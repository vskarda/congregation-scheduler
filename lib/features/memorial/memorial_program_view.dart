import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/assignment_history.dart';
import '../../core/data/attendance_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/assignment_chips.dart';
import '../../core/widgets/assignment_editor.dart';
import '../songs/song_editor.dart';

/// The Memorial program, rendered inside whichever meeting week it replaces —
/// the midweek and the weekend view build the very same widget, because the
/// Memorial is one program that can fall on either day.
///
/// Attendants and audio/video are not here: they are the week's own support
/// slots, rendered below this card by the screen (see `SupportAssignmentsCard`).
///
/// None of the four name slots filters the publisher picker. The Memorial
/// talk is given by a visiting speaker as often as not, and the picker's
/// free-text mode is what such an entry uses.
class MemorialProgramView extends ConsumerWidget {
  const MemorialProgramView({
    super.key,
    required this.program,
    required this.canEdit,
    required this.showNames,
    required this.date,
    required this.onChanged,
  });

  final MemorialProgram program;
  final bool canEdit;

  /// False for a publisher on a week switched off: both songs still render,
  /// the name rows do not.
  final bool showNames;

  /// Calendar date the Memorial is held on (the week's meeting date, moved by
  /// the week's own weekday override); forwarded to the picker so it can flag
  /// publishers who are away.
  final DateTime? date;

  final Future<void> Function(MemorialProgram) onChanged;

  Future<void> _editOpeningSong(BuildContext context) async {
    final result = await showSongEditor(
      context,
      dialogTitle: context.l10n.songLabel,
      songNo: program.openingSongNo,
      songTitle: program.openingSongTitle,
    );
    if (result != null) {
      await onChanged(program.copyWith(
        openingSongNo: result.songNo,
        openingSongTitle: result.title,
      ));
    }
  }

  Future<void> _editClosingSong(BuildContext context) async {
    final result = await showSongEditor(
      context,
      dialogTitle: context.l10n.songLabel,
      songNo: program.closingSongNo,
      songTitle: program.closingSongTitle,
    );
    if (result != null) {
      await onChanged(program.copyWith(
        closingSongNo: result.songNo,
        closingSongTitle: result.title,
      ));
    }
  }

  Future<void> _edit(
    BuildContext context, {
    required String title,
    required Assignment initial,
    required String historyKey,
    required MemorialProgram Function(Assignment) apply,
  }) async {
    final result = await showAssignmentEditor(
      context,
      title: title,
      initial: initial,
      historyKey: historyKey,
      qualifies: (_) => true,
      date: date,
    );
    if (result != null) await onChanged(apply(result));
  }

