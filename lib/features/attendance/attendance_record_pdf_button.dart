import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/attendance_repository.dart';
import '../../core/data/congregation_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/pdf/pdf_fonts.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/service_year_picker_dialog.dart';
import '../info_board/file_opener/file_opener.dart';
import 'attendance_record_pdf.dart';

/// The sheet prints two service years side by side, the picked one and the
/// one before it — as the official form does.
List<int> _yearsFor(int picked) => [picked - 1, picked];

/// App-bar action for attendance admins: exports the congregation meeting
/// attendance record as a PDF.
class AttendanceRecordPdfButton extends ConsumerStatefulWidget {
  const AttendanceRecordPdfButton({super.key});

  @override
  ConsumerState<AttendanceRecordPdfButton> createState() =>
      _AttendanceRecordPdfButtonState();
}

class _AttendanceRecordPdfButtonState
    extends ConsumerState<AttendanceRecordPdfButton> {
  bool _busy = false;

  Future<void> _export() async {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final messenger = ScaffoldMessenger.of(context);
    final congregationName =
        ref.read(congregationMetaProvider).value?.name ?? '';

    final picked = await showServiceYearPicker(
      context,
      title: l10n.attRecordDialogTitle,
      initialYear: serviceYearOf(DateTime.now()),
      subtitle: (year) => l10n.attRecordCovers(
        _yearsFor(year).map(l10n.serviceYear).join(' · '),
      ),
    );
    if (picked == null || !mounted) return;
    final years = _yearsFor(picked);

    setState(() => _busy = true);
    try {
      // A one-shot read of exactly the years printed: the streaming provider
      // behind the screen only covers a rolling 24-month window, and a past
      // service year falls outside it.
      final entries = await ref
          .read(attendanceRepositoryProvider)
          .getRange('${years.first - 1}-09-01', '${years.last}-08-31');
      final bytes = await buildAttendanceRecordPdf(
        entries: entries,
        serviceYears: years,
        l10n: l10n,
        locale: locale,
        fonts: await loadPdfFonts(),
      );
      final fileName = [
        'Attendance',
        if (congregationName.isNotEmpty) congregationName,
        '${years.first}-${years.last}',
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
      tooltip: context.l10n.attRecordExport,
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
