import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/assignment_history.dart';
import '../../core/data/congregation_repository.dart';
import '../../core/data/schedule_config_repository.dart';
import '../../core/data/weekend_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/assignment_chips.dart';
import '../../core/widgets/assignment_editor.dart';
import '../../core/widgets/meeting_week_header.dart';
import '../../core/widgets/program_kind_actions.dart';
import '../../core/widgets/show_to_publishers_switch.dart';
import '../../core/widgets/week_navigator.dart';
import '../attendance/meeting_attendance_card.dart';
import '../lmm_schedule/lmm_screen.dart' show SupportAssignmentsCard;
import '../memorial/memorial_program_view.dart';
import '../songs/song_editor.dart';
import 'talk_title_editor.dart';

class WeekendScreen extends StatelessWidget {
  const WeekendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WeekNavigator(
      headerBuilder: (context, weekId, goTo) => MeetingWeekHeader(
        weekId: weekId,
        kind: MeetingKind.weekend,
        goTo: goTo,
      ),
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
    final roles = ref.watch(effectiveRolesProvider);
    final canEdit = roles.canEditWeekend();
    // The Memorial replaces whichever meeting it falls on and is arranged by
    // either meeting-schedule role, so a midweek-schedule admin may plan one
    // here (firestore.rules grants exactly the same).
    final canPlanMemorial = canEditProgram(
      roles,
      ScheduleKind.weekend,
      MeetingProgramKind.memorial,
    );

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
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => _save(
                        ref,
                        WeekendWeek(
                          id: weekId,
                          programKind: MeetingProgramKind.nothingPlanned,
                        )),
                    icon: const Icon(Icons.event_busy_outlined),
                    label: Text(l10n.programKindNothingPlanned),
                  ),
                ],
                if (canPlanMemorial) ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => _save(
                        ref,
                        WeekendWeek(
                          id: weekId,
                          programKind: MeetingProgramKind.memorial,
                          memorial: const MemorialProgram(),
                        )),
                    icon: const Icon(Icons.wine_bar_outlined),
                    label: Text(l10n.programKindMemorial),
                  ),
                ],
              ],
            ),
          );
        }
        return _WeekContent(
          week: week,
          canEdit:
              canEditProgram(roles, ScheduleKind.weekend, week.programKind),
          canDelete: canEdit,
        );
      },
    );
  }
}

class _WeekContent extends ConsumerWidget {
  const _WeekContent({
    required this.week,
    required this.canEdit,
    required this.canDelete,
  });

  final WeekendWeek week;
  final bool canEdit;

  /// Deleting the week takes the weekend program with it, so it stays with
  /// the weekend role even when a midweek admin is here for the Memorial.
  final bool canDelete;

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
    final meta = ref.read(congregationMetaProvider).value;
    final result = await showAssignmentEditor(context,
        title: title,
        initial: initial,
        historyKey: historyKey,
        qualifies: qualifies,
        date: meta == null
            ? null
            : meetingDateOf(week.id, week.weekdayOr(meta.weekendWeekday)));
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

  /// Switches the week to another program. Nothing is deleted: the talk,
  /// song and assignments of the program being left stay in the document and
  /// come back with it.
  Future<void> _switchProgram(
    BuildContext context,
    WidgetRef ref,
    MeetingProgramKind kind,
  ) async {
    if (kind != MeetingProgramKind.regular &&
        !await confirmProgramSwitch(context, kind)) {
      return;
    }
    await _save(
      ref,
      week.copyWith(
        programKind: kind,
        memorial: kind == MeetingProgramKind.memorial
            ? week.memorialOrEmpty
            : week.memorial,
      ),
    );
  }

  Future<void> _editNote(BuildContext context, WidgetRef ref) async {
    final note = await showProgramNoteDialog(context, initial: week.programNote);
    if (note != null) await _save(ref, week.copyWith(programNote: note));
  }

