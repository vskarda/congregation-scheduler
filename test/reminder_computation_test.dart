import 'package:congregation_scheduler/core/notifications/reminder_computation.dart';
import 'package:congregation_scheduler/core/notifications/reminder_settings_provider.dart';
import 'package:congregation_scheduler/features/events/my_assignments_provider.dart';
import 'package:flutter_test/flutter_test.dart';

MyAssignmentEntry entry(String date, {String? time = '18:30', String? end}) =>
    MyAssignmentEntry(
      source: AssignmentSource.lmm,
      date: date,
      roleKey: 'bibleReading',
      time: time,
      endTime: end,
    );

void main() {
  final now = DateTime(2026, 7, 16, 12, 0);

  test('emits one reminder per assignment × offset', () {
    final result = computePlannedReminders(
      assignments: [entry('2026-07-20'), entry('2026-07-21')],
      reminders: const [
        ReminderSetting(value: 1, unit: ReminderUnit.days),
        ReminderSetting(value: 2, unit: ReminderUnit.hours),
      ],
      now: now,
    );
    expect(result.length, 4);
  });

  test('computes fire time as start minus offset for each unit', () {
    final result = computePlannedReminders(
      assignments: [entry('2026-07-20', time: '18:30')],
      reminders: const [
        ReminderSetting(value: 90, unit: ReminderUnit.minutes),
        ReminderSetting(value: 3, unit: ReminderUnit.hours),
        ReminderSetting(value: 2, unit: ReminderUnit.days),
      ],
      now: now,
    );
    final byFire = {
      for (final p in result) p.offset.unit: p.fireAt,
    };
    expect(byFire[ReminderUnit.minutes], DateTime(2026, 7, 20, 17, 0));
    expect(byFire[ReminderUnit.hours], DateTime(2026, 7, 20, 15, 30));
    expect(byFire[ReminderUnit.days], DateTime(2026, 7, 18, 18, 30));
  });

  test('skips fire times in the past or within 30s of now', () {
    final result = computePlannedReminders(
      // Assignment today at 12:30 with a 1-hour offset -> fire 11:30 (past).
      assignments: [entry('2026-07-16', time: '12:30')],
      reminders: const [ReminderSetting(value: 1, unit: ReminderUnit.hours)],
      now: now,
    );
    expect(result, isEmpty);
  });

  test('skips assignments with no known time', () {
    final result = computePlannedReminders(
      assignments: [entry('2026-07-20', time: null)],
      reminders: const [ReminderSetting(value: 1, unit: ReminderUnit.days)],
      now: now,
    );
    expect(result, isEmpty);
  });

  test('sorts by fire time and assigns sequential ids from 0', () {
    final result = computePlannedReminders(
      assignments: [entry('2026-07-25'), entry('2026-07-20')],
      reminders: const [ReminderSetting(value: 1, unit: ReminderUnit.days)],
      now: now,
    );
    expect(result.map((p) => p.id).toList(), [0, 1]);
    expect(result[0].fireAt.isBefore(result[1].fireAt), isTrue);
    expect(result[0].entry.date, '2026-07-20');
  });

  test('caps at maxCount keeping the soonest', () {
    final assignments = [
      for (var d = 20; d <= 28; d++) entry('2026-07-$d'),
    ];
    final result = computePlannedReminders(
      assignments: assignments,
      reminders: const [ReminderSetting(value: 1, unit: ReminderUnit.days)],
      now: now,
      maxCount: 3,
    );
    expect(result.length, 3);
    expect(result.first.entry.date, '2026-07-20');
    expect(result.last.entry.date, '2026-07-22');
  });

  test('handles day offsets across a month boundary', () {
    final result = computePlannedReminders(
      assignments: [entry('2026-08-02', time: '10:00')],
      reminders: const [ReminderSetting(value: 6, unit: ReminderUnit.days)],
      now: now,
    );
    expect(result.single.fireAt, DateTime(2026, 7, 27, 10, 0));
  });
}
