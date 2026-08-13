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

/// One thing happening during the visit, on its way onto the sheet.
class _Entry {
  const _Entry({required this.time, required this.type, this.lines = const []});

  /// HH:mm, or empty when no time has been settled on.
  final String time;

  /// What kind of thing this is — "Midday meals", "Shepherding visits",
  /// "Meetings for Field Service", "Midweek meeting". Always printed:
  /// grouped by day, a bare "12:00 J. Novák" would say nothing.
  final String type;

  /// Who, where, and any note — one per line under the type.
  final List<String> lines;
}

/// The visit as a printable calendar: the six days of the visit, Tuesday to
/// Sunday, each with what happens on it.
///
/// The week's midweek and weekend meetings are on it too — name and time
/// only, no program — because the visit is planned around them. A meeting
/// still held on the Monday is outside the visit and is left off.
///
/// [includeHidden] prints the sections hidden from publishers as well, for an
/// elders' copy of the same week. Arrangements that have no day yet are
/// collected at the end rather than dropped.
///
/// Section labels come from [sectionLabel] so the sheet and the screen cannot
/// disagree; the caller passes it in rather than this file reaching into the
/// screen it belongs to.
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
  final dayFmt = DateFormat.EEEE(locale);
  final dateFmt = DateFormat.MMMd(locale);

  String names(Assignment a) => formatAssignmentNames(a, publishersById);

  // date -> what happens that day. Days with nothing still get a heading:
  // an empty day is information on a calendar.
  final byDate = <String, List<_Entry>>{
    for (final day in CoVisit.daysOf(monday)) dateKey(day): [],
  };
  final undated = <_Entry>[];

  /// Files an arrangement under its day, or under "not scheduled yet" when it
  /// has no day (or one outside the visit) — nothing arranged may vanish off
  /// the sheet.
  void add(String date, _Entry entry) =>
      (byDate[date] ?? undated).add(entry);

  /// Files something that only makes sense on its own day: a congregation
  /// meeting still held before the visit begins is simply not part of it.
  void addOnDay(String date, _Entry entry) => byDate[date]?.add(entry);

  for (final section in CoVisitSection.values) {
    if (section == CoVisitSection.ministry) continue;
    if (!includeHidden && visit.isHidden(section)) continue;
    for (final item in visit.itemsOf(section)) {
      add(
        item.date,
        _Entry(
          time: item.time,
          type: sectionLabel(section),
          lines: [
            if (item.assignment.isNotEmpty) names(item.assignment),
            if (item.address.isNotEmpty) item.address,
            if (item.note.isNotEmpty) item.note,
          ],
        ),
      );
    }
  }

  if (includeHidden || !visit.isHidden(CoVisitSection.ministry)) {
    for (final meeting in ministryMeetings) {
      add(
        meeting.date,
        _Entry(
          time: meeting.time,
          type: sectionLabel(CoVisitSection.ministry),
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
        ),
      );
    }
  }

  // The two congregation meetings, with nothing but their name and time.
  for (final meeting in [
    (weekday: midweekWeekday, time: midweekTime, name: l10n.attMeetingLmm),
    (weekday: weekendWeekday, time: weekendTime, name: l10n.attMeetingWeekend),
  ]) {
    final date = meetingDateOf(weekId, meeting.weekday);
    if (date == null) continue;
    addOnDay(dateKey(date), _Entry(time: meeting.time, type: meeting.name));
  }

  for (final day in byDate.values) {
    day.sort((a, b) => _blankLast(a.time).compareTo(_blankLast(b.time)));
  }

  pw.Widget entryRow(_Entry entry) => pw.Padding(
        padding: const pw.EdgeInsets.only(left: 6, bottom: 4),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 40,
              child: pw.Text(entry.time,
                  style: const pw.TextStyle(fontSize: 9, color: _gray)),
            ),
            pw.SizedBox(width: 6),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(entry.type,
                      style: pw.TextStyle(
                          fontSize: 9, fontWeight: pw.FontWeight.bold)),
                  for (final line in entry.lines)
                    pw.Text(line, style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
            ),
          ],
        ),
      );

  pw.Widget heading(String text) => pw.Container(
        margin: const pw.EdgeInsets.only(top: 8, bottom: 4),
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        color: const PdfColor.fromInt(0xFFEEEEEE),
        child: pw.Text(text,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
      );

  // A flat widget list so MultiPage can break between rows; a whole day
  // wrapped in one Column could overflow a page and fail to lay out.
  final widgets = <pw.Widget>[
    pw.Text(l10n.eventTypeCoVisit,
        style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
    pw.SizedBox(height: 2),
    pw.Text(
      [
        if (congregationName.isNotEmpty) congregationName,
        '${dateFmt.format(CoVisit.startOf(monday))} – '
            '${dateFmt.format(CoVisit.endOf(monday))} '
            '${CoVisit.endOf(monday).year}',
      ].join('  ·  '),
      style: const pw.TextStyle(fontSize: 10, color: _gray),
    ),
  ];

  for (final day in CoVisit.daysOf(monday)) {
    final entries = byDate[dateKey(day)]!;
    widgets.add(
        heading('${dayFmt.format(day)}  ${dateFmt.format(day)}'));
    if (entries.isEmpty) {
      widgets.add(pw.Padding(
        padding: const pw.EdgeInsets.only(left: 6, bottom: 4),
        child: pw.Text('—',
            style: const pw.TextStyle(fontSize: 9, color: _gray)),
      ));
    } else {
      widgets.addAll(entries.map(entryRow));
    }
  }

  if (undated.isNotEmpty) {
    widgets.add(heading(l10n.coNotScheduledYet));
    widgets.addAll(undated.map(entryRow));
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

/// Sorts an entry without a time after the ones that have one.
String _blankLast(String value) => value.isEmpty ? '￿' : value;
