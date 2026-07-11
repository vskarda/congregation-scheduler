import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mondaysInMonth', () {
    List<int> days(int year, int month) =>
        mondaysInMonth(DateTime(year, month, 1)).map((d) => d.day).toList();

    test('month starting on a Monday', () {
      expect(days(2026, 6), [1, 8, 15, 22, 29]);
    });

    test('month starting mid-week', () {
      expect(days(2026, 7), [6, 13, 20, 27]);
    });

    test('28-day month starting on a Monday has exactly 4 Mondays', () {
      expect(days(2027, 2), [1, 8, 15, 22]);
    });

    test('spring DST month keeps Monday dates', () {
      // EU spring-forward on 2026-03-29.
      expect(days(2026, 3), [2, 9, 16, 23, 30]);
    });

    test('autumn DST month keeps Monday dates', () {
      // EU fall-back on 2026-10-25.
      expect(days(2026, 10), [5, 12, 19, 26]);
    });

    test('every returned date is a Monday at midnight', () {
      for (var month = 1; month <= 12; month++) {
        for (final m in mondaysInMonth(DateTime(2026, month, 1))) {
          expect(m.weekday, DateTime.monday);
          expect(m.hour, 0);
          expect(m.month, month);
        }
      }
    });
  });
}
