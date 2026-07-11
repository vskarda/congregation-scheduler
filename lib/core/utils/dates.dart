import 'package:intl/intl.dart';

/// Date-only values are stored in Firestore as `yyyy-MM-dd` strings; week
/// documents are keyed by the Monday of their week.

final DateFormat _dateKeyFormat = DateFormat('yyyy-MM-dd');
final DateFormat _monthKeyFormat = DateFormat('yyyy-MM');

String dateKey(DateTime d) => _dateKeyFormat.format(d);

DateTime? tryParseDateKey(String? key) {
  if (key == null || key.isEmpty) return null;
  return DateTime.tryParse(key);
}

DateTime parseDateKey(String key) => DateTime.parse(key);

/// Monday 00:00 of the week containing [d].
DateTime mondayOf(DateTime d) {
  final day = DateTime(d.year, d.month, d.day);
  return day.subtract(Duration(days: day.weekday - DateTime.monday));
}

String weekIdOf(DateTime d) => dateKey(mondayOf(d));

String monthKey(DateTime d) => _monthKeyFormat.format(d);

DateTime parseMonthKey(String key) => DateTime.parse('$key-01');

/// Month arithmetic that clamps to the first day of the month.
DateTime addMonths(DateTime d, int months) =>
    DateTime(d.year, d.month + months, 1);

/// Mondays that fall inside the month of [month]. Advances by calendar days
/// (not Duration) so a DST shift can't move a Monday midnight to the
/// previous day.
List<DateTime> mondaysInMonth(DateTime month) {
  var m = mondayOf(DateTime(month.year, month.month, 1));
  if (m.month != month.month) m = DateTime(m.year, m.month, m.day + 7);
  final mondays = <DateTime>[];
  while (m.month == month.month) {
    mondays.add(m);
    m = DateTime(m.year, m.month, m.day + 7);
  }
  return mondays;
}

/// Service years run September..August; returns the year the service year
/// ends in (e.g. 2026 for Sep 2025 – Aug 2026).
int serviceYearOf(DateTime d) => d.month >= 9 ? d.year + 1 : d.year;

/// The 12 month keys of a service year, September first.
List<String> serviceYearMonths(int serviceYear) => [
      for (var m = 9; m <= 12; m++) monthKey(DateTime(serviceYear - 1, m)),
      for (var m = 1; m <= 8; m++) monthKey(DateTime(serviceYear, m)),
    ];
