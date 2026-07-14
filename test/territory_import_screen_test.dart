import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/features/territories/territory_import_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // pumpAndSettle never settles here (the focused paste field keeps the
  // cursor animation alive), so pump a bounded number of frames instead.
  Future<void> pumpFrames(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('previews pasted rows, toggles updates, imports to Firestore', (
    tester,
  ) async {
    final db = FakeFirebaseFirestore();
    await db.collection('territories').add({
      'name': 'Old centre',
      'number': '1',
      'mapUrl': '',
      'notes': '',
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [firestoreProvider.overrideWithValue(db)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TerritoryImportScreen(),
                    ),
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await pumpFrames(tester);

    // One duplicate (01 matches existing 1), one new, one row without a name.
    await tester.enterText(
      find.byType(TextField),
      'Centre\t01\thttps://maps.example/1\nEast\t2\n\t3',
    );
    await tester.tap(find.text('Preview'));
    await pumpFrames(tester);

    expect(find.text('3 rows: 1 new, 1 existing, 1 invalid'), findsOneWidget);
    expect(find.text('New'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Missing name'), findsOneWidget);
    expect(find.text('Import 1 territory'), findsOneWidget);

    // The switch flips the duplicate from Skip to Update.
    await tester.tap(find.byType(Switch));
    await pumpFrames(tester);
    expect(find.text('Update'), findsOneWidget);
    expect(find.text('Skip'), findsNothing);
    expect(find.text('Import 2 territories'), findsOneWidget);

    await tester.tap(find.text('Import 2 territories'));
    await pumpFrames(tester);

    // Screen popped, snackbar shown.
    expect(find.byType(TerritoryImportScreen), findsNothing);
    expect(find.text('Imported 1 new, updated 1.'), findsOneWidget);

    // Existing doc updated in place (assignments keep pointing at it),
    // new doc created, invalid row not imported.
    final docs = await db.collection('territories').get();
    expect(docs.docs, hasLength(2));
    final byNumber = {
      for (final d in docs.docs) d.data()['number'] as String: d.data(),
    };
    expect(byNumber['01']?['name'], 'Centre');
    expect(byNumber['01']?['mapUrl'], 'https://maps.example/1');
    expect(byNumber['2']?['name'], 'East');
  });
}
