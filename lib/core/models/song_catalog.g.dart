// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SongCatalog _$SongCatalogFromJson(Map<String, dynamic> json) => _SongCatalog(
  titles:
      (json['titles'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  updatedAt: json['updatedAt'] as String? ?? '',
  lang: json['lang'] as String? ?? '',
);

Map<String, dynamic> _$SongCatalogToJson(_SongCatalog instance) =>
    <String, dynamic>{
      'titles': instance.titles,
      'updatedAt': instance.updatedAt,
      'lang': instance.lang,
    };
