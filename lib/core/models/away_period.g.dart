// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'away_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AwayPeriod _$AwayPeriodFromJson(Map<String, dynamic> json) => _AwayPeriod(
  startDate: json['startDate'] as String,
  endDate: json['endDate'] as String,
);

Map<String, dynamic> _$AwayPeriodToJson(_AwayPeriod instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };

_PublisherAway _$PublisherAwayFromJson(Map<String, dynamic> json) =>
    _PublisherAway(
      periods:
          (json['periods'] as List<dynamic>?)
              ?.map((e) => AwayPeriod.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AwayPeriod>[],
    );

Map<String, dynamic> _$PublisherAwayToJson(_PublisherAway instance) =>
    <String, dynamic>{
      'periods': instance.periods.map((e) => e.toJson()).toList(),
    };
