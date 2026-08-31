// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memorial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemorialProgram _$MemorialProgramFromJson(Map<String, dynamic> json) =>
    _MemorialProgram(
      openingSongTitle: json['songTitle'] as String? ?? '',
      openingSongNo: (json['songNo'] as num?)?.toInt(),
      closingSongTitle: json['closingSongTitle'] as String? ?? '',
      closingSongNo: (json['closingSongNo'] as num?)?.toInt(),
      chairman: json['chairman'] == null
          ? const Assignment()
          : Assignment.fromJson(json['chairman'] as Map<String, dynamic>),
      speaker: json['speaker'] == null
          ? const Assignment()
          : Assignment.fromJson(json['speaker'] as Map<String, dynamic>),
      breadPrayer: json['breadPrayer'] == null
          ? const Assignment()
          : Assignment.fromJson(json['breadPrayer'] as Map<String, dynamic>),
      winePrayer: json['winePrayer'] == null
          ? const Assignment()
          : Assignment.fromJson(json['winePrayer'] as Map<String, dynamic>),
      customFields:
          (json['customFields'] as List<dynamic>?)
              ?.map((e) => CustomAssignment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CustomAssignment>[],
    );

Map<String, dynamic> _$MemorialProgramToJson(_MemorialProgram instance) =>
    <String, dynamic>{
      'songTitle': instance.openingSongTitle,
      'songNo': ?instance.openingSongNo,
      'closingSongTitle': instance.closingSongTitle,
      'closingSongNo': ?instance.closingSongNo,
      'chairman': instance.chairman.toJson(),
      'speaker': instance.speaker.toJson(),
      'breadPrayer': instance.breadPrayer.toJson(),
      'winePrayer': instance.winePrayer.toJson(),
      'customFields': instance.customFields.map((e) => e.toJson()).toList(),
    };
