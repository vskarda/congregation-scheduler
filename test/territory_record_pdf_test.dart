import 'dart:io';
import 'dart:typed_data';

import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/pdf/pdf_fonts.dart';
import 'package:congregation_scheduler/features/territories/territory_record_pdf.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/widgets.dart' as pw;

// Loads the bundled fonts straight from disk; rootBundle is not available in
// plain unit tests.
PdfFonts loadFontsFromDisk() {
  ByteData read(String path) =>
      ByteData.sublistView(File(path).readAsBytesSync());
  return PdfFonts(
    base: pw.Font.ttf(read('assets/fonts/NotoSans-Regular.ttf')),
    bold: pw.Font.ttf(read('assets/fonts/NotoSans-Bold.ttf')),
    fallback: [pw.Font.ttf(read('assets/fonts/NotoSansJP-Regular.ttf'))],
  );
}

void main() {
  setUpAll(() => initializeDateFormatting());

  const territories = [
    Territory(id: 't1', name: '12A'),
    Territory(id: 't2', name: 'Ostrov sever'),
  ];
  const publishers = <String, Publisher>{
    'p1': Publisher(id: 'p1', firstName: 'Jan', lastName: 'Novák'),
    'p2': Publisher(id: 'p2', firstName: 'Petra', lastName: 'Dvořáková'),
  };

  TerritoryAssignment assignment(
    String id, {
    String territoryId = 't1',
    String publisherId = 'p1',
    String freeText = '',
    required String assigned,
    String returned = '',
  }) =>
      TerritoryAssignment(
        id: id,
        territoryId: territoryId,
        publisherId: publisherId,
        freeText: freeText,
        assignedDate: assigned,
        returnedDate: returned,
      );

  List<TerritoryRecordRow> rowsFor(
    List<TerritoryAssignment> assignments, {
    int serviceYear = 2026,
  }) =>
      territoryRecordRows(
        territories: territories,
        assignments: assignments,
        publishersById: publishers,
        serviceYear: serviceYear,
      );

  test('every territory gets a line, even with nothing assigned', () {
    final rows = rowsFor(const []);

    expect(rows.map((r) => r.territoryName), ['12A', 'Ostrov sever']);
    expect(rows.first.slots, hasLength(territoryRecordSlots));
    expect(rows.first.slots.every((s) => s.publisherName.isEmpty), isTrue);
    expect(rows.first.lastCompleted, '');
  });

  test('the service year runs September to August', () {
    final rows = rowsFor([
      assignment('a', assigned: '2025-08-31'), // previous service year
      assignment('b', assigned: '2025-09-01'), // first day of this one
      assignment('c', assigned: '2026-08-31'), // last day of this one
      assignment('d', assigned: '2026-09-01'), // next service year
    ]);

    expect(
      rows.first.slots.map((s) => s.assignedDate).where((d) => d.isNotEmpty),
      ['2025-09-01', '2026-08-31'],
    );
  });

  test('assignments read left to right in the order they went out', () {
    final rows = rowsFor([
      assignment('late', assigned: '2026-03-04', publisherId: 'p2'),
      assignment('early', assigned: '2025-10-08'),
    ]);

    expect(rows.first.slots.take(2).map((s) => s.publisherName), [
      'Jan Novák',
      'Petra Dvořáková',
    ]);
  });

  test('last date completed takes the newest return before the year', () {
    final rows = rowsFor([
      assignment('old', assigned: '2023-09-10', returned: '2023-11-02'),
      assignment('newer', assigned: '2024-09-10', returned: '2025-04-19'),
      // Inside the year: printed in a slot, so it must not reach the column.
      assignment('inYear', assigned: '2025-10-01', returned: '2026-01-07'),
    ]);

    expect(rows.first.lastCompleted, '2025-04-19');
  });

  test('an open assignment leaves the completed date blank', () {
    final rows = rowsFor([assignment('a', assigned: '2025-09-15')]);

    expect(rows.first.slots.first.assignedDate, '2025-09-15');
    expect(rows.first.slots.first.completedDate, '');
  });

  test('a deleted publisher blanks the name but keeps the dates', () {
    final rows = rowsFor([
      assignment('a', assigned: '2025-09-15', publisherId: 'gone'),
    ]);

    expect(rows.first.slots.first.publisherName, '');
    expect(rows.first.slots.first.assignedDate, '2025-09-15');
  });

  test('a hand-typed holder prints where the roster has nobody', () {
    final rows = rowsFor([
      assignment('a',
          assigned: '2025-09-15',
          publisherId: '',
          freeText: 'Marie Svobodová'),
      // A live record still wins: the roster has the current spelling.
      assignment('b',
          assigned: '2025-10-20', freeText: 'Stale Name'),
    ]);

    expect(rows.first.slots.take(2).map((s) => s.publisherName), [
      'Marie Svobodová',
      'Jan Novák',
    ]);
  });

  test('a fifth assignment continues the territory on another line', () {
    const dates = [
      '2025-09-01',
      '2025-10-01',
      '2025-11-01',
      '2025-12-01',
      '2026-01-01',
    ];
    final rows = rowsFor([
      assignment('before', assigned: '2024-10-01', returned: '2024-12-20'),
      for (final (i, date) in dates.indexed) assignment('a$i', assigned: date),
      assignment('other', territoryId: 't2', assigned: '2025-09-02'),
    ]);

    final first = rows.where((r) => r.territoryName == '12A').toList();
    expect(first, hasLength(2));
    expect(
      first[0].slots.where((s) => s.assignedDate.isNotEmpty),
      hasLength(4),
    );
    expect(
      first[1].slots.where((s) => s.assignedDate.isNotEmpty),
      hasLength(1),
    );
    expect(first[1].slots.first.assignedDate, dates.last);
    // The column belongs to the territory, not to each of its lines.
    expect(first[0].lastCompleted, '2024-12-20');
    expect(first[1].lastCompleted, '');
    // The continued territory does not push the next one off the sheet.
    expect(rows.map((r) => r.territoryName), ['12A', '12A', 'Ostrov sever']);
  });

  test('builds an English territory record PDF', () async {
    final bytes = await buildTerritoryRecordPdf(
      territories: territories,
      assignments: [
        assignment('a', assigned: '2025-09-03', returned: '2025-10-01'),
        assignment('b', assigned: '2025-10-05', publisherId: 'p2'),
      ],
      publishersById: publishers,
      serviceYear: 2026,
      l10n: lookupAppLocalizations(const Locale('en')),
      locale: 'en',
      fonts: loadFontsFromDisk(),
    );

    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(bytes.length, greaterThan(1000));
  });

  test(
    'builds a Japanese territory record PDF through the CJK fallback',
    () async {
      final bytes = await buildTerritoryRecordPdf(
        territories: territories,
        assignments: [assignment('a', assigned: '2025-09-03')],
        publishersById: publishers,
        serviceYear: 2026,
        l10n: lookupAppLocalizations(const Locale('ja')),
        locale: 'ja',
        fonts: loadFontsFromDisk(),
      );

      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    },
  );

  test('a long roster runs onto further pages', () async {
    final many = [
      for (var i = 0; i < 60; i++)
        Territory(id: 't$i', name: 'Territory ${i.toString().padLeft(2, '0')}'),
    ];
    final bytes = await buildTerritoryRecordPdf(
      territories: many,
      assignments: const [],
      publishersById: const {},
      serviceYear: 2026,
      l10n: lookupAppLocalizations(const Locale('en')),
      locale: 'en',
      fonts: loadFontsFromDisk(),
    );

    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });
}
