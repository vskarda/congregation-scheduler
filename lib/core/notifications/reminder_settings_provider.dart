import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';

/// Unit of a reminder offset. Persisted by [ReminderUnit.name].
enum ReminderUnit { minutes, hours, days }

/// A single "remind me N units before the assignment" offset.
class ReminderSetting {
  const ReminderSetting({required this.value, required this.unit});

  /// How many [unit]s before the assignment to fire. The UI clamps to 1..999.
  final int value;
  final ReminderUnit unit;

  Duration get duration => switch (unit) {
    ReminderUnit.minutes => Duration(minutes: value),
    ReminderUnit.hours => Duration(hours: value),
    ReminderUnit.days => Duration(days: value),
  };

  Map<String, Object?> toJson() => {'value': value, 'unit': unit.name};

  /// Parses one persisted entry; returns null on malformed input so callers
  /// can drop it and fall back to defaults.
  static ReminderSetting? tryFromJson(Object? json) {
    if (json is! Map) return null;
    final value = json['value'];
    final unitName = json['unit'];
    if (value is! int || value < 1) return null;
    final unit = ReminderUnit.values
        .where((u) => u.name == unitName)
        .firstOrNull;
    if (unit == null) return null;
    return ReminderSetting(value: value, unit: unit);
  }

  @override
  bool operator ==(Object other) =>
      other is ReminderSetting && other.value == value && other.unit == unit;

  @override
  int get hashCode => Object.hash(value, unit);
}

/// Global, per-device reminder configuration. Applies to every upcoming
/// assignment. Disabled by default.
class ReminderSettings {
  const ReminderSettings({this.enabled = false, this.reminders = _default});

  static const List<ReminderSetting> _default = [
    ReminderSetting(value: 1, unit: ReminderUnit.days),
  ];

  final bool enabled;
  final List<ReminderSetting> reminders;

  ReminderSettings copyWith({bool? enabled, List<ReminderSetting>? reminders}) =>
      ReminderSettings(
        enabled: enabled ?? this.enabled,
        reminders: reminders ?? this.reminders,
      );
}

const _enabledKey = 'assignment_reminders_enabled';
const _listKey = 'assignment_reminders';

/// Maximum number of distinct reminder offsets a user can configure.
const kMaxReminderSettings = 5;

/// Persists reminder settings in shared_preferences (per device), following
/// the same Notifier-over-prefs pattern as `HideAdminUiNotifier`.
class ReminderSettingsNotifier extends Notifier<ReminderSettings> {
  @override
  ReminderSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final enabled = prefs.getBool(_enabledKey) ?? false;
    return ReminderSettings(
      enabled: enabled,
      reminders: _readReminders(prefs.getString(_listKey)),
    );
  }

  static List<ReminderSetting> _readReminders(String? raw) {
    if (raw == null || raw.isEmpty) return ReminderSettings._default;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return ReminderSettings._default;
      final parsed = decoded
          .map(ReminderSetting.tryFromJson)
          .whereType<ReminderSetting>()
          .toList();
      return parsed.isEmpty ? ReminderSettings._default : parsed;
    } catch (_) {
      return ReminderSettings._default;
    }
  }

  Future<void> setEnabled(bool enabled) async {
    state = state.copyWith(enabled: enabled);
    await ref.read(sharedPreferencesProvider).setBool(_enabledKey, enabled);
  }

  /// Deduplicates and caps at [kMaxReminderSettings] before persisting.
  Future<void> setReminders(List<ReminderSetting> reminders) async {
    final deduped = <ReminderSetting>[];
    for (final r in reminders) {
      if (!deduped.contains(r)) deduped.add(r);
      if (deduped.length >= kMaxReminderSettings) break;
    }
    final effective = deduped.isEmpty ? ReminderSettings._default : deduped;
    state = state.copyWith(reminders: effective);
    await ref
        .read(sharedPreferencesProvider)
        .setString(_listKey, jsonEncode(effective.map((r) => r.toJson()).toList()));
  }
}

final reminderSettingsProvider =
    NotifierProvider<ReminderSettingsNotifier, ReminderSettings>(
      ReminderSettingsNotifier.new,
    );
