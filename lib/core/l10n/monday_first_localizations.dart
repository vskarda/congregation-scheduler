import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// Index of the first day of week per [MaterialLocalizations.firstDayOfWeekIndex]:
/// 0 = Sunday .. 6 = Saturday.
const int _mondayIndex = 1;

/// `en`'s CLDR data defaults to Sunday-first (en_US convention), which is the
/// only locale among [AppLocalizations.supportedLocales] that isn't already
/// Monday-first — `cs` and `tr` already start on Monday. Overrides just
/// [firstDayOfWeekIndex] so the calendar grid in [showDatePicker] etc. always
/// starts on Monday, matching the Monday-anchored week logic used everywhere
/// else in the app (see `core/utils/dates.dart`).
class _MondayFirstMaterialLocalizationEn extends MaterialLocalizationEn {
  const _MondayFirstMaterialLocalizationEn({
    required super.fullYearFormat,
    required super.compactDateFormat,
    required super.shortDateFormat,
    required super.mediumDateFormat,
    required super.longDateFormat,
    required super.yearMonthFormat,
    required super.shortMonthDayFormat,
    required super.decimalFormat,
    required super.twoDigitZeroPaddedFormat,
  });

  @override
  int get firstDayOfWeekIndex => _mondayIndex;
}

/// Wraps the stock Material localizations delegate to force Monday as the
/// first day of week for every locale. Must be listed before
/// [GlobalMaterialLocalizations.delegate] (and before
/// [AppLocalizations.localizationsDelegates], which includes it) since
/// [Localizations] only honors the first delegate registered for a type.
class MondayFirstMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const MondayFirstMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      GlobalMaterialLocalizations.delegate.isSupported(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final base = await GlobalMaterialLocalizations.delegate.load(locale);
    if (base.firstDayOfWeekIndex == _mondayIndex) return base;

    // Only 'en' is known to default to Sunday-first today; a future locale
    // that also defaults to Sunday-first would need its own branch here (the
    // guard test in monday_first_localizations_test.dart fails until it's
    // added).
    if (locale.languageCode != 'en') return base;

    return _MondayFirstMaterialLocalizationEn(
      fullYearFormat: intl.DateFormat.y('en'),
      compactDateFormat: intl.DateFormat.yMd('en'),
      shortDateFormat: intl.DateFormat.yMMMd('en'),
      mediumDateFormat: intl.DateFormat.MMMEd('en'),
      longDateFormat: intl.DateFormat.yMMMMEEEEd('en'),
      yearMonthFormat: intl.DateFormat.yMMMM('en'),
      shortMonthDayFormat: intl.DateFormat.MMMd('en'),
      decimalFormat: intl.NumberFormat.decimalPattern('en'),
      twoDigitZeroPaddedFormat: intl.NumberFormat('00', 'en'),
    );
  }

  @override
  bool shouldReload(MondayFirstMaterialLocalizationsDelegate old) => false;
}

/// [AppLocalizations.localizationsDelegates] with Material's date picker
/// forced to start the week on Monday. Use this instead of
/// `AppLocalizations.localizationsDelegates` when configuring `MaterialApp`.
List<LocalizationsDelegate<dynamic>> get appLocalizationsDelegates => [
      const MondayFirstMaterialLocalizationsDelegate(),
      ...AppLocalizations.localizationsDelegates,
    ];
