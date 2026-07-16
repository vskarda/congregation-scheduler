// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'congregation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CongregationMeta _$CongregationMetaFromJson(Map<String, dynamic> json) =>
    _CongregationMeta(
      name: json['name'] as String? ?? '',
      founderUid: json['founderUid'] as String? ?? '',
      lmmWeekday: (json['lmmWeekday'] as num?)?.toInt() ?? DateTime.tuesday,
      lmmTime: json['lmmTime'] as String? ?? '18:30',
      lmmClassCount: (json['lmmClassCount'] as num?)?.toInt() ?? 1,
      weekendWeekday:
          (json['weekendWeekday'] as num?)?.toInt() ?? DateTime.sunday,
      weekendTime: json['weekendTime'] as String? ?? '10:00',
      appointmentBackfilled: json['appointmentBackfilled'] as bool? ?? false,
    );

Map<String, dynamic> _$CongregationMetaToJson(_CongregationMeta instance) =>
    <String, dynamic>{
      'name': instance.name,
      'founderUid': instance.founderUid,
      'lmmWeekday': instance.lmmWeekday,
      'lmmTime': instance.lmmTime,
      'lmmClassCount': instance.lmmClassCount,
      'weekendWeekday': instance.weekendWeekday,
      'weekendTime': instance.weekendTime,
      'appointmentBackfilled': instance.appointmentBackfilled,
    };
