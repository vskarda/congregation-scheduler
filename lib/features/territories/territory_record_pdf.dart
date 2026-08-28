import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/pdf/pdf_fonts.dart';
import '../../core/utils/collation.dart';
import 'territory_holder.dart';

/// Assignment slots printed next to each other on one line of the sheet. The
/// official form prints four; a territory that went out more often continues
/// on a further line rather than losing assignments.
const territoryRecordSlots = 4;

/// One assignment printed in a slot: who held the territory and when. Dates
/// are the stored `yyyy-MM-dd` keys — formatting is the PDF's job, so the row
/// building stays locale-free and testable on its own.
class TerritorySlot {
  const TerritorySlot({
    this.publisherName = '',
    this.assignedDate = '',
    this.completedDate = '',
  });

  final String publisherName;
  final String assignedDate;

  /// Empty while the territory is still out.
  final String completedDate;
}

/// One printed line of the sheet.
class TerritoryRecordRow {
  const TerritoryRecordRow({
    required this.territoryName,
    required this.lastCompleted,
    required this.slots,
  });

  final String territoryName;

  /// `yyyy-MM-dd` the territory was last completed *before* this service year,
  /// empty when it never was. Blank on a continuation line.
  final String lastCompleted;

  /// Always [territoryRecordSlots] entries, padded with empty slots.
  final List<TerritorySlot> slots;
}

/// Turns the roster of territories and their whole assignment history into the
/// lines of one service year's sheet.
///
/// Every existing territory gets a line whether or not it went out this year —
/// the sheet is a register of the congregation's territories, not a list of
/// this year's activity. Assignments are ordered oldest first, so the slots
/// read left to right in the order the territory actually went out.
@visibleForTesting
List<TerritoryRecordRow> territoryRecordRows({
  required List<Territory> territories,
  required List<TerritoryAssignment> assignments,
  required Map<String, Publisher> publishersById,
  required int serviceYear,
}) {
  // Service years run September..August; see serviceYearOf in core/utils/dates.
  final from = '${serviceYear - 1}-09-01';
  final to = '$serviceYear-08-31';
  final byTerritory = groupBy(
    assignments,
    (TerritoryAssignment a) => a.territoryId,
  );

  final rows = <TerritoryRecordRow>[];
  for (final territory in [
    ...territories,
  ]..sort((a, b) => collate(a.name, b.name))) {
    final own = byTerritory[territory.id] ?? const <TerritoryAssignment>[];

    // Only completions from before this sheet's year belong in the column;
    // the ones inside it are already printed in the slots.
    final lastCompleted = own
        .map((a) => a.returnedDate)
        .where((d) => d.isNotEmpty && d.compareTo(from) < 0)
        .fold<String>('', (best, d) => d.compareTo(best) > 0 ? d : best);

    // Assignments belong to the year they started in. One that began earlier
    // and was returned inside this year is not repeated here — its return
    // date is what the following year's "last date completed" picks up.
    final inYear = own
        .where(
          (a) =>
              a.assignedDate.isNotEmpty &&
              a.assignedDate.compareTo(from) >= 0 &&
              a.assignedDate.compareTo(to) <= 0,
        )
        .toList()
      ..sort((a, b) {
        final byDate = a.assignedDate.compareTo(b.assignedDate);
        return byDate != 0 ? byDate : a.id.compareTo(b.id);
      });

    final slots = [
      for (final a in inYear)
        TerritorySlot(
          // A publisher deleted before the name was kept leaves it blank; the
          // dates beside it still happened and stay on the sheet.
          publisherName: territoryHolderName(a, publishersById),
          assignedDate: a.assignedDate,
          completedDate: a.returnedDate,
        ),
    ];

    final lines = (slots.length / territoryRecordSlots).ceil();
    for (var line = 0; line < (lines == 0 ? 1 : lines); line++) {
      rows.add(
        TerritoryRecordRow(
          territoryName: territory.name,
          // As on paper, only the territory's first line carries the column.
          lastCompleted: line == 0 ? lastCompleted : '',
          slots: [
            for (var slot = 0; slot < territoryRecordSlots; slot++)
              () {
                final index = line * territoryRecordSlots + slot;
                return index < slots.length
                    ? slots[index]
                    : const TerritorySlot();
              }(),
          ],
        ),
      );
    }
  }
  return rows;
}

/// Hairline dividing the two halves of an assignment slot, and the two dates
/// inside its lower half. Thinner than the table's own grid, as printed.
const _hair = pw.BorderSide(width: 0.4);

/// Heights of the two halves of a territory line. Together with the hairline
/// between them they come to the ~31pt line the official sheet rules. Fixed,
/// so the sheet stays evenly ruled whatever the names in it are.
const _nameHeight = 15.5;
const _dateHeight = 13.0;

