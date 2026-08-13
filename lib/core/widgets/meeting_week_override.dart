import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/l10n.dart';

/// A week's meeting day and time. Both null means "follow the congregation
/// setting"; the two always travel together, so a week is either regular or
/// fully re-scheduled — there is no half-overridden state to reason about.
typedef MeetingWeekOverride = ({int? weekday, String? time});

/// Row shown at the top of a schedule week: which day and time this week's
/// meeting is actually held. Tapping it (admins only) opens
/// [showMeetingWeekOverrideDialog].
class MeetingWeekTile extends StatelessWidget {
  const MeetingWeekTile({
    super.key,
    required this.weekday,
    required this.time,
    required this.isOverridden,
    required this.canEdit,
    required this.onTap,
  });

  /// DateTime.monday..DateTime.sunday, already resolved (week override or
  /// congregation setting).
  final int weekday;
  final String time;

  /// Whether [weekday]/[time] come from this week rather than the
  /// congregation setting — shown as a badge so a moved meeting is obvious.
  final bool isOverridden;
  final bool canEdit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    return ListTile(
      dense: true,
      leading: Icon(
        Icons.event_outlined,
        color: isOverridden ? theme.colorScheme.primary : null,
      ),
      title: Text('${weekdayName(locale, weekday)}  ·  $time'),
      subtitle: isOverridden ? Text(l10n.meetingWeekChanged) : null,
      trailing: canEdit ? const Icon(Icons.edit_outlined, size: 18) : null,
      onTap: canEdit ? onTap : null,
    );
  }
}

/// Localized name of [weekday] (DateTime.monday..DateTime.sunday). June 2026
/// starts on a Monday, so day-of-month equals the weekday number.
String weekdayName(String locale, int weekday) =>
    DateFormat.EEEE(locale).format(DateTime(2026, 6, weekday));

/// Asks for this week's meeting day and time. Returns null when cancelled,
/// `(weekday: null, time: null)` when the week should follow the congregation
/// setting again, or the day and time to hold this one meeting at.
Future<MeetingWeekOverride?> showMeetingWeekOverrideDialog(
  BuildContext context, {
  required String title,
  required MeetingWeekOverride current,
  required int defaultWeekday,
  required String defaultTime,
}) {
  var custom = current.weekday != null || current.time != null;
  var weekday = current.weekday ?? defaultWeekday;
  var time = current.time ?? defaultTime;

  return showDialog<MeetingWeekOverride>(
    context: context,
    builder: (context) {
      final l10n = context.l10n;
      final locale = Localizations.localeOf(context).toString();
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickTime() async {
            final parts = time.split(':');
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(
                hour: int.tryParse(parts[0]) ?? 18,
                minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
              ),
            );
            if (picked == null) return;
            setState(() => time = '${picked.hour.toString().padLeft(2, '0')}'
                ':${picked.minute.toString().padLeft(2, '0')}');
          }

          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: custom,
                    title: Text(l10n.meetingWeekDifferent),
                    subtitle: Text(l10n.meetingWeekFollows(
                        weekdayName(locale, defaultWeekday), defaultTime)),
                    onChanged: (v) => setState(() => custom = v),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    initialValue: weekday,
                    decoration:
                        InputDecoration(labelText: l10n.meetingWeekDay),
                    items: [
                      for (var d = DateTime.monday; d <= DateTime.sunday; d++)
                        DropdownMenuItem(
                            value: d, child: Text(weekdayName(locale, d))),
                    ],
                    onChanged: custom
                        ? (d) => setState(() => weekday = d ?? weekday)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: Text(l10n.meetingWeekTime)),
                      OutlinedButton.icon(
                        onPressed: custom ? pickTime : null,
                        icon: const Icon(Icons.schedule, size: 18),
                        label: Text(time),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.commonCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(custom
                    ? (weekday: weekday, time: time)
                    : (weekday: null, time: null)),
                child: Text(l10n.commonSave),
              ),
            ],
          );
        },
      );
    },
  );
}
