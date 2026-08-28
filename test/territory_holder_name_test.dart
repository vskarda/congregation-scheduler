import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/data/territories_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/territories/territory_holder.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

/// Who a territory assignment says held it. Deleting a publisher takes their
/// name out of the territory record too — the dates of the round stay, the
/// name does not — so the only name that outlives a record is one an admin
/// typed by hand into the free-text field.
void main() {
  const publisher = Publisher(
    id: 'p1',
    firstName: 'Jan',
    lastName: 'Novák',
    verified: true,
  );

  Future<void> seed(FakeFirebaseFirestore db) async {
    await db.collection('publishers').doc('p1').set(publisher.toJson());
    await TerritoriesRepository(db).saveAssignment(const TerritoryAssignment(
      territoryId: 't1',
      publisherId: 'p1',
      assignedDate: '2025-09-01',
      returnedDate: '2025-11-30',
    ));
    await TerritoriesRepository(db).saveAssignment(const TerritoryAssignment(
      territoryId: 't2',
      publisherId: 'p1',
      assignedDate: '2026-01-05',
    ));
  }

  test('deleting a publisher leaves the dates and takes the name', () async {
    final db = FakeFirebaseFirestore();
    await seed(db);

    await PublishersRepository(db).delete('p1');

    final assignments = await TerritoriesRepository(db).getAllAssignments();
    expect(assignments, hasLength(2));
    // Nothing is written in the publisher's place: no name is stored on the
    // way out, and the roster can no longer answer for the id.
    expect(assignments.every((a) => a.freeText.isEmpty), isTrue);
    expect(
      assignments.map((a) => a.assignedDate).toList()..sort(),
      ['2025-09-01', '2026-01-05'],
    );
    expect((await db.collection('publishers').doc('p1').get()).exists, isFalse);
  });

  test('a hand-typed holder survives any deletion — nothing links to it',
      () async {
    final db = FakeFirebaseFirestore();
    await seed(db);
    await TerritoriesRepository(db).saveAssignment(const TerritoryAssignment(
      territoryId: 't3',
      freeText: 'Old Brother',
      assignedDate: '2024-03-01',
    ));

    await PublishersRepository(db).delete('p1');

    final assignments = await TerritoriesRepository(db).getAllAssignments();
    final typed = assignments.firstWhere((a) => a.territoryId == 't3');
    expect(typed.freeText, 'Old Brother');
    expect(typed.publisherId, '');
  });

  group('territoryHolderName', () {
    const byId = {'p1': publisher};

    test('the live record answers for a linked publisher', () {
      const assignment = TerritoryAssignment(publisherId: 'p1');
      expect(territoryHolderName(assignment, byId), 'Jan Novák');
    });

    test('a hand-typed holder has no publisher at all', () {
      const assignment = TerritoryAssignment(freeText: 'Old Brother');
      expect(territoryHolderName(assignment, byId), 'Old Brother');
    });

    test('a live record still wins over free text left beside it', () {
      const assignment = TerritoryAssignment(
        publisherId: 'p1',
        freeText: 'Stale Name',
      );
      expect(territoryHolderName(assignment, byId), 'Jan Novák');
    });

    test('a deleted publisher leaves nothing to print', () {
      const assignment = TerritoryAssignment(publisherId: 'gone');
      expect(territoryHolderName(assignment, byId), '');
    });
  });
}
