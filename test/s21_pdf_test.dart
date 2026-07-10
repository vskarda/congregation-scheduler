import 'dart:io';
import 'dart:typed_data';

import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/publishers/s21/s21_pdf.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/widgets.dart' as pw;

// Loads the bundled fonts straight from disk; rootBundle is not available in
// plain unit tests.
S21Fonts loadFontsFromDisk() {
  ByteData read(String path) =>
      ByteData.sublistView(File(path).readAsBytesSync());
  return S21Fonts(
    base: pw.Font.ttf(read('assets/fonts/NotoSans-Regular.ttf')),
    bold: pw.Font.ttf(read('assets/fonts/NotoSans-Bold.ttf')),
  );
}

void main() {
  setUpAll(() => initializeDateFormatting());

  const publisher = Publisher(
    id: 'p1',
    firstName: 'Jan',
    lastName: 'Novák',
    gender: Gender.male,
    status: PublisherStatus.fieldMissionary,
  );
  const private = PublisherPrivate(
    birthDate: '1990-01-15',
    baptismDate: '2005-06-11',
    hope: Hope.anointed,
    appointment: Appointment.elder,
  );
  final reports = <String, MinistryReport?>{
    '2025-09': const MinistryReport(
      month: '2025-09',
      participated: true,
      bibleStudies: 2,
      hours: 50,
      creditHours: 5,
      comments: 'Vzpomínková slavnost',
      statusAtMonth: PublisherStatus.auxiliaryPioneer,
    ),
    '2025-10': null,
  };

  test('builds an English S-21 PDF', () async {
    final bytes = await buildS21Pdf(
      publisher: publisher,
      private: private,
      serviceYear: 2026,
      reportsByMonth: reports,
      l10n: lookupAppLocalizations(const Locale('en')),
      locale: 'en',
      fonts: loadFontsFromDisk(),
    );
    expect(bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('builds a Czech S-21 PDF with diacritics', () async {
    final bytes = await buildS21Pdf(
      publisher: publisher,
      private: private,
      serviceYear: 2026,
      reportsByMonth: reports,
      l10n: lookupAppLocalizations(const Locale('cs')),
      locale: 'cs',
      fonts: loadFontsFromDisk(),
    );
    expect(bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('handles a publisher with no private data or reports', () async {
    final bytes = await buildS21Pdf(
      publisher: const Publisher(id: 'p2', firstName: 'Ann'),
      private: null,
      serviceYear: 2026,
      reportsByMonth: const {},
      l10n: lookupAppLocalizations(const Locale('en')),
      locale: 'en',
      fonts: loadFontsFromDisk(),
    );
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });
}
