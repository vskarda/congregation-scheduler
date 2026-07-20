import 'dart:convert';
import 'dart:io';
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
<p>2. Hledání duchovních drahokamů (10 min.)</p>
<p>3. Čtení Bible (4 min.)</p>
<h2>ZLEPŠUJ SE VE SLUŽBĚ</h2>
<p>4. Zahájení rozhovoru (3 min.)</p>
<h2>ŽIVOT KŘESŤANA</h2>
<p>PÍSEŇ 22</p>
<p>5. Sborové studium Bible (30 min.)</p>
<p>PÍSEŇ 33 a modlitba</p>
</body></html>
''';

const _trWeek = '''
<html><body>
<h1>6-12 TEMMUZ | MEZMUR 45</h1>
<p>İLAHİ 1 ve dua</p>
<h2>TANRI’NIN SÖZÜNDEKİ HAZİNELER</h2>
<p>1. Yehova Kralını Bereketler (10 dk.)</p>
<p>2. Ruhi Hazineler (10 dk.)</p>
<p>3. Kutsal Kitap Okuması (4 dk.)</p>
<h2>HİZMETTE BECERİLERİMİZİ GELİŞTİRELİM</h2>
<p>4. Sohbete Başlama (3 dk.)</p>
<h2>HIRİSTİYANCA YAŞAM</h2>
<p>İLAHİ 22</p>
<p>5. Cemaat Kutsal Kitap İncelemesi (30 dk.)</p>
<p>İLAHİ 33 ve dua</p>
</body></html>
''';

/// Sanitized replica of the 2024+ workbook markup (mwb_E_202611): part
/// titles in <h3>, duration + instructions in the following detail
/// paragraph, sections marked by dc-icon-- wrapper classes.
const _enWeek2026 = '''
<html><body class="jwac dir-ltr ml-E pub-mwb docId-202026401">
<article>
<h1 id="p1"><span>NOVEMBER 2-8</span></h1>
<h2 id="p2">JEREMIAH 49-50</h2>
<div class="bodyTxt">
<h3 class="dc-icon--music du-fontSize--base" id="p3">Song 1 and Prayer | Opening Comments (1 min.)</h3>
<div id="tt7" class="du-fontSize--basePlus2 dc-icon--gem dc-icon-layout--top">
<h2 class="du-color--teal-700" id="p4">TREASURES FROM GOD’S WORD</h2>
</div>
<div id="tt9" class="du-bgColor--bgSecondary">
<h3 class="du-color--teal-700" id="p5">1. Help Others Benefit From Jehovah’s Mercy</h3>
<div id="tt11"><div id="tt12">
<p id="p6">(10 min.)</p>
<p id="p7">Jehovah rightly condemned Babylon (Jer 50:14, 29, 31)</p>
</div></div>
<h3 class="du-color--teal-700" id="p10">2. Spiritual Gems</h3>
<div id="tt14"><div id="tt15">
<p id="p11">(10 min.)</p>
<ul><li><p id="p12">Jer 50:24—In what way did Jehovah catch Babylon in a “snare”?</p></li></ul>
</div></div>
<h3 class="du-color--teal-700" id="p16">3. Bible Reading</h3>
<div id="tt28">
<p id="p17">(4 min.) Jer 50:24-40 (th study 11)</p>
</div>
</div>
<div id="tt29" class="dc-icon--wheat dc-icon-layout--top">
<h2 class="du-color--gold-700" id="p18">APPLY YOURSELF TO THE FIELD MINISTRY</h2>
</div>
<h3 class="du-color--gold-700" id="p19">4. Starting a Conversation</h3>
<div id="tt32"><p id="p20">(3 min.) HOUSE TO HOUSE. Share a Bible truth. (lmd lesson 1 point 5)</p></div>
<h3 class="du-color--gold-700" id="p21">5. Following Up</h3>
<div id="tt34"><p id="p22">(4 min.) HOUSE TO HOUSE. (lmd lesson 9 point 3)</p></div>
<h3 class="du-color--gold-700" id="p23">6. Making Disciples</h3>
<div id="tt36"><p id="p24">(5 min.) lff lesson 20 point 4 (lmd lesson 11 point 4)</p></div>
<div id="tt37" class="dc-icon--sheep dc-icon-layout--top">
<h2 class="du-color--maroon-600" id="p25">LIVING AS CHRISTIANS</h2>
</div>
<h3 class="dc-icon--music" id="p26">Song 44</h3>
<h3 class="du-color--maroon-600" id="p27">7. Never Forget What Jehovah Remembers</h3>
<div id="tt42"><div id="tt43">
<p id="p28">(15 min.) Discussion.</p>
<p id="p29">Play the VIDEO. Then ask the audience:</p>
</div></div>
<h3 class="du-color--maroon-600" id="p32">8. Congregation Bible Study</h3>
<div id="tt52"><p id="p33">(30 min.) wcg chap. 15</p></div>
<h3 id="p34">Concluding Comments (3 min.) | Song 33 and Prayer</h3>
</div>
</article>
</body></html>
''';

void main() {
  group('MwbParser.parseWeekDocument (legacy inline format)', () {
    test('parses an English week', () {
      final week =
          MwbParser.parseWeekDocument(_enWeek, issue: (2026, 7));
      expect(week, isNotNull);
      expect(week!.id, '2026-07-06');
      expect(week.openingSongNo, 1);
      expect(week.livingSongNo, 22);
      expect(week.closingSongNo, 33);
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
      expect(week.openingSongNo, 1);
      expect(week.livingSongNo, 22);
      expect(week.closingSongNo, 33);
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

    test('parses a Turkish week', () {
      final week =
          MwbParser.parseWeekDocument(_trWeek, issue: (2026, 7));
      expect(week, isNotNull);
      expect(week!.id, '2026-07-06');
      expect(week.openingSongNo, 1);
      expect(week.livingSongNo, 22);
      expect(week.closingSongNo, 33);
      expect(
          week.parts.map((part) => part.type),
          containsAll([
            LmmPartType.gems,
            LmmPartType.bibleReading,
            LmmPartType.fieldMinistry,
            LmmPartType.cbsConductor,
          ]));
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

    test('resolves song titles from the provided catalog', () {
      final week = MwbParser.parseWeekDocument(_enWeek,
          issue: (2026, 7),
          songTitles: {1: 'Opening Song', 33: 'Closing Song'});
      expect(week, isNotNull);
      expect(week!.openingSongNo, 1);
      expect(week.openingSongTitle, 'Opening Song');
      // Number present but absent from the catalog stays untitled.
      expect(week.livingSongNo, 22);
      expect(week.livingSongTitle, '');
      expect(week.closingSongNo, 33);
      expect(week.closingSongTitle, 'Closing Song');
    });
  });

  group('MwbParser.parseWeekDocument (2024+ format)', () {
    test('parses a full week with detail paragraphs', () {
      final week =
          MwbParser.parseWeekDocument(_enWeek2026, issue: (2026, 11));
      expect(week, isNotNull);
      expect(week!.id, '2026-11-02');
      expect(week.weekLabel, 'NOVEMBER 2-8 | JEREMIAH 49-50');
      expect(week.openingSongNo, 1);
      expect(week.livingSongNo, 44);
      expect(week.closingSongNo, 33);

      expect(week.parts.map((p) => p.type).toList(), [
        LmmPartType.chairman,
        LmmPartType.prayer,
        LmmPartType.treasures,
        LmmPartType.gems,
        LmmPartType.bibleReading,
        LmmPartType.fieldMinistry,
        LmmPartType.fieldMinistry,
        LmmPartType.fieldMinistry,
        LmmPartType.living,
        LmmPartType.cbsConductor,
        LmmPartType.cbsReader,
        LmmPartType.prayer,
      ]);

      final treasures = week.parts
          .firstWhere((p) => p.type == LmmPartType.treasures);
      expect(treasures.title, 'Help Others Benefit From Jehovah’s Mercy');
      expect(treasures.durationMin, 10);
      expect(treasures.description, '');

      final reading = week.parts
          .firstWhere((p) => p.type == LmmPartType.bibleReading);
      expect(reading.durationMin, 4);
      expect(reading.description, 'Jer 50:24-40 (th study 11)');

      final demos = week.parts
          .where((p) => p.type == LmmPartType.fieldMinistry)
          .toList();
      expect(demos.map((p) => p.durationMin), [3, 4, 5]);
      expect(demos.first.description,
          'HOUSE TO HOUSE. Share a Bible truth. (lmd lesson 1 point 5)');

      final cbs = week.parts
          .firstWhere((p) => p.type == LmmPartType.cbsConductor);
      expect(cbs.durationMin, 30);
      expect(cbs.description, 'wcg chap. 15');
    });

    test('detects sections from icon classes when headings are unknown', () {
      final html = _enWeek2026
          .replaceFirst('TREASURES FROM GOD’S WORD', 'SCHÄTZE AUS GOTTES WORT')
          .replaceFirst(
              'APPLY YOURSELF TO THE FIELD MINISTRY', 'UNS IM DIENST VERBESSERN')
          .replaceFirst('LIVING AS CHRISTIANS', 'UNSER LEBEN ALS CHRIST');
      final week = MwbParser.parseWeekDocument(html, issue: (2026, 11));
      expect(week, isNotNull);
      expect(
          week!.parts
              .where((p) => p.type == LmmPartType.fieldMinistry)
              .length,
          3);
      expect(
          week.parts
              .where((p) => p.section == LmmSection.living)
              .map((p) => p.type),
          contains(LmmPartType.cbsConductor));
    });

    test('uses explicit years in rollover headings', () {
      final html = _enWeek2026.replaceFirst(
          'NOVEMBER 2-8', 'DECEMBER 28, 2026–JANUARY 3, 2027');
      // No issue/fileName available at all.
      final week = MwbParser.parseWeekDocument(html);
      expect(week, isNotNull);
      expect(week!.id, '2026-12-28');
    });
  });

  group('MwbParser.parse (epub zip)', () {
    Uint8List zip(Map<String, String> entries) {
      final archive = Archive();
      entries.forEach((name, content) {
        final bytes = utf8.encode(content);
        archive.addFile(ArchiveFile(name, bytes.length, bytes));
      });
      return Uint8List.fromList(ZipEncoder().encode(archive));
    }

    test('extracts weeks from OEBPS xhtml files, sorted and deduped', () {
      final bytes = zip({
        'OEBPS/week2.xhtml':
            _enWeek.replaceFirst('JULY 6-12', 'JULY 13-19'),
        'OEBPS/week1.xhtml': _enWeek,
        'OEBPS/toc.xhtml': '<html><body><h1>Contents</h1></body></html>',
        'mimetype': 'application/epub+zip',
      });
      final weeks = MwbParser.parse(bytes, fileName: 'mwb_E_202607.epub');
      expect(weeks.map((w) => w.id).toList(),
          ['2026-07-06', '2026-07-13']);
    });

    test('honors the OPF spine and skips non-linear documents', () {
      const opf = '''
