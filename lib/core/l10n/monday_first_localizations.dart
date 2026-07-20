import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// Index of the first day of week per [MaterialLocalizations.firstDayOfWeekIndex]:
/// 0 = Sunday .. 6 = Saturday.
const int _mondayIndex = 1;

/// The supported locales whose CLDR data defaults to Sunday-first and therefore
/// need a Monday-first override. Checked against the `intl` package's
/// `FIRSTDAYOFWEEK` symbol: `en`, `pt` and `ja` are Sunday-first, while
/// `cs`, `tr`, `es`, `it`, `fr`, `pl` and `de` already start on Monday.
/// A future Sunday-first locale must be added here (and given its own subclass
/// below); the guard test in `monday_first_localizations_test.dart` fails
/// until it is.
const _sundayFirstCodes = {'en', 'pt', 'ja'};

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

class _MondayFirstMaterialLocalizationPt extends MaterialLocalizationPt {
  const _MondayFirstMaterialLocalizationPt({
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

class _MondayFirstMaterialLocalizationJa extends MaterialLocalizationJa {
  const _MondayFirstMaterialLocalizationJa({
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

/// The date/number formats every [GlobalMaterialLocalizations] subclass needs,
/// built for one locale code so each Monday-first subclass can be constructed
/// without repeating the nine expressions.
typedef _Formats = ({
  intl.DateFormat fullYearFormat,
  intl.DateFormat compactDateFormat,
  intl.DateFormat shortDateFormat,
  intl.DateFormat mediumDateFormat,
  intl.DateFormat longDateFormat,
  intl.DateFormat yearMonthFormat,
  intl.DateFormat shortMonthDayFormat,
  intl.NumberFormat decimalFormat,
  intl.NumberFormat twoDigitZeroPaddedFormat,
});

_Formats _formatsFor(String code) => (
      fullYearFormat: intl.DateFormat.y(code),
      compactDateFormat: intl.DateFormat.yMd(code),
      shortDateFormat: intl.DateFormat.yMMMd(code),
      mediumDateFormat: intl.DateFormat.MMMEd(code),
      longDateFormat: intl.DateFormat.yMMMMEEEEd(code),
      yearMonthFormat: intl.DateFormat.yMMMM(code),
      shortMonthDayFormat: intl.DateFormat.MMMd(code),
      decimalFormat: intl.NumberFormat.decimalPattern(code),
      twoDigitZeroPaddedFormat: intl.NumberFormat('00', code),
    );

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

    final code = locale.languageCode;
    if (!_sundayFirstCodes.contains(code)) return base;

    final f = _formatsFor(code);
    return switch (code) {
      'pt' => _MondayFirstMaterialLocalizationPt(
          fullYearFormat: f.fullYearFormat,
          compactDateFormat: f.compactDateFormat,
          shortDateFormat: f.shortDateFormat,
          mediumDateFormat: f.mediumDateFormat,
          longDateFormat: f.longDateFormat,
          yearMonthFormat: f.yearMonthFormat,
          shortMonthDayFormat: f.shortMonthDayFormat,
          decimalFormat: f.decimalFormat,
          twoDigitZeroPaddedFormat: f.twoDigitZeroPaddedFormat,
        ),
      'ja' => _MondayFirstMaterialLocalizationJa(
          fullYearFormat: f.fullYearFormat,
          compactDateFormat: f.compactDateFormat,
          shortDateFormat: f.shortDateFormat,
          mediumDateFormat: f.mediumDateFormat,
          longDateFormat: f.longDateFormat,
          yearMonthFormat: f.yearMonthFormat,
          shortMonthDayFormat: f.shortMonthDayFormat,
          decimalFormat: f.decimalFormat,
          twoDigitZeroPaddedFormat: f.twoDigitZeroPaddedFormat,
        ),
      _ => _MondayFirstMaterialLocalizationEn(
          fullYearFormat: f.fullYearFormat,
          compactDateFormat: f.compactDateFormat,
          shortDateFormat: f.shortDateFormat,
          mediumDateFormat: f.mediumDateFormat,
          longDateFormat: f.longDateFormat,
          yearMonthFormat: f.yearMonthFormat,
          shortMonthDayFormat: f.shortMonthDayFormat,
          decimalFormat: f.decimalFormat,
          twoDigitZeroPaddedFormat: f.twoDigitZeroPaddedFormat,
        ),
    };
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
