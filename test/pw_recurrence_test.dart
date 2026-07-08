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
}
