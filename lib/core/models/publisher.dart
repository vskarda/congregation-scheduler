import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/dates.dart';
import 'converters.dart';
import 'enums.dart';

part 'publisher.freezed.dart';
part 'publisher.g.dart';

/// Per-section admin rights. Field names must match firestore.rules.
@freezed
abstract class Roles with _$Roles {
  const Roles._();

  const factory Roles({
    @Default(false) bool infoBoard,
    @Default(false) bool events,
    @Default(false) bool lmmSchedule,
    @Default(false) bool weekendSchedule,
    @Default(false) bool publicWitnessing,
    @Default(false) bool fieldServiceMeetings,
    @Default(false) bool territories,
    @Default(false) bool reports,
    @Default(false) bool attendance,
    @Default(false) bool recordAttendance,
    @Default(false) bool publishers,
    @Default(false) bool fullAdmin,
  }) = _Roles;

  factory Roles.fromJson(Map<String, dynamic> json) => _$RolesFromJson(json);

  bool get any =>
      infoBoard ||
      events ||
      lmmSchedule ||
      weekendSchedule ||
      publicWitnessing ||
      fieldServiceMeetings ||
      territories ||
      reports ||
      attendance ||
      recordAttendance ||
      publishers ||
      fullAdmin;

  bool canEditInfoBoard() => infoBoard || fullAdmin;
  bool canEditEvents() => events || fullAdmin;
  bool canEditLmm() => lmmSchedule || fullAdmin;
  bool canEditWeekend() => weekendSchedule || fullAdmin;
  bool canEditPublicWitnessing() => publicWitnessing || fullAdmin;
  bool canEditFieldServiceMeetings() => fieldServiceMeetings || fullAdmin;
  bool canEditTerritories() => territories || fullAdmin;
  bool canEditReports() => reports || fullAdmin;
  bool canEditAttendance() => attendance || fullAdmin;

  /// Full attendance right, or the narrower record-only right that just
  /// grants the record form (no monthly averages / history).
  bool canRecordAttendance() => recordAttendance || canEditAttendance();
  bool canEditPublishers() => publishers || fullAdmin;
}

/// What a publisher may be assigned to. Used to filter the publisher picker;
/// admins can always override with "show all" or free text.
@freezed
abstract class Qualifications with _$Qualifications {
  const Qualifications._();

  const factory Qualifications({
    @Default(false) bool chairman,
    @Default(false) bool prayer,
    @Default(false) bool treasures,
    @Default(false) bool gems,
    @Default(false) bool bibleReading,
    @Default(false) bool fieldMinistry,
    @Default(false) bool livingParts,
    @Default(false) bool cbsConductor,
    @Default(false) bool cbsReader,
    @Default(false) bool publicTalk,
    @Default(false) bool weekendChairman,
    @Default(false) bool wtReader,
    @Default(false) bool attendant,
    @Default(false) bool microphone,
    @Default(false) bool audioVideo,
    @Default(false) bool publicWitnessing,
    @Default(false) bool ministryMeetingConductor,
  }) = _Qualifications;

  factory Qualifications.fromJson(Map<String, dynamic> json) =>
      _$QualificationsFromJson(json);

  bool forLmmPartType(LmmPartType type) => switch (type) {
        LmmPartType.chairman => chairman,
        LmmPartType.prayer => prayer,
        LmmPartType.treasures => treasures,
        LmmPartType.gems => gems,
        LmmPartType.bibleReading => bibleReading,
        LmmPartType.fieldMinistry => fieldMinistry,
        LmmPartType.living => livingParts,
        LmmPartType.cbsConductor => cbsConductor,
        LmmPartType.cbsReader => cbsReader,
        LmmPartType.custom => true,
      };
}

@freezed
abstract class Publisher with _$Publisher {
  const Publisher._();

