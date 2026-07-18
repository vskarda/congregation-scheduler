import 'package:congregation_scheduler/core/data/fsm_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FsmRepository.materializedDates', () {
    test('emits the rule weekday between from and until', () {
      const rule = FsmRecurring(id: 'r1', weekday: DateTime.saturday);
      final dates = FsmRepository.materializedDates(
          rule, DateTime(2026, 7, 7), DateTime(2026, 8, 4));
      expect(dates, ['2026-07-11', '2026-07-18', '2026-07-25', '2026-08-01']);
    });

    test('starts on from itself when it matches the weekday', () {
      const rule = FsmRecurring(id: 'r1', weekday: DateTime.tuesday);
      final dates = FsmRepository.materializedDates(
          rule, DateTime(2026, 7, 7), DateTime(2026, 7, 22));
      expect(dates, ['2026-07-07', '2026-07-14', '2026-07-21']);
    });

    test('respects validFrom and validUntil', () {
      const rule = FsmRecurring(
        id: 'r1',
        weekday: DateTime.saturday,
        validFrom: '2026-07-15',
        validUntil: '2026-07-31',
      );
      final dates = FsmRepository.materializedDates(
          rule, DateTime(2026, 7, 1), DateTime(2026, 9, 1));
      expect(dates, ['2026-07-18', '2026-07-25']);
    });

    test('is empty when the rule expired', () {
      const rule = FsmRecurring(
          id: 'r1', weekday: DateTime.saturday, validUntil: '2026-06-30');
      final dates = FsmRepository.materializedDates(
          rule, DateTime(2026, 7, 7), DateTime(2026, 9, 1));
      expect(dates, isEmpty);
    });
  });

  group('FsmRepository.mergeWithRules', () {
    // Week Monday 2026-07-06 .. Sunday 2026-07-12 (until is exclusive).
    final monday = DateTime(2026, 7, 6);
    final until = DateTime(2026, 7, 13);

    const rule = FsmRecurring(
      id: 'r1',
      weekday: DateTime.saturday, // 2026-07-11
      time: '09:00',
      location: 'Kingdom Hall',
      note: 'Bring the carts',
      defaultAssignment: Assignment(publisherIds: ['p1']),
    );

    test('expands a virtual instance with the deterministic id', () {
      final merged =
          FsmRepository.mergeWithRules(const [], [rule], monday, until);
      expect(merged, hasLength(1));
      final meeting = merged.single;
      expect(meeting.id, 'r1_2026-07-11');
      expect(meeting.date, '2026-07-11');
      expect(meeting.time, '09:00');
      expect(meeting.location, 'Kingdom Hall');
      expect(meeting.note, 'Bring the carts');
      expect(meeting.recurringId, 'r1');
      expect(meeting.assignment.publisherIds, ['p1']);
      expect(meeting.allAssigneeIds, ['p1']);
    });

    test('expands past weeks too', () {
      final merged = FsmRepository.mergeWithRules(
          const [], [rule], DateTime(2026, 6, 1), DateTime(2026, 6, 8));
      expect(merged.map((m) => m.date), ['2026-06-06']);
    });

    test('a concrete edited instance wins over the virtual one', () {
      const edited = FsmMeeting(
        id: 'r1_2026-07-11',
        date: '2026-07-11',
        time: '10:00',
        location: 'Kingdom Hall',
        recurringId: 'r1',
      );
      final merged =
          FsmRepository.mergeWithRules(const [edited], [rule], monday, until);
      expect(merged, hasLength(1));
      expect(merged.single.time, '10:00');
    });

    test('a cancelled instance suppresses the virtual one and is hidden', () {
      const cancelled = FsmMeeting(
        id: 'r1_2026-07-11',
        date: '2026-07-11',
        recurringId: 'r1',
        cancelled: true,
      );
      final merged = FsmRepository.mergeWithRules(
          const [cancelled], [rule], monday, until);
      expect(merged, isEmpty);
    });

    test('one-off meetings pass through and the result is sorted', () {
      const oneOff = FsmMeeting(
        id: 'x1',
        date: '2026-07-11',
        time: '07:00',
        location: 'Station',
      );
      const earlier = FsmMeeting(
        id: 'x2',
        date: '2026-07-08',
        time: '15:00',
        location: 'Park',
      );
      final merged = FsmRepository.mergeWithRules(
          const [oneOff, earlier], [rule], monday, until);
      expect(merged.map((m) => m.id), ['x2', 'x1', 'r1_2026-07-11']);
    });

    test('respects the rule validity window', () {
      const limited = FsmRecurring(
        id: 'r1',
        weekday: DateTime.saturday,
        validUntil: '2026-07-10',
      );
      final merged =
          FsmRepository.mergeWithRules(const [], [limited], monday, until);
      expect(merged, isEmpty);
    });
  });

  group('FsmRepository.deleteRecurring', () {
    late FakeFirebaseFirestore db;
    late FsmRepository repo;
    final today = DateTime(2026, 7, 16);

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = FsmRepository(db);
    });

    test('deletes the rule and only its own future instances', () async {
      await db.collection('fsm_recurring').doc('r1').set(
          const FsmRecurring(weekday: DateTime.thursday).toJson());
      await db
          .collection('fsm_meetings')
          .doc('r1_2026-07-09')
          .set({'date': '2026-07-09', 'recurringId': 'r1'}); // past, kept
      await db
          .collection('fsm_meetings')
          .doc('r1_2026-07-23')
          .set({'date': '2026-07-23', 'recurringId': 'r1'}); // future, removed
      await db.collection('fsm_meetings').doc('other_2026-08-01').set(
          {'date': '2026-08-01', 'recurringId': 'other'}); // other rule

      await repo.deleteRecurring('r1', now: today);

      expect((await db.collection('fsm_recurring').doc('r1').get()).exists,
          isFalse);
      expect(
          (await db.collection('fsm_meetings').doc('r1_2026-07-09').get())
              .exists,
          isTrue);
      expect(
          (await db.collection('fsm_meetings').doc('r1_2026-07-23').get())
              .exists,
          isFalse);
      expect(
          (await db.collection('fsm_meetings').doc('other_2026-08-01').get())
              .exists,
          isTrue);
    });
  });

  group('FsmRepository.deleteAllFutureMeetings', () {
    late FakeFirebaseFirestore db;
    late FsmRepository repo;
    final today = DateTime(2026, 7, 16);

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = FsmRepository(db);
    });

    test('deletes every future meeting (one-off and recurring) and every rule',
        () async {
      await db.collection('fsm_recurring').doc('r1').set(
          const FsmRecurring(weekday: DateTime.thursday).toJson());
      await db
          .collection('fsm_meetings')
          .doc('r1_2026-07-09')
          .set({'date': '2026-07-09', 'recurringId': 'r1'}); // past
      await db
          .collection('fsm_meetings')
          .doc('r1_2026-07-23')
          .set({'date': '2026-07-23', 'recurringId': 'r1'}); // future, rule
      await db.collection('fsm_meetings').doc('oneoff-past').set(
          {'date': '2026-07-01', 'recurringId': ''}); // past one-off
      await db.collection('fsm_meetings').doc('oneoff-future').set(
          {'date': '2026-07-20', 'recurringId': ''}); // future one-off
      // Orphan: recurringId points at a rule that no longer exists.
      await db.collection('fsm_meetings').doc('orphan_2026-08-01').set(
          {'date': '2026-08-01', 'recurringId': 'gone'});

      await repo.deleteAllFutureMeetings(now: today);

      expect((await db.collection('fsm_recurring').doc('r1').get()).exists,
          isFalse);
      expect(
          (await db.collection('fsm_meetings').doc('r1_2026-07-09').get())
              .exists,
          isTrue);
      expect(
          (await db.collection('fsm_meetings').doc('r1_2026-07-23').get())
              .exists,
          isFalse);
      expect(
          (await db.collection('fsm_meetings').doc('oneoff-past').get())
              .exists,
          isTrue);
      expect(
          (await db.collection('fsm_meetings').doc('oneoff-future').get())
              .exists,
          isFalse);
      expect(
          (await db
                  .collection('fsm_meetings')
                  .doc('orphan_2026-08-01')
                  .get())
              .exists,
          isFalse);
    });
  });
}
