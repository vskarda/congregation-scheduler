import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/assignment_history.dart';
import '../../core/data/schedule_config_repository.dart';
import '../../core/data/weekend_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/widgets/assignment_chips.dart';
import '../../core/widgets/assignment_editor.dart';
import '../../core/widgets/week_navigator.dart';
import '../lmm_schedule/lmm_screen.dart' show SupportAssignmentsCard;
import '../songs/song_editor.dart';
import 'talk_title_editor.dart';

class WeekendScreen extends StatelessWidget {
  const WeekendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WeekNavigator(
      contentBuilder: (context, weekId) => _WeekendWeekView(weekId: weekId),
    );
  }
}

Future<void> _save(WidgetRef ref, WeekendWeek week) async {
  await ref.read(weekendRepositoryProvider).saveWeek(week);
  ref.invalidate(assignmentHistoryProvider);
}

class _WeekendWeekView extends ConsumerWidget {
  const _WeekendWeekView({required this.weekId});

  final String weekId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final weekAsync = ref.watch(weekendWeekProvider(weekId));
    final canEdit = ref.watch(effectiveRolesProvider).canEditWeekend();

    return weekAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l10n.commonErrorDetail(e.toString()))),
      data: (week) {
        if (week == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.weekNoSchedule),
                if (canEdit) ...[
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () =>
                        _save(ref, WeekendWeek(id: weekId)),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.weekCreateEmpty),
                  ),
                ],
              ],
            ),
          );
        }
        return _WeekContent(week: week, canEdit: canEdit);
      },
    );
  }
}

class _WeekContent extends ConsumerWidget {
  const _WeekContent({required this.week, required this.canEdit});

  final WeekendWeek week;
  final bool canEdit;

  Future<void> _editTalkTitle(BuildContext context, WidgetRef ref) async {
    final result = await showTalkTitleEditor(context,
        talkNo: week.talkNo, title: week.talkTitle);
    if (result != null) {
      await _save(
          ref, week.copyWith(talkNo: result.talkNo, talkTitle: result.title));
    }
  }

  Future<void> _editSong(BuildContext context, WidgetRef ref) async {
    final result = await showSongEditor(context,
        dialogTitle: context.l10n.songLabel,
        songNo: week.songNo,
        songTitle: week.songTitle);
    if (result != null) {
      await _save(
          ref, week.copyWith(songNo: result.songNo, songTitle: result.title));
    }
  }

