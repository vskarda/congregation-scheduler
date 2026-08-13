import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';
import '../utils/dates.dart';
import 'publishers_repository.dart';

/// Circuit overseer visits, one document per visit keyed by the Monday of its
/// week (`yyyy-MM-dd`), exactly like the schedule week documents. A visit
/// always runs Tuesday to Sunday inside that week.
///
/// The meetings for field service held during the visit are *not* stored here:
/// they stay in `fsm_meetings`, so the two views edit one set of documents.
class CoVisitRepository {
  CoVisitRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('co_visits');

  CoVisit _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      CoVisit.fromJson(doc.data()!).copyWith(id: doc.id);

  /// Every visit, earliest first. A congregation has a handful per year, so
  /// the whole collection is read at once to fill the visit picker.
  Stream<List<CoVisit>> watchAll() => _col.snapshots().map((snap) {
        final list = snap.docs.map(_fromDoc).toList();
        list.sort((a, b) => a.id.compareTo(b.id));
        return list;
      });

  Stream<CoVisit?> watchOne(String weekId) => _col
      .doc(weekId)
      .snapshots()
      .map((doc) => doc.data() == null ? null : _fromDoc(doc));

  Future<void> save(CoVisit visit) =>
      _col.doc(visit.id).set(visit.withRecomputedAssignees().toJson());

  Future<void> delete(String weekId) => _col.doc(weekId).delete();

  /// Visits in `[fromId, toId]` (Monday keys); used for history-based
  /// ordering in the publisher picker.
  Future<List<CoVisit>> getRange(String fromId, String toId) async {
    final snap = await _col
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: fromId)
        .where(FieldPath.documentId, isLessThanOrEqualTo: toId)
        .get();
    return snap.docs.map(_fromDoc).toList();
  }

  /// All visits that mention [uid]; the caller filters for upcoming ones
  /// (data volume is small and this avoids composite-index requirements).
  Future<List<CoVisit>> getAssignedTo(String uid) async {
    final snap = await _col.where('allAssigneeIds', arrayContains: uid).get();
    return snap.docs.map(_fromDoc).toList();
  }

  /// Rewrites every reference to [fromId] onto [toId]; used when connecting an
  /// admin-created record to a registered account. Idempotent.
  Future<void> replaceAssigneeInAll(String fromId, String toId) async {
    final visits = await getAssignedTo(fromId);
    // Firestore caps a WriteBatch at 500 operations.
    for (var i = 0; i < visits.length; i += 400) {
      final batch = _db.batch();
      for (final visit in visits.skip(i).take(400)) {
        batch.set(_col.doc(visit.id),
            visit.replaceAssignee(fromId, toId).toJson());
      }
      await batch.commit();
    }
  }
}

final coVisitRepositoryProvider = Provider<CoVisitRepository>(
    (ref) => CoVisitRepository(ref.watch(firestoreProvider)));

/// Every planned visit; empty until the user is verified (rules deny it).
final coVisitsProvider = StreamProvider<List<CoVisit>>((ref) {
  if (!ref.watch(isVerifiedProvider)) return Stream.value(const <CoVisit>[]);
  return ref.watch(coVisitRepositoryProvider).watchAll();
});

/// One visit by its week id (the Monday key); null when none is planned.
final coVisitProvider = StreamProvider.family<CoVisit?, String>((ref, weekId) {
  if (!ref.watch(isVerifiedProvider)) return Stream.value(null);
  return ref.watch(coVisitRepositoryProvider).watchOne(weekId);
});

/// Week ids (Monday keys) that a circuit overseer's visit falls in. Used to
/// decide whether a meeting for field service shows its circuit-overseer
/// companion slots.
final coVisitWeekIdsProvider = Provider<Set<String>>((ref) =>
    {for (final visit in ref.watch(coVisitsProvider).value ?? const <CoVisit>[])
      visit.id});

/// Whether [date] (`yyyy-MM-dd`) falls in a week the circuit overseer visits
/// — the condition for a meeting for field service to offer its companion
/// slots. Tolerates an unparseable date (an unset one) by answering false.
bool isCoVisitDate(Set<String> coVisitWeekIds, String date) {
  final day = tryParseDateKey(date);
  return day != null && coVisitWeekIds.contains(weekIdOf(day));
}

/// The visit to open the view on: the next one that has not finished yet,
/// otherwise the most recent past one, otherwise null.
String? defaultCoVisitWeekId(List<CoVisit> visits, {DateTime? now}) {
  if (visits.isEmpty) return null;
  final thisWeek = weekIdOf(now ?? DateTime.now());
  for (final visit in visits) {
    if (visit.id.compareTo(thisWeek) >= 0) return visit.id;
  }
  return visits.last.id;
}
