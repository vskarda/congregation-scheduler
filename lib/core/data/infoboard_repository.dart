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
        final list = snap.docs.map(_fromDoc).toList();
        list.sort((a, b) {
          final at = a.createdAt ?? DateTime(2000);
          final bt = b.createdAt ?? DateTime(2000);
          return bt.compareTo(at);
        });
        return list;
      });

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
      final blob = chunk.data()?['data'] as Blob?;
      if (blob == null) throw StateError('missing chunk $i');
      builder.add(blob.bytes);
    }
    return builder.takeBytes();
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
