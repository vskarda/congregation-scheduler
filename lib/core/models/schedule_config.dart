import 'package:freezed_annotation/freezed_annotation.dart';

import 'assignment.dart';

part 'schedule_config.freezed.dart';
part 'schedule_config.g.dart';

/// Congregation-level configuration for a meeting schedule (one doc per
/// meeting type: `schedule_config/lmm`, `schedule_config/weekend`).
///
/// Holds the "permanent" custom-assignment definitions: labels that recur on
/// every week. Only the id + label are stored here; the per-week assignee
/// lives on each week document, matched back by [CustomAssignment.id].
///
/// It also carries [hiddenWeeks], the weeks whose assigned names publishers
/// are not shown. Public witnessing and the meetings for field service have no
/// week document of their own to put that flag on — their occurrences are
/// expanded from the recurring rules — so all four schedules keep it here,
/// under `schedule_config/{lmm,weekend,pw,fsm}`.
@freezed
abstract class ScheduleConfig with _$ScheduleConfig {
  const ScheduleConfig._();

  const factory ScheduleConfig({
    @Default(<CustomAssignment>[]) List<CustomAssignment> permanentAssignments,

    /// Monday keys (yyyy-MM-dd) whose assigned names are hidden from
    /// publishers. Absent means shown, so only the weeks an admin switched
    /// off are listed and an untouched congregation shows everything.
    ///
    /// Cosmetic, like `CoVisit.hiddenSections`: the week documents stay
    /// readable by every verified user (firestore.rules cannot hide
    /// individual fields).
    @Default(<String>[]) List<String> hiddenWeeks,
  }) = _ScheduleConfig;

  factory ScheduleConfig.fromJson(Map<String, dynamic> json) =>
      _$ScheduleConfigFromJson(json);

  bool showsAssignees(String weekId) => !hiddenWeeks.contains(weekId);
}
