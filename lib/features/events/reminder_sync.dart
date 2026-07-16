import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/l10n/l10n.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/notifications/assignment_reminder_service.dart';
import '../../core/notifications/reminder_computation.dart';
import '../../core/notifications/reminder_settings_provider.dart';
import '../../core/utils/dates.dart';
import 'events_screen.dart';
import 'my_assignments_provider.dart';

/// Keeps scheduled local reminders in sync with the user's upcoming
/// assignments and reminder settings. Mounted once above the router.
///
/// Notifications are only (re)scheduled while the app runs; assignment changes
/// made on the server while the app is closed are picked up on next open or
/// resume (see the resume handler). No-op on web.
class AssignmentReminderSync extends ConsumerStatefulWidget {
  const AssignmentReminderSync({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AssignmentReminderSync> createState() =>
      _AssignmentReminderSyncState();
}

class _AssignmentReminderSyncState
    extends ConsumerState<AssignmentReminderSync> {
  AppLifecycleListener? _lifecycle;
  Timer? _debounce;
  // Whether we've ever scheduled/cancelled — avoids touching the plugin (and
  // creating its notification channel) for users who never enable reminders.
  bool _didTouchPlugin = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) return;
    _lifecycle = AppLifecycleListener(
      onResume: () {
        if (ref.read(reminderSettingsProvider).enabled) {
          ref.invalidate(myUpcomingAssignmentsProvider);
        }
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _lifecycle?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return widget.child;

    final settings = ref.watch(reminderSettingsProvider);
    // Reschedule when the display locale changes (notification text is
    // resolved at schedule time).
    ref.watch(localeProvider);

    if (!settings.enabled || settings.reminders.isEmpty) {
      if (_didTouchPlugin) {
        _didTouchPlugin = false;
        _debounce?.cancel();
        unawaited(ref.read(assignmentReminderServiceProvider).cancelAll());
      }
      // Do not watch the assignments provider — keeps Firestore queries off
      // for users with reminders disabled.
      return widget.child;
    }

    final assignmentsAsync = ref.watch(myUpcomingAssignmentsProvider);
    assignmentsAsync.whenData(_scheduleDebounced);

    return widget.child;
  }

  void _scheduleDebounced(List<MyAssignmentEntry> assignments) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _resync(assignments);
    });
  }

  Future<void> _resync(List<MyAssignmentEntry> assignments) async {
    try {
      final settings = ref.read(reminderSettingsProvider);
      if (!settings.enabled || settings.reminders.isEmpty) return;

      final locale = ref.read(localeProvider) ?? PlatformDispatcher.instance.locale;
      final resolved = basicLocaleListResolution(
        [locale],
        AppLocalizations.supportedLocales,
      );
      final l10n = lookupAppLocalizations(resolved);
      final dateFmt = DateFormat.yMMMEd(resolved.toString());

      final planned = computePlannedReminders(
        assignments: assignments,
        reminders: settings.reminders,
        now: DateTime.now(),
      );

      final notifications = [
        for (final p in planned)
          ScheduledNotification(
            id: p.id,
            title: assignmentTitle(l10n, p.entry),
            body: _body(dateFmt, p.entry),
            fireAt: p.fireAt,
          ),
      ];

      _didTouchPlugin = true;
      await ref
          .read(assignmentReminderServiceProvider)
          .replaceAll(
            notifications,
            channelName: l10n.remindersChannelName,
            channelDescription: l10n.remindersChannelDescription,
          );
    } catch (e, st) {
      // Scheduling must never break the UI.
      debugPrint('AssignmentReminderSync: failed to schedule reminders: $e\n$st');
    }
  }

  String _body(DateFormat dateFmt, MyAssignmentEntry entry) {
    final date = dateFmt.format(parseDateKey(entry.date));
    final time = entry.time;
    if (time == null) return date;
    final timeLabel = entry.endTime == null ? time : '$time–${entry.endTime}';
    return '$date  $timeLabel';
  }
}
