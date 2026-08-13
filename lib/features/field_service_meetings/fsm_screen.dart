import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/assignment_history.dart';
import '../../core/data/co_visit_repository.dart';
import '../../core/data/fsm_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/assignment_chips.dart';
import '../../core/widgets/assignment_editor.dart';
import '../../core/widgets/week_navigator.dart';
import 'fsm_recurring_screen.dart';

String _sundayOf(String weekId) =>
    dateKey(parseDateKey(weekId).add(const Duration(days: 6)));

/// Meeting documents held in one week, including cancelled ones (needed so a
/// cancelled occurrence suppresses the one its rule would expand).
final _fsmWeekByDateProvider =
    StreamProvider.family<List<FsmMeeting>, String>((ref, weekId) => ref
        .watch(fsmRepositoryProvider)
        .watchRange(weekId, _sundayOf(weekId), includeCancelled: true));

/// Exceptions whose *occurrence* is in this week, wherever they were moved
/// to — they claim their slot so the rule does not expand it a second time.
final _fsmWeekBySeriesDateProvider =
    StreamProvider.family<List<FsmMeeting>, String>((ref, weekId) => ref
        .watch(fsmRepositoryProvider)
        .watchSeriesRange(weekId, _sundayOf(weekId)));

/// Meetings of one week (weekId = Monday key): one-off meetings and edited
/// occurrences merged with everything the recurring rules produce. Rules are
/// the source of truth, so a rule edit is visible here immediately, for every
/// user and every browsed week.
final fsmWeekMeetingsProvider =
    Provider.family<AsyncValue<List<FsmMeeting>>, String>((ref, weekId) {
  final byDate = ref.watch(_fsmWeekByDateProvider(weekId));
  final bySeriesDate = ref.watch(_fsmWeekBySeriesDateProvider(weekId));
  final rules = ref.watch(fsmRecurringProvider);
  final monday = parseDateKey(weekId);
  return byDate.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (held) => bySeriesDate.when(
      loading: () => const AsyncValue.loading(),
      error: (e, st) => AsyncValue.error(e, st),
      data: (claimed) => rules.when(
        loading: () => const AsyncValue.loading(),
        error: (e, st) => AsyncValue.error(e, st),
        data: (ruleList) => AsyncValue.data(FsmRepository.expand(held, claimed,
            ruleList, monday, monday.add(const Duration(days: 7)))),
      ),
    ),
  );
});

/// Reconnects meeting documents to their rules and compacts away the snapshot
/// copies the old materializer wrote. Runs once per session for FSM admins
/// (it writes, so publishers must not attempt it) and is idempotent.
final fsmRepairProvider = FutureProvider<void>((ref) async {
  if (!ref.watch(myRolesProvider).canEditFieldServiceMeetings()) return;
  await ref.watch(fsmRepositoryProvider).repairAndCompact();
});

class FsmScreen extends ConsumerWidget {
  const FsmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(fsmRepairProvider);
    // Subscribed here, not read in the dialog: an unlistened stream provider
    // is still loading the first time it is read, and the meeting dialog
    // would then miss the circuit-overseer companion slots.
    ref.watch(coVisitWeekIdsProvider);
    final canEdit =
        ref.watch(effectiveRolesProvider).canEditFieldServiceMeetings();
    final l10n = context.l10n;

    return Scaffold(
      floatingActionButton: canEdit
          ? FloatingActionButton(
              tooltip: l10n.fsmAddMeeting,
              onPressed: () => showFsmMeetingDialog(context, ref),
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          if (canEdit)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 4),
                child: TextButton.icon(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const FsmRecurringScreen())),
                  icon: const Icon(Icons.repeat, size: 18),
                  label: Text(l10n.fsmRecurringRules),
                ),
              ),
            ),
          Expanded(
            child: WeekNavigator(
              contentBuilder: (context, weekId) =>
                  _FsmWeekView(weekId: weekId, canEdit: canEdit),
            ),
          ),
        ],
      ),
    );
  }
}

class _FsmWeekView extends ConsumerWidget {
  const _FsmWeekView({required this.weekId, required this.canEdit});

  final String weekId;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final meetings = ref.watch(fsmWeekMeetingsProvider(weekId));
    final locale = Localizations.localeOf(context).toString();
    final dayFmt = DateFormat.EEEE(locale);
    final dateFmt = DateFormat.MMMd(locale);

