import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/l10n/l10n.dart';
import '../../../core/models/models.dart';
import '../../../core/utils/dates.dart';

/// Unicode fonts embedded into the PDF; the pdf package's built-in Helvetica
/// lacks the Latin Extended-A glyphs Czech needs.
class S21Fonts {
  const S21Fonts({required this.base, required this.bold});

  final pw.Font base;
  final pw.Font bold;
}

Future<S21Fonts> loadS21Fonts() async => S21Fonts(
      base: pw.Font.ttf(
          await rootBundle.load('assets/fonts/NotoSans-Regular.ttf')),
      bold:
          pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Bold.ttf')),
    );

/// Builds a one-page PDF replicating the official S-21 (11/23) publisher
/// record card for one service year, localized to [locale].
Future<Uint8List> buildS21Pdf({
  required Publisher publisher,
  required PublisherPrivate? private,
  required int serviceYear,
  required Map<String, MinistryReport?> reportsByMonth,
  required AppLocalizations l10n,
  required String locale,
  required S21Fonts fonts,
}) async {
  final dateFmt = DateFormat.yMd(locale);
  final monthFmt = DateFormat('LLLL', locale);

  String formatDate(String? key) {
    final d = tryParseDateKey(key);
    return d == null ? '' : dateFmt.format(d);
  }

  final hope = private?.hope ?? Hope.otherSheep;
  final appointment = private?.appointment ?? Appointment.none;
  final totalHours = reportsByMonth.values
      .whereType<MinistryReport>()
      .fold<int>(0, (sum, r) => sum + r.totalHours);

  pw.Widget checkbox(bool checked, String label) => pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Container(
            width: 9,
            height: 9,
            decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.8)),
            alignment: pw.Alignment.center,
            child: checked
                ? pw.Text('X',
                    style: pw.TextStyle(
                        fontSize: 7, fontWeight: pw.FontWeight.bold))
                : null,
          ),
          pw.SizedBox(width: 3),
          pw.Text(label,
              style:
                  pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
        ],
      );

  // A header line ("Date of birth: 1.1.1990") with two aligned checkbox
  // columns on the right, mirroring the official card.
  pw.Widget headerLine(String label, String value,
          {pw.Widget? box1, pw.Widget? box2}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Expanded(
              child: pw.Row(children: [
                pw.Text(label,
                    style: pw.TextStyle(
                        fontSize: 9, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(width: 6),
                pw.Text(value, style: const pw.TextStyle(fontSize: 9)),
              ]),
            ),
            pw.SizedBox(width: 100, child: box1 ?? pw.SizedBox()),
            pw.SizedBox(width: 80, child: box2 ?? pw.SizedBox()),
          ],
        ),
      );

  pw.Widget headCell(String text) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 4),
        child: pw.Text(text,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
      );

  pw.Widget textCell(String text,
          {pw.TextAlign align = pw.TextAlign.left, bool bold = false}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        child: pw.Text(text,
            textAlign: align,
            style: pw.TextStyle(
                fontSize: 9,
                fontWeight:
                    bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
      );

  pw.Widget boxCell(bool checked) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 3),
        child: pw.Center(
          child: pw.Container(
            width: 9,
            height: 9,
            decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.8)),
            alignment: pw.Alignment.center,
            child: checked
                ? pw.Text('X',
                    style: pw.TextStyle(
                        fontSize: 7, fontWeight: pw.FontWeight.bold))
                : null,
          ),
        ),
      );

  String capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  final doc = pw.Document();
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      theme: pw.ThemeData.withFont(base: fonts.base, bold: fonts.bold),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Center(
            child: pw.Text(l10n.s21Title,
                style: pw.TextStyle(
                    fontSize: 13, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 14),
          headerLine(l10n.s21Name, publisher.fullName),
          headerLine(
            l10n.s21DateOfBirth,
            formatDate(private?.birthDate),
            box1: checkbox(publisher.gender == Gender.male, l10n.genderMale),
            box2:
                checkbox(publisher.gender == Gender.female, l10n.genderFemale),
          ),
          headerLine(
            l10n.s21DateOfBaptism,
            formatDate(private?.baptismDate),
            box1: checkbox(hope == Hope.otherSheep, l10n.hopeOtherSheep),
            box2: checkbox(hope == Hope.anointed, l10n.hopeAnointed),
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              checkbox(
                  appointment == Appointment.elder, l10n.appointmentElder),
              checkbox(appointment == Appointment.ministerialServant,
                  l10n.appointmentMinisterialServant),
              checkbox(publisher.status == PublisherStatus.regularPioneer,
                  l10n.statusRegPioneer),
              checkbox(publisher.status == PublisherStatus.specialPioneer,
                  l10n.statusSpecialPioneer),
              checkbox(publisher.status == PublisherStatus.fieldMissionary,
                  l10n.statusFieldMissionary),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(1.6),
              2: pw.FlexColumnWidth(1.2),
              3: pw.FlexColumnWidth(1.4),
              4: pw.FlexColumnWidth(1.6),
              5: pw.FlexColumnWidth(3),
            },
            children: [
              pw.TableRow(children: [
                headCell(l10n.serviceYear(serviceYear)),
                headCell(l10n.reportParticipated),
                headCell(l10n.reportStudies),
                headCell(l10n.statusAuxPioneer),
                headCell(l10n.s21HoursHeader),
                headCell(l10n.s21Remarks),
              ]),
              for (final month in serviceYearMonths(serviceYear))
                pw.TableRow(children: [
                  textCell(capitalize(monthFmt.format(parseMonthKey(month)))),
                  boxCell(reportsByMonth[month]?.participated == true),
                  textCell(
                      reportsByMonth[month]?.bibleStudies?.toString() ?? '',
                      align: pw.TextAlign.center),
                  boxCell(reportsByMonth[month]?.statusAtMonth ==
                      PublisherStatus.auxiliaryPioneer),
                  textCell(
                      (reportsByMonth[month]?.totalHours ?? 0) == 0
                          ? ''
                          : reportsByMonth[month]!.totalHours.toString(),
                      align: pw.TextAlign.center),
                  textCell(reportsByMonth[month]?.comments ?? ''),
                ]),
              pw.TableRow(children: [
                textCell(''),
                textCell(''),
                textCell(''),
                textCell(l10n.s21Total,
                    align: pw.TextAlign.right, bold: true),
                textCell(totalHours == 0 ? '' : totalHours.toString(),
                    align: pw.TextAlign.center, bold: true),
                textCell(''),
              ]),
            ],
          ),
          pw.Spacer(),
          pw.Text(l10n.s21FormCode, style: const pw.TextStyle(fontSize: 7)),
        ],
      ),
    ),
  );
  return doc.save();
}
