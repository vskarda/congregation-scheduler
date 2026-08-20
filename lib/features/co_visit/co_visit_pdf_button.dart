import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/co_visit_repository.dart';
import '../../core/data/congregation_repository.dart';
import '../../core/data/fsm_repository.dart';
import '../../core/data/lmm_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/data/weekend_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/pdf/pdf_fonts.dart';
import '../../core/utils/dates.dart';
import '../info_board/file_opener/file_opener.dart';
import 'co_visit_item_dialog.dart';
import 'co_visit_pdf.dart';
import 'co_visit_screen.dart';

/// App-bar action for the visit's planners: prints the visit currently on
/// screen, asking first whether the sections hidden from publishers should be
/// on the sheet too. Only offered to events-admins (see [AppShell]) —
/// publishers read the visit in the app rather than printing it.
class CoVisitPdfButton extends ConsumerStatefulWidget {
  const CoVisitPdfButton({super.key});

  @override
  ConsumerState<CoVisitPdfButton> createState() => _CoVisitPdfButtonState();
}

class _CoVisitPdfButtonState extends ConsumerState<CoVisitPdfButton> {
  bool _busy = false;

  Future<bool?> _askIncludeHidden(CoVisit visit) async {
    final l10n = context.l10n;
    // Nothing is hidden — no question to ask.
    if (visit.hiddenSections.isEmpty) return false;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.coPrintTitle),
        content: Text(l10n.coPrintIncludeHiddenBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.commonCancel)),
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.coPrintVisibleOnly)),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.coPrintIncludeHidden)),
        ],
      ),
    );
  }

  Future<void> _export() async {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final messenger = ScaffoldMessenger.of(context);
    final weekId = ref.read(shownCoVisitProvider);
    if (weekId == null) return;
    final visit = ref
        .read(coVisitsProvider)
        .value
        ?.where((v) => v.id == weekId)
        .firstOrNull;
    if (visit == null) return;

    final includeHidden = await _askIncludeHidden(visit);
    if (includeHidden == null) return; // cancelled

    setState(() => _busy = true);
    try {
      // One-shot: the streaming roster only resolves while something listens
      // to it, and on this screen that is AssignmentText, which skips the
      // watch when an assignment is empty.
      final byId = await ref.read(publishersByIdOnceProvider.future);
      final meta =
          ref.read(congregationMetaProvider).value ?? const CongregationMeta();
      final monday = parseDateKey(weekId);
      final firstDay = dateKey(CoVisit.startOf(monday));
      final lastDay = dateKey(CoVisit.endOf(monday));
      final ministry = (await ref
              .read(fsmRepositoryProvider)
              .expandRange(firstDay, lastDay))
          .toList();
      final lmmWeek =
          (await ref.read(lmmRepositoryProvider).getRange(weekId, weekId))
              .firstOrNull;
      final weekendWeek =
          (await ref.read(weekendRepositoryProvider).getRange(weekId, weekId))
              .firstOrNull;

      final bytes = await buildCoVisitPdf(
        weekId: weekId,
        visit: visit,
        ministryMeetings: ministry,
        publishersById: byId,
        congregationName: meta.name,
        midweekWeekday: lmmWeek?.weekdayOr(meta.lmmWeekday) ?? meta.lmmWeekday,
        midweekTime: lmmWeek?.timeOr(meta.lmmTime) ?? meta.lmmTime,
        weekendWeekday:
            weekendWeek?.weekdayOr(meta.weekendWeekday) ?? meta.weekendWeekday,
        weekendTime: weekendWeek?.timeOr(meta.weekendTime) ?? meta.weekendTime,
        includeHidden: includeHidden,
        sectionLabel: (s) => coSectionLabel(l10n, s),
        l10n: l10n,
        locale: locale,
        fonts: await loadPdfFonts(),
      );
      await openFileBytes(
        bytes: bytes,
        name: 'CO_Visit_$weekId.pdf',
        mimeType: 'application/pdf',
      );
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(l10n.commonErrorDetail(e.toString()))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(shownCoVisitProvider) == null) {
      return const SizedBox.shrink();
    }
    return IconButton(
      tooltip: context.l10n.coPrintTitle,
      onPressed: _busy ? null : _export,
      icon: _busy
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.picture_as_pdf_outlined),
    );
  }
}
