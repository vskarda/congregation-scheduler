import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';

class SongCatalogRepository {
  SongCatalogRepository(this._db);

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _db.collection('song_catalog').doc('catalog');

  Stream<SongCatalog?> watchCatalog() => _doc.snapshots().map(
      (doc) => doc.data() == null ? null : SongCatalog.fromJson(doc.data()!));

  Future<void> saveCatalog(SongCatalog catalog) => _doc.set(catalog.toJson());
}

final songCatalogRepositoryProvider = Provider<SongCatalogRepository>(
    (ref) => SongCatalogRepository(ref.watch(firestoreProvider)));

final songCatalogProvider = StreamProvider<SongCatalog?>(
    (ref) => ref.watch(songCatalogRepositoryProvider).watchCatalog());
