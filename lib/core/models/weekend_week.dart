import 'package:freezed_annotation/freezed_annotation.dart';

import 'assignment.dart';
import 'enums.dart';
import 'memorial.dart';

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

    /// This week only: the meeting is held on another day / at another time
    /// than the congregation's regular setting. Null means "follow the
    /// congregation setting", so the keys stay absent from documents that
    /// never needed them — see [weekdayOr] / [timeOr].
    @JsonKey(includeIfNull: false) int? meetingWeekday,
    @JsonKey(includeIfNull: false) String? meetingTime,

    /// S-99 talk number when the title was picked from the catalog;
    /// null for free-text titles. The stored [talkTitle] is a snapshot.
    @JsonKey(includeIfNull: false) int? talkNo,

    /// Opening song. [songTitle] is a snapshot; [songNo] is the catalog number
    /// when picked from the song list, null for free text.
    @Default('') String songTitle,
    @JsonKey(includeIfNull: false) int? songNo,

    /// Which program this week's meeting runs. The regular program below is
    /// kept whatever this says, so switching to (and back from) a Memorial or
    /// a week with nothing planned never destroys scheduling work.
    @Default(MeetingProgramKind.regular) MeetingProgramKind programKind,

    /// What publishers are shown instead of the program when the week has
    /// [MeetingProgramKind.nothingPlanned] — "assembly in Brno", and so on.
    @Default('') String programNote,

    /// The Memorial program, when this week runs one. Kept (like the regular
    /// program) even while another kind is selected.
    @JsonKey(includeIfNull: false) MemorialProgram? memorial,
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

  /// The weekday this week's meeting is held on: the week's own override, or
  /// [fallback] (the congregation setting) when it has none.
  int weekdayOr(int fallback) => meetingWeekday ?? fallback;

  /// The time this week's meeting starts at; see [weekdayOr].
  String timeOr(String fallback) => meetingTime ?? fallback;

  bool get hasMeetingOverride => meetingWeekday != null || meetingTime != null;

  /// Whether the regular public talk / Watchtower study is what this week
  /// actually runs.
  bool get isRegular => programKind == MeetingProgramKind.regular;

  /// The Memorial program, defaulted so the view never has to null-check it.
  MemorialProgram get memorialOrEmpty => memorial ?? const MemorialProgram();

  /// Covers every stored slot, dormant program kinds included — see
  /// [LmmWeek.withRecomputedAssignees] for why.
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
      ...?memorial?.publisherIds,
    };
    return copyWith(allAssigneeIds: ids.toList()..sort());
  }

  /// Rewrites every occurrence of publisher id [from] to [to] across the
  /// whole week and recomputes [allAssigneeIds]. Used when connecting an
  /// admin-created record to a registered account.
  WeekendWeek replaceAssignee(String from, String to) => copyWith(
        speaker: speaker.replaceAssignee(from, to),
        chairman: chairman.replaceAssignee(from, to),
        wtReader: wtReader.replaceAssignee(from, to),
        customFields: [
          for (final c in customFields)
            c.copyWith(assignment: c.assignment.replaceAssignee(from, to)),
        ],
        attendants: attendants.replaceAssignee(from, to),
        microphones: microphones.replaceAssignee(from, to),
        audioVideo: audioVideo.replaceAssignee(from, to),
        customAssignments: [
          for (final c in customAssignments)
            c.copyWith(assignment: c.assignment.replaceAssignee(from, to)),
        ],
        memorial: memorial?.replaceAssignee(from, to),
      ).withRecomputedAssignees();
}