  Future<void> _onMenu(
    BuildContext context,
    WidgetRef ref,
    WeekMenuAction action,
  ) async {
    switch (action) {
      case WeekMenuAction.nothingPlanned:
        await _switchProgram(context, ref, MeetingProgramKind.nothingPlanned);
      case WeekMenuAction.memorial:
        await _switchProgram(context, ref, MeetingProgramKind.memorial);
      case WeekMenuAction.restoreProgram:
        await _switchProgram(context, ref, MeetingProgramKind.regular);
      case WeekMenuAction.editNote:
        await _editNote(context, ref);
      case WeekMenuAction.delete:
        await _confirmDeleteWeek(context, ref);
    }
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
    final meta = ref.watch(congregationMetaProvider).value;
    // Attendance is recorded against the meeting date this week's schedule is
    // for. Without meta the weekday is unknown, and guessing it would write
    // the count under the wrong document id.
    final meetingDate =
        meta == null
            ? null
            : meetingDateOf(week.id, week.weekdayOr(meta.weekendWeekday));
    // Off for this week, a publisher gets the talk and the song without the
    // names. Always true for the schedule's admins.
    final showNames = ref.watch(
      weekAssigneesVisibleProvider((
        kind: ScheduleKind.weekend,
        weekId: week.id,
      )),
    );

    // The program menu normally hangs off the talk-title tile; a week that
    // runs no talk needs its own place for it.
    Widget programMenuRow(String title) => Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                child: Text(title, style: theme.textTheme.titleMedium),
              ),
            ),
            if (canEdit)
              PopupMenuButton<WeekMenuAction>(
                onSelected: (v) => _onMenu(context, ref, v),
                itemBuilder: (_) => weekMenuItems(l10n, week.programKind,
                    canDelete: canDelete),
              ),
          ],
        );

    // A week that runs something other than the regular program renders that
    // instead — the talk, song and assignments below stay in the document,
    // dormant, and come back when the week is switched back.
    if (week.programKind == MeetingProgramKind.nothingPlanned) {
      return ListView(
        children: [
          programMenuRow(l10n.programKindNothingPlanned),
          NothingPlannedCard(
            note: week.programNote,
            canEdit: canEdit,
            onEditNote: () => _editNote(context, ref),
          ),
          const SizedBox(height: 24),
        ],
      );
    }

    if (week.programKind == MeetingProgramKind.memorial) {
      return ListView(
        children: [
          programMenuRow(l10n.programKindMemorial),
          ShowToPublishersSwitch(
              kind: ScheduleKind.weekend, weekId: week.id),
          MemorialProgramView(
            program: week.memorialOrEmpty,
            canEdit: canEdit,
            showNames: showNames,
            date: meetingDate,
            onChanged: (m) => _save(ref, week.copyWith(memorial: m)),
          ),
          if (showNames)
            _SupportCard(
              week: week,
              date: meetingDate,
              withMicrophones: false,
            ),
          if (meetingDate != null) ...[
            MeetingAttendanceCard(
              date: meetingDate,
              meetingType: MeetingType.memorial,
            ),
            MemorialAttendanceHistory(excludeDate: dateKey(meetingDate)),
          ],
          const SizedBox(height: 24),
        ],
      );
    }

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
        ShowToPublishersSwitch(kind: ScheduleKind.weekend, weekId: week.id),
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
                    ? PopupMenuButton<WeekMenuAction>(
                        onSelected: (v) => _onMenu(context, ref, v),
                        itemBuilder: (_) => weekMenuItems(
                            l10n, week.programKind,
                            canDelete: canDelete),
                      )
                    : null,
              ),
              ListTile(
                dense: true,
                title: Text(l10n.songLabel),
                subtitle: Text(songDisplayText(week.songNo, week.songTitle)),
                onTap: canEdit ? () => _editSong(context, ref) : null,
              ),
              // Every row below carries a name and nothing else, the speaker
              // included: a week switched off keeps the talk and the song.
              if (showNames) ...[
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
              ],
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
        // Nothing but names: it has no program of its own to show a publisher.
        if (showNames) _SupportCard(week: week, date: meetingDate),
        if (meetingDate != null)
          MeetingAttendanceCard(
            date: meetingDate,
            meetingType: MeetingType.weekend,
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// Attendants / microphones / audio-video / custom assignments for one
/// weekend week. Extracted so the Memorial branch can render the same card
/// without the microphone row it does not arrange.
class _SupportCard extends ConsumerWidget {
  const _SupportCard({
    required this.week,
    required this.date,
    this.withMicrophones = true,
  });

  final WeekendWeek week;
  final DateTime? date;

  /// The Memorial arranges attendants and audio/video and nothing else.
  final bool withMicrophones;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permanent =
        ref.watch(weekendPermanentAssignmentsProvider).value ?? const [];
    final configRepo = ref.read(scheduleConfigRepositoryProvider);
    final canEdit = canEditProgram(
      ref.watch(effectiveRolesProvider),
      ScheduleKind.weekend,
      week.programKind,
    );
    return SupportAssignmentsCard(
      canEdit: canEdit,
      date: date,
      attendants: week.attendants,
      microphones: withMicrophones ? week.microphones : null,
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
          permanentAssignments: permanent.where((c) => c.id != id).toList(),
        ),
      ),
      onChanged: ({attendants, microphones, audioVideo, customAssignments}) =>
          _save(
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
