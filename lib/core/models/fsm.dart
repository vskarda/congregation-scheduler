import 'package:freezed_annotation/freezed_annotation.dart';

import 'assignment.dart';

part 'fsm.freezed.dart';
part 'fsm.g.dart';

/// Recurring meeting-for-field-service rule; materialized into [FsmMeeting]s
/// a few months ahead whenever an admin opens the FSM screen.
@freezed
abstract class FsmRecurring with _$FsmRecurring {
  const factory FsmRecurring({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,

    /// DateTime.monday..sunday (1..7)
    @Default(DateTime.saturday) int weekday,
    @Default('09:00') String time,
    @Default('') String location,
    @Default(Assignment()) Assignment defaultAssignment,

    /// yyyy-MM-dd
    @Default('') String validFrom,
    @Default('') String validUntil,
  }) = _FsmRecurring;

  factory FsmRecurring.fromJson(Map<String, dynamic> json) =>
      _$FsmRecurringFromJson(json);
}

@freezed
abstract class FsmMeeting with _$FsmMeeting {
  const FsmMeeting._();

  const factory FsmMeeting({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,

    /// yyyy-MM-dd
    @Default('') String date,
    @Default('09:00') String time,
    @Default('') String location,
    @Default(Assignment()) Assignment assignment,

    /// Set when this meeting was generated from a recurring rule.
    @Default('') String recurringId,

    /// A "deleted" recurring instance is kept as cancelled so the
    /// materializer doesn't recreate it.
    @Default(false) bool cancelled,
    @Default(<String>[]) List<String> allAssigneeIds,
  }) = _FsmMeeting;

  factory FsmMeeting.fromJson(Map<String, dynamic> json) =>
      _$FsmMeetingFromJson(json);

  FsmMeeting withRecomputedAssignees() => copyWith(
      allAssigneeIds: assignment.publisherIds.toSet().toList()..sort());
}
