import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/publishers/admin_publishers_screen.dart';
import 'package:congregation_scheduler/features/publishers/roster_export_scope.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The roster's "Publishers" filter, and the warning the exports carry when
/// the list is not simply everybody who reports.
void main() {
  const roster = [
    Publisher(id: 'p1', firstName: 'Ann', lastName: 'Adams', verified: true),
    Publisher(id: 'p2', firstName: 'Ben', lastName: 'Brown', verified: true),
    // Keeps a record for the schedules, but has no service status.
    Publisher(
        id: 'p3',
        firstName: 'Cara',
        lastName: 'Clark',
        verified: true,
        status: PublisherStatus.none),
  ];

  // Publishers *and* reports: the S-21 export needs both, the profiles export
  // only the first. Not full-admin, which would start the appointment
  // backfill this test has no Firestore data for.
  const roles = Roles(publishers: true, reports: true);

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        firestoreProvider.overrideWithValue(FakeFirebaseFirestore()),
        myRolesProvider.overrideWithValue(roles),
        allPublishersProvider.overrideWith((ref) => Stream.value(roster)),
      ],
      child: const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AdminPublishersScreen(),
      ),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> tapChip(WidgetTester tester, String label) async {
    await tester.tap(find.widgetWithText(FilterChip, label));
    await tester.pumpAndSettle();
  }

  testWidgets('the Publishers chip hides records with no service status',
      (tester) async {
    await pump(tester);
    expect(find.text('Clark Cara'), findsOneWidget);

    await tapChip(tester, 'Publishers');

    expect(find.text('Clark Cara'), findsNothing);
    expect(find.text('Adams Ann'), findsOneWidget);
    expect(find.text('Brown Ben'), findsOneWidget);
  });

  testWidgets('Clear puts the hidden records back', (tester) async {
    await pump(tester);
    await tapChip(tester, 'Publishers');
    await tester.tap(find.widgetWithText(ActionChip, 'Clear'));
    await tester.pumpAndSettle();

    expect(find.text('Clark Cara'), findsOneWidget);
  });

  testWidgets('exporting the unfiltered roster warns about the non-publisher',
      (tester) async {
    await pump(tester);
    await tester.tap(find.byTooltip('Export list (PDF)'));
    await tester.pumpAndSettle();

    expect(find.byType(RosterExportScopeWarning), findsOneWidget);
    expect(find.textContaining('covers the 3 records'), findsOneWidget);
    expect(find.textContaining('1 listed records are not active publishers'),
        findsOneWidget);
  });

  testWidgets('with the chip on, the exports have nothing to warn about',
      (tester) async {
    await pump(tester);
    await tapChip(tester, 'Publishers');

    for (final tooltip in ['Export list (PDF)', 'Export S-21 of all (PDF)']) {
      await tester.tap(find.byTooltip(tooltip));
      await tester.pumpAndSettle();
      expect(find.byType(RosterExportScopeWarning), findsNothing,
          reason: '$tooltip covers exactly the congregation’s publishers');
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('a search term narrows the export just as a chip does',
      (tester) async {
    await pump(tester);
    await tapChip(tester, 'Publishers');
    await tester.enterText(find.byType(TextField), 'ann');
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Export list (PDF)'));
    await tester.pumpAndSettle();

    expect(find.textContaining('1 of the congregation’s 2 publishers'),
        findsOneWidget);
  });
}
