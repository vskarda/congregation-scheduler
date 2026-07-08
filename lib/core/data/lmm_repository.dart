import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';

class LmmRepository {
  LmmRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('lmm_weeks');

  LmmWeek _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      LmmWeek.fromJson(doc.data()!).copyWith(id: doc.id);

  Stream<LmmWeek?> watchWeek(String weekId) => _col
      .doc(weekId)
      .snapshots()
      .map((doc) => doc.data() == null ? null : _fromDoc(doc));

  Future<void> saveWeek(LmmWeek week) =>
      _col.doc(week.id).set(week.withRecomputedAssignees().toJson());

  Future<void> deleteWeek(String weekId) => _col.doc(weekId).delete();

  /// Weeks in [fromId, toId] (Monday keys); used for history-based ordering
  /// in the publisher picker.
  Future<List<LmmWeek>> getRange(String fromId, String toId) async {
    final snap = await _col
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: fromId)
        .where(FieldPath.documentId, isLessThanOrEqualTo: toId)
        .get();
    return snap.docs.map(_fromDoc).toList();
  }

  /// All weeks that mention [uid]; caller filters for upcoming (data volume
  /// is small and this avoids composite-index requirements).
  Future<List<LmmWeek>> getAssignedTo(String uid) async {
    final snap =
        await _col.where('allAssigneeIds', arrayContains: uid).get();
    return snap.docs.map(_fromDoc).toList();
  }
}

final lmmRepositoryProvider =
    Provider<LmmRepository>((ref) => LmmRepository(ref.watch(firestoreProvider)));

final lmmWeekProvider =
    StreamProvider.family<LmmWeek?, String>((ref, weekId) {
  return ref.watch(lmmRepositoryProvider).watchWeek(weekId);
});
