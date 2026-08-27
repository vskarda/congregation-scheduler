import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/core/widgets/service_year_picker_dialog.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The dialog both record-sheet exports open to ask which service year to
/// print.
void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  /// Pumps a button, opens the picker with it, and hands back a reader for
  /// whatever the dialog resolves to once it is dismissed.
  Future<int? Function()> open(
    WidgetTester tester, {
    required int initialYear,
    String Function(int year)? subtitle,
    Size size = const Size(800, 600),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    int? picked;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            picked = await showServiceYearPicker(
              context,
              title: 'Which service year',
              initialYear: initialYear,
              subtitle: subtitle,
            );
          },
          child: const Text('open'),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return () => picked;
  }

  testWidgets('opens on the year it was given', (tester) async {
    await open(tester, initialYear: 2026);

    expect(find.text(l10n.serviceYear(2026)), findsOneWidget);
  });

  testWidgets('Export returns the year on screen', (tester) async {
    final picked = await open(tester, initialYear: 2026);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.commonExport));
    await tester.pumpAndSettle();

    expect(picked(), 2025);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Cancel gives back nothing', (tester) async {
    final picked = await open(tester, initialYear: 2026);

    await tester.tap(find.text(l10n.commonCancel));
    await tester.pumpAndSettle();

    expect(picked(), isNull);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('the subtitle follows the stepper', (tester) async {
    await open(
      tester,
      initialYear: 2026,
      subtitle: (year) => 'covers ${year - 1} and $year',
    );

    expect(find.text('covers 2025 and 2026'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    expect(find.text('covers 2024 and 2025'), findsOneWidget);
  });

  testWidgets('it will not step past the running service year', (tester) async {
    final thisYear = serviceYearOf(DateTime.now());
    await open(tester, initialYear: thisYear);

    // A record sheet reports on time that has passed, so forward is disabled
    // at the top and the year cannot run away into the future.
    final forward = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_right));
    expect(forward.onPressed, isNull);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    expect(find.text(l10n.serviceYear(thisYear - 1)), findsOneWidget);

    final forwardAgain = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_right));
    expect(forwardAgain.onPressed, isNotNull);
  });

  testWidgets('it scrolls rather than overflowing on a short viewport',
      (tester) async {
    // A phone held sideways leaves a dialog very little height; the stepper
    // plus its subtitle are taller than that.
    await open(
      tester,
      initialYear: 2026,
      subtitle: (year) => 'covers ${year - 1} and $year',
      size: const Size(740, 360),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
