import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';
import '../utils/dates.dart';

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