/// Builds the territory assignment record for [serviceYear]: a portrait A4
/// sheet with one line per territory, each carrying four assignment slots.
///
/// The sheet deliberately carries **no official form code** anywhere — not in
/// the title, not as a footer. Do not add one.
Future<Uint8List> buildTerritoryRecordPdf({
  required List<Territory> territories,
  required List<TerritoryAssignment> assignments,
  required Map<String, Publisher> publishersById,
  required int serviceYear,
  required AppLocalizations l10n,
  required String locale,
  required PdfFonts fonts,
}) async {
  final rows = territoryRecordRows(
    territories: territories,
    assignments: assignments,
    publishersById: publishersById,
    serviceYear: serviceYear,
  );
  final dateFmt = DateFormat.yMd(locale);

  String formatDate(String key) =>
      key.isEmpty ? '' : dateFmt.format(DateTime.parse(key));

  /// A header label. Left free to grow: several languages need three lines for
  /// "Date completed", and a header that overflowed would print on top of the
  /// first territory.
  pw.Widget headLabel(String text, {double size = 7}) => pw.Container(
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 1.5, vertical: 3),
        child: pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          maxLines: 3,
          style: pw.TextStyle(fontSize: size, fontWeight: pw.FontWeight.bold),
        ),
      );

  /// Half of an assignment slot on a territory line. The height is fixed, and
  /// a name too long for its slot is scaled down rather than wrapped — nothing
  /// may push a line taller than the ones around it.
  pw.Widget slotHalf(double height, String text, {double size = 7}) =>
      pw.Container(
        height: height,
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 2),
        // A blank slot is the sheet's normal state, and FittedBox cannot scale
        // an empty child — it has no width to scale from.
        child: text.isEmpty
            ? null
            : pw.FittedBox(
                fit: pw.BoxFit.scaleDown,
                child: pw.Text(
                  text,
                  maxLines: 1,
                  style: pw.TextStyle(fontSize: size),
                ),
              ),
      );

  /// The two columns on the left carry no divider of their own, so against the
  /// split slots beside them they read as one cell spanning the whole line.
  pw.Widget spanningCell(String text) => pw.Container(
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        child: pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          maxLines: 2,
          style: const pw.TextStyle(fontSize: 7.5),
        ),
      );

  /// An assignment slot: a name across the whole slot, the two dates beneath.
  /// The dates sit in a table of their own so the divider between them runs
  /// the full height of the half without the two cells agreeing on one.
  pw.Widget slotCell(
    pw.Widget name,
    pw.Widget assigned,
    pw.Widget completed,
  ) =>
      pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Container(
            decoration:
                const pw.BoxDecoration(border: pw.Border(bottom: _hair)),
            child: name,
          ),
          pw.Table(
            border: const pw.TableBorder(verticalInside: _hair),
            defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
            // Spelled out: a table left to itself sizes columns to their
            // content, which hands the wordier heading the room and breaks the
            // shorter one mid-word. The sheet rules them down the middle.
            columnWidths: const {
              0: pw.FlexColumnWidth(),
              1: pw.FlexColumnWidth()
            },
            children: [
              pw.TableRow(children: [assigned, completed]),
            ],
          ),
        ],
      );

  final headerRow = pw.TableRow(
    // Reprinted at the top of every page the sheet runs onto.
    repeat: true,
    children: [
      headLabel(l10n.terrRecordColTerritory, size: 7.5),
      headLabel(l10n.terrRecordColLastCompleted),
      for (var group = 0; group < territoryRecordSlots; group++)
        slotCell(
          headLabel(l10n.terrRecordColAssignedTo),
          headLabel(l10n.terrRecordColDateAssigned, size: 6),
          headLabel(l10n.terrRecordColDateCompleted, size: 6),
        ),
    ],
  );

  pw.TableRow dataRow(TerritoryRecordRow row) => pw.TableRow(
        children: [
          spanningCell(row.territoryName),
          spanningCell(formatDate(row.lastCompleted)),
          for (final slot in row.slots)
            slotCell(
              slotHalf(_nameHeight, slot.publisherName),
              slotHalf(_dateHeight, formatDate(slot.assignedDate)),
              slotHalf(_dateHeight, formatDate(slot.completedDate)),
            ),
        ],
      );

  final doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      theme: pw.ThemeData.withFont(
        base: fonts.base,
        bold: fonts.bold,
        fontFallback: fonts.fallback,
      ),
      build: (context) => [
        pw.Center(
          child: pw.Text(
            l10n.terrRecordTitle,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          l10n.serviceYear(serviceYear),
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
          // Proportions taken from the official sheet. The first column is
          // widened from its ~37pt — it carries the territory's name, and the
          // app has no separate territory number to print there — and the
          // second from its ~63pt, which Japanese overruns by a hair.
          columnWidths: const {
            0: pw.FlexColumnWidth(70),
            1: pw.FlexColumnWidth(66),
            2: pw.FlexColumnWidth(96.8),
            3: pw.FlexColumnWidth(96.8),
            4: pw.FlexColumnWidth(96.8),
            5: pw.FlexColumnWidth(96.8),
          },
          children: [headerRow, ...rows.map(dataRow)],
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          l10n.terrRecordFootnote,
          style: const pw.TextStyle(fontSize: 6.5),
        ),
      ],
    ),
  );
  return doc.save();
}
