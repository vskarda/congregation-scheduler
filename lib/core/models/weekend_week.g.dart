// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekend_week.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeekendWeek _$WeekendWeekFromJson(Map<String, dynamic> json) => _WeekendWeek(
  talkTitle: json['talkTitle'] as String? ?? '',
  talkNo: (json['talkNo'] as num?)?.toInt(),
  speaker: json['speaker'] == null
      ? const Assignment()
      : Assignment.fromJson(json['speaker'] as Map<String, dynamic>),
  chairman: json['chairman'] == null
      ? const Assignment()
      : Assignment.fromJson(json['chairman'] as Map<String, dynamic>),
  wtReader: json['wtReader'] == null
      ? const Assignment()
      : Assignment.fromJson(json['wtReader'] as Map<String, dynamic>),
  customFields:
      (json['customFields'] as List<dynamic>?)
          ?.map((e) => CustomAssignment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CustomAssignment>[],
  attendants: json['attendants'] == null
      ? const Assignment()
      : Assignment.fromJson(json['attendants'] as Map<String, dynamic>),
  microphones: json['microphones'] == null
      ? const Assignment()
      : Assignment.fromJson(json['microphones'] as Map<String, dynamic>),
  audioVideo: json['audioVideo'] == null
      ? const Assignment()
      : Assignment.fromJson(json['audioVideo'] as Map<String, dynamic>),
  customAssignments:
      (json['customAssignments'] as List<dynamic>?)
          ?.map((e) => CustomAssignment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CustomAssignment>[],
  allAssigneeIds:
      (json['allAssigneeIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$WeekendWeekToJson(_WeekendWeek instance) =>
    <String, dynamic>{
      'talkTitle': instance.talkTitle,
      'talkNo': ?instance.talkNo,
      'speaker': instance.speaker.toJson(),
      'chairman': instance.chairman.toJson(),
      'wtReader': instance.wtReader.toJson(),
      'customFields': instance.customFields.map((e) => e.toJson()).toList(),
      'attendants': instance.attendants.toJson(),
      'microphones': instance.microphones.toJson(),
      'audioVideo': instance.audioVideo.toJson(),
      'customAssignments': instance.customAssignments
          .map((e) => e.toJson())
          .toList(),
      'allAssigneeIds': instance.allAssigneeIds,
    };
