import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';

/// Frozen S-1 figures, one document per month at `s1_records/{yyyy-MM}`.
///
/// The collection also holds [autoFreezeDocId], the sweep's bookmark; it is a
/// plain document beside the months, so month ids are recognised by shape
/// rather than by exclusion.
class S1Repository {
  S1Repository(this._db);

  /// Bookmark of the automatic freeze sweep: the newest month it has already
  /// considered. A leading underscore cannot collide with a `yyyy-MM` key.
  static const autoFreezeDocId = '_autofreeze';

  static final _monthId = RegExp(r'^\d{4}-\d{2}$');

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('s1_records');

  /// Every frozen month, keyed by month. A dozen small documents per year, so
  /// the whole collection is read at once — and read rather than watched:
  /// frozen figures change only when someone on this device presses the
  /// button, so an always-open listener would spend reads on nothing.
  ///
  /// Deployments whose rules predate the `s1_records` block deny the read;
  /// that yields an empty map so the S-1 keeps working (unfrozen) until the
  /// admin re-pastes the rules. Pressing Freeze then reports the real error,
  /// which is where it is actionable.
  Future<Map<String, S1Record>> getAll() async {
    final QuerySnapshot<Map<String, dynamic>> snap;
    try {
      snap = await _col.get();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') return const {};
      rethrow;
    }
    return {
      for (final doc in snap.docs)
        if (_monthId.hasMatch(doc.id))
          doc.id: S1Record.fromJson(doc.data()).copyWith(month: doc.id),
    };
  }

  Future<void> freeze(S1Record record) =>
      _col.doc(record.month).set(record.toJson());

  Future<void> unfreeze(String month) => _col.doc(month).delete();

  /// Newest month the automatic sweep has already looked at, or null when it
  /// has never run here.
  Future<String?> autoFreezeScannedThrough() async {
    final data = (await _col.doc(autoFreezeDocId).get()).data();
    final value = data?['scannedThrough'];
    return value is String && _monthId.hasMatch(value) ? value : null;
  }

  Future<void> saveAutoFreezeScannedThrough(String month) =>
      _col.doc(autoFreezeDocId).set({'scannedThrough': month});
}

final s1RepositoryProvider =
    Provider<S1Repository>((ref) => S1Repository(ref.watch(firestoreProvider)));
