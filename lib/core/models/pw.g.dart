// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pw.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PwRecurring _$PwRecurringFromJson(Map<String, dynamic> json) => _PwRecurring(
  weekday: (json['weekday'] as num?)?.toInt() ?? DateTime.saturday,
  startTime: json['startTime'] as String? ?? '09:00',
  endTime: json['endTime'] as String? ?? '11:00',
  location: json['location'] as String? ?? '',
  defaultAssignment: json['defaultAssignment'] == null
      ? const Assignment()
      : Assignment.fromJson(json['defaultAssignment'] as Map<String, dynamic>),
  validFrom: json['validFrom'] as String? ?? '',
  validUntil: json['validUntil'] as String? ?? '',
);

Map<String, dynamic> _$PwRecurringToJson(_PwRecurring instance) =>
    <String, dynamic>{
      'weekday': instance.weekday,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'location': instance.location,
      'defaultAssignment': instance.defaultAssignment.toJson(),
      'validFrom': instance.validFrom,
      'validUntil': instance.validUntil,
    };

_PwSlot _$PwSlotFromJson(Map<String, dynamic> json) => _PwSlot(
  date: json['date'] as String? ?? '',
  startTime: json['startTime'] as String? ?? '09:00',
  endTime: json['endTime'] as String? ?? '11:00',
  location: json['location'] as String? ?? '',
  assignment: json['assignment'] == null
      ? const Assignment()
      : Assignment.fromJson(json['assignment'] as Map<String, dynamic>),
  recurringId: json['recurringId'] as String? ?? '',
  cancelled: json['cancelled'] as bool? ?? false,
  allAssigneeIds:
      (json['allAssigneeIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$PwSlotToJson(_PwSlot instance) => <String, dynamic>{
  'date': instance.date,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'location': instance.location,
  'assignment': instance.assignment.toJson(),
  'recurringId': instance.recurringId,
  'cancelled': instance.cancelled,
  'allAssigneeIds': instance.allAssigneeIds,
};
