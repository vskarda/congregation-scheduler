import 'package:congregation_scheduler/core/data/admin_mode_provider.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/help/help_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The Help screen: publisher tips always visible, admin topics gated by
/// the viewer's roles.
void main() {
  // Tall surface so every help card is mounted, not scrolled out of view.
  void enlarge(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Widget wrap(Roles roles) {
    return ProviderScope(
      overrides: [effectiveRolesProvider.overrideWithValue(roles)],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: HelpScreen()),
      ),
    );
  }

  final en = lookupAppLocalizations(const Locale('en'));

  testWidgets('publisher sees tips but no admin section', (tester) async {
    enlarge(tester);
    await tester.pumpWidget(wrap(const Roles()));
    await tester.pumpAndSettle();

    expect(find.text(en.helpPublisherSection), findsOneWidget);
    expect(find.text(en.helpCalendarTitle), findsOneWidget);
    expect(find.text(en.helpRemindersTitle), findsOneWidget);
    expect(find.text(en.helpHighlightTitle), findsOneWidget);
    expect(find.text(en.helpTerritoryMapTitle), findsOneWidget);
    expect(find.text(en.helpAdminSection), findsNothing);
    expect(find.text(en.helpGoogleMyMapsTitle), findsNothing);
  });

  testWidgets('territory admin sees the Google My Maps topic',
      (tester) async {
    enlarge(tester);
    await tester.pumpWidget(wrap(const Roles(territories: true)));
    await tester.pumpAndSettle();

    expect(find.text(en.helpAdminSection), findsOneWidget);
    expect(find.text(en.helpAdminToggleTitle), findsOneWidget);
    expect(find.text(en.helpGoogleMyMapsTitle), findsOneWidget);
    expect(find.text(en.helpOpenGuide), findsOneWidget);
    // No LMM/weekend rights, so the PDF export topic stays hidden.
    expect(find.text(en.helpPdfExportTitle), findsNothing);
  });

  testWidgets('full admin sees every admin topic', (tester) async {
    enlarge(tester);
    await tester.pumpWidget(wrap(const Roles(fullAdmin: true)));
    await tester.pumpAndSettle();

    expect(find.text(en.helpAdminToggleTitle), findsOneWidget);
    expect(find.text(en.helpPdfExportTitle), findsOneWidget);
    expect(find.text(en.helpGoogleMyMapsTitle), findsOneWidget);
  });
}
