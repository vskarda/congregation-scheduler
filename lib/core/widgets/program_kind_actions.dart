import 'package:flutter/material.dart';

import '../l10n/enum_labels.dart';
import '../l10n/l10n.dart';
import '../models/models.dart';

// Choosing which program a week's meeting runs, shared by the midweek and the
// weekend view — a Memorial or an assembly week looks the same from either
// side, and both are one field on the week document (MeetingProgramKind).

/// What the week's overflow menu can do.
enum WeekMenuAction { nothingPlanned, memorial, restoreProgram, editNote, delete }

/// The overflow-menu entries for a week currently running [kind]: the two
/// program kinds it is not on, the way back to the regular program, and the
/// note that replaces the program when nothing is planned.
/// [canDelete] is false for an admin who only holds the *other* meeting
/// role and is here for the Memorial: deleting the week would take the whole
/// schedule with it, which firestore.rules keeps with the schedule's own role.
List<PopupMenuEntry<WeekMenuAction>> weekMenuItems(
  AppLocalizations l10n,
  MeetingProgramKind kind, {
  bool canDelete = true,
}) =>
    [
      if (kind != MeetingProgramKind.nothingPlanned)
        PopupMenuItem(
          value: WeekMenuAction.nothingPlanned,
          child: Text(l10n.programKindNothingPlanned),
        ),
      if (kind == MeetingProgramKind.nothingPlanned)
        PopupMenuItem(
          value: WeekMenuAction.editNote,
          child: Text(l10n.weekNoteEdit),
        ),
      if (kind != MeetingProgramKind.memorial)
        PopupMenuItem(
          value: WeekMenuAction.memorial,
          child: Text(l10n.programKindMemorial),
        ),
      if (kind != MeetingProgramKind.regular)
        PopupMenuItem(
          value: WeekMenuAction.restoreProgram,
          child: Text(l10n.weekRestoreProgram),
        ),
      if (canDelete) ...[
        const PopupMenuDivider(),
        PopupMenuItem(
          value: WeekMenuAction.delete,
          child: Text(l10n.weekDelete),
        ),
      ],
    ];

/// Confirms switching a week to [to]. Says plainly that nothing is lost —
/// the program the week runs today stays in the document either way.
Future<bool> confirmProgramSwitch(
  BuildContext context,
  MeetingProgramKind to,
) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(programKindLabel(l10n, to)),
      content: Text(l10n.weekProgramSwitchConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.commonSave),
        ),
      ],
    ),
  );
  return confirmed == true;
}

/// Edits the note publishers are shown instead of the program. Returns null
/// when cancelled; an empty string is a deliberate "clear the note".
Future<String?> showProgramNoteDialog(
  BuildContext context, {
  required String initial,
}) async {
  final l10n = context.l10n;
  final ctrl = TextEditingController(text: initial);
  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.weekNoteLabel),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        minLines: 2,
        maxLines: 5,
        decoration: InputDecoration(hintText: l10n.weekNothingPlannedHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(ctrl.text.trim()),
          child: Text(l10n.commonSave),
        ),
      ],
    ),
  );
  ctrl.dispose();
  return result;
}

/// What a week with nothing planned shows in place of its program: the
/// admin's note, or a plain "no meeting this week" when they wrote none.
///
/// This is all a publisher sees of such a week — no parts, no songs, no
/// support roles and no attendance, because none of it happens.
class NothingPlannedCard extends StatelessWidget {
  const NothingPlannedCard({
    super.key,
    required this.note,
    required this.canEdit,
    required this.onEditNote,
  });

  final String note;
  final bool canEdit;
  final VoidCallback onEditNote;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event_busy_outlined,
                    color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(l10n.programKindNothingPlanned,
                      style: theme.textTheme.titleMedium),
                ),
                if (canEdit)
                  IconButton(
                    tooltip: l10n.weekNoteEdit,
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    onPressed: onEditNote,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note.isEmpty ? l10n.weekNothingPlannedHint : note,
              style: note.isEmpty
                  ? theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)
                  : theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
