import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/features/reports/admin_reports_screen.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '_harness.dart';

/// Worked example: the reports month overview at a desktop and a phone width.
///
/// This is the screen whose header columns drifted out of line with the body
/// columns -- a defect invisible to `find.text` assertions but obvious in a
/// picture. Copy this file when you need to look at another gated screen.
///
/// Not run by `flutter test`: the name ends in `.shot.dart`, not `_test.dart`.
void main() {
  final month = monthKey(addMonths(DateTime.now(), -1));

  final publishers = <Publisher>[
    const Publisher(id: 'p1', firstName: 'Jan', lastName: 'Novak'),
    const Publisher(
        id: 'p2',
        firstName: 'Eva',
        lastName: 'Novakova',
        status: PublisherStatus.regularPioneer),
    const Publisher(id: 'p3', firstName: 'Petr', lastName: 'Cerny'),
  ];

  Future<FakeFirebaseFirestore> seeded() async {
    final db = FakeFirebaseFirestore();
    await db
        .collection('reports')
        .doc(month)
        .collection('entries')
        .doc('p1')
        .set(MinistryReport(
          publisherId: 'p1',
          month: month,
          participated: true,
          bibleStudies: 2,
        ).toJson());
    await db
        .collection('reports')
        .doc(month)
        .collection('entries')
        .doc('p2')
        .set(MinistryReport(
          publisherId: 'p2',
          month: month,
          participated: true,
          hours: 54,
          bibleStudies: 4,
        ).toJson());
    return db;
  }

  Widget scope(FakeFirebaseFirestore db) => ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(db),
          allPublishersProvider.overrideWith((ref) => Stream.value(publishers)),
          formerPublishersProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: appFrame(const AdminReportsScreen()),
      );

  testWidgets('reports overview, desktop width', (tester) async {
    await shoot(tester, scope(await seeded()),
        name: 'reports-desktop', size: const Size(1200, 600));
  });

  testWidgets('reports overview, phone width', (tester) async {
    await shoot(tester, scope(await seeded()),
        name: 'reports-phone', size: const Size(390, 720));
  });
}
