import 'package:congregation_scheduler/core/l10n/l10n.dart';
import 'package:congregation_scheduler/core/l10n/monday_first_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every supported locale starts the week on Monday', () async {
    const delegate = MondayFirstMaterialLocalizationsDelegate();
    for (final locale in AppLocalizations.supportedLocales) {
      final localizations = await delegate.load(locale);
      expect(localizations.firstDayOfWeekIndex, 1,
          reason: '$locale must start the week on Monday '
              '(firstDayOfWeekIndex: 0=Sunday..6=Saturday)');
    }
  });
}
