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
      seriesDate: '2026-08-08',
      location: 'Town square',
      recurringId: 'rule1',
    );

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = PwRepository(db);
    });

    Future<List<String>> applicationIds() async {
      final snap = await db.collection('pw_applications').get();
      return snap.docs.map((d) => d.id).toList()..sort();
    }

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

    test('watchApplicationsForSlots groups by slot, moved slots included',
        () async {
      // The applicants' denormalized date says 2026-08-08, but an admin has
      // since moved the slot to another week. Keying on the slot id is what
      // keeps the badge with the slot.
      await repo.applyForSlot(slot, 'uid-1');
      await repo.applyForSlot(slot, 'uid-2');
      await repo.applyForSlot(
          slot.copyWith(id: 'other', date: '2026-09-01'), 'uid-1');

      final bySlot =
          await repo.watchApplicationsForSlots(['rule1_2026-08-08']).first;

      expect(bySlot.keys, ['rule1_2026-08-08']);
      expect(bySlot['rule1_2026-08-08']!.map((a) => a.publisherId).toList()
        ..sort(), ['uid-1', 'uid-2']);
    });

    test('watchApplicationsForSlots is empty for no slots', () async {
      await repo.applyForSlot(slot, 'uid-1');
      expect(await repo.watchApplicationsForSlots(const []).first, isEmpty);
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

      expect((await db.collection('pw_slots').doc('one-off').get()).exists,
          isFalse);
      expect(await applicationIds(), isEmpty);
    });

    test('cancelling a recurring occurrence withdraws its applications',
        () async {
      // The occurrence no longer happens, so the volunteering for it means
      // nothing — and leaving it would restore the old applicants if the
      // occurrence were ever brought back.
      await db.collection('pw_slots').doc(slot.id).set(slot.toJson());
      await repo.applyForSlot(slot, 'uid-1');

      await repo.deleteSlot(slot);

      final slotDoc = await db.collection('pw_slots').doc(slot.id).get();
      expect(slotDoc.data()!['cancelled'], isTrue);
      expect(await applicationIds(), isEmpty);
    });
  });

  group('PwRepository applications through rule changes', () {
    late FakeFirebaseFirestore db;
    late PwRepository repo;
    final today = DateTime(2026, 7, 16); // a Thursday

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = PwRepository(db);
    });

    Future<List<String>> applicationIds() async {
      final snap = await db.collection('pw_applications').get();
      return snap.docs.map((d) => d.id).toList()..sort();
    }

    Future<void> apply(String slotId, String date, String uid) =>
        db.collection('pw_applications').doc('${slotId}_$uid').set({
          'slotId': slotId,
          'date': date,
          'publisherId': uid,
        });

    test('compacting a materialized copy keeps its applications attached',
        () async {
      // The document goes, but the rule renders the same occurrence under the
      // very same id — which is the id the application is keyed to.
      const rule = PwRecurring(
        weekday: DateTime.saturday,
        startTime: '09:00',
        location: 'Square',
        validFrom: '2026-07-01',
      );
      await db.collection('pw_recurring').doc('r1').set(rule.toJson());
      await db.collection('pw_slots').doc('r1_2026-08-01').set(
          PwSlot.fromRule(rule.copyWith(id: 'r1'), '2026-08-01')
              .copyWith(seriesDate: '')
              .toJson());
      await apply('r1_2026-08-01', '2026-08-01', 'uid-1');

      await repo.repairAndCompact(now: today);

      expect((await db.collection('pw_slots').get()).docs, isEmpty);
      expect(await applicationIds(), ['r1_2026-08-01_uid-1']);
    });

    test('the repair pass sweeps a future application naming nothing',
        () async {
      await apply('gone_2026-08-01', '2026-08-01', 'uid-1');

      await repo.repairAndCompact(now: today);

      expect(await applicationIds(), isEmpty);
    });

    test('the repair pass keeps a past application, whatever became of it',
        () async {
      // Who actually volunteered is history and is never rewritten.
      await apply('gone_2026-06-06', '2026-06-06', 'uid-1');

      await repo.repairAndCompact(now: today);

      expect(await applicationIds(), ['gone_2026-06-06_uid-1']);
    });

    test('the repair pass keeps an application its rule still expands',
        () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.saturday,
            validFrom: '2026-07-01',
          ).toJson());
      await apply('r1_2026-08-01', '2026-08-01', 'uid-1');

      await repo.repairAndCompact(now: today);

      expect(await applicationIds(), ['r1_2026-08-01_uid-1']);
    });

    test('the repair pass sweeps applications for a cancelled occurrence',
        () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.saturday,
            validFrom: '2026-07-01',
          ).toJson());
      await db.collection('pw_slots').doc('r1_2026-08-01').set(const PwSlot(
            date: '2026-08-01',
            seriesDate: '2026-08-01',
            recurringId: 'r1',
            cancelled: true,
          ).toJson());
      await apply('r1_2026-08-01', '2026-08-01', 'uid-1');

      await repo.repairAndCompact(now: today);

      expect(await applicationIds(), isEmpty);
    });

    test('deleting a rule keeps applications on frozen past occurrences',
        () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.thursday,
            location: 'Square',
            validFrom: '2026-07-01',
          ).toJson());
      await apply('r1_2026-07-09', '2026-07-09', 'uid-1');

      await repo.deleteRecurring('r1', now: today);

      expect(await applicationIds(), ['r1_2026-07-09_uid-1'],
          reason: 'the frozen slot kept its id, so the record still resolves');
      final frozen = await db.collection('pw_slots').doc('r1_2026-07-09').get();
      expect(frozen.exists, isTrue);
    });

    test('deleting a rule drops applications on plain future occurrences',
        () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.thursday,
            validFrom: '2026-07-16',
          ).toJson());
      await db.collection('pw_slots').doc('r1_2026-07-23').set(const PwSlot(
            date: '2026-07-23',
            seriesDate: '2026-07-23',
            recurringId: 'r1',
          ).toJson());
      await apply('r1_2026-07-23', '2026-07-23', 'uid-1');

      await repo.deleteRecurring('r1', now: today);

      expect(await applicationIds(), isEmpty);
    });

    test('deleting a rule keeps applications on a detached occurrence',
        () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.thursday,
            startTime: '09:30',
            location: 'Square',
            validFrom: '2026-07-16',
          ).toJson());
      await db.collection('pw_slots').doc('r1_2026-07-23').set(const PwSlot(
            date: '2026-07-23',
            seriesDate: '2026-07-23',
            startTime: '18:00',
            recurringId: 'r1',
            overrides: ['startTime'],
          ).toJson());
      await apply('r1_2026-07-23', '2026-07-23', 'uid-1');

      await repo.deleteRecurring('r1', now: today);

      expect(await applicationIds(), ['r1_2026-07-23_uid-1'],
          reason: 'detaching in place keeps admin work and its applicants');
    });

    test('deleteFromWeek withdraws applications from that week on', () async {
      await apply('kept_2026-07-11', '2026-07-11', 'uid-1');
      await apply('removed_2026-07-18', '2026-07-18', 'uid-1');

      await repo.deleteFromWeek('2026-07-13', now: today);

      expect(await applicationIds(), ['kept_2026-07-11_uid-1']);
    });

    test('deleteFromWeek withdraws applications for a moved slot it removes',
        () async {
      // The application carries the date it was applied for; the slot has
      // since been moved into the deleted range.
      await db.collection('pw_slots').doc('r1_2026-07-04').set(const PwSlot(
            date: '2026-07-20',
            seriesDate: '2026-07-04',
            recurringId: 'r1',
            overrides: ['date'],
          ).toJson());
      await apply('r1_2026-07-04', '2026-07-04', 'uid-1');

      await repo.deleteFromWeek('2026-07-13', now: today);

      expect(await applicationIds(), isEmpty);
    });
  });
}
