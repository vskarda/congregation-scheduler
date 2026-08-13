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
  @JsonValue('none')
  none,
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

/// Kinds of arrangement made for a circuit overseer's visit. Each is a
/// section of the visit view that can be shown or hidden on its own.
///
/// [ministry] stores nothing of its own: it renders the week's meetings for
/// field service (`fsm_meetings`), so both views edit the same documents. It
/// is part of the enum so it can be hidden and printed like the rest.
enum CoVisitSection {
  @JsonValue('ministry')
  ministry,
  @JsonValue('meal')
  meal,
  @JsonValue('shepherding')
  shepherding,
  @JsonValue('pioneers')
  pioneers,
  @JsonValue('elders')
  elders,
  @JsonValue('other')
  other,
}

/// The four schedules whose weeks can be shown to publishers with or without
/// the names assigned in them. Each owns one `schedule_config` document and
/// one editing role; see `ScheduleConfig.hiddenWeeks`.
enum ScheduleKind { lmm, weekend, pw, fsm }

enum InfoItemType {
  @JsonValue('text')
  text,
  @JsonValue('file')
  file,
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
