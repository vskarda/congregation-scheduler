import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';

class TerritoriesRepository {
  TerritoriesRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _territories =>
      _db.collection('territories');

  CollectionReference<Map<String, dynamic>> get _assignments =>
      _db.collection('territory_assignments');

  Territory _territoryFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      Territory.fromJson(doc.data()!).copyWith(id: doc.id);

  TerritoryAssignment _assignmentFromDoc(
          DocumentSnapshot<Map<String, dynamic>> doc) =>
      TerritoryAssignment.fromJson(doc.data()!).copyWith(id: doc.id);

  Stream<List<Territory>> watchAll() => _territories.snapshots().map((snap) {
        final list = snap.docs.map(_territoryFromDoc).toList();
        list.sort((a, b) => _naturalKey(a).compareTo(_naturalKey(b)));
        return list;
      });

  static String _naturalKey(Territory t) {
    final n = int.tryParse(t.number);
    return n != null
        ? n.toString().padLeft(6, '0')
        : '999999${t.name.toLowerCase()}';
  }

  Future<void> saveTerritory(Territory territory) async {
    if (territory.id.isEmpty) {
      await _territories.add(territory.toJson());
    } else {
      await _territories.doc(territory.id).set(territory.toJson());
    }
  }

  Future<void> deleteTerritory(String id) => _territories.doc(id).delete();

  /// Admin view: every assignment ever (stats need history).
  Stream<List<TerritoryAssignment>> watchAllAssignments() =>
      _assignments.snapshots().map((snap) {
        final list = snap.docs.map(_assignmentFromDoc).toList();
        list.sort((a, b) => b.assignedDate.compareTo(a.assignedDate));
        return list;
      });

  /// Publisher view: only own assignments (rules enforce the filter).
  Stream<List<TerritoryAssignment>> watchMyAssignments(String uid) =>
      _assignments
          .where('publisherId', isEqualTo: uid)
          .snapshots()
          .map((snap) {
        final list = snap.docs.map(_assignmentFromDoc).toList();
        list.sort((a, b) => b.assignedDate.compareTo(a.assignedDate));
        return list;
      });

  Future<void> assign(TerritoryAssignment assignment) =>
      _assignments.add(assignment.toJson()).then((_) {});

  /// Publishers may only touch returnedDate/returnNotes (rules-enforced).
  Future<void> returnTerritory(
          String assignmentId, String returnedDate, String notes) =>
      _assignments.doc(assignmentId).update({
        'returnedDate': returnedDate,
        'returnNotes': notes,
      });

  Future<void> deleteAssignment(String assignmentId) =>
      _assignments.doc(assignmentId).delete();
}

final territoriesRepositoryProvider = Provider<TerritoriesRepository>(
    (ref) => TerritoriesRepository(ref.watch(firestoreProvider)));

final territoriesProvider = StreamProvider<List<Territory>>(
    (ref) => ref.watch(territoriesRepositoryProvider).watchAll());

final myTerritoryAssignmentsProvider =
    StreamProvider<List<TerritoryAssignment>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(const []);
  return ref.watch(territoriesRepositoryProvider).watchMyAssignments(uid);
});

final allTerritoryAssignmentsProvider =
    StreamProvider<List<TerritoryAssignment>>((ref) =>
        ref.watch(territoriesRepositoryProvider).watchAllAssignments());
