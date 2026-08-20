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

  /// Departures of deleted records; see [FormerPublisher].
  CollectionReference<Map<String, dynamic>> get _formerCol =>
      _db.collection('former_publishers');

  Publisher _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      Publisher.fromJson(doc.data()!).copyWith(id: doc.id);

  Stream<List<Publisher>> watchAll() => _col.snapshots().map((snap) {
        final list = snap.docs.map(_fromDoc).toList();
        list.sort((a, b) => collate(a.listName, b.listName));
        return list;
      });

  /// One-shot twin of [watchAll], for callbacks that need the roster once
  /// (the PDF exports) rather than a subscription.
  Future<List<Publisher>> getAll() async {
    final snap = await _col.get();
    final list = snap.docs.map(_fromDoc).toList();
    list.sort((a, b) => collate(a.listName, b.listName));
    return list;
  }

  Stream<Publisher?> watchOne(String id) => _col
      .doc(id)
      .snapshots()
      .map((doc) => doc.data() == null ? null : _fromDoc(doc));

  Future<Publisher?> getOne(String id) async {
    final doc = await _col.doc(id).get();
    return doc.data() == null ? null : _fromDoc(doc);
  }

  /// Create with a fixed id (auth uid at self-registration).
  ///
  /// Clears any departure left over from a previous record on the same id:
  /// somebody who deleted their account and registers again arrives on the
  /// very same auth uid, and an old tombstone would silently drop their new
  /// reports from the S-1.
  Future<void> createWithId(String id, Publisher publisher) async {
    await _col.doc(id).set(publisher.toJson());
    try {
      await _formerCol.doc(id).delete();
    } on FirebaseException catch (_) {
      // Nothing to clear, or rules not yet updated: registration must not
      // fail over a document that only matters to the S-1.
    }
  }

  /// Admin-created record for a member without a login.
  Future<String> create(Publisher publisher) async {
    final doc = await _col.add(publisher.toJson());
    return doc.id;
  }

  Future<void> update(Publisher publisher) =>
      _col.doc(publisher.id).set(publisher.toJson());

  /// Removes the record, its private profile and its away periods.
  ///
  /// A record that had moved away leaves a [FormerPublisher] behind first:
  /// their report entries stay under `reports/{month}/entries/{id}`, and
  /// without the departure the months they had already left would start
  /// counting for this congregation again. [known] saves a read for callers
  /// holding the document already.
  Future<void> delete(String id, {Publisher? known}) async {
    final publisher = known ?? await getOne(id);
    if (publisher != null && publisher.moved) {
      await _formerCol.doc(id).set(FormerPublisher(
            movedDate: publisher.movedDate,
            deletedAt: DateTime.now(),
          ).toJson());
    }
    final batch = _db.batch();
    batch.delete(_col.doc(id).collection('private').doc('profile'));
    batch.delete(_awayDoc(id));
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

  /// Private profiles of many publishers, in the order of [publisherIds] and
  /// null where a record has none yet (admin-created records start without
  /// one). One document read per publisher is unavoidable — they live in a
  /// subcollection — so they are fetched in rounds of [batch] rather than all
  /// at once: a large congregation would otherwise open 150 parallel requests.
  /// [onRound] fires after each round, for callers showing progress.
  Future<List<PublisherPrivate?>> getPrivatesBatched(
    List<String> publisherIds, {
    int batch = 10,
    void Function()? onRound,
  }) async {
    final result = <PublisherPrivate?>[];
    for (var i = 0; i < publisherIds.length; i += batch) {
      final round = publisherIds.skip(i).take(batch);
      result.addAll(await Future.wait(round.map(getPrivate)));
      onRound?.call();
    }
    return result;
  }

  DocumentReference<Map<String, dynamic>> _awayDoc(String publisherId) =>
      _col.doc(publisherId).collection('away').doc('periods');

  Stream<PublisherAway> watchAway(String publisherId) =>
      _awayDoc(publisherId).snapshots().map((doc) {
        final data = doc.data();
        return data == null
            ? const PublisherAway()
            : PublisherAway.fromJson(data);
      });

  Future<PublisherAway> getAway(String publisherId) async {
    final doc = await _awayDoc(publisherId).get();
    final data = doc.data();
    return data == null
        ? const PublisherAway()
        : PublisherAway.fromJson(data);
  }

  Future<void> setAway(String publisherId, PublisherAway data) =>
      _awayDoc(publisherId).set(data.toJson());

  /// Departures that outlived their records; see [FormerPublisher]. A handful
  /// of tiny documents at most, so the whole collection is read at once.
  Stream<List<FormerPublisher>> watchFormer() =>
      _formerCol.snapshots().map((snap) => [
            for (final doc in snap.docs)
              FormerPublisher.fromJson(doc.data()).copyWith(id: doc.id),
          ]);
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

/// Mirrors what firestore.rules grants: verified, and not past one's own
/// moving date. Without the second half a publisher whose recorded departure
/// has arrived would still be routed into the app while the backend denies
/// every read, turning a clean "you have moved" state into error screens.
final isVerifiedProvider = Provider<bool>((ref) {
  final me = ref.watch(myPublisherProvider).value;
  return me != null && me.verified && !me.hasMovedBy(DateTime.now());
});

/// All publishers; empty until the user is verified (rules would deny it).
final allPublishersProvider = StreamProvider<List<Publisher>>((ref) {
  if (!ref.watch(isVerifiedProvider)) {
    return Stream.value(const <Publisher>[]);
  }
  return ref.watch(publishersRepositoryProvider).watchAll();
});

/// Departures of publishers whose records have been deleted. Only the report
/// screens need them, and only their admins may read them (firestore.rules),
/// so everyone else gets an empty list rather than a denied query.
final formerPublishersProvider = StreamProvider<List<FormerPublisher>>((ref) {
  final roles = ref.watch(myRolesProvider);
  if (!roles.canEditReports() && !roles.canEditPublishers()) {
    return Stream.value(const <FormerPublisher>[]);
  }
  return ref.watch(publishersRepositoryProvider).watchFormer();
});

/// Quick id -> publisher lookup for rendering assignment names.
final publishersByIdProvider = Provider<Map<String, Publisher>>((ref) {
  final all = ref.watch(allPublishersProvider).value ?? const [];
  return {for (final p in all) p.id: p};
});

/// One-shot twin of [publishersByIdProvider], for the PDF exports.
///
/// [allPublishersProvider] is a StreamProvider, and a StreamProvider's
/// `.future` only completes while something is listening to it. On the
/// schedule screens the only listener is `AssignmentText`, which skips the
/// watch when an assignment is empty — so exporting a month that has nothing
/// assigned yet (exactly when a blank sheet is wanted) would otherwise wait
/// forever. Mirrors the verified guard on [allPublishersProvider].
final publishersByIdOnceProvider =
    FutureProvider<Map<String, Publisher>>((ref) async {
  if (!ref.watch(isVerifiedProvider)) return const {};
  final all = await ref.watch(publishersRepositoryProvider).getAll();
  return {for (final p in all) p.id: p};
});

/// Away periods (vacations) for one publisher. Readable by the publisher
/// themselves and by admins of the sections that assign parts (enforced in
/// firestore.rules), so the assignment picker can flag candidates who are away.
final publisherAwayProvider = StreamProvider.family<PublisherAway, String>(
    (ref, id) => ref.watch(publishersRepositoryProvider).watchAway(id));
