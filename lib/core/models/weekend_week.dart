import 'package:freezed_annotation/freezed_annotation.dart';

import 'assignment.dart';

part 'weekend_week.freezed.dart';
part 'weekend_week.g.dart';

/// Weekend meeting week document, keyed by the Monday (yyyy-MM-dd) of its week.
@freezed
abstract class WeekendWeek with _$WeekendWeek {
  const WeekendWeek._();

  const factory WeekendWeek({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String talkTitle,

    /// S-99 talk number when the title was picked from the catalog;
    /// null for free-text titles. The stored [talkTitle] is a snapshot.
    @JsonKey(includeIfNull: false) int? talkNo,
    @Default(Assignment()) Assignment speaker,
    @Default(Assignment()) Assignment chairman,
    @Default(Assignment()) Assignment wtReader,

    /// Extra program fields (label + assignment/free text).
    @Default(<CustomAssignment>[]) List<CustomAssignment> customFields,
    @Default(Assignment()) Assignment attendants,
    @Default(Assignment()) Assignment microphones,
    @Default(Assignment()) Assignment audioVideo,
    @Default(<CustomAssignment>[]) List<CustomAssignment> customAssignments,
    @Default(<String>[]) List<String> allAssigneeIds,
  }) = _WeekendWeek;

  factory WeekendWeek.fromJson(Map<String, dynamic> json) =>
      _$WeekendWeekFromJson(json);

  WeekendWeek withRecomputedAssignees() {
    final ids = <String>{
      ...speaker.publisherIds,
      ...chairman.publisherIds,
      ...wtReader.publisherIds,
      for (final c in customFields) ...c.assignment.publisherIds,
      ...attendants.publisherIds,
      ...microphones.publisherIds,
      ...audioVideo.publisherIds,
      for (final c in customAssignments) ...c.assignment.publisherIds,
    };
    return copyWith(allAssigneeIds: ids.toList()..sort());
  }
}
