import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';
import 'publishers_repository.dart';

class MinistryGroupsRepository {
  MinistryGroupsRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('ministry_groups');

  CollectionReference<Map<String, dynamic>> get _publishers =>
      _db.collection('publishers');

  MinistryGroup _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      MinistryGroup.fromJson(doc.data()!).copyWith(id: doc.id);

  Stream<List<MinistryGroup>> watchAll() => _col.snapshots().map((snap) {
        final list = snap.docs.map(_fromDoc).toList();
        list.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        return list;
      });

  Future<void> saveGroup(MinistryGroup group) async {
    if (group.id.isEmpty) {
      await _col.add(group.toJson());
    } else {
      await _col.doc(group.id).set(group.toJson());
    }
  }

  /// Deletes the group and clears membership on all its members in one
  /// batch. [memberIds] is passed in because members are derived from the
  /// publishers stream, not stored on the group doc.
  Future<void> deleteGroup(String groupId, List<String> memberIds) async {
    final batch = _db.batch();
    for (final id in memberIds) {
      batch.update(_publishers.doc(id), {'groupId': FieldValue.delete()});
    }
    batch.delete(_col.doc(groupId));
    await batch.commit();
  }

  /// Moves [publisher] into [groupId] (null = no group). Single entry point
  /// for all membership changes: if the publisher leaves [previousGroup]
  /// where they were overseer/assistant, that designation is cleared
  /// atomically in the same batch.
  Future<void> setPublisherGroup(
      Publisher publisher, String? groupId, MinistryGroup? previousGroup) async {
    final batch = _db.batch();
    // Full set(): with includeIfNull:false a null groupId omits the key,
    // which removes it from the doc (repo convention, no merge).
    batch.set(_publishers.doc(publisher.id),
        publisher.copyWith(groupId: groupId).toJson());
    if (previousGroup != null &&
        previousGroup.id != groupId &&
        (previousGroup.overseerId == publisher.id ||
            previousGroup.assistantId == publisher.id)) {
      batch.set(
          _col.doc(previousGroup.id),
          previousGroup
              .copyWith(
                overseerId: previousGroup.overseerId == publisher.id
                    ? ''
                    : previousGroup.overseerId,
                assistantId: previousGroup.assistantId == publisher.id
                    ? ''
                    : previousGroup.assistantId,
              )
              .toJson());
    }
    await batch.commit();
  }
}

final ministryGroupsRepositoryProvider = Provider<MinistryGroupsRepository>(
    (ref) => MinistryGroupsRepository(ref.watch(firestoreProvider)));

/// All groups; empty until the user is verified (rules would deny it).
final ministryGroupsProvider = StreamProvider<List<MinistryGroup>>((ref) {
  if (!ref.watch(isVerifiedProvider)) {
    return Stream.value(const <MinistryGroup>[]);
  }
  return ref.watch(ministryGroupsRepositoryProvider).watchAll();
});
