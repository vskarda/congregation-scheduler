import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';

class CongregationRepository {
  CongregationRepository(this._db);

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> get _meta =>
      _db.collection('congregation').doc('meta');

  Stream<CongregationMeta?> watchMeta() => _meta.snapshots().map((s) {
        final data = s.data();
        return data == null ? null : CongregationMeta.fromJson(data);
      });

  /// One-shot read used to positively determine congregation state before
  /// writing (so a transient permission denial is never mistaken for "the
  /// congregation already exists"). Null when the document does not exist.
  Future<CongregationMeta?> getMeta() async {
    final snap = await _meta.get();
    final data = snap.data();
    return data == null ? null : CongregationMeta.fromJson(data);
  }

  /// Succeeds only for the very first caller (rules allow create-if-absent).
  Future<void> createMeta(CongregationMeta meta) => _meta.set(meta.toJson());

  Future<void> updateMeta(CongregationMeta meta) =>
      _meta.set(meta.toJson(), SetOptions(merge: true));
}

final congregationRepositoryProvider = Provider<CongregationRepository>(
    (ref) => CongregationRepository(ref.watch(firestoreProvider)));

final congregationMetaProvider = StreamProvider<CongregationMeta?>((ref) {
  if (ref.watch(currentUidProvider) == null) {
    return Stream.value(null);
  }
  return ref.watch(congregationRepositoryProvider).watchMeta();
});
