// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'former_publisher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormerPublisher _$FormerPublisherFromJson(Map<String, dynamic> json) =>
    _FormerPublisher(
      moved: json['moved'] as bool? ?? true,
      movedDate: json['movedDate'] as String?,
      deletedAt: const NullableTimestampConverter().fromJson(json['deletedAt']),
    );

Map<String, dynamic> _$FormerPublisherToJson(
  _FormerPublisher instance,
) => <String, dynamic>{
  'moved': instance.moved,
  'movedDate': ?instance.movedDate,
  'deletedAt': const NullableTimestampConverter().toJson(instance.deletedAt),
};
