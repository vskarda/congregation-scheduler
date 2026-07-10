import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/congregation_repository.dart';
import '../../core/data/lmm_repository.dart';
import '../../core/data/pw_repository.dart';
import '../../core/data/weekend_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';

enum AssignmentSource { lmm, weekend, pw }

/// One row of "my upcoming assignments". [roleKey] is localized by the UI
/// (part-type names, 'assistant', 'speaker', 'wtReader', 'attendants',
/// 'microphones', 'audioVideo', 'custom', 'pw'); [detail] is raw text
/// (part title, custom label, or location).
class MyAssignmentEntry {
  const MyAssignmentEntry({
    required this.source,
    required this.date,
    required this.roleKey,
    this.detail = '',
    this.time,
    this.endTime,
  });

  final AssignmentSource source;
  final String date;
  final String roleKey;
  final String detail;
  final String? time;
  final String? endTime;
}

final myUpcomingAssignmentsProvider =
    FutureProvider<List<MyAssignmentEntry>>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const [];
  final meta = ref.watch(congregationMetaProvider).value ??
      const CongregationMeta();
  final today = dateKey(DateTime.now());
  final entries = <MyAssignmentEntry>[];

  void addSupport(
    AssignmentSource source,
    String date,
    String time, {
    required Assignment attendants,
    required Assignment microphones,
    required Assignment audioVideo,
    required List<CustomAssignment> custom,
  }) {
    if (attendants.contains(uid)) {
      entries.add(MyAssignmentEntry(
          source: source, date: date, roleKey: 'attendants', time: time));
    }
    if (microphones.contains(uid)) {
      entries.add(MyAssignmentEntry(
          source: source, date: date, roleKey: 'microphones', time: time));
    }
    if (audioVideo.contains(uid)) {
      entries.add(MyAssignmentEntry(
          source: source, date: date, roleKey: 'audioVideo', time: time));
    }
    for (final c in custom) {
      if (c.assignment.contains(uid)) {
        entries.add(MyAssignmentEntry(
            source: source,
            date: date,
            roleKey: 'custom',
            detail: c.label,
            time: time));
      }
    }
  }

  final lmmWeeks =
      await ref.watch(lmmRepositoryProvider).getAssignedTo(uid);
  for (final week in lmmWeeks) {
    final monday = tryParseDateKey(week.id);
    if (monday == null) continue;
    final date =
        dateKey(monday.add(Duration(days: meta.lmmWeekday - 1)));
    if (date.compareTo(today) < 0) continue;
    for (final part in week.parts) {
      if (part.assignment.contains(uid)) {
        entries.add(MyAssignmentEntry(
            source: AssignmentSource.lmm,
            date: date,
            roleKey: part.type.name,
            detail: part.title,
            time: meta.lmmTime));
      }
      if (part.assistant.contains(uid)) {
        entries.add(MyAssignmentEntry(
            source: AssignmentSource.lmm,
            date: date,
            roleKey: 'assistant',
            detail: part.title,
            time: meta.lmmTime));
      }
    }
    addSupport(AssignmentSource.lmm, date, meta.lmmTime,
        attendants: week.attendants,
        microphones: week.microphones,
        audioVideo: week.audioVideo,
        custom: week.customAssignments);
  }

  final weekendWeeks =
      await ref.watch(weekendRepositoryProvider).getAssignedTo(uid);
  for (final week in weekendWeeks) {
    final monday = tryParseDateKey(week.id);
    if (monday == null) continue;
    final date =
        dateKey(monday.add(Duration(days: meta.weekendWeekday - 1)));
    if (date.compareTo(today) < 0) continue;
    if (week.speaker.contains(uid)) {
      entries.add(MyAssignmentEntry(
          source: AssignmentSource.weekend,
          date: date,
          roleKey: 'speaker',
          detail: week.talkTitle,
          time: meta.weekendTime));
    }
    if (week.chairman.contains(uid)) {
      entries.add(MyAssignmentEntry(
          source: AssignmentSource.weekend,
          date: date,
          roleKey: 'weekendChairman',
          time: meta.weekendTime));
    }
    if (week.wtReader.contains(uid)) {
      entries.add(MyAssignmentEntry(
          source: AssignmentSource.weekend,
          date: date,
          roleKey: 'wtReader',
          time: meta.weekendTime));
    }
    for (final c in week.customFields) {
      if (c.assignment.contains(uid)) {
        entries.add(MyAssignmentEntry(
            source: AssignmentSource.weekend,
            date: date,
            roleKey: 'custom',
            detail: c.label,
            time: meta.weekendTime));
      }
    }
    addSupport(AssignmentSource.weekend, date, meta.weekendTime,
        attendants: week.attendants,
        microphones: week.microphones,
        audioVideo: week.audioVideo,
        custom: week.customAssignments);
  }

  final slots = await ref.watch(pwRepositoryProvider).getAssignedTo(uid);
  for (final slot in slots) {
    if (slot.date.compareTo(today) < 0) continue;
    entries.add(MyAssignmentEntry(
        source: AssignmentSource.pw,
        date: slot.date,
        roleKey: 'pw',
        detail: slot.location,
        time: slot.startTime,
        endTime: slot.endTime));
  }

  entries.sort((a, b) => a.date.compareTo(b.date));
  return entries;
});
