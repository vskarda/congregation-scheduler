import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'attendance.freezed.dart';
part 'attendance.g.dart';

/// One meeting's attendance; doc id is "{date}_{meetingType}" so a meeting
/// can only be counted once.
///
/// All three counts are nullable so "not entered" is distinguishable from an
/// entered 0, and a historical record may carry only a total without the
/// in-person/online split.
@freezed
abstract class AttendanceEntry with _$AttendanceEntry {
  const AttendanceEntry._();

  const factory AttendanceEntry({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,

    /// yyyy-MM-dd
    @Default('') String date,
    @Default(MeetingType.lmm) MeetingType meetingType,
    @JsonKey(includeIfNull: false) int? inPerson,
    @JsonKey(includeIfNull: false) int? online,

    /// Stored explicitly (not derived) so a total-only record is possible;
    /// legacy docs lack this field and fall back to inPerson + online.
    @JsonKey(includeIfNull: false) int? total,
  }) = _AttendanceEntry;

  factory AttendanceEntry.fromJson(Map<String, dynamic> json) =>
      _$AttendanceEntryFromJson(json);

  /// Overview always shows one combined number.
  int get resolvedTotal => total ?? ((inPerson ?? 0) + (online ?? 0));

  /// Whether any count has been entered for this meeting.
  bool get hasData => total != null || inPerson != null || online != null;

  static String docId(String date, MeetingType type) =>
      '${date}_${type.name}';
}
