import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';

class WeekendRepository {
  WeekendRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('weekend_weeks');

  WeekendWeek _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      WeekendWeek.fromJson(doc.data()!).copyWith(id: doc.id);

  Stream<WeekendWeek?> watchWeek(String weekId) => _col
      .doc(weekId)
      .snapshots()
      .map((doc) => doc.data() == null ? null : _fromDoc(doc));

  Future<void> saveWeek(WeekendWeek week) =>
      _col.doc(week.id).set(week.withRecomputedAssignees().toJson());

  Future<void> deleteWeek(String weekId) => _col.doc(weekId).delete();

  Future<List<WeekendWeek>> getRange(String fromId, String toId) async {
    final snap = await _col
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: fromId)
        .where(FieldPath.documentId, isLessThanOrEqualTo: toId)
        .get();
    return snap.docs.map(_fromDoc).toList();
  }

  Future<List<WeekendWeek>> getAssignedTo(String uid) async {
    final snap =
        await _col.where('allAssigneeIds', arrayContains: uid).get();
    return snap.docs.map(_fromDoc).toList();
  }
}

final weekendRepositoryProvider = Provider<WeekendRepository>(
    (ref) => WeekendRepository(ref.watch(firestoreProvider)));

final weekendWeekProvider =
    StreamProvider.family<WeekendWeek?, String>((ref, weekId) {
  return ref.watch(weekendRepositoryProvider).watchWeek(weekId);
});
