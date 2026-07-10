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

  Future<List<WeekendWeek>> getAll() async {
    final snap = await _col.get();
    return snap.docs.map(_fromDoc).toList();
  }

  /// Rewrites talkTitle snapshots on weeks >= [fromWeekId] whose talkNo is in
  /// [titlesByNo] and whose stored title differs. Returns the updated count.
  Future<int> updateTalkTitles(Map<int, String> titlesByNo,
      {required String fromWeekId}) async {
    final weeks = await getRange(fromWeekId, '9999-12-31');
    return updateTalkTitlesIn(weeks, titlesByNo);
  }

  /// Batch-updates [weeks] whose talkNo maps to a differing title.
  Future<int> updateTalkTitlesIn(
      List<WeekendWeek> weeks, Map<int, String> titlesByNo) async {
    final dirty = weeks
        .where((w) =>
            w.talkNo != null &&
            titlesByNo.containsKey(w.talkNo) &&
            titlesByNo[w.talkNo] != w.talkTitle)
        .toList();
    // Firestore caps a WriteBatch at 500 operations.
    for (var i = 0; i < dirty.length; i += 400) {
      final batch = _db.batch();
      for (final w in dirty.skip(i).take(400)) {
        batch.update(_col.doc(w.id), {'talkTitle': titlesByNo[w.talkNo]!});
      }
      await batch.commit();
    }
    return dirty.length;
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
