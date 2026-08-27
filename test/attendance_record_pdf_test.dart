import 'dart:io';
import 'dart:typed_data';

import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/pdf/pdf_fonts.dart';
import 'package:congregation_scheduler/features/attendance/attendance_record_pdf.dart';
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

  AttendanceEntry entry(
    String date, {
    MeetingType type = MeetingType.lmm,
    int? inPerson,
    int? online,
    int? total,
  }) =>
      AttendanceEntry(
        id: AttendanceEntry.docId(date, type),
        date: date,
        meetingType: type,
        inPerson: inPerson,
        online: online,
        total: total,
      );

  // Service year 2026 = September 2025 .. August 2026; September is index 0.
  AttendanceRecordYear rollUp(
    List<AttendanceEntry> entries, {
    MeetingType type = MeetingType.lmm,
  }) =>
      attendanceRecordYear(
        entries: entries,
        serviceYear: 2026,
        meetingType: type,
      );

  test('a month with nothing recorded stays blank', () {
    final year = rollUp([entry('2025-09-03', total: 90)]);

    expect(year.months, hasLength(12));
    expect(year.months[0].isEmpty, isFalse);
    expect(year.months[1].isEmpty, isTrue);
    expect(year.months[1].meetings, isNull);
    expect(year.months[1].total, isNull);
    expect(year.months[1].average, isNull);
  });

  test('counts recorded meetings and averages over them', () {
    final year = rollUp([
      entry('2025-09-03', total: 90),
      entry('2025-09-10', total: 95),
      entry('2025-09-17', total: 100),
    ]);

    expect(year.months[0].meetings, 3);
    expect(year.months[0].total, 285);
    expect(year.months[0].average, 95);
  });

  test('in person and online are combined, and a bare total counts', () {
    final year = rollUp([
      entry('2025-09-03', inPerson: 70, online: 12),
      entry('2025-09-10', total: 88),
    ]);

    expect(year.months[0].meetings, 2);
    expect(year.months[0].total, 170);
  });

  test('an entry with no numbers at all is not a recorded meeting', () {
    final year = rollUp([entry('2025-09-03')]);

    expect(year.months[0].isEmpty, isTrue);
    expect(year.yearAverage, isNull);
  });

  test('the other meeting kind is left out', () {
    final year = rollUp([
      entry('2025-09-03', total: 90),
      entry('2025-09-07', type: MeetingType.weekend, total: 130),
    ]);

    expect(year.months[0].meetings, 1);
    expect(year.months[0].total, 90);
  });

  test('entries outside the service year are left out', () {
    final year = rollUp([
      entry('2025-08-27', total: 500), // previous service year
      entry('2025-09-03', total: 90),
      entry('2026-09-02', total: 500), // next service year
    ]);

    expect(year.months.where((m) => !m.isEmpty), hasLength(1));
    expect(year.yearAverage, 90);
  });

  test('the year figure divides all attendance by all meetings', () {
    // Not the mean of the monthly means: September averages 100 over one
    // meeting and October 50 over three, so the year is 250/4 = 63 — the mean
    // of the two monthly averages would be 75.
    final year = rollUp([
      entry('2025-09-03', total: 100),
      entry('2025-10-01', total: 50),
      entry('2025-10-08', total: 50),
      entry('2025-10-15', total: 50),
    ]);

    expect(year.months[0].average, 100);
    expect(year.months[1].average, 50);
    expect(year.yearAverage, 63);
  });

  test(
    'builds an English attendance record PDF for two service years',
    () async {
      final bytes = await buildAttendanceRecordPdf(
        entries: [
          entry('2025-09-03', total: 90),
          entry('2025-09-07', type: MeetingType.weekend, total: 130),
          entry('2024-11-06', total: 88),
        ],
        serviceYears: const [2025, 2026],
        l10n: lookupAppLocalizations(const Locale('en')),
        locale: 'en',
        fonts: loadFontsFromDisk(),
      );

      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
      expect(bytes.length, greaterThan(1000));
    },
  );

  test(
    'builds a Japanese attendance record PDF through the CJK fallback',
    () async {
      final bytes = await buildAttendanceRecordPdf(
        entries: [entry('2025-09-03', total: 90)],
        serviceYears: const [2025, 2026],
        l10n: lookupAppLocalizations(const Locale('ja')),
        locale: 'ja',
        fonts: loadFontsFromDisk(),
      );

      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    },
  );

  test('an empty year still builds a blank sheet', () async {
    final bytes = await buildAttendanceRecordPdf(
      entries: const [],
      serviceYears: const [2025, 2026],
      l10n: lookupAppLocalizations(const Locale('cs')),
      locale: 'cs',
      fonts: loadFontsFromDisk(),
    );

    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });
}
