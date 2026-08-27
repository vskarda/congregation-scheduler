import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/congregation_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/data/territories_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/pdf/pdf_fonts.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/service_year_picker_dialog.dart';
import '../info_board/file_opener/file_opener.dart';
import 'territory_record_pdf.dart';

/// App-bar action for territory admins: exports one service year's territory
/// assignment record as a PDF.
class TerritoryRecordPdfButton extends ConsumerStatefulWidget {
  const TerritoryRecordPdfButton({super.key});

  @override
  ConsumerState<TerritoryRecordPdfButton> createState() =>
      _TerritoryRecordPdfButtonState();
}

class _TerritoryRecordPdfButtonState
    extends ConsumerState<TerritoryRecordPdfButton> {
  bool _busy = false;

  Future<void> _export() async {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final messenger = ScaffoldMessenger.of(context);
    final congregationName =
        ref.read(congregationMetaProvider).value?.name ?? '';

    final year = await showServiceYearPicker(
      context,
      title: l10n.terrRecordDialogTitle,
      initialYear: serviceYearOf(DateTime.now()),
    );
    if (year == null || !mounted) return;

    setState(() => _busy = true);
    try {
      // One-shot reads throughout: this button must not depend on which
      // providers the screen underneath happens to be listening to, and the
      // sheet covers years far outside any window the screen streams.
      final repo = ref.read(territoriesRepositoryProvider);
      final bytes = await buildTerritoryRecordPdf(
        territories: await repo.getAll(),
        assignments: await repo.getAllAssignments(),
        publishersById: await ref.read(publishersByIdOnceProvider.future),
        serviceYear: year,
        l10n: l10n,
        locale: locale,
        fonts: await loadPdfFonts(),
      );
      final fileName = [
        'Territories',
        if (congregationName.isNotEmpty) congregationName,
        '$year',
      ].join('_').replaceAll(' ', '_');
      await openFileBytes(
        bytes: bytes,
        name: '$fileName.pdf',
        mimeType: 'application/pdf',
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.commonErrorDetail(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.terrRecordExport,
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
