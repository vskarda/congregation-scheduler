import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';
import 'firestore_json.dart';

/// File tag written into (and verified when reading) a backup.
const backupFormat = 'congregation_scheduler.backup';
const backupFormatVersion = 1;

/// Top-level collections dumped as a flat list of `{id, data}` documents.
/// `publishers` (private profile subcollection) and `reports` (month/entries)
/// are handled separately. Info-board file *binaries* (`files/{id}/chunks`) are
/// intentionally excluded — only the `files/{id}` metadata doc is kept.
const _flatCollections = [
  'congregation',
  'infoboard_items',
  'files',
  'events',
  'lmm_weeks',
  'weekend_weeks',
  'schedule_config',
  'public_talks',
  'pw_recurring',
  'pw_slots',
  'pw_applications',
  'fsm_recurring',
  'fsm_meetings',
  'territories',
  'territory_assignments',
  'ministry_groups',
  'attendance',
];

/// Thrown by [BackupService.importAll] when the file is not a recognised,
/// supported backup. The UI surfaces this as an "invalid file" message.
class BackupFormatException implements Exception {
  const BackupFormatException(this.reason);
  final String reason;
  @override
  String toString() => 'BackupFormatException: $reason';
}

/// Outcome of a restore: how many documents each collection wrote, and any
/// collection that failed entirely (e.g. a rule denied the write) with reason.
class BackupImportResult {
  const BackupImportResult({required this.restored, required this.failed});
  final Map<String, int> restored;
  final Map<String, String> failed;

  int get totalRestored => restored.values.fold(0, (a, b) => a + b);
  bool get hasFailures => failed.isNotEmpty;
}

/// Exports every congregation collection to a JSON-able map and restores it.
/// All operations require a full admin (the only role that can read/write every
/// collection); the calling screen is already gated on `roles.fullAdmin`.
class BackupService {
  BackupService(this._db);

  final FirebaseFirestore _db;

  /// Reads the entire congregation into the backup structure. Serialise the
  /// result with `JsonEncoder.withIndent`.
  Future<Map<String, dynamic>> exportAll({
    required String congregationName,
  }) async {
    final collections = <String, dynamic>{};
    for (final name in _flatCollections) {
      collections[name] = await _dumpFlat(name);
    }
    collections['publishers'] = await _dumpPublishers();
    collections['reports'] = await _dumpReports();

    return {
      'format': backupFormat,
      'formatVersion': backupFormatVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'congregationName': congregationName,
      'collections': collections,
    };
  }

  Future<List<Map<String, dynamic>>> _dumpFlat(String name) async {
    final snap = await _db.collection(name).get();
    return [
      for (final d in snap.docs)
        {'id': d.id, 'data': encodeFirestoreData(d.data())},
    ];
  }

  Future<List<Map<String, dynamic>>> _dumpPublishers() async {
    final snap = await _db.collection('publishers').get();
    final out = <Map<String, dynamic>>[];
    for (final d in snap.docs) {
      final node = <String, dynamic>{
        'id': d.id,
        'data': encodeFirestoreData(d.data()),
      };
      final priv =
          await _db.collection('publishers').doc(d.id).collection('private').get();
      if (priv.docs.isNotEmpty) {
        node['subcollections'] = {
          'private': [
            for (final p in priv.docs)
              {'id': p.id, 'data': encodeFirestoreData(p.data())},
          ],
        };
      }
      out.add(node);
    }
    return out;
  }