  Future<void> _addCustomField(BuildContext context) async {
    final l10n = context.l10n;
    final ctrl = TextEditingController();
    final label = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.customFieldAdd),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.customLabel),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.commonCancel)),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(ctrl.text.trim()),
              child: Text(l10n.commonAdd)),
        ],
      ),
    );
    ctrl.dispose();
    if (label == null || label.isEmpty) return;
    await onChanged(program.copyWith(
      customFields: [...program.customFields, CustomAssignment(label: label)],
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    Widget assignmentRow({
      required String label,
      required Assignment assignment,
      required String historyKey,
      required MemorialProgram Function(Assignment) apply,
      VoidCallback? onDelete,
    }) =>
        ListTile(
          dense: true,
          title: Text(label),
          subtitle: AssignmentText(assignment),
          onTap: canEdit
              ? () => _edit(context,
                  title: label,
                  initial: assignment,
                  historyKey: historyKey,
                  apply: apply)
              : null,
          trailing: onDelete != null && canEdit
              ? IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: onDelete)
              : null,
        );

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            leading: const Icon(Icons.wine_bar_outlined),
            title: Text(l10n.programKindMemorial,
                style: theme.textTheme.titleMedium),
          ),
          ListTile(
            dense: true,
            title: Text(l10n.songLabel),
            subtitle: Text(songDisplayText(
                program.openingSongNo, program.openingSongTitle)),
            onTap: canEdit ? () => _editOpeningSong(context) : null,
          ),
          // Every row below but the closing song carries a name and nothing
          // else: a week switched off keeps the Memorial heading and both
          // songs, and drops only the assignments in between.
          if (showNames) ...[
            assignmentRow(
              label: l10n.partChairman,
              assignment: program.chairman,
              historyKey: HistoryKeys.memorialChairman,
              apply: (a) => program.copyWith(chairman: a),
            ),
            assignmentRow(
              label: l10n.weekendSpeaker,
              assignment: program.speaker,
              historyKey: HistoryKeys.memorialSpeaker,
              apply: (a) => program.copyWith(speaker: a),
            ),
            assignmentRow(
              label: l10n.memorialBreadPrayer,
              assignment: program.breadPrayer,
              historyKey: HistoryKeys.memorialBreadPrayer,
              apply: (a) => program.copyWith(breadPrayer: a),
            ),
            assignmentRow(
              label: l10n.memorialWinePrayer,
              assignment: program.winePrayer,
              historyKey: HistoryKeys.memorialWinePrayer,
              apply: (a) => program.copyWith(winePrayer: a),
            ),
            for (var i = 0; i < program.customFields.length; i++)
              assignmentRow(
                label: program.customFields[i].label,
                assignment: program.customFields[i].assignment,
                historyKey: HistoryKeys.custom,
                apply: (a) {
                  final updated = [...program.customFields];
                  updated[i] = updated[i].copyWith(assignment: a);
                  return program.copyWith(customFields: updated);
                },
                onDelete: () {
                  final updated = [...program.customFields]..removeAt(i);
                  onChanged(program.copyWith(customFields: updated));
                },
              ),
          ],
          // Outside the names block, like the opening song: the closing song
          // carries no name and stays visible on a week switched off.
          ListTile(
            dense: true,
            title: Text(l10n.songLabel),
            subtitle: Text(songDisplayText(
                program.closingSongNo, program.closingSongTitle)),
            onTap: canEdit ? () => _editClosingSong(context) : null,
          ),
          if (canEdit)
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton.icon(
                onPressed: () => _addCustomField(context),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.customFieldAdd),
              ),
            ),
        ],
      ),
    );
  }
}

/// The attendance recorded at earlier Memorials, newest first.
///
/// Memorial counts live in the `attendance` collection like every other
/// meeting's, so they can be entered and corrected the same way — they are
/// simply never one of [kCountedMeetingTypes], so no midweek or weekend
/// average, no S-1 and no S-88 record sheet ever sees them. This card is
/// where they are read instead.
class MemorialAttendanceHistory extends ConsumerWidget {
  const MemorialAttendanceHistory({super.key, this.excludeDate});

  /// The Memorial currently on screen; its own count is shown by the record
  /// card above, so it is left out of the history below it.
  final String? excludeDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    // The role check must come before watching the entries: firestore.rules
    // grants attendance reads to the two attendance roles only, so listening
    // unconditionally would fail for every other publisher opening the week.
    if (!ref.watch(effectiveRolesProvider).canRecordAttendance()) {
      return const SizedBox.shrink();
    }
    final past = [
      for (final e in ref.watch(memorialAttendanceProvider).value ?? const [])
        if (e.date != excludeDate && e.hasData) e,
    ];
    if (past.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(l10n.memorialPastTitle,
                style: theme.textTheme.titleMedium),
          ),
          for (final entry in past)
            ListTile(
              dense: true,
              title: Text(DateFormat.yMMMd(locale)
                  .format(parseDateKey(entry.date))),
              trailing: Text('${entry.resolvedTotal}',
                  style: theme.textTheme.titleMedium),
            ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

/// Every recorded Memorial count, newest first. Unbounded by design: a
/// congregation holds one Memorial a year, so the whole set is a handful of
/// documents and every one of them is worth keeping on show.
final memorialAttendanceProvider = StreamProvider<List<AttendanceEntry>>(
    (ref) => ref
        .watch(attendanceRepositoryProvider)
        .watchOfType(MeetingType.memorial));
