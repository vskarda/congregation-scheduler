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
      inPerson: (json['inPerson'] as num?)?.toInt() ?? 0,
      online: (json['online'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AttendanceEntryToJson(_AttendanceEntry instance) =>
    <String, dynamic>{
      'date': instance.date,
      'meetingType': _$MeetingTypeEnumMap[instance.meetingType]!,
      'inPerson': instance.inPerson,
      'online': instance.online,
    };

const _$MeetingTypeEnumMap = {
  MeetingType.lmm: 'lmm',
  MeetingType.weekend: 'weekend',
};
