import 'package:congregation_scheduler/core/data/co_visit_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

/// The circuit overseer visit document: its Tuesday-to-Sunday shape, the
/// ordering of half-arranged items, section hiding, and the denormalized
/// assignee index that "my assignments" queries.
void main() {
  const meal = CoVisitSection.meal;
  const shepherding = CoVisitSection.shepherding;

  CoVisitItem item(String id, CoVisitSection section,
          {String date = '', String time = '', List<String> ids = const []}) =>
      CoVisitItem(
        id: id,
        section: section,
        date: date,
        time: time,
        assignment: Assignment(publisherIds: ids),
      );

  group('CoVisit week shape', () {
    // 2026-04-13 is a Monday; the visit runs Tuesday to Sunday inside it.
    final monday = DateTime(2026, 4, 13);

    test('starts on Tuesday and ends on Sunday', () {
      expect(CoVisit.startOf(monday), DateTime(2026, 4, 14));
      expect(CoVisit.endOf(monday), DateTime(2026, 4, 19));
      expect(CoVisit.startOf(monday).weekday, DateTime.tuesday);
      expect(CoVisit.endOf(monday).weekday, DateTime.sunday);
    });

    test('offers exactly the six days of the visit', () {
      final days = CoVisit.daysOf(monday);
      expect(days, hasLength(6));
      expect(days.first, DateTime(2026, 4, 14));
      expect(days.last, DateTime(2026, 4, 19));
    });

    test('spans a month boundary without slipping', () {
      final endOfMonth = DateTime(2026, 4, 27);
      expect(CoVisit.endOf(endOfMonth), DateTime(2026, 5, 3));
    });
  });

  group('CoVisit.itemsOf', () {
    test('sorts by day then time, with the unscheduled ones last', () {
      final visit = CoVisit(id: '2026-04-13', items: [
        item('c', meal, date: '2026-04-16', time: '12:00'),
        item('d', meal),
        item('a', meal, date: '2026-04-14', time: '12:30'),
        item('b', meal, date: '2026-04-14', time: '12:00'),
        item('e', meal, date: '2026-04-15'),
      ]);

      expect(visit.itemsOf(meal).map((i) => i.id), ['b', 'a', 'e', 'c', 'd']);
    });

    test('keeps the sections apart', () {
      final visit = CoVisit(id: '2026-04-13', items: [
        item('a', meal, date: '2026-04-14'),
        item('b', shepherding, date: '2026-04-14'),
      ]);

      expect(visit.itemsOf(meal).map((i) => i.id), ['a']);
      expect(visit.itemsOf(shepherding).map((i) => i.id), ['b']);
    });
  });

  group('CoVisit items', () {
    test('withItem replaces by id rather than appending a second copy', () {
      final visit = CoVisit(id: '2026-04-13', items: [item('a', meal)])
          .withItem(item('a', meal, date: '2026-04-15'));

      expect(visit.items, hasLength(1));
      expect(visit.items.single.date, '2026-04-15');
    });

    test('an untouched item is blank, anything filled in is not', () {
      expect(const CoVisitItem(id: 'a').isBlank, isTrue);
      expect(const CoVisitItem(id: 'a', note: '  ').isBlank, isTrue,
          reason: 'whitespace is not an arrangement');
      expect(const CoVisitItem(id: 'a', date: '2026-04-14').isBlank, isFalse);
      expect(
          const CoVisitItem(id: 'a', assignment: Assignment(freeText: 'Anna'))
              .isBlank,
          isFalse);
    });

    test('hiding a section is idempotent and reversible', () {
      final visit = CoVisit(id: '2026-04-13');
      final hidden = visit
          .withSectionHidden(meal, true)
          .withSectionHidden(meal, true);

      expect(hidden.hiddenSections, ['meal']);
      expect(hidden.isHidden(meal), isTrue);
      expect(hidden.isHidden(shepherding), isFalse);
      expect(hidden.withSectionHidden(meal, false).hiddenSections, isEmpty);
    });
  });

  group('CoVisit assignees', () {
    test('collects every assigned publisher, sorted and deduplicated', () {
      final visit = CoVisit(id: '2026-04-13', items: [
        item('a', meal, ids: ['p2', 'p1']),
        item('b', shepherding, ids: ['p1']),
      ]).withRecomputedAssignees();

      expect(visit.allAssigneeIds, ['p1', 'p2']);
    });

    test('replaceAssignee rewrites every item and reindexes', () {
      final visit = CoVisit(id: '2026-04-13', items: [
        item('a', meal, ids: ['old']),
        item('b', shepherding, ids: ['other', 'old']),
      ]).replaceAssignee('old', 'new');

      expect(visit.items.first.assignment.publisherIds, ['new']);
      expect(visit.items.last.assignment.publisherIds, ['other', 'new']);
      expect(visit.allAssigneeIds, ['new', 'other']);
    });
  });

  group('defaultCoVisitWeekId', () {
    final now = DateTime(2026, 4, 15); // week of 2026-04-13

    test('is null when nothing is planned', () {
      expect(defaultCoVisitWeekId(const [], now: now), isNull);
    });

    test('opens on the visit in progress rather than the next one', () {
      final visits = [
        const CoVisit(id: '2026-01-05'),
        const CoVisit(id: '2026-04-13'),
        const CoVisit(id: '2026-10-05'),
      ];
      expect(defaultCoVisitWeekId(visits, now: now), '2026-04-13');
    });

    test('opens on the next upcoming visit', () {
      final visits = [
        const CoVisit(id: '2026-01-05'),
        const CoVisit(id: '2026-10-05'),
      ];
      expect(defaultCoVisitWeekId(visits, now: now), '2026-10-05');
    });

    test('falls back to the most recent past visit', () {
      final visits = [
        const CoVisit(id: '2025-10-06'),
        const CoVisit(id: '2026-01-05'),
      ];
      expect(defaultCoVisitWeekId(visits, now: now), '2026-01-05');
    });
  });

  group('isCoVisitDate', () {
    const weeks = {'2026-04-13'};

    test('covers every day of the visit week', () {
      expect(isCoVisitDate(weeks, '2026-04-14'), isTrue);
      expect(isCoVisitDate(weeks, '2026-04-19'), isTrue);
    });

    test('excludes the weeks around it', () {
      expect(isCoVisitDate(weeks, '2026-04-12'), isFalse);
      expect(isCoVisitDate(weeks, '2026-04-20'), isFalse);
    });

    test('tolerates an unset date', () {
      expect(isCoVisitDate(weeks, ''), isFalse);
    });
  });

  group('CoVisitRepository', () {
    late FakeFirebaseFirestore db;
    late CoVisitRepository repo;

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = CoVisitRepository(db);
    });

    test('save indexes the assignees, delete removes the visit', () async {
      await repo.save(CoVisit(id: '2026-04-13', items: [
        item('a', meal, date: '2026-04-14', ids: ['p1']),
      ]));

      final stored =
          await db.collection('co_visits').doc('2026-04-13').get();
      expect(stored.data()!['allAssigneeIds'], ['p1']);

      await repo.delete('2026-04-13');
      expect(
          (await db.collection('co_visits').doc('2026-04-13').get()).exists,
          isFalse);
    });

    test('getAssignedTo finds the visits someone is named in', () async {
      await repo.save(CoVisit(id: '2026-04-13', items: [
        item('a', meal, date: '2026-04-14', ids: ['p1']),
      ]));
      await repo.save(CoVisit(id: '2026-10-05', items: [
        item('b', meal, date: '2026-10-06', ids: ['p2']),
      ]));

      final mine = await repo.getAssignedTo('p1');
      expect(mine.map((v) => v.id), ['2026-04-13']);
    });

    test('replaceAssigneeInAll is idempotent', () async {
      await repo.save(CoVisit(id: '2026-04-13', items: [
        item('a', meal, date: '2026-04-14', ids: ['old']),
      ]));

      await repo.replaceAssigneeInAll('old', 'new');
      await repo.replaceAssigneeInAll('old', 'new');

      final visits = await repo.getRange('2026-01-01', '2026-12-31');
      expect(visits.single.items.single.assignment.publisherIds, ['new']);
      expect(visits.single.allAssigneeIds, ['new']);
    });
  });
}
