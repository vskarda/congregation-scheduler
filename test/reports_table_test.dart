import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/features/reports/admin_reports_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The month overview as a table: which cell holds which figure, and how the
/// three states a row can be in are told apart. The screen opens on last
/// month, so that is the month every report here is filed for.
void main() {
  final month = monthKey(addMonths(DateTime.now(), -1));

  Widget wrap(FakeFirebaseFirestore db, List<Publisher> publishers) =>
      ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(db),
          allPublishersProvider.overrideWith((ref) => Stream.value(publishers)),
          formerPublishersProvider
              .overrideWith((ref) => Stream.value(const [])),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: AdminReportsScreen()),
        ),
      );

  final john =
      Publisher(id: 'john', firstName: 'John', lastName: 'Adams');

  Future<FakeFirebaseFirestore> dbWith(MinistryReport report) async {
    final db = FakeFirebaseFirestore();
    await db
        .collection('reports')
        .doc(month)
        .collection('entries')
        .doc(john.id)
        .set(report.copyWith(month: month).toJson());
    return db;
  }

  testWidgets('a filed report puts its figures in the numeric columns',
      (tester) async {
    final db = await dbWith(const MinistryReport(
      participated: true,
      bibleStudies: 3,
      hours: 12,
      creditHours: 47,
      comments: 'two weeks away',
    ));
    await tester.pumpWidget(wrap(db, [john]));
    await tester.pumpAndSettle();

    expect(find.text('Adams John'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('47'), findsOneWidget);
    expect(find.text('two weeks away'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('a missing report leaves the cells blank and tints the row',
      (tester) async {
    await tester.pumpWidget(wrap(FakeFirebaseFirestore(), [john]));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);
    // The tint is what makes a gap visible while scrolling the roster.
    final row = tester.widget<DataTable>(find.byType(DataTable)).rows.single;
    expect(row.color, isNotNull);
  });

  testWidgets('an empty report is marked as filed, not as a gap',
      (tester) async {
    // A note and credit hours alone are not ministry (sharedInMinistry), but
    // the report was filed — nobody is waiting for it, so no tint.
    final db = await dbWith(
        const MinistryReport(creditHours: 8, comments: 'in hospital'));
    await tester.pumpWidget(wrap(db, [john]));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.cancel), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);
    final row = tester.widget<DataTable>(find.byType(DataTable)).rows.single;
    expect(row.color, isNull);
  });

  testWidgets('the auxiliary-pioneer month is ticked in its own column',
      (tester) async {
    final db = await dbWith(const MinistryReport(
      participated: true,
      hours: 30,
      statusAtMonth: PublisherStatus.auxiliaryPioneer,
    ));
    await tester.pumpWidget(wrap(db, [john]));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('tapping a row opens the entry dialog for that publisher',
      (tester) async {
    await tester.pumpWidget(wrap(FakeFirebaseFirestore(), [john]));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Adams John'));
    await tester.pumpAndSettle();
    expect(find.text('Enter report — John Adams'), findsOneWidget);
  });

  testWidgets('the narrow columns are headed by an abbreviation that keeps '
      'the full label as a tooltip', (tester) async {
    // No report filed, so the only "Shared in Ministry" tooltip in the tree is
    // the column's — the row icon's says "Not submitted".
    await tester.pumpWidget(wrap(FakeFirebaseFirestore(), [john]));
    await tester.pumpAndSettle();

    expect(find.text('Shared'), findsOneWidget);
    expect(find.text('Aux.'), findsOneWidget);
    expect(find.text('Credit'), findsOneWidget);
    expect(find.byTooltip('Shared in Ministry'), findsOneWidget);
    expect(find.byTooltip('Auxiliary Pioneer'), findsOneWidget);
    expect(find.byTooltip('Credit hours'), findsOneWidget);
  });

  testWidgets('the table fills a wide viewport, comments taking the slack',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = await dbWith(
        const MinistryReport(participated: true, hours: 9, comments: 'ok'));
    await tester.pumpWidget(wrap(db, [john]));
    await tester.pumpAndSettle();

    // Only the flex on the comments column can stretch the table this far;
    // intrinsically it is roughly half as wide.
    expect(tester.getSize(find.byType(DataTable)).width, 1200);
  });

  testWidgets('a long note is capped rather than widening the table without '
      'end', (tester) async {
    tester.view.physicalSize = const Size(390, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = await dbWith(MinistryReport(
        participated: true, hours: 9, comments: 'a very long note ' * 20));
    await tester.pumpWidget(wrap(db, [john]));
    await tester.pumpAndSettle();

    // Wider than the phone, so it scrolls sideways as before. The ceiling is
    // the point: maxIntrinsicWidth of a Text is its *single-line* width no
    // matter how many lines it may wrap onto, so uncapped this 340-character
    // note would ask for several thousand pixels and drag every other row
    // sideways with it.
    final width = tester.getSize(find.byType(DataTable)).width;
    expect(width, greaterThan(390));
    expect(width, lessThan(1500));
  });
}
