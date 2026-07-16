import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// A resolved notification ready to be scheduled.
class ScheduledNotification {
  const ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.fireAt,
  });

  final int id;
  final String title;
  final String body;
  final DateTime fireAt;
}

const _channelId = 'assignment_reminders';

/// Wraps [FlutterLocalNotificationsPlugin] for scheduling assignment reminders.
/// All methods are no-ops on web (the plugin has no web implementation).
class AssignmentReminderService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void>? _initFuture;
  // Serializes cancelAll + schedule bursts so overlapping syncs can't interleave.
  Future<void> _queue = Future.value();

  /// Lazily initializes the timezone database and the plugin exactly once.
  Future<void> ensureInitialized() => _initFuture ??= _init();

  Future<void> _init() async {
    if (kIsWeb) return;
    tz.initializeTimeZones();
    try {
      final local = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(local));
    } catch (_) {
      // Keep the timezone package default; scheduling still works, though
      // fire times may drift for exotic zones.
    }
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // Permission is requested at enable time, not at init.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  /// Requests notification permission. Returns whether notifications are
  /// permitted (true on platforms that need no runtime grant).
  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;
    await ensureInitialized();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      // Pre-API-33 there is no runtime permission; the plugin returns null.
      return await android.requestNotificationsPermission() ?? true;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }
    return false;
  }

  /// Cancels all pending reminders and schedules [notifications] in their place.
  /// Serialized against other calls to this service.
  Future<void> replaceAll(
    List<ScheduledNotification> notifications, {
    required String channelName,
    required String channelDescription,
  }) {
    if (kIsWeb) return Future.value();
    final task = () async {
      await ensureInitialized();
      await _plugin.cancelAll();
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
        ),
        iOS: const DarwinNotificationDetails(),
      );
      for (final n in notifications) {
        await _plugin.zonedSchedule(
          n.id,
          n.title,
          n.body,
          tz.TZDateTime.from(n.fireAt, tz.local),
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    }();
    _queue = _queue.then((_) => task).catchError((_) {});
    return task;
  }

  /// Cancels all pending reminders. Serialized against other calls.
  Future<void> cancelAll() {
    if (kIsWeb) return Future.value();
    final task = () async {
      await ensureInitialized();
      await _plugin.cancelAll();
    }();
    _queue = _queue.then((_) => task).catchError((_) {});
    return task;
  }
}

final assignmentReminderServiceProvider = Provider<AssignmentReminderService>(
  (ref) => AssignmentReminderService(),
);
