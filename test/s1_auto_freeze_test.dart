import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/data/s1_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/features/s1_report/s1_auto_freeze.dart';
import 'package:congregation_scheduler/features/s1_report/s1_providers.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The sweep that freezes months nobody got around to freezing. It rides along
/// with an admin opening the S-1 screen — there are no Cloud Functions here —
/// so everything about it has to stay cheap and predictable.
void main() {
  final aged = monthKey(addMonths(DateTime.now(), -kS1FreezeAfterMonths));
  final recent = monthKey(addMonths(DateTime.now(), -1));
  final older = monthKey(addMonths(DateTime.now(), -kS1FreezeAfterMonths - 1));

  const admin = Publisher(
    id: 'admin1',
    firstName: 'Admin',
    lastName: 'One',
    verified: true,
    roles: Roles(reports: true),
  );

  Future<void> report(FakeFirebaseFirestore db, String month, String id) => db
      .collection('reports')
      .doc(month)
      .collection('entries')
      .doc(id)
      .set(MinistryReport(month: month, participated: true, bibleStudies: 1)
          .toJson());

  /// The sweep expects what the app shell guarantees: the signed-in
  /// publisher document already loaded.
  Future<ProviderContainer> containerFor(FakeFirebaseFirestore db,
      {Publisher me = admin}) async {
    await db.collection('publishers').doc(me.id).set(me.toJson());
    final container = ProviderContainer(
      overrides: [
        firestoreProvider.overrideWithValue(db),
        myPublisherProvider.overrideWith((ref) => Stream.value(me)),
      ],
    );
    addTearDown(container.dispose);
    container.listen(myPublisherProvider, (_, _) {});
    await container.read(myPublisherProvider.future);
    return container;
  }

  Future<Set<String>> frozenMonths(FakeFirebaseFirestore db) async {
    final snap = await db.collection('s1_records').get();
    return {
      for (final d in snap.docs)
        if (d.id != S1Repository.autoFreezeDocId) d.id,
    };
  }

  test('freezes months past the threshold and leaves newer ones alone',
      () async {
    final db = FakeFirebaseFirestore();
    await report(db, older, 'p1');
    await report(db, aged, 'p1');
    await report(db, recent, 'p1');
    final container = await containerFor(db);

    expect(await container.read(s1AutoFreezeProvider.future), 2);
    expect(await frozenMonths(db), {older, aged});
    expect(await container.read(s1RepositoryProvider).autoFreezeScannedThrough(),
        aged);

    // The frozen figures are the real ones, not placeholders.
    final stored = await container.read(s1ResultProvider(aged).future);
    expect(stored.isFrozen, isTrue);
    expect(stored.auto, isTrue);
    expect(stored.publishers.count, 1);
    expect(stored.publishers.studies, 1);
  });

  test('a month with no reports and no attendance is skipped, not zeroed',
      () async {
    // A congregation that imports its S-21 history later must still get real
    // figures for those months.
    final db = FakeFirebaseFirestore();
    await report(db, aged, 'p1');
    final container = await containerFor(db);

    expect(await container.read(s1AutoFreezeProvider.future), 1);
    expect(await frozenMonths(db), {aged});
  });

  test('the second run has nothing left to do', () async {
    final db = FakeFirebaseFirestore();
    await report(db, aged, 'p1');
    expect(await (await containerFor(db)).read(s1AutoFreezeProvider.future), 1);

    // A late report for the same month arrives; the sweep must not re-freeze
    // over the figures already stored.
    await report(db, aged, 'p2');
    expect(await (await containerFor(db)).read(s1AutoFreezeProvider.future), 0);
    final stored =
        await (await containerFor(db)).read(s1ResultProvider(aged).future);
    expect(stored.publishers.count, 1);
  });

  test('a month frozen by hand is never overwritten', () async {
    final db = FakeFirebaseFirestore();
    await report(db, aged, 'p1');
    final container = await containerFor(db);
    await container.read(s1RepositoryProvider).freeze(S1Record(
          month: aged,
          activePublishers: 99,
          frozenAt: DateTime(2026),
          frozenBy: 'admin1',
        ));

    expect(await container.read(s1AutoFreezeProvider.future), 0);
    final stored = await container.read(s1ResultProvider(aged).future);
    expect(stored.activePublishers, 99);
    expect(stored.auto, isFalse);
  });

  test('the backfill reaches no further than its window', () async {
    final db = FakeFirebaseFirestore();
    final ancient = monthKey(addMonths(
        parseMonthKey(aged), -kS1AutoFreezeBackfillMonths));
    await report(db, ancient, 'p1');
    await report(db, aged, 'p1');
    final container = await containerFor(db);

    expect(await container.read(s1AutoFreezeProvider.future), 1);
    expect(await frozenMonths(db), {aged},
        reason: 'a congregation with years of history is not read in full');
  });

  test('someone without the reports role sweeps nothing', () async {
    final db = FakeFirebaseFirestore();
    await report(db, aged, 'p1');
    final container = await containerFor(db,
        me: const Publisher(
            id: 'p9', firstName: 'Plain', lastName: 'Publisher',
            verified: true));

    expect(await container.read(s1AutoFreezeProvider.future), 0);
    expect(await frozenMonths(db), isEmpty);
  });
}
