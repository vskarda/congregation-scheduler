import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:uuid/uuid.dart';

import '../../../core/models/models.dart';
import '../../../core/utils/dates.dart';

/// Heuristic parser for the Meeting Workbook (mwb) epub. Extracts one
/// [LmmWeek] per weekly program file: date range, weekly scripture, songs,
/// and the numbered parts with durations and instructions, mapped onto
/// sections and part types.
///
/// Two markup generations are supported:
///  * current (2024+): section headings carry `dc-icon--gem/wheat/sheep`
///    wrapper classes, part titles are `<h3>1. Title</h3>` with the duration
///    in a following `<p>(10 min.) instructions…</p>` detail paragraph;
///  * legacy/simple: plain text lines like `1. Title (10 min.)` with section
///    headings recognized by their wording.
///
/// Supported publication languages: English (mwb_E_*), Czech (mwb_B_*), and
/// Turkish (mwb_TK_*); structural markers above are language independent, only
/// date ranges and heading keywords are language specific.
abstract final class MwbParser {
  static const _enMonths = {
    'JANUARY': 1,
    'FEBRUARY': 2,
    'MARCH': 3,
    'APRIL': 4,
    'MAY': 5,
    'JUNE': 6,
    'JULY': 7,
    'AUGUST': 8,
    'SEPTEMBER': 9,
    'OCTOBER': 10,
    'NOVEMBER': 11,
    'DECEMBER': 12,
  };

  // Czech month names in genitive (as used in date ranges), plus September
  // nominative which is identical.
  static const _csMonths = {
    'LEDNA': 1,
    'ÚNORA': 2,
    'BŘEZNA': 3,
    'DUBNA': 4,
    'KVĚTNA': 5,
    'ČERVNA': 6,
    'ČERVENCE': 7,
    'SRPNA': 8,
    'ZÁŘÍ': 9,
    'ŘÍJNA': 10,
    'LISTOPADU': 11,
    'PROSINCE': 12,
  };

  static const _trMonths = {
    'OCAK': 1,
    'ŞUBAT': 2,
    'MART': 3,
    'NİSAN': 4,
    'MAYIS': 5,
    'HAZİRAN': 6,
    'TEMMUZ': 7,
    'AĞUSTOS': 8,
    'EYLÜL': 9,
    'EKİM': 10,
    'KASIM': 11,
    'ARALIK': 12,
  };

  // Spanish month names (nominative; Spanish does not inflect them in the
  // date ranges, e.g. "1 a 7 de septiembre").
  static const _esMonths = {
    'ENERO': 1,
    'FEBRERO': 2,
    'MARZO': 3,
    'ABRIL': 4,
    'MAYO': 5,
    'JUNIO': 6,
    'JULIO': 7,
    'AGOSTO': 8,
    'SEPTIEMBRE': 9,
    'OCTUBRE': 10,
    'NOVIEMBRE': 11,
    'DICIEMBRE': 12,
  };

  // Italian month names (nominative; not inflected in the date ranges,
  // e.g. "6-12 luglio").
  static const _itMonths = {
    'GENNAIO': 1,
    'FEBBRAIO': 2,
    'MARZO': 3,
    'APRILE': 4,
    'MAGGIO': 5,
    'GIUGNO': 6,
    'LUGLIO': 7,
    'AGOSTO': 8,
    'SETTEMBRE': 9,
    'OTTOBRE': 10,
    'NOVEMBRE': 11,
    'DICEMBRE': 12,
  };

  // French month names (nominative; not inflected in the date ranges,
  // e.g. "6-12 juillet").
  static const _frMonths = {
    'JANVIER': 1,
    'FÉVRIER': 2,
    'MARS': 3,
    'AVRIL': 4,
    'MAI': 5,
    'JUIN': 6,
    'JUILLET': 7,
    'AOÛT': 8,
    'SEPTEMBRE': 9,
    'OCTOBRE': 10,
    'NOVEMBRE': 11,
    'DÉCEMBRE': 12,
  };

