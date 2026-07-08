// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'territory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Territory _$TerritoryFromJson(Map<String, dynamic> json) => _Territory(
  name: json['name'] as String? ?? '',
  number: json['number'] as String? ?? '',
  mapUrl: json['mapUrl'] as String? ?? '',
  notes: json['notes'] as String? ?? '',
);

Map<String, dynamic> _$TerritoryToJson(_Territory instance) =>
    <String, dynamic>{
      'name': instance.name,
      'number': instance.number,
      'mapUrl': instance.mapUrl,
      'notes': instance.notes,
    };

_TerritoryAssignment _$TerritoryAssignmentFromJson(Map<String, dynamic> json) =>
    _TerritoryAssignment(
      territoryId: json['territoryId'] as String? ?? '',
      publisherId: json['publisherId'] as String? ?? '',
      assignedDate: json['assignedDate'] as String? ?? '',
      returnedDate: json['returnedDate'] as String? ?? '',
      returnNotes: json['returnNotes'] as String? ?? '',
    );

Map<String, dynamic> _$TerritoryAssignmentToJson(
  _TerritoryAssignment instance,
) => <String, dynamic>{
  'territoryId': instance.territoryId,
  'publisherId': instance.publisherId,
  'assignedDate': instance.assignedDate,
  'returnedDate': instance.returnedDate,
  'returnNotes': instance.returnNotes,
};
