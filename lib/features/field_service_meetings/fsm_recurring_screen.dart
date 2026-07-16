import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/assignment_history.dart';
import '../../core/data/fsm_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/assignment_chips.dart';
import '../../core/widgets/assignment_editor.dart';

/// Admin management of recurring field-service-meeting rules.
class FsmRecurringScreen extends ConsumerWidget {
  const FsmRecurringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final rules = ref.watch(fsmRecurringProvider);
    final locale = Localizations.localeOf(context).toString();
    // DateFormat weekday demo dates: 2026-06-01 is a Monday.
    String weekdayName(int weekday) => DateFormat.EEEE(locale)
        .format(DateTime(2026, 6, weekday));

    final error = Theme.of(context).colorScheme.error;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fsmRecurringRules),
        actions: [
          IconButton(
            tooltip: l10n.fsmRemoveAllFutureAction,
            icon: Icon(Icons.delete_sweep_outlined, color: error),
            onPressed: () => _confirmDeleteAllFuture(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.fsmRecurringAdd,
        onPressed: () => _showRuleDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.errorContainer,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.fsmRemoveAllFutureWarning,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: rules.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text(l10n.commonErrorDetail(e.toString()))),
              data: (list) => ListView(
                children: [
                  for (final rule in list)
                    Card(
                      child: ListTile(
                        title:
                            Text('${weekdayName(rule.weekday)}  ${rule.time}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (rule.location.isNotEmpty) Text(rule.location),
                            AssignmentText(rule.defaultAssignment),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () =>
                              _confirmDeleteRule(context, ref, rule),
                        ),
                        onTap: () =>
                            _showRuleDialog(context, ref, existing: rule),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteRule(
      BuildContext context, WidgetRef ref, FsmRecurring rule) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.commonConfirmDeleteTitle),
        content: Text(l10n.fsmRecurringDeleteConfirm),
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
      await ref.read(fsmRepositoryProvider).deleteRecurring(rule.id);
      ref.invalidate(assignmentHistoryProvider);
    }
  }

  Future<void> _confirmDeleteAllFuture(
      BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final error = Theme.of(context).colorScheme.error;
    await showDialog<void>(
      context: context,
      builder: (context) {
        var busy = false;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            icon: Icon(Icons.warning_amber_rounded, color: error, size: 32),
            title: Text(l10n.fsmRemoveAllFutureTitle),
            content: Text(l10n.fsmRemoveAllFutureBody),
            actions: [
              TextButton(
                onPressed: busy ? null : () => Navigator.of(context).pop(),
                child: Text(l10n.commonCancel),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                onPressed: busy
                    ? null
                    : () async {
                        setState(() => busy = true);
                        await ref
                            .read(fsmRepositoryProvider)
                            .deleteAllFutureMeetings();
                        ref.invalidate(assignmentHistoryProvider);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                child: busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.fsmRemoveAllFutureConfirm),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showRuleDialog(BuildContext context, WidgetRef ref,
      {FsmRecurring? existing}) async {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    String weekdayName(int weekday) =>
        DateFormat.EEEE(locale).format(DateTime(2026, 6, weekday));

    var rule = existing ??
        FsmRecurring(validFrom: dateKey(DateTime.now()));
    final locationCtrl = TextEditingController(text: rule.location);

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickTime() async {
            final parts = rule.time.split(':');
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(
                  hour: int.tryParse(parts[0]) ?? 9,
                  minute:
                      int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0),
            );
            if (picked != null) {
              final value =
                  '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
              setState(() => rule = rule.copyWith(time: value));
            }
          }

          Future<void> pickDate(bool from) async {
            final current = from ? rule.validFrom : rule.validUntil;
            final picked = await showDatePicker(
              context: context,
              initialDate: tryParseDateKey(current) ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() => rule = from
                  ? rule.copyWith(validFrom: dateKey(picked))
                  : rule.copyWith(validUntil: dateKey(picked)));
            }
          }

          return AlertDialog(
            title: Text(
                existing == null ? l10n.fsmRecurringAdd : l10n.fsmEditMeeting),
            content: SizedBox(
              width: 360,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      initialValue: rule.weekday,
                      decoration:
                          InputDecoration(labelText: l10n.fsmWeekday),
                      items: [
                        for (var d = DateTime.monday;
                            d <= DateTime.sunday;
                            d++)
                          DropdownMenuItem(
                              value: d, child: Text(weekdayName(d))),
                      ],
                      onChanged: (d) => setState(() =>
                          rule = rule.copyWith(weekday: d ?? rule.weekday)),
                    ),
                    ListTile(
                      dense: true,
                      title: Text(l10n.fsmTime),
                      subtitle: Text(rule.time),
                      onTap: pickTime,
                    ),
                    TextField(
                      controller: locationCtrl,
                      decoration:
                          InputDecoration(labelText: l10n.fsmLocation),
                    ),
                    ListTile(
                      dense: true,
                      title: Text(l10n.fsmValidFrom),
                      subtitle: Text(
                          rule.validFrom.isEmpty ? '—' : rule.validFrom),
                      onTap: () => pickDate(true),
                    ),
                    ListTile(
                      dense: true,
                      title: Text(l10n.fsmValidUntil),
                      subtitle: Text(
                          rule.validUntil.isEmpty ? '—' : rule.validUntil),
                      onTap: () => pickDate(false),
                    ),
                    ListTile(
                      dense: true,
                      title: Text(l10n.fsmConductor),
                      subtitle: AssignmentText(rule.defaultAssignment),
                      onTap: () async {
                        final result = await showAssignmentEditor(
                          context,
                          title: l10n.fsmConductor,
                          initial: rule.defaultAssignment,
                          historyKey: HistoryKeys.fieldServiceMeetings,
                          qualifies: (p) =>
                              p.qualifications.ministryMeetingConductor,
                          multi: false,
                        );
                        if (result != null) {
                          setState(() => rule =
                              rule.copyWith(defaultAssignment: result));
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
      final repo = ref.read(fsmRepositoryProvider);
      final finalRule =
          rule.copyWith(location: locationCtrl.text.trim());
      final id = await repo.saveRecurring(finalRule);
      await repo.materializeRule(finalRule.copyWith(id: id));
      ref.invalidate(assignmentHistoryProvider);
    }
    locationCtrl.dispose();
  }
}
