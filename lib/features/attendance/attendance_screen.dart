import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/attendance_repository.dart';
import '../../core/data/congregation_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import 'attendance_form.dart';
import 'attendance_history_card.dart';

/// Most recent occurrence (<= today) of a weekly meeting held on [weekday].
DateTime lastOccurrence(int weekday, DateTime today) {
  final diff = (today.weekday - weekday) % 7;
  final day = DateTime(today.year, today.month, today.day);
  return day.subtract(Duration(days: diff));
}

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final canEdit = ref.watch(effectiveRolesProvider).canEditAttendance();
    final entriesAsync = ref.watch(attendanceEntriesProvider);

    return entriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l10n.commonErrorDetail(e.toString()))),
      data: (entries) => ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (canEdit) _AddAttendanceCard(entries: entries),
          _OverviewCard(entries: entries),
          AttendanceHistoryCard(
            entries: entries,
            canEdit: canEdit,
            fromDate: attendanceHistoryStart(),
          ),
        ],
      ),
    );
  }
}

class _AddAttendanceCard extends ConsumerStatefulWidget {
  const _AddAttendanceCard({required this.entries});

  final List<AttendanceEntry> entries;

  @override
  ConsumerState<_AddAttendanceCard> createState() =>
      _AddAttendanceCardState();
}

class _AddAttendanceCardState extends ConsumerState<_AddAttendanceCard> {
  MeetingType? _type;
  String? _date;

  /// Preselect the meeting closest to today ("present meeting").
  (MeetingType, String) _presentMeeting(CongregationMeta meta) {
    final today = DateTime.now();
    final lmm = lastOccurrence(meta.lmmWeekday, today);
    final weekend = lastOccurrence(meta.weekendWeekday, today);
    return lmm.isAfter(weekend)
        ? (MeetingType.lmm, dateKey(lmm))
        : (MeetingType.weekend, dateKey(weekend));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final meta = ref.watch(congregationMetaProvider).value ??
        const CongregationMeta();
    final (presetType, presetDate) = _presentMeeting(meta);
    final type = _type ?? presetType;
    final date = _date ?? presetDate;

    // Prefill with the stored entry when one exists for this meeting.
    final existing = widget.entries
        .where((e) => e.date == date && e.meetingType == type)
        .firstOrNull;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.attAdd,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<MeetingType>(
              segments: [
                ButtonSegment(
                    value: MeetingType.lmm,
                    label: Text(l10n.attMeetingLmm)),
                ButtonSegment(
                    value: MeetingType.weekend,
                    label: Text(l10n.attMeetingWeekend)),
              ],
              selected: {type},
              onSelectionChanged: (s) => setState(() {
                _type = s.first;
                _date = dateKey(lastOccurrence(
                    s.first == MeetingType.lmm
                        ? meta.lmmWeekday
                        : meta.weekendWeekday,
                    DateTime.now()));
              }),
            ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.pwDate),
              subtitle: Text(date),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: parseDateKey(date),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 7)),
                );
                if (picked != null) {
                  setState(() => _date = dateKey(picked));
                }
              },
            ),
            // Keyed so switching meeting resets (and prefills) the counts.
            AttendanceForm(
              key: ValueKey('$date|${type.name}'),
              initial: existing ??
                  AttendanceEntry(date: date, meetingType: type),
              onSubmit: (entry) async {
                await ref.read(attendanceRepositoryProvider).upsert(entry);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.attSaved)));
                }
              },
            ),
          ],
        ),
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

    // month -> type -> totals (in-person + online always combined).
    final byMonth = <String, Map<MeetingType, List<int>>>{};
    for (final e in entries) {
      if (e.date.length < 7 || !e.hasData) continue;
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
      if (totals == null || totals.isEmpty) return '—';
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

