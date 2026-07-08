// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventItem _$EventItemFromJson(Map<String, dynamic> json) => _EventItem(
  title: json['title'] as String? ?? '',
  type:
      $enumDecodeNullable(_$EventTypeEnumMap, json['type']) ?? EventType.other,
  dateFrom: json['dateFrom'] as String? ?? '',
  dateTo: json['dateTo'] as String? ?? '',
  location: json['location'] as String? ?? '',
  notes: json['notes'] as String? ?? '',
);

Map<String, dynamic> _$EventItemToJson(_EventItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'type': _$EventTypeEnumMap[instance.type]!,
      'dateFrom': instance.dateFrom,
      'dateTo': instance.dateTo,
      'location': instance.location,
      'notes': instance.notes,
    };

const _$EventTypeEnumMap = {
  EventType.convention: 'convention',
  EventType.assembly: 'assembly',
  EventType.memorial: 'memorial',
  EventType.coVisit: 'coVisit',
  EventType.other: 'other',
};
