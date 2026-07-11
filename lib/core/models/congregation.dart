import 'package:freezed_annotation/freezed_annotation.dart';

part 'congregation.freezed.dart';
part 'congregation.g.dart';

/// Singleton congregation/meta document.
@freezed
abstract class CongregationMeta with _$CongregationMeta {
  const factory CongregationMeta({
    @Default('') String name,
    @Default('') String founderUid,

    /// DateTime.monday..DateTime.sunday (1..7)
    @Default(DateTime.tuesday) int lmmWeekday,

    /// "HH:mm"
    @Default('18:30') String lmmTime,

    /// Midweek meeting classes (1 = main hall only, 2-3 add auxiliary
    /// classes with their own student assignments).
    @Default(1) int lmmClassCount,
    @Default(DateTime.sunday) int weekendWeekday,
    @Default('10:00') String weekendTime,
  }) = _CongregationMeta;

  factory CongregationMeta.fromJson(Map<String, dynamic> json) =>
      _$CongregationMetaFromJson(json);
}
