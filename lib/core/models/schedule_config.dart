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
@freezed
abstract class ScheduleConfig with _$ScheduleConfig {
  const factory ScheduleConfig({
    @Default(<CustomAssignment>[]) List<CustomAssignment> permanentAssignments,
  }) = _ScheduleConfig;

  factory ScheduleConfig.fromJson(Map<String, dynamic> json) =>
      _$ScheduleConfigFromJson(json);
}
