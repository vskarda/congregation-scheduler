// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceEntry _$AttendanceEntryFromJson(Map<String, dynamic> json) =>
    _AttendanceEntry(
      date: json['date'] as String? ?? '',
      meetingType:
          $enumDecodeNullable(_$MeetingTypeEnumMap, json['meetingType']) ??
          MeetingType.lmm,
      inPerson: (json['inPerson'] as num?)?.toInt(),
      online: (json['online'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AttendanceEntryToJson(_AttendanceEntry instance) =>
    <String, dynamic>{
      'date': instance.date,
      'meetingType': _$MeetingTypeEnumMap[instance.meetingType]!,
      'inPerson': ?instance.inPerson,
      'online': ?instance.online,
      'total': ?instance.total,
    };

const _$MeetingTypeEnumMap = {
  MeetingType.lmm: 'lmm',
  MeetingType.weekend: 'weekend',
};
