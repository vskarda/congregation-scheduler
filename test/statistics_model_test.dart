import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/statistics/statistics_model.dart';
import 'package:flutter_test/flutter_test.dart';

Publisher publisher(
  String id, {
  PublisherStatus status = PublisherStatus.publisher,
  Gender gender = Gender.unknown,
  Appointment appointment = Appointment.none,
  Roles roles = const Roles(),
  bool hasAccount = false,
  bool verified = false,
  bool moved = false,
  String? movedDate,
  String? groupId,
}) =>
    Publisher(
      id: id,
      firstName: id,
      status: status,
      gender: gender,
      appointment: appointment,
      roles: roles,
      hasAccount: hasAccount,
      verified: verified,
      moved: moved,
      movedDate: movedDate,
      groupId: groupId,
    );

void main() {
  group('computeMembership', () {
    test('counts statuses, appointments, gender; excludes moved and status "-"',
        () {
      final stats = computeMembership([
        publisher('a',
            gender: Gender.male, appointment: Appointment.elder),
        publisher('b',
            status: PublisherStatus.regularPioneer,
            gender: Gender.female,
            groupId: 'g1'),
        publisher('c',
            status: PublisherStatus.auxiliaryPioneer,
            appointment: Appointment.ministerialServant,
            gender: Gender.male,
            groupId: 'g1'),
        publisher('d', status: PublisherStatus.none), // "-" -> excluded
        publisher('e', moved: true), // moved away -> excluded everywhere
        // Stale groupId (group deleted) counts as ungrouped.
        publisher('f', groupId: 'gone'),
      ], const [
        MinistryGroup(id: 'g1', name: 'Group 1'),
        MinistryGroup(id: 'g2', name: 'Group 2'),
      ]);

      // 'd' (status "-") and 'e' (moved) drop out; total is all publishers
      // and pioneers together.
      expect(stats.total, 4);
      expect(stats.byStatus[PublisherStatus.publisher], 2);
      expect(stats.byStatus[PublisherStatus.regularPioneer], 1);
      expect(stats.byStatus[PublisherStatus.auxiliaryPioneer], 1);
      expect(stats.byStatus.containsKey(PublisherStatus.none), isFalse);
      expect(stats.pioneers, 2);
      expect(stats.elders, 1);
      expect(stats.ministerialServants, 1);
      expect(stats.byGender[Gender.male], 2);
      expect(stats.byGender[Gender.female], 1);
      expect(stats.groupSizes, {'Group 1': 2, 'Group 2': 0});
      expect(stats.ungrouped, 2); // a, f
    });

    test('a departure counts from its date, not from when it was recorded',
        () {
      // The roster cards describe the congregation as it stands: a move that
      // has not happened yet is still one of us, one that has is not.
      final roster = [
        publisher('here'),
        publisher('leaving', moved: true, movedDate: '2026-03-15'),
        publisher('gone', moved: true, movedDate: '2026-03-15'),
      ];
      expect(activeRoster(roster, asOf: DateTime(2026, 3, 14)), hasLength(3));
      expect(activeRoster(roster, asOf: DateTime(2026, 3, 15)), hasLength(1));

      expect(
          computeMembership(roster, const [], asOf: DateTime(2026, 3, 1)).total,
          3);
      expect(
          computeMembership(roster, const [], asOf: DateTime(2026, 4, 1)).total,
          1);
    });

    test('empty roster yields zeros', () {
      final stats = computeMembership(const [], const []);
      expect(stats.total, 0);
      expect(stats.pioneers, 0);
      expect(stats.ungrouped, 0);
      expect(stats.byStatus, isEmpty);
    });
  });

  group('ageInYears / bandOf', () {
    final asOf = DateTime(2026, 7, 17);

    test('birthday not yet reached counts one year less', () {
      expect(ageInYears(DateTime(2000, 7, 17), asOf), 26); // today
      expect(ageInYears(DateTime(2000, 7, 18), asOf), 25); // tomorrow
      expect(ageInYears(DateTime(2000, 7, 16), asOf), 26); // yesterday
    });

    test('leap-day birthday rolls over on Mar 1 in non-leap years', () {
      final birth = DateTime(2004, 2, 29);
      expect(ageInYears(birth, DateTime(2026, 2, 28)), 21);
      expect(ageInYears(birth, DateTime(2026, 3, 1)), 22);
    });

    test('band boundaries', () {
      expect(bandOf(17), AgeBand.under18);
      expect(bandOf(18), AgeBand.from18to29);
      expect(bandOf(29), AgeBand.from18to29);
      expect(bandOf(30), AgeBand.from30to44);
      expect(bandOf(44), AgeBand.from30to44);
      expect(bandOf(45), AgeBand.from45to64);
      expect(bandOf(64), AgeBand.from45to64);
      expect(bandOf(65), AgeBand.over65);
    });
  });

  group('computeAges', () {
    final asOf = DateTime(2026, 7, 17);

    test('bands, unknowns and average', () {
      final stats = computeAges([
        DateTime(2010, 1, 1), // 16
        DateTime(2000, 1, 1), // 26
        DateTime(1990, 1, 1), // 36
        null, // unknown
      ], asOf);
      expect(stats.byBand[AgeBand.under18], 1);
      expect(stats.byBand[AgeBand.from18to29], 1);
      expect(stats.byBand[AgeBand.from30to44], 1);
      expect(stats.byBand[AgeBand.unknown], 1);
      expect(stats.known, 3);
      expect(stats.averageAge, closeTo(26, 0.001));
    });

    test('no known birth dates -> null average', () {
      final stats = computeAges([null, null], asOf);
      expect(stats.averageAge, isNull);
      expect(stats.known, 0);
      expect(stats.byBand[AgeBand.unknown], 2);
    });
  });

  group('computeAttendance', () {
    AttendanceEntry entry(String date, MeetingType type, int total) =>
        AttendanceEntry(date: date, meetingType: type, total: total);

    test('averages per window and monthly series', () {
      final stats = computeAttendance([
        entry('2026-05-05', MeetingType.lmm, 40),
        entry('2026-05-12', MeetingType.lmm, 44), // May avg 42
        entry('2026-06-02', MeetingType.lmm, 50),
        entry('2026-07-07', MeetingType.lmm, 60),
        entry('2026-07-05', MeetingType.weekend, 80),
        // Future month must be ignored.
        entry('2026-08-04', MeetingType.lmm, 999),
        // Entry without data must be skipped.
        const AttendanceEntry(date: '2026-07-14', meetingType: MeetingType.lmm),
      ], currentMonth: '2026-07');

      expect(stats.avg3Months[MeetingType.lmm], 49); // (40+44+50+60)/4
      expect(stats.avg12Months[MeetingType.lmm], 49);
      expect(stats.avg3Months[MeetingType.weekend], 80);
      expect(stats.monthlySeries.keys.toList(),
          ['2026-05', '2026-06', '2026-07']);
      expect(stats.monthlySeries['2026-05']![MeetingType.lmm], 42);
      expect(stats.monthlySeries['2026-07']![MeetingType.weekend], 80);
      expect(stats.monthlySeries['2026-05']!.containsKey(MeetingType.weekend),
          isFalse);
    });

    test('no data -> null averages, empty series', () {
      final stats = computeAttendance(const [], currentMonth: '2026-07');
      expect(stats.avg3Months[MeetingType.lmm], isNull);
      expect(stats.avg12Months[MeetingType.weekend], isNull);
      expect(stats.monthlySeries, isEmpty);
    });

    test('a Memorial count moves nothing and gets no series of its own', () {
      final withoutMemorial = computeAttendance([
        entry('2026-07-07', MeetingType.lmm, 60),
        entry('2026-07-05', MeetingType.weekend, 80),
      ], currentMonth: '2026-07');
      final withMemorial = computeAttendance([
        entry('2026-07-07', MeetingType.lmm, 60),
        entry('2026-07-05', MeetingType.weekend, 80),
        // Ten times the size of a normal meeting, as a Memorial often is.
        entry('2026-07-02', MeetingType.memorial, 800),
      ], currentMonth: '2026-07');

      expect(withMemorial.avg3Months, withoutMemorial.avg3Months);
      expect(withMemorial.avg12Months, withoutMemorial.avg12Months);
      expect(withMemorial.monthlySeries, withoutMemorial.monthlySeries);
      expect(withMemorial.avg3Months.containsKey(MeetingType.memorial),
          isFalse);
      expect(
        withMemorial.monthlySeries['2026-07']!
            .containsKey(MeetingType.memorial),
        isFalse,
      );
    });

    test('windows cover the last 3 and 12 months with data', () {
      final entries = [
        for (var m = 1; m <= 12; m++)
          entry('2025-${m.toString().padLeft(2, '0')}-01', MeetingType.lmm, m),
        entry('2026-01-01', MeetingType.lmm, 100),
      ];
      final stats = computeAttendance(entries, currentMonth: '2026-01');
      // Last 3 months with data: 2025-11 (11), 2025-12 (12), 2026-01 (100).
      expect(stats.avg3Months[MeetingType.lmm], 41);
      // Last 12: 2025-02..2026-01 -> (2+..+12+100)/12
      expect(stats.avg12Months[MeetingType.lmm],
          ((2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10 + 11 + 12 + 100) / 12).round());
      expect(stats.monthlySeries.length, 12);
      expect(stats.monthlySeries.containsKey('2025-01'), isFalse);
    });
  });

  group('computeFieldService', () {
    MinistryReport report(
      String id, {
      bool participated = true,
      PublisherStatus status = PublisherStatus.publisher,
      int? hours,
      int? credit,
      int? studies,
    }) =>
        MinistryReport(
          publisherId: id,
          participated: participated,
          statusAtMonth: status,
          hours: hours,
          creditHours: credit,
          bibleStudies: studies,
        );

    test('totals, pioneer split and participation', () {
      final stats = computeFieldService([
        [
          report('a', studies: 2),
          report('b',
              status: PublisherStatus.regularPioneer, hours: 50, credit: 10),
          report('c', participated: false),
        ],
        [
          report('a', studies: 1),
          report('d', status: PublisherStatus.auxiliaryPioneer, hours: 30),
        ],
        const <MinistryReport>[], // month without data
      ]);

      expect(stats.totalHours, 90);
      expect(stats.totalStudies, 3);
      expect(stats.pioneerHours, 90);
      expect(stats.publisherHours, 0);
      expect(stats.reportsSubmitted, 5);
      expect(stats.participated, 4);
      expect(stats.monthsWithData, 2);
    });
  });

  group('computeTerritories', () {
    // Sep 2025 – Aug 2026.
    const serviceYear = 2026;

    TerritoryAssignment assignment(
      String territoryId, {
      String assigned = '2025-09-01',
      String returned = '',
    }) =>
        TerritoryAssignment(
          territoryId: territoryId,
          assignedDate: assigned,
          returnedDate: returned,
        );

    const territories = [
      Territory(id: 't1', name: 'Alpha'),
      Territory(id: 't2', name: 'Beta'),
      Territory(id: 't3', name: 'Gamma'),
    ];

    TerritoryStats stats(List<TerritoryAssignment> assignments) =>
        computeTerritories(territories, assignments,
            serviceYear: serviceYear);

    test('the year runs September to August', () {
      final result = stats([
        assignment('t1', assigned: '2025-08-01', returned: '2025-08-31'),
        assignment('t1', assigned: '2025-08-15', returned: '2025-09-01'),
        assignment('t2', assigned: '2026-08-01', returned: '2026-08-31'),
        assignment('t3', assigned: '2026-08-20', returned: '2026-09-01'),
      ]);

      // The August before and the September after belong to other years.
      expect(result.completed, 2);
      expect(result.completionsByMonth['2025-09'], 1);
      expect(result.completionsByMonth['2026-08'], 1);
      expect(result.completionsByMonth.keys.first, '2025-09');
      expect(result.completionsByMonth.keys.last, '2026-08');
      expect(result.completionsByMonth, hasLength(12));
    });

    test('a territory worked twice is covered once', () {
      final result = stats([
        assignment('t1', assigned: '2025-09-01', returned: '2025-10-01'),
        assignment('t1', assigned: '2025-11-01', returned: '2025-12-01'),
      ]);

      expect(result.completed, 2);
      expect(result.covered, 1);
      expect(result.notCovered, 2);
      expect(result.total, 3);
    });

    test('a territory still out counts as assigned, never as completed', () {
      final result = stats([
        assignment('t1'),
        assignment('t2', returned: '2025-10-15'),
      ]);

      expect(result.currentlyAssigned, 1);
      expect(result.completed, 1);
      expect(result.covered, 1);
    });

    test('a deleted territory keeps its history but not its share', () {
      // The territory is gone, the round of work still happened; the bars
      // measure against the territories that exist, so neither can overflow.
      final result = stats([
        assignment('deleted', assigned: '2025-09-01', returned: '2025-10-01'),
        assignment('deleted'),
      ]);

      expect(result.completed, 1);
      expect(result.completionsByMonth['2025-10'], 1);
      expect(result.covered, 0);
      expect(result.currentlyAssigned, 0);
      expect(result.covered, lessThanOrEqualTo(result.total));
    });

    test('average span skips what it cannot measure', () {
      final result = stats([
        assignment('t1', assigned: '2025-09-01', returned: '2025-09-11'),
        assignment('t2', assigned: '2025-10-01', returned: '2025-10-21'),
        // Never recorded as handed out, and a return before the assignment:
        // both count as completions, neither as a measurable span.
        assignment('t3', assigned: '', returned: '2025-11-01'),
        assignment('t3', assigned: '2025-12-10', returned: '2025-12-01'),
      ]);

      expect(result.completed, 4);
      expect(result.averageDaysToComplete, closeTo(15, 0.001));
    });

    test('a span across the spring DST switch keeps its full length', () {
      // Local midnights lose an hour in between; whole days must not.
      final result = stats(
          [assignment('t1', assigned: '2026-03-01', returned: '2026-04-01')]);

      expect(result.averageDaysToComplete, closeTo(31, 0.001));
    });

    test('a year without returns has no average and only zero months', () {
      final result = stats([assignment('t1')]);

      expect(result.completed, 0);
      expect(result.covered, 0);
      expect(result.averageDaysToComplete, isNull);
      expect(result.completionsByMonth.values.every((v) => v == 0), isTrue);
    });

    test('no territories yields zeros', () {
      final result = computeTerritories(const [], const [],
          serviceYear: serviceYear);

      expect(result.total, 0);
      expect(result.currentlyAssigned, 0);
      expect(result.notCovered, 0);
    });
  });

  group('computeAppUsage', () {
    test('accounts, admins and self-reporting split', () {
      final stats = computeAppUsage([
        publisher('a',
            hasAccount: true,
            verified: true,
            roles: const Roles(fullAdmin: true)),
        publisher('b',
            hasAccount: true, verified: true, roles: const Roles(reports: true)),
        publisher('c', hasAccount: true), // awaiting verification
        publisher('d'), // record without login
        publisher('e', moved: true, hasAccount: true), // excluded
      ], const [
        MinistryReport(publisherId: 'a', enteredBy: 'self'),
        MinistryReport(publisherId: 'b', enteredBy: 'self'),
        MinistryReport(publisherId: 'd', enteredBy: 'adminUid'),
      ]);

      expect(stats.total, 4);
      expect(stats.withAccount, 3);
      expect(stats.awaitingVerification, 1);
      expect(stats.fullAdmins, 1);
      expect(stats.sectionAdmins, 1);
      expect(stats.selfReported, 2);
      expect(stats.adminEntered, 1);
    });
  });
}
