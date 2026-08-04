import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/s1_report/s1_screen.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A closed month's S-1 must not change when someone is archived afterwards.
///
/// The figures are computed from `reports/{month}/entries` and the month's
/// attendance alone — the publisher roster is never consulted — so marking a
/// publisher moved (or even deleting the record) leaves the month untouched.
/// This pins that down against a future "filter the roster" refactor.
void main() {
  const month = '2026-06';

  Future<FakeFirebaseFirestore> seed() async {
    final db = FakeFirebaseFirestore();
    await db.collection('publishers').doc('p1').set(const Publisher(
          firstName: 'Anna',
          lastName: 'Novak',
          verified: true,
        ).toJson());
    await db.collection('publishers').doc('p2').set(const Publisher(
          firstName: 'Petr',
          lastName: 'Svoboda',
          status: PublisherStatus.regularPioneer,
          verified: true,
        ).toJson());

    final entries = db.collection('reports').doc(month).collection('entries');
    await entries.doc('p1').set(const MinistryReport(
          month: month,
          participated: true,
          bibleStudies: 2,
        ).toJson());
    await entries.doc('p2').set(const MinistryReport(
          month: month,
          participated: true,
          hours: 50,
          bibleStudies: 3,
          statusAtMonth: PublisherStatus.regularPioneer,
        ).toJson());

    await db.collection('attendance').doc('$month-02_lmm').set(
        const AttendanceEntry(
                date: '$month-02', meetingType: MeetingType.lmm, total: 50)
            .toJson());
    return db;
  }

  ProviderContainer containerOn(FakeFirebaseFirestore db) {
    final container = ProviderContainer(
      overrides: [firestoreProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('a past month keeps a publisher who moved away afterwards', () async {
    final db = await seed();
    final container = containerOn(db);

    final before = await container.read(s1ResultProvider(month).future);
    expect(before.activePublishers, 2);
    expect(before.publishers.count, 1);
    expect(before.publishers.studies, 2);
    expect(before.regularPioneers.count, 1);
    expect(before.regularPioneers.hours, 50);
    expect(before.avgMidweekAttendance, 50);

    // Exactly what "Mark as moved" writes today.
    await db.collection('publishers').doc('p1').set(const Publisher(
          firstName: 'Anna',
          lastName: 'Novak',
          verified: false,
          moved: true,
        ).toJson());

    // The provider caches per month; refresh stands in for a fresh session.
    final after = await container.refresh(s1ResultProvider(month).future);
    expect(after.activePublishers, before.activePublishers);
    expect(after.publishers.count, before.publishers.count);
    expect(after.publishers.studies, before.publishers.studies);
    expect(after.regularPioneers.count, before.regularPioneers.count);
    expect(after.regularPioneers.hours, before.regularPioneers.hours);
  });

  test('a past month keeps a publisher whose record was deleted', () async {
    final db = await seed();
    final container = containerOn(db);

    final before = await container.read(s1ResultProvider(month).future);
    await db.collection('publishers').doc('p1').delete();

    final after = await container.refresh(s1ResultProvider(month).future);
    expect(after.activePublishers, before.activePublishers);
    expect(after.publishers.count, before.publishers.count);
  });

  test('a report without participation never reaches the S-1 groups', () async {
    // The likeliest reason a person "disappears" from a month they were still
    // here for: an empty report counts as reported on the Reports overview but
    // is not a publisher on the S-1.
    final db = await seed();
    await db
        .collection('reports')
        .doc(month)
        .collection('entries')
        .doc('p1')
        .set(const MinistryReport(month: month, comments: 'moved away')
            .toJson());

    final result =
        await containerOn(db).read(s1ResultProvider(month).future);
    expect(result.publishers.count, 0);
    expect(result.activePublishers, 1);
  });
}
