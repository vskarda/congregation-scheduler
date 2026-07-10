import 'dart:io';

import 'package:congregation_scheduler/features/weekend_schedule/talk_catalog/s99_parser.dart';
import 'package:flutter_test/flutter_test.dart';

/// Generated filler entries so fixtures pass the >= 20 entries sanity guard.
String _entries(int from, int to) => [
      for (var n = from; n <= to; n++) '$n. Sample Talk Title $n       ',
    ].join('\n');

final _enPage1 = '''
S-99-E  2/26
Public Talk Titles
The following is a list of approved talk titles. The columns at the right may be used to keep
a record of the dates when talks are delivered in your congregation. This is for congregation
use only.
 Year:

1. How Well Do You Know God?
2. Will You Be a Survivor of the Last Days?
3. Move Ahead With Jehovah’s Unified
Organization
4. Evidence of God in the World Around Us
${_entries(5, 15)}''';

final _enPage2 = '''
S-99-E  2/26 2
 Year:

16. Ruining the Earth Brings Divine
Retribution
${_entries(17, 30)}''';

final _csPage = '''
S-99-B  2/26
Náměty veřejných přednášek
Následuje seznam schválených námětů.
 Rok:
1. Jak dobře znáš Boha?
2. Přežiješ poslední dny?​
3. Proč si vážit místa v Jehovově
organizaci?
${_entries(4, 24)}''';

void main() {
  group('S99Parser', () {
    test('parses two English pages with wrapped titles', () {
      final titles = S99Parser.parse([_enPage1, _enPage2]);
      expect(titles.length, 30);
      expect(titles[1], 'How Well Do You Know God?');
      expect(titles[3], 'Move Ahead With Jehovah’s Unified Organization');
      expect(titles[16], 'Ruining the Earth Brings Divine Retribution');
      expect(titles[30], 'Sample Talk Title 30');
    });

    test('page headers and year rows never leak into titles', () {
      final titles = S99Parser.parse([_enPage1, _enPage2]);
      for (final title in titles.values) {
        expect(title.contains('S-99'), isFalse);
        expect(title.contains('Year:'), isFalse);
      }
      // Last entry of page 1 stays clean despite page 2's leading rows.
      expect(titles[15], 'Sample Talk Title 15');
    });

    test('parses Czech text with diacritics and strips invisible chars', () {
      final titles = S99Parser.parse([_csPage]);
      expect(titles[1], 'Jak dobře znáš Boha?');
      expect(titles[2], 'Přežiješ poslední dny?');
      expect(titles[3], 'Proč si vážit místa v Jehovově organizaci?');
    });

    test('handles CRLF line breaks', () {
      final titles =
          S99Parser.parse([_enPage1.replaceAll('\n', '\r\n'), _enPage2]);
      expect(titles[3], 'Move Ahead With Jehovah’s Unified Organization');
    });

    test('non-increasing numbered line is treated as a continuation', () {
      final page = '${_entries(1, 20)}\n5. looks like an entry       ';
      final titles = S99Parser.parse([page]);
      expect(titles.length, 20);
      expect(titles[20], 'Sample Talk Title 20 5. looks like an entry');
    });

    test('numbered intro line above the first entry is ignored', () {
      final page = '25. Fake intro item\n${_entries(1, 26)}';
      final titles = S99Parser.parse([page]);
      expect(titles[25], 'Sample Talk Title 25');
      expect(titles.length, 26);
    });

    test('tolerates gaps in numbering (discontinued outlines)', () {
      final page = '${_entries(1, 2)}\n${_entries(4, 24)}';
      final titles = S99Parser.parse([page]);
      expect(titles.containsKey(3), isFalse);
      expect(titles.length, 23);
    });

    test('rejects input with too few entries', () {
      expect(() => S99Parser.parse([_entries(1, 5)]),
          throwsA(isA<FormatException>()));
      expect(() => S99Parser.parse(['just some text', 'more text']),
          throwsA(isA<FormatException>()));
    });

    test(
      'parses the real S-99-E page texts (extracted from S-99_E.pdf)',
      () {
        final pages =
            File('test/s99_e_pages.txt').readAsStringSync().split('\f');
        final titles = S99Parser.parse(pages);
        expect(titles.length, 194);
        expect(titles[1], 'How Well Do You Know God?');
        expect(titles[106], 'Ruining the Earth Brings Divine Retribution');
        expect(titles[194], 'How Godly Wisdom Benefits Us');
      },
      skip: File('test/s99_e_pages.txt').existsSync()
          ? false
          : 'test/s99_e_pages.txt not present',
    );
  });

  group('diffCatalog', () {
    test('partitions added, changed, removed and unchanged', () {
      final diff = diffCatalog(
        {1: 'One', 2: 'Two', 3: 'Three'},
        {1: 'One', 2: 'Two changed', 4: 'Four'},
      );
      expect(diff.unchanged, [1]);
      expect(diff.changed, [2]);
      expect(diff.removed, [3]);
      expect(diff.added, [4]);
    });

    test('empty old catalog marks everything as added', () {
      final diff = diffCatalog({}, {1: 'One', 2: 'Two'});
      expect(diff.added, [1, 2]);
      expect(diff.changed, isEmpty);
      expect(diff.removed, isEmpty);
    });
  });
}