  /// `reports/{month}` parent docs are never written (and rules forbid it), so
  /// they can't be listed — enumerate the entries across all months with a
  /// collection-group query and regroup them by month. Deployments whose rules
  /// predate the `{path=**}/entries` collection-group rule deny that query;
  /// fall back to probing each month key directly (those per-month reads are
  /// allowed by the original rules).
  Future<List<Map<String, dynamic>>> _dumpReports() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
    try {
      final snap = await _db.collectionGroup('entries').get();
      docs = [
        for (final d in snap.docs)
          if (d.reference.parent.parent?.parent.id == 'reports') d,
      ];
    } catch (_) {
      docs = await probeReportEntries();
    }
    final byMonth = <String, List<Map<String, dynamic>>>{};
    for (final d in docs) {
      byMonth.putIfAbsent(d.reference.parent.parent!.id, () => []).add(
            {'id': d.id, 'data': encodeFirestoreData(d.data())},
          );
    }
    return [
      for (final e in byMonth.entries)
        {
          'id': e.key,
          'subcollections': {'entries': e.value},
        },
    ];
  }

  /// Fallback month enumeration: query every `reports/{yyyy-MM}/entries` in
  /// [reportProbeMonths] directly. Bounded window — S-21 imports can carry
  /// history several service years back, so the floor is generous; empty
  /// months cost one read each.
  @visibleForTesting
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      probeReportEntries() async {
    final months = reportProbeMonths();
    final docs = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
    for (var i = 0; i < months.length; i += 24) {
      final snaps = await Future.wait(months.skip(i).take(24).map((m) =>
          _db.collection('reports').doc(m).collection('entries').get()));
      for (final s in snaps) {
        docs.addAll(s.docs);
      }
    }
    return docs;
  }

  /// Overwrites current documents with those in [backup] (matching by ID);
  /// documents not present in the backup are left untouched. Each document is
  /// written individually (not batched — batches are atomic, so one doc a rule
  /// denies would sink 500 others) and failures are collected per collection,
  /// so a restore recovers everything it possibly can.
  Future<BackupImportResult> importAll(Map<String, dynamic> backup) async {
    _validate(backup);
    final collections =
        (backup['collections'] as Map).cast<String, dynamic>();
    final restored = <String, int>{};
    final failed = <String, String>{};

    for (final entry in collections.entries) {
      final name = entry.key;
      var ok = 0;
      var failCount = 0;
      String? firstError;
      try {
        final writes = <_Write>[];
        for (final raw in (entry.value as List)) {
          _collectWrites(
            _db.collection(name),
            (raw as Map).cast<String, dynamic>(),
            writes,
          );
        }
        for (var i = 0; i < writes.length; i += 20) {
          await Future.wait(writes.skip(i).take(20).map((w) async {
            try {
              await w.ref.set(w.data);
              ok++;
            } catch (e) {
              failCount++;
              firstError ??= e.toString();
            }
          }));
        }
      } catch (e) {
        // Malformed collection node — count it failed, keep the docs that
        // already landed.
        failCount++;
        firstError ??= e.toString();
      }
      restored[name] = ok;
      if (failCount > 0) {
        failed[name] = '$failCount: $firstError';
      }
    }
    return BackupImportResult(restored: restored, failed: failed);
  }

  void _collectWrites(
    CollectionReference<Map<String, dynamic>> col,
    Map<String, dynamic> node,
    List<_Write> out,
  ) {
    final ref = col.doc(node['id'] as String);
    // A node without `data` is a phantom parent (e.g. a reports/{month} doc);
    // only its subcollection entries are real.
    if (node.containsKey('data')) {
      final data = (node['data'] as Map).cast<String, dynamic>();
      out.add(_Write(ref, decodeFirestoreData(data, db: _db)));
    }
    final subs = node['subcollections'];
    if (subs is Map) {
      for (final e in subs.entries) {
        final subCol = ref.collection(e.key as String);
        for (final child in (e.value as List)) {
          _collectWrites(subCol, (child as Map).cast<String, dynamic>(), out);
        }
      }
    }
  }

  void _validate(Map<String, dynamic> backup) {
    if (backup['format'] != backupFormat) {
      throw const BackupFormatException('not a congregation backup');
    }
    final version = backup['formatVersion'];
    if (version is! int || version > backupFormatVersion) {
      throw const BackupFormatException('unsupported backup version');
    }
    if (backup['collections'] is! Map) {
      throw const BackupFormatException('backup has no collections');
    }
  }
}

class _Write {
  _Write(this.ref, this.data);
  final DocumentReference<Map<String, dynamic>> ref;
  final Map<String, dynamic> data;
}

/// Month keys probed by the reports fallback: 2000-01 through next month.
List<String> reportProbeMonths() {
  final now = DateTime.now();
  final end = DateTime(now.year, now.month + 1);
  return [
    for (var y = 2000; y <= end.year; y++)
      for (var m = 1; m <= 12; m++)
        if (y < end.year || m <= end.month)
          '$y-${m.toString().padLeft(2, '0')}',
  ];
}

/// Document count per collection (including nested subcollection docs), for the
/// export snackbar and the import preview.
Map<String, int> backupDocCounts(Map<String, dynamic> backup) {
  final collections =
      (backup['collections'] as Map?)?.cast<String, dynamic>() ?? const {};
  return {
    for (final e in collections.entries)
      e.key: _countNodes((e.value as List?) ?? const []),
  };
}

int _countNodes(List<dynamic> nodes) {
  var n = 0;
  for (final raw in nodes) {
    final node = (raw as Map).cast<String, dynamic>();
    if (node.containsKey('data')) n++;
    final subs = node['subcollections'];
    if (subs is Map) {
      for (final s in subs.values) {
        n += _countNodes(s as List);
      }
    }
  }
  return n;
}

final backupServiceProvider = Provider<BackupService>(
    (ref) => BackupService(ref.watch(firestoreProvider)));
