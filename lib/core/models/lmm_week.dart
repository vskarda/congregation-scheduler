import 'package:freezed_annotation/freezed_annotation.dart';

import 'assignment.dart';
import 'enums.dart';
import 'memorial.dart';

part 'lmm_week.freezed.dart';
part 'lmm_week.g.dart';

/// One numbered (or structural) part of the midweek meeting.
@freezed
abstract class LmmPart with _$LmmPart {
  const LmmPart._();

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

    /// Student/assistant slots for auxiliary classes 2 and 3; only used on
    /// student parts (see [isStudentPart]) and only shown when
    /// CongregationMeta.lmmClassCount enables the class.
    @Default(Assignment()) Assignment assignment2,
    @Default(Assignment()) Assignment assistant2,
    @Default(Assignment()) Assignment assignment3,
    @Default(Assignment()) Assignment assistant3,

    /// Program content typed by an admin rather than parsed from the Meeting
    /// Workbook. A re-import keeps this part's title, description and
    /// duration instead of overwriting them, and keeps the part itself even
    /// when the parsed program has no counterpart for it (see
    /// `mergeParsedWeek`). Set by the part dialog, clearable there too.
    @Default(false) bool manual,
  }) = _LmmPart;

  factory LmmPart.fromJson(Map<String, dynamic> json) =>
      _$LmmPartFromJson(json);

  /// Parts whose assignee differs per auxiliary class.
  bool get isStudentPart =>
      type == LmmPartType.bibleReading || type == LmmPartType.fieldMinistry;

  Assignment assignmentFor(int classIndex) => switch (classIndex) {
    2 => assignment2,
    3 => assignment3,
    _ => assignment,
  };

  Assignment assistantFor(int classIndex) => switch (classIndex) {
    2 => assistant2,
    3 => assistant3,
    _ => assistant,
  };

  LmmPart withAssignmentFor(int classIndex, Assignment a) =>
      switch (classIndex) {
        2 => copyWith(assignment2: a),
        3 => copyWith(assignment3: a),
        _ => copyWith(assignment: a),
      };

  LmmPart withAssistantFor(int classIndex, Assignment a) =>
      switch (classIndex) {
        2 => copyWith(assistant2: a),
        3 => copyWith(assistant3: a),
        _ => copyWith(assistant: a),
      };

  /// Rewrites every occurrence of publisher id [from] to [to] in all
  /// assignment/assistant slots (see [Assignment.replaceAssignee]).
  LmmPart replaceAssignee(String from, String to) => copyWith(
        assignment: assignment.replaceAssignee(from, to),
        assistant: assistant.replaceAssignee(from, to),
        assignment2: assignment2.replaceAssignee(from, to),
        assistant2: assistant2.replaceAssignee(from, to),
        assignment3: assignment3.replaceAssignee(from, to),
        assistant3: assistant3.replaceAssignee(from, to),
      );
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

    /// This week only: the meeting is held on another day / at another time
    /// than the congregation's regular setting (a circuit overseer's visit
    /// moves the midweek meeting to Tuesday, an assembly moves it elsewhere).
    /// Null means "follow the congregation setting", so the keys stay absent
    /// from documents that never needed them — see [weekdayOr] / [timeOr].
    @JsonKey(includeIfNull: false) int? meetingWeekday,
    @JsonKey(includeIfNull: false) String? meetingTime,

    /// The three meeting songs at their fixed positions: opening (before
    /// Treasures), the Living-as-Christians song, and the closing song. Each
    /// [*Title] is a snapshot; each [*No] is the catalog number when known
    /// (from the parsed workbook or a picked song), null for free text.
    @Default('') String openingSongTitle,
    @JsonKey(includeIfNull: false) int? openingSongNo,
    @Default('') String livingSongTitle,
    @JsonKey(includeIfNull: false) int? livingSongNo,
    @Default('') String closingSongTitle,
    @JsonKey(includeIfNull: false) int? closingSongNo,

    /// Song slots picked or typed by hand; a re-import leaves those alone,
    /// exactly like [LmmPart.manual] does for a part.
    @Default(false) bool openingSongManual,
    @Default(false) bool livingSongManual,
    @Default(false) bool closingSongManual,

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

  /// The weekday this week's meeting is held on: the week's own override, or
  /// [fallback] (the congregation setting) when it has none.
  int weekdayOr(int fallback) => meetingWeekday ?? fallback;

  /// The time this week's meeting starts at; see [weekdayOr].
  String timeOr(String fallback) => meetingTime ?? fallback;

  bool get hasMeetingOverride => meetingWeekday != null || meetingTime != null;

  /// Whether the regular workbook program is what this week actually runs.
  bool get isRegular => programKind == MeetingProgramKind.regular;

  /// The Memorial program, defaulted so the view never has to null-check it.
  MemorialProgram get memorialOrEmpty => memorial ?? const MemorialProgram();

  /// The union covers every stored slot, the ones belonging to a program kind
  /// this week is not currently running included: `allAssigneeIds` backs the
  /// array-contains query the connect-publisher migration uses, which must
  /// still find a week whose Memorial (or whose regular program) is dormant.
  /// Filtering by the active program happens where assignments are shown.
  LmmWeek withRecomputedAssignees() {
    final ids = <String>{
      for (final p in parts) ...[
        ...p.assignment.publisherIds,
        ...p.assistant.publisherIds,
        ...p.assignment2.publisherIds,
        ...p.assistant2.publisherIds,
        ...p.assignment3.publisherIds,
        ...p.assistant3.publisherIds,
      ],
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
  LmmWeek replaceAssignee(String from, String to) => copyWith(
        parts: [for (final p in parts) p.replaceAssignee(from, to)],
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
