import 'package:freezed_annotation/freezed_annotation.dart';

part 'territory.freezed.dart';
part 'territory.g.dart';

@freezed
abstract class Territory with _$Territory {
  const factory Territory({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String name,
    @Default('') String number,

    /// Link to a map (e.g. Google My Maps).
    @Default('') String mapUrl,
    @Default('') String notes,
  }) = _Territory;

  factory Territory.fromJson(Map<String, dynamic> json) =>
      _$TerritoryFromJson(json);
}

@freezed
abstract class TerritoryAssignment with _$TerritoryAssignment {
  const TerritoryAssignment._();

  const factory TerritoryAssignment({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String territoryId,
    @Default('') String publisherId,

    /// yyyy-MM-dd
    @Default('') String assignedDate,
    @Default('') String returnedDate,
    @Default('') String returnNotes,
  }) = _TerritoryAssignment;

  factory TerritoryAssignment.fromJson(Map<String, dynamic> json) =>
      _$TerritoryAssignmentFromJson(json);

  bool get isOpen => returnedDate.isEmpty;
}
