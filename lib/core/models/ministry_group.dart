import 'package:freezed_annotation/freezed_annotation.dart';

part 'ministry_group.freezed.dart';
part 'ministry_group.g.dart';

/// A field ministry group. Membership is not stored here: each publisher
/// carries an optional `groupId` on their own doc, so members are derived
/// by filtering the publishers stream.
@freezed
abstract class MinistryGroup with _$MinistryGroup {
  const factory MinistryGroup({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String name,

    /// Publisher id of the group overseer ('' = none). Chosen among members.
    @Default('') String overseerId,

    /// Publisher id of the overseer's assistant ('' = none).
    @Default('') String assistantId,
  }) = _MinistryGroup;

  factory MinistryGroup.fromJson(Map<String, dynamic> json) =>
      _$MinistryGroupFromJson(json);
}
