// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fsm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FsmRecurring _$FsmRecurringFromJson(Map<String, dynamic> json) =>
    _FsmRecurring(
      weekday: (json['weekday'] as num?)?.toInt() ?? DateTime.saturday,
      time: json['time'] as String? ?? '09:00',
      location: json['location'] as String? ?? '',
      note: json['note'] as String? ?? '',
      defaultAssignment: json['defaultAssignment'] == null
          ? const Assignment()
          : Assignment.fromJson(
              json['defaultAssignment'] as Map<String, dynamic>,
            ),
      validFrom: json['validFrom'] as String? ?? '',
      validUntil: json['validUntil'] as String? ?? '',
    );

Map<String, dynamic> _$FsmRecurringToJson(_FsmRecurring instance) =>
    <String, dynamic>{
      'weekday': instance.weekday,
      'time': instance.time,
      'location': instance.location,
      'note': instance.note,
      'defaultAssignment': instance.defaultAssignment.toJson(),
      'validFrom': instance.validFrom,
      'validUntil': instance.validUntil,
    };

_FsmMeeting _$FsmMeetingFromJson(Map<String, dynamic> json) => _FsmMeeting(
  date: json['date'] as String? ?? '',
  time: json['time'] as String? ?? '09:00',
  location: json['location'] as String? ?? '',
  note: json['note'] as String? ?? '',
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

Map<String, dynamic> _$FsmMeetingToJson(_FsmMeeting instance) =>
    <String, dynamic>{
      'date': instance.date,
      'time': instance.time,
      'location': instance.location,
      'note': instance.note,
      'assignment': instance.assignment.toJson(),
      'recurringId': instance.recurringId,
      'cancelled': instance.cancelled,
      'allAssigneeIds': instance.allAssigneeIds,
    };
