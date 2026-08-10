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
}
