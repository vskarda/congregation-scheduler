import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/reports/report_form.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // English labels used by the finders below.
  const auxLabel = 'Auxiliary Pioneer';
  const hoursLabel = 'Hours';

  Future<MinistryReport?> pumpForm(
    WidgetTester tester, {
    required MinistryReport initial,
    required bool isPioneer,
    required bool showAuxiliaryPioneer,
  }) async {
    MinistryReport? submitted;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: ReportForm(
            initial: initial,
            isPioneer: isPioneer,
            showAuxiliaryPioneer: showAuxiliaryPioneer,
            onSubmit: (r) async => submitted = r,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    // The closure keeps writing to `submitted`; callers read it after submit.
    return submitted;
  }

  Finder auxTick() => find.widgetWithText(CheckboxListTile, auxLabel);
  Finder hoursField() => find.widgetWithText(TextField, hoursLabel);
  Finder creditField() => find.widgetWithText(TextField, 'Credit hours');

  testWidgets('publisher can mark a month as auxiliary pioneer', (tester) async {
    MinistryReport? out;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: ReportForm(
            initial: const MinistryReport(
                month: '2025-09', statusAtMonth: PublisherStatus.publisher),
            isPioneer: false,
            showAuxiliaryPioneer: true,
            onSubmit: (r) async => out = r,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    // Tick offered; hours hidden while unchecked (a plain publisher).
    expect(auxTick(), findsOneWidget);
    expect(hoursField(), findsNothing);

    // Ticking aux reveals the hours field.
    await tester.tap(auxTick());
    await tester.pumpAndSettle();
    expect(hoursField(), findsOneWidget);

    await tester.enterText(hoursField(), '30');
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(out, isNotNull);
    expect(out!.statusAtMonth, PublisherStatus.auxiliaryPioneer);
    expect(out!.hours, 30);
  });

  testWidgets('aux tick is preselected when status is auxiliary pioneer',
      (tester) async {
    await pumpForm(
      tester,
      initial: const MinistryReport(
          month: '2025-09', statusAtMonth: PublisherStatus.auxiliaryPioneer),
      isPioneer: true,
      showAuxiliaryPioneer: true,
    );

    final tile = tester.widget<CheckboxListTile>(auxTick());
    expect(tile.value, true);
    expect(hoursField(), findsOneWidget);
  });

  testWidgets('no aux tick for permanent pioneers; status is preserved',
      (tester) async {
    MinistryReport? out;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: ReportForm(
            initial: const MinistryReport(
                month: '2025-09',
                statusAtMonth: PublisherStatus.regularPioneer),
            isPioneer: true,
            showAuxiliaryPioneer: false,
            onSubmit: (r) async => out = r,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(auxTick(), findsNothing);
    // Pioneers always see hours.
    expect(hoursField(), findsOneWidget);

    await tester.enterText(hoursField(), '50');
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(out!.statusAtMonth, PublisherStatus.regularPioneer);
    expect(out!.hours, 50);
  });

  testWidgets('unchecking aux reverts to publisher and drops hours',
      (tester) async {
    MinistryReport? out;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: ReportForm(
            initial: const MinistryReport(
                month: '2025-09',
                statusAtMonth: PublisherStatus.auxiliaryPioneer,
                hours: 20),
            isPioneer: false,
            showAuxiliaryPioneer: true,
            onSubmit: (r) async => out = r,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    // Preselected aux → hours visible with the initial value.
    expect(hoursField(), findsOneWidget);

    // Untick → hours hidden and dropped on submit; status back to publisher.
    await tester.tap(auxTick());
    await tester.pumpAndSettle();
    expect(hoursField(), findsNothing);

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(out!.statusAtMonth, PublisherStatus.publisher);
    expect(out!.hours, isNull);
  });

  testWidgets('reporting hours auto-marks participation when the tick is '
      'forgotten', (tester) async {
    MinistryReport? out;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: ReportForm(
            initial: const MinistryReport(
                month: '2025-09',
                statusAtMonth: PublisherStatus.regularPioneer),
            isPioneer: true,
            showAuxiliaryPioneer: false,
            onSubmit: (r) async => out = r,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    // Enter hours but never tick "Shared in Ministry".
    await tester.enterText(hoursField(), '40');
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(out!.hours, 40);
    expect(out!.participated, isTrue);
    expect(out!.sharedInMinistry, isTrue);
  });

  testWidgets('credit hours alone do not mark participation', (tester) async {
    MinistryReport? out;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: ReportForm(
            initial: const MinistryReport(
                month: '2025-09',
                statusAtMonth: PublisherStatus.regularPioneer),
            isPioneer: true,
            showAuxiliaryPioneer: false,
            onSubmit: (r) async => out = r,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(creditField(), '15');
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(out!.creditHours, 15);
    expect(out!.participated, isFalse);
    // An empty report for overview purposes — only credit was entered.
    expect(out!.sharedInMinistry, isFalse);
  });
}
