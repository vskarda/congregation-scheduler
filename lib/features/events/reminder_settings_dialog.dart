import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/notifications/assignment_reminder_service.dart';
import '../../core/notifications/reminder_settings_provider.dart';
import '../../core/utils/numeric_input.dart';

/// Opens the assignment-reminders settings dialog (mobile only; the caller
/// hides the entry point on web).
Future<void> showReminderSettingsDialog(BuildContext context, WidgetRef ref) {
  return showDialog<void>(
    context: context,
    builder: (_) => const _ReminderSettingsDialog(),
  );
}

class _ReminderSettingsDialog extends ConsumerWidget {
  const _ReminderSettingsDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(reminderSettingsProvider);
    final notifier = ref.read(reminderSettingsProvider.notifier);

    Future<void> toggle(bool enable) async {
      if (!enable) {
        await notifier.setEnabled(false);
        return;
      }
      final granted =
          await ref.read(assignmentReminderServiceProvider).requestPermissions();
      if (!context.mounted) return;
      if (!granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.remindersPermissionDenied)),
        );
        return;
      }
      await notifier.setEnabled(true);
    }

    void updateAt(int index, ReminderSetting value) {
      final next = [...settings.reminders]..[index] = value;
      notifier.setReminders(next);
    }

    void removeAt(int index) {
      final next = [...settings.reminders]..removeAt(index);
      notifier.setReminders(next);
    }

    void add() {
      notifier.setReminders([
        ...settings.reminders,
        const ReminderSetting(value: 1, unit: ReminderUnit.hours),
      ]);
    }

    return AlertDialog(
      title: Text(l10n.remindersTitle),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.remindersDescription,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.remindersEnable),
              value: settings.enabled,
              onChanged: toggle,
            ),
            if (settings.enabled) ...[
              const Divider(height: 8),
              for (var i = 0; i < settings.reminders.length; i++)
                _ReminderRow(
                  key: ValueKey(i),
                  setting: settings.reminders[i],
                  onChanged: (v) => updateAt(i, v),
                  onDelete: settings.reminders.length > 1
                      ? () => removeAt(i)
                      : null,
                ),
              if (settings.reminders.length < kMaxReminderSettings)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l10n.remindersAdd),
                    onPressed: add,
                  ),
                ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonClose),
        ),
      ],
    );
  }
}

class _ReminderRow extends StatefulWidget {
  const _ReminderRow({
    super.key,
    required this.setting,
    required this.onChanged,
    required this.onDelete,
  });

  final ReminderSetting setting;
  final ValueChanged<ReminderSetting> onChanged;
  final VoidCallback? onDelete;

  @override
  State<_ReminderRow> createState() => _ReminderRowState();
}

class _ReminderRowState extends State<_ReminderRow> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.setting.value.toString());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _commitValue(String raw) {
    final parsed = int.tryParse(raw) ?? 1;
    final clamped = parsed.clamp(1, 999);
    if (clamped.toString() != _controller.text) {
      _controller.text = clamped.toString();
    }
    widget.onChanged(
      ReminderSetting(value: clamped, unit: widget.setting.unit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: TextField(
              controller: _controller,
              keyboardType: numericKeyboardType,
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              decoration: const InputDecoration(isDense: true),
              onChanged: (v) {
                final parsed = int.tryParse(v);
                if (parsed != null && parsed >= 1 && parsed <= 999) {
                  widget.onChanged(
                    ReminderSetting(value: parsed, unit: widget.setting.unit),
                  );
                }
              },
              onSubmitted: _commitValue,
              onEditingComplete: () => _commitValue(_controller.text),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<ReminderUnit>(
              isExpanded: true,
              value: widget.setting.unit,
              onChanged: (unit) {
                if (unit != null) {
                  widget.onChanged(
                    ReminderSetting(value: widget.setting.value, unit: unit),
                  );
                }
              },
              items: [
                DropdownMenuItem(
                  value: ReminderUnit.minutes,
                  child: Text(l10n.reminderUnitMinutes),
                ),
                DropdownMenuItem(
                  value: ReminderUnit.hours,
                  child: Text(l10n.reminderUnitHours),
                ),
                DropdownMenuItem(
                  value: ReminderUnit.days,
                  child: Text(l10n.reminderUnitDays),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.commonDelete,
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }
}
