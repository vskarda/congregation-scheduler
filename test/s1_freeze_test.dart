import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/data/s1_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/s1_report/s1_providers.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Freezing a month: the figures handed in to the branch stop moving, while
/// the reports they were computed from stay editable.
void main() {
  const month = '2026-06';

  Future<FakeFirebaseFirestore> seed() async {
    final db = FakeFirebaseFirestore();
    await db
        .collection('reports')
        .doc(month)
        .collection('entries')
        .doc('p1')
        .set(const MinistryReport(
          month: month,
          participated: true,
          bibleStudies: 2,
        ).toJson());
    await db.collection('attendance').doc('$month-02_lmm').set(
        const AttendanceEntry(
                date: '$month-02', meetingType: MeetingType.lmm, total: 50)
            .toJson());
    return db;
  }

  ProviderContainer containerFor(FakeFirebaseFirestore db) {
    final container = ProviderContainer(
      overrides: [
        firestoreProvider.overrideWithValue(db),
        allPublishersProvider.overrideWith((ref) => Stream.value(const [
              Publisher(id: 'p1', firstName: 'Anna', lastName: 'Novak',
                  verified: true),
            ])),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// Adds a second report to the month — the late arrival a frozen S-1 must
  /// ignore.
  Future<void> addLateReport(FakeFirebaseFirestore db) => db
      .collection('reports')
      .doc(month)
      .collection('entries')
      .doc('p2')
      .set(const MinistryReport(
        month: month,
        participated: true,
        bibleStudies: 7,
      ).toJson());

  test('an unfrozen month follows the reports', () async {
    final db = await seed();
    final container = containerFor(db);

    expect((await container.read(s1ResultProvider(month).future)).publishers
        .count, 1);

    await addLateReport(db);
    container.invalidate(liveS1Provider(month));
    final after = await container.read(s1ResultProvider(month).future);
    expect(after.publishers.count, 2);
    expect(after.isFrozen, isFalse);
  });

  test('freezing stores the figures and later reports no longer change them',
      () async {
    final db = await seed();
    final container = containerFor(db);
    final repo = container.read(s1RepositoryProvider);

    final live = await container.read(liveS1Provider(month).future);
    await repo.freeze(
        live.copyWith(frozenAt: DateTime(2026, 7, 5), frozenBy: 'admin1'));

    // The document holds what was handed in, not a pointer to live data.
    final stored = (await db.collection('s1_records').doc(month).get()).data()!;
    expect(stored['publishers']['count'], 1);
    expect(stored['publishers']['studies'], 2);
    expect(stored['avgMidweekAttendance'], 50);
    expect(stored['frozenBy'], 'admin1');

    await addLateReport(db);
    container.invalidate(liveS1Provider(month));
    final shown = await container.read(s1ResultProvider(month).future);

    expect(shown.publishers.count, 1, reason: 'frozen figures stand');
    expect(shown.publishers.studies, 2);
    expect(shown.isFrozen, isTrue);
    expect(shown.frozenBy, 'admin1');
    expect(shown.month, month);
    // The report itself was still recorded — freezing preserves the S-1, it
    // does not refuse the data.
    expect((await container.read(liveS1Provider(month).future)).publishers
        .count, 2);
  });

  test('unfreezing returns the month to the current reports', () async {
    final db = await seed();
    final container = containerFor(db);
    final repo = container.read(s1RepositoryProvider);

    await repo.freeze((await container.read(liveS1Provider(month).future))
        .copyWith(frozenAt: DateTime(2026, 7, 5)));
    await addLateReport(db);
    await repo.unfreeze(month);
    container.invalidate(liveS1Provider(month));

    final shown = await container.read(s1ResultProvider(month).future);
    expect(shown.isFrozen, isFalse);
    expect(shown.publishers.count, 2);
  });

  test('freezing one month leaves its neighbours live', () async {
    final db = await seed();
    final container = containerFor(db);
    await container.read(s1RepositoryProvider).freeze(
        (await container.read(liveS1Provider(month).future))
            .copyWith(frozenAt: DateTime(2026, 7, 5)));

    expect((await container.read(s1ResultProvider('2026-05').future)).isFrozen,
        isFalse);
  });

  test('the sweep bookmark is not mistaken for a month', () async {
    final db = await seed();
    final container = containerFor(db);
    final repo = container.read(s1RepositoryProvider);
    await repo.saveAutoFreezeScannedThrough(month);

    expect(await container.read(frozenS1Provider.future), isEmpty);
    expect(await repo.autoFreezeScannedThrough(), month);
  });

  test('only ended months can be frozen', () {
    expect(s1CanFreeze('2026-06', DateTime(2026, 7, 1)), isTrue);
    expect(s1CanFreeze('2026-07', DateTime(2026, 7, 15)), isFalse,
        reason: 'the current month is still collecting reports');
    expect(s1CanFreeze('2026-08', DateTime(2026, 7, 15)), isFalse);
  });
}
