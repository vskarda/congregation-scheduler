import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/data/reports_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import 'report_form.dart';

/// Admin overview of one month's reports with paper-report entry.
class AdminReportsScreen extends ConsumerStatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  ConsumerState<AdminReportsScreen> createState() =>
      _AdminReportsScreenState();
}

class _AdminReportsScreenState extends ConsumerState<AdminReportsScreen> {
  late String _month = monthKey(addMonths(DateTime.now(), -1));

  Future<void> _enterFor(Publisher publisher, MinistryReport? existing) async {
    final l10n = context.l10n;
    final adminUid = ref.read(currentUidProvider) ?? 'admin';
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.reportEnterFor(publisher.fullName)),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: ReportForm(
              initial: existing ??
                  MinistryReport(
                      publisherId: publisher.id,
                      month: _month,
                      statusAtMonth: publisher.status),
              isPioneer: true,
              submitLabel: l10n.commonSave,
              onSubmit: (report) async {
                await ref.read(reportsRepositoryProvider).submit(
                      report.copyWith(
                        publisherId: publisher.id,
                        month: _month,
                        statusAtMonth:
                            existing?.statusAtMonth ?? publisher.status,
                        submittedAt: DateTime.now(),
                        enteredBy:
                            existing?.enteredBy == 'self' ? 'self' : adminUid,
                      ),
                    );
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final publishers = ref.watch(allPublishersProvider).value ?? const [];
    final reportsAsync = ref.watch(monthReportsProvider(_month));
    final locale = Localizations.localeOf(context).toString();
    final monthFmt = DateFormat.yMMMM(locale);

    return reportsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l10n.commonErrorDetail(e.toString()))),
      data: (reports) {
        final byId = {for (final r in reports) r.publisherId: r};
        final reported =
            publishers.where((p) => byId.containsKey(p.id)).length;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => setState(() =>
                        _month = monthKey(
                            addMonths(parseMonthKey(_month), -1))),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(monthFmt.format(parseMonthKey(_month)),
                            style:
                                Theme.of(context).textTheme.titleMedium),
                        Text(
                          l10n.reportSummaryReported(
                              reported, publishers.length),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => setState(() =>
                        _month = monthKey(
                            addMonths(parseMonthKey(_month), 1))),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: publishers.length,
                itemBuilder: (context, i) {
                  final p = publishers[i];
                  final report = byId[p.id];
                  final summary = report == null
                      ? null
                      : [
                          if (report.participated) '✓',
                          if (report.bibleStudies != null)
                            '${l10n.reportStudies}: ${report.bibleStudies}',
                          if (report.hours != null)
                            '${l10n.reportHours}: ${report.hours}',
                          if (report.creditHours != null)
                            '${l10n.reportCredit}: ${report.creditHours}',
                          if (report.comments.isNotEmpty) report.comments,
                        ].join('  ·  ');
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      report == null
                          ? Icons.radio_button_unchecked
                          : Icons.check_circle,
                      color: report == null
                          ? Theme.of(context).disabledColor
                          : Colors.green,
                      size: 20,
                    ),
                    title: Text(p.listName),
                    subtitle: summary == null
                        ? Text(l10n.reportMissing,
                            style: TextStyle(
                                color: Theme.of(context).disabledColor))
                        : Text(summary),
                    onTap: () => _enterFor(p, report),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
