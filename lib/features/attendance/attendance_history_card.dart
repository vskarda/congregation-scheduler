import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/attendance_repository.dart';
import '../../core/data/congregation_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import 'attendance_form.dart';

/// One expected or recorded meeting in the history table.
typedef _Slot = ({String date, MeetingType type, AttendanceEntry? entry});

/// Past meetings grouped by month (newest first, current month expanded):
/// every meeting expected from the congregation's configured weekdays plus
/// any recorded entry, with unrecorded past meetings shown so they can be
/// filled in. Tapping a row opens an edit dialog.
class AttendanceHistoryCard extends ConsumerWidget {
  const AttendanceHistoryCard({
    super.key,
    required this.entries,
    required this.canEdit,
    required this.fromDate,
  });

  final List<AttendanceEntry> entries;
  final bool canEdit;

  /// yyyy-MM-dd start of the history window.
  final String fromDate;

  /// Expected meetings (weekday occurrences up to today) merged with the
  /// recorded entries; entries outside the expected pattern (e.g. after a
  /// meeting-day change) are kept too.
  List<_Slot> _slots(CongregationMeta meta) {
    final byId = {
      for (final e in entries) AttendanceEntry.docId(e.date, e.meetingType): e,
    };
    final slots = <String, _Slot>{};
    final today = DateTime.now();
    var day = parseDateKey(fromDate);
    while (!day.isAfter(today)) {
      for (final type in MeetingType.values) {
        final weekday = type == MeetingType.lmm
            ? meta.lmmWeekday
            : meta.weekendWeekday;
        if (day.weekday != weekday) continue;
        final date = dateKey(day);
        final id = AttendanceEntry.docId(date, type);
        slots[id] = (date: date, type: type, entry: byId[id]);
      }
      day = DateTime(day.year, day.month, day.day + 1);
    }
    for (final MapEntry(:key, :value) in byId.entries) {
      slots.putIfAbsent(
          key, () => (date: value.date, type: value.meetingType, entry: value));
    }
    return slots.values.toList()
      ..sort((a, b) {
        final byDate = b.date.compareTo(a.date);
        if (byDate != 0) return byDate;
        return a.type.index.compareTo(b.type.index);
      });
  }

  Future<void> _edit(
      BuildContext context, WidgetRef ref, _Slot slot, String typeLabel) async {
    final l10n = context.l10n;
    final repo = ref.read(attendanceRepositoryProvider);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${slot.date}  ·  $typeLabel'),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: AttendanceForm(
              initial: slot.entry ??
                  AttendanceEntry(date: slot.date, meetingType: slot.type),
              onSubmit: (entry) async {
                await repo.upsert(entry);
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(l10n.attSaved)));
                }
              },
            ),
          ),
        ),
        actions: [
          if (slot.entry != null)
            TextButton(
              onPressed: () async {
                await repo.delete(slot.entry!.id);
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(l10n.commonDelete),
            ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.commonCancel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final monthFmt = DateFormat.yMMMM(locale);
    final meta = ref.watch(congregationMetaProvider).value ??
        const CongregationMeta();

    final byMonth =
        groupBy(_slots(meta), (_Slot s) => s.date.substring(0, 7));
    final months = byMonth.keys.toList()..sort((a, b) => b.compareTo(a));
    final currentMonth = monthKey(DateTime.now());

    String subtitleFor(AttendanceEntry e) {
      final parts = [
        if (e.inPerson != null) '${l10n.attInPerson}: ${e.inPerson}',
        if (e.online != null) '${l10n.attOnline}: ${e.online}',
      ];
      return '${l10n.attTotal}: ${e.resolvedTotal}'
          '${parts.isEmpty ? '' : '  (${parts.join(', ')})'}';
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Text(l10n.attHistory,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          for (final month in months)
            ExpansionTile(
              title: Text(monthFmt.format(parseMonthKey(month))),
              subtitle: Text(l10n.attRecordedOf(
                byMonth[month]!
                    .where((s) => s.entry?.hasData ?? false)
                    .length,
                byMonth[month]!.length,
              )),
              initiallyExpanded: month == currentMonth,
              shape: const Border(),
              children: [
                for (final slot in byMonth[month]!)
                  ListTile(
                    dense: true,
                    title: Text(
                        '${slot.date}  ·  ${slot.type == MeetingType.lmm ? l10n.attMeetingLmm : l10n.attMeetingWeekend}'),
                    subtitle: (slot.entry?.hasData ?? false)
                        ? Text(subtitleFor(slot.entry!))
                        : Text(l10n.attNotFilled,
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.outline)),
                    trailing: canEdit
                        ? const Icon(Icons.edit_outlined, size: 18)
                        : null,
                    onTap: canEdit
                        ? () => _edit(
                            context,
                            ref,
                            slot,
                            slot.type == MeetingType.lmm
                                ? l10n.attMeetingLmm
                                : l10n.attMeetingWeekend)
                        : null,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
