import 'dart:typed_data';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/pdf/pdf_fonts.dart';
import '../../core/utils/dates.dart';

/// One month's three figures on the sheet. All null when no meeting of that
/// kind was recorded in the month, which prints as a blank line — the same
/// thing an unfilled paper sheet shows.
class AttendanceRecordMonth {
  const AttendanceRecordMonth({this.meetings, this.total, this.average});

  final int? meetings;
  final int? total;
  final int? average;

  bool get isEmpty => meetings == null;
}

/// One service year's block: twelve months, September first, plus the figure
/// printed on the year line beneath them.
class AttendanceRecordYear {
  const AttendanceRecordYear({
    required this.serviceYear,
    required this.months,
    this.yearAverage,
  });

  final int serviceYear;
  final List<AttendanceRecordMonth> months;

  /// Σ attendance ÷ Σ meetings across the year, so the year figure sits on the
  /// same basis as the monthly averages above it. Null when the year is empty.
  final int? yearAverage;
}

/// Rolls one service year of [entries] up into the block printed for
/// [meetingType].
///
/// Only entries that carry a number are counted, so the three columns always
/// agree with each other (`average = total ÷ meetings`) — the same basis
/// `computeS1` uses. In-person and online are always combined, as everywhere
/// else in the app.
@visibleForTesting
AttendanceRecordYear attendanceRecordYear({
  required List<AttendanceEntry> entries,
  required int serviceYear,
  required MeetingType meetingType,
}) {
  final byMonth = <String, List<AttendanceEntry>>{};
  for (final entry in entries) {
    if (entry.meetingType != meetingType ||
        !entry.hasData ||
        entry.date.length < 7) {
      continue;
    }
    byMonth.putIfAbsent(entry.date.substring(0, 7), () => []).add(entry);
  }

  var totalSum = 0;
  var meetingSum = 0;
  final months = <AttendanceRecordMonth>[];
  for (final month in serviceYearMonths(serviceYear)) {
    final recorded = byMonth[month] ?? const <AttendanceEntry>[];
    if (recorded.isEmpty) {
      months.add(const AttendanceRecordMonth());
      continue;
    }
    final total = recorded.fold<int>(0, (sum, e) => sum + e.resolvedTotal);
    totalSum += total;
    meetingSum += recorded.length;
    months.add(
      AttendanceRecordMonth(
        meetings: recorded.length,
        total: total,
        average: (total / recorded.length).round(),
      ),
    );
  }

  return AttendanceRecordYear(
    serviceYear: serviceYear,
    months: months,
    yearAverage: meetingSum == 0 ? null : (totalSum / meetingSum).round(),
  );
}

const _grid = pw.BorderSide(width: 0.5);

/// Builds the congregation meeting attendance record: one portrait A4 page
/// holding both meetings, each with a block per entry of [serviceYears]
/// printed side by side (oldest first), exactly as the official sheet does.
///
/// The sheet deliberately carries **no official form code** anywhere — not in
/// the title, not as a footer. Do not add one.
Future<Uint8List> buildAttendanceRecordPdf({
  required List<AttendanceEntry> entries,
  required List<int> serviceYears,
  required AppLocalizations l10n,
  required String locale,
  required PdfFonts fonts,
}) async {
  final monthFmt = DateFormat('LLLL', locale);

  // Matches the S-21 export: several languages print the month capitalized on
  // the form where CLDR gives it lowercase.
  String monthName(String monthKey) {
    final name = monthFmt.format(parseMonthKey(monthKey));
    return name.isEmpty ? name : name[0].toUpperCase() + name.substring(1);
  }

  pw.Widget cell(
    String text, {
    bool bold = false,
    pw.TextAlign align = pw.TextAlign.left,
    double size = 7,
    int maxLines = 2,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 3),
        child: pw.Text(
          text,
          textAlign: align,
          maxLines: maxLines,
          style: pw.TextStyle(
            fontSize: size,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      );

  /// A column heading. Small and allowed four lines: the two blocks share a
  /// portrait page, and German, Polish and Italian all spell these out at
  /// length — a heading that ran out of lines would break mid-word.
  pw.Widget headCell(String text) =>
      cell(text, bold: true, align: pw.TextAlign.center, size: 6, maxLines: 4);

  String figure(int? value) => value?.toString() ?? '';

  /// One service year of one meeting: the twelve month lines, then the year
  /// line. The year line is a table of its own so its label can run under the
  /// three columns the way the official sheet prints it.
  pw.Widget yearBlock(AttendanceRecordYear year) {
    final months = serviceYearMonths(year.serviceYear);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Table(
          border: const pw.TableBorder(
            top: _grid,
            left: _grid,
            right: _grid,
            bottom: _grid,
            horizontalInside: _grid,
            verticalInside: _grid,
          ),
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
          // The month names need far less room than the headings above the
          // three figure columns, so the width goes to those.
          columnWidths: const {
            0: pw.FlexColumnWidth(2.2),
            1: pw.FlexColumnWidth(1.9),
            2: pw.FlexColumnWidth(1.9),
            3: pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              children: [
                cell(l10n.serviceYear(year.serviceYear), bold: true, size: 6.5),
                headCell(l10n.attRecordColMeetings),
                headCell(l10n.attRecordColTotal),
                headCell(l10n.attRecordColAvgWeek),
              ],
            ),
            for (var i = 0; i < months.length; i++)
              pw.TableRow(
                children: [
                  cell(monthName(months[i])),
                  cell(
                    figure(year.months[i].meetings),
                    align: pw.TextAlign.center,
                  ),
                  cell(
                    figure(year.months[i].total),
                    align: pw.TextAlign.center,
                  ),
                  cell(
                    figure(year.months[i].average),
                    align: pw.TextAlign.center,
                  ),
                ],
              ),
          ],
        ),
        pw.Table(
          // No top edge: the month table's bottom is already there.
          border: const pw.TableBorder(
            left: _grid,
            right: _grid,
            bottom: _grid,
            verticalInside: _grid,
          ),
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
          // The label runs under the three columns to its left, as printed.
          columnWidths: const {
            0: pw.FlexColumnWidth(6),
            1: pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              children: [
                cell(l10n.attRecordRowAvgMonth, bold: true, size: 6.5),
                cell(
                  figure(year.yearAverage),
                  bold: true,
                  align: pw.TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// One meeting: its name, then a block per service year side by side.
  pw.Widget meetingSection(String title, MeetingType type) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (final year in serviceYears) ...[
                if (year != serviceYears.first) pw.SizedBox(width: 12),
                pw.Expanded(
                  child: yearBlock(
                    attendanceRecordYear(
                      entries: entries,
                      serviceYear: year,
                      meetingType: type,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      );

  final doc = pw.Document();
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      theme: pw.ThemeData.withFont(
        base: fonts.base,
        bold: fonts.bold,
        fontFallback: fonts.fallback,
      ),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Center(
            child: pw.Text(
              l10n.attRecordTitle,
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 14),
          meetingSection(l10n.attMeetingLmm, MeetingType.lmm),
          pw.SizedBox(height: 16),
          meetingSection(l10n.attMeetingWeekend, MeetingType.weekend),
        ],
      ),
    ),
  );
  return doc.save();
}
