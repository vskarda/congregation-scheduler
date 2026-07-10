import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';

class TalkCatalogRepository {
  TalkCatalogRepository(this._db);

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _db.collection('public_talks').doc('catalog');

  Stream<TalkCatalog?> watchCatalog() => _doc.snapshots().map(
      (doc) => doc.data() == null ? null : TalkCatalog.fromJson(doc.data()!));

  Future<void> saveCatalog(TalkCatalog catalog) => _doc.set(catalog.toJson());
}

final talkCatalogRepositoryProvider = Provider<TalkCatalogRepository>(
    (ref) => TalkCatalogRepository(ref.watch(firestoreProvider)));

final talkCatalogProvider = StreamProvider<TalkCatalog?>(
    (ref) => ref.watch(talkCatalogRepositoryProvider).watchCatalog());
