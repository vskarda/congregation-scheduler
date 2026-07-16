import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/notifications/reminder_settings_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> containerWith(Map<String, Object> initial) async {
  SharedPreferences.setMockInitialValues(initial);
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('defaults to disabled with a single 1-day reminder', () async {
    final container = await containerWith({});
    final settings = container.read(reminderSettingsProvider);
    expect(settings.enabled, isFalse);
    expect(settings.reminders, [
      const ReminderSetting(value: 1, unit: ReminderUnit.days),
    ]);
  });

  test('persists enabled flag and reminders across reloads', () async {
    final container = await containerWith({});
    final notifier = container.read(reminderSettingsProvider.notifier);
    await notifier.setEnabled(true);
    await notifier.setReminders(const [
      ReminderSetting(value: 2, unit: ReminderUnit.hours),
      ReminderSetting(value: 6, unit: ReminderUnit.days),
    ]);

    // Rebuild the provider from the same (mock-backed) prefs.
    container.invalidate(reminderSettingsProvider);
    final reloaded = container.read(reminderSettingsProvider);
    expect(reloaded.enabled, isTrue);
    expect(reloaded.reminders, const [
      ReminderSetting(value: 2, unit: ReminderUnit.hours),
      ReminderSetting(value: 6, unit: ReminderUnit.days),
    ]);
  });

  test('falls back to defaults on corrupted JSON', () async {
    final container = await containerWith({
      'assignment_reminders': 'not-json',
      'assignment_reminders_enabled': true,
    });
    final settings = container.read(reminderSettingsProvider);
    expect(settings.enabled, isTrue);
    expect(settings.reminders, [
      const ReminderSetting(value: 1, unit: ReminderUnit.days),
    ]);
  });

  test('drops malformed entries but keeps valid ones', () async {
    final container = await containerWith({
      'assignment_reminders':
          '[{"value":3,"unit":"hours"},{"value":0,"unit":"days"},{"unit":"days"},{"value":5,"unit":"weeks"}]',
    });
    final settings = container.read(reminderSettingsProvider);
    expect(settings.reminders, const [
      ReminderSetting(value: 3, unit: ReminderUnit.hours),
    ]);
  });

  test('deduplicates and caps at the maximum', () async {
    final container = await containerWith({});
    final notifier = container.read(reminderSettingsProvider.notifier);
    await notifier.setReminders(const [
      ReminderSetting(value: 1, unit: ReminderUnit.hours),
      ReminderSetting(value: 1, unit: ReminderUnit.hours),
      ReminderSetting(value: 2, unit: ReminderUnit.hours),
      ReminderSetting(value: 3, unit: ReminderUnit.hours),
      ReminderSetting(value: 4, unit: ReminderUnit.hours),
      ReminderSetting(value: 5, unit: ReminderUnit.hours),
      ReminderSetting(value: 6, unit: ReminderUnit.hours),
    ]);
    final reminders = container.read(reminderSettingsProvider).reminders;
    expect(reminders.length, kMaxReminderSettings);
    // First duplicate collapsed, distinct values preserved in order.
    expect(reminders.first, const ReminderSetting(value: 1, unit: ReminderUnit.hours));
  });

  test('empty reminder list falls back to the default', () async {
    final container = await containerWith({});
    final notifier = container.read(reminderSettingsProvider.notifier);
    await notifier.setReminders(const []);
    expect(container.read(reminderSettingsProvider).reminders, [
      const ReminderSetting(value: 1, unit: ReminderUnit.days),
    ]);
  });
}
