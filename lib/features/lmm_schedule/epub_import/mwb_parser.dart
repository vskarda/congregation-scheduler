import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:uuid/uuid.dart';

import '../../../core/models/models.dart';
import '../../../core/utils/dates.dart';

/// Heuristic parser for the Meeting Workbook (mwb) epub. Extracts one
/// [LmmWeek] per weekly program file: date range, songs, and the numbered
/// parts with durations, mapped onto sections and part types.
///
/// Supported publication languages: English (mwb_E_*) and Czech (mwb_B_*).
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

  static final _partPattern =
      RegExp(r'^\s*\d+\.\s*(.+?)\s*\((?:\D{0,12}?)?(\d+)\s*min', unicode: true);

  static final _songPattern =
      RegExp(r'(?:SONG|PÍSEŇ)\s*(?:Č\.\s*)?(\d+)', caseSensitive: false);

  /// [fileName] (e.g. mwb_E_202607.epub) provides the issue year/month used
  /// to resolve week years; [now] is injectable for tests.
  static List<LmmWeek> parse(Uint8List bytes,
      {String? fileName, DateTime? now}) {
    final archive = ZipDecoder().decodeBytes(bytes);
    (int, int)? issue;
    final m = RegExp(r'(20\d{2})(\d{2})').firstMatch(fileName ?? '');
    if (m != null) {
      issue = (int.parse(m.group(1)!), int.parse(m.group(2)!));
    }

    final weeks = <String, LmmWeek>{};
    for (final file in archive.files) {
      if (!file.isFile) continue;
      final name = file.name.toLowerCase();
      if (!name.endsWith('.xhtml') && !name.endsWith('.html')) continue;
      final String content;
      try {
        content = utf8.decode(file.content as List<int>);
      } on FormatException {
        continue;
      }
      final week = parseWeekDocument(content, issue: issue, now: now);
      if (week != null) weeks[week.id] = week;
    }
    final result = weeks.values.toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    return result;
  }

  /// Parses a single weekly XHTML document; returns null when the file is
  /// not a weekly program (toc, cover, …).
  static LmmWeek? parseWeekDocument(String content,
      {(int, int)? issue, DateTime? now}) {
    final doc = html_parser.parse(content);
    final body = doc.body;
    if (body == null) return null;

    final blocks = <String>[];
    for (final el in body.querySelectorAll('h1,h2,h3,p,li')) {
      final text = el.text.replaceAll(RegExp(r'\s+'), ' ').trim();
      if (text.isNotEmpty && (blocks.isEmpty || blocks.last != text)) {
        blocks.add(text);
      }
    }
    if (blocks.isEmpty) return null;

    final headline = body.querySelector('h1')?.text.trim() ?? blocks.first;
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

    for (final text in blocks) {
      final upper = text.toUpperCase();
      if (upper.contains('POKLADY Z BOŽÍHO') ||
          upper.contains('TREASURES FROM')) {
        section = LmmSection.treasures;
        sawSectionHeading = true;
        continue;
      }
      if (upper.contains('FIELD MINISTRY') ||
          upper.contains('VE SLUŽBĚ')) {
        section = LmmSection.ministry;
        sawSectionHeading = true;
        continue;
      }
      if (upper.contains('LIVING AS CHRISTIANS') ||
          upper.contains('KŘESŤANSKÝ ŽIVOT')) {
        section = LmmSection.living;
        sawSectionHeading = true;
        continue;
      }

      final songMatch = _songPattern.firstMatch(text);
      if (songMatch != null && text.length < 40) {
        songs.add(songMatch.group(1)!);
        continue;
      }

      final partMatch = _partPattern.firstMatch(text);
      if (partMatch == null) continue;
      final title = partMatch.group(1)!;
      final duration = int.parse(partMatch.group(2)!);
      final titleUpper = title.toUpperCase();

      var type = switch (section) {
        LmmSection.ministry => LmmPartType.fieldMinistry,
        LmmSection.living => LmmPartType.living,
        _ => LmmPartType.treasures,
      };
      if (section == LmmSection.treasures) {
        if (titleUpper.contains('SPIRITUAL GEMS') ||
            titleUpper.contains('DUCHOVNÍ PERLY')) {
          type = LmmPartType.gems;
        } else if (titleUpper.contains('BIBLE READING') ||
            titleUpper.contains('ČTENÍ BIBLE') ||
            titleUpper.contains('ČTENÍ Z BIBLE')) {
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
              titleUpper.contains('SBOROVÉ STUDIUM'))) {
        type = LmmPartType.cbsConductor;
      }

      parts.add(LmmPart(
        id: uuid.v4(),
        section: section,
        type: type,
        title: title,
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

    return LmmWeek(
      id: dateKey(mondayOf(weekStart)),
      weekLabel: headline,
      songs: songs,
      source: 'epub',
      parts: parts,
    );
  }

  /// Parses the start date out of headings like "JULY 7-13", "JUNE 30–JULY 6",
  /// "7.–13. ČERVENCE" or "30. ČERVNA – 6. ČERVENCE | ŽALM 45".
  static DateTime? _parseWeekStart(String headline,
      {(int, int)? issue, DateTime? now}) {
    final upper = headline.toUpperCase();

    // First day number in the text.
    final dayMatch = RegExp(r'(\d{1,2})').firstMatch(upper);
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
    ]) {
      for (final entry in months.entries) {
        var idx = upper.indexOf(entry.key);
        while (idx >= 0) {
          final onExpectedSide =
              monthComesFirst ? idx < dayMatch.start : idx > dayMatch.start;
          final score =
              (idx - dayMatch.start).abs() + (onExpectedSide ? 0 : 1000);
          if (score < bestScore) {
            bestScore = score;
            month = entry.value;
          }
          idx = upper.indexOf(entry.key, idx + 1);
        }
      }
    }
    if (month == null) return null;

    int year;
    if (issue != null) {
      year = issue.$1;
      // December issues contain January weeks (and vice versa at rollover).
      if (issue.$2 >= 11 && month <= 2) year++;
      if (issue.$2 <= 2 && month >= 11) year--;
    } else {
      // Pick the year that puts the week closest to today.
      final reference = now ?? DateTime.now();
      year = reference.year;
      var best = const Duration(days: 1 << 20);
      for (final candidate in [year - 1, year, year + 1]) {
        final d = DateTime(candidate, month, day);
        final distance = d.difference(reference).abs();
        if (distance < best) {
          best = distance;
          year = candidate;
        }
      }
    }
    return DateTime(year, month, day);
  }
}
