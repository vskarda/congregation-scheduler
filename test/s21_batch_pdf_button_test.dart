import 'package:congregation_scheduler/core/data/congregation_repository.dart';
import 'package:congregation_scheduler/core/data/reports_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/publishers/s21/s21_batch_pdf_button.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The bulk S-21 export puts every listed publisher's personal data into one
/// file, so nothing may be read before the admin has seen the warning and
/// confirmed it.
void main() {
  const publishers = [
    Publisher(id: 'p1', firstName: 'Ann', lastName: 'Adams'),
    Publisher(id: 'p2', firstName: 'Ben', lastName: 'Brown'),
  ];

  late _CountingReportsRepository reports;

  Widget wrap(List<Publisher> list) {
    final db = FakeFirebaseFirestore();
    reports = _CountingReportsRepository(db);
    return ProviderScope(
      overrides: [
        firestoreProvider.overrideWithValue(db),
        reportsRepositoryProvider.overrideWithValue(reports),
        congregationMetaProvider
            .overrideWith((ref) => Stream.value(const CongregationMeta())),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: S21BatchPdfButton(publishers: list)),
      ),
    );
  }

  testWidgets('warns about the personal data before reading anything',
      (tester) async {
    await tester.pumpWidget(wrap(publishers));
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(find.text('Export S-21 of all publishers?'), findsOneWidget);
    // The warning names the number of cards and the years they cover.
    expect(find.textContaining('2 publisher record cards'), findsOneWidget);
    expect(find.textContaining('Service Year'), findsOneWidget);
    expect(reports.monthQueries, 0);
  });

  testWidgets('cancelling exports nothing', (tester) async {
    await tester.pumpWidget(wrap(publishers));
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Export S-21 of all publishers?'), findsNothing);
    expect(find.text('Generating S-21 cards…'), findsNothing);
    expect(reports.monthQueries, 0);
  });

  testWidgets('is disabled with nothing listed', (tester) async {
    await tester.pumpWidget(wrap(const []));
    expect(tester.widget<IconButton>(find.byType(IconButton)).onPressed,
        isNull);
  });
}

class _CountingReportsRepository extends ReportsRepository {
  _CountingReportsRepository(super.db);

  int monthQueries = 0;

  @override
  Future<List<MinistryReport>> getMonth(String month) {
    monthQueries++;
    return super.getMonth(month);
  }
}
