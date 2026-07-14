import 'dart:convert';
import 'dart:typed_data';

import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/territories/territory_import_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseTerritoryImport', () {
    test('parses tab-separated paste with all four columns', () {
      final rows = parseTerritoryImport(
        'Centre\t1\thttps://maps.example/1\tBig blocks\n'
        'North\t2\thttps://maps.example/2\tRural',
      );
      expect(rows, hasLength(2));
      expect(rows[0].name, 'Centre');
      expect(rows[0].number, '1');
      expect(rows[0].mapUrl, 'https://maps.example/1');
      expect(rows[0].notes, 'Big blocks');
      expect(rows[1].name, 'North');
      expect(rows[1].line, 2);
    });

    test('missing optional columns default to empty', () {
      final rows = parseTerritoryImport('Centre\t1\nNorth');
      expect(rows[0].mapUrl, '');
      expect(rows[0].notes, '');
      expect(rows[1].name, 'North');
      expect(rows[1].number, '');
    });

    test('detects semicolon delimiter despite commas in fields', () {
      final rows = parseTerritoryImport(
        '1. obvod;12;https://maps.example/x?a=1,2;Domy, byty\n'
        '2. obvod;13;;Poznámka',
      );
      expect(rows, hasLength(2));
      expect(rows[0].name, '1. obvod');
      expect(rows[0].number, '12');
      expect(rows[0].mapUrl, 'https://maps.example/x?a=1,2');
      expect(rows[0].notes, 'Domy, byty');
      expect(rows[1].mapUrl, '');
    });

    test('handles quoted commas and escaped quotes in comma CSV', () {
      final rows = parseTerritoryImport(
        '"Centre, north",5,,"He said ""hi"""\nEast,6',
      );
      expect(rows, hasLength(2));
      expect(rows[0].name, 'Centre, north');
      expect(rows[0].number, '5');
      expect(rows[0].notes, 'He said "hi"');
      expect(rows[1].name, 'East');
    });

    test('keeps embedded newline inside a quoted field in one row', () {
      final rows = parseTerritoryImport(
        'West,7,,"line one\nline two"\nSouth,8',
      );
      expect(rows, hasLength(2));
      expect(rows[0].notes, 'line one\nline two');
      expect(rows[1].name, 'South');
      expect(rows[1].line, 3);
    });

    test('skips English and Czech header rows', () {
      final en = parseTerritoryImport('Name\tNumber\tLink\tNotes\nCentre\t1');
      expect(en, hasLength(1));
      expect(en.first.name, 'Centre');

      final cs = parseTerritoryImport('Název;Číslo;Odkaz;Poznámky\nKarlín;3');
      expect(cs, hasLength(1));
      expect(cs.first.name, 'Karlín');
    });

    test('does not skip a first row of real data', () {
      final rows = parseTerritoryImport('Karlín\t3\nSmíchov\t4');
      expect(rows, hasLength(2));
    });

    test('ignores blank lines and CRLF, keeps source line numbers', () {
      final rows = parseTerritoryImport('Centre\t1\r\n\r\nNorth\t2\r\n');
      expect(rows, hasLength(2));
      expect(rows[0].line, 1);
      expect(rows[1].line, 3);
    });

    test('treats input without any delimiter as names only', () {
      final rows = parseTerritoryImport('Centre\nNorth\n');
      expect(rows, hasLength(2));
      expect(rows[0].name, 'Centre');
      expect(rows[0].number, '');
      expect(rows[1].name, 'North');
    });
  });

  group('analyzeTerritoryImport', () {
    const existing = [
      Territory(id: 'doc1', name: 'Old centre', number: '1'),
      Territory(id: 'doc2', name: 'North', number: '02'),
    ];

    List<TerritoryImportEntry> analyze(String text) =>
        analyzeTerritoryImport(parseTerritoryImport(text), existing);

    test('matches numbers numerically ("01" matches "1")', () {
      final entries = analyze('Centre\t01\nEast\t3');
      expect(entries[0].status, TerritoryImportStatus.duplicate);
      expect(entries[0].existing?.id, 'doc1');
      expect(entries[1].status, TerritoryImportStatus.newEntry);
    });

    test('flags a repeated number within the file', () {
      final entries = analyze('East\t5\nEast again\t5');
      expect(entries[0].status, TerritoryImportStatus.newEntry);
      expect(entries[1].status, TerritoryImportStatus.duplicateInFile);
    });

    test('flags empty name as invalid', () {
      final entries = analyze('\t9\nEast\t5');
      expect(entries[0].status, TerritoryImportStatus.invalid);
      expect(entries[1].status, TerritoryImportStatus.newEntry);
    });

    test('rows without a number are always new, even repeated', () {
      final entries = analyze('East\nWest');
      expect(entries[0].status, TerritoryImportStatus.newEntry);
      expect(entries[1].status, TerritoryImportStatus.newEntry);
    });
  });

  group('decodeImportBytes', () {
    test('strips a UTF-8 BOM', () {
      final bytes = Uint8List.fromList([
        0xEF,
        0xBB,
        0xBF,
        ...utf8.encode('Náměstí;7'),
      ]);
      expect(decodeImportBytes(bytes), 'Náměstí;7');
    });

    test('falls back to Windows-1250 for Czech Excel bytes', () {
      // "Náměstí Míru;7" encoded in cp1250.
      final bytes = Uint8List.fromList([
        0x4E, 0xE1, 0x6D, 0xEC, 0x73, 0x74, 0xED, 0x20, // Náměstí + space
        0x4D, 0xED, 0x72, 0x75, 0x3B, 0x37, // Míru;7
      ]);
      expect(decodeImportBytes(bytes), 'Náměstí Míru;7');
    });
  });
}
