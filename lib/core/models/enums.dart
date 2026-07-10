import 'package:json_annotation/json_annotation.dart';

enum Gender {
  @JsonValue('unknown')
  unknown,
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
}

enum PublisherStatus {
  @JsonValue('publisher')
  publisher,
  @JsonValue('auxPioneer')
  auxiliaryPioneer,
  @JsonValue('regPioneer')
  regularPioneer,
  @JsonValue('specialPioneer')
  specialPioneer,
  @JsonValue('fieldMissionary')
  fieldMissionary,
}

enum Hope {
  @JsonValue('otherSheep')
  otherSheep,
  @JsonValue('anointed')
  anointed,
}

enum Appointment {
  @JsonValue('none')
  none,
  @JsonValue('ministerialServant')
  ministerialServant,
  @JsonValue('elder')
  elder,
}

enum EventType {
  @JsonValue('convention')
  convention,
  @JsonValue('assembly')
  assembly,
  @JsonValue('memorial')
  memorial,
  @JsonValue('coVisit')
  coVisit,
  @JsonValue('other')
  other,
}

enum InfoItemType {
  @JsonValue('text')
  text,
  @JsonValue('file')
  file,
  @JsonValue('link')
  link,
}

enum MeetingType {
  @JsonValue('lmm')
  lmm,
  @JsonValue('weekend')
  weekend,
}

enum LmmSection {
  @JsonValue('opening')
  opening,
  @JsonValue('treasures')
  treasures,
  @JsonValue('ministry')
  ministry,
  @JsonValue('living')
  living,
  @JsonValue('closing')
  closing,
}

enum LmmPartType {
  @JsonValue('chairman')
  chairman,
  @JsonValue('prayer')
  prayer,
  @JsonValue('treasures')
  treasures,
  @JsonValue('gems')
  gems,
  @JsonValue('bibleReading')
  bibleReading,
  @JsonValue('fieldMinistry')
  fieldMinistry,
  @JsonValue('living')
  living,
  @JsonValue('cbsConductor')
  cbsConductor,
  @JsonValue('cbsReader')
  cbsReader,
  @JsonValue('custom')
  custom,
}
