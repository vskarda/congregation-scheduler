// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publisher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Roles _$RolesFromJson(Map<String, dynamic> json) => _Roles(
  infoBoard: json['infoBoard'] as bool? ?? false,
  events: json['events'] as bool? ?? false,
  lmmSchedule: json['lmmSchedule'] as bool? ?? false,
  weekendSchedule: json['weekendSchedule'] as bool? ?? false,
  publicWitnessing: json['publicWitnessing'] as bool? ?? false,
  fieldServiceMeetings: json['fieldServiceMeetings'] as bool? ?? false,
  territories: json['territories'] as bool? ?? false,
  reports: json['reports'] as bool? ?? false,
  attendance: json['attendance'] as bool? ?? false,
  publishers: json['publishers'] as bool? ?? false,
  fullAdmin: json['fullAdmin'] as bool? ?? false,
);

Map<String, dynamic> _$RolesToJson(_Roles instance) => <String, dynamic>{
  'infoBoard': instance.infoBoard,
  'events': instance.events,
  'lmmSchedule': instance.lmmSchedule,
  'weekendSchedule': instance.weekendSchedule,
  'publicWitnessing': instance.publicWitnessing,
  'fieldServiceMeetings': instance.fieldServiceMeetings,
  'territories': instance.territories,
  'reports': instance.reports,
  'attendance': instance.attendance,
  'publishers': instance.publishers,
  'fullAdmin': instance.fullAdmin,
};

_Qualifications _$QualificationsFromJson(Map<String, dynamic> json) =>
    _Qualifications(
      chairman: json['chairman'] as bool? ?? false,
      prayer: json['prayer'] as bool? ?? false,
      treasures: json['treasures'] as bool? ?? false,
      gems: json['gems'] as bool? ?? false,
      bibleReading: json['bibleReading'] as bool? ?? false,
      fieldMinistry: json['fieldMinistry'] as bool? ?? false,
      livingParts: json['livingParts'] as bool? ?? false,
      cbsConductor: json['cbsConductor'] as bool? ?? false,
      cbsReader: json['cbsReader'] as bool? ?? false,
      publicTalk: json['publicTalk'] as bool? ?? false,
      weekendChairman: json['weekendChairman'] as bool? ?? false,
      wtReader: json['wtReader'] as bool? ?? false,
      attendant: json['attendant'] as bool? ?? false,
      microphone: json['microphone'] as bool? ?? false,
      audioVideo: json['audioVideo'] as bool? ?? false,
      publicWitnessing: json['publicWitnessing'] as bool? ?? false,
      ministryMeetingConductor:
          json['ministryMeetingConductor'] as bool? ?? false,
    );

Map<String, dynamic> _$QualificationsToJson(_Qualifications instance) =>
    <String, dynamic>{
      'chairman': instance.chairman,
      'prayer': instance.prayer,
      'treasures': instance.treasures,
      'gems': instance.gems,
      'bibleReading': instance.bibleReading,
      'fieldMinistry': instance.fieldMinistry,
      'livingParts': instance.livingParts,
      'cbsConductor': instance.cbsConductor,
      'cbsReader': instance.cbsReader,
      'publicTalk': instance.publicTalk,
      'weekendChairman': instance.weekendChairman,
      'wtReader': instance.wtReader,
      'attendant': instance.attendant,
      'microphone': instance.microphone,
      'audioVideo': instance.audioVideo,
      'publicWitnessing': instance.publicWitnessing,
      'ministryMeetingConductor': instance.ministryMeetingConductor,
    };

_Publisher _$PublisherFromJson(Map<String, dynamic> json) => _Publisher(
  firstName: json['firstName'] as String? ?? '',
  lastName: json['lastName'] as String? ?? '',
  gender:
      $enumDecodeNullable(_$GenderEnumMap, json['gender']) ?? Gender.unknown,
  status:
      $enumDecodeNullable(_$PublisherStatusEnumMap, json['status']) ??
      PublisherStatus.publisher,
  verified: json['verified'] as bool? ?? false,
  roles: json['roles'] == null
      ? const Roles()
      : Roles.fromJson(json['roles'] as Map<String, dynamic>),
  qualifications: json['qualifications'] == null
      ? const Qualifications()
      : Qualifications.fromJson(json['qualifications'] as Map<String, dynamic>),
  hasAccount: json['hasAccount'] as bool? ?? false,
  moved: json['moved'] as bool? ?? false,
  groupId: json['groupId'] as String?,
);

Map<String, dynamic> _$PublisherToJson(_Publisher instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': _$GenderEnumMap[instance.gender]!,
      'status': _$PublisherStatusEnumMap[instance.status]!,
      'verified': instance.verified,
      'roles': instance.roles.toJson(),
      'qualifications': instance.qualifications.toJson(),
      'hasAccount': instance.hasAccount,
      'moved': instance.moved,
      'groupId': ?instance.groupId,
    };

const _$GenderEnumMap = {
  Gender.unknown: 'unknown',
  Gender.male: 'male',
  Gender.female: 'female',
};

const _$PublisherStatusEnumMap = {
  PublisherStatus.publisher: 'publisher',
  PublisherStatus.auxiliaryPioneer: 'auxPioneer',
  PublisherStatus.regularPioneer: 'regPioneer',
  PublisherStatus.specialPioneer: 'specialPioneer',
  PublisherStatus.fieldMissionary: 'fieldMissionary',
};

_PublisherPrivate _$PublisherPrivateFromJson(Map<String, dynamic> json) =>
    _PublisherPrivate(
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      birthDate: json['birthDate'] as String? ?? '',
      baptismDate: json['baptismDate'] as String? ?? '',
      hope: $enumDecodeNullable(_$HopeEnumMap, json['hope']) ?? Hope.otherSheep,
      appointment:
          $enumDecodeNullable(_$AppointmentEnumMap, json['appointment']) ??
          Appointment.none,
      emergencyNote: json['emergencyNote'] as String? ?? '',
    );

Map<String, dynamic> _$PublisherPrivateToJson(_PublisherPrivate instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'birthDate': instance.birthDate,
      'baptismDate': instance.baptismDate,
      'hope': _$HopeEnumMap[instance.hope]!,
      'appointment': _$AppointmentEnumMap[instance.appointment]!,
      'emergencyNote': instance.emergencyNote,
    };

const _$HopeEnumMap = {
  Hope.otherSheep: 'otherSheep',
  Hope.anointed: 'anointed',
};

const _$AppointmentEnumMap = {
  Appointment.none: 'none',
  Appointment.ministerialServant: 'ministerialServant',
  Appointment.elder: 'elder',
};
