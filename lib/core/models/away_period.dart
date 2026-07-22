import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/dates.dart';

part 'away_period.freezed.dart';
part 'away_period.g.dart';

/// A single vacation / unavailability span a publisher declares on their
/// profile. Both bounds are inclusive `yyyy-MM-dd` date-only strings.
@freezed
abstract class AwayPeriod with _$AwayPeriod {
  const AwayPeriod._();

  const factory AwayPeriod({
    required String startDate,
    required String endDate,
  }) = _AwayPeriod;

  factory AwayPeriod.fromJson(Map<String, dynamic> json) =>
      _$AwayPeriodFromJson(json);

  /// True when [date] (date-only) falls within this period, bounds inclusive.
  bool includes(DateTime date) {
    final s = tryParseDateKey(startDate);
    final e = tryParseDateKey(endDate);
    if (s == null || e == null) return false;
    final d = DateTime(date.year, date.month, date.day);
    return !d.isBefore(s) && !d.isAfter(e);
  }
}

/// The set of away periods stored at publishers/{uid}/away/periods.
@freezed
abstract class PublisherAway with _$PublisherAway {
  const factory PublisherAway({
    @Default(<AwayPeriod>[]) List<AwayPeriod> periods,
  }) = _PublisherAway;

  factory PublisherAway.fromJson(Map<String, dynamic> json) =>
      _$PublisherAwayFromJson(json);
}
