import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'event_item.freezed.dart';
part 'event_item.g.dart';

@freezed
abstract class EventItem with _$EventItem {
  const factory EventItem({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String title,
    @Default(EventType.other) EventType type,

    /// yyyy-MM-dd (inclusive range; single-day events leave dateTo empty)
    @Default('') String dateFrom,
    @Default('') String dateTo,
    @Default('') String location,
    @Default('') String notes,
  }) = _EventItem;

  factory EventItem.fromJson(Map<String, dynamic> json) =>
      _$EventItemFromJson(json);
}
