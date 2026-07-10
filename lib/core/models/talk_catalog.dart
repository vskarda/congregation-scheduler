import 'package:freezed_annotation/freezed_annotation.dart';

part 'talk_catalog.freezed.dart';
part 'talk_catalog.g.dart';

/// Congregation-wide catalog of approved public talk titles (S-99),
/// stored as the single doc public_talks/catalog and keyed by talk number
/// so records survive title-wording changes.
@freezed
abstract class TalkCatalog with _$TalkCatalog {
  const TalkCatalog._();

  const factory TalkCatalog({
    /// Talk number (as string — JSON map keys) -> approved title.
    @Default(<String, String>{}) Map<String, String> titles,

    /// yyyy-MM-dd of the last import or manual edit.
    @Default('') String updatedAt,

    /// Name of the imported file, for reference.
    @Default('') String source,
  }) = _TalkCatalog;

  factory TalkCatalog.fromJson(Map<String, dynamic> json) =>
      _$TalkCatalogFromJson(json);

  String? titleFor(int no) => titles['$no'];

  List<int> get numbers => titles.keys.map(int.parse).toList()..sort();
}