    return meetings.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l10n.commonErrorDetail(e.toString()))),
      data: (list) {
        if (list.isEmpty) {
          return Center(child: Text(l10n.fsmNoMeetings));
        }
        return ListView(
          children: [
            for (final meeting in list)
              Card(
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(dayFmt.format(parseDateKey(meeting.date)),
                          style: Theme.of(context).textTheme.labelSmall),
                      Text(dateFmt.format(parseDateKey(meeting.date))),
                    ],
                  ),
                  title: Text('${meeting.time}  ${meeting.location}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AssignmentText(meeting.assignment),
                      // Shown wherever they are set — which, by construction,
                      // is only during a circuit overseer's visit.
                      if (meeting.withCo.isNotEmpty)
                        LabelledAssignment(
                            label: l10n.coWithCo, assignment: meeting.withCo),
                      if (meeting.withCoWife.isNotEmpty)
                        LabelledAssignment(
                            label: l10n.coWithCoWife,
                            assignment: meeting.withCoWife),
                      if (meeting.note.isNotEmpty)
                        Text(meeting.note,
                            style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  trailing: canEdit
                      ? IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => ref
                              .read(fsmRepositoryProvider)
                              .deleteMeeting(meeting),
                        )
                      : null,
                  onTap: canEdit
                      ? () => showFsmMeetingDialog(context, ref,
                          existing: meeting)
                      : null,
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Create/edit one meeting. Editing an occurrence of a recurring rule writes
/// an exception recording only the fields that were actually changed, so the
/// rest keep following the rule.
///
/// During a circuit overseer's visit the dialog also offers the two companion
/// slots — who shares in the ministry with the overseer, and with his wife.
/// They are stored on the meeting itself, so the circuit overseer view and
/// this one edit exactly the same documents. [initialDate] seeds a new
/// meeting (the visit view opens it on a day of the visit).
Future<void> showFsmMeetingDialog(BuildContext context, WidgetRef ref,
    {FsmMeeting? existing, String? initialDate}) async {
  final l10n = context.l10n;
  var meeting =
      existing ?? FsmMeeting(date: initialDate ?? dateKey(DateTime.now()));
  final coWeeks = ref.read(coVisitWeekIdsProvider);
  final locationCtrl = TextEditingController(text: meeting.location);
  final noteCtrl = TextEditingController(text: meeting.note);

  final saved = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        Future<void> pickDate() async {
          final picked = await showDatePicker(
            context: context,
            initialDate: parseDateKey(meeting.date),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            setState(() => meeting = meeting.copyWith(date: dateKey(picked)));
          }
        }

        Future<void> pickTime() async {
          final parts = meeting.time.split(':');
          final picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
                hour: int.tryParse(parts[0]) ?? 9,
                minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0),
          );
          if (picked != null) {
            final value =
                '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
            setState(() => meeting = meeting.copyWith(time: value));
          }
        }

        return AlertDialog(
          title: Text(
              existing == null ? l10n.fsmAddMeeting : l10n.fsmEditMeeting),
          content: SizedBox(
            width: 360,
            child: SingleChildScrollView(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  dense: true,
                  title: Text(l10n.fsmDate),
                  subtitle: Text(meeting.date),
                  onTap: pickDate,
                ),
                ListTile(
                  dense: true,
                  title: Text(l10n.fsmTime),
                  subtitle: Text(meeting.time),
                  onTap: pickTime,
                ),
                TextField(
                  controller: locationCtrl,
                  decoration: InputDecoration(labelText: l10n.fsmLocation),
                ),
                TextField(
                  controller: noteCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(labelText: l10n.fsmNote),
                ),
                const SizedBox(height: 8),
                ListTile(
                  dense: true,
                  title: Text(l10n.fsmConductor),
                  subtitle: AssignmentText(meeting.assignment),
                  onTap: () async {
                    final result = await showAssignmentEditor(
                      context,
                      title: l10n.fsmConductor,
                      initial: meeting.assignment,
                      historyKey: HistoryKeys.fieldServiceMeetings,
                      qualifies: (p) =>
                          p.qualifications.ministryMeetingConductor,
                      multi: false,
                      date: tryParseDateKey(meeting.date),
                    );
                    if (result != null) {
                      setState(() =>
                          meeting = meeting.copyWith(assignment: result));
                    }
                  },
                ),
                // Only during a circuit overseer's visit: anyone may share in
                // the ministry with him, so the picker is not filtered.
                if (isCoVisitDate(coWeeks, meeting.date)) ...[
                  const Divider(),
                  for (final slot in [
                    (
                      label: l10n.coWithCo,
                      value: meeting.withCo,
                      key: HistoryKeys.coWithCo,
                      apply: (Assignment a) => meeting.copyWith(withCo: a),
                    ),
                    (
                      label: l10n.coWithCoWife,
                      value: meeting.withCoWife,
                      key: HistoryKeys.coWithCoWife,
                      apply: (Assignment a) => meeting.copyWith(withCoWife: a),
                    ),
                  ])
                    ListTile(
                      dense: true,
                      title: Text(slot.label),
                      subtitle: AssignmentText(slot.value),
                      onTap: () async {
                        final result = await showAssignmentEditor(
                          context,
                          title: slot.label,
                          initial: slot.value,
                          historyKey: slot.key,
                          qualifies: (_) => true,
                          date: tryParseDateKey(meeting.date),
                        );
                        if (result != null) {
                          setState(() => meeting = slot.apply(result));
                        }
                      },
                    ),
                ],
              ],
            ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.commonCancel)),
            FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.commonSave)),
          ],
        );
      },
    ),
  );
  if (saved == true) {
    final rule = meeting.isException
        ? ref
            .read(fsmRecurringProvider)
            .value
            ?.where((r) => r.id == meeting.recurringId)
            .firstOrNull
        : null;
    await ref.read(fsmRepositoryProvider).saveMeeting(
          meeting.copyWith(
            location: locationCtrl.text.trim(),
            note: noteCtrl.text.trim(),
          ),
          rule: rule,
        );
    ref.invalidate(assignmentHistoryProvider);
  }
  locationCtrl.dispose();
  noteCtrl.dispose();
}
