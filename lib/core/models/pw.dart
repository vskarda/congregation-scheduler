import 'package:freezed_annotation/freezed_annotation.dart';

import 'assignment.dart';
import 'converters.dart';

part 'pw.freezed.dart';
part 'pw.g.dart';

/// Recurring public-witnessing rule. The rule *is* the slots: its occurrences
/// are expanded on the fly (see `PwRepository.expand`), never pre-written.
/// Only occurrences an admin edited, moved or cancelled get a document of
/// their own — see [PwSlot.overrides].
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

/// Field names that an occurrence may override on its rule. Stored verbatim
/// in [PwSlot.overrides], so the strings are part of the data format.
abstract final class PwFields {
  static const date = 'date';
  static const startTime = 'startTime';
  static const endTime = 'endTime';
  static const location = 'location';
  static const assignment = 'assignment';

  static const all = [date, startTime, endTime, location, assignment];
}

/// Either a one-off slot (empty [recurringId], self-contained) or an
/// *exception* to a recurring rule — one occurrence an admin edited, moved or
/// cancelled. Exceptions store only what deviates: [overrides] names the
/// authoritative fields, everything else is read from the rule at render
/// time, so later rule edits keep flowing through.
@freezed
abstract class PwSlot with _$PwSlot {
  const PwSlot._();

  const factory PwSlot({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,

    /// yyyy-MM-dd — when the slot actually happens. For an exception this may
    /// differ from [seriesDate] (the occurrence was moved).
    @Default('') String date,
    @Default('09:00') String startTime,
    @Default('11:00') String endTime,
    @Default('') String location,
    @Default(Assignment()) Assignment assignment,

    /// Set when this slot is an exception to a recurring rule.
    @Default('') String recurringId,

    /// yyyy-MM-dd — the slot in the series this exception belongs to. Its
    /// identity: unlike [date] it never changes, so moving an occurrence
    /// cannot make it collide with its own series — nor detach the
    /// applications keyed to its id, which the security rules forbid anyone
    /// from re-keying. Empty on documents written before the field existed;
    /// use [seriesKey].
    @Default('') String seriesDate,

    /// Which of [PwFields] this occurrence overrides on its rule. Empty on
    /// one-off slots, which are authoritative for everything.
    @Default(<String>[]) List<String> overrides,

    /// A "deleted" recurring occurrence is kept as a cancelled exception so
    /// the rule stops expanding it.
    @Default(false) bool cancelled,
    @Default(<String>[]) List<String> allAssigneeIds,
  }) = _PwSlot;

  factory PwSlot.fromJson(Map<String, dynamic> json) => _$PwSlotFromJson(json);

  /// True for an exception to a recurring rule, false for a one-off slot.
  bool get isException => recurringId.isNotEmpty;

  /// The occurrence this document stands for. Falls back to [date] for
  /// documents written before [seriesDate] existed — for those two the values
  /// were by definition equal, because moving one was not yet possible
  /// without corrupting it.
  String get seriesKey => seriesDate.isEmpty ? date : seriesDate;

  /// Document id of the exception for [seriesDate] of [ruleId]. Deterministic
  /// so editing an expanded occurrence writes exactly one document, and so
  /// applications — keyed `{slotId}_{uid}` — stay attached to it forever.
  static String exceptionId(String ruleId, String seriesDate) =>
      '${ruleId}_$seriesDate';

  bool hasOverride(String field) => overrides.contains(field);

  /// The occurrence [rule] produces on [seriesDate], with no exception.
  static PwSlot fromRule(PwRecurring rule, String seriesDate) => PwSlot(
        id: exceptionId(rule.id, seriesDate),
        date: seriesDate,
        startTime: rule.startTime,
        endTime: rule.endTime,
        location: rule.location,
        assignment: rule.defaultAssignment,
        recurringId: rule.id,
        seriesDate: seriesDate,
      ).withRecomputedAssignees();

  /// Fills every field this occurrence does *not* override from [rule], so a
  /// rule edit reaches occurrences an admin customized in other fields.
  PwSlot applyRule(PwRecurring rule) => copyWith(
        date: hasOverride(PwFields.date) ? date : seriesKey,
        startTime:
            hasOverride(PwFields.startTime) ? startTime : rule.startTime,
        endTime: hasOverride(PwFields.endTime) ? endTime : rule.endTime,
        location: hasOverride(PwFields.location) ? location : rule.location,
        assignment: hasOverride(PwFields.assignment)
            ? assignment
            : rule.defaultAssignment,
      ).withRecomputedAssignees();

  /// Which of [PwFields] differ from what [rule] would produce for this
  /// occurrence. Used to record overrides when an occurrence is edited, and
  /// by the repair pass to tell a customized document from a stale copy.
  List<String> diffFrom(PwRecurring rule) => [
        if (date != seriesKey) PwFields.date,
        if (startTime != rule.startTime) PwFields.startTime,
        if (endTime != rule.endTime) PwFields.endTime,
        if (location != rule.location) PwFields.location,
        if (assignment != rule.defaultAssignment) PwFields.assignment,
      ];

  /// Turns this exception into a stand-alone one-off slot, freezing the
  /// fields it used to inherit from [rule]. Used when the rule goes away, so
  /// no document is ever left pointing at a rule that no longer exists.
  ///
  /// The document id is deliberately kept: applications are stored at
  /// `{slotId}_{uid}` and the security rules let nobody re-key them, so a
  /// slot that changed id would silently lose everyone who volunteered for
  /// it. Callers must therefore write a detached slot before — or in place
  /// of — deleting the document it came from.
  PwSlot detachFrom(PwRecurring? rule) =>
      (rule == null ? this : applyRule(rule)).copyWith(
        recurringId: '',
        seriesDate: '',
        overrides: const [],
      );

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
