import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/data/assignment_history.dart';
import '../../core/data/lmm_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/widgets/assignment_chips.dart';
import '../../core/widgets/assignment_editor.dart';
import '../../core/widgets/week_navigator.dart';
import 'epub_import/import_screen.dart';

class LmmScreen extends StatelessWidget {
  const LmmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WeekNavigator(
      contentBuilder: (context, weekId) => LmmWeekView(weekId: weekId),
    );
  }
}

Future<void> saveLmmWeek(WidgetRef ref, LmmWeek week) async {
  await ref.read(lmmRepositoryProvider).saveWeek(week);
  ref.invalidate(assignmentHistoryProvider);
}

String lmmPartDefaultLabel(AppLocalizations l10n, LmmPart part) {
  if (part.title.isNotEmpty) return part.title;
  return switch (part.type) {
    LmmPartType.chairman => l10n.partChairman,
    LmmPartType.prayer => part.section == LmmSection.opening
        ? l10n.partOpeningPrayer
        : l10n.partClosingPrayer,
    LmmPartType.gems => l10n.partGems,
    LmmPartType.bibleReading => l10n.partBibleReading,
    LmmPartType.cbsConductor => l10n.partCbs,
    LmmPartType.cbsReader => l10n.partCbsReader,
    _ => part.title,
  };
}

class LmmWeekView extends ConsumerWidget {
  const LmmWeekView({super.key, required this.weekId});

  final String weekId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final weekAsync = ref.watch(lmmWeekProvider(weekId));
    final canEdit = ref.watch(myRolesProvider).canEditLmm();

    return weekAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l10n.commonErrorDetail(e.toString()))),
      data: (week) => week == null
          ? _EmptyWeekView(weekId: weekId, canEdit: canEdit)
          : _WeekContent(week: week, canEdit: canEdit),
    );
  }
}

class _EmptyWeekView extends ConsumerWidget {
  const _EmptyWeekView({required this.weekId, required this.canEdit});

  final String weekId;
  final bool canEdit;

  static LmmWeek _skeleton(String weekId) {
    const uuid = Uuid();
    LmmPart part(LmmSection s, LmmPartType t, {int? min}) => LmmPart(
        id: uuid.v4(), section: s, type: t, durationMin: min);
    return LmmWeek(id: weekId, parts: [
      part(LmmSection.opening, LmmPartType.chairman),
      part(LmmSection.opening, LmmPartType.prayer),
      part(LmmSection.treasures, LmmPartType.treasures, min: 10),
      part(LmmSection.treasures, LmmPartType.gems, min: 10),
      part(LmmSection.treasures, LmmPartType.bibleReading, min: 4),
      part(LmmSection.living, LmmPartType.cbsConductor, min: 30),
      part(LmmSection.living, LmmPartType.cbsReader),
      part(LmmSection.closing, LmmPartType.prayer),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.weekNoSchedule),
          if (canEdit) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const EpubImportScreen())),
              icon: const Icon(Icons.file_open_outlined),
              label: Text(l10n.weekImportEpub),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => saveLmmWeek(ref, _skeleton(weekId)),
              icon: const Icon(Icons.add),
              label: Text(l10n.weekCreateEmpty),
            ),
          ],
        ],
      ),
    );
  }
}

class _WeekContent extends ConsumerWidget {
  const _WeekContent({required this.week, required this.canEdit});

  final LmmWeek week;
  final bool canEdit;

  static Color _sectionColor(LmmSection s) => switch (s) {
        LmmSection.treasures => const Color(0xFF2F6B77),
        LmmSection.ministry => const Color(0xFF9C6F19),
        LmmSection.living => const Color(0xFF8E2E33),
        _ => const Color(0xFF5C6BC0),
      };

  String _sectionLabel(AppLocalizations l10n, LmmSection s) => switch (s) {
        LmmSection.opening => l10n.sectionOpening,
        LmmSection.treasures => l10n.sectionTreasures,
        LmmSection.ministry => l10n.sectionMinistry,
        LmmSection.living => l10n.sectionLiving,
        LmmSection.closing => l10n.sectionClosing,
      };

