import 'dart:convert';
import 'dart:typed_data';

import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/territories/territory_import_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseTerritoryImport', () {
    test('parses tab-separated paste with all three columns', () {
      final rows = parseTerritoryImport(
        'Centre\thttps://maps.example/1\tBig blocks\n'
        'North\thttps://maps.example/2\tRural',
      );
      expect(rows, hasLength(2));
      expect(rows[0].name, 'Centre');
      expect(rows[0].mapUrl, 'https://maps.example/1');
      expect(rows[0].notes, 'Big blocks');
      expect(rows[1].name, 'North');
      expect(rows[1].line, 2);
    });

    test('missing optional columns default to empty', () {
      final rows = parseTerritoryImport('Centre\thttps://maps.example/1\nNorth');
      expect(rows[0].mapUrl, 'https://maps.example/1');
      expect(rows[0].notes, '');
      expect(rows[1].name, 'North');
      expect(rows[1].mapUrl, '');
    });

    test('detects semicolon delimiter despite commas in fields', () {
      final rows = parseTerritoryImport(
        '1. obvod;https://maps.example/x?a=1,2;Domy, byty\n'
        '2. obvod;;Poznámka',
      );
      expect(rows, hasLength(2));
      expect(rows[0].name, '1. obvod');
      expect(rows[0].mapUrl, 'https://maps.example/x?a=1,2');
      expect(rows[0].notes, 'Domy, byty');
      expect(rows[1].mapUrl, '');
      expect(rows[1].notes, 'Poznámka');
    });

    test('handles quoted commas and escaped quotes in comma CSV', () {
      final rows = parseTerritoryImport(
        '"Centre, north",,"He said ""hi"""\nEast',
      );
      expect(rows, hasLength(2));
      expect(rows[0].name, 'Centre, north');
      expect(rows[0].notes, 'He said "hi"');
      expect(rows[1].name, 'East');
    });

    test('keeps embedded newline inside a quoted field in one row', () {
      final rows = parseTerritoryImport(
        'West,,"line one\nline two"\nSouth',
      );
      expect(rows, hasLength(2));
      expect(rows[0].notes, 'line one\nline two');
      expect(rows[1].name, 'South');
      expect(rows[1].line, 3);
    });

    test('skips English and Czech header rows', () {
      final en = parseTerritoryImport('Name\tLink\tNotes\nCentre\thttp://m/1');
      expect(en, hasLength(1));
      expect(en.first.name, 'Centre');

      final cs = parseTerritoryImport('Název;Odkaz;Poznámky\nKarlín;http://m/3');
      expect(cs, hasLength(1));
      expect(cs.first.name, 'Karlín');
    });

    test('does not skip a first row of real data', () {
      final rows = parseTerritoryImport('Karlín\nSmíchov');
      expect(rows, hasLength(2));
    });

    test('ignores blank lines and CRLF, keeps source line numbers', () {
      final rows = parseTerritoryImport('Centre\r\n\r\nNorth\r\n');
      expect(rows, hasLength(2));
      expect(rows[0].line, 1);
      expect(rows[1].line, 3);
    });

    test('treats input without any delimiter as names only', () {
      final rows = parseTerritoryImport('Centre\nNorth\n');
      expect(rows, hasLength(2));
      expect(rows[0].name, 'Centre');
      expect(rows[0].mapUrl, '');
      expect(rows[1].name, 'North');
    });
  });

  group('analyzeTerritoryImport', () {
    const existing = [
      Territory(id: 'doc1', name: 'Centre'),
      Territory(id: 'doc2', name: 'North'),
    ];

    List<TerritoryImportEntry> analyze(String text) =>
        analyzeTerritoryImport(parseTerritoryImport(text), existing);

    test('matches existing names case-insensitively', () {
      final entries = analyze('centre\nEast');
      expect(entries[0].status, TerritoryImportStatus.duplicate);
      expect(entries[0].existing?.id, 'doc1');
      expect(entries[1].status, TerritoryImportStatus.newEntry);
    });

    test('flags a repeated name within the file (case-insensitive)', () {
      final entries = analyze('East\neast');
      expect(entries[0].status, TerritoryImportStatus.newEntry);
      expect(entries[1].status, TerritoryImportStatus.duplicateInFile);
    });

    test('flags empty name as invalid', () {
      final entries = analyze('\thttps://maps.example/9\nEast');
      expect(entries[0].status, TerritoryImportStatus.invalid);
      expect(entries[1].status, TerritoryImportStatus.newEntry);
    });

    test('a matched name updates map/notes on the existing territory', () {
      final entries = analyze('North\thttps://maps.example/n\tSee gate');
      expect(entries[0].status, TerritoryImportStatus.duplicate);
      expect(entries[0].existing?.id, 'doc2');
      expect(entries[0].row.mapUrl, 'https://maps.example/n');
      expect(entries[0].row.notes, 'See gate');
    });
  });

  group('decodeImportBytes', () {
    test('strips a UTF-8 BOM', () {
      final bytes = Uint8List.fromList([
        0xEF,
        0xBB,
        0xBF,
        ...utf8.encode('Náměstí;http://m/7'),
      ]);
      expect(decodeImportBytes(bytes), 'Náměstí;http://m/7');
    });

    test('falls back to Windows-1250 for Czech Excel bytes', () {
      // "Náměstí Míru" encoded in cp1250.
      final bytes = Uint8List.fromList([
        0x4E, 0xE1, 0x6D, 0xEC, 0x73, 0x74, 0xED, 0x20, // Náměstí + space
        0x4D, 0xED, 0x72, 0x75, // Míru
      ]);
      expect(decodeImportBytes(bytes), 'Náměstí Míru');
    });
  });
}
