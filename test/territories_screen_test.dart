import 'package:congregation_scheduler/core/data/admin_mode_provider.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/territories/territories_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Admin overview of the territories screen: delete confirmation, the
/// search+sort controls, and tap-to-expand assignment history.
void main() {
  Future<void> seedTerritory(FakeFirebaseFirestore db, String id,
      {required String name, String notes = ''}) {
    return db.collection('territories').doc(id).set({
      'name': name,
      'mapUrl': '',
      'notes': notes,
    });
  }

  Future<void> seedAssignment(
    FakeFirebaseFirestore db,
    String id, {
    required String territoryId,
    required String publisherId,
    required String assignedDate,
    String returnedDate = '',
    String returnNotes = '',
  }) {
    return db.collection('territory_assignments').doc(id).set({
      'territoryId': territoryId,
      'publisherId': publisherId,
      'assignedDate': assignedDate,
      'returnedDate': returnedDate,
      'returnNotes': returnNotes,
    });
  }

  Widget wrap(FakeFirebaseFirestore db, List<Publisher> publishers) {
    return ProviderScope(
      overrides: [
        firestoreProvider.overrideWithValue(db),
        effectiveRolesProvider
            .overrideWithValue(const Roles(fullAdmin: true)),
        allPublishersProvider.overrideWith((ref) => Stream.value(publishers)),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TerritoriesScreen(),
      ),
    );
  }

  testWidgets('delete requires confirmation before removing the territory',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await seedTerritory(db, 't1', name: 'Alpha');

    await tester.pumpWidget(wrap(db, const []));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete?'), findsOneWidget);
    expect(find.text("Delete this territory? This can't be undone."),
        findsOneWidget);

    // Cancel leaves the territory in place.
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect((await db.collection('territories').doc('t1').get()).exists,
        isTrue);

    // Confirming removes it.
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect((await db.collection('territories').doc('t1').get()).exists,
        isFalse);
  });

  testWidgets('search and sort chips reorder and filter the list',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await seedTerritory(db, 't1', name: 'Beta');
    await seedTerritory(db, 't2', name: 'Alpha');
    await seedTerritory(db, 't3', name: 'Charlie');
    await seedAssignment(db, 'a1',
        territoryId: 't2', publisherId: 'p1', assignedDate: '2026-01-01');
    await seedAssignment(db, 'a2',
        territoryId: 't3', publisherId: 'p2', assignedDate: '2026-03-01');
    final publishers = [
      const Publisher(
          id: 'p1', firstName: 'Zack', lastName: 'Adams', verified: true),
      const Publisher(
          id: 'p2', firstName: 'Amy', lastName: 'Baker', verified: true),
    ];

    await tester.pumpWidget(wrap(db, publishers));
    await tester.pumpAndSettle();

    double yOf(String text) => tester.getTopLeft(find.text(text)).dy;

    // Default sort: Territory, ascending by name.
    expect(yOf('Alpha'), lessThan(yOf('Beta')));
    expect(yOf('Beta'), lessThan(yOf('Charlie')));

    // Sort by Publisher: unassigned (Beta) always last.
    await tester.tap(find.text('Publisher'));
    await tester.pumpAndSettle();
    expect(yOf('Charlie'), lessThan(yOf('Alpha')));
    expect(yOf('Alpha'), lessThan(yOf('Beta')));

    // Sort by Date assigned, ascending then descending; Beta stays last.
    await tester.tap(find.text('Date assigned'));
    await tester.pumpAndSettle();
    expect(yOf('Alpha'), lessThan(yOf('Charlie')));
    expect(yOf('Charlie'), lessThan(yOf('Beta')));

    await tester.tap(find.text('Date assigned ▲'));
    await tester.pumpAndSettle();
    expect(yOf('Charlie'), lessThan(yOf('Alpha')));
    expect(yOf('Alpha'), lessThan(yOf('Beta')));

    // Search narrows by both territory name and current holder's name.
    await tester.enterText(find.byType(TextField), 'amy');
    await tester.pumpAndSettle();
    expect(find.text('Charlie'), findsOneWidget);
    expect(find.text('Alpha'), findsNothing);
    expect(find.text('Beta'), findsNothing);
  });

  testWidgets('tapping a territory rolls down its assignment history',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await seedTerritory(db, 't1', name: 'Alpha');
    await seedAssignment(db, 'a1',
        territoryId: 't1',
        publisherId: 'p1',
        assignedDate: '2025-01-01',
        returnedDate: '2025-06-01',
        returnNotes: 'Finished early');
    await seedAssignment(db, 'a2',
        territoryId: 't1', publisherId: 'p2', assignedDate: '2025-07-01');
    final publishers = [
      const Publisher(
          id: 'p1', firstName: 'Old', lastName: 'Holder', verified: true),
      const Publisher(
          id: 'p2', firstName: 'New', lastName: 'Holder', verified: true),
    ];

    await tester.pumpWidget(wrap(db, publishers));
    await tester.pumpAndSettle();

    // Collapsed: only the current holder's history is hidden too.
    expect(find.text('Finished early'), findsNothing);
    expect(find.text('Old Holder'), findsNothing);

    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();

    expect(find.text('Old Holder'), findsOneWidget);
    expect(find.text('Finished early'), findsOneWidget);
    expect(find.text('Jul 1, 2025 – Current'), findsOneWidget);

    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();
    expect(find.text('Finished early'), findsNothing);
  });

  testWidgets('territory note shows only when the details are rolled down',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await seedTerritory(db, 't1',
        name: 'Alpha', notes: 'Locked gate on Main St');

    await tester.pumpWidget(wrap(db, const []));
    await tester.pumpAndSettle();

    // Collapsed: the note is not shown next to the territory row.
    expect(find.textContaining('Locked gate on Main St'), findsNothing);

    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Locked gate on Main St'), findsOneWidget);
  });

  testWidgets('adding a territory with an existing name is blocked',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await seedTerritory(db, 't1', name: 'Alpha');

    await tester.pumpWidget(wrap(db, const []));
    await tester.pumpAndSettle();

    // Open the Add dialog and type a name that already exists (any case).
    // The name field is the first TextField inside the dialog (not the
    // search box that also lives on the screen behind it).
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    final nameField = find
        .descendant(of: find.byType(AlertDialog), matching: find.byType(TextField))
        .first;
    await tester.enterText(nameField, 'alpha');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    // Dialog stays open with an inline error; no second territory is written.
    expect(find.text('A territory with this name already exists.'),
        findsOneWidget);
    expect((await db.collection('territories').get()).docs, hasLength(1));

    // A distinct name saves and closes the dialog.
    await tester.enterText(nameField, 'Beta');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
    expect(find.text('A territory with this name already exists.'),
        findsNothing);
    expect((await db.collection('territories').get()).docs, hasLength(2));
  });
}
