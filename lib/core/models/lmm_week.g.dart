// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lmm_week.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LmmPart _$LmmPartFromJson(Map<String, dynamic> json) => _LmmPart(
  id: json['id'] as String? ?? '',
  section:
      $enumDecodeNullable(_$LmmSectionEnumMap, json['section']) ??
      LmmSection.treasures,
  type:
      $enumDecodeNullable(_$LmmPartTypeEnumMap, json['type']) ??
      LmmPartType.custom,
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  durationMin: (json['durationMin'] as num?)?.toInt(),
  assignment: json['assignment'] == null
      ? const Assignment()
      : Assignment.fromJson(json['assignment'] as Map<String, dynamic>),
  assistant: json['assistant'] == null
      ? const Assignment()
      : Assignment.fromJson(json['assistant'] as Map<String, dynamic>),
  assignment2: json['assignment2'] == null
      ? const Assignment()
      : Assignment.fromJson(json['assignment2'] as Map<String, dynamic>),
  assistant2: json['assistant2'] == null
      ? const Assignment()
      : Assignment.fromJson(json['assistant2'] as Map<String, dynamic>),
  assignment3: json['assignment3'] == null
      ? const Assignment()
      : Assignment.fromJson(json['assignment3'] as Map<String, dynamic>),
  assistant3: json['assistant3'] == null
      ? const Assignment()
      : Assignment.fromJson(json['assistant3'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LmmPartToJson(_LmmPart instance) => <String, dynamic>{
  'id': instance.id,
  'section': _$LmmSectionEnumMap[instance.section]!,
  'type': _$LmmPartTypeEnumMap[instance.type]!,
  'title': instance.title,
  'description': instance.description,
  'durationMin': instance.durationMin,
  'assignment': instance.assignment.toJson(),
  'assistant': instance.assistant.toJson(),
  'assignment2': instance.assignment2.toJson(),
  'assistant2': instance.assistant2.toJson(),
  'assignment3': instance.assignment3.toJson(),
  'assistant3': instance.assistant3.toJson(),
};

const _$LmmSectionEnumMap = {
  LmmSection.opening: 'opening',
  LmmSection.treasures: 'treasures',
  LmmSection.ministry: 'ministry',
  LmmSection.living: 'living',
  LmmSection.closing: 'closing',
};

const _$LmmPartTypeEnumMap = {
  LmmPartType.chairman: 'chairman',
  LmmPartType.prayer: 'prayer',
  LmmPartType.treasures: 'treasures',
  LmmPartType.gems: 'gems',
  LmmPartType.bibleReading: 'bibleReading',
  LmmPartType.fieldMinistry: 'fieldMinistry',
  LmmPartType.living: 'living',
  LmmPartType.cbsConductor: 'cbsConductor',
  LmmPartType.cbsReader: 'cbsReader',
  LmmPartType.custom: 'custom',
};

_LmmWeek _$LmmWeekFromJson(Map<String, dynamic> json) => _LmmWeek(
  weekLabel: json['weekLabel'] as String? ?? '',
  openingSongTitle: json['openingSongTitle'] as String? ?? '',
  openingSongNo: (json['openingSongNo'] as num?)?.toInt(),
  livingSongTitle: json['livingSongTitle'] as String? ?? '',
  livingSongNo: (json['livingSongNo'] as num?)?.toInt(),
  closingSongTitle: json['closingSongTitle'] as String? ?? '',
  closingSongNo: (json['closingSongNo'] as num?)?.toInt(),
  source: json['source'] as String? ?? 'manual',
  parts:
      (json['parts'] as List<dynamic>?)
          ?.map((e) => LmmPart.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LmmPart>[],
  attendants: json['attendants'] == null
      ? const Assignment()
      : Assignment.fromJson(json['attendants'] as Map<String, dynamic>),
  microphones: json['microphones'] == null
      ? const Assignment()
      : Assignment.fromJson(json['microphones'] as Map<String, dynamic>),
  audioVideo: json['audioVideo'] == null
      ? const Assignment()
      : Assignment.fromJson(json['audioVideo'] as Map<String, dynamic>),
  customAssignments:
      (json['customAssignments'] as List<dynamic>?)
          ?.map((e) => CustomAssignment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CustomAssignment>[],
  allAssigneeIds:
      (json['allAssigneeIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$LmmWeekToJson(_LmmWeek instance) => <String, dynamic>{
  'weekLabel': instance.weekLabel,
  'openingSongTitle': instance.openingSongTitle,
  'openingSongNo': ?instance.openingSongNo,
  'livingSongTitle': instance.livingSongTitle,
  'livingSongNo': ?instance.livingSongNo,
  'closingSongTitle': instance.closingSongTitle,
  'closingSongNo': ?instance.closingSongNo,
  'source': instance.source,
  'parts': instance.parts.map((e) => e.toJson()).toList(),
  'attendants': instance.attendants.toJson(),
  'microphones': instance.microphones.toJson(),
  'audioVideo': instance.audioVideo.toJson(),
  'customAssignments': instance.customAssignments
      .map((e) => e.toJson())
      .toList(),
  'allAssigneeIds': instance.allAssigneeIds,
};
