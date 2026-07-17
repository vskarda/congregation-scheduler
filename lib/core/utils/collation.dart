/// Name collation for the app's languages (Czech, Turkish, English).
///
/// Dart has no ICU collator, so a plain `String.compareTo` sorts by Unicode
/// code point and dumps accented letters after `z` (e.g. "Šimek" after
/// "Zeman"). Instead we fold each letter to its base for the primary
/// comparison, then fall back to the original (accented) text to break ties.
///
/// Effect: accented names sort among their base letter — "Šimek" lands between
/// "Simon" and "Skala" — and on an otherwise-equal remainder the accented form
/// orders right after its base ("s" before "š", "c" before "č"). This covers
/// Czech and Turkish diacritics (and common Western/Polish ones) without a
/// per-locale alphabet table.
library;

/// Accented letter (lowercased) -> base letter. Keys are code points so
/// multi-codepoint results (e.g. German ß) and removals (combining marks) are
/// handled uniformly. Unlisted runes pass through unchanged.
const Map<int, String> _fold = {
  // Czech
  0x00E1: 'a', // á
  0x010D: 'c', // č
  0x010F: 'd', // ď
  0x00E9: 'e', // é
  0x011B: 'e', // ě
  0x00ED: 'i', // í
  0x0148: 'n', // ň
  0x00F3: 'o', // ó
  0x0159: 'r', // ř
  0x0161: 's', // š
  0x0165: 't', // ť
  0x00FA: 'u', // ú
  0x016F: 'u', // ů
  0x00FD: 'y', // ý
  0x017E: 'z', // ž
  // Turkish
  0x00E7: 'c', // ç
  0x011F: 'g', // ğ
  0x0131: 'i', // ı (dotless i)
  0x00F6: 'o', // ö
  0x015F: 's', // ş
  0x00FC: 'u', // ü
  0x0307: '', // ◌̇ combining dot above (from lowercasing İ)
  // Other common Western Latin
  0x00E0: 'a', // à
  0x00E2: 'a', // â
  0x00E3: 'a', // ã
  0x00E4: 'a', // ä
  0x00E5: 'a', // å
  0x00E8: 'e', // è
  0x00EA: 'e', // ê
  0x00EB: 'e', // ë
  0x00EC: 'i', // ì
  0x00EE: 'i', // î
  0x00EF: 'i', // ï
  0x00F1: 'n', // ñ
  0x00F2: 'o', // ò
  0x00F4: 'o', // ô
  0x00F5: 'o', // õ
  0x00F9: 'u', // ù
  0x00FB: 'u', // û
  0x00FF: 'y', // ÿ
  0x00DF: 'ss', // ß
  // Polish
  0x0105: 'a', // ą
  0x0107: 'c', // ć
  0x0119: 'e', // ę
  0x0142: 'l', // ł
  0x0144: 'n', // ń
  0x015B: 's', // ś
  0x017A: 'z', // ź
  0x017C: 'z', // ż
};

/// Lowercases [s] and folds its diacritics to base letters. Exposed for tests.
String foldForSort(String s) {
  final buffer = StringBuffer();
  for (final rune in s.toLowerCase().runes) {
    final mapped = _fold[rune];
    if (mapped != null) {
      buffer.write(mapped);
    } else {
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString();
}

/// Locale-aware-ish comparison of two display names. Primary order is by folded
/// base letters; equal folds fall back to the lowercased original so the
/// accented form (e.g. "š") sorts right after its base ("s").
int collate(String a, String b) {
  final byBase = foldForSort(a).compareTo(foldForSort(b));
  if (byBase != 0) return byBase;
  return a.toLowerCase().compareTo(b.toLowerCase());
}
