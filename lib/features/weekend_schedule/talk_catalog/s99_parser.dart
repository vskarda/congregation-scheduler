/// Parses the S-99 "Public Talk Titles" form into talk number -> title.
///
/// Works on plain page texts extracted from the PDF. Language-agnostic:
/// entries are recognized purely by their numeric anchors ("142. Title"),
/// never by keywords, so any language edition of the form parses the same.
abstract final class S99Parser {
  // Zero-width characters (ZWSP..ZWJ, BOM) that leak into extracted text.
  static final _invisiblePattern = RegExp('[​-‍﻿]');

  // An entry anchor: "142. Title text…".
  static final _entryPattern = RegExp(r'^\s*(\d{1,3})\.\s*(\S.*)$');

  // Per-page form header ("S-99-E  2/26"); the form symbol is constant
  // across language editions.
  static final _formCodePattern = RegExp(r'^\s*S-99');

  /// The first accepted entry number must be at most this, which implicitly
  /// skips numbered text inside the intro paragraph.
  static const _maxFirstNumber = 5;

  static const _minEntries = 20;
  static const _maxNumber = 400;

  /// Parses per-page texts into talk number -> title. Titles wrapped across
  /// lines within a page are joined; entries never span pages (the form's
  /// table rows don't split), so page trailers/leaders ("Year:" labels)
  /// cannot leak into titles. Gaps in numbering are allowed (discontinued
  /// outlines). Throws [FormatException] when the input does not look like
  /// an S-99 form.
  static Map<int, String> parse(List<String> pageTexts) {
    final titles = <int, String>{};
    int? lastNo;

    for (final pageText in pageTexts) {
      final lines =
          pageText.replaceAll(_invisiblePattern, '').split(RegExp('\r\n?|\n'));
      int? currentNo;
      var currentTitle = StringBuffer();

      void commit() {
        if (currentNo == null) return;
        final title = _normalize(currentTitle.toString());
        if (title.isNotEmpty) titles[currentNo] = title;
      }

      for (final line in lines) {
        if (_formCodePattern.hasMatch(line)) continue;
        final match = _entryPattern.firstMatch(line);
        final number = match == null ? null : int.parse(match.group(1)!);
        final startsEntry = number != null &&
            (lastNo == null ? number <= _maxFirstNumber : number > lastNo);
        if (startsEntry) {
          commit();
          currentNo = number;
          lastNo = number;
          currentTitle = StringBuffer(match!.group(2)!);
        } else if (currentNo != null) {
          // Wrapped continuation of the entry open on this page.
          currentTitle.write(' ${line.trim()}');
        }
        // Lines before the page's first entry (headers, intro, year row)
        // are ignored.
      }
      commit();
    }

    if (titles.length < _minEntries ||
        titles.keys.any((n) => n > _maxNumber)) {
      throw const FormatException('Not a recognizable S-99 talk title list');
    }
    return titles;
  }

  static String _normalize(String text) => text
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

typedef CatalogDiff = ({
  List<int> added,
  List<int> changed,
  List<int> removed,
  List<int> unchanged,
});

/// Partitions talk numbers by how [newTitles] differs from [oldTitles].
CatalogDiff diffCatalog(
    Map<int, String> oldTitles, Map<int, String> newTitles) {
  final added = <int>[];
  final changed = <int>[];
  final unchanged = <int>[];
  for (final no in newTitles.keys.toList()..sort()) {
    if (!oldTitles.containsKey(no)) {
      added.add(no);
    } else if (oldTitles[no] != newTitles[no]) {
      changed.add(no);
    } else {
      unchanged.add(no);
    }
  }
  final removed = (oldTitles.keys.where((n) => !newTitles.containsKey(n)))
      .toList()
    ..sort();
  return (
    added: added,
    changed: changed,
    removed: removed,
    unchanged: unchanged,
  );
}
