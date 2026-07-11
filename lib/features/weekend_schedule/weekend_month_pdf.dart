import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/pdf/pdf_fonts.dart';
import '../../core/utils/assignment_names.dart';
import '../../core/utils/dates.dart';

const _gray = PdfColor.fromInt(0xFF757575);

/// Builds a month-overview PDF of the weekend meeting: one label/value block
/// per week (Mondays of [month]), localized to [locale]. Weeks without a
/// schedule document appear with a "no schedule" note.
Future<Uint8List> buildWeekendMonthPdf({
  required DateTime month,
  required List<DateTime> mondays,
  required Map<String, WeekendWeek> weeksById,
  required Map<String, Publisher> publishersById,
  required AppLocalizations l10n,
  required String locale,
  required PdfFonts fonts,
}) async {
  final monthFmt = DateFormat('LLLL yyyy', locale);
  final dayFmt = DateFormat.MMMd(locale);

  pw.Widget row(String label, String value) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 2),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 130,
              child: pw.Text(label,
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Expanded(
              child: pw.Text(value, style: const pw.TextStyle(fontSize: 9)),
            ),
          ],
        ),
      );

  pw.Widget assignmentRow(String label, Assignment assignment) =>
      row(label, formatAssignmentNames(assignment, publishersById));

  // Flat widget list so MultiPage can break pages between rows; a whole week
  // wrapped in one Column could overflow a page and fail to lay out.
  final widgets = <pw.Widget>[
    pw.Text('${l10n.navWeekend} — ${monthFmt.format(month)}',
        style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
    pw.SizedBox(height: 10),
  ];

  for (final monday in mondays) {
    final week = weeksById[dateKey(monday)];
    final sunday = DateTime(monday.year, monday.month, monday.day + 6);
    final range = '${dayFmt.format(monday)} – ${dayFmt.format(sunday)}';

    widgets.add(pw.Container(
      margin: const pw.EdgeInsets.only(top: 6, bottom: 4),
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      color: const PdfColor.fromInt(0xFFEEEEEE),
      child: pw.Text(range,
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
    ));

    if (week == null) {
      widgets.add(pw.Padding(
        padding: const pw.EdgeInsets.only(left: 6, bottom: 6),
        child: pw.Text(l10n.weekNoSchedule,
            style: const pw.TextStyle(fontSize: 9, color: _gray)),
      ));
      continue;
    }

    final talk = week.talkTitle.isEmpty
        ? '—'
        : week.talkNo == null
            ? week.talkTitle
            : '${week.talkNo}. ${week.talkTitle}';
    widgets.add(row(l10n.weekendTalkTitle, talk));
    widgets.add(assignmentRow(l10n.weekendSpeaker, week.speaker));
    widgets.add(assignmentRow(l10n.weekendChairmanLabel, week.chairman));
    widgets.add(assignmentRow(l10n.weekendWtReader, week.wtReader));
    for (final custom in week.customFields) {
      widgets.add(assignmentRow(custom.label, custom.assignment));
    }
    widgets.add(pw.SizedBox(height: 3));
    widgets.add(assignmentRow(l10n.supportAttendants, week.attendants));
    widgets.add(assignmentRow(l10n.supportMicrophones, week.microphones));
    widgets.add(assignmentRow(l10n.supportAudioVideo, week.audioVideo));
    for (final custom in week.customAssignments) {
      widgets.add(assignmentRow(custom.label, custom.assignment));
    }
  }

  final doc = pw.Document();
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    theme: pw.ThemeData.withFont(base: fonts.base, bold: fonts.bold),
    build: (_) => widgets,
  ));
  return doc.save();
}
