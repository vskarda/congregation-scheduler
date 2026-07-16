import '../../features/events/my_assignments_provider.dart';
import '../utils/dates.dart';
import 'reminder_settings_provider.dart';

/// iOS silently drops pending notification requests beyond 64; keep headroom.
const kMaxScheduledReminders = 60;

/// One notification to schedule: an [entry] reminded [offset] ahead of time,
/// firing at [fireAt] (local wall-clock). [id] is unique within one sync only
/// (see [computePlannedReminders]).
class PlannedReminder {
  const PlannedReminder({
    required this.id,
    required this.fireAt,
    required this.entry,
    required this.offset,
  });

  final int id;
  final DateTime fireAt;
  final MyAssignmentEntry entry;
  final ReminderSetting offset;
}

/// Computes the notifications to schedule for the given [assignments] and
/// reminder [reminders], relative to [now]. Pure — no plugin dependency.
///
/// For each assignment (with a known time) × each reminder offset, emits one
/// [PlannedReminder] at `assignmentStart - offset`, skipping any fire time in
/// the past (or within 30s of now). Results are sorted by fire time and capped
/// at [maxCount], keeping the soonest.
///
/// IDs are sequential indices into the sorted, capped result. This is safe
/// because the scheduler cancels all pending notifications and reschedules the
/// full set on every sync; if a second notification source is ever added,
/// switch to per-notification stable IDs instead.
List<PlannedReminder> computePlannedReminders({
  required List<MyAssignmentEntry> assignments,
  required List<ReminderSetting> reminders,
  required DateTime now,
  int maxCount = kMaxScheduledReminders,
}) {
  final cutoff = now.add(const Duration(seconds: 30));
  final planned = <_Candidate>[];

  for (final entry in assignments) {
    final time = entry.time;
    if (time == null) continue;
    final DateTime start;
    try {
      start = combineDateAndTime(parseDateKey(entry.date), time);
    } catch (_) {
      continue; // malformed date/time — skip defensively
    }
    for (final reminder in reminders) {
      final fireAt = start.subtract(reminder.duration);
      if (!fireAt.isAfter(cutoff)) continue;
      planned.add(_Candidate(fireAt: fireAt, entry: entry, offset: reminder));
    }
  }

  planned.sort((a, b) {
    final byFire = a.fireAt.compareTo(b.fireAt);
    if (byFire != 0) return byFire;
    final byDate = a.entry.date.compareTo(b.entry.date);
    if (byDate != 0) return byDate;
    return a.entry.roleKey.compareTo(b.entry.roleKey);
  });

  final capped = planned.length > maxCount
      ? planned.sublist(0, maxCount)
      : planned;

  return [
    for (var i = 0; i < capped.length; i++)
      PlannedReminder(
        id: i,
        fireAt: capped[i].fireAt,
        entry: capped[i].entry,
        offset: capped[i].offset,
      ),
  ];
}

class _Candidate {
  const _Candidate({
    required this.fireAt,
    required this.entry,
    required this.offset,
  });
  final DateTime fireAt;
  final MyAssignmentEntry entry;
  final ReminderSetting offset;
}
