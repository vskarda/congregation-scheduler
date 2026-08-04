import '../../core/models/models.dart';

/// One S-1 group line: publishers / auxiliary pioneers / regular pioneers.
class S1Group {
  const S1Group(
      {required this.count, required this.studies, required this.hours});

  final int count;
  final int studies;

  /// Field service + credit hours.
  final int hours;
}

class S1Result {
  const S1Result({
    required this.activePublishers,
    required this.avgMidweekAttendance,
    required this.avgWeekendAttendance,
    required this.publishers,
    required this.auxiliaryPioneers,
    required this.regularPioneers,
  });

  /// Distinct persons with a positive report in the last 6 months
  /// (including the selected month).
  final int activePublishers;
  final int? avgMidweekAttendance;
  final int? avgWeekendAttendance;
  final S1Group publishers;
  final S1Group auxiliaryPioneers;
  final S1Group regularPioneers;
}

/// Pure S-1 computation over one month's report entries, the last six
/// months' entries (for the actives count) and the month's attendance.
///
/// Group membership uses the status snapshot stored on each report
/// (statusAtMonth); pioneers are excluded from the Publishers group and
/// special pioneers from every group, per the S-1 definition.
///
/// [excludedIds] names publishers who had already left the congregation by
/// this month (see `Publisher.onRosterInMonth`). Their entries belong to the
/// congregation they moved to, whichever month they were filed for — a report
/// submitted on the 10th by someone who moved on the 15th is still theirs, not
/// ours. Entries whose publisher record is gone altogether are not in the set
/// and keep counting: a deleted record says nothing about where the person
/// went, and a closed month should not quietly lose a number because somebody
/// tidied up the roster.
S1Result computeS1({
  required List<MinistryReport> monthReports,
  required List<List<MinistryReport>> lastSixMonths,
  required List<AttendanceEntry> monthAttendance,
  Set<String> excludedIds = const {},
}) {
  final activeIds = <String>{
    for (final month in lastSixMonths)
      for (final report in month)
        if (report.participated && !excludedIds.contains(report.publisherId))
          report.publisherId,
  };

  S1Group group(PublisherStatus status) {
    final reports = monthReports
        .where((r) =>
            r.participated &&
            r.statusAtMonth == status &&
            !excludedIds.contains(r.publisherId))
        .toList();
    return S1Group(
      count: reports.length,
      studies: reports.fold(0, (sum, r) => sum + (r.bibleStudies ?? 0)),
      hours: reports.fold(0, (sum, r) => sum + r.totalHours),
    );
  }

  int? average(MeetingType type) {
    final totals = monthAttendance
        .where((e) => e.meetingType == type && e.hasData)
        .map((e) => e.resolvedTotal)
        .toList();
    if (totals.isEmpty) return null;
    return (totals.reduce((a, b) => a + b) / totals.length).round();
  }

  return S1Result(
    activePublishers: activeIds.length,
    avgMidweekAttendance: average(MeetingType.lmm),
    avgWeekendAttendance: average(MeetingType.weekend),
    publishers: group(PublisherStatus.publisher),
    auxiliaryPioneers: group(PublisherStatus.auxiliaryPioneer),
    regularPioneers: group(PublisherStatus.regularPioneer),
  );
}
