import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/pdf/pdf_fonts.dart';
import '../../core/utils/assignment_names.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/meeting_week_override.dart';

const _gray = PdfColor.fromInt(0xFF757575);

/// The visit schedule as a printable sheet: every section in view order, each
/// row with its day, time, who is arranged for it, where, and any note.
///
/// [includeHidden] prints the sections the admin has hidden from publishers
/// too — an elders' copy of the same week.
///
/// Section labels must match the ones on screen, so both take them from
/// [coSectionLabel]; the caller passes it in rather than this file importing
/// the dialog it lives next to.
Future<Uint8List> buildCoVisitPdf({
  required String weekId,
  required CoVisit visit,
  required List<FsmMeeting> ministryMeetings,
  required Map<String, Publisher> publishersById,
  required String congregationName,
  required int midweekWeekday,
  required String midweekTime,
  required int weekendWeekday,
  required String weekendTime,
  required bool includeHidden,
  required String Function(CoVisitSection) sectionLabel,
  required AppLocalizations l10n,
  required String locale,
  required PdfFonts fonts,
}) async {
  final monday = parseDateKey(weekId);
  final dayFmt = DateFormat.MMMEd(locale);
  final rangeFmt = DateFormat.MMMd(locale);

  String names(Assignment a) => formatAssignmentNames(a, publishersById);

  pw.Widget row({
    required String date,
    required String time,
    required List<String> lines,
  }) {
    final day = tryParseDateKey(date);
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 96,
            child: pw.Text(
              [
                if (day != null) dayFmt.format(day),
                if (time.isNotEmpty) time,
              ].join('  '),
              style: const pw.TextStyle(fontSize: 9),
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                for (final line in lines)
                  pw.Text(line, style: const pw.TextStyle(fontSize: 9)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final widgets = <pw.Widget>[
    pw.Text(l10n.eventTypeCoVisit,
        style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
    pw.SizedBox(height: 2),
    pw.Text(
      [
        if (congregationName.isNotEmpty) congregationName,
        '${rangeFmt.format(CoVisit.startOf(monday))} – '
            '${rangeFmt.format(CoVisit.endOf(monday))} '
            '${CoVisit.endOf(monday).year}',
      ].join('  ·  '),
      style: const pw.TextStyle(fontSize: 10, color: _gray),
    ),
    pw.SizedBox(height: 6),
    // The meeting days of the visit week, which is the point of printing it:
    // the midweek meeting normally moves to Tuesday.
    pw.Text(
      '${l10n.settingsLmmMeeting}: '
      '${weekdayName(locale, midweekWeekday)} $midweekTime    '
      '${l10n.settingsWeekendMeeting}: '
      '${weekdayName(locale, weekendWeekday)} $weekendTime',
      style: const pw.TextStyle(fontSize: 9, color: _gray),
    ),
    pw.SizedBox(height: 10),
  ];

  for (final section in CoVisitSection.values) {
    if (!includeHidden && visit.isHidden(section)) continue;

    final rows = <pw.Widget>[];
    if (section == CoVisitSection.ministry) {
      for (final meeting in ministryMeetings) {
        rows.add(row(
          date: meeting.date,
          time: meeting.time,
          lines: [
            if (meeting.location.isNotEmpty) meeting.location,
            if (meeting.assignment.isNotEmpty)
              '${l10n.fsmConductor}: ${names(meeting.assignment)}',
            if (meeting.withCo.isNotEmpty)
              '${l10n.coWithCo}: ${names(meeting.withCo)}',
            if (meeting.withCoWife.isNotEmpty)
              '${l10n.coWithCoWife}: ${names(meeting.withCoWife)}',
            if (meeting.note.isNotEmpty) meeting.note,
          ],
        ));
      }
    } else {
      for (final item in visit.itemsOf(section)) {
        rows.add(row(
          date: item.date,
          time: item.time,
          lines: [
            if (item.assignment.isNotEmpty) names(item.assignment),
            if (item.address.isNotEmpty) item.address,
            if (item.note.isNotEmpty) item.note,
          ],
        ));
      }
    }

    widgets.add(pw.Container(
      margin: const pw.EdgeInsets.only(top: 6, bottom: 4),
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      color: const PdfColor.fromInt(0xFFEEEEEE),
      child: pw.Text(sectionLabel(section),
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
    ));
    if (rows.isEmpty) {
      widgets.add(pw.Padding(
        padding: const pw.EdgeInsets.only(left: 6, bottom: 4),
        child: pw.Text(l10n.coSectionEmpty,
            style: const pw.TextStyle(fontSize: 9, color: _gray)),
      ));
    } else {
      widgets.addAll(rows);
    }
  }

  final doc = pw.Document();
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    theme: pw.ThemeData.withFont(
        base: fonts.base, bold: fonts.bold, fontFallback: fonts.fallback),
    build: (_) => widgets,
  ));
  return doc.save();
}
