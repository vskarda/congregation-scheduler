import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/assignment_history.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/data/pw_repository.dart';
import '../../core/data/schedule_config_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/assignment_chips.dart';
import '../../core/widgets/assignment_editor.dart';
import '../../core/widgets/show_to_publishers_switch.dart';
import '../../core/widgets/week_navigator.dart';
import 'pw_recurring_screen.dart';

String _sundayOf(String weekId) =>
    dateKey(parseDateKey(weekId).add(const Duration(days: 6)));

/// Slot documents held in one week, including cancelled ones (needed so a
/// cancelled occurrence suppresses the one its rule would expand).
final _pwWeekByDateProvider =
    StreamProvider.family<List<PwSlot>, String>((ref, weekId) => ref
        .watch(pwRepositoryProvider)
        .watchRange(weekId, _sundayOf(weekId), includeCancelled: true));

/// Exceptions whose *occurrence* is in this week, wherever they were moved
/// to — they claim their slot so the rule does not expand it a second time.
final _pwWeekBySeriesDateProvider =
    StreamProvider.family<List<PwSlot>, String>((ref, weekId) => ref
        .watch(pwRepositoryProvider)
        .watchSeriesRange(weekId, _sundayOf(weekId)));

/// Slots of one week (weekId = Monday key): one-off slots and edited
/// occurrences merged with everything the recurring rules produce. Rules are
/// the source of truth, so a rule edit is visible here immediately, for every
/// user and every browsed week.
final pwWeekSlotsProvider =
    Provider.family<AsyncValue<List<PwSlot>>, String>((ref, weekId) {
  final byDate = ref.watch(_pwWeekByDateProvider(weekId));
  final bySeriesDate = ref.watch(_pwWeekBySeriesDateProvider(weekId));
  final rules = ref.watch(pwRecurringProvider);
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
        data: (ruleList) => AsyncValue.data(PwRepository.expand(held, claimed,
            ruleList, monday, monday.add(const Duration(days: 7)))),
      ),
    ),
  );
});

/// Slot ids the current user has applied for. Not gated on the PW
/// qualification, so someone who lost it can still see and withdraw
/// their existing applications.
final myPwApplicationsProvider = StreamProvider<Set<String>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null || !ref.watch(isVerifiedProvider)) {
    return Stream.value(const <String>{});
  }
  return ref
      .watch(pwRepositoryProvider)
      .watchMyApplications(uid)
      .map((apps) => apps.map((a) => a.slotId).toSet());
});

/// Applications for one chunk of slot ids (comma-joined, because a family
/// key needs value equality). Firestore caps `whereIn` at 30 ids, so a busy
/// week is split across several of these.
final _pwApplicationChunkProvider =
    StreamProvider.family<Map<String, List<PwApplication>>, String>(
        (ref, joinedIds) => ref
            .watch(pwRepositoryProvider)
            .watchApplicationsForSlots(joinedIds.split(',')));

/// Applications for the slots shown in one week, grouped by slot id. Only PW
/// admins may run the underlying query (uses the real roles, like
/// [pwRepairProvider]); empty for everyone else.
///
/// Keyed by the ids of the slots actually on screen rather than by the
/// applications' denormalized date, which goes stale as soon as an admin
/// moves a slot and which the security rules let nobody correct.
final pwWeekApplicationsProvider =
    Provider.family<Map<String, List<PwApplication>>, String>((ref, weekId) {
  if (!ref.watch(myRolesProvider).canEditPublicWitnessing()) return const {};
  final slots = ref.watch(pwWeekSlotsProvider(weekId)).value;
  if (slots == null || slots.isEmpty) return const {};

  final result = <String, List<PwApplication>>{};
  for (final chunk in PwRepository.chunkIds(slots.map((s) => s.id).toList())) {
    final apps = ref.watch(_pwApplicationChunkProvider(chunk.join(','))).value;
    if (apps != null) result.addAll(apps);
  }
  return result;
});

/// Reconnects slot documents to their rules, compacts away the snapshot
/// copies the old materializer wrote, and sweeps up applications naming slots
/// that no longer happen. Runs once per session for PW admins (it writes, so
/// publishers must not attempt it) and is idempotent.
final pwRepairProvider = FutureProvider<void>((ref) async {
  if (!ref.watch(myRolesProvider).canEditPublicWitnessing()) return;
  await ref.watch(pwRepositoryProvider).repairAndCompact();
});

