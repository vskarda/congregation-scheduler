/// Support for *looking at* a screen that normally sits behind login.
///
/// The web build (scripts/serve-web.ps1) only reaches `/setup` without a real
/// Firebase project, so an admin screen's layout cannot be inspected there.
/// These shots pump the screen with fakes at a fixed size and write a PNG you
/// can open. Text renders as Ahem boxes, but column widths, alignment, row
/// tints and icon states are all legible -- which is how the reports-table
/// header-width bug was found.
///
/// The PNGs are a **visual probe, not a regression golden**: Flutter's
/// rendering differs between this Windows box and Linux CI, so committing
/// them would mean a permanently red check. `test/shots/out/` is gitignored,
/// and files here are named `*.shot.dart` so `flutter test` -- which only
/// discovers `*_test.dart` -- never runs them in CI. Run one explicitly:
///
/// ```powershell
/// scripts\shot.ps1 -Target test\shots\example.shot.dart -Open
/// ```
library;

import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps [screen] in the app frame it expects.
///
/// Screens shown inside `AppShell` have no `Scaffold` of their own, so
/// pumping one bare makes `ScaffoldMessenger.showSnackBar` assert.
Widget appFrame(Widget screen, {Locale locale = const Locale('en')}) =>
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: screen),
    );

/// Pumps [app] at [size] and writes `test/shots/out/<name>.png`.
///
/// Pass the whole tree, `ProviderScope` included -- the overrides list cannot
/// be a parameter here because Riverpod 3 does not export the `Override`
/// type, so an explicitly typed `List<Override>` fails to compile. Building
/// the scope at the call site lets the list literal infer instead.
Future<void> shoot(
  WidgetTester tester,
  Widget app, {
  required String name,
  Size size = const Size(1000, 620),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(app);
  await tester.pumpAndSettle();

  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('out/$name.png'),
  );
}