<?xml version="1.0"?>
<package xmlns="http://www.idpf.org/2007/opf">
<manifest>
<item id="week1" href="202026401.xhtml" media-type="application/xhtml+xml"/>
<item id="extracted" href="202026401-extracted.xhtml" media-type="application/xhtml+xml"/>
</manifest>
<spine>
<itemref idref="week1"/>
<itemref idref="extracted" linear="no"/>
</spine>
</package>
''';
      final bytes = zip({
        'mimetype': 'application/epub+zip',
        'OEBPS/content.opf': opf,
        'OEBPS/202026401.xhtml': _enWeek2026,
        // Would parse as a different week if it were not spine-excluded.
        'OEBPS/202026401-extracted.xhtml':
            _enWeek2026.replaceFirst('NOVEMBER 2-8', 'NOVEMBER 9-15'),
      });
      final weeks = MwbParser.parse(bytes, fileName: 'mwb_E_202611.epub');
      expect(weeks.map((w) => w.id).toList(), ['2026-11-02']);
    });

    test('records the requested source', () {
      final bytes = zip({'OEBPS/week1.xhtml': _enWeek});
      final weeks = MwbParser.parse(bytes,
          fileName: 'mwb_E_202607.epub', source: 'cdn');
      expect(weeks.single.source, 'cdn');
    });
  });

  group('real workbook epub', () {
    final epub = File('mwb_E_202611.epub');

    test('parses all nine weeks of mwb_E_202611', () {
      final weeks = MwbParser.parse(
          Uint8List.fromList(epub.readAsBytesSync()),
          fileName: 'mwb_E_202611.epub');
      expect(weeks.map((w) => w.id).toList(), [
        '2026-11-02',
        '2026-11-09',
        '2026-11-16',
        '2026-11-23',
        '2026-11-30',
        '2026-12-07',
        '2026-12-14',
        '2026-12-21',
        '2026-12-28',
      ]);
      for (final week in weeks) {
        expect(week.openingSongNo, isNotNull, reason: week.id);
        expect(week.livingSongNo, isNotNull, reason: week.id);
        expect(week.closingSongNo, isNotNull, reason: week.id);
        expect(week.weekLabel, contains('|'), reason: week.id);
        expect(week.parts.length, greaterThanOrEqualTo(10),
            reason: week.id);
        final demos = week.parts
            .where((p) => p.type == LmmPartType.fieldMinistry)
            .toList();
        expect(demos, isNotEmpty, reason: week.id);
        for (final demo in demos) {
          expect(demo.durationMin, isNotNull, reason: week.id);
          expect(demo.description, isNotEmpty, reason: week.id);
        }
        expect(
            week.parts.any((p) => p.type == LmmPartType.cbsConductor),
            isTrue,
            reason: week.id);
      }
    }, skip: File('mwb_E_202611.epub').existsSync()
        ? false
        : 'mwb_E_202611.epub not present in the repo root');
  });
}
