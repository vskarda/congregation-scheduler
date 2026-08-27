import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/publishers/admin_publishers_screen.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '_harness.dart';

/// The publisher roster's filter row -- now eight chips, so how it wraps at a
/// phone width is worth a look -- and the export-scope warning inside each of
/// the two bulk-export confirmations, where a card plus a long paragraph is
/// the tallest a dialog gets.
///
/// A picture only; the behaviour is asserted in
/// `test/admin_publishers_filter_test.dart` and
/// `test/export_scope_warning_test.dart`, which run in CI. Not run by
/// `flutter test`: the name ends in `.shot.dart`, not `_test.dart`.
void main() {
  const roster = <Publisher>[
    Publisher(id: 'p1', firstName: 'Jan', lastName: 'Novak', verified: true),
    Publisher(
        id: 'p2',
        firstName: 'Eva',
        lastName: 'Novakova',
        verified: true,
        status: PublisherStatus.regularPioneer),
    Publisher(
        id: 'p3',
        firstName: 'Petr',
        lastName: 'Cerny',
        verified: true,
        appointment: Appointment.elder),
    // No service status: on the roster, but not a publisher.
    Publisher(
        id: 'p4',
        firstName: 'Marek',
        lastName: 'Dvorak',
        verified: true,
        status: PublisherStatus.none),
  ];

  Widget scope() => ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(FakeFirebaseFirestore()),
          myRolesProvider
              .overrideWithValue(const Roles(publishers: true, reports: true)),
          allPublishersProvider.overrideWith((ref) => Stream.value(roster)),
        ],
        child: appFrame(const AdminPublishersScreen()),
      );

  Future<void> Function(WidgetTester) open(String tooltip) =>
      (tester) => tester.tap(find.byTooltip(tooltip));

  testWidgets('roster and its filter chips, desktop width', (tester) async {
    await shoot(tester, scope(),
        name: 'publishers-filters-desktop', size: const Size(1200, 620));
  });

  testWidgets('roster and its filter chips, phone width', (tester) async {
    await shoot(tester, scope(),
        name: 'publishers-filters-phone', size: const Size(390, 720));
  });

  testWidgets('profiles export warning, phone width', (tester) async {
    await shoot(tester, scope(),
        name: 'publishers-export-warning-phone',
        size: const Size(390, 720),
        after: open('Export list (PDF)'));
  });

  testWidgets('S-21 batch export warning, phone width', (tester) async {
    await shoot(tester, scope(),
        name: 's21-export-warning-phone',
        size: const Size(390, 720),
        after: open('Export S-21 of all (PDF)'));
  });

  testWidgets('S-21 batch export warning, phone landscape', (tester) async {
    await shoot(tester, scope(),
        name: 's21-export-warning-landscape',
        size: const Size(720, 390),
        after: open('Export S-21 of all (PDF)'));
  });
}
