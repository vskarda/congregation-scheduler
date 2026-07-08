import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/data/reports_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import 'report_form.dart';

/// Publisher's own ministry report submission.
class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  // Reports are usually submitted for the previous month.
  late String _month = monthKey(addMonths(DateTime.now(), -1));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final me = ref.watch(myPublisherProvider).value;
    if (me == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final reportAsync = ref.watch(myReportProvider(_month));
    final locale = Localizations.localeOf(context).toString();
    final monthFmt = DateFormat.yMMMM(locale);
    final months = [
      for (var i = 0; i < 12; i++) monthKey(addMonths(DateTime.now(), -i)),
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              initialValue: _month,
              decoration: InputDecoration(labelText: l10n.reportMonth),
              items: [
                for (final m in months)
                  DropdownMenuItem(
                      value: m,
                      child: Text(monthFmt.format(parseMonthKey(m)))),
              ],
              onChanged: (m) => setState(() => _month = m ?? _month),
            ),
            const SizedBox(height: 16),
            reportAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Text(l10n.commonErrorDetail(e.toString())),
              data: (existing) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (existing?.submittedAt != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        l10n.reportSubmittedAt(DateFormat.yMMMd(locale)
                            .format(existing!.submittedAt!)),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ReportForm(
                    key: ValueKey('$_month-${existing?.submittedAt}'),
                    initial: existing ??
                        MinistryReport(
                            publisherId: me.id,
                            month: _month,
                            statusAtMonth: me.status),
                    isPioneer: me.isPioneer,
                    onSubmit: (report) async {
                      await ref.read(reportsRepositoryProvider).submit(
                            report.copyWith(
                              publisherId: me.id,
                              month: _month,
                              statusAtMonth:
                                  existing?.statusAtMonth ?? me.status,
                              submittedAt: DateTime.now(),
                              enteredBy: 'self',
                            ),
                          );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.reportSaved)));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
