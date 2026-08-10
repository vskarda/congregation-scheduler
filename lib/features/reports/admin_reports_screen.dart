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

  Future<void> _enterFor(Publisher publisher, MinistryReport? existing,
      {required bool sharedLastMonth}) async {
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
              // The admin gets the whole status list rather than the aux tick:
              // it covers the aux month the tick covered, and it is the only
              // place a snapshot taken under a wrong standing status can be
              // put right afterwards.
              showStatusPicker: true,
              sharedLastMonth: sharedLastMonth,
              submitLabel: l10n.commonSave,
              onSubmit: (report) async {
                // statusAtMonth (aux tick) is owned by the form.
                await ref.read(reportsRepositoryProvider).submit(
                      report.copyWith(
                        publisherId: publisher.id,
                        month: _month,
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
    final all = ref.watch(allPublishersProvider).value ?? const <Publisher>[];
    final roster =
        all.where((p) => p.status != PublisherStatus.none).toList();
    final former =
        ref.watch(formerPublishersProvider).value ?? const <FormerPublisher>[];
    final reportsAsync = ref.watch(monthReportsProvider(_month));
    // Who was out in the ministry the month before — the form questions a
    // report that files one of them as having done nothing this month.
    final sharedLastMonth = {
      for (final r in ref
              .watch(monthReportsProvider(
                  monthKey(addMonths(parseMonthKey(_month), -1))))
              .value ??
          const <MinistryReport>[])
        if (r.sharedInMinistry) r.publisherId,
    };
    final locale = Localizations.localeOf(context).toString();
    final monthFmt = DateFormat.yMMMM(locale);

    return reportsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l10n.commonErrorDetail(e.toString()))),
      data: (reports) {
        final byId = {for (final r in reports) r.publisherId: r};
        // A publisher who moved away belongs to the months before the move
        // and to no later one — so past months stay complete and enterable
        // while they stop being missing from every month after.
        final expected =
            roster.where((p) => p.onRosterInMonth(_month)).toList();
        // An entry filed for a month they had already left still shows (it
        // happened, and a mistake must stay correctable), marked as counting
        // for nobody — otherwise this list and the S-1 would disagree.
        // Entries whose publisher record is gone altogether. They go on
        // counting on the S-1 unless a recorded departure says otherwise, so
        // they belong on this list too — nameless, out of the "reported" tally
        // (nobody is waiting for them), and still openable, because a wrong
        // figure has to stay correctable after the person has left.
        final knownIds = {for (final p in all) p.id};
        final formerById = {for (final f in former) f.id: f};
        final orphans = [
          for (final r in reports)
            if (!knownIds.contains(r.publisherId))
              Publisher(
                id: r.publisherId,
                firstName: l10n.reportFormerMember,
                moved: formerById.containsKey(r.publisherId),
                movedDate: formerById[r.publisherId]?.movedDate,
              ),
        ];
        final publishers = [
          ...expected,
          ...roster.where(
              (p) => !p.onRosterInMonth(_month) && byId.containsKey(p.id)),
          ...orphans,
        ];
        final reported =
            expected.where((p) => byId.containsKey(p.id)).length;
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
                              reported, expected.length),
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
                  final counts = p.onRosterInMonth(_month);
                  final summary = report == null
                      ? null
                      : [
                          if (report.participated) '✓',
                          if (report.statusAtMonth ==
                              PublisherStatus.auxiliaryPioneer)
                            l10n.statusAuxPioneer,
                          if (report.bibleStudies != null)
                            '${l10n.reportStudies}: ${report.bibleStudies}',
                          if (report.hours != null)
                            '${l10n.reportHours}: ${report.hours}',
                          if (report.creditHours != null)
                            '${l10n.reportCredit}: ${report.creditHours}',
                          if (report.comments.isNotEmpty) report.comments,
                        ].join('  ·  ');
                  // Three states: no report (grey ring), a report where the
                  // publisher shared in the ministry (green tick), or an empty
                  // report — nothing but maybe a note/credit hours (red cross).
                  // A report that counts for nobody gets neither: it says
                  // nothing about this month's ministry.
                  final (icon, iconColor) = !counts
                      ? (Icons.local_shipping_outlined,
                          Theme.of(context).disabledColor)
                      : report == null
                          ? (Icons.radio_button_unchecked,
                              Theme.of(context).disabledColor)
                          : report.sharedInMinistry
                              ? (Icons.check_circle, Colors.green)
                              : (Icons.cancel,
                                  Theme.of(context).colorScheme.error);
                  return ListTile(
                    dense: true,
                    leading: Icon(icon, color: iconColor, size: 20),
                    title: Text(p.listName),
                    subtitle: summary == null
                        ? Text(l10n.reportMissing,
                            style: TextStyle(
                                color: Theme.of(context).disabledColor))
                        : Text(counts
                            ? summary
                            : '${l10n.reportNotCountedMoved}  ·  $summary'),
                    onTap: () => _enterFor(p, report,
                        sharedLastMonth: sharedLastMonth.contains(p.id)),
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
