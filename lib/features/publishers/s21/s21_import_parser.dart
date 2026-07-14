import '../../../core/models/models.dart';

/// Parses the text layer of an S-21 publisher record card (any of the app's
/// languages: English, Czech, Turkish) into structured data.
///
/// Handles both the "flat" generated card layout (values inline with the
/// labels, checkbox glyphs in the text, possibly several service years per
/// file) and — best effort — the official fillable form, whose static labels
/// extract with decomposed diacritics. Values stored only in AcroForm fields
/// (never rendered into the text layer) cannot be recovered here; such files
/// simply parse as empty.
///
/// Labels are matched on normalized tokens (lowercased, diacritics stripped),
/// so the parser needs no localization at runtime.

/// One month row of the S-21 table.
class S21MonthRow {
  const S21MonthRow({
    required this.month,
    this.participated = false,
    this.bibleStudies,
    this.auxPioneer = false,
    this.hours,
    this.creditHours,
    this.comments = '',
  });

  /// Calendar month 1–12 (September = 9).
  final int month;
  final bool participated;
  final int? bibleStudies;

  /// The "Auxiliary Pioneer" column checkbox.
  final bool auxPioneer;
  final int? hours;

  /// Parsed from a "Credit:/Kredit:/Kredi:" note in the remarks, if present.
  final int? creditHours;

  /// Full original remarks text (credit notes are kept in here too).
  final String comments;

  bool get isEmpty =>
      !participated &&
      !auxPioneer &&
      bibleStudies == null &&
      hours == null &&
      comments.isEmpty;
}

/// One service-year table of the card.
class S21YearImport {
  const S21YearImport({required this.serviceYear, required this.rows});

  /// Sep–Aug service year labeled by its ending year (2026 = Sep 2025–Aug
  /// 2026, matching [serviceYearMonths]); null when the card left it blank.
  final int? serviceYear;
  final List<S21MonthRow> rows;
}

/// Everything recovered from one S-21 file. Header values are null when the
/// label (or its checkbox state) could not be found — callers should keep
/// the app's current value in that case.
class S21Import {
  const S21Import({
    this.name = '',
    this.birthDate,
    this.baptismDate,
    this.gender,
    this.hope,
    this.appointment,
    this.status,
    this.years = const [],
  });

  final String name;

  /// yyyy-MM-dd.
  final String? birthDate;

  /// yyyy-MM-dd.
  final String? baptismDate;
  final Gender? gender;
  final Hope? hope;
  final Appointment? appointment;

  /// Header pioneer checkboxes; [PublisherStatus.publisher] when the labels
  /// were found but none is checked. Auxiliary pioneer is per-month.
  final PublisherStatus? status;
  final List<S21YearImport> years;

  int get monthCount => years.fold(0, (sum, y) => sum + y.rows.length);

  bool get isEmpty => years.isEmpty && name.isEmpty;
}

/// yyyy-MM key of calendar [month] (1–12) within Sep-first [serviceYear].
String s21MonthKey(int serviceYear, int month) {
  final year = month >= 9 ? serviceYear - 1 : serviceYear;
  return '$year-${month.toString().padLeft(2, '0')}';
}

/// "First Last" → (first: "First", last: "Last"); the last word becomes the
/// surname, everything before it the first name(s).
({String first, String last}) splitS21Name(String name) {
  final parts = name.trim().split(RegExp(r'\s+'))
    ..removeWhere((p) => p.isEmpty);
  if (parts.isEmpty) return (first: '', last: '');
  if (parts.length == 1) return (first: parts.first, last: '');
  return (
    first: parts.sublist(0, parts.length - 1).join(' '),
    last: parts.last,
  );
}

S21Import parseS21Import(String text) => _S21Parser(text).parse();

// ---------------------------------------------------------------------------

