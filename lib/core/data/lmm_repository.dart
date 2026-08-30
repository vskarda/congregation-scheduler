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

  /// Weeks in `[fromId, toId]` whose meeting was moved off the congregation's
  /// regular weekday, as `weekId -> weekday`.
  ///
  /// `meetingWeekday` is absent from every week that follows the regular
  /// setting (`includeIfNull: false`), so this query returns only the handful
  /// that deviate. The id range is applied here rather than in the query
  /// because Firestore would need a composite index for the second bound.
  Future<Map<String, int>> getWeekdayOverrides(
      String fromId, String toId) async {
    final snap =
        await _col.where('meetingWeekday', isGreaterThanOrEqualTo: 1).get();
    return {
      for (final doc in snap.docs)
        if (doc.id.compareTo(fromId) >= 0 && doc.id.compareTo(toId) <= 0)
          doc.id: _fromDoc(doc).meetingWeekday!,
    };
  }

  /// Weeks in `[fromId, toId]` that do not run their regular program, as
  /// `weekId -> kind`.
  ///
  /// `programKind` is only ever the default on the weeks that run the regular
  /// program, so the `whereIn` returns just the handful that deviate. The id
  /// range is applied here rather than in the query for the same reason as in
  /// [getWeekdayOverrides].
  Future<Map<String, MeetingProgramKind>> getProgramKinds(
      String fromId, String toId) async {
    final snap = await _col.where('programKind', whereIn: [
      MeetingProgramKind.nothingPlanned.name,
      MeetingProgramKind.memorial.name,
    ]).get();
    return {
      for (final doc in snap.docs)
        if (doc.id.compareTo(fromId) >= 0 && doc.id.compareTo(toId) <= 0)
          doc.id: _fromDoc(doc).programKind,
    };
  }

  /// All weeks that mention [uid]; caller filters for upcoming (data volume
  /// is small and this avoids composite-index requirements).
  Future<List<LmmWeek>> getAssignedTo(String uid) async {
    final snap =
        await _col.where('allAssigneeIds', arrayContains: uid).get();
    return snap.docs.map(_fromDoc).toList();
  }

  /// Rewrites every reference to [fromId] onto [toId] across all weeks; used
  /// when connecting an admin-created record to a registered account.
  /// Idempotent (a re-run finds no weeks mentioning [fromId]).
  Future<void> replaceAssigneeInAll(String fromId, String toId) async {
    final weeks = await getAssignedTo(fromId);
    // Firestore caps a WriteBatch at 500 operations.
    for (var i = 0; i < weeks.length; i += 400) {
      final batch = _db.batch();
      for (final w in weeks.skip(i).take(400)) {
        batch.set(_col.doc(w.id), w.replaceAssignee(fromId, toId).toJson());
      }
      await batch.commit();
    }
  }
}

final lmmRepositoryProvider =
    Provider<LmmRepository>((ref) => LmmRepository(ref.watch(firestoreProvider)));

final lmmWeekProvider =
    StreamProvider.family<LmmWeek?, String>((ref, weekId) {
  return ref.watch(lmmRepositoryProvider).watchWeek(weekId);
});
