import 'package:congregation_scheduler/core/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

/// The two cuts a recorded departure makes: day-level for meetings and
/// assignments, month-level for report rosters and the S-1.
void main() {
  Publisher moved(String? date) =>
      Publisher(moved: true, movedDate: date);

  group('hasMovedBy', () {
    test('a record that never moved is never gone', () {
      const here = Publisher();
      expect(here.hasMovedBy(DateTime(2030)), isFalse);
      // A stray date without the flag is not a departure either.
      expect(const Publisher(movedDate: '2020-01-01').hasMovedBy(DateTime(2030)),
          isFalse);
    });

    test('gone from the moving day onwards, not before', () {
      final p = moved('2026-03-15');
      expect(p.hasMovedBy(DateTime(2026, 3, 14, 23, 59)), isFalse);
      expect(p.hasMovedBy(DateTime(2026, 3, 15)), isTrue);
      expect(p.hasMovedBy(DateTime(2026, 3, 15, 23, 59)), isTrue);
      expect(p.hasMovedBy(DateTime(2026, 3, 16)), isTrue);
    });

    test('a record archived without a date counts as long gone', () {
      // Written before the field existed; there is no day to compare against,
      // so it must not silently come back onto the roster.
      expect(moved(null).hasMovedBy(DateTime(1990)), isTrue);
      expect(moved('').hasMovedBy(DateTime(2030)), isTrue);
    });

    test('isMovePending only while the date is still ahead', () {
      final future = DateTime.now().add(const Duration(days: 30));
      final past = DateTime.now().subtract(const Duration(days: 30));
      String key(DateTime d) =>
          '${d.year}-${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';
      expect(moved(key(future)).isMovePending, isTrue);
      expect(moved(key(past)).isMovePending, isFalse);
      expect(moved(null).isMovePending, isFalse);
      expect(const Publisher().isMovePending, isFalse);
    });
  });

  group('onRosterInMonth', () {
    test('the month of the move belongs to the new congregation', () {
      final p = moved('2026-03-15');
      expect(p.onRosterInMonth('2026-01'), isTrue);
      expect(p.onRosterInMonth('2026-02'), isTrue);
      expect(p.onRosterInMonth('2026-03'), isFalse);
      expect(p.onRosterInMonth('2026-04'), isFalse);
    });

    test('the day within the month does not matter', () {
      // Moving on the 1st and on the 31st drop the same month: the report for
      // a partial month goes to the congregation they moved to.
      expect(moved('2026-03-01').onRosterInMonth('2026-03'), isFalse);
      expect(moved('2026-03-31').onRosterInMonth('2026-03'), isFalse);
      expect(moved('2026-03-31').onRosterInMonth('2026-02'), isTrue);
    });

    test('crosses the year boundary on string order alone', () {
      final p = moved('2026-01-10');
      expect(p.onRosterInMonth('2025-12'), isTrue);
      expect(p.onRosterInMonth('2026-01'), isFalse);
    });

    test('everyone else is on every roster', () {
      expect(const Publisher().onRosterInMonth('1999-01'), isTrue);
      // Archived without a date: no month can be proven, so none is claimed.
      expect(moved(null).onRosterInMonth('1999-01'), isFalse);
    });
  });
}