  // Portuguese month names (nominative; not inflected in the date ranges,
  // e.g. "6-12 de julho").
  static const _ptMonths = {
    'JANEIRO': 1,
    'FEVEREIRO': 2,
    'MARÇO': 3,
    'ABRIL': 4,
    'MAIO': 5,
    'JUNHO': 6,
    'JULHO': 7,
    'AGOSTO': 8,
    'SETEMBRO': 9,
    'OUTUBRO': 10,
    'NOVEMBRO': 11,
    'DEZEMBRO': 12,
  };

  // Polish month names in the genitive (as used in the date ranges, e.g.
  // "6-12 lipca").
  static const _plMonths = {
    'STYCZNIA': 1,
    'LUTEGO': 2,
    'MARCA': 3,
    'KWIETNIA': 4,
    'MAJA': 5,
    'CZERWCA': 6,
    'LIPCA': 7,
    'SIERPNIA': 8,
    'WRZEŚNIA': 9,
    'PAŹDZIERNIKA': 10,
    'LISTOPADA': 11,
    'GRUDNIA': 12,
  };

  // German month names (nominative; not inflected in the date ranges,
  // e.g. "6.–12. Juli").
  static const _deMonths = {
    'JANUAR': 1,
    'FEBRUAR': 2,
    'MÄRZ': 3,
    'APRIL': 4,
    'MAI': 5,
    'JUNI': 6,
    'JULI': 7,
    'AUGUST': 8,
    'SEPTEMBER': 9,
    'OKTOBER': 10,
    'NOVEMBER': 11,
    'DEZEMBER': 12,
  };

  static final _numberedTitlePattern = RegExp(r'^\s*\d+\.\s*(.+)$');

  // "(10 min.)", "(Br. … 3 min.)", "(10 dk.)"; the digits directly before
  // the localized minutes abbreviation.
  // Opening paren (ASCII "(" or full-width "（" for Japanese), then the digits
  // before the localized minutes abbreviation ("min", "dk" or Japanese "分").
  static final _durationPattern = RegExp(
      r'[(（](?:\D{0,12}?)?(\d+)\s*(?:min|dk|分)',
      caseSensitive: false,
      unicode: true);

  static final _songPattern = RegExp(
      r'(?:SONG|PÍSEŇ|İLAHİ|CANCIÓN|CANTICO|CANTIQUE|CÂNTICO|PIEŚŃ|LIED|歌)\s*(?:Ç\.\s*|NR\.\s*)?(\d+)',
      caseSensitive: false);

  // Zero-width characters (ZWSP..ZWJ, BOM) that leak into extracted text.
  static final _invisiblePattern = RegExp('[\u200B-\u200D\uFEFF]');

  /// [fileName] (e.g. mwb_E_202607.epub) provides the issue year/month used
  /// to resolve week years; [now] is injectable for tests. [source] is
  /// recorded on the produced weeks ('epub' or 'cdn'). [songTitles], when
  /// given (a song number->title catalog), resolves parsed song numbers to
  /// their titles.
  static List<LmmWeek> parse(Uint8List bytes,
      {String? fileName,
      DateTime? now,
      String source = 'epub',
      Map<int, String>? songTitles}) {
    final archive = ZipDecoder().decodeBytes(bytes);
    (int, int)? issue;
    final m = RegExp(r'(20\d{2})(\d{2})').firstMatch(fileName ?? '');
    if (m != null) {
      issue = (int.parse(m.group(1)!), int.parse(m.group(2)!));
    }

    // Prefer the OPF spine (it excludes the "-extracted" reference files and
    // covers via linear="no"); fall back to every xhtml in the zip.
    final documents = _spineDocuments(archive) ??
        [
          for (final file in archive.files)
            if (file.isFile &&
                (file.name.toLowerCase().endsWith('.xhtml') ||
                    file.name.toLowerCase().endsWith('.html')) &&
                !file.name.toLowerCase().contains('-extracted'))
              file
        ];

    final weeks = <String, LmmWeek>{};
    for (final file in documents) {
      final String content;
      try {
        content = utf8.decode(file.content as List<int>);
      } on FormatException {
        continue;
      }
      final week = parseWeekDocument(content,
          issue: issue, now: now, source: source, songTitles: songTitles);
      if (week != null) weeks[week.id] = week;
    }
    final result = weeks.values.toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    return result;
  }

