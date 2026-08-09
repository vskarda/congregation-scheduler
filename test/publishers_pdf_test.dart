import 'dart:io';
import 'dart:typed_data';

import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/pdf/pdf_fonts.dart';
import 'package:congregation_scheduler/features/publishers/publishers_pdf.dart';
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

  final rows = <PublisherProfileRow>[
    const PublisherProfileRow(
      publisher: Publisher(
        id: 'p1',
        firstName: 'Jan',
        lastName: 'Novák',
        gender: Gender.male,
        status: PublisherStatus.regularPioneer,
        appointment: Appointment.elder,
      ),
      private: PublisherPrivate(
        email: 'jan@example.com',
        phone: '+420 777 123 456',
        address: 'Dlouhá 12, Praha',
        birthDate: '1990-01-15',
        baptismDate: '2005-06-11',
        emergencyNote: 'Manželka Eva, +420 777 000 111',
      ),
    ),
    const PublisherProfileRow(
      publisher: Publisher(
        id: 'p2',
        firstName: 'Eva',
        lastName: 'Nováková',
        gender: Gender.female,
        status: PublisherStatus.auxiliaryPioneer,
      ),
      private: PublisherPrivate(
        email: 'eva@example.com',
        phone: '+420 777 000 111',
        address: 'Dlouhá 12, Praha',
        birthDate: '1992-03-02',
      ),
    ),
  ];

  Future<Uint8List> build(
    List<PublisherProfileRow> rows, {
    String locale = 'en',
  }) =>
      buildPublishersPdf(
        rows: rows,
        congregationName: 'Praha–Sever',
        l10n: lookupAppLocalizations(Locale(locale)),
        locale: locale,
        fonts: loadFontsFromDisk(),
      );

  test('builds an English roster PDF', () async {
    final bytes = await build(rows);
    expect(bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('builds a Czech roster PDF with diacritics', () async {
    final bytes = await build(rows, locale: 'cs');
    expect(bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('builds a Japanese roster PDF with CJK glyphs', () async {
    final bytes = await build(rows, locale: 'ja');
    expect(bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('builds every supported locale', () async {
    for (final locale in ['de', 'es', 'fr', 'it', 'pl', 'pt', 'tr']) {
      final bytes = await build(rows, locale: locale);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-', reason: locale);
    }
  });

  test('handles a publisher with no private profile', () async {
    final bytes = await build(const [
      PublisherProfileRow(
        publisher: Publisher(id: 'p3', firstName: 'Ann', lastName: 'Smith'),
      ),
    ]);
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('builds an empty roster', () async {
    final bytes = await build(const []);
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('moved and moving publishers both build', () async {
    final future = DateTime.now().add(const Duration(days: 40));
    final bytes = await build([
      const PublisherProfileRow(
        publisher: Publisher(
          id: 'p4',
          firstName: 'Petr',
          lastName: 'Dvořák',
          moved: true,
          movedDate: '2020-04-30',
        ),
      ),
      // Archived before the moving date existed — reads as gone throughout.
      const PublisherProfileRow(
        publisher: Publisher(
            id: 'p5', firstName: 'Ida', lastName: 'Kraus', moved: true),
      ),
      PublisherProfileRow(
        publisher: Publisher(
          id: 'p6',
          firstName: 'Lea',
          lastName: 'Horák',
          moved: true,
          movedDate:
              '${future.year}-${future.month.toString().padLeft(2, '0')}-'
              '${future.day.toString().padLeft(2, '0')}',
        ),
      ),
    ]);
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('spans onto further pages as the roster grows', () async {
    final many = [
      for (var i = 0; i < 120; i++)
        PublisherProfileRow(
          publisher: Publisher(
            id: 'p$i',
            firstName: 'Name$i',
            lastName: 'Surname$i',
            gender: i.isEven ? Gender.male : Gender.female,
            status: PublisherStatus.publisher,
          ),
          private: PublisherPrivate(
            email: 'pub$i@example.com',
            phone: '+420 777 000 $i',
            address: 'Street $i, Town',
            birthDate: '1980-05-01',
            emergencyNote: 'Contact $i',
          ),
        ),
    ];
    final small = await build(rows);
    final large = await build(many);
    expect(String.fromCharCodes(large.take(5)), '%PDF-');
    expect(large.length, greaterThan(small.length));
  });

  group('column codes', () {
    test('gender', () {
      expect(genderCode(Gender.male), 'M');
      expect(genderCode(Gender.female), 'F');
      expect(genderCode(Gender.unknown), '');
    });

    test('service status', () {
      expect(statusCode(PublisherStatus.none), '');
      expect(statusCode(PublisherStatus.publisher), 'P');
      expect(statusCode(PublisherStatus.auxiliaryPioneer), 'A');
      expect(statusCode(PublisherStatus.regularPioneer), 'R');
      expect(statusCode(PublisherStatus.specialPioneer), 'SP');
      expect(statusCode(PublisherStatus.fieldMissionary), 'FM');
    });

    test('appointment', () {
      expect(appointmentCode(Appointment.none), '');
      expect(appointmentCode(Appointment.ministerialServant), 'MS');
      expect(appointmentCode(Appointment.elder), 'E');
    });

    test('codes are unique within each column', () {
      final statuses = PublisherStatus.values
          .map(statusCode)
          .where((c) => c.isNotEmpty)
          .toList();
      expect(statuses.toSet().length, statuses.length);
    });
  });
}