  Future<void> _editSongs(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final ctrl = TextEditingController(text: week.songs.join(', '));
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.lmmSongs),
        content: TextField(controller: ctrl, autofocus: true),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel)),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.commonSave)),
        ],
      ),
    );
    if (saved == true) {
      final songs = ctrl.text
          .split(RegExp(r'[,;]'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      await saveLmmWeek(ref, week.copyWith(songs: songs));
    }
    ctrl.dispose();
  }

  Future<void> _confirmDeleteWeek(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.commonConfirmDeleteTitle),
        content: Text(l10n.commonConfirmDeleteBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel)),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.commonDelete)),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(lmmRepositoryProvider).deleteWeek(week.id);
      ref.invalidate(assignmentHistoryProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (week.weekLabel.isNotEmpty)
                    Text(week.weekLabel,
                        style: theme.textTheme.titleMedium),
                  if (week.songs.isNotEmpty || canEdit)
                    InkWell(
                      onTap: canEdit
                          ? () => _editSongs(context, ref, l10n)
                          : null,
                      child: Text(
                        '${l10n.lmmSongs}: '
                        '${week.songs.isEmpty ? '—' : week.songs.join(' · ')}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                ],
              ),
            ),
            if (canEdit)
              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'delete') _confirmDeleteWeek(context, ref, l10n);
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                      value: 'delete', child: Text(l10n.weekDelete)),
                ],
              ),
          ],
        ),
      ),
    ];

    for (final section in LmmSection.values) {
      final parts = week.parts.where((p) => p.section == section).toList();
      // Non-admins don't need empty sections; admins get them with an
      // add-part button.
      if (parts.isEmpty && !canEdit) continue;
      children.add(Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _sectionLabel(l10n, section),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: _sectionColor(section),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (canEdit)
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: l10n.partAdd,
                icon: const Icon(Icons.add, size: 18),
                onPressed: () => _addPart(context, ref, section),
              ),
          ],
        ),
      ));
      for (final part in parts) {
        children.add(_PartTile(week: week, part: part, canEdit: canEdit));
      }
    }

    children.add(_SupportCard(week: week, canEdit: canEdit));
    children.add(const SizedBox(height: 24));

    return ListView(children: children);
  }

  Future<void> _addPart(
      BuildContext context, WidgetRef ref, LmmSection section) async {
    final part = await showLmmPartDialog(context, section: section);
    if (part == null) return;
    // Insert after the last existing part of the same section.
    final parts = [...week.parts];
    var insertAt = parts.length;
    for (var i = parts.length - 1; i >= 0; i--) {
      if (parts[i].section == section) {
        insertAt = i + 1;
        break;
      }
    }
    if (insertAt == parts.length &&
        parts.every((p) => p.section != section)) {
      // No part of this section yet: keep global section order.
      final order = LmmSection.values.indexOf(section);
      insertAt = parts.indexWhere(
          (p) => LmmSection.values.indexOf(p.section) > order);
      if (insertAt < 0) insertAt = parts.length;
    }
    parts.insert(insertAt, part);
    await saveLmmWeek(ref, week.copyWith(parts: parts));
  }
}

/// Dialog for creating/editing a part (title, duration, type for new parts).
Future<LmmPart?> showLmmPartDialog(BuildContext context,
    {LmmPart? existing, LmmSection? section}) async {
  final l10n = context.l10n;
  final titleCtrl = TextEditingController(text: existing?.title ?? '');
  final descriptionCtrl =
      TextEditingController(text: existing?.description ?? '');
  final durationCtrl = TextEditingController(
      text: existing?.durationMin?.toString() ?? '');
  var type = existing?.type ??
      switch (section) {
        LmmSection.ministry => LmmPartType.fieldMinistry,
        LmmSection.living => LmmPartType.living,
        LmmSection.treasures => LmmPartType.treasures,
        _ => LmmPartType.custom,
      };

  final result = await showDialog<LmmPart>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(existing == null ? l10n.partAdd : l10n.partEdit),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (existing == null)
              DropdownButtonFormField<LmmPartType>(
                initialValue: type,
                decoration: InputDecoration(labelText: l10n.partEdit),
                items: [
                  for (final t in LmmPartType.values)
                    DropdownMenuItem(value: t, child: Text(t.name)),
                ],
                onChanged: (t) =>
                    setState(() => type = t ?? LmmPartType.custom),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: titleCtrl,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.partTitle),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionCtrl,
              decoration:
                  InputDecoration(labelText: l10n.partDescription),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: durationCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.partDuration),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.commonCancel)),
          FilledButton(
            onPressed: () {
              final base = existing ??
                  LmmPart(
                      id: const Uuid().v4(),
                      section: section ?? LmmSection.living,
                      type: type);
              Navigator.of(context).pop(base.copyWith(
                title: titleCtrl.text.trim(),
                description: descriptionCtrl.text.trim(),
                durationMin: int.tryParse(durationCtrl.text.trim()),
              ));
            },
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    ),
  );
  titleCtrl.dispose();
  descriptionCtrl.dispose();
  durationCtrl.dispose();
  return result;
}

