import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congregation_scheduler/features/settings/backup/backup_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

/// Seeds a spread of collections, including a real [Timestamp] field, a
/// `publishers/{id}/private/profile` subcollection doc, and
/// `reports/{month}/entries/{pid}` entries.
Future<void> _seed(FakeFirebaseFirestore db) async {
  await db.collection('congregation').doc('meta').set({
    'name': 'Test Congregation',
    'founderUid': 'uid-1',
    'lmmWeekday': 2,
  });
  await db.collection('publishers').doc('uid-1').set({
    'firstName': 'Ada',
    'lastName': 'Lovelace',
    'verified': true,
    'roles': {'fullAdmin': true},
  });
  await db
      .collection('publishers')
      .doc('uid-1')
      .collection('private')
      .doc('profile')
      .set({'phone': '+420123456789', 'email': 'ada@example.com'});
  await db.collection('infoboard_items').doc('item-1').set({
    'title': 'Notice',
    'createdAt': Timestamp.fromDate(DateTime.utc(2026, 6, 1, 9, 30)),
  });
  await db
      .collection('reports')
      .doc('2026-06')
      .collection('entries')
      .doc('uid-1')
      .set({'month': '2026-06', 'placements': 4, 'ministry': true});
  await db.collection('attendance').doc('2026-06-01_weekend').set({
    'date': '2026-06-01',
    'meetingType': 'weekend',
    'total': 42,
  });
}

void main() {
  test('export -> JSON -> import reproduces every document and its types',
      () async {
    final source = FakeFirebaseFirestore();
    await _seed(source);

    final service = BackupService(source);
    final backup = await service.exportAll(congregationName: 'Test Congregation');

    // The backup must survive a real JSON round-trip (no Firestore types leak).
    final roundTripped =
        jsonDecode(jsonEncode(backup)) as Map<String, dynamic>;
    expect(roundTripped['format'], backupFormat);

    // Restore into a fresh, empty database.
    final target = FakeFirebaseFirestore();
    final result = await BackupService(target).importAll(roundTripped);

    expect(result.hasFailures, isFalse, reason: result.failed.toString());

    // Top-level docs and their data.
    final meta = await target.collection('congregation').doc('meta').get();
    expect(meta.data()!['name'], 'Test Congregation');
    expect(meta.data()!['lmmWeekday'], 2);

    final pub = await target.collection('publishers').doc('uid-1').get();
    expect(pub.data()!['lastName'], 'Lovelace');
    expect((pub.data()!['roles'] as Map)['fullAdmin'], true);

    // Sensitive private subcollection doc.
    final profile = await target
        .collection('publishers')
        .doc('uid-1')
        .collection('private')
        .doc('profile')
        .get();
    expect(profile.data()!['phone'], '+420123456789');

    // Timestamp stays a Timestamp, not a String.
    final item = await target.collection('infoboard_items').doc('item-1').get();
    expect(item.data()!['createdAt'], isA<Timestamp>());
    expect(
      (item.data()!['createdAt'] as Timestamp).toDate().toUtc(),
      DateTime.utc(2026, 6, 1, 9, 30),
    );

    // reports/{month}/entries/{pid} restored at the right path.
    final entry = await target
        .collection('reports')
        .doc('2026-06')
        .collection('entries')
        .doc('uid-1')
        .get();
    expect(entry.data()!['placements'], 4);

    final att =
        await target.collection('attendance').doc('2026-06-01_weekend').get();
    expect(att.data()!['total'], 42);
  });

  test('doc counts cover nested subcollection documents', () async {
    final db = FakeFirebaseFirestore();
    await _seed(db);
    final backup = await BackupService(db).exportAll(congregationName: 'x');
    final counts = backupDocCounts(backup);

    expect(counts['publishers'], 2); // publisher doc + its private/profile
    expect(counts['reports'], 1); // the entry, not the phantom month parent
    expect(counts['congregation'], 1);
    expect(counts['attendance'], 1);
  });

  test('report month probe fallback finds the same entries', () async {
    final db = FakeFirebaseFirestore();
    await _seed(db);
    final docs = await BackupService(db).probeReportEntries();
    expect(docs, hasLength(1));
    expect(docs.single.reference.parent.parent!.id, '2026-06');
    expect(docs.single.id, 'uid-1');
  });

  test('probe window spans 2000-01 through next month', () {
    final months = reportProbeMonths();
    final now = DateTime.now();
    final next = DateTime(now.year, now.month + 1);
    expect(months.first, '2000-01');
    expect(months.last,
        '${next.year}-${next.month.toString().padLeft(2, '0')}');
    expect(months.toSet().length, months.length);
  });

  test('importAll rejects a file that is not a backup', () async {
    final db = FakeFirebaseFirestore();
    expect(
      () => BackupService(db).importAll({'format': 'something-else'}),
      throwsA(isA<BackupFormatException>()),
    );
  });
}
