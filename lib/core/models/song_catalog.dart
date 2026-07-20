import 'package:freezed_annotation/freezed_annotation.dart';

part 'song_catalog.freezed.dart';
part 'song_catalog.g.dart';

/// Congregation-wide catalog of meeting song titles, fetched from the official
/// jw.org CDN and stored as the single doc song_catalog/catalog, keyed by song
/// number so records survive title-wording changes.
@freezed
abstract class SongCatalog with _$SongCatalog {
  const SongCatalog._();

  const factory SongCatalog({
    /// Song number (as string — JSON map keys) -> title.
    @Default(<String, String>{}) Map<String, String> titles,

    /// yyyy-MM-dd of the last fetch.
    @Default('') String updatedAt,

    /// Publication language last fetched (E / B / TK).
    @Default('') String lang,
  }) = _SongCatalog;

  factory SongCatalog.fromJson(Map<String, dynamic> json) =>
      _$SongCatalogFromJson(json);

  String? titleFor(int no) => titles['$no'];

  List<int> get numbers => titles.keys.map(int.parse).toList()..sort();
}