enum _Label {
  name,
  birth,
  baptism,
  male,
  female,
  otherSheep,
  anointed,
  elder,
  ministerialServant,
  regularPioneer,
  specialPioneer,
  fieldMissionary,
  serviceYear,
  total,
}

/// Condensed (lowercased, diacritics stripped, no spaces) label phrases for
/// en / cs / tr, both the official card wording and the app's own S-21
/// export wording.
const Map<_Label, List<String>> _labelPhrases = {
  _Label.name: ['name', 'jmeno', 'isim'],
  _Label.birth: ['dateofbirth', 'birthdate', 'datumnarozeni', 'dogumtarihi'],
  _Label.baptism: [
    'dateofbaptism',
    'baptismdate',
    'datumkrtu',
    'vaftiztarihi',
  ],
  _Label.male: ['male', 'muz', 'erkek'],
  _Label.female: ['female', 'zena', 'kadin'],
  _Label.otherSheep: ['othersheep', 'jinaovce', 'baskakoyun'],
  _Label.anointed: ['anointed', 'pomazany', 'meshedilmis'],
  _Label.elder: ['elder', 'starsi', 'ihtiyar'],
  _Label.ministerialServant: [
    'ministerialservant',
    'sluzebnipomocnik',
    'hizmetgorevlisi',
  ],
  _Label.regularPioneer: [
    'regularpioneer',
    'pravidelnyprukopnik',
    'daimioncu',
  ],
  _Label.specialPioneer: [
    'specialpioneer',
    'zvlastniprukopnik',
    'ozeloncu',
  ],
  _Label.fieldMissionary: ['fieldmissionary', 'misionar', 'gorevlivaiz'],
  _Label.serviceYear: ['serviceyear', 'sluzebnirok', 'hizmetyili'],
  _Label.total: ['total', 'celkem', 'toplam'],
};

/// Condensed month names (en / cs / tr) → calendar month number.
const Map<String, int> _monthPhrases = {
  'september': 9, 'october': 10, 'november': 11, 'december': 12, //
  'january': 1, 'february': 2, 'march': 3, 'april': 4, 'may': 5,
  'june': 6, 'july': 7, 'august': 8,
  'zari': 9, 'rijen': 10, 'listopad': 11, 'prosinec': 12,
  'leden': 1, 'unor': 2, 'brezen': 3, 'duben': 4, 'kveten': 5,
  'cerven': 6, 'cervenec': 7, 'srpen': 8,
  'eylul': 9, 'ekim': 10, 'kasim': 11, 'aralik': 12,
  'ocak': 1, 'subat': 2, 'mart': 3, 'nisan': 4, 'mayis': 5,
  'haziran': 6, 'temmuz': 7, 'agustos': 8,
};

/// Checkbox glyphs. `þ`/`¨` are what the common generated cards' dingbat
/// checkboxes decode to; `X` is what the app's own S-21 export prints inside
/// a checked box.
const Set<String> _checkedGlyphs = {'þ', 'Þ', '☑', '☒', '✓', '✔', '■', 'x', 'X'};
const Set<String> _uncheckedGlyphs = {'¨', '☐', '□', '❑'};

const Map<String, String> _diacriticsMap = {
  'á': 'a', 'à': 'a', 'â': 'a', 'ä': 'a', 'ă': 'a', 'ą': 'a', //
  'č': 'c', 'ç': 'c', 'ć': 'c',
  'ď': 'd', 'đ': 'd',
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e', 'ě': 'e', 'ę': 'e',
  'ğ': 'g',
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i', 'ı': 'i',
  'ľ': 'l', 'ĺ': 'l', 'ł': 'l',
  'ň': 'n', 'ń': 'n', 'ñ': 'n',
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'ö': 'o', 'ő': 'o',
  'ř': 'r', 'ŕ': 'r',
  'š': 's', 'ś': 's', 'ş': 's', 'ș': 's', 'ß': 'ss',
  'ť': 't', 'ţ': 't', 'ț': 't',
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u', 'ů': 'u', 'ű': 'u',
  'ý': 'y', 'ÿ': 'y',
  'ž': 'z', 'ź': 'z', 'ż': 'z',
};

