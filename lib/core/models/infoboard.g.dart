// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infoboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InfoboardItem _$InfoboardItemFromJson(Map<String, dynamic> json) =>
    _InfoboardItem(
      type:
          $enumDecodeNullable(_$InfoItemTypeEnumMap, json['type']) ??
          InfoItemType.text,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      fileId: json['fileId'] as String? ?? '',
      url: json['url'] as String? ?? '',
      showFrom: json['showFrom'] as String? ?? '',
      showUntil: json['showUntil'] as String? ?? '',
      createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
      createdBy: json['createdBy'] as String? ?? '',
    );

Map<String, dynamic> _$InfoboardItemToJson(
  _InfoboardItem instance,
) => <String, dynamic>{
  'type': _$InfoItemTypeEnumMap[instance.type]!,
  'title': instance.title,
  'body': instance.body,
  'fileId': instance.fileId,
  'url': instance.url,
  'showFrom': instance.showFrom,
  'showUntil': instance.showUntil,
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
  'createdBy': instance.createdBy,
};

const _$InfoItemTypeEnumMap = {
  InfoItemType.text: 'text',
  InfoItemType.file: 'file',
  InfoItemType.link: 'link',
};

_StoredFileMeta _$StoredFileMetaFromJson(Map<String, dynamic> json) =>
    _StoredFileMeta(
      name: json['name'] as String? ?? '',
      mimeType: json['mimeType'] as String? ?? '',
      sizeBytes: (json['sizeBytes'] as num?)?.toInt() ?? 0,
      chunkCount: (json['chunkCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StoredFileMetaToJson(_StoredFileMeta instance) =>
    <String, dynamic>{
      'name': instance.name,
      'mimeType': instance.mimeType,
      'sizeBytes': instance.sizeBytes,
      'chunkCount': instance.chunkCount,
    };
