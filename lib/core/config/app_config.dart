/// Global app constants.
abstract final class AppConfig {
  /// CDN URL template for the Meeting Workbook epub.
  ///
  /// TODO: the real URL will be provided later and is deliberately kept out of
  /// the UI. Placeholders: `{lang}` (publication language code, e.g. E / B)
  /// and `{yyyyMM}` (issue month). While this is null the "check online"
  /// action stays hidden and only file import is offered.
  static const String? workbookCdnUrlTemplate = null;

  /// Maximum size of a file stored in Firestore (chunked). Larger files
  /// should be shared as external links.
  static const int maxFileSizeBytes = 10 * 1024 * 1024;

  /// Binary bytes per Firestore chunk document (limit is 1 MiB per doc).
  static const int fileChunkBytes = 900 * 1024;

  /// How far ahead recurring public-witnessing slots are materialized.
  static const int pwMaterializeMonthsAhead = 3;

  /// How much schedule history feeds the "least recently assigned" ordering.
  static const int pickerHistoryMonths = 18;
}
