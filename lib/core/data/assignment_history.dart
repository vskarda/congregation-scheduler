import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../models/models.dart';
import '../utils/dates.dart';
import 'lmm_repository.dart';
import 'pw_repository.dart';
import 'weekend_repository.dart';

/// History keys group assignments for the "least recently assigned" ordering
/// in the publisher picker.
abstract final class HistoryKeys {
  static String lmmPart(LmmPartType type) => 'lmm.${type.name}';
  static const lmmAssistant = 'lmm.assistant';
  static const weekendSpeaker = 'weekend.speaker';
  static const weekendChairman = 'weekend.chairman';
  static const weekendWtReader = 'weekend.wtReader';
  static const attendant = 'support.attendant';
  static const microphone = 'support.microphone';
  static const audioVideo = 'support.audioVideo';
  static const custom = 'custom';
  static const publicWitnessing = 'pw';
}

/// historyKey -> (publisherId -> most recent assignment date, incl. future
/// weeks so already-booked publishers sort to the back).
///
/// Invalidate this provider after saving any schedule.
final assignmentHistoryProvider =
    FutureProvider<Map<String, Map<String, String>>>((ref) async {
  final from =
      weekIdOf(addMonths(DateTime.now(), -AppConfig.pickerHistoryMonths));
  const until = '9999-12-31';

  final result = <String, Map<String, String>>{};
  void record(String key, Assignment assignment, String date) {
    final byUid = result.putIfAbsent(key, () => {});
    for (final uid in assignment.publisherIds) {
      final prev = byUid[uid];
      if (prev == null || date.compareTo(prev) > 0) byUid[uid] = date;
    }
  }

  final lmmWeeks =
      await ref.watch(lmmRepositoryProvider).getRange(from, until);
  for (final week in lmmWeeks) {
    for (final part in week.parts) {
      record(HistoryKeys.lmmPart(part.type), part.assignment, week.id);
      record(HistoryKeys.lmmAssistant, part.assistant, week.id);
    }
    record(HistoryKeys.attendant, week.attendants, week.id);
    record(HistoryKeys.microphone, week.microphones, week.id);
    record(HistoryKeys.audioVideo, week.audioVideo, week.id);
    for (final c in week.customAssignments) {
      record(HistoryKeys.custom, c.assignment, week.id);
    }
  }

  final weekendWeeks =
      await ref.watch(weekendRepositoryProvider).getRange(from, until);
  for (final week in weekendWeeks) {
    record(HistoryKeys.weekendSpeaker, week.speaker, week.id);
    record(HistoryKeys.weekendChairman, week.chairman, week.id);
    record(HistoryKeys.weekendWtReader, week.wtReader, week.id);
    for (final c in week.customFields) {
      record(HistoryKeys.custom, c.assignment, week.id);
    }
    record(HistoryKeys.attendant, week.attendants, week.id);
    record(HistoryKeys.microphone, week.microphones, week.id);
    record(HistoryKeys.audioVideo, week.audioVideo, week.id);
    for (final c in week.customAssignments) {
      record(HistoryKeys.custom, c.assignment, week.id);
    }
  }

  final slots = await ref.watch(pwRepositoryProvider).getRange(from, until);
  for (final slot in slots) {
    record(HistoryKeys.publicWitnessing, slot.assignment, slot.date);
  }

  return result;
});
