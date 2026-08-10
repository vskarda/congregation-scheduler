import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/features/statistics/statistics_model.dart';
import 'package:congregation_scheduler/features/statistics/statistics_providers.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The statistics read report documents, so they need the same cut as the
/// S-1: an entry filed for a month the publisher had already left is the next
/// congregation's, and must not swell this one's service-year totals.
void main() {
  // Sep 2025 – Aug 2026.
  const serviceYear = 2026;

  ProviderContainer containerWith(
      FakeFirebaseFirestore db, List<Publisher> publishers,
      {List<FormerPublisher> former = const []}) {
    final container = ProviderContainer(
      overrides: [
        firestoreProvider.overrideWithValue(db),
        allPublishersProvider.overrideWith((ref) => Stream.value(publishers)),
        formerPublishersProvider.overrideWith((ref) => Stream.value(former)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// Both providers under test are autoDispose: reading only their `.future`
  /// closes the subscription again straight away and disposes them mid-load,
  /// so each read is held open by a listener that outlives it.
  Future<List<List<MinistryReport>>> serviceYearReports(
      ProviderContainer container) async {
    final provider = serviceYearReportsProvider(serviceYear);
    final sub = container.listen(provider, (_, _) {});
    try {
      return await container.read(provider.future);
    } finally {
      sub.close();
    }
  }

  Future<List<MinistryReport>> lastMonthReports(
      ProviderContainer container) async {
    final sub = container.listen(lastMonthReportsProvider, (_, _) {});
    try {
      return await container.read(lastMonthReportsProvider.future);
    } finally {
      sub.close();
    }
  }

  /// 10 hours and 1 study every month of the service year.
  Future<FakeFirebaseFirestore> seedFullYear(String publisherId) async {
    final db = FakeFirebaseFirestore();
    for (final month in serviceYearMonths(serviceYear)) {
      await db
          .collection('reports')
          .doc(month)
          .collection('entries')
          .doc(publisherId)
          .set(MinistryReport(
            month: month,
            participated: true,
            hours: 10,
            bibleStudies: 1,
          ).toJson());
    }
    return db;
  }

  test('a service year keeps the months before the move and drops the rest',
      () async {
    final db = await seedFullYear('p1');
    final moved = Publisher(
      id: 'p1',
      firstName: 'Anna',
      moved: true,
      movedDate: '2026-01-20',
    );

    final stats =
        computeFieldService(await serviceYearReports(containerWith(db, [moved])));

    // Sep–Dec 2025 count (4 months), January onwards does not.
    expect(stats.monthsWithData, 4);
    expect(stats.reportsSubmitted, 4);
    expect(stats.totalHours, 40);
    expect(stats.totalStudies, 4);
  });

  test('deleting the mover changes none of it', () async {
    // The record is gone, its departure is not: the statistics and the S-1
    // have to draw the line in the same place, or the two screens disagree
    // about a year that has already been reported.
    final db = await seedFullYear('p1');
    final stats = computeFieldService(await serviceYearReports(containerWith(
      db,
      const [],
      former: const [FormerPublisher(id: 'p1', movedDate: '2026-01-20')],
    )));

    expect(stats.monthsWithData, 4);
    expect(stats.totalHours, 40);
    expect(stats.totalStudies, 4);
  });

  test('an unmoved publisher keeps the whole year', () async {
    final db = await seedFullYear('p1');
    final stats = computeFieldService(await serviceYearReports(
        containerWith(db, [const Publisher(id: 'p1', firstName: 'Anna')])));

    expect(stats.monthsWithData, 12);
    expect(stats.totalHours, 120);
  });

  test('last month drops a report the mover no longer owes', () async {
    // The usage card compares self-entered against admin-entered reports; an
    // entry that counts for nobody would skew that split.
    final month = monthKey(addMonths(DateTime.now(), -1));
    final db = FakeFirebaseFirestore();
    final entries = db.collection('reports').doc(month).collection('entries');
    await entries.doc('here').set(
        MinistryReport(month: month, participated: true).toJson());
    await entries.doc('gone').set(MinistryReport(
      month: month,
      participated: true,
      enteredBy: 'admin-uid',
    ).toJson());

    final container = containerWith(db, [
      const Publisher(id: 'here', firstName: 'Here'),
      Publisher(
        id: 'gone',
        firstName: 'Gone',
        moved: true,
        movedDate: '$month-02',
      ),
    ]);
    final reports = await lastMonthReports(container);

    expect(reports.map((r) => r.publisherId), ['here']);
  });
}
