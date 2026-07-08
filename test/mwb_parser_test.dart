import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/lmm_schedule/epub_import/mwb_parser.dart';
import 'package:flutter_test/flutter_test.dart';

const _enWeek = '''
<html><body>
<h1>JULY 6-12 | PSALM 45</h1>
<p>SONG 1 and Prayer</p>
<h2>TREASURES FROM GOD'S WORD</h2>
<p>1. Jehovah Blesses His King (10 min.)</p>
<p>2. Spiritual Gems (10 min.)</p>
<p>3. Bible Reading (4 min.)</p>
<h2>APPLY YOURSELF TO THE FIELD MINISTRY</h2>
<p>4. Starting a Conversation (3 min.)</p>
<p>5. Following Up (4 min.)</p>
<p>6. Talk (5 min.)</p>
<h2>LIVING AS CHRISTIANS</h2>
<p>SONG 22</p>
<p>7. Local Needs (15 min.)</p>
<p>8. Congregation Bible Study (30 min.)</p>
<p>SONG 33 and Prayer</p>
</body></html>
''';

const _csWeek = '''
<html><body>
<h1>6.–12. ČERVENCE | ŽALM 45</h1>
<p>PÍSEŇ 1 a modlitba</p>
<h2>POKLADY Z BOŽÍHO SLOVA</h2>
<p>1. Jehova žehná svému králi (10 min.)</p>
<p>2. Duchovní perly (10 min.)</p>
<p>3. Čtení Bible (4 min.)</p>
<h2>ROZVÍJEJME SE VE SLUŽBĚ</h2>
<p>4. Zahájení rozhovoru (3 min.)</p>
<h2>KŘESŤANSKÝ ŽIVOT</h2>
<p>PÍSEŇ 22</p>
<p>5. Sborové studium Bible (30 min.)</p>
<p>PÍSEŇ 33 a modlitba</p>
</body></html>
''';

void main() {
  group('MwbParser.parseWeekDocument', () {
    test('parses an English week', () {
      final week =
          MwbParser.parseWeekDocument(_enWeek, issue: (2026, 7));
      expect(week, isNotNull);
      expect(week!.id, '2026-07-06');
      expect(week.songs, ['1', '22', '33']);
      expect(week.source, 'epub');

      final types = week.parts.map((p) => p.type).toList();
      expect(
          types,
          containsAllInOrder([
            LmmPartType.chairman,
            LmmPartType.prayer,
            LmmPartType.treasures,
            LmmPartType.gems,
            LmmPartType.bibleReading,
            LmmPartType.fieldMinistry,
            LmmPartType.living,
            LmmPartType.cbsConductor,
            LmmPartType.cbsReader,
            LmmPartType.prayer,
          ]));
      expect(
          week.parts
              .where((p) => p.type == LmmPartType.fieldMinistry)
              .length,
          3);
      final treasuresTalk = week.parts
          .firstWhere((p) => p.type == LmmPartType.treasures);
      expect(treasuresTalk.title, 'Jehovah Blesses His King');
      expect(treasuresTalk.durationMin, 10);
    });

    test('parses a Czech week', () {
      final week =
          MwbParser.parseWeekDocument(_csWeek, issue: (2026, 7));
      expect(week, isNotNull);
      expect(week!.id, '2026-07-06');
      expect(week.songs, ['1', '22', '33']);
      expect(
          week.parts.any((p) =>
              p.type == LmmPartType.cbsConductor &&
              p.title == 'Sborové studium Bible'),
          isTrue);
      expect(
          week.parts.any((p) => p.type == LmmPartType.gems), isTrue);
      expect(week.parts.any((p) => p.type == LmmPartType.bibleReading),
          isTrue);
    });

    test('resolves January weeks in a December issue to the next year', () {
      final html = _enWeek.replaceFirst(
          'JULY 6-12 | PSALM 45', 'DECEMBER 29–JANUARY 4');
      final week = MwbParser.parseWeekDocument(html, issue: (2026, 11));
      expect(week, isNotNull);
      // Start day December 29, 2026 — a Tuesday; snaps to Monday 2026-12-28.
      expect(week!.id, '2026-12-28');
    });

    test('rejects non-week documents', () {
      const toc = '''
<html><body><h1>Table of Contents</h1>
<p>July 6-12</p><p>July 13-19</p></body></html>
''';
      expect(MwbParser.parseWeekDocument(toc, issue: (2026, 7)), isNull);
    });
  });

  group('MwbParser.parse (epub zip)', () {
    test('extracts weeks from OEBPS xhtml files, sorted and deduped', () {
      final archive = Archive();
      void add(String name, String content) {
        final bytes = utf8.encode(content);
        archive.addFile(ArchiveFile(name, bytes.length, bytes));
      }

      add('OEBPS/week2.xhtml',
          _enWeek.replaceFirst('JULY 6-12', 'JULY 13-19'));
      add('OEBPS/week1.xhtml', _enWeek);
      add('OEBPS/toc.xhtml',
          '<html><body><h1>Contents</h1></body></html>');
      add('mimetype', 'application/epub+zip');

      final zipped = ZipEncoder().encode(archive);
      final weeks = MwbParser.parse(Uint8List.fromList(zipped),
          fileName: 'mwb_E_202607.epub');
      expect(weeks.map((w) => w.id).toList(),
          ['2026-07-06', '2026-07-13']);
    });
  });
}
