import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/assignment_history.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/data/pw_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/assignment_chips.dart';
import '../../core/widgets/assignment_editor.dart';
import '../../core/widgets/week_navigator.dart';
import 'pw_recurring_screen.dart';

/// Slots of one week (weekId = Monday key).
final pwWeekSlotsProvider =
    StreamProvider.family<List<PwSlot>, String>((ref, weekId) {
  final monday = parseDateKey(weekId);
  final sunday = dateKey(monday.add(const Duration(days: 6)));
  return ref.watch(pwRepositoryProvider).watchRange(weekId, sunday);
});

/// Ensures recurring rules are materialized ahead; runs once per session for
/// PW admins (publishers only read existing slots).
final pwMaterializationProvider = FutureProvider<void>((ref) async {
  if (!ref.watch(myRolesProvider).canEditPublicWitnessing()) return;
  final repo = ref.watch(pwRepositoryProvider);
  final rules = await repo.watchRecurring().first;
  for (final rule in rules) {
    await repo.materializeRule(rule);
  }
});

class PwScreen extends ConsumerWidget {
  const PwScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pwMaterializationProvider);
    final canEdit = ref.watch(myRolesProvider).canEditPublicWitnessing();
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
                  subtitle: AssignmentText(slot.assignment),
                  trailing: canEdit
                      ? IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => ref
                              .read(pwRepositoryProvider)
                              .deleteSlot(slot),
                        )
                      : null,
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
}

/// Create/edit one concrete slot.
Future<void> showPwSlotDialog(BuildContext context, WidgetRef ref,
    {PwSlot? existing}) async {
  final l10n = context.l10n;
  var slot = existing ?? PwSlot(date: dateKey(DateTime.now()));
  final locationCtrl = TextEditingController(text: slot.location);

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
    await ref
        .read(pwRepositoryProvider)
        .saveSlot(slot.copyWith(location: locationCtrl.text.trim()));
    ref.invalidate(assignmentHistoryProvider);
  }
  locationCtrl.dispose();
}
