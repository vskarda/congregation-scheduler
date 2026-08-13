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

  // Seeds a date picker with a day from the week being looked at rather than
  // from today.
  group('dayInWeek', () {
    final monday = DateTime(2026, 4, 13);

    test('is today when today is in that week', () {
      expect(dayInWeek(monday, now: DateTime(2026, 4, 16, 21, 30)),
          DateTime(2026, 4, 16));
    });

    test('is the Monday for a week ahead or behind', () {
      expect(dayInWeek(monday, now: DateTime(2026, 4, 12, 23, 59)), monday);
      expect(dayInWeek(monday, now: DateTime(2026, 4, 20)), monday);
    });

    test('covers both ends of the week', () {
      expect(dayInWeek(monday, now: DateTime(2026, 4, 13, 0, 1)), monday);
      expect(dayInWeek(monday, now: DateTime(2026, 4, 19, 23, 59)),
          DateTime(2026, 4, 19));
    });
  });
}
