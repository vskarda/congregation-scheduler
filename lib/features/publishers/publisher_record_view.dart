import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/l10n/l10n.dart';
import '../../core/utils/dates.dart';
import 'publishers_providers.dart';

/// Ministry reports of one publisher grouped by service year (Sep–Aug).
class PublisherRecordView extends ConsumerStatefulWidget {
  const PublisherRecordView({super.key, required this.publisherId});

  final String publisherId;

  @override
  ConsumerState<PublisherRecordView> createState() =>
      _PublisherRecordViewState();
}

class _PublisherRecordViewState extends ConsumerState<PublisherRecordView> {
  late int _year = serviceYearOf(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentYear = serviceYearOf(DateTime.now());
    final reports = ref.watch(serviceYearReportsProvider(
        (publisherId: widget.publisherId, year: _year)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.profileRecord,
                  style: Theme.of(context).textTheme.titleMedium),
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
