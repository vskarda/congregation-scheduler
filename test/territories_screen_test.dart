import 'package:congregation_scheduler/core/data/admin_mode_provider.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
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
    String freeText = '',
  }) {
    return db.collection('territory_assignments').doc(id).set({
      'territoryId': territoryId,
      'publisherId': publisherId,
      'freeText': freeText,
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

  // ---------------------------------------------------------------------
  // Editing the history: a territory's rounds can be added and corrected
  // after the fact, not only stamped with today's date as they happen.
  // ---------------------------------------------------------------------

  final publishers = [
    const Publisher(
        id: 'p1', firstName: 'Zack', lastName: 'Adams', verified: true),
    const Publisher(
        id: 'p2', firstName: 'Amy', lastName: 'Baker', verified: true),
  ];

  /// A tall window: the default 800x600 puts the "Add territory" button in the
  /// bottom-right corner right on top of the history rows' overflow menus, and
  /// a tap on one lands on the button instead.
  Future<void> pumpScreen(WidgetTester tester, FakeFirebaseFirestore db,
      List<Publisher> roster) async {
    await tester.binding.setSurfaceSize(const Size(1000, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(wrap(db, roster));
    await tester.pumpAndSettle();
  }

  Future<void> expandTerritory(WidgetTester tester, String name) async {
    await tester.tap(find.text(name));
    await tester.pumpAndSettle();
  }

  Future<void> openAddDialog(WidgetTester tester) async {
    await tester.tap(find.text('Add past assignment'));
    await tester.pumpAndSettle();
  }

  /// Opens the shared assignment editor from the holder tile and picks a
  /// publisher out of its checkbox list.
  Future<void> pickHolder(WidgetTester tester, String fullName) async {
    await tester.tap(find.widgetWithText(ListTile, 'Publisher'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CheckboxListTile, fullName));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Save').last);
    await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
  }

  testWidgets('a past assignment is added to an empty history',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await seedTerritory(db, 't1', name: 'Alpha');

    await pumpScreen(tester, db, publishers);
    await expandTerritory(tester, 'Alpha');
    await openAddDialog(tester);
    await pickHolder(tester, 'Amy Baker');

    // The picked publisher shows on the holder tile.
    expect(find.text('Amy Baker'), findsOneWidget);

    // Back-date it: the first of the current month is always on or before
    // today, so the calendar needs no month navigation to reach it.
    await tester.tap(find.widgetWithText(ListTile, 'Date assigned'));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
        of: find.byType(DatePickerDialog), matching: find.text('1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await save(tester);

    final now = DateTime.now();
    final docs = (await db.collection('territory_assignments').get()).docs;
    expect(docs, hasLength(1));
    expect(docs.single.data(), containsPair('publisherId', 'p2'));
    final firstOfMonth = dateKey(DateTime(now.year, now.month, 1));
    expect(docs.single.data(), containsPair('assignedDate', firstOfMonth));
    expect(docs.single.data(), containsPair('returnedDate', ''));
    expect(docs.single.data(), containsPair('freeText', ''));
  });

  testWidgets('a holder the roster cannot name is typed in as free text',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await seedTerritory(db, 't1', name: 'Alpha');

    await pumpScreen(tester, db, publishers);
    await expandTerritory(tester, 'Alpha');
    await openAddDialog(tester);

    // The same "Text" segment the meeting schedules use.
    await tester.tap(find.widgetWithText(ListTile, 'Publisher'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Text'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextField, 'Text'), 'Old Brother');
    await tester.tap(find.widgetWithText(FilledButton, 'Save').last);
    await tester.pumpAndSettle();

    await save(tester);

    final docs = (await db.collection('territory_assignments').get()).docs;
    expect(docs.single.data(), containsPair('freeText', 'Old Brother'));
    expect(docs.single.data(), containsPair('publisherId', ''));

    // The typed name reads back in the still-open history, and answers the
    // search box like a publisher's own name would.
    expect(find.text('Old Brother'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'old bro');
    await tester.pumpAndSettle();
    expect(find.text('Alpha'), findsOneWidget);
  });

  testWidgets('a deleted publisher leaves the dates under a stand-in',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await seedTerritory(db, 't1', name: 'Alpha');
    // The record is gone; nothing was ever written in its place.
    await seedAssignment(db, 'a1',
        territoryId: 't1',
        publisherId: 'deleted-uid',
        assignedDate: '2025-01-01',
        returnedDate: '2025-06-01');

    await pumpScreen(tester, db, publishers);
    await expandTerritory(tester, 'Alpha');

    expect(find.text('Deleted publisher'), findsOneWidget);
    expect(find.text('Jan 1, 2025 – Jun 1, 2025'), findsOneWidget);
  });

  testWidgets('editing a history row rewrites it in place', (tester) async {
    final db = FakeFirebaseFirestore();
    await seedTerritory(db, 't1', name: 'Alpha');
    await seedAssignment(db, 'a1',
        territoryId: 't1',
        publisherId: 'p1',
        assignedDate: '2025-01-01',
        returnedDate: '2025-06-01',
        returnNotes: 'Half done');

    await pumpScreen(tester, db, publishers);
    await expandTerritory(tester, 'Alpha');

    // The history row's own menu, not the territory's.
    await tester.tap(find.byType(PopupMenuButton<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    await pickHolder(tester, 'Amy Baker');
    await tester.enterText(
        find.widgetWithText(TextField, 'Notes (optional)'), 'Finished');
    await save(tester);

    // Same document, corrected — not a second row.
    final docs = (await db.collection('territory_assignments').get()).docs;
    expect(docs, hasLength(1));
    expect(docs.single.id, 'a1');
    expect(docs.single.data(), containsPair('publisherId', 'p2'));
    expect(docs.single.data(), containsPair('returnNotes', 'Finished'));
    expect(docs.single.data(), containsPair('assignedDate', '2025-01-01'));
  });

  testWidgets('a second open assignment on one territory is refused',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await seedTerritory(db, 't1', name: 'Alpha');
    await seedAssignment(db, 'a1',
        territoryId: 't1', publisherId: 'p1', assignedDate: '2026-01-01');

    await pumpScreen(tester, db, publishers);
    await expandTerritory(tester, 'Alpha');
    await openAddDialog(tester);
    await pickHolder(tester, 'Amy Baker');
    await save(tester);

    expect(
        find.textContaining('This territory is already out.'), findsOneWidget);
    expect((await db.collection('territory_assignments').get()).docs,
        hasLength(1));
  });

  testWidgets('a return date before the date assigned is refused',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await seedTerritory(db, 't1', name: 'Alpha');
    // Inverted dates can only arrive from outside the dialog (the return-date
    // picker starts at the assigned date); saving the row must still refuse.
    await seedAssignment(db, 'a1',
        territoryId: 't1',
        publisherId: 'p1',
        assignedDate: '2025-07-01',
        returnedDate: '2025-05-01');

    await pumpScreen(tester, db, publishers);
    await expandTerritory(tester, 'Alpha');
    await tester.tap(find.byType(PopupMenuButton<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await save(tester);

    expect(find.text('The return date cannot be before the date assigned.'),
        findsOneWidget);
    final doc = await db.collection('territory_assignments').doc('a1').get();
    expect(doc.data(), containsPair('returnedDate', '2025-05-01'));
  });

  testWidgets('deleting a history row asks first', (tester) async {
    final db = FakeFirebaseFirestore();
    await seedTerritory(db, 't1', name: 'Alpha');
    await seedAssignment(db, 'a1',
        territoryId: 't1',
        publisherId: 'p1',
        assignedDate: '2025-01-01',
        returnedDate: '2025-06-01');

    await pumpScreen(tester, db, publishers);
    await expandTerritory(tester, 'Alpha');

    Future<void> chooseDelete() async {
      await tester.tap(find.byType(PopupMenuButton<String>).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
    }

    await chooseDelete();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect((await db.collection('territory_assignments').get()).docs,
        hasLength(1));

    await chooseDelete();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect((await db.collection('territory_assignments').get()).docs, isEmpty);
  });
}
