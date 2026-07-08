import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'attendance.freezed.dart';
part 'attendance.g.dart';

/// One meeting's attendance; doc id is "{date}_{meetingType}" so a meeting
/// can only be counted once.
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
    @Default(0) int inPerson,
    @Default(0) int online,
  }) = _AttendanceEntry;

  factory AttendanceEntry.fromJson(Map<String, dynamic> json) =>
      _$AttendanceEntryFromJson(json);

  /// Overview always shows one combined number.
  int get total => inPerson + online;

  static String docId(String date, MeetingType type) =>
      '${date}_${type.name}';
}
