// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MinistryReport _$MinistryReportFromJson(
  Map<String, dynamic> json,
) => _MinistryReport(
  month: json['month'] as String? ?? '',
  participated: json['participated'] as bool? ?? false,
  bibleStudies: (json['bibleStudies'] as num?)?.toInt(),
  hours: (json['hours'] as num?)?.toInt(),
  creditHours: (json['creditHours'] as num?)?.toInt(),
  comments: json['comments'] as String? ?? '',
  statusAtMonth:
      $enumDecodeNullable(_$PublisherStatusEnumMap, json['statusAtMonth']) ??
      PublisherStatus.publisher,
  submittedAt: const NullableTimestampConverter().fromJson(json['submittedAt']),
  enteredBy: json['enteredBy'] as String? ?? 'self',
);

Map<String, dynamic> _$MinistryReportToJson(_MinistryReport instance) =>
    <String, dynamic>{
      'month': instance.month,
      'participated': instance.participated,
      'bibleStudies': instance.bibleStudies,
      'hours': instance.hours,
      'creditHours': instance.creditHours,
      'comments': instance.comments,
      'statusAtMonth': _$PublisherStatusEnumMap[instance.statusAtMonth]!,
      'submittedAt': const NullableTimestampConverter().toJson(
        instance.submittedAt,
      ),
      'enteredBy': instance.enteredBy,
    };

const _$PublisherStatusEnumMap = {
  PublisherStatus.publisher: 'publisher',
  PublisherStatus.auxiliaryPioneer: 'auxPioneer',
  PublisherStatus.regularPioneer: 'regPioneer',
  PublisherStatus.specialPioneer: 'specialPioneer',
};