class PwScreen extends ConsumerWidget {
  const PwScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pwRepairProvider);
    final canEdit = ref.watch(effectiveRolesProvider).canEditPublicWitnessing();
    final l10n = context.l10n;

    return Scaffold(
      floatingActionButton: canEdit
          ? FloatingActionButton(
              tooltip: l10n.pwAddSlot,
              onPressed: () => showPwSlotDialog(context, ref),
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
                          builder: (_) => const PwRecurringScreen())),
                  icon: const Icon(Icons.repeat, size: 18),
                  label: Text(l10n.pwRecurringRules),
                ),
              ),
            ),
          Expanded(
            child: WeekNavigator(
              contentBuilder: (context, weekId) =>
                  _PwWeekView(weekId: weekId, canEdit: canEdit),
            ),
          ),
        ],
      ),
    );
  }
}

class _PwWeekView extends ConsumerWidget {
  const _PwWeekView({required this.weekId, required this.canEdit});

  final String weekId;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final slots = ref.watch(pwWeekSlotsProvider(weekId));
    final locale = Localizations.localeOf(context).toString();
    final dayFmt = DateFormat.EEEE(locale);
    final dateFmt = DateFormat.MMMd(locale);
    final uid = ref.watch(currentUidProvider);
    final me = ref.watch(myPublisherProvider).value;
    final appliedSlotIds =
        ref.watch(myPwApplicationsProvider).value ?? const <String>{};
    final weekApplications = canEdit
        ? ref.watch(pwWeekApplicationsProvider(weekId))
        : const <String, List<PwApplication>>{};
    final todayKey = dateKey(DateTime.now());
    // Off for this week, a publisher gets the slots without who is on them —
    // but still applies for and withdraws from them. Always true for admins.
    final showNames = ref.watch(
        weekAssigneesVisibleProvider((kind: ScheduleKind.pw, weekId: weekId)));

    return slots.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l10n.commonErrorDetail(e.toString()))),
      data: (list) {
        if (list.isEmpty) {
          return Center(child: Text(l10n.pwNoSlots));
        }
        return ListView(
          children: [
            ShowToPublishersSwitch(kind: ScheduleKind.pw, weekId: weekId),
            for (final slot in list)
              Card(
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(dayFmt.format(parseDateKey(slot.date)),
                          style: Theme.of(context).textTheme.labelSmall),
                      Text(dateFmt.format(parseDateKey(slot.date))),
                    ],
                  ),
                  title: Text(
                      '${slot.startTime}–${slot.endTime}  ${slot.location}'),
                  subtitle:
                      showNames ? AssignmentText(slot.assignment) : null,
                  trailing: canEdit
                      ? _adminTrailing(context, ref, slot,
                          weekApplications[slot.id]?.length ?? 0)
                      : _applyTrailing(context, ref, slot,
                          uid: uid,
                          me: me,
                          hasApplied: appliedSlotIds.contains(slot.id),
                          isPast: slot.date.compareTo(todayKey) < 0),
                  onTap: canEdit
                      ? () => showPwSlotDialog(context, ref, existing: slot)
                      : null,
                ),
              ),
          ],
        );
      },
    );
  }

  /// Delete button, prefixed with an applicant-count badge when anyone
  /// applied for the slot.
  Widget _adminTrailing(
      BuildContext context, WidgetRef ref, PwSlot slot, int applicantCount) {
    final delete = IconButton(
      icon: const Icon(Icons.delete_outline),
      onPressed: () => ref.read(pwRepositoryProvider).deleteSlot(slot),
    );
    if (applicantCount == 0) return delete;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: context.l10n.pwApplicants(applicantCount),
          child: Badge.count(
            count: applicantCount,
            child: const Icon(Icons.front_hand_outlined),
          ),
        ),
        delete,
      ],
    );
  }

  /// Apply/withdraw toggle for qualified publishers; a plain applied marker
  /// on past slots; nothing for someone not qualified.
  ///
  /// Offered on every slot, assigned ones included: on a week whose names are
  /// hidden a publisher cannot see that they are already on a slot, and even
  /// when they can, an application and an assignment are two different things
  /// — withdrawing one leaves the other exactly as the admin set it.
  Widget? _applyTrailing(BuildContext context, WidgetRef ref, PwSlot slot,
      {required String? uid,
      required Publisher? me,
      required bool hasApplied,
      required bool isPast}) {
    if (uid == null) return null;
    if (hasApplied) {
      if (isPast) {
        return Icon(Icons.front_hand, color: Theme.of(context).disabledColor);
      }
      return IconButton(
        icon: Icon(Icons.front_hand,
            color: Theme.of(context).colorScheme.primary),
        tooltip: context.l10n.pwWithdraw,
        onPressed: () =>
            ref.read(pwRepositoryProvider).withdrawApplication(slot.id, uid),
      );
    }
    final qualified =
        me != null && me.verified && me.qualifications.publicWitnessing;
    if (!qualified || isPast) return null;
    return IconButton(
      icon: const Icon(Icons.front_hand_outlined),
      tooltip: context.l10n.pwApply,
      onPressed: () => ref.read(pwRepositoryProvider).applyForSlot(slot, uid),
    );
  }
}

