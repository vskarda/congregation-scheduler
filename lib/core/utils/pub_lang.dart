import 'package:flutter/widgets.dart';

/// Maps an app [Locale] to the JW publication-media `langwritten` code used by
/// the pub-media CDN (Meeting Workbook, songbook). Defaults to English.
String pubLangFor(Locale locale) => switch (locale.languageCode) {
      'cs' => 'B',
      'tr' => 'TK',
      _ => 'E',
    };