class _PartTile extends ConsumerWidget {
  const _PartTile(
      {required this.week, required this.part, required this.canEdit});

  final LmmWeek week;
  final LmmPart part;
  final bool canEdit;

  Future<void> _assign(BuildContext context, WidgetRef ref,
      {required bool assistant}) async {
    final l10n = context.l10n;
    final label = lmmPartDefaultLabel(l10n, part);
    final result = await showAssignmentEditor(
      context,
      title: assistant ? '${l10n.partAssistant} — $label' : label,
      initial: assistant ? part.assistant : part.assignment,
      historyKey: assistant
          ? HistoryKeys.lmmAssistant
          : HistoryKeys.lmmPart(part.type),
      qualifies: (p) => assistant
          ? p.qualifications.fieldMinistry
          : p.qualifications.forLmmPartType(part.type),
    );
    if (result == null) return;
    final updated = assistant
        ? part.copyWith(assistant: result)
        : part.copyWith(assignment: result);
    await _saveVariant(ref, updated);
  }

  Future<void> _saveVariant(WidgetRef ref, LmmPart updated) async {
    final parts =
        week.parts.map((p) => p.id == updated.id ? updated : p).toList();
    await saveLmmWeek(ref, week.copyWith(parts: parts));
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.commonConfirmDeleteTitle),
        content: Text(l10n.partDeleteConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel)),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.commonDelete)),
        ],
      ),
    );
    if (confirmed == true) {
      await saveLmmWeek(
          ref,
          week.copyWith(
              parts: week.parts.where((p) => p.id != part.id).toList()));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isMinistryPart = part.type == LmmPartType.fieldMinistry;
    final showAssistant =
        isMinistryPart && (canEdit || part.assistant.isNotEmpty);

    return ListTile(
      dense: true,
      title: Text(lmmPartDefaultLabel(l10n, part)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (part.description.isNotEmpty)
            Text(part.description,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant)),
          AssignmentText(part.assignment),
          if (showAssistant)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${l10n.partAssistant}: ',
                    style: theme.textTheme.bodySmall),
                Flexible(
                    child: AssignmentText(part.assistant,
                        style: theme.textTheme.bodySmall)),
              ],
            ),
        ],
      ),
      leading: SizedBox(
        width: 48,
        child: Text(
          part.durationMin == null
              ? ''
              : l10n.partMinutes(part.durationMin!),
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.right,
        ),
      ),
      trailing: canEdit
          ? PopupMenuButton<String>(
              onSelected: (v) async {
                switch (v) {
                  case 'assign':
                    await _assign(context, ref, assistant: false);
                  case 'assistant':
                    await _assign(context, ref, assistant: true);
                  case 'edit':
                    final edited =
                        await showLmmPartDialog(context, existing: part);
                    if (edited != null) await _saveVariant(ref, edited);
                  case 'delete':
                    await _delete(context, ref);
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                    value: 'assign', child: Text(l10n.commonEdit)),
                if (isMinistryPart)
                  PopupMenuItem(
                      value: 'assistant',
                      child: Text(l10n.partAssistant)),
                PopupMenuItem(value: 'edit', child: Text(l10n.partEdit)),
                PopupMenuItem(
                    value: 'delete', child: Text(l10n.commonDelete)),
              ],
            )
          : null,
      onTap: canEdit ? () => _assign(context, ref, assistant: false) : null,
    );
  }
}

/// Attendants / microphones / audio-video / custom assignments; shared by
/// design with the weekend meeting via [SupportAssignmentsCard].
class _SupportCard extends ConsumerWidget {
  const _SupportCard({required this.week, required this.canEdit});

