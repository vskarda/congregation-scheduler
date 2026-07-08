import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/attendance_repository.dart';
import '../../core/data/reports_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import 's1_calculator.dart';

final s1ResultProvider =
    FutureProvider.family<S1Result, String>((ref, month) async {
  final reportsRepo = ref.watch(reportsRepositoryProvider);
  final monthDate = parseMonthKey(month);

  final lastSix = <List<MinistryReport>>[];
  for (var i = 0; i < 6; i++) {
    lastSix.add(
        await reportsRepo.getMonth(monthKey(addMonths(monthDate, -i))));
  }
  final attendance = await ref.watch(attendanceRepositoryProvider).getRange(
        '$month-01',
        '$month-31',
      );
  return computeS1(
    monthReports: lastSix.first,
    lastSixMonths: lastSix,
    monthAttendance: attendance,
  );
});

class S1Screen extends ConsumerStatefulWidget {
  const S1Screen({super.key});

  @override
  ConsumerState<S1Screen> createState() => _S1ScreenState();
}

class _S1ScreenState extends ConsumerState<S1Screen> {
  late String _month = monthKey(addMonths(DateTime.now(), -1));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final resultAsync = ref.watch(s1ResultProvider(_month));
    final locale = Localizations.localeOf(context).toString();
    final monthFmt = DateFormat.yMMMM(locale);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => setState(() => _month =
                      monthKey(addMonths(parseMonthKey(_month), -1))),
                ),
                Expanded(
                  child: Text(
                    monthFmt.format(parseMonthKey(_month)),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => setState(() => _month =
                      monthKey(addMonths(parseMonthKey(_month), 1))),
                ),
              ],
            ),
            resultAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) =>
                  Text(l10n.commonErrorDetail(e.toString())),
              data: (result) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ValueTile(
                      label: l10n.s1Active,
                      value: result.activePublishers.toString()),
                  _ValueTile(
                      label: l10n.s1AvgMid,
                      value:
                          result.avgMidweekAttendance?.toString() ?? '—'),
                  _ValueTile(
                      label: l10n.s1AvgWeekend,
                      value:
                          result.avgWeekendAttendance?.toString() ?? '—'),
                  _GroupCard(
                    title: l10n.s1Publishers,
                    group: result.publishers,
                    showHours: false,
                  ),
                  _GroupCard(
                    title: l10n.s1AuxPioneers,
                    group: result.auxiliaryPioneers,
                    showHours: true,
                  ),
                  _GroupCard(
                    title: l10n.s1RegPioneers,
                    group: result.regularPioneers,
                    showHours: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(l10n.s1Note,
                        style: Theme.of(context).textTheme.bodySmall),
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

class _ValueTile extends StatelessWidget {
  const _ValueTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(value,
            style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard(
      {required this.title, required this.group, required this.showHours});

  final String title;
  final S1Group group;
  final bool showHours;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget stat(String label, int value) => Expanded(
          child: Column(
            children: [
              Text(value.toString(),
                  style: Theme.of(context).textTheme.headlineSmall),
              Text(label,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center),
            ],
          ),
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                stat(l10n.s1Count, group.count),
                if (showHours) stat(l10n.s1Hours, group.hours),
                stat(l10n.s1Studies, group.studies),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