/// Create/edit one slot. Editing an occurrence of a recurring rule writes an
/// exception recording only the fields that were actually changed, so the
/// rest keep following the rule.
Future<void> showPwSlotDialog(BuildContext context, WidgetRef ref,
    {PwSlot? existing}) async {
  final l10n = context.l10n;
  var slot = existing ?? PwSlot(date: dateKey(DateTime.now()));
  final locationCtrl = TextEditingController(text: slot.location);

  // Who applied for this slot (oldest first), so the assignee picker can
  // pin and badge them.
  final applicantIds = slot.id.isEmpty
      ? const <String>[]
      : [
          for (final a in await ref
              .read(pwRepositoryProvider)
              .getApplicationsForSlot(slot.id))
            a.publisherId
        ];
  if (!context.mounted) {
    locationCtrl.dispose();
    return;
  }

  final saved = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        Future<void> pickDate() async {
          final picked = await showDatePicker(
            context: context,
            initialDate: parseDateKey(slot.date),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            setState(() => slot = slot.copyWith(date: dateKey(picked)));
          }
        }

        Future<void> pickTime(bool start) async {
          final initial = start ? slot.startTime : slot.endTime;
          final parts = initial.split(':');
          final picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
                hour: int.tryParse(parts[0]) ?? 9,
                minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0),
          );
          if (picked != null) {
            final value =
                '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
            setState(() => slot = start
                ? slot.copyWith(startTime: value)
                : slot.copyWith(endTime: value));
          }
        }

        return AlertDialog(
          title: Text(existing == null ? l10n.pwAddSlot : l10n.pwEditSlot),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  dense: true,
                  title: Text(l10n.pwDate),
                  subtitle: Text(slot.date),
                  onTap: pickDate,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        dense: true,
                        title: Text(l10n.pwTimeFrom),
                        subtitle: Text(slot.startTime),
                        onTap: () => pickTime(true),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        dense: true,
                        title: Text(l10n.pwTimeTo),
                        subtitle: Text(slot.endTime),
                        onTap: () => pickTime(false),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: locationCtrl,
                  decoration: InputDecoration(labelText: l10n.pwLocation),
                ),
                const SizedBox(height: 8),
                ListTile(
                  dense: true,
                  title: Text(l10n.pwAssignees),
                  subtitle: AssignmentText(slot.assignment),
                  onTap: () async {
                    final result = await showAssignmentEditor(
                      context,
                      title: l10n.pwAssignees,
                      initial: slot.assignment,
                      historyKey: HistoryKeys.publicWitnessing,
                      qualifies: (p) => p.qualifications.publicWitnessing,
                      applicantIds: applicantIds,
                      date: tryParseDateKey(slot.date),
                    );
                    if (result != null) {
                      setState(
                          () => slot = slot.copyWith(assignment: result));
                    }
                  },
                ),
              ],
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
    final rule = slot.isException
        ? ref
            .read(pwRecurringProvider)
            .value
            ?.where((r) => r.id == slot.recurringId)
            .firstOrNull
        : null;
    await ref.read(pwRepositoryProvider).saveSlot(
          slot.copyWith(location: locationCtrl.text.trim()),
          rule: rule,
        );
    ref.invalidate(assignmentHistoryProvider);
  }
  locationCtrl.dispose();
}
