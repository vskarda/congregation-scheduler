import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/attendance_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import 'attendance_history_card.dart';

/// Monthly averages and the past-meetings history — the full attendance
/// right only. Recording a meeting's counts happens in the midweek and
/// weekend meeting views (meeting_attendance_card.dart), where the date comes
/// from the schedule being shown.
class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final canEditFull = ref.watch(effectiveRolesProvider).canEditAttendance();
    final entriesAsync = ref.watch(attendanceEntriesProvider);

    return entriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l10n.commonErrorDetail(e.toString()))),
      data: (entries) => ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (canEditFull) _OverviewCard(entries: entries),
          if (canEditFull)
            AttendanceHistoryCard(
              entries: entries,
              canEdit: canEditFull,
              fromDate: attendanceHistoryStart(),
            ),
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.entries});

  final List<AttendanceEntry> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final monthFmt = DateFormat.yMMM(locale);

    // month -> type -> totals (in-person + online always combined). Only the
    // two congregation meetings: a Memorial is recorded in the same
    // collection but is not averaged with them, and a month holding nothing
    // else must not appear here as an empty row.
    final byMonth = <String, Map<MeetingType, List<int>>>{};
    for (final e in entries) {
      if (e.date.length < 7 || !e.hasData) continue;
      if (!kCountedMeetingTypes.contains(e.meetingType)) continue;
      final month = e.date.substring(0, 7);
      byMonth
          .putIfAbsent(month, () => {})
          .putIfAbsent(e.meetingType, () => [])
          .add(e.resolvedTotal);
    }
    // The provider spans 24 months for the history card; keep the averages
    // table at the last 12.
    final months = byMonth.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    final shownMonths = months.take(12).toList();

    String avg(String month, MeetingType type) {
      final totals = byMonth[month]?[type];
      if (totals == null || totals.isEmpty) return 'â€”';
      return (totals.reduce((a, b) => a + b) / totals.length)
          .round()
          .toString();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.attOverview,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(children: [
                  Text(l10n.reportMonth,
                      style: Theme.of(context).textTheme.labelMedium),
                  Text(l10n.attMeetingLmm,
                      style: Theme.of(context).textTheme.labelMedium),
                  Text(l10n.attMeetingWeekend,
                      style: Theme.of(context).textTheme.labelMedium),
                ]),
                for (final month in shownMonths)
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child:
                          Text(monthFmt.format(parseMonthKey(month))),
                    ),
                    Text(avg(month, MeetingType.lmm)),
                    Text(avg(month, MeetingType.weekend)),
                  ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