  const factory Publisher({
    /// Firestore document id (= auth uid for publishers with accounts).
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default(Gender.unknown) Gender gender,
    @Default(PublisherStatus.publisher) PublisherStatus status,

    /// Elder / ministerial-servant appointment, denormalized from the private
    /// profile ([PublisherPrivate.appointment]) so the admin roster can filter
    /// and badge by it without loading every private doc. Admin-set only
    /// (firestore.rules blocks self-edits, same as [status] 'none').
    @Default(Appointment.none) Appointment appointment,
    @Default(false) bool verified,
    @Default(Roles()) Roles roles,
    @Default(Qualifications()) Qualifications qualifications,

    /// False for records an admin created for members without a login.
    @Default(false) bool hasAccount,

    /// Archived because the publisher moved to another congregation. The
    /// record (and their S-21 history) is kept, but from [movedDate] on they
    /// lose access and drop out of schedule pickers and report rosters.
    /// Distinct from an unverified/awaiting user.
    @Default(false) bool moved,

    /// The day the publisher left, `yyyy-MM-dd`. May be in the future: until
    /// it arrives the record behaves exactly like any other member. Absent on
    /// records archived before this field existed — those read as moved long
    /// ago. Admin-set only (firestore.rules blocks self-edits, like [moved]);
    /// includeIfNull keeps the key out of toJson() so full-doc self-saves
    /// don't trip the affectedKeys rule (same reason as [groupId]).
    @JsonKey(includeIfNull: false) String? movedDate,

    /// [movedDate] at local midnight, denormalized purely so firestore.rules
    /// can end access at the right instant — rules cannot parse a date
    /// string. Never read by the app; always written with [movedDate].
    @JsonKey(includeIfNull: false)
    @NullableTimestampConverter()
    DateTime? movedAt,

    /// Ministry group membership (ministry_groups doc id); null = no group.
    /// Admin-assigned only — firestore.rules blocks self-edits of this key.
    /// includeIfNull keeps the key absent from toJson() so full-doc
    /// self-saves by ungrouped publishers don't trip the affectedKeys rule.
    @JsonKey(includeIfNull: false) String? groupId,
  }) = _Publisher;

  factory Publisher.fromJson(Map<String, dynamic> json) =>
      _$PublisherFromJson(json);

  String get fullName =>
      [firstName, lastName].where((s) => s.isNotEmpty).join(' ');

  /// "Surname Name" for sorted lists.
  String get listName => lastName.isEmpty ? firstName : '$lastName $firstName';

  bool get isPioneer =>
      status != PublisherStatus.publisher && status != PublisherStatus.none;

  /// The parsed [movedDate], or null when there is none to parse.
  DateTime? get movedOn => tryParseDateKey(movedDate);

  /// Whether the publisher had already left on [day]. A record marked moved
  /// without a date (archived before the date existed) counts as gone
  /// throughout. Day-level: this is the cut for meetings and assignments.
  bool hasMovedBy(DateTime day) {
    if (!moved) return false;
    final left = movedOn;
    if (left == null) return true;
    return !DateTime(day.year, day.month, day.day).isBefore(left);
  }

  /// Whether the publisher belongs on the roster of report month [month]
  /// (`yyyy-MM`). See [onRosterInMonthOf] for the rule itself, which a
  /// [FormerPublisher] applies to the same person after their record is gone.
  bool onRosterInMonth(String month) =>
      onRosterInMonthOf(moved: moved, movedDate: movedDate, month: month);

  /// Marked as moved with a date that has not arrived yet: still a full
  /// member everywhere, just with the departure already recorded.
  bool get isMovePending => moved && !hasMovedBy(DateTime.now());
}

/// The month-level cut a departure makes: whether someone who left on
/// [movedDate] still belongs on the roster of report month [month]
/// (`yyyy-MM`). The month the move falls in already belongs to the new
/// congregation, so the last month claimed here is the one before it. A
/// departure with no date (records archived before the date existed) claims
/// no month at all.
///
/// Lives outside [Publisher] because the fact outlives the record: once a
/// moved publisher is deleted, the same rule is applied to the
/// [FormerPublisher] tombstone left behind.
bool onRosterInMonthOf({
  required bool moved,
  required String? movedDate,
  required String month,
}) {
  if (!moved) return true;
  if (movedDate == null) return false;
  return month.compareTo(movedDate.substring(0, 7)) < 0;
}

/// Sensitive personal data, stored at publishers/{uid}/private/profile and
/// readable only by the publisher themselves and publisher-admins.
@freezed
abstract class PublisherPrivate with _$PublisherPrivate {
  const factory PublisherPrivate({
    @Default('') String email,
    @Default('') String phone,
    @Default('') String address,

    /// yyyy-MM-dd
    @Default('') String birthDate,

    /// yyyy-MM-dd
    @Default('') String baptismDate,
    @Default(Hope.otherSheep) Hope hope,

    /// Set by publisher-admins only (enforced in firestore.rules).
    @Default(Appointment.none) Appointment appointment,
    @Default('') String emergencyNote,
  }) = _PublisherPrivate;

  factory PublisherPrivate.fromJson(Map<String, dynamic> json) =>
      _$PublisherPrivateFromJson(json);
}