  final LmmWeek week;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SupportAssignmentsCard(
      canEdit: canEdit,
      attendants: week.attendants,
      microphones: week.microphones,
      audioVideo: week.audioVideo,
      customAssignments: week.customAssignments,
      onChanged: ({
        attendants,
        microphones,
        audioVideo,
        customAssignments,
      }) =>
          saveLmmWeek(
        ref,
        week.copyWith(
          attendants: attendants ?? week.attendants,
          microphones: microphones ?? week.microphones,
          audioVideo: audioVideo ?? week.audioVideo,
          customAssignments: customAssignments ?? week.customAssignments,
        ),
      ),
    );
  }
}

/// Reusable support-assignments block (also used by the weekend schedule).
class SupportAssignmentsCard extends ConsumerWidget {
  const SupportAssignmentsCard({
    super.key,
    required this.canEdit,
    required this.attendants,
    required this.microphones,
    required this.audioVideo,
    required this.customAssignments,
    required this.onChanged,
  });

  final bool canEdit;
  final Assignment attendants;
  final Assignment microphones;
  final Assignment audioVideo;
  final List<CustomAssignment> customAssignments;
  final Future<void> Function({
    Assignment? attendants,
    Assignment? microphones,
    Assignment? audioVideo,
    List<CustomAssignment>? customAssignments,
  }) onChanged;

  Future<void> _edit(
    BuildContext context, {
    required String title,
    required Assignment initial,
    required String historyKey,
    required bool Function(Publisher) qualifies,
    required Future<void> Function(Assignment) save,
  }) async {
    final result = await showAssignmentEditor(context,
        title: title,
        initial: initial,
        historyKey: historyKey,
        qualifies: qualifies);
    if (result != null) await save(result);
  }

  Future<void> _addCustom(BuildContext context) async {
    final l10n = context.l10n;
    final ctrl = TextEditingController();
    final label = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.customAssignmentAdd),
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
    if (label != null && label.isNotEmpty) {
      await onChanged(customAssignments: [
        ...customAssignments,
        CustomAssignment(label: label),
      ]);
    }
    ctrl.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    Widget row({
      required String label,
      required Assignment assignment,
      required VoidCallback? onTap,
      VoidCallback? onDelete,
    }) =>
        ListTile(
          dense: true,
          title: Text(label),
          subtitle: AssignmentText(assignment),
          onTap: onTap,
          trailing: onDelete != null
              ? IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: onDelete)
              : null,
        );

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row(
            label: l10n.supportAttendants,
            assignment: attendants,
            onTap: !canEdit
                ? null
                : () => _edit(context,
                    title: l10n.supportAttendants,
                    initial: attendants,
                    historyKey: HistoryKeys.attendant,
                    qualifies: (p) => p.qualifications.attendant,
                    save: (a) => onChanged(attendants: a)),
          ),
          row(
            label: l10n.supportMicrophones,
            assignment: microphones,
            onTap: !canEdit
                ? null
                : () => _edit(context,
                    title: l10n.supportMicrophones,
                    initial: microphones,
                    historyKey: HistoryKeys.microphone,
                    qualifies: (p) => p.qualifications.microphone,
                    save: (a) => onChanged(microphones: a)),
          ),
          row(
            label: l10n.supportAudioVideo,
            assignment: audioVideo,
            onTap: !canEdit
                ? null
                : () => _edit(context,
                    title: l10n.supportAudioVideo,
                    initial: audioVideo,
                    historyKey: HistoryKeys.audioVideo,
                    qualifies: (p) => p.qualifications.audioVideo,
                    save: (a) => onChanged(audioVideo: a)),
          ),
          for (var i = 0; i < customAssignments.length; i++)
            row(
              label: customAssignments[i].label,
              assignment: customAssignments[i].assignment,
              onTap: !canEdit
                  ? null
                  : () => _edit(context,
                      title: customAssignments[i].label,
                      initial: customAssignments[i].assignment,
                      historyKey: HistoryKeys.custom,
                      qualifies: (_) => true,
                      save: (a) {
                        final updated = [...customAssignments];
                        updated[i] =
                            updated[i].copyWith(assignment: a);
                        return onChanged(customAssignments: updated);
                      }),
              onDelete: !canEdit
                  ? null
                  : () {
                      final updated = [...customAssignments]..removeAt(i);
                      onChanged(customAssignments: updated);
                    },
            ),
          if (canEdit)
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton.icon(
                onPressed: () => _addCustom(context),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.customAssignmentAdd),
              ),
            ),
        ],
      ),
    );
  }
}
