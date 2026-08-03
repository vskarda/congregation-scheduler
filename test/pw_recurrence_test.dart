import 'package:congregation_scheduler/core/data/pw_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PwRepository.materializedDates', () {
    test('emits the rule weekday between from and until', () {
      const rule = PwRecurring(id: 'r1', weekday: DateTime.saturday);
      final dates = PwRepository.materializedDates(
          rule, DateTime(2026, 7, 7), DateTime(2026, 8, 4));
      expect(dates, ['2026-07-11', '2026-07-18', '2026-07-25', '2026-08-01']);
    });

    test('starts on from itself when it matches the weekday', () {
      const rule = PwRecurring(id: 'r1', weekday: DateTime.tuesday);
      final dates = PwRepository.materializedDates(
          rule, DateTime(2026, 7, 7), DateTime(2026, 7, 22));
      expect(dates, ['2026-07-07', '2026-07-14', '2026-07-21']);
    });

    test('respects validFrom and validUntil', () {
      const rule = PwRecurring(
        id: 'r1',
        weekday: DateTime.saturday,
        validFrom: '2026-07-15',
        validUntil: '2026-07-31',
      );
      final dates = PwRepository.materializedDates(
          rule, DateTime(2026, 7, 1), DateTime(2026, 9, 1));
      expect(dates, ['2026-07-18', '2026-07-25']);
    });

    test('is empty when the rule expired', () {
      const rule = PwRecurring(
          id: 'r1', weekday: DateTime.saturday, validUntil: '2026-06-30');
      final dates = PwRepository.materializedDates(
          rule, DateTime(2026, 7, 7), DateTime(2026, 9, 1));
      expect(dates, isEmpty);
    });
  });

  group('PwRepository.producesOn', () {
    const rule = PwRecurring(id: 'r1', weekday: DateTime.saturday);

    test('is true only on the rule weekday', () {
      expect(PwRepository.producesOn(rule, '2026-07-11'), isTrue);
      expect(PwRepository.producesOn(rule, '2026-07-12'), isFalse);
    });

    test('is false outside the validity window', () {
      const limited = PwRecurring(
        id: 'r1',
        weekday: DateTime.saturday,
        validFrom: '2026-07-15',
        validUntil: '2026-07-31',
      );
      expect(PwRepository.producesOn(limited, '2026-07-11'), isFalse);
      expect(PwRepository.producesOn(limited, '2026-07-18'), isTrue);
      expect(PwRepository.producesOn(limited, '2026-08-01'), isFalse);
    });

    test('is false for an unparseable date', () {
      expect(PwRepository.producesOn(rule, ''), isFalse);
    });
  });

  group('PwRepository.runsBefore', () {
    test('a rule without validFrom has always run', () {
      const rule = PwRecurring(id: 'r1', weekday: DateTime.saturday);
      expect(PwRepository.runsBefore(rule, DateTime(2026, 7, 13)), isTrue);
    });

    test('is false when the first occurrence is on or after the cut-off', () {
      const rule = PwRecurring(
          id: 'r1', weekday: DateTime.saturday, validFrom: '2026-07-13');
      expect(PwRepository.runsBefore(rule, DateTime(2026, 7, 13)), isFalse);
    });

    test('is true when it already ran, even if it has since ended', () {
      const rule = PwRecurring(
        id: 'r1',
        weekday: DateTime.saturday,
        validFrom: '2026-06-01',
        validUntil: '2026-06-30',
      );
      expect(PwRepository.runsBefore(rule, DateTime(2026, 7, 13)), isTrue);
    });
  });

  group('PwRepository.chunkIds', () {
    test('splits at the Firestore whereIn limit', () {
      final ids = [for (var i = 0; i < 65; i++) 's$i'];
      final chunks = PwRepository.chunkIds(ids);
      expect(chunks.map((c) => c.length), [30, 30, 5]);
      expect(chunks.expand((c) => c), ids);
    });

    test('is empty for no ids', () {
      expect(PwRepository.chunkIds(const []), isEmpty);
    });
  });

  group('PwRepository.expand', () {
    // Week Monday 2026-07-06 .. Sunday 2026-07-12 (until is exclusive).
    final monday = DateTime(2026, 7, 6);
    final until = DateTime(2026, 7, 13);

    const rule = PwRecurring(
      id: 'r1',
      weekday: DateTime.saturday, // 2026-07-11
      startTime: '09:00',
      endTime: '11:00',
      location: 'Town square',
      defaultAssignment: Assignment(publisherIds: ['p1']),
    );

    test('expands an occurrence with the deterministic id', () {
      final merged =
          PwRepository.expand(const [], const [], [rule], monday, until);
      expect(merged, hasLength(1));
      final slot = merged.single;
      expect(slot.id, 'r1_2026-07-11');
      expect(slot.date, '2026-07-11');
      expect(slot.seriesDate, '2026-07-11');
      expect(slot.startTime, '09:00');
      expect(slot.endTime, '11:00');
      expect(slot.location, 'Town square');
      expect(slot.recurringId, 'r1');
      expect(slot.allAssigneeIds, ['p1']);
    });

    test('expands past weeks too', () {
      final merged = PwRepository.expand(const [], const [], [rule],
          DateTime(2026, 6, 1), DateTime(2026, 6, 8));
      expect(merged.map((s) => s.date), ['2026-06-06']);
    });

    test(
        'an exception overriding one field still follows the rule for the '
        'others', () {
      const edited = PwSlot(
        id: 'r1_2026-07-11',
        date: '2026-07-11',
        seriesDate: '2026-07-11',
        startTime: '10:00',
        location: 'stale copy of an older rule',
        recurringId: 'r1',
        overrides: ['startTime'],
      );
      final merged =
          PwRepository.expand(const [edited], const [], [rule], monday, until);
      expect(merged, hasLength(1));
      expect(merged.single.startTime, '10:00', reason: 'the override wins');
      expect(merged.single.location, 'Town square',
          reason: 'everything else follows the rule');
      expect(merged.single.endTime, '11:00');
      expect(merged.single.assignment.publisherIds, ['p1']);
    });

    test('customized assignees survive a later rule edit', () {
      const edited = PwSlot(
        id: 'r1_2026-07-11',
        date: '2026-07-11',
        seriesDate: '2026-07-11',
        assignment: Assignment(publisherIds: ['p9']),
        recurringId: 'r1',
        overrides: ['assignment'],
      );
      final merged =
          PwRepository.expand(const [edited], const [], [rule], monday, until);
      expect(merged.single.assignment.publisherIds, ['p9']);
      expect(merged.single.allAssigneeIds, ['p9']);
      expect(merged.single.location, 'Town square');
    });

    test('a cancelled occurrence is suppressed and hidden', () {
      const cancelled = PwSlot(
        id: 'r1_2026-07-11',
        date: '2026-07-11',
        seriesDate: '2026-07-11',
        recurringId: 'r1',
        cancelled: true,
      );
      final merged = PwRepository.expand(
          const [cancelled], const [cancelled], [rule], monday, until);
      expect(merged, isEmpty);
    });

    test('one-off slots pass through and the result is sorted', () {
      const oneOff = PwSlot(id: 'x1', date: '2026-07-11', startTime: '07:00');
      const earlier = PwSlot(id: 'x2', date: '2026-07-08', startTime: '15:00');
      final merged = PwRepository.expand(
          const [oneOff, earlier], const [], [rule], monday, until);
      expect(merged.map((s) => s.id), ['x2', 'x1', 'r1_2026-07-11']);
    });

    test('respects the rule validity window', () {
      const limited = PwRecurring(
          id: 'r1', weekday: DateTime.saturday, validUntil: '2026-07-10');
      final merged =
          PwRepository.expand(const [], const [], [limited], monday, until);
      expect(merged, isEmpty);
    });

    test('an occurrence moved to another week leaves no twin behind', () {
      const moved = PwSlot(
        id: 'r1_2026-07-11',
        date: '2026-07-14',
        seriesDate: '2026-07-11',
        startTime: '09:00',
        recurringId: 'r1',
        overrides: ['date'],
      );

      final source =
          PwRepository.expand(const [], const [moved], [rule], monday, until);
      expect(source, isEmpty);

      final target = PwRepository.expand(const [moved], const [], [rule],
          DateTime(2026, 7, 13), DateTime(2026, 7, 20));
      expect(target.map((s) => s.date), ['2026-07-14', '2026-07-18']);
      expect(target.first.location, 'Town square',
          reason: 'a moved occurrence still follows its rule');
      expect(target.first.id, 'r1_2026-07-11',
          reason: 'its id never moves, so its applications stay attached');
    });

    test('an exception whose rule is gone renders from its own fields', () {
      const orphan = PwSlot(
        id: 'gone_2026-07-11',
        date: '2026-07-11',
        seriesDate: '2026-07-11',
        startTime: '08:30',
        location: 'Old place',
        recurringId: 'gone',
      );
      final merged = PwRepository.expand(
          const [orphan], const [], const [], monday, until);
      expect(merged, hasLength(1));
      expect(merged.single.location, 'Old place');
      expect(merged.single.startTime, '08:30');
    });
  });

  group('PwRepository.repairAndCompact', () {
    late FakeFirebaseFirestore db;
    late PwRepository repo;
    final today = DateTime(2026, 7, 1);

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = PwRepository(db);
    });

    Future<void> addRule(String id, PwRecurring rule) =>
        db.collection('pw_recurring').doc(id).set(rule.toJson());

    Future<List<PwSlot>> slots() async {
      final snap = await db.collection('pw_slots').get();
      return snap.docs
          .map((d) => PwSlot.fromJson(d.data()).copyWith(id: d.id))
          .toList();
    }

    test('deletes a materialized copy that deviates in nothing', () async {
      const rule = PwRecurring(
          weekday: DateTime.saturday, startTime: '09:00', location: 'Square');
      await addRule('r1', rule);
      await db.collection('pw_slots').doc('r1_2026-07-11').set(
          PwSlot.fromRule(rule.copyWith(id: 'r1'), '2026-07-11')
              .copyWith(seriesDate: '')
              .toJson());

      await repo.repairAndCompact(now: today);

      expect(await slots(), isEmpty,
          reason: 'the rule renders this occurrence now, under the same id');
    });

    test('keeps an edited copy, recording only what deviates', () async {
      const rule = PwRecurring(
          weekday: DateTime.saturday, startTime: '09:00', location: 'Square');
      await addRule('r1', rule);
      await db.collection('pw_slots').doc('r1_2026-07-11').set(const PwSlot(
            date: '2026-07-11',
            startTime: '10:30',
            location: 'Square',
            recurringId: 'r1',
          ).toJson());

      await repo.repairAndCompact(now: today);

      final all = await slots();
      expect(all, hasLength(1));
      expect(all.single.id, 'r1_2026-07-11');
      expect(all.single.seriesDate, '2026-07-11', reason: 'backfilled');
      expect(all.single.overrides, ['startTime']);
    });

    test('backfills seriesDate from the doc id when the date was moved',
        () async {
      const rule = PwRecurring(weekday: DateTime.saturday, startTime: '09:00');
      await addRule('r1', rule);
      await db.collection('pw_slots').doc('r1_2026-07-11').set(const PwSlot(
            date: '2026-07-14',
            startTime: '09:00',
            recurringId: 'r1',
          ).toJson());

      await repo.repairAndCompact(now: today);

      final all = await slots();
      expect(all, hasLength(1));
      expect(all.single.id, 'r1_2026-07-11',
          reason: 'the id its applications are keyed to must not move');
      expect(all.single.seriesDate, '2026-07-11');
      expect(all.single.date, '2026-07-14');
      expect(all.single.overrides, ['date']);
    });

    test('detaches a customized leftover of a weekday change', () async {
      const rule = PwRecurring(weekday: DateTime.sunday, startTime: '09:00');
      await addRule('r1', rule);
      await db.collection('pw_slots').doc('r1_2026-07-11').set(const PwSlot(
            date: '2026-07-11',
            startTime: '07:15',
            location: 'Marketplace',
            recurringId: 'r1',
          ).toJson());

      await repo.repairAndCompact(now: today);

      final all = await slots();
      expect(all, hasLength(1));
      expect(all.single.id, 'r1_2026-07-11', reason: 'detached in place');
      expect(all.single.recurringId, isEmpty, reason: 'now a one-off slot');
      expect(all.single.seriesDate, isEmpty);
      expect(all.single.location, 'Marketplace', reason: 'admin work kept');
      expect(all.single.startTime, '07:15');
    });

    test('deletes an uncustomized leftover of a weekday change', () async {
      const rule = PwRecurring(weekday: DateTime.sunday, startTime: '09:00');
      await addRule('r1', rule);
      await db.collection('pw_slots').doc('r1_2026-07-11').set(const PwSlot(
            date: '2026-07-11',
            startTime: '09:00',
            recurringId: 'r1',
          ).toJson());

      await repo.repairAndCompact(now: today);

      expect(await slots(), isEmpty);
    });

    test('re-adopts an orphan into a rule that produces its date', () async {
      const rule = PwRecurring(
          weekday: DateTime.saturday, startTime: '09:00', location: 'Square');
      await addRule('r2', rule);
      await db.collection('pw_slots').doc('r1_2026-07-11').set(const PwSlot(
            date: '2026-07-11',
            startTime: '09:00',
            location: 'Square',
            recurringId: 'r1', // r1 no longer exists
          ).toJson());

      await repo.repairAndCompact(now: today);

      expect(await slots(), isEmpty,
          reason: 'adopted by r2, which deviates in nothing');
    });

    test('turns an unadoptable orphan into a clean one-off slot', () async {
      await db.collection('pw_slots').doc('gone_2026-07-11').set(const PwSlot(
            date: '2026-07-11',
            startTime: '09:00',
            location: 'Somewhere',
            recurringId: 'gone',
          ).toJson());

      await repo.repairAndCompact(now: today);

      final all = await slots();
      expect(all, hasLength(1));
      expect(all.single.id, 'gone_2026-07-11');
      expect(all.single.recurringId, isEmpty);
      expect(all.single.location, 'Somewhere');
    });

    test('drops a tombstone whose rule is gone', () async {
      await db.collection('pw_slots').doc('gone_2026-07-11').set(const PwSlot(
            date: '2026-07-11',
            recurringId: 'gone',
            cancelled: true,
          ).toJson());

      await repo.repairAndCompact(now: today);

      expect(await slots(), isEmpty);
    });

    test('keeps a cancellation that its rule still expands', () async {
      const rule = PwRecurring(weekday: DateTime.saturday, startTime: '09:00');
      await addRule('r1', rule);
      await db.collection('pw_slots').doc('r1_2026-07-11').set(const PwSlot(
            date: '2026-07-11',
            recurringId: 'r1',
            cancelled: true,
          ).toJson());

      await repo.repairAndCompact(now: today);

      final all = await slots();
      expect(all, hasLength(1));
      expect(all.single.cancelled, isTrue);
      expect(all.single.seriesDate, '2026-07-11');
    });

    test('leaves one-off slots alone', () async {
      await db
          .collection('pw_slots')
          .add(const PwSlot(date: '2026-07-11', location: 'Mall').toJson());

      await repo.repairAndCompact(now: today);

      final all = await slots();
      expect(all, hasLength(1));
      expect(all.single.location, 'Mall');
    });

    test('is idempotent', () async {
      const rule = PwRecurring(
          weekday: DateTime.saturday, startTime: '09:00', location: 'Square');
      await addRule('r1', rule);
      await db.collection('pw_slots').doc('r1_2026-07-11').set(const PwSlot(
            date: '2026-07-11',
            startTime: '10:30',
            location: 'Square',
            recurringId: 'r1',
          ).toJson());
      await db.collection('pw_slots').doc('gone_2026-06-06').set(
          const PwSlot(date: '2026-06-06', recurringId: 'gone').toJson());

      await repo.repairAndCompact(now: today);
      final first = await slots();
      await repo.repairAndCompact(now: today);
      final second = await slots();

      expect(second.map((s) => s.toJson()), first.map((s) => s.toJson()));
    });
  });

  group('PwRepository.deleteRecurring', () {
    late FakeFirebaseFirestore db;
    late PwRepository repo;
    final today = DateTime(2026, 7, 16); // a Thursday

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = PwRepository(db);
    });

    Future<List<PwSlot>> slots() async {
      final snap = await db.collection('pw_slots').get();
      return snap.docs
          .map((d) => PwSlot.fromJson(d.data()).copyWith(id: d.id))
          .toList();
    }

    test('freezes past occurrences into stand-alone slots at their own ids',
        () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.thursday,
            startTime: '09:30',
            location: 'Square',
            validFrom: '2026-07-01',
          ).toJson());

      await repo.deleteRecurring('r1', now: today);

      expect((await db.collection('pw_recurring').doc('r1').get()).exists,
          isFalse);
      final all = await slots();
      expect(all.map((s) => s.id).toList()..sort(),
          ['r1_2026-07-02', 'r1_2026-07-09'],
          reason: 'ids are kept so applications stay attached');
      expect(all.every((s) => s.recurringId.isEmpty), isTrue);
      expect(all.every((s) => s.location == 'Square'), isTrue);
      expect(all.every((s) => s.startTime == '09:30'), isTrue);
    });

    test('drops plain future occurrences and their tombstones', () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.thursday,
            validFrom: '2026-07-16',
          ).toJson());
      await db.collection('pw_slots').doc('r1_2026-07-23').set(const PwSlot(
            date: '2026-07-23',
            seriesDate: '2026-07-23',
            recurringId: 'r1',
          ).toJson());
      await db.collection('pw_slots').doc('r1_2026-07-30').set(const PwSlot(
            date: '2026-07-30',
            seriesDate: '2026-07-30',
            recurringId: 'r1',
            cancelled: true,
          ).toJson());

      await repo.deleteRecurring('r1', now: today);

      expect(await slots(), isEmpty);
    });

    test('detaches a customized future occurrence in place', () async {
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

      await repo.deleteRecurring('r1', now: today);

      final all = await slots();
      expect(all, hasLength(1));
      expect(all.single.id, 'r1_2026-07-23');
      expect(all.single.recurringId, isEmpty);
      expect(all.single.startTime, '18:00', reason: 'the override is kept');
      expect(all.single.location, 'Square',
          reason: 'inherited fields are frozen before the rule goes');
    });

    test('leaves other rules and one-off slots untouched', () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.thursday,
            validFrom: '2026-07-16',
          ).toJson());
      await db.collection('pw_recurring').doc('r2').set(const PwRecurring(
            weekday: DateTime.saturday,
            validFrom: '2026-07-16',
          ).toJson());
      await db
          .collection('pw_slots')
          .doc('one-off')
          .set(const PwSlot(date: '2026-08-01', location: 'Mall').toJson());

      await repo.deleteRecurring('r1', now: today);

      expect((await db.collection('pw_recurring').doc('r2').get()).exists,
          isTrue);
      final all = await slots();
      expect(all, hasLength(1));
      expect(all.single.id, 'one-off');
    });
  });

  group('PwRepository.deleteFromWeek', () {
    late FakeFirebaseFirestore db;
    late PwRepository repo;
    final today = DateTime(2026, 7, 16);
    const cutoff = '2026-07-13'; // Monday

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = PwRepository(db);
    });

    Future<List<String>> slotIds() async {
      final snap = await db.collection('pw_slots').get();
      return snap.docs.map((d) => d.id).toList()..sort();
    }

    Future<PwRecurring?> rule(String id) async {
      final doc = await db.collection('pw_recurring').doc(id).get();
      return doc.exists ? PwRecurring.fromJson(doc.data()!) : null;
    }

    test('deletes slots from the week on and keeps earlier ones', () async {
      await db
          .collection('pw_slots')
          .doc('before')
          .set(const PwSlot(date: '2026-07-12', location: 'Mall').toJson());
      await db
          .collection('pw_slots')
          .doc('on-monday')
          .set(const PwSlot(date: '2026-07-13', location: 'Mall').toJson());
      await db
          .collection('pw_slots')
          .doc('after')
          .set(const PwSlot(date: '2026-08-20', location: 'Mall').toJson());

      await repo.deleteFromWeek(cutoff, now: today);

      expect(await slotIds(), ['before']);
    });

    test('clamps a rule that already ran before the cut-off', () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.saturday,
            validFrom: '2026-06-01',
          ).toJson());

      await repo.deleteFromWeek(cutoff, now: today);

      expect((await rule('r1'))?.validUntil, '2026-07-12',
          reason: 'the Sunday before the selected week');
    });

    test('deletes a rule that starts on or after the cut-off', () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.saturday,
            validFrom: '2026-07-13',
          ).toJson());

      await repo.deleteFromWeek(cutoff, now: today);

      expect(await rule('r1'), isNull);
    });

    test('clamps a rule ending exactly on the cut-off Monday', () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.monday,
            validFrom: '2026-06-01',
            validUntil: cutoff,
          ).toJson());

      await repo.deleteFromWeek(cutoff, now: today);

      expect((await rule('r1'))?.validUntil, '2026-07-12');
      expect(await repo.expandRange(cutoff, '2026-07-19'), isEmpty);
    });

    test('leaves a rule that already ended before the cut-off alone', () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.saturday,
            validFrom: '2026-05-01',
            validUntil: '2026-06-30',
          ).toJson());

      await repo.deleteFromWeek(cutoff, now: today);

      expect((await rule('r1'))?.validUntil, '2026-06-30');
    });

    test('a clamped rule stops expanding from the cut-off', () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.saturday,
            validFrom: '2026-06-01',
          ).toJson());

      await repo.deleteFromWeek(cutoff, now: today);

      final before = await repo.expandRange('2026-07-06', '2026-07-12');
      final after = await repo.expandRange('2026-07-13', '2026-07-19');
      expect(before.map((s) => s.date), ['2026-07-11']);
      expect(after, isEmpty);
    });

    test('deletes an occurrence moved back across the cut-off', () async {
      await db.collection('pw_slots').doc('r1_2026-07-18').set(const PwSlot(
            date: '2026-07-10',
            seriesDate: '2026-07-18',
            recurringId: 'r1',
            overrides: ['date'],
          ).toJson());

      await repo.deleteFromWeek(cutoff, now: today);

      expect(await slotIds(), isEmpty);
    });
  });

  group('PwRepository.deleteAllFutureSlots', () {
    late FakeFirebaseFirestore db;
    late PwRepository repo;
    final today = DateTime(2026, 7, 16);

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = PwRepository(db);
    });

    test('drops every rule and future slot, keeping the past', () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.thursday,
            location: 'Square',
            validFrom: '2026-07-01',
          ).toJson());
      await db
          .collection('pw_slots')
          .doc('past-one-off')
          .set(const PwSlot(date: '2026-07-01', location: 'Mall').toJson());
      await db
          .collection('pw_slots')
          .doc('future-one-off')
          .set(const PwSlot(date: '2026-07-20', location: 'Mall').toJson());

      await repo.deleteAllFutureSlots(now: today);

      expect((await db.collection('pw_recurring').get()).docs, isEmpty);
      final snap = await db.collection('pw_slots').get();
      final dates = snap.docs.map((d) => d.data()['date'] as String).toList()
        ..sort();
      expect(dates, ['2026-07-01', '2026-07-02', '2026-07-09'],
          reason: 'the past one-off plus the rule occurrences frozen as '
              'history');
    });
  });

  group('PwRepository.expandAssignedTo', () {
    late FakeFirebaseFirestore db;
    late PwRepository repo;

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = PwRepository(db);
    });

    test('finds recurring slots that have no document at all', () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.saturday,
            startTime: '09:00',
            location: 'Square',
            validFrom: '2026-07-01',
            defaultAssignment: Assignment(publisherIds: ['p1']),
          ).toJson());

      final mine =
          await repo.expandAssignedTo('p1', '2026-07-06', '2026-07-19');

      expect(mine.map((s) => s.date), ['2026-07-11', '2026-07-18']);
      expect(mine.every((s) => s.location == 'Square'), isTrue);
    });

    test('skips occurrences reassigned to someone else', () async {
      await db.collection('pw_recurring').doc('r1').set(const PwRecurring(
            weekday: DateTime.saturday,
            validFrom: '2026-07-01',
            defaultAssignment: Assignment(publisherIds: ['p1']),
          ).toJson());
      await db.collection('pw_slots').doc('r1_2026-07-11').set(const PwSlot(
            date: '2026-07-11',
            seriesDate: '2026-07-11',
            assignment: Assignment(publisherIds: ['p2']),
            recurringId: 'r1',
            overrides: ['assignment'],
          ).toJson());

      final mine =
          await repo.expandAssignedTo('p1', '2026-07-06', '2026-07-19');

      expect(mine.map((s) => s.date), ['2026-07-18']);
    });
  });
}
