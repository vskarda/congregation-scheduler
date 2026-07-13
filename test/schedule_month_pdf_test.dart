import 'dart:io';
import 'dart:typed_data';

import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/pdf/pdf_fonts.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/features/lmm_schedule/lmm_month_pdf.dart';
import 'package:congregation_scheduler/features/weekend_schedule/weekend_month_pdf.dart';
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
  );
}

void main() {
  setUpAll(() => initializeDateFormatting());

  final month = DateTime(2026, 7, 1);
  final mondays = mondaysInMonth(month); // 6, 13, 20, 27

  const publishers = <String, Publisher>{
    'p1': Publisher(id: 'p1', firstName: 'Jan', lastName: 'Novák'),
    'p2': Publisher(id: 'p2', firstName: 'Jiří', lastName: 'Dvořák'),
    'p3': Publisher(id: 'p3', firstName: 'Anna', lastName: 'Čechová'),
  };

  final lmmWeek = LmmWeek(
    id: '2026-07-06',
    weekLabel: 'JULY 6-12 | PSALM 45',
    songs: const ['132', '5', '88'],
    parts: const [
      LmmPart(
        id: 'a',
        section: LmmSection.opening,
        type: LmmPartType.chairman,
        assignment: Assignment(publisherIds: ['p1']),
      ),
      LmmPart(
        id: 'b',
        section: LmmSection.treasures,
        type: LmmPartType.bibleReading,
        durationMin: 4,
        assignment: Assignment(publisherIds: ['p2']),
        assignment2: Assignment(publisherIds: ['p3']),
        assignment3: Assignment(freeText: 'Host'),
      ),
      LmmPart(
        id: 'c',
        section: LmmSection.ministry,
        type: LmmPartType.fieldMinistry,
        title: 'Starting a conversation',
        description: 'HOUSE TO HOUSE. (lmd lesson 1 point 5)',
        durationMin: 3,
        assignment: Assignment(publisherIds: ['p2']),
        assistant: Assignment(publisherIds: ['p3']),
        assignment2: Assignment(publisherIds: ['p1']),
        assistant2: Assignment(publisherIds: ['p2']),
      ),
      LmmPart(
        id: 'd',
        section: LmmSection.living,
        type: LmmPartType.cbsConductor,
        durationMin: 30,
        assignment: Assignment(publisherIds: ['p1']),
      ),
    ],
    attendants: const Assignment(publisherIds: ['p1', 'p2']),
    microphones: const Assignment(publisherIds: ['p3']),
    customAssignments: const [
      CustomAssignment(
        label: 'Cleaning',
        assignment: Assignment(freeText: 'Group 2'),
      ),
    ],
  );

  final weekendWeek = WeekendWeek(
    id: '2026-07-06',
    talkTitle: 'Jak najít skutečné štěstí',
    talkNo: 12,
    speaker: const Assignment(freeText: 'Br. Hostující'),
    chairman: const Assignment(publisherIds: ['p1']),
    wtReader: const Assignment(publisherIds: ['p2']),
    customFields: const [
      CustomAssignment(
        label: 'Hospitality',
        assignment: Assignment(publisherIds: ['p3']),
      ),
    ],
    attendants: const Assignment(publisherIds: ['p2']),
  );

  test('builds an LMM month PDF with 3 classes and missing weeks', () async {
    final bytes = await buildLmmMonthPdf(
      month: month,
      mondays: mondays,
      weeksById: {'2026-07-06': lmmWeek}, // 13/20/27 have no schedule
      publishersById: publishers,
      classCount: 3,
      permanentAssignments: const [],
      l10n: lookupAppLocalizations(const Locale('en')),
      locale: 'en',
      fonts: loadFontsFromDisk(),
    );
    expect(bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('builds a Czech LMM month PDF with diacritics', () async {
    final bytes = await buildLmmMonthPdf(
      month: month,
      mondays: mondays,
      weeksById: {'2026-07-06': lmmWeek, '2026-07-13': lmmWeek},
      publishersById: publishers,
      classCount: 1,
      permanentAssignments: const [],
      l10n: lookupAppLocalizations(const Locale('cs')),
      locale: 'cs',
      fonts: loadFontsFromDisk(),
    );
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('builds an LMM month PDF for an empty month', () async {
    final bytes = await buildLmmMonthPdf(
      month: month,
      mondays: mondays,
      weeksById: const {},
      publishersById: const {},
      classCount: 1,
      permanentAssignments: const [],
      l10n: lookupAppLocalizations(const Locale('en')),
      locale: 'en',
      fonts: loadFontsFromDisk(),
    );
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('LMM PDF merges permanent custom assignments (assigned + blank)',
      () async {
    const permanent = [
      CustomAssignment(id: 'perm1', label: 'Zoom host'),
      CustomAssignment(id: 'perm2', label: 'Cleaning group'),
    ];
    // perm1 has this-week's assignee stored by id; perm2 is unfilled (blank
    // row); a one-off (empty id) also renders.
    final weekWithPermanent = lmmWeek.copyWith(customAssignments: const [
      CustomAssignment(
        id: 'perm1',
        label: 'Zoom host',
        assignment: Assignment(publisherIds: ['p1']),
      ),
      CustomAssignment(
        label: 'One-off note',
        assignment: Assignment(freeText: 'note'),
      ),
    ]);
    final bytes = await buildLmmMonthPdf(
      month: month,
      mondays: mondays,
      weeksById: {'2026-07-06': weekWithPermanent},
      publishersById: publishers,
      classCount: 1,
      permanentAssignments: permanent,
      l10n: lookupAppLocalizations(const Locale('en')),
      locale: 'en',
      fonts: loadFontsFromDisk(),
    );
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('builds a weekend month PDF with missing weeks', () async {
    final bytes = await buildWeekendMonthPdf(
      month: month,
      mondays: mondays,
      weeksById: {'2026-07-06': weekendWeek},
      publishersById: publishers,
      permanentAssignments: const [],
      l10n: lookupAppLocalizations(const Locale('cs')),
      locale: 'cs',
      fonts: loadFontsFromDisk(),
    );
    expect(bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('builds a weekend month PDF for an empty month', () async {
    final bytes = await buildWeekendMonthPdf(
      month: month,
      mondays: mondays,
      weeksById: const {},
      publishersById: const {},
      permanentAssignments: const [],
      l10n: lookupAppLocalizations(const Locale('en')),
      locale: 'en',
      fonts: loadFontsFromDisk(),
    );
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });
}