  Future<void> _editAssignment(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required Assignment initial,
    required String historyKey,
    required bool Function(Publisher) qualifies,
    required WeekendWeek Function(Assignment) apply,
  }) async {
    final result = await showAssignmentEditor(context,
        title: title,
        initial: initial,
        historyKey: historyKey,
        qualifies: qualifies);
    if (result != null) await _save(ref, apply(result));
  }

  Future<void> _addCustomField(BuildContext context, WidgetRef ref) async {
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
    if (label != null && label.isNotEmpty) {
      await _save(
          ref,
          week.copyWith(customFields: [
            ...week.customFields,
            CustomAssignment(label: label),
          ]));
    }
    ctrl.dispose();
  }

  Future<void> _confirmDeleteWeek(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
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
      await ref.read(weekendRepositoryProvider).deleteWeek(week.id);
      ref.invalidate(assignmentHistoryProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    Widget assignmentRow({
      required String label,
      required Assignment assignment,
      required String historyKey,
      required bool Function(Publisher) qualifies,
      required WeekendWeek Function(Assignment) apply,
      VoidCallback? onDelete,
    }) =>
        ListTile(
          dense: true,
          title: Text(label),
          subtitle: AssignmentText(assignment),
          onTap: canEdit
              ? () => _editAssignment(context, ref,
                  title: label,
                  initial: assignment,
                  historyKey: historyKey,
                  qualifies: qualifies,
                  apply: apply)
              : null,
          trailing: onDelete != null && canEdit
              ? IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: onDelete)
              : null,
        );

    return ListView(
      children: [
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                dense: true,
                title: Text(l10n.weekendTalkTitle,
                    style: theme.textTheme.labelLarge),
                subtitle: Text(
                  week.talkTitle.isEmpty
                      ? '—'
                      : week.talkNo == null
                          ? week.talkTitle
                          : '${week.talkNo}. ${week.talkTitle}',
                  style: theme.textTheme.titleMedium,
                ),
                onTap: canEdit ? () => _editTalkTitle(context, ref) : null,
                trailing: canEdit
                    ? PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == 'delete') {
                            _confirmDeleteWeek(context, ref);
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                              value: 'delete',
                              child: Text(l10n.weekDelete)),
                        ],
                      )
                    : null,
              ),
              ListTile(
                dense: true,
                title: Text(l10n.songLabel),
                subtitle: Text(songDisplayText(week.songNo, week.songTitle)),
                onTap: canEdit ? () => _editSong(context, ref) : null,
              ),
              assignmentRow(
                label: l10n.weekendSpeaker,
                assignment: week.speaker,
                historyKey: HistoryKeys.weekendSpeaker,
                qualifies: (p) => p.qualifications.publicTalk,
                apply: (a) => week.copyWith(speaker: a),
              ),
              assignmentRow(
                label: l10n.weekendChairmanLabel,
                assignment: week.chairman,
                historyKey: HistoryKeys.weekendChairman,
                qualifies: (p) => p.qualifications.weekendChairman,
                apply: (a) => week.copyWith(chairman: a),
              ),
              assignmentRow(
                label: l10n.weekendWtReader,
                assignment: week.wtReader,
                historyKey: HistoryKeys.weekendWtReader,
                qualifies: (p) => p.qualifications.wtReader,
                apply: (a) => week.copyWith(wtReader: a),
              ),
              for (var i = 0; i < week.customFields.length; i++)
                assignmentRow(
                  label: week.customFields[i].label,
                  assignment: week.customFields[i].assignment,
                  historyKey: HistoryKeys.custom,
                  qualifies: (_) => true,
                  apply: (a) {
                    final updated = [...week.customFields];
                    updated[i] = updated[i].copyWith(assignment: a);
                    return week.copyWith(customFields: updated);
                  },
                  onDelete: () {
                    final updated = [...week.customFields]..removeAt(i);
                    _save(ref, week.copyWith(customFields: updated));
                  },
                ),
              if (canEdit)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton.icon(
                    onPressed: () => _addCustomField(context, ref),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.customFieldAdd),
                  ),
                ),
            ],
          ),
        ),
        Builder(
          builder: (context) {
            final permanent =
                ref.watch(weekendPermanentAssignmentsProvider).value ??
                    const [];
            final configRepo = ref.read(scheduleConfigRepositoryProvider);
            return SupportAssignmentsCard(
              canEdit: canEdit,
              attendants: week.attendants,
              microphones: week.microphones,
              audioVideo: week.audioVideo,
              customAssignments: week.customAssignments,
              permanentAssignments: permanent,
              onAddPermanent: (template) => configRepo.saveConfig(
                ScheduleConfigDoc.weekend,
                ScheduleConfig(permanentAssignments: [...permanent, template]),
              ),
              onRemovePermanent: (id) => configRepo.saveConfig(
                ScheduleConfigDoc.weekend,
                ScheduleConfig(
                  permanentAssignments:
                      permanent.where((c) => c.id != id).toList(),
                ),
              ),
              onChanged: ({
                attendants,
                microphones,
                audioVideo,
                customAssignments,
              }) =>
                  _save(
                ref,
                week.copyWith(
                  attendants: attendants ?? week.attendants,
                  microphones: microphones ?? week.microphones,
                  audioVideo: audioVideo ?? week.audioVideo,
                  customAssignments:
                      customAssignments ?? week.customAssignments,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
