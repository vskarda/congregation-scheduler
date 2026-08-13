// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'co_visit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoVisitItem _$CoVisitItemFromJson(Map<String, dynamic> json) => _CoVisitItem(
  id: json['id'] as String? ?? '',
  section:
      $enumDecodeNullable(_$CoVisitSectionEnumMap, json['section']) ??
      CoVisitSection.other,
  date: json['date'] as String? ?? '',
  time: json['time'] as String? ?? '',
  assignment: json['assignment'] == null
      ? const Assignment()
      : Assignment.fromJson(json['assignment'] as Map<String, dynamic>),
  address: json['address'] as String? ?? '',
  note: json['note'] as String? ?? '',
);

Map<String, dynamic> _$CoVisitItemToJson(_CoVisitItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'section': _$CoVisitSectionEnumMap[instance.section]!,
      'date': instance.date,
      'time': instance.time,
      'assignment': instance.assignment.toJson(),
      'address': instance.address,
      'note': instance.note,
    };

const _$CoVisitSectionEnumMap = {
  CoVisitSection.ministry: 'ministry',
  CoVisitSection.meal: 'meal',
  CoVisitSection.shepherding: 'shepherding',
  CoVisitSection.pioneers: 'pioneers',
  CoVisitSection.elders: 'elders',
  CoVisitSection.other: 'other',
};

_CoVisit _$CoVisitFromJson(Map<String, dynamic> json) => _CoVisit(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CoVisitItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CoVisitItem>[],
  hiddenSections:
      (json['hiddenSections'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  allAssigneeIds:
      (json['allAssigneeIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$CoVisitToJson(_CoVisit instance) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'hiddenSections': instance.hiddenSections,
  'allAssigneeIds': instance.allAssigneeIds,
};

_CoVisitConfig _$CoVisitConfigFromJson(Map<String, dynamic> json) =>
    _CoVisitConfig(
      visibleToPublishers: json['visibleToPublishers'] as bool? ?? false,
    );

Map<String, dynamic> _$CoVisitConfigToJson(_CoVisitConfig instance) =>
    <String, dynamic>{'visibleToPublishers': instance.visibleToPublishers};
