import 'package:congregation_scheduler/core/data/lmm_repository.dart';
import 'package:congregation_scheduler/core/data/weekend_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/lmm_schedule/epub_import/week_merge.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

/// One week's meeting can be held on another day than the congregation's
/// regular one — a circuit overseer's visit moves the midweek meeting to
/// Tuesday. The override lives on the week document; everything that computes
/// a meeting date has to consult it.
void main() {
  const meta = CongregationMeta(
    lmmWeekday: DateTime.wednesday,
    lmmTime: '18:30',
    weekendWeekday: DateTime.sunday,
    weekendTime: '10:00',
  );

  group('LmmWeek', () {
    test('follows the congregation setting when it has no override', () {
      const week = LmmWeek(id: '2026-04-13');
      expect(week.weekdayOr(meta.lmmWeekday), DateTime.wednesday);
      expect(week.timeOr(meta.lmmTime), '18:30');
      expect(week.hasMeetingOverride, isFalse);
    });

    test('prefers its own day and time when it has them', () {
      const week = LmmWeek(
          id: '2026-04-13',
          meetingWeekday: DateTime.tuesday,
          meetingTime: '19:00');
      expect(week.weekdayOr(meta.lmmWeekday), DateTime.tuesday);
      expect(week.timeOr(meta.lmmTime), '19:00');
      expect(week.hasMeetingOverride, isTrue);
    });

    test('keeps the keys out of the document when there is no override', () {
      expect(const LmmWeek(id: '2026-04-13').toJson(),
          isNot(contains('meetingWeekday')));
      expect(
          const LmmWeek(id: '2026-04-13', meetingWeekday: DateTime.tuesday)
              .toJson()['meetingWeekday'],
          DateTime.tuesday);
    });

    test('clearing the override removes the keys again', () {
      const week = LmmWeek(
          id: '2026-04-13',
          meetingWeekday: DateTime.tuesday,
          meetingTime: '19:00');
      final cleared = week.copyWith(meetingWeekday: null, meetingTime: null);
      expect(cleared.hasMeetingOverride, isFalse);
      expect(cleared.toJson(), isNot(contains('meetingWeekday')));
    });
  });

  group('WeekendWeek', () {
    test('follows the congregation setting, then its own', () {
      const plain = WeekendWeek(id: '2026-04-13');
      expect(plain.weekdayOr(meta.weekendWeekday), DateTime.sunday);
      expect(plain.timeOr(meta.weekendTime), '10:00');

      const moved = WeekendWeek(
          id: '2026-04-13',
          meetingWeekday: DateTime.saturday,
          meetingTime: '17:00');
      expect(moved.weekdayOr(meta.weekendWeekday), DateTime.saturday);
      expect(moved.timeOr(meta.weekendTime), '17:00');
    });
  });

  // The workbook says nothing about when a meeting is held, so re-importing
  // a week must not hand a rescheduled one back to its regular day.
  test('re-importing the workbook keeps a rescheduled week', () {
    const existing = LmmWeek(
      id: '2026-04-13',
      meetingWeekday: DateTime.tuesday,
      meetingTime: '19:00',
    );
    const parsed = LmmWeek(id: '2026-04-13', weekLabel: 'APRIL 13-19');

    final merged = mergeParsedWeek(existing: existing, parsed: parsed);

    expect(merged.weekLabel, 'APRIL 13-19');
    expect(merged.meetingWeekday, DateTime.tuesday);
    expect(merged.meetingTime, '19:00');
  });

  group('getWeekdayOverrides', () {
    late FakeFirebaseFirestore db;

    setUp(() => db = FakeFirebaseFirestore());

    test('returns only the weeks that deviate, inside the range', () async {
      final repo = LmmRepository(db);
      await repo.saveWeek(const LmmWeek(id: '2026-04-06'));
      await repo.saveWeek(
          const LmmWeek(id: '2026-04-13', meetingWeekday: DateTime.tuesday));
      await repo.saveWeek(
          const LmmWeek(id: '2026-10-05', meetingWeekday: DateTime.thursday));

      final inRange =
          await repo.getWeekdayOverrides('2026-01-01', '2026-06-30');

      expect(inRange, {'2026-04-13': DateTime.tuesday});
    });

    test('works the same for the weekend meeting', () async {
      final repo = WeekendRepository(db);
      await repo.saveWeek(const WeekendWeek(id: '2026-04-06'));
      await repo.saveWeek(const WeekendWeek(
          id: '2026-04-13', meetingWeekday: DateTime.saturday));

      expect(await repo.getWeekdayOverrides('2026-01-01', '2026-12-31'),
          {'2026-04-13': DateTime.saturday});
    });
  });
}
