import 'package:freezed_annotation/freezed_annotation.dart';

import 'assignment.dart';
import 'enums.dart';

part 'lmm_week.freezed.dart';
part 'lmm_week.g.dart';

/// One numbered (or structural) part of the midweek meeting.
@freezed
abstract class LmmPart with _$LmmPart {
  const factory LmmPart({
    @Default('') String id,
    @Default(LmmSection.treasures) LmmSection section,
    @Default(LmmPartType.custom) LmmPartType type,
    @Default('') String title,

    /// Instructions/reference from the workbook, e.g. "HOUSE TO HOUSE.
    /// Share a Bible truth… (lmd lesson 1 point 5)" or "wcg chap. 15".
    @Default('') String description,
    int? durationMin,
    @Default(Assignment()) Assignment assignment,

    /// Demonstration assistant (field-ministry parts).
    @Default(Assignment()) Assignment assistant,
  }) = _LmmPart;

  factory LmmPart.fromJson(Map<String, dynamic> json) =>
      _$LmmPartFromJson(json);
}

/// Life and Ministry Meeting week document, keyed by the Monday (yyyy-MM-dd).
@freezed
abstract class LmmWeek with _$LmmWeek {
  const LmmWeek._();

  const factory LmmWeek({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,

    /// Human label from the workbook, e.g. "JULY 6-12 | PSALM 45".
    @Default('') String weekLabel,
    @Default(<String>[]) List<String> songs,

    /// epub | cdn | manual
    @Default('manual') String source,
    @Default(<LmmPart>[]) List<LmmPart> parts,
    @Default(Assignment()) Assignment attendants,
    @Default(Assignment()) Assignment microphones,
    @Default(Assignment()) Assignment audioVideo,
    @Default(<CustomAssignment>[]) List<CustomAssignment> customAssignments,

    /// Denormalized union of every assigned publisher id, kept in sync on
    /// save; enables array-contains "my assignments" queries.
    @Default(<String>[]) List<String> allAssigneeIds,
  }) = _LmmWeek;

  factory LmmWeek.fromJson(Map<String, dynamic> json) =>
      _$LmmWeekFromJson(json);

  LmmWeek withRecomputedAssignees() {
    final ids = <String>{
      for (final p in parts) ...[
        ...p.assignment.publisherIds,
        ...p.assistant.publisherIds,
      ],
      ...attendants.publisherIds,
      ...microphones.publisherIds,
      ...audioVideo.publisherIds,
      for (final c in customAssignments) ...c.assignment.publisherIds,
    };
    return copyWith(allAssigneeIds: ids.toList()..sort());
  }
}
