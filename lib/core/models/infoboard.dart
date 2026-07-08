import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';
import 'enums.dart';

part 'infoboard.freezed.dart';
part 'infoboard.g.dart';

@freezed
abstract class InfoboardItem with _$InfoboardItem {
  const InfoboardItem._();

  const factory InfoboardItem({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default(InfoItemType.text) InfoItemType type,
    @Default('') String title,

    /// Text content for [InfoItemType.text].
    @Default('') String body,

    /// files/{fileId} reference for [InfoItemType.file].
    @Default('') String fileId,

    /// External URL for [InfoItemType.link].
    @Default('') String url,

    /// Visibility window (yyyy-MM-dd, inclusive); empty = unbounded.
    @Default('') String showFrom,
    @Default('') String showUntil,
    @NullableTimestampConverter() DateTime? createdAt,
    @Default('') String createdBy,
  }) = _InfoboardItem;

  factory InfoboardItem.fromJson(Map<String, dynamic> json) =>
      _$InfoboardItemFromJson(json);

  bool visibleOn(String todayKey) =>
      (showFrom.isEmpty || showFrom.compareTo(todayKey) <= 0) &&
      (showUntil.isEmpty || showUntil.compareTo(todayKey) >= 0);
}

/// Metadata for a file stored as chunked blobs in files/{id}/chunks/{n}.
@freezed
abstract class StoredFileMeta with _$StoredFileMeta {
  const factory StoredFileMeta({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String name,
    @Default('') String mimeType,
    @Default(0) int sizeBytes,
    @Default(0) int chunkCount,
  }) = _StoredFileMeta;

  factory StoredFileMeta.fromJson(Map<String, dynamic> json) =>
      _$StoredFileMetaFromJson(json);
}
