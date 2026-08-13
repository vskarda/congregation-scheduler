import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/assignment_history.dart';
import '../../core/data/co_visit_repository.dart';
import '../../core/data/events_repository.dart';
import '../../core/data/lmm_repository.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';

/// Writes that keep a circuit overseer's visit, the events entry announcing
/// it and the week's midweek meeting day in step.
///
/// Each of those three lives under a different role: the visit under `events`,
/// the midweek meeting under `lmmSchedule`, the meetings for field service
/// under `fieldServiceMeetings`. An events-admin who has only the first can
/// plan the visit; the parts they may not write are skipped here and reported
/// back to the screen, never attempted and left to fail.

/// What a visit write deliberately did not do, so the screen can say so.
enum CoVisitSideEffect { midweekMeetingNotMoved }

/// Creates the visit of [weekId] (a Monday), announces it on the events
/// screen, and — for admins who may edit the midweek schedule — moves that
/// week's midweek meeting to Tuesday, the day the visit begins.
Future<Set<CoVisitSideEffect>> createCoVisit(
  WidgetRef ref,
  String weekId, {
  required CongregationMeta meta,
  required bool canEditLmm,
}) async {
  await ref.read(coVisitRepositoryProvider).save(CoVisit(id: weekId));
  await upsertCoVisitEvent(ref, weekId);
  if (!canEditLmm) return const {CoVisitSideEffect.midweekMeetingNotMoved};
  await moveMidweekMeetingToTuesday(ref, weekId, meta);
  return const {};
}

/// Removes the visit of [weekId] together with the events entry, and undoes
/// the midweek meeting move — but only when it is still the untouched
/// Tuesday this planning put there. A day an admin has since chosen by hand
/// is theirs, and survives.
///
/// The week's meetings for field service are *not* touched: they are ordinary
/// meetings that happened, and they belong to a different role anyway.
Future<void> deleteCoVisit(
  WidgetRef ref,
  String weekId, {
  required bool canEditLmm,
}) async {
  await ref.read(coVisitRepositoryProvider).delete(weekId);
  await ref
      .read(eventsRepositoryProvider)
      .delete(EventsRepository.coVisitEventId(weekId));
  if (canEditLmm) await _restoreMidweekMeeting(ref, weekId);
  ref.invalidate(assignmentHistoryProvider);
}

/// Creates or refreshes the events-screen entry for the visit, spanning
/// Tuesday to Sunday. Anything an admin typed on that entry (title, place,
/// notes) is preserved; only the dates are ours. An entry with no title
/// renders as the localized "Circuit overseer's visit", so it stays correct
/// in every language.
Future<void> upsertCoVisitEvent(WidgetRef ref, String weekId) async {
  final monday = parseDateKey(weekId);
  final repo = ref.read(eventsRepositoryProvider);
  final id = EventsRepository.coVisitEventId(weekId);
  final existing = await repo.getOne(id);
  await repo.save(
    (existing ?? const EventItem()).copyWith(
      id: id,
      type: EventType.coVisit,
      dateFrom: dateKey(CoVisit.startOf(monday)),
      dateTo: dateKey(CoVisit.endOf(monday)),
    ),
  );
}

/// Moves the midweek meeting of [weekId] to Tuesday, keeping the time it is
/// held at. Creates the week document when the workbook has not been imported
/// yet — a document without parts still shows the import prompt.
Future<void> moveMidweekMeetingToTuesday(
  WidgetRef ref,
  String weekId,
  CongregationMeta meta,
) async {
  final repo = ref.read(lmmRepositoryProvider);
  final weeks = await repo.getRange(weekId, weekId);
  final week = weeks.isEmpty ? LmmWeek(id: weekId) : weeks.first;
  final time = week.timeOr(meta.lmmTime);
  if (week.meetingWeekday == DateTime.tuesday && week.meetingTime == time) {
    return;
  }
  await repo.saveWeek(
    week.copyWith(meetingWeekday: DateTime.tuesday, meetingTime: time),
  );
}

/// Drops the Tuesday override again, unless the week has since been moved
/// somewhere else by hand.
Future<void> _restoreMidweekMeeting(WidgetRef ref, String weekId) async {
  final repo = ref.read(lmmRepositoryProvider);
  final weeks = await repo.getRange(weekId, weekId);
  if (weeks.isEmpty) return;
  final week = weeks.first;
  if (week.meetingWeekday != DateTime.tuesday) return;
  await repo.saveWeek(week.copyWith(meetingWeekday: null, meetingTime: null));
}
