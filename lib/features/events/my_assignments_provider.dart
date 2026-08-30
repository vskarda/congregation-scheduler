import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/data/co_visit_repository.dart';
import '../../core/data/congregation_repository.dart';
import '../../core/data/fsm_repository.dart';
import '../../core/data/lmm_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/data/pw_repository.dart';
import '../../core/data/schedule_config_repository.dart';
import '../../core/data/weekend_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';

enum AssignmentSource { lmm, weekend, pw, fsm, coVisit, memorial }

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

final myUpcomingAssignmentsProvider = FutureProvider<List<MyAssignmentEntry>>((
  ref,
) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const [];
  final meta =
      ref.watch(congregationMetaProvider).value ?? const CongregationMeta();
  final today = dateKey(DateTime.now());
  final entries = <MyAssignmentEntry>[];

  // A week whose names are hidden is not announced to the publisher at all:
  // it contributes no line here, and so schedules no reminder either. Read
  // with the real roles rather than the effective ones — an admin who hides
  // the admin UI must not lose their own reminders while previewing.
  final roles = ref.watch(myRolesProvider);
  final configRepo = ref.watch(scheduleConfigRepositoryProvider);
  final configs = <ScheduleKind, ScheduleConfig>{};
  for (final kind in ScheduleKind.values) {
    configs[kind] = canEditSchedule(roles, kind)
        ? const ScheduleConfig()
        : await configRepo.getConfig(ScheduleConfigDoc.of(kind));
  }
  bool shown(ScheduleKind kind, String weekId) =>
      configs[kind]!.showsAssignees(weekId);

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
      entries.add(
        MyAssignmentEntry(
          source: source,
          date: date,
          roleKey: 'attendants',
          time: time,
        ),
      );
    }
    if (microphones.contains(uid)) {
      entries.add(
        MyAssignmentEntry(
          source: source,
          date: date,
          roleKey: 'microphones',
          time: time,
        ),
      );
    }
    if (audioVideo.contains(uid)) {
      entries.add(
        MyAssignmentEntry(
          source: source,
          date: date,
          roleKey: 'audioVideo',
          time: time,
        ),
      );
    }
    for (final c in custom) {
      if (c.assignment.contains(uid)) {
        entries.add(
          MyAssignmentEntry(
            source: source,
            date: date,
            roleKey: 'custom',
            detail: c.label,
            time: time,
          ),
        );
      }
    }
  }

  /// The Memorial's four name slots plus its own program fields. Emitted for
  /// whichever meeting week runs it — the Memorial can fall on either day.
  void addMemorial(MemorialProgram m, String date, String time) {
    for (final slot in [
      (roleKey: 'memorialChairman', assignment: m.chairman),
      (roleKey: 'memorialSpeaker', assignment: m.speaker),
      (roleKey: 'memorialBreadPrayer', assignment: m.breadPrayer),
      (roleKey: 'memorialWinePrayer', assignment: m.winePrayer),
    ]) {
      if (!slot.assignment.contains(uid)) continue;
      entries.add(MyAssignmentEntry(
        source: AssignmentSource.memorial,
        date: date,
        roleKey: slot.roleKey,
        time: time,
      ));
    }
    for (final c in m.customFields) {
      if (!c.assignment.contains(uid)) continue;
      entries.add(MyAssignmentEntry(
        source: AssignmentSource.memorial,
        date: date,
        roleKey: 'custom',
        detail: c.label,
        time: time,
      ));
    }
  }

  final lmmWeeks = await ref.watch(lmmRepositoryProvider).getAssignedTo(uid);
  for (final week in lmmWeeks) {
    final monday = tryParseDateKey(week.id);
    if (monday == null) continue;
    if (!shown(ScheduleKind.lmm, week.id)) continue;
    // A week may hold its meeting on another day/time than usual (circuit
    // overseer's visit, assembly) — that is what a reminder must fire for.
    final date = dateKey(
      monday.add(Duration(days: week.weekdayOr(meta.lmmWeekday) - 1)),
    );
    final time = week.timeOr(meta.lmmTime);
    if (date.compareTo(today) < 0) continue;
    // No meeting, nobody serving: the parts stay in the document but they
    // are not what this week runs, so they raise no line and no reminder.
    if (week.programKind == MeetingProgramKind.nothingPlanned) continue;
    if (week.programKind == MeetingProgramKind.memorial) {
      addMemorial(week.memorialOrEmpty, date, time);
    }
    for (final part in week.isRegular ? week.parts : const <LmmPart>[]) {
      if (part.assignment.contains(uid)) {
        entries.add(
          MyAssignmentEntry(
            source: AssignmentSource.lmm,
            date: date,
            roleKey: part.type.name,
            detail: part.title,
            time: time,
          ),
        );
      }
      if (part.assistant.contains(uid)) {
        entries.add(
          MyAssignmentEntry(
            source: AssignmentSource.lmm,
            date: date,
            roleKey: 'assistant',
            detail: part.title,
            time: time,
          ),
        );
      }
      // Auxiliary-class slots are only surfaced while the class is enabled
      // in the congregation settings (data survives a disable/re-enable).
      for (var c = 2; c <= meta.lmmClassCount.clamp(1, 3); c++) {
        if (part.assignmentFor(c).contains(uid)) {
          entries.add(
            MyAssignmentEntry(
              source: AssignmentSource.lmm,
              date: date,
              roleKey: '${part.type.name}#$c',
              detail: part.title,
              time: time,
            ),
          );
        }
        if (part.assistantFor(c).contains(uid)) {
          entries.add(
            MyAssignmentEntry(
              source: AssignmentSource.lmm,
              date: date,
              roleKey: 'assistant#$c',
              detail: part.title,
              time: time,
            ),
          );
        }
      }
    }
    addSupport(
      AssignmentSource.lmm,
      date,
      time,
      attendants: week.attendants,
      // The Memorial arranges attendants and audio/video only, so a
      // microphone slot left over from the regular program stays dormant.
      microphones: week.isRegular ? week.microphones : const Assignment(),
      audioVideo: week.audioVideo,
      custom: week.customAssignments,
    );
  }

  final weekendWeeks = await ref
      .watch(weekendRepositoryProvider)
      .getAssignedTo(uid);
  for (final week in weekendWeeks) {
    final monday = tryParseDateKey(week.id);
    if (monday == null) continue;
    if (!shown(ScheduleKind.weekend, week.id)) continue;
    final date = dateKey(
      monday.add(Duration(days: week.weekdayOr(meta.weekendWeekday) - 1)),
    );
    final time = week.timeOr(meta.weekendTime);
    if (date.compareTo(today) < 0) continue;
    if (week.programKind == MeetingProgramKind.nothingPlanned) continue;
    if (week.programKind == MeetingProgramKind.memorial) {
      addMemorial(week.memorialOrEmpty, date, time);
    }
    if (week.isRegular && week.speaker.contains(uid)) {
      entries.add(
        MyAssignmentEntry(
          source: AssignmentSource.weekend,
          date: date,
          roleKey: 'speaker',
          detail: week.talkTitle,
          time: time,
        ),
      );
    }
    if (week.isRegular && week.chairman.contains(uid)) {
      entries.add(
        MyAssignmentEntry(
          source: AssignmentSource.weekend,
          date: date,
          roleKey: 'weekendChairman',
          time: time,
        ),
      );
    }
    if (week.isRegular && week.wtReader.contains(uid)) {
      entries.add(
        MyAssignmentEntry(
          source: AssignmentSource.weekend,
          date: date,
          roleKey: 'wtReader',
          time: time,
        ),
      );
    }
    for (final c in week.isRegular ? week.customFields : const []) {
      if (c.assignment.contains(uid)) {
        entries.add(
          MyAssignmentEntry(
            source: AssignmentSource.weekend,
            date: date,
            roleKey: 'custom',
            detail: c.label,
            time: time,
          ),
        );
      }
    }
    addSupport(
      AssignmentSource.weekend,
      date,
      time,
      attendants: week.attendants,
      // The Memorial arranges attendants and audio/video only, so a
      // microphone slot left over from the regular program stays dormant.
      microphones: week.isRegular ? week.microphones : const Assignment(),
      audioVideo: week.audioVideo,
      custom: week.customAssignments,
    );
  }

  // Expanded from the rules, not queried: most recurring slots have no
  // document of their own, so an array-contains query would miss them.
  final slots = await ref.watch(pwRepositoryProvider).expandAssignedTo(
        uid,
        today,
        dateKey(addMonths(DateTime.now(), AppConfig.pwMaterializeMonthsAhead)),
      );
  for (final slot in slots) {
    if (!shown(ScheduleKind.pw, weekIdOf(parseDateKey(slot.date)))) continue;
    entries.add(
      MyAssignmentEntry(
        source: AssignmentSource.pw,
        date: slot.date,
        roleKey: 'pw',
        detail: slot.location,
        time: slot.startTime,
        endTime: slot.endTime,
      ),
    );
  }

  // Expanded from the rules, not queried: most recurring meetings have no
  // document of their own, so an array-contains query would miss them.
  final meetings = await ref.watch(fsmRepositoryProvider).expandAssignedTo(
        uid,
        today,
        dateKey(addMonths(DateTime.now(), AppConfig.fsmMaterializeMonthsAhead)),
      );
  for (final meeting in meetings) {
    if (!shown(ScheduleKind.fsm, weekIdOf(parseDateKey(meeting.date)))) {
      continue;
    }
    // A meeting can name someone in three different ways during a circuit
    // overseer's visit, and each is its own entry — conducting the meeting
    // and sharing in the ministry with the overseer are not the same duty.
    for (final slot in [
      (roleKey: 'fsm', assignment: meeting.assignment),
      (roleKey: 'withCo', assignment: meeting.withCo),
      (roleKey: 'withCoWife', assignment: meeting.withCoWife),
    ]) {
      if (!slot.assignment.contains(uid)) continue;
      entries.add(
        MyAssignmentEntry(
          source: AssignmentSource.fsm,
          date: meeting.date,
          roleKey: slot.roleKey,
          detail: meeting.location,
          time: meeting.time,
        ),
      );
    }
  }

  // Arrangements for a circuit overseer's visit. A day or a time may still be
  // missing (nothing about a visit is required); an entry without a time
  // shows up in the list but schedules no reminder.
  final visits = await ref.watch(coVisitRepositoryProvider).getAssignedTo(uid);
  for (final visit in visits) {
    for (final item in visit.items) {
      if (!item.assignment.contains(uid)) continue;
      if (item.date.isEmpty || item.date.compareTo(today) < 0) continue;
      entries.add(
        MyAssignmentEntry(
          source: AssignmentSource.coVisit,
          date: item.date,
          roleKey: 'co.${item.section.name}',
          detail: item.address,
          time: item.time.isEmpty ? null : item.time,
        ),
      );
    }
  }

  entries.sort((a, b) => a.date.compareTo(b.date));
  return entries;
});
