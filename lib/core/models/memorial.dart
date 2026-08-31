import 'package:freezed_annotation/freezed_annotation.dart';

import 'assignment.dart';

part 'memorial.freezed.dart';
part 'memorial.g.dart';

/// The Memorial program, embedded in the week document of whichever meeting
/// it replaces ([LmmWeek.memorial] / [WeekendWeek.memorial]; the week's
/// `programKind` says which program is actually running).
///
/// The Memorial can fall on any day, so it carries no day or time of its own:
/// the week's existing `meetingWeekday` / `meetingTime` override moves it, the
/// same mechanism that moves a meeting for a circuit overseer's visit.
///
/// Attendants and audio/video are not here either — they are the week
/// document's own support slots, shared by all three program kinds.
///
/// Every slot takes a publisher or free text (a visiting speaker gives the
/// talk more often than not), so none of them filters the picker.
@freezed
abstract class MemorialProgram with _$MemorialProgram {
  const MemorialProgram._();

  const factory MemorialProgram({
    /// Opening song, before the talk. [openingSongTitle] is a snapshot;
    /// [openingSongNo] is the catalog number when picked from the song list,
    /// null for free text.
    ///
    /// JSON keys stay `songTitle`/`songNo` — the Memorial had only the one
    /// song when those were chosen, and renaming them would orphan the
    /// opening song on every Memorial already saved.
    @JsonKey(name: 'songTitle') @Default('') String openingSongTitle,
    @JsonKey(name: 'songNo', includeIfNull: false) int? openingSongNo,

    /// Closing song, after the wine is passed.
    @Default('') String closingSongTitle,
    @JsonKey(includeIfNull: false) int? closingSongNo,
    @Default(Assignment()) Assignment chairman,
    @Default(Assignment()) Assignment speaker,

    /// The two prayers said over the emblems.
    @Default(Assignment()) Assignment breadPrayer,
    @Default(Assignment()) Assignment winePrayer,

    /// Extra program fields (label + assignment/free text), this Memorial
    /// only — the schedule's permanent custom assignments recur on every
    /// week and belong to the week document instead.
    @Default(<CustomAssignment>[]) List<CustomAssignment> customFields,
  }) = _MemorialProgram;

  factory MemorialProgram.fromJson(Map<String, dynamic> json) =>
      _$MemorialProgramFromJson(json);

  /// Every publisher named anywhere in the program.
  Iterable<String> get publisherIds => [
        ...chairman.publisherIds,
        ...speaker.publisherIds,
        ...breadPrayer.publisherIds,
        ...winePrayer.publisherIds,
        for (final c in customFields) ...c.assignment.publisherIds,
      ];

  /// Rewrites every occurrence of publisher id [from] to [to]; used when
  /// connecting an admin-created record to a registered account.
  MemorialProgram replaceAssignee(String from, String to) => copyWith(
        chairman: chairman.replaceAssignee(from, to),
        speaker: speaker.replaceAssignee(from, to),
        breadPrayer: breadPrayer.replaceAssignee(from, to),
        winePrayer: winePrayer.replaceAssignee(from, to),
        customFields: [
          for (final c in customFields)
            c.copyWith(assignment: c.assignment.replaceAssignee(from, to)),
        ],
      );
}
