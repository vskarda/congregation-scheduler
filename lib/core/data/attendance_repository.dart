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

  /// Every recorded entry of one meeting type, newest first. Used for the
  /// Memorial, of which there is one a year: the rolling 24-month window the
  /// other readers use would drop most of that history on the floor.
  Stream<List<AttendanceEntry>> watchOfType(MeetingType type) => _col
      .where('meetingType', isEqualTo: type.name)
      .snapshots()
      .map((snap) {
        final list = snap.docs.map(_fromDoc).toList();
        list.sort((a, b) => b.date.compareTo(a.date));
        return list;
      });

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

/// What one meeting of one week deviates in: the day it was moved to (null
/// when it kept the congregation's regular day) and the program it runs.
typedef MeetingWeekState = ({int? weekday, MeetingProgramKind kind});

/// A meeting that deviates in nothing: the fallback for every week the
/// override map has no entry for.
const MeetingWeekState kRegularMeetingWeek =
    (weekday: null, kind: MeetingProgramKind.regular);

/// Weeks in the attendance history window whose meeting deviates from the
/// congregation's regular arrangement: it was moved to another day (a circuit
/// overseer's visit moves the midweek meeting to Tuesday), or it runs another
/// program than usual (nothing planned during an assembly week, or the
/// Memorial). Keyed by week id, one entry per meeting.
///
/// Without this the history would expect a meeting on the regular day, list it
/// as never recorded, and show the real one as a stray extra row — and it
/// would go on expecting a midweek meeting in a week that had none.
final meetingWeekOverridesProvider = FutureProvider<
    Map<String, ({MeetingWeekState lmm, MeetingWeekState weekend})>>(
        (ref) async {
  final from = attendanceHistoryStart();
  final to = dateKey(DateTime.now());
  final lmmRepo = ref.watch(lmmRepositoryProvider);
  final weekendRepo = ref.watch(weekendRepositoryProvider);
  final lmmDays = await lmmRepo.getWeekdayOverrides(from, to);
  final lmmKinds = await lmmRepo.getProgramKinds(from, to);
  final weekendDays = await weekendRepo.getWeekdayOverrides(from, to);
  final weekendKinds = await weekendRepo.getProgramKinds(from, to);
  return {
    for (final weekId in {
      ...lmmDays.keys,
      ...lmmKinds.keys,
      ...weekendDays.keys,
      ...weekendKinds.keys,
    })
      weekId: (
        lmm: (
          weekday: lmmDays[weekId],
          kind: lmmKinds[weekId] ?? MeetingProgramKind.regular,
        ),
        weekend: (
          weekday: weekendDays[weekId],
          kind: weekendKinds[weekId] ?? MeetingProgramKind.regular,
        ),
      ),
  };
});

/// One meeting's counts, keyed by [AttendanceEntry.docId]. Backs the record
/// card in the meeting views, which page far outside the 24-month window
/// [attendanceEntriesProvider] covers.
final attendanceEntryProvider =
    StreamProvider.family<AttendanceEntry?, String>((ref, docId) =>
        ref.watch(attendanceRepositoryProvider).watchDoc(docId));
