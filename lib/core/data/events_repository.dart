import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';

class EventsRepository {
  EventsRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('events');

  EventItem _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      EventItem.fromJson(doc.data()!).copyWith(id: doc.id);

  Stream<List<EventItem>> watchAll() => _col.snapshots().map((snap) {
        final list = snap.docs.map(_fromDoc).toList();
        list.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
        return list;
      });

  Future<void> save(EventItem event) async {
    if (event.id.isEmpty) {
      await _col.add(event.toJson());
    } else {
      await _col.doc(event.id).set(event.toJson());
    }
  }

  Future<EventItem?> getOne(String id) async {
    final doc = await _col.doc(id).get();
    return doc.data() == null ? null : _fromDoc(doc);
  }

  Future<void> delete(String id) => _col.doc(id).delete();

  /// Deterministic id of the event entry that announces the circuit
  /// overseer's visit of [weekId] on the events screen. Deterministic so
  /// re-saving a visit updates the one entry instead of adding another.
  static String coVisitEventId(String weekId) => 'covisit_$weekId';
}

final eventsRepositoryProvider = Provider<EventsRepository>(
    (ref) => EventsRepository(ref.watch(firestoreProvider)));

final eventsProvider = StreamProvider<List<EventItem>>((ref) {
  if (!ref.watch(currentUidProvider.select((uid) => uid != null))) {
    return Stream.value(const <EventItem>[]);
  }
  return ref.watch(eventsRepositoryProvider).watchAll();
});
