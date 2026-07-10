// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TalkCatalog _$TalkCatalogFromJson(Map<String, dynamic> json) => _TalkCatalog(
  titles:
      (json['titles'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  updatedAt: json['updatedAt'] as String? ?? '',
  source: json['source'] as String? ?? '',
);

Map<String, dynamic> _$TalkCatalogToJson(_TalkCatalog instance) =>
    <String, dynamic>{
      'titles': instance.titles,
      'updatedAt': instance.updatedAt,
      'source': instance.source,
    };
