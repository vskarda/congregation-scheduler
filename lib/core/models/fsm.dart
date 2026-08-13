import 'package:freezed_annotation/freezed_annotation.dart';

import 'assignment.dart';

part 'fsm.freezed.dart';
part 'fsm.g.dart';

/// Recurring meeting-for-field-service rule. The rule *is* the meeting: its
/// occurrences are expanded on the fly (see `FsmRepository.expand`), never
/// pre-written as documents. Only occurrences an admin edited, moved or
/// cancelled get a document of their own — see [FsmMeeting.overrides].
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
    @Default('') String note,
    @Default(Assignment()) Assignment defaultAssignment,

    /// yyyy-MM-dd
    @Default('') String validFrom,
    @Default('') String validUntil,
  }) = _FsmRecurring;

  factory FsmRecurring.fromJson(Map<String, dynamic> json) =>
      _$FsmRecurringFromJson(json);
}

/// Field names that an occurrence may override on its rule. Stored verbatim
/// in [FsmMeeting.overrides], so the strings are part of the data format.
abstract final class FsmFields {
  static const date = 'date';
  static const time = 'time';
  static const location = 'location';
  static const note = 'note';
  static const assignment = 'assignment';
  static const withCo = 'withCo';
  static const withCoWife = 'withCoWife';

  static const all = [
    date,
    time,
    location,
    note,
    assignment,
    withCo,
    withCoWife,
  ];
}

/// Either a one-off meeting (empty [recurringId], self-contained) or an
/// *exception* to a recurring rule — one occurrence an admin edited, moved or
/// cancelled. Exceptions store only what deviates: [overrides] names the
/// authoritative fields, everything else is read from the rule at render
/// time, so later rule edits keep flowing through.
@freezed
abstract class FsmMeeting with _$FsmMeeting {
  const FsmMeeting._();

  const factory FsmMeeting({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,

    /// yyyy-MM-dd — when the meeting actually happens. For an exception this
    /// may differ from [seriesDate] (the occurrence was moved).
    @Default('') String date,
    @Default('09:00') String time,
    @Default('') String location,
    @Default('') String note,
    @Default(Assignment()) Assignment assignment,

    /// Publishers arranged to share in the ministry with the visiting circuit
    /// overseer, and with his wife, on this meeting's day. Only filled during
    /// a circuit overseer's visit ([CoVisit]), and only shown there — an
    /// ordinary week's meeting never renders them.
    ///
    /// A recurring rule has no companions, so these are always the
    /// occurrence's own: [diffFrom] reports them the moment they are set,
    /// which is what keeps [FsmRepository.repairAndCompact] from mistaking a
    /// companion-only exception for a redundant copy of its rule.
    @Default(Assignment()) Assignment withCo,
    @Default(Assignment()) Assignment withCoWife,

    /// Set when this meeting is an exception to a recurring rule.
    @Default('') String recurringId,

    /// yyyy-MM-dd — the slot in the series this exception belongs to. Its
    /// identity: unlike [date] it never changes, so moving an occurrence
    /// cannot make it collide with, or be overwritten by, its own series.
    /// Empty on documents written before the field existed; use [seriesKey].
    @Default('') String seriesDate,

    /// Which of [FsmFields] this occurrence overrides on its rule. Empty on
    /// one-off meetings, which are authoritative for everything.
    @Default(<String>[]) List<String> overrides,

    /// A "deleted" recurring occurrence is kept as a cancelled exception so
    /// the rule stops expanding it.
    @Default(false) bool cancelled,
    @Default(<String>[]) List<String> allAssigneeIds,
  }) = _FsmMeeting;

  factory FsmMeeting.fromJson(Map<String, dynamic> json) =>
      _$FsmMeetingFromJson(json);

  /// True for an exception to a recurring rule, false for a one-off meeting.
  bool get isException => recurringId.isNotEmpty;

