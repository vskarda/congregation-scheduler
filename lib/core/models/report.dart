import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';
import 'enums.dart';

part 'report.freezed.dart';
part 'report.g.dart';

/// Ministry report at reports/{yyyy-MM}/entries/{publisherId}.
@freezed
abstract class MinistryReport with _$MinistryReport {
  const MinistryReport._();

  const factory MinistryReport({
    /// = publisher document id.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String publisherId,

    /// yyyy-MM
    @Default('') String month,
    @Default(false) bool participated,
    int? bibleStudies,

    /// Field service hours (pioneers).
    int? hours,

    /// Credit hours (Bethel, construction, pioneer school, …).
    int? creditHours,
    @Default('') String comments,

    /// Publisher status snapshot for the reported month; drives the S-1
    /// group breakdown even when the status changes later.
    @Default(PublisherStatus.publisher) PublisherStatus statusAtMonth,
    @NullableTimestampConverter() DateTime? submittedAt,

    /// 'self' or the uid of the admin who entered a paper report.
    @Default('self') String enteredBy,
  }) = _MinistryReport;

  factory MinistryReport.fromJson(Map<String, dynamic> json) =>
      _$MinistryReportFromJson(json);

  int get totalHours => (hours ?? 0) + (creditHours ?? 0);
}
