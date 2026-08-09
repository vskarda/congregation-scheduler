import 'dart:typed_data';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/l10n/enum_labels.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/pdf/pdf_fonts.dart';
import '../../core/utils/dates.dart';

const _gray = PdfColor.fromInt(0xFF757575);
const _headerFill = PdfColor.fromInt(0xFFEEEEEE);

/// One row of the roster export: the public publisher document together with
/// its private profile, or null when the publisher has no private doc yet
/// (admin-created records start without one).
class PublisherProfileRow {
  const PublisherProfileRow({required this.publisher, this.private});

  final Publisher publisher;
  final PublisherPrivate? private;
}

/// Codes filling the narrow gender / status / appointment columns. They are
/// deliberately language-independent: the legend under the table spells each
/// one out in the reader's language, so translators never have to invent
/// letters that happen to stay unique in their language (Czech "Pomocný" and
/// "Pravidelný průkopník" would both want a P).
@visibleForTesting
String genderCode(Gender gender) => switch (gender) {
      Gender.male => 'M',
      Gender.female => 'F',
      Gender.unknown => '',
    };

@visibleForTesting
String statusCode(PublisherStatus status) => switch (status) {
      PublisherStatus.none => '',
      PublisherStatus.publisher => 'P',
      PublisherStatus.auxiliaryPioneer => 'A',
      PublisherStatus.regularPioneer => 'R',
      PublisherStatus.specialPioneer => 'SP',
      PublisherStatus.fieldMissionary => 'FM',
    };

@visibleForTesting
String appointmentCode(Appointment appointment) => switch (appointment) {
      Appointment.none => '',
      Appointment.ministerialServant => 'MS',
      Appointment.elder => 'E',
    };

