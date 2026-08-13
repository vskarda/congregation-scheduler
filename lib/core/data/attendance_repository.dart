import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';
import '../utils/dates.dart';
import 'lmm_repository.dart';
import 'weekend_repository.dart';

class AttendanceRepository {
  AttendanceRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('attendance');

  AttendanceEntry _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      AttendanceEntry.fromJson(doc.data()!).copyWith(id: doc.id);

  Stream<List<AttendanceEntry>> watchRange(String fromDate, String toDate) =>
      _col
          .where('date', isGreaterThanOrEqualTo: fromDate)
          .where('date', isLessThanOrEqualTo: toDate)
          .snapshots()
          .map((snap) {
        final list = snap.docs.map(_fromDoc).toList();
        list.sort((a, b) => b.date.compareTo(a.date));
        return list;
      });

  Future<List<AttendanceEntry>> getRange(String fromDate, String toDate) async {
    final snap = await _col
        .where('date', isGreaterThanOrEqualTo: fromDate)
        .where('date', isLessThanOrEqualTo: toDate)
        .get();
    return snap.docs.map(_fromDoc).toList();
  }

  /// One meeting's entry, or null when nothing has been recorded for it.
  Stream<AttendanceEntry?> watchDoc(String docId) =>
      _col.doc(docId).snapshots().map((d) => d.exists ? _fromDoc(d) : null);

  /// Doc id {date}_{type} makes saving idempotent per meeting.
  Future<void> upsert(AttendanceEntry entry) => _col
      .doc(AttendanceEntry.docId(entry.date, entry.meetingType))
      .set(entry.toJson());

  Future<void> delete(String id) => _col.doc(id).delete();
}

final attendanceRepositoryProvider = Provider<AttendanceRepository>(
    (ref) => AttendanceRepository(ref.watch(firestoreProvider)));

/// First day of the oldest month in the rolling 24-month history window.
String attendanceHistoryStart() =>
    '${monthKey(addMonths(DateTime.now(), -23))}-01';

/// The rolling 24-month attendance history, shared by the attendance and
/// statistics screens.
final attendanceEntriesProvider =
    StreamProvider<List<AttendanceEntry>>((ref) {
  final to = dateKey(DateTime.now().add(const Duration(days: 7)));
  return ref
      .watch(attendanceRepositoryProvider)
      .watchRange(attendanceHistoryStart(), to);
});

/// Weeks in the attendance history window whose meeting was held on another
/// day than usual (a circuit overseer's visit moves the midweek meeting to
/// Tuesday, an assembly moves the weekend meeting). Keyed by week id; either
/// entry is null when that meeting kept its regular day.
///
/// Without this the history would expect a meeting on the regular day, list
/// it as never recorded, and show the real one as a stray extra row.
final meetingWeekdayOverridesProvider =
    FutureProvider<Map<String, ({int? lmm, int? weekend})>>((ref) async {
  final from = attendanceHistoryStart();
  final to = dateKey(DateTime.now());
  final lmm =
      await ref.watch(lmmRepositoryProvider).getWeekdayOverrides(from, to);
  final weekend =
      await ref.watch(weekendRepositoryProvider).getWeekdayOverrides(from, to);
  return {
    for (final weekId in {...lmm.keys, ...weekend.keys})
      weekId: (lmm: lmm[weekId], weekend: weekend[weekId]),
  };
});

/// One meeting's counts, keyed by [AttendanceEntry.docId]. Backs the record
/// card in the meeting views, which page far outside the 24-month window
/// [attendanceEntriesProvider] covers.
final attendanceEntryProvider =
    StreamProvider.family<AttendanceEntry?, String>((ref, docId) =>
        ref.watch(attendanceRepositoryProvider).watchDoc(docId));
