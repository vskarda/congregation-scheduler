import 'package:congregation_scheduler/core/data/pw_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('docId concatenates slot id and uid', () {
    expect(PwApplication.docId('rule1_2026-08-08', 'uid-1'),
        'rule1_2026-08-08_uid-1');
  });

  test('JSON round-trip excludes the id field', () {
    const app = PwApplication(
      id: 'doc-id',
      slotId: 's1',
      date: '2026-08-08',
      publisherId: 'uid-1',
    );
    final json = app.toJson();
    expect(json.containsKey('id'), isFalse);
    expect(PwApplication.fromJson(json).id, '');
    expect(PwApplication.fromJson(json).slotId, 's1');
  });

  group('PwRepository applications', () {
    late FakeFirebaseFirestore db;
    late PwRepository repo;

    const slot = PwSlot(
      id: 'rule1_2026-08-08',
      date: '2026-08-08',
      location: 'Town square',
      recurringId: 'rule1',
    );

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = PwRepository(db);
    });

    test('applyForSlot writes a deterministic doc; withdraw removes it',
        () async {
      await repo.applyForSlot(slot, 'uid-1');
      final doc = await db
          .collection('pw_applications')
          .doc('rule1_2026-08-08_uid-1')
          .get();
      expect(doc.exists, isTrue);
      expect(doc.data()!['slotId'], 'rule1_2026-08-08');
      expect(doc.data()!['date'], '2026-08-08');
      expect(doc.data()!['publisherId'], 'uid-1');

      await repo.withdrawApplication(slot.id, 'uid-1');
      final gone = await db
          .collection('pw_applications')
          .doc('rule1_2026-08-08_uid-1')
          .get();
      expect(gone.exists, isFalse);
    });

    test('watchMyApplications returns only the given publisher', () async {
      await repo.applyForSlot(slot, 'uid-1');
      await repo.applyForSlot(slot, 'uid-2');
      final mine = await repo.watchMyApplications('uid-1').first;
      expect(mine.map((a) => a.publisherId), ['uid-1']);
      expect(mine.single.id, 'rule1_2026-08-08_uid-1');
    });

    test('watchApplicationsInRange filters by date', () async {
      await repo.applyForSlot(slot, 'uid-1');
      await repo.applyForSlot(
          slot.copyWith(id: 'other', date: '2026-09-01'), 'uid-1');
      final week =
          await repo.watchApplicationsInRange('2026-08-03', '2026-08-09').first;
      expect(week.map((a) => a.slotId), ['rule1_2026-08-08']);
    });

    test('getApplicationsForSlot sorts oldest application first', () async {
      await db.collection('pw_applications').doc('s1_late').set({
        'slotId': 's1',
        'date': '2026-08-08',
        'publisherId': 'late',
        'appliedAt': DateTime(2026, 7, 2),
      });
      await db.collection('pw_applications').doc('s1_early').set({
        'slotId': 's1',
        'date': '2026-08-08',
        'publisherId': 'early',
        'appliedAt': DateTime(2026, 7, 1),
      });
      final apps = await repo.getApplicationsForSlot('s1');
      expect(apps.map((a) => a.publisherId), ['early', 'late']);
    });

    test('deleting a one-off slot removes its applications', () async {
      const oneOff = PwSlot(id: 'one-off', date: '2026-08-08');
      await db.collection('pw_slots').doc(oneOff.id).set(oneOff.toJson());
      await repo.applyForSlot(oneOff, 'uid-1');

      await repo.deleteSlot(oneOff);

      expect(
          (await db.collection('pw_slots').doc('one-off').get()).exists,
          isFalse);
      expect(
          (await db.collection('pw_applications').doc('one-off_uid-1').get())
              .exists,
          isFalse);
    });

    test('cancelling a recurring instance keeps its applications', () async {
      await db.collection('pw_slots').doc(slot.id).set(slot.toJson());
      await repo.applyForSlot(slot, 'uid-1');

      await repo.deleteSlot(slot);

      final slotDoc = await db.collection('pw_slots').doc(slot.id).get();
      expect(slotDoc.data()!['cancelled'], isTrue);
      expect(
          (await db
                  .collection('pw_applications')
                  .doc('rule1_2026-08-08_uid-1')
                  .get())
              .exists,
          isTrue);
    });
  });
}
