import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 's1_record.freezed.dart';
part 's1_record.g.dart';

/// One S-1 group line: publishers / auxiliary pioneers / regular pioneers.
@freezed
abstract class S1Group with _$S1Group {
  const factory S1Group({
    @Default(0) int count,
    @Default(0) int studies,

    /// Field service + credit hours.
    @Default(0) int hours,
  }) = _S1Group;

  factory S1Group.fromJson(Map<String, dynamic> json) =>
      _$S1GroupFromJson(json);
}

/// One month's S-1 figures — both the live computation (`frozenAt == null`)
/// and, once frozen, the document at `s1_records/{yyyy-MM}`.
///
/// Freezing exists because the S-1 is derived from data that keeps moving:
/// reports arrive late, attendance gets corrected, a moving date is entered
/// months after the fact. What was submitted to the branch must not change
/// under any of that, so the figures are stored as sent and read back
/// verbatim; the underlying reports stay editable.
@freezed
abstract class S1Record with _$S1Record {
  const factory S1Record({
    /// yyyy-MM, = doc id.
    @Default('') String month,

    /// Distinct persons with a positive report in the last 6 months
    /// (including this month).
    @Default(0) int activePublishers,
    int? avgMidweekAttendance,
    int? avgWeekendAttendance,
    @Default(S1Group()) S1Group publishers,
    @Default(S1Group()) S1Group auxiliaryPioneers,
    @Default(S1Group()) S1Group regularPioneers,

    /// When the figures were frozen; null on a freshly computed result.
    @NullableTimestampConverter() DateTime? frozenAt,

    /// Uid of whoever froze the month (empty for the automatic sweep).
    @Default('') String frozenBy,

    /// Written by the automatic sweep rather than by the Freeze button.
    @Default(false) bool auto,
  }) = _S1Record;

  const S1Record._();

  factory S1Record.fromJson(Map<String, dynamic> json) =>
      _$S1RecordFromJson(json);

  bool get isFrozen => frozenAt != null;
}
