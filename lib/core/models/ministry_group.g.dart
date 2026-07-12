// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ministry_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MinistryGroup _$MinistryGroupFromJson(Map<String, dynamic> json) =>
    _MinistryGroup(
      name: json['name'] as String? ?? '',
      overseerId: json['overseerId'] as String? ?? '',
      assistantId: json['assistantId'] as String? ?? '',
    );

Map<String, dynamic> _$MinistryGroupToJson(_MinistryGroup instance) =>
    <String, dynamic>{
      'name': instance.name,
      'overseerId': instance.overseerId,
      'assistantId': instance.assistantId,
    };
