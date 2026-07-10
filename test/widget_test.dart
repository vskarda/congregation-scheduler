import 'package:congregation_scheduler/app.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/l10n/locale_provider.dart';
import 'package:congregation_scheduler/features/setup/setup_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('supports and persists Turkish as the selected locale', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);

    expect(AppLocalizations.supportedLocales, contains(const Locale('tr')));
    expect(
        await AppLocalizations.delegate.load(const Locale('tr')).then(
              (localizations) => localizations.languageTurkish,
            ),
        'Türkçe');

    await container.read(localeProvider.notifier).set(const Locale('tr'));
    expect(container.read(localeProvider), const Locale('tr'));
    expect(prefs.getString('app_locale'), 'tr');
  });

  testWidgets('boots to the setup screen when no config is stored',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const CongregationApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SetupScreen), findsOneWidget);
  });
}