/// Lowercases and strips diacritics, punctuation and stray accent marks
/// (the official forms extract with decomposed diacritics like `Do ˘ gum`),
/// keeping only ASCII letters and digits. May return ''.
String _normalizeToken(String token) {
  final buf = StringBuffer();
  for (final rune in token.toLowerCase().runes) {
    // Combining marks (U+0300–U+036F) — e.g. the dot 'İ' lowercases into.
    if (rune >= 0x300 && rune <= 0x36F) continue;
    final ch = String.fromCharCode(rune);
    final mapped = _diacriticsMap[ch] ?? ch;
    for (final r in mapped.runes) {
      if ((r >= 0x61 && r <= 0x7A) || (r >= 0x30 && r <= 0x39)) {
        buf.writeCharCode(r);
      }
    }
  }
  return buf.toString();
}

final RegExp _intRe = RegExp(r'^\d+$');
final RegExp _yearRe = RegExp(r'^(19|20)\d{2}$');
final RegExp _ymdRe = RegExp(r'(\d{4})[./-](\d{1,2})[./-](\d{1,2})');
final RegExp _dmyRe = RegExp(r'(\d{1,2})[./](\d{1,2})[./](\d{4})');
final RegExp _creditRe = RegExp(r'(?:credit|kredit|kredi)[^0-9]{0,3}(\d+)');

class _Hit {
  const _Hit({this.label, this.month, required this.end});

  final _Label? label;
  final int? month;

  /// Token index just past the matched phrase.
  final int end;
}

class _Block {
  _Block(this.year);

  final int? year;
  final List<S21MonthRow> rows = [];
}

class _S21Parser {
  _S21Parser(String text) {
    for (final raw in text.split(RegExp(r'\s+'))) {
      var t = raw;
      // Glyphs occasionally stick to the following value ("þ3").
      while (t.length > 1 && _isGlyph(t[0])) {
        _tokens.add(t[0]);
        t = t.substring(1);
      }
      if (t.isNotEmpty) _tokens.add(t);
    }
    _norms = [for (final t in _tokens) _normalizeToken(t)];
  }

  final List<String> _tokens = [];
  late final List<String> _norms;

  static bool _isGlyph(String s) =>
      _checkedGlyphs.contains(s) || _uncheckedGlyphs.contains(s);

  /// Matches a condensed [phrase] starting at token [i]. Tokens must be
  /// consumed whole; tokens that normalize to '' (accent-mark debris in the
  /// official forms) are skipped, so `Do ˘ gum tarihi` matches
  /// `dogumtarihi`. Returns the exclusive end index, or null.
  int? _matchPhrase(String phrase, int i) {
    if (i >= _tokens.length || _norms[i].isEmpty) return null;
    var acc = '';
    var j = i;
    while (j < _tokens.length && acc.length < phrase.length) {
      final n = _norms[j];
      j++;
      if (n.isEmpty) continue;
      acc += n;
      if (!phrase.startsWith(acc)) return null;
    }
    return acc == phrase ? j : null;
  }

  _Hit? _matchAt(int i) {
    for (final entry in _labelPhrases.entries) {
      for (final phrase in entry.value) {
        final end = _matchPhrase(phrase, i);
        if (end != null) return _Hit(label: entry.key, end: end);
      }
    }
    for (final entry in _monthPhrases.entries) {
      final end = _matchPhrase(entry.key, i);
      if (end != null) return _Hit(month: entry.value, end: end);
    }
    return null;
  }

  /// First occurrence of [label]; also matched during the month scan, so a
  /// phrase like "Görevli vaiz" inside a column header never outranks the
  /// real header line, which always comes first in the document.
  _Hit? _find(_Label label) {
    for (var i = 0; i < _tokens.length; i++) {
      for (final phrase in _labelPhrases[label]!) {
        final end = _matchPhrase(phrase, i);
        if (end != null) return _Hit(label: label, end: end);
      }
    }
    return null;
  }

