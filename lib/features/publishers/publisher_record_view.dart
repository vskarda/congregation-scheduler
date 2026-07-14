import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/pdf/pdf_fonts.dart';
import '../../core/utils/dates.dart';
import '../info_board/file_opener/file_opener.dart';
import 'publishers_providers.dart';
import 's21/s21_import_screen.dart';
import 's21/s21_pdf.dart';

/// Ministry reports of one publisher grouped by service year (Sep–Aug).
class PublisherRecordView extends ConsumerStatefulWidget {
  const PublisherRecordView({
    super.key,
    required this.publisherId,
    this.showS21Export = false,
  });

  final String publisherId;

  /// Admin-only: reading another publisher's private data and reports
  /// requires the publishers + reports roles.
  final bool showS21Export;

  @override
  ConsumerState<PublisherRecordView> createState() =>
      _PublisherRecordViewState();
}

class _PublisherRecordViewState extends ConsumerState<PublisherRecordView> {
  late int _year = serviceYearOf(DateTime.now());
  bool _exporting = false;

  Future<void> _exportS21() async {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _exporting = true);
    try {
      final publisher =
          await ref.read(publisherProvider(widget.publisherId).future);
      if (publisher == null) throw StateError('publisher not found');
      final private =
          await ref.read(publisherPrivateProvider(widget.publisherId).future);
      final reports = await ref.read(serviceYearReportsProvider(
          (publisherId: widget.publisherId, year: _year)).future);
      final bytes = await buildS21Pdf(
        publisher: publisher,
        private: private,
        serviceYear: _year,
        reportsByMonth: reports,
        l10n: l10n,
        locale: locale,
        fonts: await loadPdfFonts(),
      );
      await openFileBytes(
        bytes: bytes,
        name: 'S-21_${publisher.lastName}_${publisher.firstName}_$_year.pdf'
            .replaceAll(' ', '_'),
        mimeType: 'application/pdf',
      );
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(l10n.commonErrorDetail(e.toString()))));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentYear = serviceYearOf(DateTime.now());
    final reports = ref.watch(serviceYearReportsProvider(
        (publisherId: widget.publisherId, year: _year)));
    // Importing writes profile fields and reports, so both roles are needed.
    final roles = ref.watch(myRolesProvider);
    final canImport = widget.showS21Export &&
        roles.canEditPublishers() &&
        roles.canEditReports();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.profileRecord,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            if (canImport)
              IconButton(
                tooltip: l10n.s21Import,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        S21ImportScreen(publisherId: widget.publisherId),
                  ),
                ),
                icon: const Icon(Icons.upload_file_outlined),
              ),
            if (widget.showS21Export)
              IconButton(
                tooltip: l10n.s21Export,
                onPressed: _exporting ? null : _exportS21,
                icon: _exporting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.picture_as_pdf_outlined),
              ),
            DropdownButton<int>(
              value: _year,
              items: [
                for (var y = currentYear; y > currentYear - 4; y--)
                  DropdownMenuItem(value: y, child: Text(l10n.serviceYear(y))),
              ],
              onChanged: (y) => setState(() => _year = y ?? currentYear),
            ),
          ],
        ),
        const SizedBox(height: 8),
        reports.when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text(l10n.commonErrorDetail(e.toString())),
          data: (byMonth) {
            final locale = Localizations.localeOf(context).toString();
            final monthFmt = DateFormat.yMMM(locale);
            return Card(
              margin: EdgeInsets.zero,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 24,
                  columns: [
                    DataColumn(label: Text(l10n.reportMonth)),
                    DataColumn(label: Text(l10n.reportParticipated)),
                    DataColumn(label: Text(l10n.reportStudies)),
                    DataColumn(label: Text(l10n.reportHours)),
                    DataColumn(label: Text(l10n.reportCredit)),
                    DataColumn(label: Text(l10n.reportComments)),
                  ],
                  rows: [
                    for (final month in serviceYearMonths(_year))
                      DataRow(cells: [
                        DataCell(
                            Text(monthFmt.format(parseMonthKey(month)))),
                        DataCell(byMonth[month] == null
                            ? const Text('—')
                            : Icon(
                                byMonth[month]!.participated
                                    ? Icons.check
                                    : Icons.close,
                                size: 18,
                              )),
                        DataCell(Text(
                            byMonth[month]?.bibleStudies?.toString() ?? '')),
                        DataCell(
                            Text(byMonth[month]?.hours?.toString() ?? '')),
                        DataCell(Text(
                            byMonth[month]?.creditHours?.toString() ?? '')),
                        DataCell(Text(byMonth[month]?.comments ?? '')),
                      ]),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
