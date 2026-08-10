import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/reports/report_form.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // English labels used by the finders below.
  const auxLabel = 'Auxiliary Pioneer';
  const hoursLabel = 'Hours';

  const saveAnywayLabel = 'Save anyway';
  const noHoursWarning = 'Hours are blank on a pioneer report. Enter 0 if '
      'there really was no time in the ministry.';
  const wasActiveWarning = '“Shared in Ministry” is not ticked, but '
      'ministry was reported last month.';

  Future<MinistryReport?> pumpForm(
    WidgetTester tester, {
    required MinistryReport initial,
    required bool isPioneer,
    required bool showAuxiliaryPioneer,
    bool sharedLastMonth = false,
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
            sharedLastMonth: sharedLastMonth,
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
  Finder saveAnyway() => find.widgetWithText(FilledButton, saveAnywayLabel);

  /// Taps the form's own submit button — never the dialog's, which is also a
  /// FilledButton once a warning is on screen.
  Future<void> tapSubmit(WidgetTester tester) async {
    await tester.tap(find.descendant(
        of: find.byType(ReportForm), matching: find.byType(FilledButton)));
    await tester.pumpAndSettle();
  }

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
    await tapSubmit(tester);

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
    await tapSubmit(tester);

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

    await tapSubmit(tester);

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
    await tapSubmit(tester);

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
    await tapSubmit(tester);
    // Credit-only leaves field-service hours blank, which the form queries.
    await tester.tap(saveAnyway());
    await tester.pumpAndSettle();

    expect(out!.creditHours, 15);
    expect(out!.participated, isFalse);
    // An empty report for overview purposes — only credit was entered.
    expect(out!.sharedInMinistry, isFalse);
  });

  testWidgets('a pioneer leaving hours blank is asked before it is filed',
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
                participated: true,
                statusAtMonth: PublisherStatus.regularPioneer),
            isPioneer: true,
            showAuxiliaryPioneer: false,
            onSubmit: (r) async => out = r,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tapSubmit(tester);
    expect(find.text(noHoursWarning), findsOneWidget);

    // Cancelling files nothing and leaves the typed report alone.
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(out, isNull);

    // Filling the hours in removes the question entirely.
    await tester.enterText(hoursField(), '50');
    await tapSubmit(tester);
    expect(find.text(noHoursWarning), findsNothing);
    expect(out!.hours, 50);
  });

  testWidgets('an explicit 0 hours is a real answer and is not queried',
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
                participated: true,
                statusAtMonth: PublisherStatus.regularPioneer),
            isPioneer: true,
            showAuxiliaryPioneer: false,
            onSubmit: (r) async => out = r,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(hoursField(), '0');
    await tapSubmit(tester);

    expect(find.text(noHoursWarning), findsNothing);
    expect(out!.hours, 0);
  });

  testWidgets('a publisher who was out last month is asked before being '
      'filed as inactive', (tester) async {
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
            sharedLastMonth: true,
            onSubmit: (r) async => out = r,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tapSubmit(tester);
    expect(find.text(wasActiveWarning), findsOneWidget);

    // The report is still the publisher's to make — saving files it as typed.
    await tester.tap(saveAnyway());
    await tester.pumpAndSettle();
    expect(out!.participated, isFalse);
    expect(out!.sharedInMinistry, isFalse);
  });

  testWidgets('no inactivity question when the month is reported active',
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
                month: '2025-09', statusAtMonth: PublisherStatus.publisher),
            isPioneer: false,
            showAuxiliaryPioneer: true,
            sharedLastMonth: true,
            onSubmit: (r) async => out = r,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    // A Bible study alone already means they shared in the ministry.
    await tester.enterText(
        find.widgetWithText(TextField, 'Bible Studies'), '1');
    await tapSubmit(tester);

    expect(find.text(wasActiveWarning), findsNothing);
    expect(out!.participated, isTrue);
  });

  testWidgets('the admin picker corrects a snapshot taken under the wrong '
      'status', (tester) async {
    MinistryReport? out;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: ReportForm(
            // Filed as a plain publisher while her record still said so; she
            // was a regular pioneer that month and the S-1 grouped her wrong.
            initial: const MinistryReport(
                month: '2026-07',
                participated: true,
                hours: 70,
                statusAtMonth: PublisherStatus.publisher),
            isPioneer: true,
            showStatusPicker: true,
            onSubmit: (r) async => out = r,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<PublisherStatus>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Regular pioneer').last);
    await tester.pumpAndSettle();
    await tapSubmit(tester);

    expect(out!.statusAtMonth, PublisherStatus.regularPioneer);
    expect(out!.hours, 70);
  });

  testWidgets('leaving the picker alone preserves the stored snapshot',
      (tester) async {
    MinistryReport? out;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: ReportForm(
            // A publisher who has since become a pioneer: correcting a typo in
            // an old month must not quietly promote that month with them.
            initial: const MinistryReport(
                month: '2026-03',
                participated: true,
                statusAtMonth: PublisherStatus.publisher),
            isPioneer: true,
            showStatusPicker: true,
            onSubmit: (r) async => out = r,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(hoursField(), '12');
    await tapSubmit(tester);

    expect(out!.statusAtMonth, PublisherStatus.publisher);
  });

  testWidgets('both slips are raised together in one question',
      (tester) async {
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
            sharedLastMonth: true,
            onSubmit: (r) async {},
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tapSubmit(tester);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(noHoursWarning), findsOneWidget);
    expect(find.text(wasActiveWarning), findsOneWidget);
  });
}
