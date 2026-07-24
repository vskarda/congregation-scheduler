import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../firebase/firebase_providers.dart';
import '../models/models.dart';

class InfoboardRepository {
  InfoboardRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _items =>
      _db.collection('infoboard_items');

  CollectionReference<Map<String, dynamic>> get _files =>
      _db.collection('files');

  InfoboardItem _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      InfoboardItem.fromJson(doc.data()!).copyWith(id: doc.id);

  Stream<List<InfoboardItem>> watchAll() => _items.snapshots().map((snap) {
        final list = snap.docs
            .where((doc) => doc.data()['type'] != 'link')
            .map(_fromDoc)
            .toList();
        list.sort((a, b) {
          final at = a.createdAt ?? DateTime(2000);
          final bt = b.createdAt ?? DateTime(2000);
          return bt.compareTo(at);
        });
        return list;
      });

  /// Deletes legacy announcements stored with the removed `link` type.
  Future<void> purgeLegacyLinkItems() async {
    final snap = await _items.where('type', isEqualTo: 'link').get();
    if (snap.docs.isEmpty) return;
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<void> saveItem(InfoboardItem item) async {
    if (item.id.isEmpty) {
      await _items.add(item.toJson());
    } else {
      await _items.doc(item.id).set(item.toJson());
    }
  }

  Future<void> deleteItem(InfoboardItem item) async {
    if (item.fileId.isNotEmpty) {
      await deleteFile(item.fileId);
    }
    await _items.doc(item.id).delete();
  }

  /// Stores [bytes] as chunked Blob documents. Returns the file id.
  Future<String> uploadFile({
    required Uint8List bytes,
    required String name,
    required String mimeType,
  }) async {
    if (bytes.length > AppConfig.maxFileSizeBytes) {
      throw ArgumentError('file too large');
    }
    final chunkSize = AppConfig.fileChunkBytes;
    final chunkCount = (bytes.length / chunkSize).ceil();
    final fileDoc = _files.doc();
    final meta = StoredFileMeta(
      name: name,
      mimeType: mimeType,
      sizeBytes: bytes.length,
      chunkCount: chunkCount,
    );
    // Chunks first, meta last: a meta doc implies a complete file.
    for (var i = 0; i < chunkCount; i++) {
      final start = i * chunkSize;
      final end =
          (start + chunkSize) > bytes.length ? bytes.length : start + chunkSize;
      await fileDoc
          .collection('chunks')
          .doc(i.toString())
          .set({'data': Blob(bytes.sublist(start, end))});
    }
    await fileDoc.set(meta.toJson());
    return fileDoc.id;
  }

  Future<StoredFileMeta?> getFileMeta(String fileId) async {
    final doc = await _files.doc(fileId).get();
    final data = doc.data();
    return data == null
        ? null
        : StoredFileMeta.fromJson(data).copyWith(id: doc.id);
  }

  Future<Uint8List> downloadFile(String fileId) async {
    final meta = await getFileMeta(fileId);
    if (meta == null) throw StateError('file not found');
    final builder = BytesBuilder(copy: false);
    for (var i = 0; i < meta.chunkCount; i++) {
      final chunk =
          await _files.doc(fileId).collection('chunks').doc(i.toString()).get();
      final bytes = _chunkBytes(chunk.data()?['data']);
      if (bytes == null) throw StateError('missing chunk $i');
      builder.add(bytes);
    }
    return builder.takeBytes();
  }

  /// Chunk payloads are normally Firestore [Blob]s, but files uploaded via an
  /// older web SDK stored them as a plain int array. Accept both so those
  /// legacy files still open — on iOS the array surfaces as `List<dynamic>`
  /// and the old `as Blob` cast threw.
  static Uint8List? _chunkBytes(Object? raw) {
    if (raw is Blob) return raw.bytes;
    if (raw is List) return Uint8List.fromList(raw.cast<int>());
    return null;
  }

  Future<void> deleteFile(String fileId) async {
    final meta = await getFileMeta(fileId);
    final batch = _db.batch();
    if (meta != null) {
      for (var i = 0; i < meta.chunkCount; i++) {
        batch.delete(_files.doc(fileId).collection('chunks').doc(i.toString()));
      }
    }
    batch.delete(_files.doc(fileId));
    await batch.commit();
  }
}

final infoboardRepositoryProvider = Provider<InfoboardRepository>(
    (ref) => InfoboardRepository(ref.watch(firestoreProvider)));

final infoboardItemsProvider = StreamProvider<List<InfoboardItem>>(
    (ref) => ref.watch(infoboardRepositoryProvider).watchAll());
