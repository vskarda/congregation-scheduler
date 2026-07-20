/// Global app constants.
abstract final class AppConfig {
  /// Publication-media API URL template used to locate the Meeting Workbook
  /// epub online. The JSON response carries the epub download URL under
  /// `files.{lang}.EPUB[0].file.url`; unpublished issues answer 404.
  ///
  /// Placeholders: `{lang}` (publication language code, e.g. E / B / TK) and
  /// `{yyyyMM}` (issue month). Note web builds may be blocked by CORS —
  /// file import is the fallback there.
  static const String workbookCdnUrlTemplate =
      'https://app.jw-cdn.org/apis/pub-media/GETPUBMEDIALINKS'
      '?output=json&pub=mwb&fileformat=EPUB&langwritten={lang}&issue={yyyyMM}';

  /// Publication-media API URL template for the meeting songbook (pub `sjjm`).
  /// The JSON response lists audio tracks under `files.{lang}.MP3[]`, each
  /// carrying a `title` of the form "N. Song Title"; parsed into a
  /// number->title catalog. Placeholder: `{lang}` (E / B / TK).
  static const String songCatalogCdnUrlTemplate =
      'https://app.jw-cdn.org/apis/pub-media/GETPUBMEDIALINKS'
      '?output=json&pub=sjjm&fileformat=MP3&langwritten={lang}';

  /// Maximum size of a file stored in Firestore (chunked). Larger files
  /// should be shared as external links.
  static const int maxFileSizeBytes = 10 * 1024 * 1024;

  /// Binary bytes per Firestore chunk document (limit is 1 MiB per doc).
  static const int fileChunkBytes = 900 * 1024;

  /// How far ahead recurring public-witnessing slots are materialized.
  static const int pwMaterializeMonthsAhead = 3;

  /// How far ahead recurring field-service meetings are materialized.
  static const int fsmMaterializeMonthsAhead = 3;

  /// How much schedule history feeds the "least recently assigned" ordering.
  static const int pickerHistoryMonths = 18;

  /// How many service years of report entries are migrated when an
  /// admin-created record is connected to a registered account. Report
  /// entries carry the publisher id only in their doc id (no queryable
  /// field), so the migration probes month keys over this bounded window.
  static const int connectReportsHistoryYears = 10;
}
