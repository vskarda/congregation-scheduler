import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/congregation_repository.dart';
import '../../core/data/lmm_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/data/weekend_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/pdf/pdf_fonts.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/week_navigator.dart';
import '../info_board/file_opener/file_opener.dart';
import '../lmm_schedule/lmm_month_pdf.dart';
import '../weekend_schedule/weekend_month_pdf.dart';

enum SchedulePdfKind { lmm, weekend }

/// App-bar action for schedule admins: exports the month of the currently
/// viewed week as a PDF overview.
class SchedulePdfButton extends ConsumerStatefulWidget {
  const SchedulePdfButton({super.key, required this.kind});

  final SchedulePdfKind kind;

  @override
  ConsumerState<SchedulePdfButton> createState() => _SchedulePdfButtonState();
}

class _SchedulePdfButtonState extends ConsumerState<SchedulePdfButton> {
  bool _busy = false;

  Future<void> _export() async {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final monday = ref.read(viewedWeekProvider);
      final month = DateTime(monday.year, monday.month, 1);
      final mondays = mondaysInMonth(month);

      // Ensure the publishers stream has produced a value before reading the
      // derived id->publisher map (it is empty on a cold start).
      await ref.read(allPublishersProvider.future);
      final byId = ref.read(publishersByIdProvider);
      final fonts = await loadPdfFonts();

      final bytes = switch (widget.kind) {
        SchedulePdfKind.lmm => await buildLmmMonthPdf(
            month: month,
            mondays: mondays,
            weeksById: {
              for (final w in await ref
                  .read(lmmRepositoryProvider)
                  .getRange(dateKey(mondays.first), dateKey(mondays.last)))
                w.id: w,
            },
            publishersById: byId,
            classCount:
                ((await ref.read(congregationMetaProvider.future))
                            ?.lmmClassCount ??
                        1)
                    .clamp(1, 3),
            l10n: l10n,
            locale: locale,
            fonts: fonts,
          ),
        SchedulePdfKind.weekend => await buildWeekendMonthPdf(
            month: month,
            mondays: mondays,
            weeksById: {
              for (final w in await ref
                  .read(weekendRepositoryProvider)
                  .getRange(dateKey(mondays.first), dateKey(mondays.last)))
                w.id: w,
            },
            publishersById: byId,
            l10n: l10n,
            locale: locale,
            fonts: fonts,
          ),
      };

      final prefix = widget.kind == SchedulePdfKind.lmm ? 'LMM' : 'Weekend';
      await openFileBytes(
        bytes: bytes,
        name: '${prefix}_${monthKey(month)}.pdf',
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
    return IconButton(
      tooltip: context.l10n.schedulePdfExport,
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
