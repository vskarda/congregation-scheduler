import 'package:freezed_annotation/freezed_annotation.dart';

import 'assignment.dart';
import 'converters.dart';

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

  /// Rewrites publisher id [from] to [to] and recomputes [allAssigneeIds].
  PwSlot replaceAssignee(String from, String to) =>
      copyWith(assignment: assignment.replaceAssignee(from, to))
          .withRecomputedAssignees();
}

/// A publisher's application (volunteering) for one [PwSlot], stored at
/// pw_applications/{slotId}_{publisherId}. The deterministic id makes
/// applying idempotent and works for not-yet-materialized recurring slots,
/// whose virtual ids (`{ruleId}_{date}`) are stable.
@freezed
abstract class PwApplication with _$PwApplication {
  const factory PwApplication({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String slotId,

    /// yyyy-MM-dd; denormalized copy of the slot date for range queries.
    @Default('') String date,

    /// == the applicant's auth uid.
    @Default('') String publisherId,
    @NullableTimestampConverter() DateTime? appliedAt,
  }) = _PwApplication;

  factory PwApplication.fromJson(Map<String, dynamic> json) =>
      _$PwApplicationFromJson(json);

  static String docId(String slotId, String uid) => '${slotId}_$uid';
}