  /// Reading-order content documents from the epub package manifest/spine,
  /// or null when the epub has no usable OPF.
  static List<ArchiveFile>? _spineDocuments(Archive archive) {
    ArchiveFile? opf;
    for (final file in archive.files) {
      if (file.isFile && file.name.toLowerCase().endsWith('.opf')) {
        opf = file;
        break;
      }
    }
    if (opf == null) return null;
    final String content;
    try {
      content = utf8.decode(opf.content as List<int>);
    } on FormatException {
      return null;
    }

    // The html parser handles the OPF XML well enough for attribute lookups.
    final doc = html_parser.parse(content);
    final hrefById = <String, String>{};
    for (final item in doc.querySelectorAll('item')) {
      final id = item.attributes['id'];
      final href = item.attributes['href'];
      if (id != null &&
          href != null &&
          item.attributes['media-type'] == 'application/xhtml+xml') {
        hrefById[id] = href;
      }
    }

    final dirEnd = opf.name.lastIndexOf('/');
    final dir = dirEnd < 0 ? '' : opf.name.substring(0, dirEnd + 1);
    final byName = {
      for (final file in archive.files)
        if (file.isFile) file.name: file
    };
    final documents = <ArchiveFile>[];
    for (final ref in doc.querySelectorAll('itemref')) {
      if (ref.attributes['linear'] == 'no') continue;
      final href = hrefById[ref.attributes['idref']];
      if (href == null) continue;
      final file = byName['$dir$href'] ?? byName[href];
      if (file != null) documents.add(file);
    }
    return documents.isEmpty ? null : documents;
  }