  /// The occurrence this document stands for. Falls back to [date] for
  /// documents written before [seriesDate] existed — for those two the values
  /// were by definition equal, because moving one was not yet possible
  /// without corrupting it.
  String get seriesKey => seriesDate.isEmpty ? date : seriesDate;

  /// Document id of the exception for [seriesDate] of [ruleId]. Deterministic
  /// so editing an expanded occurrence writes exactly one document, however
  /// often it is edited.
  static String exceptionId(String ruleId, String seriesDate) =>
      '${ruleId}_$seriesDate';

  bool hasOverride(String field) => overrides.contains(field);

  /// The occurrence [rule] produces on [seriesDate], with no exception.
  static FsmMeeting fromRule(FsmRecurring rule, String seriesDate) =>
      FsmMeeting(
        id: exceptionId(rule.id, seriesDate),
        date: seriesDate,
        time: rule.time,
        location: rule.location,
        note: rule.note,
        assignment: rule.defaultAssignment,
        recurringId: rule.id,
        seriesDate: seriesDate,
      ).withRecomputedAssignees();

  /// Fills every field this occurrence does *not* override from [rule], so a
  /// rule edit reaches occurrences an admin customized in other fields.
  FsmMeeting applyRule(FsmRecurring rule) => copyWith(
        date: hasOverride(FsmFields.date) ? date : seriesKey,
        time: hasOverride(FsmFields.time) ? time : rule.time,
        location: hasOverride(FsmFields.location) ? location : rule.location,
        note: hasOverride(FsmFields.note) ? note : rule.note,
        assignment: hasOverride(FsmFields.assignment)
            ? assignment
            : rule.defaultAssignment,
        // A rule names no circuit-overseer companions, so "not overridden"
        // means empty rather than inherited.
        withCo: hasOverride(FsmFields.withCo) ? withCo : const Assignment(),
        withCoWife: hasOverride(FsmFields.withCoWife)
            ? withCoWife
            : const Assignment(),
      ).withRecomputedAssignees();

  /// Which of [FsmFields] differ from what [rule] would produce for this
  /// occurrence. Used to record overrides when an occurrence is edited, and
  /// by the repair pass to tell a customized document from a stale copy.
  List<String> diffFrom(FsmRecurring rule) => [
        if (date != seriesKey) FsmFields.date,
        if (time != rule.time) FsmFields.time,
        if (location != rule.location) FsmFields.location,
        if (note != rule.note) FsmFields.note,
        if (assignment != rule.defaultAssignment) FsmFields.assignment,
        if (withCo.isNotEmpty) FsmFields.withCo,
        if (withCoWife.isNotEmpty) FsmFields.withCoWife,
      ];

  /// Turns this exception into a stand-alone one-off meeting, freezing the
  /// fields it used to inherit from [rule]. Used when the rule goes away, so
  /// no document is ever left pointing at a rule that no longer exists.
  ///
  /// The document id is kept, matching `PwSlot.detachFrom`, where it is
  /// load-bearing: PW applications are stored at `{slotId}_{uid}` and the
  /// security rules let nobody re-key them. Callers must therefore write a
  /// detached meeting before — or in place of — deleting the document it came
  /// from.
  FsmMeeting detachFrom(FsmRecurring? rule) =>
      (rule == null ? this : applyRule(rule)).copyWith(
        recurringId: '',
        seriesDate: '',
        overrides: const [],
      );

  FsmMeeting withRecomputedAssignees() => copyWith(
      allAssigneeIds: {
        ...assignment.publisherIds,
        ...withCo.publisherIds,
        ...withCoWife.publisherIds,
      }.toList()
        ..sort());

  /// Rewrites publisher id [from] to [to] and recomputes [allAssigneeIds].
  FsmMeeting replaceAssignee(String from, String to) => copyWith(
        assignment: assignment.replaceAssignee(from, to),
        withCo: withCo.replaceAssignee(from, to),
        withCoWife: withCoWife.replaceAssignee(from, to),
      ).withRecomputedAssignees();
}
