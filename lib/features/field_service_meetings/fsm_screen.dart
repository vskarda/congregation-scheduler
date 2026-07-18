import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/assignment_history.dart';
import '../../core/data/fsm_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/assignment_chips.dart';
import '../../core/widgets/assignment_editor.dart';
import '../../core/widgets/week_navigator.dart';
import 'fsm_recurring_screen.dart';

/// Concrete meetings of one week, including cancelled instances (needed so a
/// cancelled recurring instance suppresses its virtual counterpart).
final _fsmWeekRawMeetingsProvider =
    StreamProvider.family<List<FsmMeeting>, String>((ref, weekId) {
  final monday = parseDateKey(weekId);
  final sunday = dateKey(monday.add(const Duration(days: 6)));
  return ref
      .watch(fsmRepositoryProvider)
      .watchRange(weekId, sunday, includeCancelled: true);
});

/// Meetings of one week (weekId = Monday key): concrete meetings merged with
/// instances expanded from the recurring rules, so recurring meetings show up
/// for every user and every browsed week, not just where the materializer
/// already wrote docs.
final fsmWeekMeetingsProvider =
    Provider.family<AsyncValue<List<FsmMeeting>>, String>((ref, weekId) {
  final meetings = ref.watch(_fsmWeekRawMeetingsProvider(weekId));
  final rules = ref.watch(fsmRecurringProvider);
  final monday = parseDateKey(weekId);
  return meetings.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (concrete) => rules.when(
      loading: () => const AsyncValue.loading(),
      error: (e, st) => AsyncValue.error(e, st),
      data: (ruleList) => AsyncValue.data(FsmRepository.mergeWithRules(
          concrete, ruleList, monday, monday.add(const Duration(days: 7)))),
    ),
  );
});

/// Ensures recurring rules are materialized ahead; runs once per session for
/// FSM admins (publishers only read existing meetings).
final fsmMaterializationProvider = FutureProvider<void>((ref) async {
  if (!ref.watch(myRolesProvider).canEditFieldServiceMeetings()) return;
  final repo = ref.watch(fsmRepositoryProvider);
  final rules = await repo.watchRecurring().first;
  for (final rule in rules) {
    await repo.materializeRule(rule);
  }
});

class FsmScreen extends ConsumerWidget {
  const FsmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(fsmMaterializationProvider);
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

/// Create/edit one concrete meeting.
Future<void> showFsmMeetingDialog(BuildContext context, WidgetRef ref,
    {FsmMeeting? existing}) async {
  final l10n = context.l10n;
  var meeting = existing ?? FsmMeeting(date: dateKey(DateTime.now()));
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
                    );
                    if (result != null) {
                      setState(() =>
                          meeting = meeting.copyWith(assignment: result));
                    }
                  },
                ),
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
    await ref.read(fsmRepositoryProvider).saveMeeting(meeting.copyWith(
          location: locationCtrl.text.trim(),
          note: noteCtrl.text.trim(),
        ));
    ref.invalidate(assignmentHistoryProvider);
  }
  locationCtrl.dispose();
  noteCtrl.dispose();
}
