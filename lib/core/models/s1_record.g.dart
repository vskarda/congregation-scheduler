// GENERATED CODE - DO NOT MODIFY BY HAND

part of 's1_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_S1Group _$S1GroupFromJson(Map<String, dynamic> json) => _S1Group(
  count: (json['count'] as num?)?.toInt() ?? 0,
  studies: (json['studies'] as num?)?.toInt() ?? 0,
  hours: (json['hours'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$S1GroupToJson(_S1Group instance) => <String, dynamic>{
  'count': instance.count,
  'studies': instance.studies,
  'hours': instance.hours,
};

_S1Record _$S1RecordFromJson(Map<String, dynamic> json) => _S1Record(
  month: json['month'] as String? ?? '',
  activePublishers: (json['activePublishers'] as num?)?.toInt() ?? 0,
  avgMidweekAttendance: (json['avgMidweekAttendance'] as num?)?.toInt(),
  avgWeekendAttendance: (json['avgWeekendAttendance'] as num?)?.toInt(),
  publishers: json['publishers'] == null
      ? const S1Group()
      : S1Group.fromJson(json['publishers'] as Map<String, dynamic>),
  auxiliaryPioneers: json['auxiliaryPioneers'] == null
      ? const S1Group()
      : S1Group.fromJson(json['auxiliaryPioneers'] as Map<String, dynamic>),
  regularPioneers: json['regularPioneers'] == null
      ? const S1Group()
      : S1Group.fromJson(json['regularPioneers'] as Map<String, dynamic>),
  frozenAt: const NullableTimestampConverter().fromJson(json['frozenAt']),
  frozenBy: json['frozenBy'] as String? ?? '',
  auto: json['auto'] as bool? ?? false,
);

Map<String, dynamic> _$S1RecordToJson(_S1Record instance) => <String, dynamic>{
  'month': instance.month,
  'activePublishers': instance.activePublishers,
  'avgMidweekAttendance': instance.avgMidweekAttendance,
  'avgWeekendAttendance': instance.avgWeekendAttendance,
  'publishers': instance.publishers.toJson(),
  'auxiliaryPioneers': instance.auxiliaryPioneers.toJson(),
  'regularPioneers': instance.regularPioneers.toJson(),
  'frozenAt': const NullableTimestampConverter().toJson(instance.frozenAt),
  'frozenBy': instance.frozenBy,
  'auto': instance.auto,
};
