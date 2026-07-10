import 'package:congregation_scheduler/core/data/pw_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PwRepository.materializedDates', () {
    test('emits the rule weekday between from and until', () {
      const rule = PwRecurring(id: 'r1', weekday: DateTime.saturday);
      final dates = PwRepository.materializedDates(
          rule, DateTime(2026, 7, 7), DateTime(2026, 8, 4));
      expect(dates, ['2026-07-11', '2026-07-18', '2026-07-25', '2026-08-01']);
    });

    test('starts on from itself when it matches the weekday', () {
      const rule = PwRecurring(id: 'r1', weekday: DateTime.tuesday);
      final dates = PwRepository.materializedDates(
          rule, DateTime(2026, 7, 7), DateTime(2026, 7, 22));
      expect(dates, ['2026-07-07', '2026-07-14', '2026-07-21']);
    });

    test('respects validFrom and validUntil', () {
      const rule = PwRecurring(
        id: 'r1',
        weekday: DateTime.saturday,
        validFrom: '2026-07-15',
        validUntil: '2026-07-31',
      );
      final dates = PwRepository.materializedDates(
          rule, DateTime(2026, 7, 1), DateTime(2026, 9, 1));
      expect(dates, ['2026-07-18', '2026-07-25']);
    });

    test('is empty when the rule expired', () {
      const rule = PwRecurring(
          id: 'r1', weekday: DateTime.saturday, validUntil: '2026-06-30');
      final dates = PwRepository.materializedDates(
          rule, DateTime(2026, 7, 7), DateTime(2026, 9, 1));
      expect(dates, isEmpty);
    });
  });

  group('PwRepository.mergeWithRules', () {
    // Week Monday 2026-07-06 .. Sunday 2026-07-12 (until is exclusive).
    final monday = DateTime(2026, 7, 6);
    final until = DateTime(2026, 7, 13);

    const rule = PwRecurring(
      id: 'r1',
      weekday: DateTime.saturday, // 2026-07-11
      startTime: '09:00',
      endTime: '11:00',
      location: 'Square',
      defaultAssignment: Assignment(publisherIds: ['p1', 'p2']),
    );

    test('expands a virtual instance with the deterministic id', () {
      final merged = PwRepository.mergeWithRules(const [], [rule], monday, until);
      expect(merged, hasLength(1));
      final slot = merged.single;
      expect(slot.id, 'r1_2026-07-11');
      expect(slot.date, '2026-07-11');
      expect(slot.startTime, '09:00');
      expect(slot.location, 'Square');
      expect(slot.recurringId, 'r1');
      expect(slot.assignment.publisherIds, ['p1', 'p2']);
      expect(slot.allAssigneeIds, ['p1', 'p2']);
    });

    test('expands past weeks too', () {
      final merged = PwRepository.mergeWithRules(
          const [], [rule], DateTime(2026, 6, 1), DateTime(2026, 6, 8));
      expect(merged.map((s) => s.date), ['2026-06-06']);
    });

    test('a concrete edited instance wins over the virtual one', () {
      const edited = PwSlot(
        id: 'r1_2026-07-11',
        date: '2026-07-11',
        startTime: '10:00',
        endTime: '12:00',
        location: 'Square',
        recurringId: 'r1',
      );
      final merged =
          PwRepository.mergeWithRules(const [edited], [rule], monday, until);
      expect(merged, hasLength(1));
      expect(merged.single.startTime, '10:00');
    });

    test('a cancelled instance suppresses the virtual one and is hidden', () {
      const cancelled = PwSlot(
        id: 'r1_2026-07-11',
        date: '2026-07-11',
        recurringId: 'r1',
        cancelled: true,
      );
      final merged =
          PwRepository.mergeWithRules(const [cancelled], [rule], monday, until);
      expect(merged, isEmpty);
    });

    test('one-off slots pass through and the result is sorted', () {
      const oneOff = PwSlot(
        id: 'x1',
        date: '2026-07-11',
        startTime: '07:00',
        endTime: '09:00',
        location: 'Station',
      );
      const earlier = PwSlot(
        id: 'x2',
        date: '2026-07-08',
        startTime: '15:00',
        endTime: '17:00',
        location: 'Park',
      );
      final merged = PwRepository.mergeWithRules(
          const [oneOff, earlier], [rule], monday, until);
      expect(merged.map((s) => s.id), ['x2', 'x1', 'r1_2026-07-11']);
    });

    test('respects the rule validity window', () {
      const limited = PwRecurring(
        id: 'r1',
        weekday: DateTime.saturday,
        validUntil: '2026-07-10',
      );
      final merged =
          PwRepository.mergeWithRules(const [], [limited], monday, until);
      expect(merged, isEmpty);
    });
  });
}
