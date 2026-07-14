import 'package:freezed_annotation/freezed_annotation.dart';

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
    @Default(false) bool verified,
    @Default(Roles()) Roles roles,
    @Default(Qualifications()) Qualifications qualifications,

    /// False for records an admin created for members without a login.
    @Default(false) bool hasAccount,

    /// Archived because the publisher moved to another congregation. The
    /// record (and their S-21 history) is kept, but access is revoked
    /// (marking moved also clears [verified]) and they drop out of schedule
    /// pickers and report rosters. Distinct from an unverified/awaiting user.
    @Default(false) bool moved,

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
