import 'package:congregation_scheduler/core/data/admin_mode_provider.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/features/statistics/statistics_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The territory card on the Statistics screen: the assignment history rolled
/// up per service year, with its own year stepper that leaves the field
/// service card above it alone.
void main() {
  final en = lookupAppLocalizations(const Locale('en'));

  // Tall surface so every card is mounted, not scrolled out of the ListView.
  void enlarge(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  final currentYear = serviceYearOf(DateTime.now());
  final thisYear = serviceYearMonths(currentYear);
  final lastYear = serviceYearMonths(currentYear - 1);

  /// Three territories; this year one round of 14 days on Alpha and Beta
  /// still out, last year 20-day rounds on Alpha and Gamma.
  Future<FakeFirebaseFirestore> seed() async {
    final db = FakeFirebaseFirestore();
    for (final (id, name) in [('t1', 'Alpha'), ('t2', 'Beta'), ('t3', 'Gamma')]) {
      await db.collection('territories').doc(id).set(Territory(name: name).toJson());
    }
    Future<void> assign(String id, String territoryId,
            {required String assigned, String returned = ''}) =>
        db.collection('territory_assignments').doc(id).set(TerritoryAssignment(
              territoryId: territoryId,
              publisherId: 'p1',
              assignedDate: assigned,
              returnedDate: returned,
            ).toJson());

    await assign('a1', 't1',
        assigned: '${thisYear[0]}-01', returned: '${thisYear[0]}-15');
    await assign('a2', 't2', assigned: '${thisYear[0]}-20');
    await assign('a3', 't1',
        assigned: '${lastYear[0]}-01', returned: '${lastYear[0]}-21');
    await assign('a4', 't3',
        assigned: '${lastYear[1]}-01', returned: '${lastYear[1]}-21');
    return db;
  }

  Widget wrap(FakeFirebaseFirestore db) => ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(db),
          effectiveRolesProvider.overrideWithValue(const Roles(fullAdmin: true)),
          allPublishersProvider.overrideWith((ref) => Stream.value(const [])),
          formerPublishersProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: StatisticsScreen()),
        ),
      );

  Finder card() => find
      .ancestor(of: find.text(en.navTerritories), matching: find.byType(Card))
      .first;

  Finder inCard(Finder matching) =>
      find.descendant(of: card(), matching: matching);

  /// The number above a tile's label.
  String tile(WidgetTester tester, String label) => tester
      .widgetList<Text>(find.descendant(
        of: find
            .ancestor(of: inCard(find.text(label)), matching: find.byType(Column))
            .first,
        matching: find.byType(Text),
      ))
      .first
      .data!;

  /// The value at the right end of a bar's label row.
  String bar(WidgetTester tester, String label) => tester
      .widgetList<Text>(find.descendant(
        of: find
            .ancestor(of: inCard(find.text(label)), matching: find.byType(Row))
            .first,
        matching: find.byType(Text),
      ))
      .last
      .data!;

  testWidgets('rolls the assignment history up under field service',
      (tester) async {
    enlarge(tester);
    await tester.pumpWidget(wrap(await seed()));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.text(en.navTerritories)).dy,
        greaterThan(tester.getTopLeft(find.text(en.statFieldServiceTitle)).dy));

    // Total and "currently assigned" describe today; the rest the year shown.
    expect(tile(tester, en.terrStatsTotal), '3');
    expect(tile(tester, en.terrStatsAssigned), '1');
    expect(tile(tester, en.statTerrCompleted), '1');
    expect(tile(tester, en.statTerrAvgDays), '14');
    expect(bar(tester, en.statTerrCovered), '1 / 3');
    expect(bar(tester, en.statTerrNotCovered), '2 / 3');
    // One bar per elapsed month; September holds this year's only return.
    expect(bar(tester, 'Sep ${thisYear[0].substring(0, 4)}'), '1');
  });

  testWidgets('the year stepper moves this card only', (tester) async {
    enlarge(tester);
    await tester.pumpWidget(wrap(await seed()));
    await tester.pumpAndSettle();

    final rightArrow = tester.widget<IconButton>(
        inCard(find.widgetWithIcon(IconButton, Icons.chevron_right)));
    expect(rightArrow.onPressed, isNull, reason: 'no year beyond the current');

    await tester.tap(inCard(find.byIcon(Icons.chevron_left)));
    await tester.pumpAndSettle();

    expect(tile(tester, en.statTerrCompleted), '2');
    expect(tile(tester, en.statTerrAvgDays), '20');
    expect(bar(tester, en.statTerrCovered), '2 / 3');
    expect(bar(tester, en.statTerrNotCovered), '1 / 3');
    // Today's figures stay put whichever year is being read.
    expect(tile(tester, en.terrStatsTotal), '3');
    expect(tile(tester, en.terrStatsAssigned), '1');

    // Field service still shows the current year: the two steppers are apart.
    expect(
        find.text(en.statServiceYear('${currentYear - 1}/$currentYear')),
        findsOneWidget);
    expect(
        find.text(en.statServiceYear('${currentYear - 2}/${currentYear - 1}')),
        findsOneWidget);
  });

  testWidgets('a congregation without territories gets the empty state',
      (tester) async {
    enlarge(tester);
    await tester.pumpWidget(wrap(FakeFirebaseFirestore()));
    await tester.pumpAndSettle();

    expect(inCard(find.text(en.statNoData)), findsOneWidget);
    expect(inCard(find.text(en.terrStatsTotal)), findsNothing);
  });
}
