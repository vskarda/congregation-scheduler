// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleConfig _$ScheduleConfigFromJson(Map<String, dynamic> json) =>
    _ScheduleConfig(
      permanentAssignments:
          (json['permanentAssignments'] as List<dynamic>?)
              ?.map((e) => CustomAssignment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CustomAssignment>[],
    );

Map<String, dynamic> _$ScheduleConfigToJson(_ScheduleConfig instance) =>
    <String, dynamic>{
      'permanentAssignments': instance.permanentAssignments
          .map((e) => e.toJson())
          .toList(),
    };