/// Builds the roster PDF: one table row per entry of [rows], in the order
/// given (the screen's own sort and filters are the source of truth).
/// Landscape A4 — eleven columns do not fit legibly on a portrait page.
Future<Uint8List> buildPublishersPdf({
  required List<PublisherProfileRow> rows,
  required String congregationName,
  required AppLocalizations l10n,
  required String locale,
  required PdfFonts fonts,
}) async {
  final dateFmt = DateFormat.yMd(locale);
  final today = DateTime.now();

  String formatDate(String? key) {
    final d = tryParseDateKey(key);
    return d == null ? '' : dateFmt.format(d);
  }

  pw.Widget headCell(String text, {pw.TextAlign align = pw.TextAlign.left}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 4),
        child: pw.Text(text,
            textAlign: align,
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
      );

  pw.Widget cell(String text,
          {pw.TextAlign align = pw.TextAlign.left, PdfColor? color}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2.5),
        child: pw.Text(text,
            textAlign: align, style: pw.TextStyle(fontSize: 8, color: color)),
      );

  // Surname cell: carries the departure date underneath for records marked as
  // moved, so a roster exported with "Show moved" on stays unambiguous. A
  // departure still ahead reads as "Moving on", exactly as the roster tile
  // does — until that day the publisher is a full member.
  pw.Widget nameCell(Publisher p, PdfColor? color) {
    final movedOn = p.movedOn;
    if (!p.moved) return cell(p.lastName, color: color);
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2.5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(p.lastName, style: pw.TextStyle(fontSize: 8, color: color)),
          pw.Text(
            movedOn == null
                ? l10n.pubAdminMovedBadge
                : p.hasMovedBy(today)
                    ? l10n.pubAdminMovedOn(dateFmt.format(movedOn))
                    : l10n.pubAdminMovingOn(dateFmt.format(movedOn)),
            style: const pw.TextStyle(fontSize: 6.5, color: _gray),
          ),
        ],
      ),
    );
  }

  pw.TableRow dataRow(PublisherProfileRow row) {
    final p = row.publisher;
    final private = row.private;
    // Archived records print grey, matching the dimmed roster tile. A move
    // that has not arrived yet is not archived, so it stays black.
    final color = p.hasMovedBy(today) ? _gray : null;
    return pw.TableRow(children: [
      nameCell(p, color),
      cell(p.firstName, color: color),
      cell(genderCode(p.gender), align: pw.TextAlign.center, color: color),
      cell(statusCode(p.status), align: pw.TextAlign.center, color: color),
      cell(appointmentCode(p.appointment),
          align: pw.TextAlign.center, color: color),
      cell(private?.email ?? '', color: color),
      cell(private?.phone ?? '', color: color),
      cell(private?.address ?? '', color: color),
      cell(formatDate(private?.birthDate), color: color),
      cell(formatDate(private?.baptismDate), color: color),
      cell(private?.emergencyNote ?? '', color: color),
    ]);
  }

  // "G — Gender: M = Male · F = Female": the header letter first, so the
  // narrow column header ties back to its explanation.
  String legendLine(String code, String heading, Map<String, String> entries) =>
      '$code — $heading: '
      '${entries.entries.map((e) => '${e.key} = ${e.value}').join('  ·  ')}';

  final doc = pw.Document();
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4.landscape,
    margin: const pw.EdgeInsets.all(24),
    theme: pw.ThemeData.withFont(
        base: fonts.base, bold: fonts.bold, fontFallback: fonts.fallback),
    footer: (context) => pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 6),
      child: pw.Text('${context.pageNumber} / ${context.pagesCount}',
          style: const pw.TextStyle(fontSize: 7, color: _gray)),
    ),
    build: (context) => [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (congregationName.isNotEmpty)
                pw.Text(congregationName,
                    style: const pw.TextStyle(fontSize: 9, color: _gray)),
              pw.Text(l10n.pubPdfTitle,
                  style: pw.TextStyle(
                      fontSize: 13, fontWeight: pw.FontWeight.bold)),
            ],
          ),
          pw.Text(l10n.pubPdfGenerated(dateFmt.format(today), rows.length),
              style: const pw.TextStyle(fontSize: 8, color: _gray)),
        ],
      ),
      pw.SizedBox(height: 8),
      pw.Table(
        border: pw.TableBorder.all(width: 0.4, color: _gray),
        defaultVerticalAlignment: pw.TableCellVerticalAlignment.top,
        columnWidths: const {
          0: pw.FlexColumnWidth(2.2), // surname
          1: pw.FlexColumnWidth(1.8), // name
          2: pw.FlexColumnWidth(0.5), // gender
          3: pw.FlexColumnWidth(0.6), // service status
          4: pw.FlexColumnWidth(0.6), // appointment
          5: pw.FlexColumnWidth(3.2), // e-mail
          6: pw.FlexColumnWidth(1.8), // phone
          7: pw.FlexColumnWidth(3.4), // address
          8: pw.FlexColumnWidth(1.3), // birth date
          9: pw.FlexColumnWidth(1.3), // baptism date
          10: pw.FlexColumnWidth(2.7), // emergency note
        },
        children: [
          // Reprinted at the top of every page the table spans.
          pw.TableRow(
            repeat: true,
            decoration: const pw.BoxDecoration(color: _headerFill),
            children: [
              headCell(l10n.authLastName),
              headCell(l10n.authFirstName),
              headCell('G', align: pw.TextAlign.center),
              headCell('S', align: pw.TextAlign.center),
              headCell('A', align: pw.TextAlign.center),
              headCell(l10n.authEmail),
              headCell(l10n.profilePhone),
              headCell(l10n.profileAddress),
              headCell(l10n.profileBirthDate),
              headCell(l10n.profileBaptismDate),
              headCell(l10n.profileEmergency),
            ],
          ),
          for (final row in rows) dataRow(row),
        ],
      ),
      pw.SizedBox(height: 10),
      pw.Text(l10n.pubPdfLegend,
          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 2),
      for (final line in [
        legendLine('G', l10n.profileGender, {
          for (final g in [Gender.male, Gender.female])
            genderCode(g): genderLabel(l10n, g),
        }),
        legendLine('S', l10n.profileStatus, {
          for (final s in PublisherStatus.values)
            if (s != PublisherStatus.none) statusCode(s): statusLabel(l10n, s),
        }),
        legendLine('A', l10n.profileAppointment, {
          for (final a in [Appointment.elder, Appointment.ministerialServant])
            appointmentCode(a): appointmentLabel(l10n, a),
        }),
      ])
        pw.Text(line, style: const pw.TextStyle(fontSize: 7, color: _gray)),
    ],
  ));
  return doc.save();
}