  int? _indexOf(_Label label) {
    for (var i = 0; i < _tokens.length; i++) {
      for (final phrase in _labelPhrases[label]!) {
        if (_matchPhrase(phrase, i) != null) return i;
      }
    }
    return null;
  }

  /// Whether the checkbox belonging to the label starting at token [i] is
  /// checked: both the generated cards and the app's own export place the
  /// box glyph immediately before the label text.
  bool _checkedBefore(int i) =>
      i > 0 && _checkedGlyphs.contains(_tokens[i - 1]);

  /// Tri-state checkbox: null = label not found.
  bool? _checkbox(_Label label) {
    final i = _indexOf(label);
    return i == null ? null : _checkedBefore(i);
  }

  /// Date value following the label ending at token [end]: joins the next
  /// few tokens (Czech dates extract as "17." "11." "1997") and normalizes
  /// to yyyy-MM-dd.
  String? _dateAfter(int end) {
    final window =
        _tokens.sublist(end, (end + 4).clamp(0, _tokens.length)).join();
    final ymd = _ymdRe.firstMatch(window);
    if (ymd != null) {
      return _dateKey(ymd.group(1)!, ymd.group(2)!, ymd.group(3)!);
    }
    final dmy = _dmyRe.firstMatch(window);
    if (dmy != null) {
      return _dateKey(dmy.group(3)!, dmy.group(2)!, dmy.group(1)!);
    }
    return null;
  }

  static String? _dateKey(String y, String m, String d) {
    final month = int.parse(m);
    final day = int.parse(d);
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    return '$y-${m.padLeft(2, '0')}-${d.padLeft(2, '0')}';
  }

  String _nameAfter(int end) {
    final parts = <String>[];
    for (var i = end; i < _tokens.length && parts.length < 6; i++) {
      final t = _tokens[i];
      if (_isGlyph(t) || _ymdRe.hasMatch(t) || _matchAt(i) != null) break;
      if (_norms[i].isEmpty) continue;
      parts.add(t);
    }
    return parts.join(' ');
  }

  S21Import parse() {
    // --- header ---
    final nameHit = _find(_Label.name);
    final name = nameHit == null ? '' : _nameAfter(nameHit.end);
    final birthHit = _find(_Label.birth);
    final baptismHit = _find(_Label.baptism);

    final male = _checkbox(_Label.male);
    final female = _checkbox(_Label.female);
    final gender = female == true
        ? Gender.female
        : male == true
            ? Gender.male
            : null;

    final otherSheep = _checkbox(_Label.otherSheep);
    final anointed = _checkbox(_Label.anointed);
    final hope = anointed == true
        ? Hope.anointed
        : otherSheep == true
            ? Hope.otherSheep
            : null;

    final elder = _checkbox(_Label.elder);
    final ms = _checkbox(_Label.ministerialServant);
    final appointment = elder == true
        ? Appointment.elder
        : ms == true
            ? Appointment.ministerialServant
            : (elder != null && ms != null)
                ? Appointment.none
                : null;

    final reg = _checkbox(_Label.regularPioneer);
    final special = _checkbox(_Label.specialPioneer);
    final missionary = _checkbox(_Label.fieldMissionary);
    final status = special == true
        ? PublisherStatus.specialPioneer
        : reg == true
            ? PublisherStatus.regularPioneer
            : missionary == true
                ? PublisherStatus.fieldMissionary
                : (reg != null && special != null && missionary != null)
                    ? PublisherStatus.publisher
                    : null;

    // --- service-year tables ---
    final blocks = <_Block>[];
    _Block? current;
    var i = 0;
    while (i < _tokens.length) {
      final hit = _matchAt(i);
      if (hit == null) {
        i++;
        continue;
      }
      if (hit.label == _Label.serviceYear) {
        int? year;
        for (var j = hit.end;
            j < (hit.end + 4).clamp(0, _tokens.length);
            j++) {
          if (_yearRe.hasMatch(_tokens[j])) {
            year = int.parse(_tokens[j]);
            break;
          }
        }
        current = _Block(year);
        blocks.add(current);
        i = hit.end;
      } else if (hit.month != null) {
        var end = hit.end;
        while (end < _tokens.length) {
          final next = _matchAt(end);
          if (next != null &&
              (next.month != null ||
                  next.label == _Label.serviceYear ||
                  next.label == _Label.total)) {
            break;
          }
          end++;
        }
        final row = _parseRow(hit.month!, hit.end, end);
        if (!row.isEmpty) {
          if (current == null) {
            current = _Block(null);
            blocks.add(current);
          }
          current.rows.add(row);
        }
        i = end;
      } else {
        i = hit.end;
      }
    }

    final years = [
      for (final b in blocks)
        if (b.rows.isNotEmpty)
          S21YearImport(serviceYear: b.year, rows: b.rows),
    ];

    return S21Import(
      name: name,
      birthDate: birthHit == null ? null : _dateAfter(birthHit.end),
      baptismDate: baptismHit == null ? null : _dateAfter(baptismHit.end),
      gender: gender,
      hope: hope,
      appointment: appointment,
      status: status,
      years: years,
    );
  }

