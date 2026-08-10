import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/s1_report/s1_calculator.dart';
import 'package:congregation_scheduler/features/s1_report/s1_screen.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Deleting a publisher record must not rewrite a month that has been handed
/// in. The record carries the moving date; the report entries it speaks for
/// outlive it, so the departure is kept at `former_publishers/{id}` and goes
/// on excluding exactly what it excluded before.
void main() {
  const month = '2026-06';

  /// Anna reported May and June, then moved on 15 June: June is the new
  /// congregation's month, May is ours.
  Future<FakeFirebaseFirestore> seed() async {
    final db = FakeFirebaseFirestore();
    for (final m in const ['2026-05', month]) {
      await db
          .collection('reports')
          .doc(m)
          .collection('entries')
          .doc('p1')
          .set(MinistryReport(month: m, participated: true, bibleStudies: 2)
              .toJson());
    }
    return db;
  }

  /// Both providers are overridden rather than seeded: they are gated on the
  /// signed-in user (verified / with a role), and there is no auth here.
  Future<S1Result> s1For(
    FakeFirebaseFirestore db, {
    List<Publisher> publishers = const [],
    List<FormerPublisher> former = const [],
    String on = month,
  }) {
    final container = ProviderContainer(
      overrides: [
        firestoreProvider.overrideWithValue(db),
        allPublishersProvider.overrideWith((ref) => Stream.value(publishers)),
        formerPublishersProvider.overrideWith((ref) => Stream.value(former)),
      ],
    );
    addTearDown(container.dispose);
    return container.read(s1ResultProvider(on).future);
  }

  group('the S-1 after the record is gone', () {
    test('a departure kept as a tombstone still drops the move month',
        () async {
      final db = await seed();
      // Exactly what the roster said before the record was deleted.
      final before = await s1For(db, publishers: [
        const Publisher(
            id: 'p1', firstName: 'Anna', moved: true, movedDate: '$month-15'),
      ]);
      final after = await s1For(db, former: const [
        FormerPublisher(id: 'p1', movedDate: '$month-15'),
      ]);

      expect(before.publishers.count, 0);
      expect(after.publishers.count, before.publishers.count);
      expect(after.publishers.studies, 0);
      expect(after.activePublishers, 0);
    });

    test('the months before the move still count in full', () async {
      final may = await s1For(await seed(),
          former: const [FormerPublisher(id: 'p1', movedDate: '$month-15')],
          on: '2026-05');

      expect(may.publishers.count, 1);
      expect(may.publishers.studies, 2);
      expect(may.activePublishers, 1);
    });

    test('a deletion with no departure recorded leaves the month alone',
        () async {
      // Nothing says the person left — they may just have been tidied off the
      // roster — so a filed month must not lose the number.
      final result = await s1For(await seed());

      expect(result.publishers.count, 1);
      expect(result.publishers.studies, 2);
      expect(result.activePublishers, 1);
    });

    test('a dateless departure counts in no month at all', () async {
      // Mirrors a record archived before the date existed: there is no month
      // to draw the line at, so none of their reports can be claimed.
      final db = await seed();
      const former = [FormerPublisher(id: 'p1')];
      expect((await s1For(db, former: former)).publishers.count, 0);
      expect(
          (await s1For(db, former: former, on: '2026-05')).publishers.count, 0);
    });

    test('a tombstone says nothing about anybody else', () async {
      final db = await seed();
      await db
          .collection('reports')
          .doc(month)
          .collection('entries')
          .doc('p2')
          .set(const MinistryReport(month: month, participated: true).toJson());

      final result = await s1For(db,
          former: const [FormerPublisher(id: 'p1', movedDate: '$month-15')]);

      expect(result.publishers.count, 1);
    });
  });

  group('writing the tombstone', () {
    const anna = Publisher(
        id: 'p1', firstName: 'Anna', moved: true, movedDate: '2026-06-15');

    Future<Map<String, dynamic>?> tombstone(
            FakeFirebaseFirestore db, String id) async =>
        (await db.collection('former_publishers').doc(id).get()).data();

    test('deleting a moved record keeps its departure', () async {
      final db = FakeFirebaseFirestore();
      await db.collection('publishers').doc('p1').set(anna.toJson());
      await PublishersRepository(db).delete('p1');

      expect((await db.collection('publishers').doc('p1').get()).exists,
          isFalse);
      final kept = await tombstone(db, 'p1');
      expect(kept, isNotNull);
      expect(kept!['movedDate'], '2026-06-15');
      expect(kept['moved'], isTrue);
      // The point of deleting is that the person is gone: no name, nothing
      // personal, only what the S-1 needs.
      expect(kept.keys, unorderedEquals(['moved', 'movedDate', 'deletedAt']));
    });

    test('deleting a member who never moved keeps nothing', () async {
      final db = FakeFirebaseFirestore();
      await db
          .collection('publishers')
          .doc('p2')
          .set(const Publisher(id: 'p2', firstName: 'Petr').toJson());
      await PublishersRepository(db).delete('p2');

      expect(await tombstone(db, 'p2'), isNull);
    });

    test('a departure without a date is kept as such', () async {
      final db = FakeFirebaseFirestore();
      await db.collection('publishers').doc('p3').set(
          const Publisher(id: 'p3', firstName: 'Eva', moved: true).toJson());
      await PublishersRepository(db).delete('p3');

      final kept = await tombstone(db, 'p3');
      expect(kept, isNotNull);
      expect(kept!.containsKey('movedDate'), isFalse);
    });

    test('registering again on the same uid clears the old departure',
        () async {
      // Someone who deleted their account and comes back arrives on the very
      // same auth uid; the old departure would silently drop their new
      // reports from the S-1.
      final db = FakeFirebaseFirestore();
      final repo = PublishersRepository(db);
      await db.collection('publishers').doc('uid-1').set(anna.toJson());
      await repo.delete('uid-1');
      expect(await tombstone(db, 'uid-1'), isNotNull);

      await repo.createWithId(
          'uid-1', const Publisher(firstName: 'Anna', lastName: 'Novak'));

      expect(await tombstone(db, 'uid-1'), isNull);
    });

    test('watchFormer reads the departures back with their ids', () async {
      final db = FakeFirebaseFirestore();
      await db.collection('publishers').doc('p1').set(anna.toJson());
      await PublishersRepository(db).delete('p1');

      final former = await PublishersRepository(db).watchFormer().first;
      expect(former.single.id, 'p1');
      expect(former.single.onRosterInMonth('2026-05'), isTrue);
      expect(former.single.onRosterInMonth('2026-06'), isFalse);
    });
  });
}
