import 'dart:io';
import 'dart:typed_data';

import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/pdf/pdf_fonts.dart';
import 'package:congregation_scheduler/features/co_visit/co_visit_item_dialog.dart';
import 'package:congregation_scheduler/features/co_visit/co_visit_pdf.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/widgets.dart' as pw;

/// The printable visit schedule. Like the other PDF tests these check that a
/// document is produced at all (layout failures throw), plus the one decision
/// the sheet actually makes: whether hidden sections are on it.
void main() {
  setUpAll(() => initializeDateFormatting());

  ByteData read(String path) =>
      ByteData.sublistView(File(path).readAsBytesSync());

  PdfFonts fonts({bool withJapanese = false}) => PdfFonts(
        base: pw.Font.ttf(read('assets/fonts/NotoSans-Regular.ttf')),
        bold: pw.Font.ttf(read('assets/fonts/NotoSans-Bold.ttf')),
        fallback: withJapanese
            ? [pw.Font.ttf(read('assets/fonts/NotoSansJP-Regular.ttf'))]
            : const [],
      );

  const publishers = <String, Publisher>{
    'p1': Publisher(id: 'p1', firstName: 'Jan', lastName: 'Novák'),
    'p2': Publisher(id: 'p2', firstName: 'Anna', lastName: 'Čechová'),
  };

  const weekId = '2026-04-13'; // Monday; the visit runs 14–19 April

  const visit = CoVisit(id: weekId, items: [
    CoVisitItem(
      id: 'a',
      section: CoVisitSection.meal,
      date: '2026-04-14',
      time: '12:00',
      assignment: Assignment(publisherIds: ['p1']),
      address: 'Hlavní 12',
      note: 'No nuts',
    ),
    CoVisitItem(
      id: 'b',
      section: CoVisitSection.shepherding,
      date: '2026-04-15',
      assignment: Assignment(publisherIds: ['p2'], freeText: 'and the family'),
    ),
    CoVisitItem(
      id: 'c',
      section: CoVisitSection.elders,
      date: '2026-04-18',
      time: '18:00',
      address: 'Kingdom Hall',
    ),
    // Nothing but a note, and no day at all — every field is optional.
    CoVisitItem(
        id: 'd',
        section: CoVisitSection.other,
        note: 'Bring the attendance figures'),
  ]);

  const ministry = [
    FsmMeeting(
      id: 'm1',
      date: '2026-04-15',
      time: '09:00',
      location: 'Hall',
      assignment: Assignment(publisherIds: ['p1']),
      withCo: Assignment(publisherIds: ['p2']),
      withCoWife: Assignment(freeText: 'Marie'),
    ),
  ];

  Future<Uint8List> build({
    required bool includeHidden,
    CoVisit source = visit,
    String locale = 'en',
    AppLocalizations? l10n,
    PdfFonts? withFonts,
  }) async {
    final strings = l10n ?? lookupAppLocalizations(Locale(locale));
    return buildCoVisitPdf(
      weekId: weekId,
      visit: source,
      ministryMeetings: ministry,
      publishersById: publishers,
      congregationName: 'Springfield',
      midweekWeekday: DateTime.tuesday,
      midweekTime: '18:30',
      weekendWeekday: DateTime.sunday,
      weekendTime: '10:00',
      includeHidden: includeHidden,
      sectionLabel: (s) => coSectionLabel(strings, s),
      l10n: strings,
      locale: locale,
      fonts: withFonts ?? fonts(),
    );
  }

  test('builds the visit schedule', () async {
    final bytes = await build(includeHidden: false);
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('builds an empty visit schedule', () async {
    final bytes =
        await build(includeHidden: false, source: const CoVisit(id: weekId));
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('hidden sections are left off unless they are asked for', () async {
    final hiddenVisit = visit
        .withSectionHidden(CoVisitSection.meal, true)
        .withSectionHidden(CoVisitSection.other, true);

    final visibleOnly =
        await build(includeHidden: false, source: hiddenVisit);
    final everything = await build(includeHidden: true, source: hiddenVisit);
    final nothingHidden = await build(includeHidden: false);

    expect(everything.length, greaterThan(visibleOnly.length),
        reason: 'the hidden sections add rows to the sheet');
    expect(everything.length, nothingHidden.length,
        reason: 'printing everything matches a visit that hides nothing');
  });

  test('hiding the ministry section drops its meetings too', () async {
    final withMinistry = await build(includeHidden: false);
    final withoutMinistry = await build(
        includeHidden: false,
        source: visit.withSectionHidden(CoVisitSection.ministry, true));

    expect(withoutMinistry.length, lessThan(withMinistry.length));
  });

  // Every day of the visit is on the sheet, even an empty one — that is what
  // makes it a calendar rather than a list.
  test('an arrangement with no day still reaches the sheet', () async {
    final undated = await build(
      includeHidden: false,
      source: const CoVisit(id: weekId, items: [
        CoVisitItem(
            id: 'x',
            section: CoVisitSection.meal,
            assignment: Assignment(freeText: 'still deciding')),
      ]),
    );
    final empty =
        await build(includeHidden: false, source: const CoVisit(id: weekId));

    expect(undated.length, greaterThan(empty.length),
        reason: 'it prints under "not scheduled yet" instead of vanishing');
  });

  test('builds a Czech schedule with diacritics', () async {
    final bytes = await build(includeHidden: true, locale: 'cs');
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('builds a Japanese schedule through the fallback font', () async {
    final bytes = await build(
        includeHidden: true, locale: 'ja', withFonts: fonts(withJapanese: true));
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });
}