  /// Row layout: [participated box] [studies] [aux box] [hours] [remarks].
  /// The generated cards always print both box glyphs; the app's own export
  /// only prints an X for checked boxes, so with fewer glyphs the integers
  /// are assigned studies-first.
  S21MonthRow _parseRow(int month, int start, int end) {
    final glyphs = <int>[];
    for (var i = start; i < end && glyphs.length < 2; i++) {
      if (_isGlyph(_tokens[i])) glyphs.add(i);
    }

    int? firstInt(int from, int to) {
      for (var i = from; i < to; i++) {
        if (_intRe.hasMatch(_tokens[i])) return i;
      }
      return null;
    }

    int? studiesIdx;
    int? hoursIdx;
    if (glyphs.length >= 2) {
      studiesIdx = firstInt(glyphs[0] + 1, glyphs[1]);
      hoursIdx = firstInt(glyphs[1] + 1, end);
    } else {
      final from = glyphs.isEmpty ? start : glyphs[0] + 1;
      studiesIdx = firstInt(from, end);
      if (studiesIdx != null) hoursIdx = firstInt(studiesIdx + 1, end);
    }

    final participated =
        glyphs.isNotEmpty && _checkedGlyphs.contains(_tokens[glyphs[0]]);
    final aux =
        glyphs.length >= 2 && _checkedGlyphs.contains(_tokens[glyphs[1]]);

    // Remarks start after the last recognized table value (a stray glyph in
    // the remarks text itself is left untouched).
    final lastValue = [
      if (glyphs.isNotEmpty) glyphs.last,
      ?studiesIdx,
      ?hoursIdx,
    ];
    final commentsFrom = lastValue.isEmpty
        ? start
        : lastValue.reduce((a, b) => a > b ? a : b) + 1;
    final comments = _tokens.sublist(commentsFrom, end).join(' ').trim();
    final credit = _creditRe.firstMatch(
      [for (var i = commentsFrom; i < end; i++) _norms[i]].join(' '),
    );

    return S21MonthRow(
      month: month,
      participated: participated,
      bibleStudies: studiesIdx == null ? null : int.parse(_tokens[studiesIdx]),
      auxPioneer: aux,
      hours: hoursIdx == null ? null : int.parse(_tokens[hoursIdx]),
      creditHours: credit == null ? null : int.parse(credit.group(1)!),
      comments: comments,
    );
  }
}
