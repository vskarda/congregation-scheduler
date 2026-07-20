import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/l10n/enum_labels.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/pdf/pdf_fonts.dart';
import '../../core/utils/assignment_names.dart';
import '../../core/utils/dates.dart';
import '../songs/song_editor.dart' show songDisplayText;
import 'lmm_screen.dart' show lmmClassLabel, lmmPartDefaultLabel;

// Section accent colors matching the in-app schedule view.
PdfColor _sectionColor(LmmSection s) => switch (s) {
      LmmSection.treasures => const PdfColor.fromInt(0xFF2F6B77),
      LmmSection.ministry => const PdfColor.fromInt(0xFF9C6F19),
      LmmSection.living => const PdfColor.fromInt(0xFF8E2E33),
      _ => const PdfColor.fromInt(0xFF5C6BC0),
    };

const _gray = PdfColor.fromInt(0xFF757575);

/// Builds a month-overview PDF of the Life and Ministry meeting: one block
/// per week (Mondays of [month]), localized to [locale]. Weeks without a
/// schedule document appear with a "no schedule" note.
Future<Uint8List> buildLmmMonthPdf({
  required DateTime month,
  required List<DateTime> mondays,
  required Map<String, LmmWeek> weeksById,
  required Map<String, Publisher> publishersById,
  required int classCount,
  required List<CustomAssignment> permanentAssignments,
  required AppLocalizations l10n,
  required String locale,
  required PdfFonts fonts,
}) async {
  final monthFmt = DateFormat('LLLL yyyy', locale);
  final dayFmt = DateFormat.MMMd(locale);

  String names(Assignment a) => formatAssignmentNames(a, publishersById);

  // Assignee text of one part: per-class lines for student parts when more
  // than one class is configured, assistant appended where assigned.
  pw.Widget assignees(LmmPart part) {
    String line(int classIndex) {
      final main = names(part.assignmentFor(classIndex));
      final assistant = part.assistantFor(classIndex);
      return assistant.isEmpty
          ? main
          : '$main (${l10n.partAssistant}: ${names(assistant)})';
    }

    if (part.isStudentPart && classCount > 1) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          for (var c = 1; c <= classCount; c++)
            pw.Text('${lmmClassLabel(l10n, c)}: ${line(c)}',
                style: const pw.TextStyle(fontSize: 9)),
        ],
      );
    }
    return pw.Text(line(1), style: const pw.TextStyle(fontSize: 9));
  }

  pw.Widget partRow(LmmPart part) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 3),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 38,
              child: pw.Text(
                part.durationMin == null
                    ? ''
                    : l10n.partMinutes(part.durationMin!),
                style: const pw.TextStyle(fontSize: 8, color: _gray),
                textAlign: pw.TextAlign.right,
              ),
            ),
            pw.SizedBox(width: 6),
            pw.Expanded(
              flex: 3,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(lmmPartDefaultLabel(l10n, part),
                      style: const pw.TextStyle(fontSize: 9)),
                  if (part.description.isNotEmpty)
                    pw.Text(part.description,
                        style: const pw.TextStyle(fontSize: 7, color: _gray)),
                ],
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(flex: 2, child: assignees(part)),
          ],
        ),
      );

  pw.Widget supportRow(String label, Assignment assignment) => pw.Padding(
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
              child: pw.Text(names(assignment),
                  style: const pw.TextStyle(fontSize: 9)),
            ),
          ],
        ),
      );

  // Flat widget list so MultiPage can break pages between rows; a whole week
  // wrapped in one Column could overflow a page and fail to lay out.
  final widgets = <pw.Widget>[
    pw.Text('${l10n.lmmScheduleTitle} — ${monthFmt.format(month)}',
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
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(range,
                style: pw.TextStyle(
                    fontSize: 11, fontWeight: pw.FontWeight.bold)),
          ),
          if (week != null && week.weekLabel.isNotEmpty)
            pw.Text(week.weekLabel,
                style: const pw.TextStyle(fontSize: 9, color: _gray)),
        ],
      ),
    ));

    if (week == null) {
      widgets.add(pw.Padding(
        padding: const pw.EdgeInsets.only(left: 6, bottom: 6),
        child: pw.Text(l10n.weekNoSchedule,
            style: const pw.TextStyle(fontSize: 9, color: _gray)),
      ));
      continue;
    }

    pw.Widget songLine(int? no, String title) => pw.Padding(
          padding: const pw.EdgeInsets.only(left: 6, top: 2, bottom: 2),
          child: pw.Text('${l10n.songLabel}: ${songDisplayText(no, title)}',
              style: const pw.TextStyle(fontSize: 9, color: _gray)),
        );

    for (final section in LmmSection.values) {
      // Opening song sits above the Treasures heading, mirroring the schedule
      // view and the S-140 form.
      if (section == LmmSection.treasures &&
          (week.openingSongNo != null || week.openingSongTitle.isNotEmpty)) {
        widgets.add(songLine(week.openingSongNo, week.openingSongTitle));
      }

      final parts = week.parts.where((p) => p.section == section).toList();
      if (parts.isEmpty) continue;
      widgets.add(pw.Padding(
        padding: const pw.EdgeInsets.only(top: 3, bottom: 2),
        child: pw.Text(lmmSectionLabel(l10n, section),
            style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: _sectionColor(section))),
      ));
      // Living / closing songs sit right below their section headings.
      if (section == LmmSection.living &&
          (week.livingSongNo != null || week.livingSongTitle.isNotEmpty)) {
        widgets.add(songLine(week.livingSongNo, week.livingSongTitle));
      } else if (section == LmmSection.closing &&
          (week.closingSongNo != null || week.closingSongTitle.isNotEmpty)) {
        widgets.add(songLine(week.closingSongNo, week.closingSongTitle));
      }
      widgets.addAll(parts.map(partRow));
    }

    widgets.add(pw.SizedBox(height: 3));
    widgets.add(supportRow(l10n.supportAttendants, week.attendants));
    widgets.add(supportRow(l10n.supportMicrophones, week.microphones));
    widgets.add(supportRow(l10n.supportAudioVideo, week.audioVideo));
    // Permanent (every-week) custom assignments: label from the config, the
    // assignee merged in from this week by id (blank when unassigned).
    for (final template in permanentAssignments) {
      final assignment = week.customAssignments
          .firstWhere(
            (c) => c.id == template.id,
            orElse: () => const CustomAssignment(),
          )
          .assignment;
      widgets.add(supportRow(template.label, assignment));
    }
    for (final custom in week.customAssignments) {
      if (custom.id.isEmpty) {
        widgets.add(supportRow(custom.label, custom.assignment));
      }
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
