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

  group('FsmRepository.producesOn', () {
    const rule = FsmRecurring(id: 'r1', weekday: DateTime.saturday);

    test('is true only on the rule weekday', () {
      expect(FsmRepository.producesOn(rule, '2026-07-11'), isTrue);
      expect(FsmRepository.producesOn(rule, '2026-07-12'), isFalse);
    });

    test('is false outside the validity window', () {
      const limited = FsmRecurring(
        id: 'r1',
        weekday: DateTime.saturday,
        validFrom: '2026-07-15',
        validUntil: '2026-07-31',
      );
      expect(FsmRepository.producesOn(limited, '2026-07-11'), isFalse);
      expect(FsmRepository.producesOn(limited, '2026-07-18'), isTrue);
      expect(FsmRepository.producesOn(limited, '2026-08-01'), isFalse);
    });

    test('is false for an unparseable date', () {
      expect(FsmRepository.producesOn(rule, ''), isFalse);
    });
  });

  group('FsmRepository.runsBefore', () {
    test('a rule without validFrom has always run', () {
      const rule = FsmRecurring(id: 'r1', weekday: DateTime.saturday);
      expect(FsmRepository.runsBefore(rule, DateTime(2026, 7, 13)), isTrue);
    });

    test('is false when the first occurrence is on or after the cut-off', () {
      const rule = FsmRecurring(
          id: 'r1', weekday: DateTime.saturday, validFrom: '2026-07-13');
      expect(FsmRepository.runsBefore(rule, DateTime(2026, 7, 13)), isFalse);
    });

    test('is true when it already ran, even if it has since ended', () {
      const rule = FsmRecurring(
        id: 'r1',
        weekday: DateTime.saturday,
        validFrom: '2026-06-01',
        validUntil: '2026-06-30',
      );
      expect(FsmRepository.runsBefore(rule, DateTime(2026, 7, 13)), isTrue);
    });
  });

  group('FsmRepository.expand', () {
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

    test('expands an occurrence with the deterministic id', () {
      final merged =
          FsmRepository.expand(const [], const [], [rule], monday, until);
      expect(merged, hasLength(1));
      final meeting = merged.single;
      expect(meeting.id, 'r1_2026-07-11');
      expect(meeting.date, '2026-07-11');
      expect(meeting.seriesDate, '2026-07-11');
      expect(meeting.time, '09:00');
      expect(meeting.location, 'Kingdom Hall');
      expect(meeting.note, 'Bring the carts');
      expect(meeting.recurringId, 'r1');
      expect(meeting.assignment.publisherIds, ['p1']);
      expect(meeting.allAssigneeIds, ['p1']);
    });

    test('expands past weeks too', () {
      final merged = FsmRepository.expand(
          const [], const [], [rule], DateTime(2026, 6, 1), DateTime(2026, 6, 8));
      expect(merged.map((m) => m.date), ['2026-06-06']);
    });

    test('an exception overriding one field still follows the rule for the '
        'others', () {
      const edited = FsmMeeting(
        id: 'r1_2026-07-11',
        date: '2026-07-11',
        seriesDate: '2026-07-11',
        time: '10:00',
        location: 'stale copy of an older rule',
        note: 'stale copy of an older rule',
        recurringId: 'r1',
        overrides: ['time'],
      );
      final merged =
          FsmRepository.expand(const [edited], const [], [rule], monday, until);
      expect(merged, hasLength(1));
      expect(merged.single.time, '10:00', reason: 'the override wins');
      expect(merged.single.location, 'Kingdom Hall',
          reason: 'everything else follows the rule');
      expect(merged.single.note, 'Bring the carts');
      expect(merged.single.assignment.publisherIds, ['p1']);
    });

    test('a customized conductor survives a later rule edit', () {
      const edited = FsmMeeting(
        id: 'r1_2026-07-11',
        date: '2026-07-11',
        seriesDate: '2026-07-11',
        assignment: Assignment(publisherIds: ['p9']),
        recurringId: 'r1',
        overrides: ['assignment'],
      );
      final merged =
          FsmRepository.expand(const [edited], const [], [rule], monday, until);
      expect(merged.single.assignment.publisherIds, ['p9']);
      expect(merged.single.allAssigneeIds, ['p9']);
      expect(merged.single.location, 'Kingdom Hall');
    });

    test('a cancelled occurrence is suppressed and hidden', () {
      const cancelled = FsmMeeting(
        id: 'r1_2026-07-11',
        date: '2026-07-11',
        seriesDate: '2026-07-11',
        recurringId: 'r1',
        cancelled: true,
      );
      final merged = FsmRepository.expand(
          const [cancelled], const [cancelled], [rule], monday, until);
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
      final merged = FsmRepository.expand(
          const [oneOff, earlier], const [], [rule], monday, until);
      expect(merged.map((m) => m.id), ['x2', 'x1', 'r1_2026-07-11']);
    });

    test('respects the rule validity window', () {
      const limited = FsmRecurring(
        id: 'r1',
        weekday: DateTime.saturday,
        validUntil: '2026-07-10',
      );
      final merged =
          FsmRepository.expand(const [], const [], [limited], monday, until);
      expect(merged, isEmpty);
    });

    test('an occurrence moved to another week leaves no twin behind', () {
      // Moved from Saturday 07-11 to Tuesday 07-14, i.e. the following week.
      const moved = FsmMeeting(
        id: 'r1_2026-07-11',
        date: '2026-07-14',
        seriesDate: '2026-07-11',
        time: '09:00',
        recurringId: 'r1',
        overrides: ['date'],
      );

      // Source week: the slot is claimed even though nothing happens here.
      final source =
          FsmRepository.expand(const [], const [moved], [rule], monday, until);
      expect(source, isEmpty);

      // Target week: the moved occurrence shows, and that week's own
      // Saturday occurrence is expanded as usual.
      final target = FsmRepository.expand(const [moved], const [], [rule],
          DateTime(2026, 7, 13), DateTime(2026, 7, 20));
      expect(target.map((m) => m.date), ['2026-07-14', '2026-07-18']);
      expect(target.first.location, 'Kingdom Hall',
          reason: 'a moved occurrence still follows its rule');
    });

    test('an exception whose rule is gone renders from its own fields', () {
      const orphan = FsmMeeting(
        id: 'gone_2026-07-11',
        date: '2026-07-11',
        seriesDate: '2026-07-11',
        time: '08:30',
        location: 'Old place',
        recurringId: 'gone',
      );
      final merged =
          FsmRepository.expand(const [orphan], const [], const [], monday, until);
      expect(merged, hasLength(1));
      expect(merged.single.location, 'Old place');
      expect(merged.single.time, '08:30');
    });
  });

  group('FsmRepository.repairAndCompact', () {
    late FakeFirebaseFirestore db;
    late FsmRepository repo;

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = FsmRepository(db);
    });

    Future<void> addRule(String id, FsmRecurring rule) =>
        db.collection('fsm_recurring').doc(id).set(rule.toJson());

    Future<List<FsmMeeting>> meetings() async {
      final snap = await db.collection('fsm_meetings').get();
      return snap.docs
          .map((d) => FsmMeeting.fromJson(d.data()).copyWith(id: d.id))
          .toList();
    }

    test('deletes a materialized copy that deviates in nothing', () async {
      const rule = FsmRecurring(
          weekday: DateTime.saturday, time: '09:00', location: 'Hall');
      await addRule('r1', rule);
      await db.collection('fsm_meetings').doc('r1_2026-07-11').set(
          FsmMeeting.fromRule(rule.copyWith(id: 'r1'), '2026-07-11')
              .copyWith(seriesDate: '')
              .toJson());

      await repo.repairAndCompact();

      expect(await meetings(), isEmpty,
          reason: 'the rule renders this occurrence now');
    });

    test('keeps an edited copy, recording only what deviates', () async {
      const rule = FsmRecurring(
          weekday: DateTime.saturday, time: '09:00', location: 'Hall');
      await addRule('r1', rule);
      await db.collection('fsm_meetings').doc('r1_2026-07-11').set(const
          FsmMeeting(
        date: '2026-07-11',
        time: '10:30',
        location: 'Hall',
        recurringId: 'r1',
      ).toJson());

      await repo.repairAndCompact();

      final all = await meetings();
      expect(all, hasLength(1));
      expect(all.single.id, 'r1_2026-07-11');
      expect(all.single.seriesDate, '2026-07-11', reason: 'backfilled');
      expect(all.single.overrides, ['time']);
    });

    test('backfills seriesDate from the doc id when the date was moved',
        () async {
      const rule = FsmRecurring(weekday: DateTime.saturday, time: '09:00');
      await addRule('r1', rule);
      // The old model corrupted a moved instance: doc id and date disagree.
      await db.collection('fsm_meetings').doc('r1_2026-07-11').set(const
          FsmMeeting(
        date: '2026-07-14',
        time: '09:00',
        recurringId: 'r1',
      ).toJson());

      await repo.repairAndCompact();

      final all = await meetings();
      expect(all, hasLength(1));
      expect(all.single.seriesDate, '2026-07-11');
      expect(all.single.date, '2026-07-14');
      expect(all.single.overrides, ['date'],
          reason: 'the move is now a recorded override, not corruption');
    });

    test('detaches a customized leftover of a weekday change', () async {
      // The rule moved to Sunday; the old Saturday instance was customized.
      const rule = FsmRecurring(weekday: DateTime.sunday, time: '09:00');
      await addRule('r1', rule);
      await db.collection('fsm_meetings').doc('r1_2026-07-11').set(const
          FsmMeeting(
        date: '2026-07-11',
        time: '07:15',
        location: 'Marketplace',
        recurringId: 'r1',
      ).toJson());

      await repo.repairAndCompact();

      final all = await meetings();
      expect(all, hasLength(1));
      expect(all.single.recurringId, isEmpty, reason: 'now a one-off meeting');
      expect(all.single.seriesDate, isEmpty);
      expect(all.single.location, 'Marketplace', reason: 'admin work kept');
      expect(all.single.time, '07:15');
    });

    test('deletes an uncustomized leftover of a weekday change', () async {
      const rule = FsmRecurring(weekday: DateTime.sunday, time: '09:00');
      await addRule('r1', rule);
      await db.collection('fsm_meetings').doc('r1_2026-07-11').set(const
          FsmMeeting(date: '2026-07-11', time: '09:00', recurringId: 'r1')
              .toJson());

      await repo.repairAndCompact();

      expect(await meetings(), isEmpty);
    });

    test('re-adopts an orphan into a rule that produces its date', () async {
      // Classic case: the rule was deleted and recreated with a new id.
      const rule = FsmRecurring(
          weekday: DateTime.saturday, time: '09:00', location: 'Hall');
      await addRule('r2', rule);
      await db.collection('fsm_meetings').doc('r1_2026-07-11').set(const
          FsmMeeting(
        date: '2026-07-11',
        time: '09:00',
        location: 'Hall',
        recurringId: 'r1', // r1 no longer exists
      ).toJson());

      await repo.repairAndCompact();

      expect(await meetings(), isEmpty,
          reason: 'adopted by r2, which deviates in nothing, so it is a copy');
    });

    test('turns an unadoptable orphan into a clean one-off meeting', () async {
      await db.collection('fsm_meetings').doc('gone_2026-07-11').set(const
          FsmMeeting(
        date: '2026-07-11',
        time: '09:00',
        location: 'Somewhere',
        recurringId: 'gone',
      ).toJson());

      await repo.repairAndCompact();

      final all = await meetings();
      expect(all, hasLength(1));
      expect(all.single.recurringId, isEmpty);
      expect(all.single.location, 'Somewhere');
      expect(all.single.date, '2026-07-11');
    });

    test('drops a tombstone whose rule is gone', () async {
      await db.collection('fsm_meetings').doc('gone_2026-07-11').set(const
          FsmMeeting(date: '2026-07-11', recurringId: 'gone', cancelled: true)
              .toJson());

      await repo.repairAndCompact();

      expect(await meetings(), isEmpty);
    });

    test('keeps a cancellation that its rule still expands', () async {
      const rule = FsmRecurring(weekday: DateTime.saturday, time: '09:00');
      await addRule('r1', rule);
      await db.collection('fsm_meetings').doc('r1_2026-07-11').set(const
          FsmMeeting(
        date: '2026-07-11',
        recurringId: 'r1',
        cancelled: true,
      ).toJson());

      await repo.repairAndCompact();

      final all = await meetings();
      expect(all, hasLength(1));
      expect(all.single.cancelled, isTrue);
      expect(all.single.seriesDate, '2026-07-11');
    });

    test('leaves one-off meetings alone', () async {
      await db
          .collection('fsm_meetings')
          .add(const FsmMeeting(date: '2026-07-11', location: 'Park').toJson());

      await repo.repairAndCompact();

      final all = await meetings();
      expect(all, hasLength(1));
      expect(all.single.location, 'Park');
    });

    test('is idempotent', () async {
      const rule = FsmRecurring(
          weekday: DateTime.saturday, time: '09:00', location: 'Hall');
      await addRule('r1', rule);
      await db.collection('fsm_meetings').doc('r1_2026-07-11').set(const
          FsmMeeting(
        date: '2026-07-11',
        time: '10:30',
        location: 'Hall',
        recurringId: 'r1',
      ).toJson());
      await db.collection('fsm_meetings').doc('gone_2026-06-06').set(const
          FsmMeeting(date: '2026-06-06', recurringId: 'gone').toJson());

      await repo.repairAndCompact();
      final first = await meetings();
      await repo.repairAndCompact();
      final second = await meetings();

      expect(second.map((m) => m.toJson()), first.map((m) => m.toJson()));
    });
  });

  group('FsmRepository.deleteRecurring', () {
    late FakeFirebaseFirestore db;
    late FsmRepository repo;
    final today = DateTime(2026, 7, 16); // a Thursday

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = FsmRepository(db);
    });

    Future<List<FsmMeeting>> meetings() async {
      final snap = await db.collection('fsm_meetings').get();
      return snap.docs
          .map((d) => FsmMeeting.fromJson(d.data()).copyWith(id: d.id))
          .toList();
    }

    test('freezes past occurrences into stand-alone meetings', () async {
      await db.collection('fsm_recurring').doc('r1').set(const FsmRecurring(
            weekday: DateTime.thursday,
            time: '09:30',
            location: 'Hall',
            validFrom: '2026-07-01',
          ).toJson());

      await repo.deleteRecurring('r1', now: today);

      expect((await db.collection('fsm_recurring').doc('r1').get()).exists,
          isFalse);
      final all = await meetings();
      expect(all.map((m) => m.date).toList()..sort(),
          ['2026-07-02', '2026-07-09']);
      expect(all.every((m) => m.recurringId.isEmpty), isTrue);
      expect(all.every((m) => m.location == 'Hall'), isTrue);
      expect(all.every((m) => m.time == '09:30'), isTrue);
    });

    test('drops plain future occurrences and their tombstones', () async {
      await db.collection('fsm_recurring').doc('r1').set(const FsmRecurring(
            weekday: DateTime.thursday,
            validFrom: '2026-07-16',
          ).toJson());
      await db.collection('fsm_meetings').doc('r1_2026-07-23').set(const
          FsmMeeting(
        date: '2026-07-23',
        seriesDate: '2026-07-23',
        recurringId: 'r1',
      ).toJson());
      await db.collection('fsm_meetings').doc('r1_2026-07-30').set(const
          FsmMeeting(
        date: '2026-07-30',
        seriesDate: '2026-07-30',
        recurringId: 'r1',
        cancelled: true,
      ).toJson());

      await repo.deleteRecurring('r1', now: today);

      expect(await meetings(), isEmpty);
    });

    test('detaches a customized future occurrence', () async {
      await db.collection('fsm_recurring').doc('r1').set(const FsmRecurring(
            weekday: DateTime.thursday,
            time: '09:30',
            location: 'Hall',
            validFrom: '2026-07-16',
          ).toJson());
      await db.collection('fsm_meetings').doc('r1_2026-07-23').set(const
          FsmMeeting(
        date: '2026-07-23',
        seriesDate: '2026-07-23',
        time: '18:00',
        recurringId: 'r1',
        overrides: ['time'],
      ).toJson());

      await repo.deleteRecurring('r1', now: today);

      final all = await meetings();
      expect(all, hasLength(1));
      expect(all.single.recurringId, isEmpty);
      expect(all.single.time, '18:00', reason: 'the override is kept');
      expect(all.single.location, 'Hall',
          reason: 'inherited fields are frozen before the rule goes');
    });

    test('leaves other rules and one-off meetings untouched', () async {
      await db.collection('fsm_recurring').doc('r1').set(const FsmRecurring(
            weekday: DateTime.thursday,
            validFrom: '2026-07-16',
          ).toJson());
      await db.collection('fsm_recurring').doc('r2').set(const FsmRecurring(
            weekday: DateTime.saturday,
            validFrom: '2026-07-16',
          ).toJson());
      await db.collection('fsm_meetings').doc('one-off').set(const
          FsmMeeting(date: '2026-08-01', location: 'Park').toJson());

      await repo.deleteRecurring('r1', now: today);

      expect((await db.collection('fsm_recurring').doc('r2').get()).exists,
          isTrue);
      final all = await meetings();
      expect(all, hasLength(1));
      expect(all.single.id, 'one-off');
    });
  });

  group('FsmRepository.deleteFromWeek', () {
    late FakeFirebaseFirestore db;
    late FsmRepository repo;
    final today = DateTime(2026, 7, 16);
    const cutoff = '2026-07-13'; // Monday

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = FsmRepository(db);
    });

    Future<List<String>> meetingIds() async {
      final snap = await db.collection('fsm_meetings').get();
      return snap.docs.map((d) => d.id).toList()..sort();
    }

    Future<FsmRecurring?> rule(String id) async {
      final doc = await db.collection('fsm_recurring').doc(id).get();
      return doc.exists ? FsmRecurring.fromJson(doc.data()!) : null;
    }

    test('deletes meetings from the week on and keeps earlier ones', () async {
      await db.collection('fsm_meetings').doc('before').set(
          const FsmMeeting(date: '2026-07-12', location: 'Park').toJson());
      await db.collection('fsm_meetings').doc('on-monday').set(
          const FsmMeeting(date: '2026-07-13', location: 'Park').toJson());
      await db.collection('fsm_meetings').doc('after').set(
          const FsmMeeting(date: '2026-08-20', location: 'Park').toJson());

      await repo.deleteFromWeek(cutoff, now: today);

      expect(await meetingIds(), ['before']);
    });

    test('clamps a rule that already ran before the cut-off', () async {
      await db.collection('fsm_recurring').doc('r1').set(const FsmRecurring(
            weekday: DateTime.saturday,
            validFrom: '2026-06-01',
          ).toJson());

      await repo.deleteFromWeek(cutoff, now: today);

      expect((await rule('r1'))?.validUntil, '2026-07-12',
          reason: 'the Sunday before the selected week');
    });

    test('deletes a rule that starts on or after the cut-off', () async {
      await db.collection('fsm_recurring').doc('r1').set(const FsmRecurring(
            weekday: DateTime.saturday,
            validFrom: '2026-07-13',
          ).toJson());

      await repo.deleteFromWeek(cutoff, now: today);

      expect(await rule('r1'), isNull);
    });

    test('clamps a rule ending exactly on the cut-off Monday', () async {
      // It would still produce that Monday, i.e. inside the deleted range.
      await db.collection('fsm_recurring').doc('r1').set(const FsmRecurring(
            weekday: DateTime.monday,
            validFrom: '2026-06-01',
            validUntil: cutoff,
          ).toJson());

      await repo.deleteFromWeek(cutoff, now: today);

      expect((await rule('r1'))?.validUntil, '2026-07-12');
      expect(await repo.expandRange(cutoff, '2026-07-19'), isEmpty);
    });

    test('leaves a rule that already ended before the cut-off alone', () async {
      await db.collection('fsm_recurring').doc('r1').set(const FsmRecurring(
            weekday: DateTime.saturday,
            validFrom: '2026-05-01',
            validUntil: '2026-06-30',
          ).toJson());

      await repo.deleteFromWeek(cutoff, now: today);

      expect((await rule('r1'))?.validUntil, '2026-06-30');
    });

    test('a clamped rule stops expanding from the cut-off', () async {
      await db.collection('fsm_recurring').doc('r1').set(const FsmRecurring(
            weekday: DateTime.saturday,
            validFrom: '2026-06-01',
          ).toJson());

      await repo.deleteFromWeek(cutoff, now: today);

      final before = await repo.expandRange('2026-07-06', '2026-07-12');
      final after = await repo.expandRange('2026-07-13', '2026-07-19');
      expect(before.map((m) => m.date), ['2026-07-11']);
      expect(after, isEmpty);
    });

    test('deletes an occurrence moved back across the cut-off', () async {
      // Its slot is in the deleted range even though it happens before it.
      await db.collection('fsm_meetings').doc('r1_2026-07-18').set(const
          FsmMeeting(
        date: '2026-07-10',
        seriesDate: '2026-07-18',
        recurringId: 'r1',
        overrides: ['date'],
      ).toJson());

      await repo.deleteFromWeek(cutoff, now: today);

      expect(await meetingIds(), isEmpty);
    });
  });

  group('FsmRepository.expandAssignedTo', () {
    late FakeFirebaseFirestore db;
    late FsmRepository repo;

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = FsmRepository(db);
    });

    test('finds recurring meetings that have no document at all', () async {
      await db.collection('fsm_recurring').doc('r1').set(const FsmRecurring(
            weekday: DateTime.saturday,
            time: '09:00',
            location: 'Hall',
            validFrom: '2026-07-01',
            defaultAssignment: Assignment(publisherIds: ['p1']),
          ).toJson());

      final mine = await repo.expandAssignedTo('p1', '2026-07-06', '2026-07-19');

      expect(mine.map((m) => m.date), ['2026-07-11', '2026-07-18']);
      expect(mine.every((m) => m.location == 'Hall'), isTrue);
    });

    test('skips occurrences whose conductor was changed to someone else',
        () async {
      await db.collection('fsm_recurring').doc('r1').set(const FsmRecurring(
            weekday: DateTime.saturday,
            validFrom: '2026-07-01',
            defaultAssignment: Assignment(publisherIds: ['p1']),
          ).toJson());
      await db.collection('fsm_meetings').doc('r1_2026-07-11').set(const
          FsmMeeting(
        date: '2026-07-11',
        seriesDate: '2026-07-11',
        assignment: Assignment(publisherIds: ['p2']),
        recurringId: 'r1',
        overrides: ['assignment'],
      ).toJson());

      final mine = await repo.expandAssignedTo('p1', '2026-07-06', '2026-07-19');

      expect(mine.map((m) => m.date), ['2026-07-18']);
    });
  });
}
