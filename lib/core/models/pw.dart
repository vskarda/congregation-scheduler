import 'package:freezed_annotation/freezed_annotation.dart';

import 'assignment.dart';

part 'pw.freezed.dart';
part 'pw.g.dart';

/// Recurring public-witnessing rule; materialized into [PwSlot]s a few
/// months ahead whenever an admin opens the PW admin screen.
@freezed
abstract class PwRecurring with _$PwRecurring {
  const factory PwRecurring({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,

    /// DateTime.monday..sunday (1..7)
    @Default(DateTime.saturday) int weekday,
    @Default('09:00') String startTime,
    @Default('11:00') String endTime,
    @Default('') String location,
    @Default(Assignment()) Assignment defaultAssignment,

    /// yyyy-MM-dd
    @Default('') String validFrom,
    @Default('') String validUntil,
  }) = _PwRecurring;

  factory PwRecurring.fromJson(Map<String, dynamic> json) =>
      _$PwRecurringFromJson(json);
}

@freezed
abstract class PwSlot with _$PwSlot {
  const PwSlot._();

  const factory PwSlot({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,

    /// yyyy-MM-dd
    @Default('') String date,
    @Default('09:00') String startTime,
    @Default('11:00') String endTime,
    @Default('') String location,
    @Default(Assignment()) Assignment assignment,

    /// Set when this slot was generated from a recurring rule.
    @Default('') String recurringId,

    /// A "deleted" recurring instance is kept as cancelled so the
    /// materializer doesn't recreate it.
    @Default(false) bool cancelled,
    @Default(<String>[]) List<String> allAssigneeIds,
  }) = _PwSlot;

  factory PwSlot.fromJson(Map<String, dynamic> json) => _$PwSlotFromJson(json);

  PwSlot withRecomputedAssignees() => copyWith(
      allAssigneeIds: assignment.publisherIds.toSet().toList()..sort());
}
