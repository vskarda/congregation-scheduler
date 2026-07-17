import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';
import '../utils/collation.dart';

class PublishersRepository {
  PublishersRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('publishers');

  Publisher _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      Publisher.fromJson(doc.data()!).copyWith(id: doc.id);

  Stream<List<Publisher>> watchAll() => _col.snapshots().map((snap) {
        final list = snap.docs.map(_fromDoc).toList();
        list.sort((a, b) => collate(a.listName, b.listName));
        return list;
      });

  Stream<Publisher?> watchOne(String id) => _col
      .doc(id)
      .snapshots()
      .map((doc) => doc.data() == null ? null : _fromDoc(doc));

  Future<Publisher?> getOne(String id) async {
    final doc = await _col.doc(id).get();
    return doc.data() == null ? null : _fromDoc(doc);
  }

  /// Create with a fixed id (auth uid at self-registration).
  Future<void> createWithId(String id, Publisher publisher) =>
      _col.doc(id).set(publisher.toJson());

  /// Admin-created record for a member without a login.
  Future<String> create(Publisher publisher) async {
    final doc = await _col.add(publisher.toJson());
    return doc.id;
  }

  Future<void> update(Publisher publisher) =>
      _col.doc(publisher.id).set(publisher.toJson());

  Future<void> delete(String id) async {
    final batch = _db.batch();
    batch.delete(_col.doc(id).collection('private').doc('profile'));
    batch.delete(_col.doc(id));
    await batch.commit();
  }

  DocumentReference<Map<String, dynamic>> _privateDoc(String publisherId) =>
      _col.doc(publisherId).collection('private').doc('profile');

  Stream<PublisherPrivate?> watchPrivate(String publisherId) =>
      _privateDoc(publisherId).snapshots().map((doc) {
        final data = doc.data();
        return data == null ? null : PublisherPrivate.fromJson(data);
      });

  Future<PublisherPrivate?> getPrivate(String publisherId) async {
    final doc = await _privateDoc(publisherId).get();
    final data = doc.data();
    return data == null ? null : PublisherPrivate.fromJson(data);
  }

  Future<void> setPrivate(String publisherId, PublisherPrivate data) =>
      _privateDoc(publisherId).set(data.toJson());
}

final publishersRepositoryProvider = Provider<PublishersRepository>(
    (ref) => PublishersRepository(ref.watch(firestoreProvider)));

/// The signed-in user's publisher document (null while signed out or before
/// the doc exists).
final myPublisherProvider = StreamProvider<Publisher?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);
  return ref.watch(publishersRepositoryProvider).watchOne(uid);
});

final myRolesProvider = Provider<Roles>(
    (ref) => ref.watch(myPublisherProvider).value?.roles ?? const Roles());

final isVerifiedProvider = Provider<bool>(
    (ref) => ref.watch(myPublisherProvider).value?.verified ?? false);

/// All publishers; empty until the user is verified (rules would deny it).
final allPublishersProvider = StreamProvider<List<Publisher>>((ref) {
  if (!ref.watch(isVerifiedProvider)) {
    return Stream.value(const <Publisher>[]);
  }
  return ref.watch(publishersRepositoryProvider).watchAll();
});

/// Quick id -> publisher lookup for rendering assignment names.
final publishersByIdProvider = Provider<Map<String, Publisher>>((ref) {
  final all = ref.watch(allPublishersProvider).value ?? const [];
  return {for (final p in all) p.id: p};
});
