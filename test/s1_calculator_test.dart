import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/s1_report/s1_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

MinistryReport report(
  String id, {
  bool participated = true,
  PublisherStatus status = PublisherStatus.publisher,
  int? studies,
  int? hours,
  int? credit,
}) =>
    MinistryReport(
      publisherId: id,
      participated: participated,
      statusAtMonth: status,
      bibleStudies: studies,
      hours: hours,
      creditHours: credit,
    );

void main() {
  test('computeS1 groups by status snapshot and excludes special pioneers',
      () {
    final month = [
      report('a', studies: 2),
      report('b'),
      report('c', participated: false),
      report('d', status: PublisherStatus.auxiliaryPioneer, hours: 30),
      report('e',
          status: PublisherStatus.auxiliaryPioneer,
          hours: 15,
          credit: 5,
          studies: 1),
      report('f',
          status: PublisherStatus.regularPioneer, hours: 50, studies: 3),
      report('g', status: PublisherStatus.specialPioneer, hours: 100),
    ];
    final result = computeS1(
      monthReports: month,
      lastSixMonths: [
        month,
        [report('h')], // reported an earlier month only -> still active
        [report('c')], // c participated earlier -> active
      ],
      monthAttendance: const [
        AttendanceEntry(
            date: '2026-06-02', meetingType: MeetingType.lmm, inPerson: 40,
            online: 10),
        AttendanceEntry(
            date: '2026-06-09', meetingType: MeetingType.lmm, inPerson: 42,
            online: 8),
        AttendanceEntry(
            date: '2026-06-07',
            meetingType: MeetingType.weekend,
            inPerson: 60,
            online: 15),
      ],
    );

    // a, b, d, e, f, g from this month + h and c from earlier months.
    expect(result.activePublishers, 8);
    // In-person and online always counted together.
    expect(result.avgMidweekAttendance, 50);
    expect(result.avgWeekendAttendance, 75);

    expect(result.publishers.count, 2); // a, b (c did not participate)
    expect(result.publishers.studies, 2);

    expect(result.auxiliaryPioneers.count, 2);
    expect(result.auxiliaryPioneers.hours, 50); // 30 + 15 + 5 credit
    expect(result.auxiliaryPioneers.studies, 1);

    expect(result.regularPioneers.count, 1);
    expect(result.regularPioneers.hours, 50);
    expect(result.regularPioneers.studies, 3);
  });
}
