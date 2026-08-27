import 'package:congregation_scheduler/core/data/congregation_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/publishers/publishers_pdf_button.dart';
import 'package:congregation_scheduler/features/publishers/roster_export_scope.dart';
import 'package:congregation_scheduler/features/publishers/s21/s21_batch_pdf_button.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Both bulk exports take the roster exactly as it is filtered, so an admin
/// who tapped them expecting "everybody" has to be told what the file will
/// really hold — before anything is read, and in the same breath as the
/// personal-data warning they already confirm.
void main() {
  const everyone =
      RosterExportScope(listed: 2, publishers: 2, missing: 0, extra: 0);
  const narrowed =
      RosterExportScope(listed: 2, publishers: 9, missing: 7, extra: 0);
  const mixed =
      RosterExportScope(listed: 2, publishers: 3, missing: 1, extra: 1);

  Widget wrap(Widget button) => ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(FakeFirebaseFirestore()),
          congregationMetaProvider
              .overrideWith((ref) => Stream.value(const CongregationMeta())),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: button),
        ),
      );

  const publishers = [
    Publisher(id: 'p1', firstName: 'Ann', lastName: 'Adams'),
    Publisher(id: 'p2', firstName: 'Ben', lastName: 'Brown'),
  ];

  Future<void> openDialog(WidgetTester tester, Widget button) async {
    await tester.pumpWidget(wrap(button));
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
  }

  group('S-21 batch export', () {
    Widget button(RosterExportScope scope) =>
        S21BatchPdfButton(publishers: publishers, scope: scope);

    testWidgets('says nothing extra when the whole roster is listed',
        (tester) async {
      await openDialog(tester, button(everyone));

      expect(find.text('Export S-21 of all publishers?'), findsOneWidget);
      expect(find.byType(RosterExportScopeWarning), findsNothing);
    });

    testWidgets('warns that filtered-out publishers are missing',
        (tester) async {
      await openDialog(tester, button(narrowed));

      expect(find.text('Check what will be exported'), findsOneWidget);
      expect(find.textContaining('covers the 2 records'), findsOneWidget);
      expect(find.textContaining('7 of the congregation’s 9 publishers'),
          findsOneWidget);
      // Nothing on the list is anything other than a publisher.
      expect(find.textContaining('not active publishers'), findsNothing);
      // The S-21 warning it already showed is still there.
      expect(find.textContaining('2 publisher record cards'), findsOneWidget);
    });

    testWidgets('warns about listed records that are not publishers',
        (tester) async {
      await openDialog(tester, button(mixed));

      expect(find.textContaining('1 of the congregation’s 3 publishers'),
          findsOneWidget);
      expect(find.textContaining('1 listed records are not active publishers'),
          findsOneWidget);
    });
  });

  group('profiles export', () {
    Widget button(RosterExportScope scope) =>
        PublishersPdfButton(publishers: publishers, scope: scope);

    testWidgets('says nothing extra when the whole roster is listed',
        (tester) async {
      await openDialog(tester, button(everyone));

      expect(find.text('Export publisher profiles?'), findsOneWidget);
      expect(find.byType(RosterExportScopeWarning), findsNothing);
    });

    testWidgets('warns before the private profiles are read', (tester) async {
      await openDialog(tester, button(narrowed));

      expect(find.text('Check what will be exported'), findsOneWidget);
      expect(find.textContaining('7 of the congregation’s 9 publishers'),
          findsOneWidget);
      expect(
          find.textContaining('personal data of 2 publishers'), findsOneWidget);
    });

    testWidgets('cancelling exports nothing', (tester) async {
      await openDialog(tester, button(narrowed));
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Check what will be exported'), findsNothing);
      expect(find.text('Export publisher profiles?'), findsNothing);
    });
  });
}
