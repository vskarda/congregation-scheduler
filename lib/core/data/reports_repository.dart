import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';

class ReportsRepository {
  ReportsRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _entries(String month) =>
      _db.collection('reports').doc(month).collection('entries');

  MinistryReport _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      MinistryReport.fromJson(doc.data()!).copyWith(publisherId: doc.id);

  Stream<MinistryReport?> watchMine(String month, String publisherId) =>
      _entries(month).doc(publisherId).snapshots().map(
          (doc) => doc.data() == null ? null : _fromDoc(doc));

  Future<void> submit(MinistryReport report) => _entries(report.month)
      .doc(report.publisherId)
      .set(report.toJson());

  /// Batched write of many reports (S-21 import); chunked to stay under the
  /// 500-operation batch limit.
  Future<void> submitMany(List<MinistryReport> reports) async {
    for (var i = 0; i < reports.length; i += 500) {
      final batch = _db.batch();
      for (final r in reports.skip(i).take(500)) {
        batch.set(_entries(r.month).doc(r.publisherId), r.toJson());
      }
      await batch.commit();
    }
  }

  Future<void> delete(String month, String publisherId) =>
      _entries(month).doc(publisherId).delete();

  /// Admin overview of one month.
  Stream<List<MinistryReport>> watchMonth(String month) =>
      _entries(month).snapshots().map(
          (snap) => snap.docs.map(_fromDoc).toList());

  Future<List<MinistryReport>> getMonth(String month) async {
    final snap = await _entries(month).get();
    return snap.docs.map(_fromDoc).toList();
  }

  /// Own reports for the given months (publisher record view); direct doc
  /// gets so rules allow it for non-admins.
  Future<Map<String, MinistryReport?>> getMineForMonths(
      String publisherId, List<String> months) async {
    final result = <String, MinistryReport?>{};
    await Future.wait(months.map((month) async {
      final doc = await _entries(month).doc(publisherId).get();
      result[month] = doc.data() == null ? null : _fromDoc(doc);
    }));
    return result;
  }

  /// Moves report entries from [fromId] to [toId] for every month in
  /// [months] (report ids are `reports/{month}/entries/{publisherId}`, so a
  /// rename means copy + delete). A month where [toId] already has an entry
  /// keeps it; the [fromId] duplicate is dropped. Idempotent — used when
  /// connecting an admin-created record to a registered account.
  Future<void> migratePublisherId(
      String fromId, String toId, List<String> months) async {
    await Future.wait(months.map((month) async {
      final fromRef = _entries(month).doc(fromId);
      final data = (await fromRef.get()).data();
      if (data == null) return;
      final toRef = _entries(month).doc(toId);
      final batch = _db.batch();
      if ((await toRef.get()).data() == null) batch.set(toRef, data);
      batch.delete(fromRef);
      await batch.commit();
    }));
  }
}

final reportsRepositoryProvider = Provider<ReportsRepository>(
    (ref) => ReportsRepository(ref.watch(firestoreProvider)));

final monthReportsProvider =
    StreamProvider.family<List<MinistryReport>, String>((ref, month) =>
        ref.watch(reportsRepositoryProvider).watchMonth(month));

final myReportProvider =
    StreamProvider.family<MinistryReport?, String>((ref, month) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);
  return ref.watch(reportsRepositoryProvider).watchMine(month, uid);
});
