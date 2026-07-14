import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congregation_scheduler/core/data/infoboard_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InfoboardRepository.downloadFile', () {
    late FakeFirebaseFirestore db;
    late InfoboardRepository repo;

    final payload = Uint8List.fromList(List.generate(2500, (i) => i % 256));

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = InfoboardRepository(db);
    });

    // Seeds files/{id} meta + chunk docs, mapping each chunk's bytes through
    // [encodeChunk] so the test controls how `data` is stored.
    Future<String> seedFile(
      Object Function(Uint8List chunk) encodeChunk, {
      int chunkSize = 900,
    }) async {
      final fileDoc = db.collection('files').doc();
      final chunkCount = (payload.length / chunkSize).ceil();
      for (var i = 0; i < chunkCount; i++) {
        final start = i * chunkSize;
        final end =
            (start + chunkSize) > payload.length ? payload.length : start + chunkSize;
        await fileDoc
            .collection('chunks')
            .doc(i.toString())
            .set({'data': encodeChunk(payload.sublist(start, end))});
      }
      await fileDoc.set({
        'name': 'doc.pdf',
        'mimeType': 'application/pdf',
        'sizeBytes': payload.length,
        'chunkCount': chunkCount,
      });
      return fileDoc.id;
    }

    test('reconstructs chunks stored as Blob (current write path)', () async {
      final id = await seedFile((chunk) => Blob(chunk));
      expect(await repo.downloadFile(id), payload);
    });

    test('reconstructs chunks stored as an int array (legacy web SDK)',
        () async {
      // Older cloud_firestore_web serialized Blob as a plain array; on iOS it
      // surfaced as List<dynamic> and the old `as Blob` cast threw.
      final id = await seedFile((chunk) => chunk.toList());
      expect(await repo.downloadFile(id), payload);
    });

    test('throws when a chunk is missing', () async {
      final fileDoc = db.collection('files').doc();
      await fileDoc.set({
        'name': 'doc.pdf',
        'mimeType': 'application/pdf',
        'sizeBytes': payload.length,
        'chunkCount': 1,
      });
      expect(repo.downloadFile(fileDoc.id), throwsStateError);
    });
  });
}
