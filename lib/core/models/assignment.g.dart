// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Assignment _$AssignmentFromJson(Map<String, dynamic> json) => _Assignment(
  publisherIds:
      (json['publisherIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  freeText: json['freeText'] as String? ?? '',
);

Map<String, dynamic> _$AssignmentToJson(_Assignment instance) =>
    <String, dynamic>{
      'publisherIds': instance.publisherIds,
      'freeText': instance.freeText,
    };

_CustomAssignment _$CustomAssignmentFromJson(Map<String, dynamic> json) =>
    _CustomAssignment(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      assignment: json['assignment'] == null
          ? const Assignment()
          : Assignment.fromJson(json['assignment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomAssignmentToJson(_CustomAssignment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'assignment': instance.assignment.toJson(),
    };