  static String _normalize(String text) => text
      .replaceAll(_invisiblePattern, '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  // Uppercase for keyword matching that also folds the Turkish dotted capital
  // "İ" onto ASCII "I". `toUpperCase()` is locale independent, so a lowercase
  // "i" in a mixed-case source title ("Kitap İncelemesi") maps to a dotless
  // "I" while headings already spelled with "İ" keep the dot — comparisons
  // fold both sides so the dot no longer decides a match.
  static String _matchKey(String text) =>
      text.toUpperCase().replaceAll('İ', 'I');

  static final _letterPattern = RegExp(r'\p{L}', unicode: true);

  /// Whether the character at [i] in [s] is a Unicode letter (used for
  /// whole-word month matching in [_parseWeekStart]).
  static bool _isLetterAt(String s, int i) =>
      i >= 0 && i < s.length && _letterPattern.hasMatch(s[i]);

  /// Parses a single weekly XHTML document; returns null when the file is
  /// not a weekly program (toc, cover, …).
  static LmmWeek? parseWeekDocument(String content,
      {(int, int)? issue,
      DateTime? now,
      String source = 'epub',
      Map<int, String>? songTitles}) {
    final doc = html_parser.parse(content);
    final body = doc.body;
    if (body == null) return null;

    final elements = <dom.Element>[];
    final texts = <String>[];
    for (final el in body.querySelectorAll('h1,h2,h3,p,li')) {
      final text = _normalize(el.text);
      // Skip empties and the duplicate a nested <p> inside an <li> produces.
      if (text.isEmpty || (texts.isNotEmpty && texts.last == text)) continue;
      elements.add(el);
      texts.add(text);
    }
    if (elements.isEmpty) return null;

    final headline =
        _normalize(body.querySelector('h1')?.text ?? texts.first);
    final weekStart = _parseWeekStart(headline, issue: issue, now: now);

    const uuid = Uuid();
    final songs = <String>[];
    final parts = <LmmPart>[
      LmmPart(
          id: uuid.v4(),
          section: LmmSection.opening,
          type: LmmPartType.chairman),
      LmmPart(
          id: uuid.v4(),
          section: LmmSection.opening,
          type: LmmPartType.prayer),
    ];

    var section = LmmSection.treasures;
    var treasuresIndex = 0;
    var sawSectionHeading = false;
    String? scripture;

    for (var i = 0; i < elements.length; i++) {
      final el = elements[i];
      final text = texts[i];
      final tag = el.localName;
      final isHeading = tag == 'h1' || tag == 'h2' || tag == 'h3';

      final newSection = (tag == 'h2' ? _sectionFromClasses(el) : null) ??
          (isHeading ? _sectionFromText(text) : null);
      if (newSection != null) {
        section = newSection;
        sawSectionHeading = true;
        continue;
      }

      final numberedMatch =
          tag != 'h1' && tag != 'h2' ? _numberedTitlePattern.firstMatch(text) : null;
      if (numberedMatch == null) {
        // Song lines: standalone in the legacy format, combined with the
        // opening/concluding comments in the current one ("Song 1 and
        // Prayer | Opening Comments (1 min.)").
        final songMatch = _songPattern.firstMatch(text);
        if (songMatch != null && (isHeading || text.length < 40)) {
          songs.add(songMatch.group(1)!);
          continue;
        }
        // Weekly scripture: the plain h2 between the date h1 and the first
        // section heading, e.g. "JEREMIAH 49-50".
        if (tag == 'h2' && scripture == null && !sawSectionHeading) {
          scripture = text;
        }
        continue;
      }

      final rawTitle = numberedMatch.group(1)!;
      final String title;
      int? duration;
      var description = '';

      final inline = _durationPattern.firstMatch(rawTitle);
      if (inline != null) {
        // Legacy format: "1. Title (10 min.) …"
        title = rawTitle.substring(0, inline.start).trim();
        duration = int.parse(inline.group(1)!);
        final close = rawTitle.indexOf(')', inline.end);
        if (close >= 0) description = rawTitle.substring(close + 1).trim();
      } else {
        // Current format: duration + instructions live in the detail
        // paragraphs that follow the <h3> title, e.g.
        // "(4 min.) Jer 50:24-40 (th study 11)".
        title = rawTitle;
        for (var j = i + 1; j < elements.length; j++) {
          final detailTag = elements[j].localName;
          if (detailTag == 'h1' || detailTag == 'h2' || detailTag == 'h3') {
            break;
          }
          final m = _durationPattern.firstMatch(texts[j]);
          if (m == null) continue;
          duration = int.parse(m.group(1)!);
          final close = texts[j].indexOf(')', m.end);
          if (close >= 0) description = texts[j].substring(close + 1).trim();
          break;
        }
      }
      // Numbered lines without a timing anywhere (toc entries, list items)
      // are not program parts.
      if (duration == null) continue;

      final titleUpper = _matchKey(title);
      var type = switch (section) {
        LmmSection.ministry => LmmPartType.fieldMinistry,
        LmmSection.living => LmmPartType.living,
        _ => LmmPartType.treasures,
      };
      if (section == LmmSection.treasures) {
        if (titleUpper.contains('SPIRITUAL GEMS') ||
            titleUpper.contains('DUCHOVNÍCH DRAHOKAMŮ') ||
            titleUpper.contains('DUCHOVNÍ PERLY') ||
            titleUpper.contains('RUHSAL HAZINELER') ||
            titleUpper.contains('RUHI HAZINELER') ||
            titleUpper.contains('PERLAS ESCONDIDAS') ||
            titleUpper.contains('GEMME SPIRITUALI') ||
            titleUpper.contains('PERLES SPIRITUELLES') ||
            titleUpper.contains('JOIAS ESPIRITUAIS') ||
            titleUpper.contains('DUCHOWE SKARBY') ||
            titleUpper.contains('GEISTIGEN SCHÄTZEN') ||
            titleUpper.contains('宝石を探し出す')) {
          type = LmmPartType.gems;
        } else if (titleUpper.contains('BIBLE READING') ||
            titleUpper.contains('ČTENÍ BIBLE') ||
            titleUpper.contains('ČTENÍ Z BIBLE') ||
            titleUpper.contains('KUTSAL KITAP OKUMASI') ||
            titleUpper.contains('LECTURA DE LA BIBLIA') ||
            titleUpper.contains('LETTURA BIBLICA') ||
            titleUpper.contains('LECTURE DE LA BIBLE') ||
            titleUpper.contains('LEITURA DA BÍBLIA') ||
            titleUpper.contains('CZYTANIE BIBLII') ||
            titleUpper.contains('BIBELLESUNG') ||
            titleUpper.contains('聖書朗読')) {
          type = LmmPartType.bibleReading;
        } else if (treasuresIndex == 1) {
          type = LmmPartType.gems;
        } else if (treasuresIndex == 2) {
          type = LmmPartType.bibleReading;
        }
        treasuresIndex++;
      }
      if (section == LmmSection.living &&
          (titleUpper.contains('CONGREGATION BIBLE STUDY') ||
              titleUpper.contains('SBOROVÉ STUDIUM') ||
              titleUpper.contains('CEMAAT KUTSAL KITAP TETKIKI') ||
              titleUpper.contains('CEMAAT KUTSAL KITAP INCELEMESI') ||
              titleUpper.contains('CEMAAT KUTSAL KITAP') ||
              titleUpper.contains('ESTUDIO BÍBLICO DE LA CONGREGACIÓN') ||
              titleUpper.contains('STUDIO BIBLICO DI CONGREGAZIONE') ||
              titleUpper.contains('ÉTUDE BIBLIQUE DE L') ||
              titleUpper.contains('ESTUDO BÍBLICO DE CONGREGAÇÃO') ||
              titleUpper.contains('ZBOROWE STUDIUM BIBLII') ||
              titleUpper.contains('VERSAMMLUNGSBIBELSTUDIUM') ||
              titleUpper.contains('会衆の聖書研究'))) {
        type = LmmPartType.cbsConductor;
      }

      parts.add(LmmPart(
        id: uuid.v4(),
        section: section,
        type: type,
        title: title,
        description: description,
        durationMin: duration,
      ));
      if (type == LmmPartType.cbsConductor) {
        parts.add(LmmPart(
            id: uuid.v4(),
            section: LmmSection.living,
            type: LmmPartType.cbsReader));
      }
    }

    parts.add(LmmPart(
        id: uuid.v4(),
        section: LmmSection.closing,
        type: LmmPartType.prayer));

    // A real weekly program has section headings, several numbered parts
    // and a parsable date.
    final numberedParts = parts
        .where((p) =>
            p.type != LmmPartType.chairman &&
            p.type != LmmPartType.prayer &&
            p.type != LmmPartType.cbsReader)
        .length;
    if (!sawSectionHeading || numberedParts < 3 || weekStart == null) {
      return null;
    }

    var weekLabel = headline;
    if (scripture != null && !headline.contains('|')) {
      weekLabel = '$headline | $scripture';
    }

    // The three songs appear in document order: opening (before Treasures),
    // the Living-as-Christians song, then the closing song. Missing ones stay
    // null/empty. Titles resolve from [songTitles] when available.
    int? songNoAt(int i) =>
        i < songs.length ? int.tryParse(songs[i]) : null;
    String titleAt(int i) {
      final no = songNoAt(i);
      return no == null ? '' : (songTitles?[no] ?? '');
    }

    return LmmWeek(
      id: dateKey(mondayOf(weekStart)),
      weekLabel: weekLabel,
      openingSongNo: songNoAt(0),
      openingSongTitle: titleAt(0),
      livingSongNo: songNoAt(1),
      livingSongTitle: titleAt(1),
      closingSongNo: songNoAt(2),
      closingSongTitle: titleAt(2),
      source: source,
      parts: parts,
    );
  }

  /// Language-independent section detection: the section h2 sits inside a
  /// wrapper div carrying the section's icon class.
  static LmmSection? _sectionFromClasses(dom.Element el) {
    dom.Element? node = el;
    for (var depth = 0; depth < 4 && node != null; depth++) {
      final classes = node.className;
      if (classes.contains('dc-icon--gem')) return LmmSection.treasures;
      if (classes.contains('dc-icon--wheat')) return LmmSection.ministry;
      if (classes.contains('dc-icon--sheep')) return LmmSection.living;
      node = node.parent;
    }
    return null;
  }

  static LmmSection? _sectionFromText(String text) {
    final upper = _matchKey(text);
    if (upper.contains('POKLADY Z BOŽÍHO') ||
        upper.contains('TREASURES FROM') ||
        upper.contains('TANRI’NIN SÖZÜNDEKI HAZINELER') ||
        upper.contains("TANRI'NIN SÖZÜNDEKI HAZINELER") ||
        upper.contains('TESOROS DE LA BIBLIA') ||
        upper.contains('TESORI DELLA PAROLA DI DIO') ||
        upper.contains('JOYAUX DE LA PAROLE DE DIEU') ||
        upper.contains('TESOUROS DA PALAVRA DE DEUS') ||
        upper.contains('SKARBY ZE SŁOWA BOŻEGO') ||
        upper.contains('SCHÄTZE AUS GOTTES WORT') ||
        upper.contains('神の言葉の宝')) {
      return LmmSection.treasures;
    }
    if (upper.contains('FIELD MINISTRY') ||
        upper.contains('VE SLUŽBĚ') ||
        upper.contains('TARLA HIZMETINDE') ||
        upper.contains('HIZMETTE BECERILERIMIZI') ||
        upper.contains('SEAMOS MEJORES MAESTROS') ||
        upper.contains('EFFICACI NEL MINISTERO') ||
        upper.contains('APPLIQUE-TOI AU MINISTÈRE') ||
        upper.contains('FAÇA SEU MELHOR NO MINISTÉRIO') ||
        upper.contains('ULEPSZAJMY SWOJĄ SŁUŻBĘ') ||
        upper.contains('UNS IM DIENST VERBESSERN') ||
        upper.contains('野外奉仕に励む')) {
      return LmmSection.ministry;
    }
    if (upper.contains('LIVING AS CHRISTIANS') ||
        upper.contains('ŽIVOT KŘESŤANA') ||
        upper.contains('KŘESŤANSKÝ ŽIVOT') ||
        upper.contains('HIRISTIYANLAR OLARAK') ||
        upper.contains('HIRISTIYANCA YAŞAM') ||
        upper.contains('NUESTRA VIDA CRISTIANA') ||
        upper.contains('VITA CRISTIANA') ||
        upper.contains('VIE CHRÉTIENNE') ||
        upper.contains('NOSSA VIDA CRISTÃ') ||
        upper.contains('CHRZEŚCIJAŃSKI TRYB ŻYCIA') ||
        upper.contains('UNSER LEBEN ALS CHRIST') ||
        upper.contains('クリスチャンとして生活する')) {
      return LmmSection.living;
    }
    return null;
  }

  /// Parses the start date out of headings like "JULY 7-13", "JUNE 30–JULY 6",
  /// "7.–13. ČERVENCE", "30. ČERVNA – 6. ČERVENCE | ŽALM 45" or
  /// "DECEMBER 28, 2026–JANUARY 3, 2027".
  static DateTime? _parseWeekStart(String headline,
      {(int, int)? issue, DateTime? now}) {
    final upper = headline.toUpperCase();

    // Japanese: "7月6～12日" / "2026年7月6日〜12日" — the month precedes 月 and
    // the day is the first number after it (a different order from the
    // Latin/day-first logic below).
    final jpMonthMatch = RegExp(r'(\d{1,2})\s*月').firstMatch(headline);
    if (jpMonthMatch != null) {
      final jpMonth = int.parse(jpMonthMatch.group(1)!);
      final jpDayMatch =
          RegExp(r'(\d{1,2})').firstMatch(headline.substring(jpMonthMatch.end));
      if (jpMonth >= 1 && jpMonth <= 12 && jpDayMatch != null) {
        final jpDay = int.parse(jpDayMatch.group(1)!);
        if (jpDay >= 1 && jpDay <= 31) {
          return DateTime(
              _resolveYear(jpMonth, jpDay, upper, issue, now), jpMonth, jpDay);
        }
      }
    }

    // First 1-2 digit number that is not part of a longer number (skips the
    // digits of explicit years like "2026").
    final dayMatch = RegExp(r'(?<!\d)(\d{1,2})(?!\d)').firstMatch(upper);
    if (dayMatch == null) return null;
    final day = int.parse(dayMatch.group(1)!);
    if (day < 1 || day > 31) return null;

    // Month token belonging to that day. English puts the month before the
    // day ("JULY 6"), Czech after it ("6. ČERVENCE"), so tokens on the wrong
    // side are heavily penalized — that keeps "DECEMBER 29–JANUARY 4" in
    // December instead of January.
    int? month;
    var bestScore = 1 << 30;
    for (final (months, monthComesFirst) in [
      (_enMonths, true),
      (_csMonths, false),
      (_trMonths, false),
      (_esMonths, false),
      (_itMonths, false),
      (_frMonths, false),
      (_ptMonths, false),
      (_plMonths, false),
      (_deMonths, false),
    ]) {
      for (final entry in months.entries) {
        var idx = upper.indexOf(entry.key);
        while (idx >= 0) {
          // Match only whole words: a month name must not be a fragment of a
          // longer word. Without this, e.g. German "JANUAR" would match inside
          // English "JANUARY" and hijack the rollover-week disambiguation.
          final end = idx + entry.key.length;
          final boundedBefore = idx == 0 || !_isLetterAt(upper, idx - 1);
          final boundedAfter = end >= upper.length || !_isLetterAt(upper, end);
          if (boundedBefore && boundedAfter) {
            final onExpectedSide =
                monthComesFirst ? idx < dayMatch.start : idx > dayMatch.start;
            final score =
                (idx - dayMatch.start).abs() + (onExpectedSide ? 0 : 1000);
            if (score < bestScore) {
              bestScore = score;
              month = entry.value;
            }
          }
          idx = upper.indexOf(entry.key, idx + 1);
        }
      }
    }
    if (month == null) return null;

    return DateTime(_resolveYear(month, day, upper, issue, now), month, day);
  }

  /// Resolves the calendar year of a week given its [month]/[day]: an explicit
  /// year in the [upper]-cased heading wins; otherwise the workbook [issue]
  /// month (handling December↔January rollover); otherwise the year that puts
  /// the week closest to [now].
  static int _resolveYear(
      int month, int day, String upper, (int, int)? issue, DateTime? now) {
    final explicitYear = RegExp(r'20\d{2}').firstMatch(upper);
    if (explicitYear != null) {
      // Year-rollover weeks spell the years out, first one first:
      // "DECEMBER 28, 2026–JANUARY 3, 2027".
      return int.parse(explicitYear.group(0)!);
    }
    if (issue != null) {
      var year = issue.$1;
      // December issues contain January weeks (and vice versa at rollover).
      if (issue.$2 >= 11 && month <= 2) year++;
      if (issue.$2 <= 2 && month >= 11) year--;
      return year;
    }
    // Pick the year that puts the week closest to today.
    final reference = now ?? DateTime.now();
    var year = reference.year;
    var best = const Duration(days: 1 << 20);
    for (final candidate in [year - 1, year, year + 1]) {
      final d = DateTime(candidate, month, day);
      final distance = d.difference(reference).abs();
      if (distance < best) {
        best = distance;
        year = candidate;
      }
    }
    return year;
  }
}
