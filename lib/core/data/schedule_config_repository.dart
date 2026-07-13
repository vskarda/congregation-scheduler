import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';

/// Doc ids in the `schedule_config` collection.
class ScheduleConfigDoc {
  static const lmm = 'lmm';
  static const weekend = 'weekend';
}

/// Congregation-level schedule configuration (permanent custom assignments).
/// One document per meeting type; see [ScheduleConfig].
class ScheduleConfigRepository {
  ScheduleConfigRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('schedule_config');

  Stream<ScheduleConfig> watchConfig(String docId) =>
      _col.doc(docId).snapshots().map((doc) {
        final data = doc.data();
        return data == null ? const ScheduleConfig() : ScheduleConfig.fromJson(data);
      });

  Future<void> saveConfig(String docId, ScheduleConfig config) =>
      _col.doc(docId).set(config.toJson());
}

final scheduleConfigRepositoryProvider = Provider<ScheduleConfigRepository>(
  (ref) => ScheduleConfigRepository(ref.watch(firestoreProvider)),
);

/// Permanent custom assignments for the midweek (LMM) meeting.
final lmmPermanentAssignmentsProvider =
    StreamProvider<List<CustomAssignment>>((ref) {
  return ref
      .watch(scheduleConfigRepositoryProvider)
      .watchConfig(ScheduleConfigDoc.lmm)
      .map((c) => c.permanentAssignments);
});

/// Permanent custom assignments for the weekend meeting.
final weekendPermanentAssignmentsProvider =
    StreamProvider<List<CustomAssignment>>((ref) {
  return ref
      .watch(scheduleConfigRepositoryProvider)
      .watchConfig(ScheduleConfigDoc.weekend)
      .map((c) => c.permanentAssignments);
});
