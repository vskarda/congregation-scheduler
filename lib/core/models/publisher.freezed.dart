// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'publisher.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Roles {

 bool get infoBoard; bool get events; bool get lmmSchedule; bool get weekendSchedule; bool get publicWitnessing; bool get fieldServiceMeetings; bool get territories; bool get reports; bool get attendance; bool get publishers; bool get fullAdmin;
/// Create a copy of Roles
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RolesCopyWith<Roles> get copyWith => _$RolesCopyWithImpl<Roles>(this as Roles, _$identity);

  /// Serializes this Roles to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Roles&&(identical(other.infoBoard, infoBoard) || other.infoBoard == infoBoard)&&(identical(other.events, events) || other.events == events)&&(identical(other.lmmSchedule, lmmSchedule) || other.lmmSchedule == lmmSchedule)&&(identical(other.weekendSchedule, weekendSchedule) || other.weekendSchedule == weekendSchedule)&&(identical(other.publicWitnessing, publicWitnessing) || other.publicWitnessing == publicWitnessing)&&(identical(other.fieldServiceMeetings, fieldServiceMeetings) || other.fieldServiceMeetings == fieldServiceMeetings)&&(identical(other.territories, territories) || other.territories == territories)&&(identical(other.reports, reports) || other.reports == reports)&&(identical(other.attendance, attendance) || other.attendance == attendance)&&(identical(other.publishers, publishers) || other.publishers == publishers)&&(identical(other.fullAdmin, fullAdmin) || other.fullAdmin == fullAdmin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,infoBoard,events,lmmSchedule,weekendSchedule,publicWitnessing,fieldServiceMeetings,territories,reports,attendance,publishers,fullAdmin);

@override
String toString() {
  return 'Roles(infoBoard: $infoBoard, events: $events, lmmSchedule: $lmmSchedule, weekendSchedule: $weekendSchedule, publicWitnessing: $publicWitnessing, fieldServiceMeetings: $fieldServiceMeetings, territories: $territories, reports: $reports, attendance: $attendance, publishers: $publishers, fullAdmin: $fullAdmin)';
}


}

/// @nodoc
abstract mixin class $RolesCopyWith<$Res>  {
  factory $RolesCopyWith(Roles value, $Res Function(Roles) _then) = _$RolesCopyWithImpl;
@useResult
$Res call({
 bool infoBoard, bool events, bool lmmSchedule, bool weekendSchedule, bool publicWitnessing, bool fieldServiceMeetings, bool territories, bool reports, bool attendance, bool publishers, bool fullAdmin
});




}
/// @nodoc
class _$RolesCopyWithImpl<$Res>
    implements $RolesCopyWith<$Res> {
  _$RolesCopyWithImpl(this._self, this._then);

  final Roles _self;
  final $Res Function(Roles) _then;

/// Create a copy of Roles
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? infoBoard = null,Object? events = null,Object? lmmSchedule = null,Object? weekendSchedule = null,Object? publicWitnessing = null,Object? fieldServiceMeetings = null,Object? territories = null,Object? reports = null,Object? attendance = null,Object? publishers = null,Object? fullAdmin = null,}) {
  return _then(_self.copyWith(
infoBoard: null == infoBoard ? _self.infoBoard : infoBoard // ignore: cast_nullable_to_non_nullable
as bool,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as bool,lmmSchedule: null == lmmSchedule ? _self.lmmSchedule : lmmSchedule // ignore: cast_nullable_to_non_nullable
as bool,weekendSchedule: null == weekendSchedule ? _self.weekendSchedule : weekendSchedule // ignore: cast_nullable_to_non_nullable
as bool,publicWitnessing: null == publicWitnessing ? _self.publicWitnessing : publicWitnessing // ignore: cast_nullable_to_non_nullable
as bool,fieldServiceMeetings: null == fieldServiceMeetings ? _self.fieldServiceMeetings : fieldServiceMeetings // ignore: cast_nullable_to_non_nullable
as bool,territories: null == territories ? _self.territories : territories // ignore: cast_nullable_to_non_nullable
as bool,reports: null == reports ? _self.reports : reports // ignore: cast_nullable_to_non_nullable
as bool,attendance: null == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as bool,publishers: null == publishers ? _self.publishers : publishers // ignore: cast_nullable_to_non_nullable
as bool,fullAdmin: null == fullAdmin ? _self.fullAdmin : fullAdmin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Roles].
extension RolesPatterns on Roles {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Roles value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Roles() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Roles value)  $default,){
final _that = this;
switch (_that) {
case _Roles():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Roles value)?  $default,){
final _that = this;
switch (_that) {
case _Roles() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool infoBoard,  bool events,  bool lmmSchedule,  bool weekendSchedule,  bool publicWitnessing,  bool fieldServiceMeetings,  bool territories,  bool reports,  bool attendance,  bool publishers,  bool fullAdmin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Roles() when $default != null:
return $default(_that.infoBoard,_that.events,_that.lmmSchedule,_that.weekendSchedule,_that.publicWitnessing,_that.fieldServiceMeetings,_that.territories,_that.reports,_that.attendance,_that.publishers,_that.fullAdmin);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool infoBoard,  bool events,  bool lmmSchedule,  bool weekendSchedule,  bool publicWitnessing,  bool fieldServiceMeetings,  bool territories,  bool reports,  bool attendance,  bool publishers,  bool fullAdmin)  $default,) {final _that = this;
switch (_that) {
case _Roles():
return $default(_that.infoBoard,_that.events,_that.lmmSchedule,_that.weekendSchedule,_that.publicWitnessing,_that.fieldServiceMeetings,_that.territories,_that.reports,_that.attendance,_that.publishers,_that.fullAdmin);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool infoBoard,  bool events,  bool lmmSchedule,  bool weekendSchedule,  bool publicWitnessing,  bool fieldServiceMeetings,  bool territories,  bool reports,  bool attendance,  bool publishers,  bool fullAdmin)?  $default,) {final _that = this;
switch (_that) {
case _Roles() when $default != null:
return $default(_that.infoBoard,_that.events,_that.lmmSchedule,_that.weekendSchedule,_that.publicWitnessing,_that.fieldServiceMeetings,_that.territories,_that.reports,_that.attendance,_that.publishers,_that.fullAdmin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Roles extends Roles {
  const _Roles({this.infoBoard = false, this.events = false, this.lmmSchedule = false, this.weekendSchedule = false, this.publicWitnessing = false, this.fieldServiceMeetings = false, this.territories = false, this.reports = false, this.attendance = false, this.publishers = false, this.fullAdmin = false}): super._();
  factory _Roles.fromJson(Map<String, dynamic> json) => _$RolesFromJson(json);

@override@JsonKey() final  bool infoBoard;
@override@JsonKey() final  bool events;
@override@JsonKey() final  bool lmmSchedule;
@override@JsonKey() final  bool weekendSchedule;
@override@JsonKey() final  bool publicWitnessing;
@override@JsonKey() final  bool fieldServiceMeetings;
@override@JsonKey() final  bool territories;
@override@JsonKey() final  bool reports;
@override@JsonKey() final  bool attendance;
@override@JsonKey() final  bool publishers;
@override@JsonKey() final  bool fullAdmin;

/// Create a copy of Roles
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RolesCopyWith<_Roles> get copyWith => __$RolesCopyWithImpl<_Roles>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RolesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Roles&&(identical(other.infoBoard, infoBoard) || other.infoBoard == infoBoard)&&(identical(other.events, events) || other.events == events)&&(identical(other.lmmSchedule, lmmSchedule) || other.lmmSchedule == lmmSchedule)&&(identical(other.weekendSchedule, weekendSchedule) || other.weekendSchedule == weekendSchedule)&&(identical(other.publicWitnessing, publicWitnessing) || other.publicWitnessing == publicWitnessing)&&(identical(other.fieldServiceMeetings, fieldServiceMeetings) || other.fieldServiceMeetings == fieldServiceMeetings)&&(identical(other.territories, territories) || other.territories == territories)&&(identical(other.reports, reports) || other.reports == reports)&&(identical(other.attendance, attendance) || other.attendance == attendance)&&(identical(other.publishers, publishers) || other.publishers == publishers)&&(identical(other.fullAdmin, fullAdmin) || other.fullAdmin == fullAdmin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,infoBoard,events,lmmSchedule,weekendSchedule,publicWitnessing,fieldServiceMeetings,territories,reports,attendance,publishers,fullAdmin);

@override
String toString() {
  return 'Roles(infoBoard: $infoBoard, events: $events, lmmSchedule: $lmmSchedule, weekendSchedule: $weekendSchedule, publicWitnessing: $publicWitnessing, fieldServiceMeetings: $fieldServiceMeetings, territories: $territories, reports: $reports, attendance: $attendance, publishers: $publishers, fullAdmin: $fullAdmin)';
}


}

/// @nodoc
abstract mixin class _$RolesCopyWith<$Res> implements $RolesCopyWith<$Res> {
  factory _$RolesCopyWith(_Roles value, $Res Function(_Roles) _then) = __$RolesCopyWithImpl;
@override @useResult
$Res call({
 bool infoBoard, bool events, bool lmmSchedule, bool weekendSchedule, bool publicWitnessing, bool fieldServiceMeetings, bool territories, bool reports, bool attendance, bool publishers, bool fullAdmin
});




}
/// @nodoc
class __$RolesCopyWithImpl<$Res>
    implements _$RolesCopyWith<$Res> {
  __$RolesCopyWithImpl(this._self, this._then);

  final _Roles _self;
  final $Res Function(_Roles) _then;

/// Create a copy of Roles
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? infoBoard = null,Object? events = null,Object? lmmSchedule = null,Object? weekendSchedule = null,Object? publicWitnessing = null,Object? fieldServiceMeetings = null,Object? territories = null,Object? reports = null,Object? attendance = null,Object? publishers = null,Object? fullAdmin = null,}) {
  return _then(_Roles(
infoBoard: null == infoBoard ? _self.infoBoard : infoBoard // ignore: cast_nullable_to_non_nullable
as bool,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as bool,lmmSchedule: null == lmmSchedule ? _self.lmmSchedule : lmmSchedule // ignore: cast_nullable_to_non_nullable
as bool,weekendSchedule: null == weekendSchedule ? _self.weekendSchedule : weekendSchedule // ignore: cast_nullable_to_non_nullable
as bool,publicWitnessing: null == publicWitnessing ? _self.publicWitnessing : publicWitnessing // ignore: cast_nullable_to_non_nullable
as bool,fieldServiceMeetings: null == fieldServiceMeetings ? _self.fieldServiceMeetings : fieldServiceMeetings // ignore: cast_nullable_to_non_nullable
as bool,territories: null == territories ? _self.territories : territories // ignore: cast_nullable_to_non_nullable
as bool,reports: null == reports ? _self.reports : reports // ignore: cast_nullable_to_non_nullable
as bool,attendance: null == attendance ? _self.attendance : attendance // ignore: cast_nullable_to_non_nullable
as bool,publishers: null == publishers ? _self.publishers : publishers // ignore: cast_nullable_to_non_nullable
as bool,fullAdmin: null == fullAdmin ? _self.fullAdmin : fullAdmin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Qualifications {

 bool get chairman; bool get prayer; bool get treasures; bool get gems; bool get bibleReading; bool get fieldMinistry; bool get livingParts; bool get cbsConductor; bool get cbsReader; bool get publicTalk; bool get weekendChairman; bool get wtReader; bool get attendant; bool get microphone; bool get audioVideo; bool get publicWitnessing; bool get ministryMeetingConductor;
/// Create a copy of Qualifications
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QualificationsCopyWith<Qualifications> get copyWith => _$QualificationsCopyWithImpl<Qualifications>(this as Qualifications, _$identity);

  /// Serializes this Qualifications to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Qualifications&&(identical(other.chairman, chairman) || other.chairman == chairman)&&(identical(other.prayer, prayer) || other.prayer == prayer)&&(identical(other.treasures, treasures) || other.treasures == treasures)&&(identical(other.gems, gems) || other.gems == gems)&&(identical(other.bibleReading, bibleReading) || other.bibleReading == bibleReading)&&(identical(other.fieldMinistry, fieldMinistry) || other.fieldMinistry == fieldMinistry)&&(identical(other.livingParts, livingParts) || other.livingParts == livingParts)&&(identical(other.cbsConductor, cbsConductor) || other.cbsConductor == cbsConductor)&&(identical(other.cbsReader, cbsReader) || other.cbsReader == cbsReader)&&(identical(other.publicTalk, publicTalk) || other.publicTalk == publicTalk)&&(identical(other.weekendChairman, weekendChairman) || other.weekendChairman == weekendChairman)&&(identical(other.wtReader, wtReader) || other.wtReader == wtReader)&&(identical(other.attendant, attendant) || other.attendant == attendant)&&(identical(other.microphone, microphone) || other.microphone == microphone)&&(identical(other.audioVideo, audioVideo) || other.audioVideo == audioVideo)&&(identical(other.publicWitnessing, publicWitnessing) || other.publicWitnessing == publicWitnessing)&&(identical(other.ministryMeetingConductor, ministryMeetingConductor) || other.ministryMeetingConductor == ministryMeetingConductor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chairman,prayer,treasures,gems,bibleReading,fieldMinistry,livingParts,cbsConductor,cbsReader,publicTalk,weekendChairman,wtReader,attendant,microphone,audioVideo,publicWitnessing,ministryMeetingConductor);

@override
String toString() {
  return 'Qualifications(chairman: $chairman, prayer: $prayer, treasures: $treasures, gems: $gems, bibleReading: $bibleReading, fieldMinistry: $fieldMinistry, livingParts: $livingParts, cbsConductor: $cbsConductor, cbsReader: $cbsReader, publicTalk: $publicTalk, weekendChairman: $weekendChairman, wtReader: $wtReader, attendant: $attendant, microphone: $microphone, audioVideo: $audioVideo, publicWitnessing: $publicWitnessing, ministryMeetingConductor: $ministryMeetingConductor)';
}


}

/// @nodoc
abstract mixin class $QualificationsCopyWith<$Res>  {
  factory $QualificationsCopyWith(Qualifications value, $Res Function(Qualifications) _then) = _$QualificationsCopyWithImpl;
@useResult
$Res call({
 bool chairman, bool prayer, bool treasures, bool gems, bool bibleReading, bool fieldMinistry, bool livingParts, bool cbsConductor, bool cbsReader, bool publicTalk, bool weekendChairman, bool wtReader, bool attendant, bool microphone, bool audioVideo, bool publicWitnessing, bool ministryMeetingConductor
});




}
/// @nodoc
class _$QualificationsCopyWithImpl<$Res>
    implements $QualificationsCopyWith<$Res> {
  _$QualificationsCopyWithImpl(this._self, this._then);

  final Qualifications _self;
  final $Res Function(Qualifications) _then;

/// Create a copy of Qualifications
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chairman = null,Object? prayer = null,Object? treasures = null,Object? gems = null,Object? bibleReading = null,Object? fieldMinistry = null,Object? livingParts = null,Object? cbsConductor = null,Object? cbsReader = null,Object? publicTalk = null,Object? weekendChairman = null,Object? wtReader = null,Object? attendant = null,Object? microphone = null,Object? audioVideo = null,Object? publicWitnessing = null,Object? ministryMeetingConductor = null,}) {
  return _then(_self.copyWith(
chairman: null == chairman ? _self.chairman : chairman // ignore: cast_nullable_to_non_nullable
as bool,prayer: null == prayer ? _self.prayer : prayer // ignore: cast_nullable_to_non_nullable
as bool,treasures: null == treasures ? _self.treasures : treasures // ignore: cast_nullable_to_non_nullable
as bool,gems: null == gems ? _self.gems : gems // ignore: cast_nullable_to_non_nullable
as bool,bibleReading: null == bibleReading ? _self.bibleReading : bibleReading // ignore: cast_nullable_to_non_nullable
as bool,fieldMinistry: null == fieldMinistry ? _self.fieldMinistry : fieldMinistry // ignore: cast_nullable_to_non_nullable
as bool,livingParts: null == livingParts ? _self.livingParts : livingParts // ignore: cast_nullable_to_non_nullable
as bool,cbsConductor: null == cbsConductor ? _self.cbsConductor : cbsConductor // ignore: cast_nullable_to_non_nullable
as bool,cbsReader: null == cbsReader ? _self.cbsReader : cbsReader // ignore: cast_nullable_to_non_nullable
as bool,publicTalk: null == publicTalk ? _self.publicTalk : publicTalk // ignore: cast_nullable_to_non_nullable
as bool,weekendChairman: null == weekendChairman ? _self.weekendChairman : weekendChairman // ignore: cast_nullable_to_non_nullable
as bool,wtReader: null == wtReader ? _self.wtReader : wtReader // ignore: cast_nullable_to_non_nullable
as bool,attendant: null == attendant ? _self.attendant : attendant // ignore: cast_nullable_to_non_nullable
as bool,microphone: null == microphone ? _self.microphone : microphone // ignore: cast_nullable_to_non_nullable
as bool,audioVideo: null == audioVideo ? _self.audioVideo : audioVideo // ignore: cast_nullable_to_non_nullable
as bool,publicWitnessing: null == publicWitnessing ? _self.publicWitnessing : publicWitnessing // ignore: cast_nullable_to_non_nullable
as bool,ministryMeetingConductor: null == ministryMeetingConductor ? _self.ministryMeetingConductor : ministryMeetingConductor // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Qualifications].
extension QualificationsPatterns on Qualifications {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Qualifications value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Qualifications() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Qualifications value)  $default,){
final _that = this;
switch (_that) {
case _Qualifications():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Qualifications value)?  $default,){
final _that = this;
switch (_that) {
case _Qualifications() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool chairman,  bool prayer,  bool treasures,  bool gems,  bool bibleReading,  bool fieldMinistry,  bool livingParts,  bool cbsConductor,  bool cbsReader,  bool publicTalk,  bool weekendChairman,  bool wtReader,  bool attendant,  bool microphone,  bool audioVideo,  bool publicWitnessing,  bool ministryMeetingConductor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Qualifications() when $default != null:
return $default(_that.chairman,_that.prayer,_that.treasures,_that.gems,_that.bibleReading,_that.fieldMinistry,_that.livingParts,_that.cbsConductor,_that.cbsReader,_that.publicTalk,_that.weekendChairman,_that.wtReader,_that.attendant,_that.microphone,_that.audioVideo,_that.publicWitnessing,_that.ministryMeetingConductor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool chairman,  bool prayer,  bool treasures,  bool gems,  bool bibleReading,  bool fieldMinistry,  bool livingParts,  bool cbsConductor,  bool cbsReader,  bool publicTalk,  bool weekendChairman,  bool wtReader,  bool attendant,  bool microphone,  bool audioVideo,  bool publicWitnessing,  bool ministryMeetingConductor)  $default,) {final _that = this;
switch (_that) {
case _Qualifications():
return $default(_that.chairman,_that.prayer,_that.treasures,_that.gems,_that.bibleReading,_that.fieldMinistry,_that.livingParts,_that.cbsConductor,_that.cbsReader,_that.publicTalk,_that.weekendChairman,_that.wtReader,_that.attendant,_that.microphone,_that.audioVideo,_that.publicWitnessing,_that.ministryMeetingConductor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool chairman,  bool prayer,  bool treasures,  bool gems,  bool bibleReading,  bool fieldMinistry,  bool livingParts,  bool cbsConductor,  bool cbsReader,  bool publicTalk,  bool weekendChairman,  bool wtReader,  bool attendant,  bool microphone,  bool audioVideo,  bool publicWitnessing,  bool ministryMeetingConductor)?  $default,) {final _that = this;
switch (_that) {
case _Qualifications() when $default != null:
return $default(_that.chairman,_that.prayer,_that.treasures,_that.gems,_that.bibleReading,_that.fieldMinistry,_that.livingParts,_that.cbsConductor,_that.cbsReader,_that.publicTalk,_that.weekendChairman,_that.wtReader,_that.attendant,_that.microphone,_that.audioVideo,_that.publicWitnessing,_that.ministryMeetingConductor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Qualifications extends Qualifications {
  const _Qualifications({this.chairman = false, this.prayer = false, this.treasures = false, this.gems = false, this.bibleReading = false, this.fieldMinistry = false, this.livingParts = false, this.cbsConductor = false, this.cbsReader = false, this.publicTalk = false, this.weekendChairman = false, this.wtReader = false, this.attendant = false, this.microphone = false, this.audioVideo = false, this.publicWitnessing = false, this.ministryMeetingConductor = false}): super._();
  factory _Qualifications.fromJson(Map<String, dynamic> json) => _$QualificationsFromJson(json);

@override@JsonKey() final  bool chairman;
@override@JsonKey() final  bool prayer;
@override@JsonKey() final  bool treasures;
@override@JsonKey() final  bool gems;
@override@JsonKey() final  bool bibleReading;
@override@JsonKey() final  bool fieldMinistry;
@override@JsonKey() final  bool livingParts;
@override@JsonKey() final  bool cbsConductor;
@override@JsonKey() final  bool cbsReader;
@override@JsonKey() final  bool publicTalk;
@override@JsonKey() final  bool weekendChairman;
@override@JsonKey() final  bool wtReader;
@override@JsonKey() final  bool attendant;
@override@JsonKey() final  bool microphone;
@override@JsonKey() final  bool audioVideo;
@override@JsonKey() final  bool publicWitnessing;
@override@JsonKey() final  bool ministryMeetingConductor;

/// Create a copy of Qualifications
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QualificationsCopyWith<_Qualifications> get copyWith => __$QualificationsCopyWithImpl<_Qualifications>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QualificationsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Qualifications&&(identical(other.chairman, chairman) || other.chairman == chairman)&&(identical(other.prayer, prayer) || other.prayer == prayer)&&(identical(other.treasures, treasures) || other.treasures == treasures)&&(identical(other.gems, gems) || other.gems == gems)&&(identical(other.bibleReading, bibleReading) || other.bibleReading == bibleReading)&&(identical(other.fieldMinistry, fieldMinistry) || other.fieldMinistry == fieldMinistry)&&(identical(other.livingParts, livingParts) || other.livingParts == livingParts)&&(identical(other.cbsConductor, cbsConductor) || other.cbsConductor == cbsConductor)&&(identical(other.cbsReader, cbsReader) || other.cbsReader == cbsReader)&&(identical(other.publicTalk, publicTalk) || other.publicTalk == publicTalk)&&(identical(other.weekendChairman, weekendChairman) || other.weekendChairman == weekendChairman)&&(identical(other.wtReader, wtReader) || other.wtReader == wtReader)&&(identical(other.attendant, attendant) || other.attendant == attendant)&&(identical(other.microphone, microphone) || other.microphone == microphone)&&(identical(other.audioVideo, audioVideo) || other.audioVideo == audioVideo)&&(identical(other.publicWitnessing, publicWitnessing) || other.publicWitnessing == publicWitnessing)&&(identical(other.ministryMeetingConductor, ministryMeetingConductor) || other.ministryMeetingConductor == ministryMeetingConductor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chairman,prayer,treasures,gems,bibleReading,fieldMinistry,livingParts,cbsConductor,cbsReader,publicTalk,weekendChairman,wtReader,attendant,microphone,audioVideo,publicWitnessing,ministryMeetingConductor);

@override
String toString() {
  return 'Qualifications(chairman: $chairman, prayer: $prayer, treasures: $treasures, gems: $gems, bibleReading: $bibleReading, fieldMinistry: $fieldMinistry, livingParts: $livingParts, cbsConductor: $cbsConductor, cbsReader: $cbsReader, publicTalk: $publicTalk, weekendChairman: $weekendChairman, wtReader: $wtReader, attendant: $attendant, microphone: $microphone, audioVideo: $audioVideo, publicWitnessing: $publicWitnessing, ministryMeetingConductor: $ministryMeetingConductor)';
}


}

/// @nodoc
abstract mixin class _$QualificationsCopyWith<$Res> implements $QualificationsCopyWith<$Res> {
  factory _$QualificationsCopyWith(_Qualifications value, $Res Function(_Qualifications) _then) = __$QualificationsCopyWithImpl;
@override @useResult
$Res call({
 bool chairman, bool prayer, bool treasures, bool gems, bool bibleReading, bool fieldMinistry, bool livingParts, bool cbsConductor, bool cbsReader, bool publicTalk, bool weekendChairman, bool wtReader, bool attendant, bool microphone, bool audioVideo, bool publicWitnessing, bool ministryMeetingConductor
});




}
/// @nodoc
class __$QualificationsCopyWithImpl<$Res>
    implements _$QualificationsCopyWith<$Res> {
  __$QualificationsCopyWithImpl(this._self, this._then);

  final _Qualifications _self;
  final $Res Function(_Qualifications) _then;

/// Create a copy of Qualifications
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chairman = null,Object? prayer = null,Object? treasures = null,Object? gems = null,Object? bibleReading = null,Object? fieldMinistry = null,Object? livingParts = null,Object? cbsConductor = null,Object? cbsReader = null,Object? publicTalk = null,Object? weekendChairman = null,Object? wtReader = null,Object? attendant = null,Object? microphone = null,Object? audioVideo = null,Object? publicWitnessing = null,Object? ministryMeetingConductor = null,}) {
  return _then(_Qualifications(
chairman: null == chairman ? _self.chairman : chairman // ignore: cast_nullable_to_non_nullable
as bool,prayer: null == prayer ? _self.prayer : prayer // ignore: cast_nullable_to_non_nullable
as bool,treasures: null == treasures ? _self.treasures : treasures // ignore: cast_nullable_to_non_nullable
as bool,gems: null == gems ? _self.gems : gems // ignore: cast_nullable_to_non_nullable
as bool,bibleReading: null == bibleReading ? _self.bibleReading : bibleReading // ignore: cast_nullable_to_non_nullable
as bool,fieldMinistry: null == fieldMinistry ? _self.fieldMinistry : fieldMinistry // ignore: cast_nullable_to_non_nullable
as bool,livingParts: null == livingParts ? _self.livingParts : livingParts // ignore: cast_nullable_to_non_nullable
as bool,cbsConductor: null == cbsConductor ? _self.cbsConductor : cbsConductor // ignore: cast_nullable_to_non_nullable
as bool,cbsReader: null == cbsReader ? _self.cbsReader : cbsReader // ignore: cast_nullable_to_non_nullable
as bool,publicTalk: null == publicTalk ? _self.publicTalk : publicTalk // ignore: cast_nullable_to_non_nullable
as bool,weekendChairman: null == weekendChairman ? _self.weekendChairman : weekendChairman // ignore: cast_nullable_to_non_nullable
as bool,wtReader: null == wtReader ? _self.wtReader : wtReader // ignore: cast_nullable_to_non_nullable
as bool,attendant: null == attendant ? _self.attendant : attendant // ignore: cast_nullable_to_non_nullable
as bool,microphone: null == microphone ? _self.microphone : microphone // ignore: cast_nullable_to_non_nullable
as bool,audioVideo: null == audioVideo ? _self.audioVideo : audioVideo // ignore: cast_nullable_to_non_nullable
as bool,publicWitnessing: null == publicWitnessing ? _self.publicWitnessing : publicWitnessing // ignore: cast_nullable_to_non_nullable
as bool,ministryMeetingConductor: null == ministryMeetingConductor ? _self.ministryMeetingConductor : ministryMeetingConductor // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Publisher {

/// Firestore document id (= auth uid for publishers with accounts).
@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get firstName; String get lastName; Gender get gender; PublisherStatus get status;/// Elder / ministerial-servant appointment, denormalized from the private
/// profile ([PublisherPrivate.appointment]) so the admin roster can filter
/// and badge by it without loading every private doc. Admin-set only
/// (firestore.rules blocks self-edits, same as [status] 'none').
 Appointment get appointment; bool get verified; Roles get roles; Qualifications get qualifications;/// False for records an admin created for members without a login.
 bool get hasAccount;/// Archived because the publisher moved to another congregation. The
/// record (and their S-21 history) is kept, but access is revoked
/// (marking moved also clears [verified]) and they drop out of schedule
/// pickers and report rosters. Distinct from an unverified/awaiting user.
 bool get moved;/// Ministry group membership (ministry_groups doc id); null = no group.
/// Admin-assigned only — firestore.rules blocks self-edits of this key.
/// includeIfNull keeps the key absent from toJson() so full-doc
/// self-saves by ungrouped publishers don't trip the affectedKeys rule.
@JsonKey(includeIfNull: false) String? get groupId;
/// Create a copy of Publisher
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublisherCopyWith<Publisher> get copyWith => _$PublisherCopyWithImpl<Publisher>(this as Publisher, _$identity);

  /// Serializes this Publisher to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Publisher&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.status, status) || other.status == status)&&(identical(other.appointment, appointment) || other.appointment == appointment)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.roles, roles) || other.roles == roles)&&(identical(other.qualifications, qualifications) || other.qualifications == qualifications)&&(identical(other.hasAccount, hasAccount) || other.hasAccount == hasAccount)&&(identical(other.moved, moved) || other.moved == moved)&&(identical(other.groupId, groupId) || other.groupId == groupId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,gender,status,appointment,verified,roles,qualifications,hasAccount,moved,groupId);

@override
String toString() {
  return 'Publisher(id: $id, firstName: $firstName, lastName: $lastName, gender: $gender, status: $status, appointment: $appointment, verified: $verified, roles: $roles, qualifications: $qualifications, hasAccount: $hasAccount, moved: $moved, groupId: $groupId)';
}


}

/// @nodoc
abstract mixin class $PublisherCopyWith<$Res>  {
  factory $PublisherCopyWith(Publisher value, $Res Function(Publisher) _then) = _$PublisherCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String firstName, String lastName, Gender gender, PublisherStatus status, Appointment appointment, bool verified, Roles roles, Qualifications qualifications, bool hasAccount, bool moved,@JsonKey(includeIfNull: false) String? groupId
});


$RolesCopyWith<$Res> get roles;$QualificationsCopyWith<$Res> get qualifications;

}
/// @nodoc
class _$PublisherCopyWithImpl<$Res>
    implements $PublisherCopyWith<$Res> {
  _$PublisherCopyWithImpl(this._self, this._then);

  final Publisher _self;
  final $Res Function(Publisher) _then;

/// Create a copy of Publisher
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? gender = null,Object? status = null,Object? appointment = null,Object? verified = null,Object? roles = null,Object? qualifications = null,Object? hasAccount = null,Object? moved = null,Object? groupId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PublisherStatus,appointment: null == appointment ? _self.appointment : appointment // ignore: cast_nullable_to_non_nullable
as Appointment,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as Roles,qualifications: null == qualifications ? _self.qualifications : qualifications // ignore: cast_nullable_to_non_nullable
as Qualifications,hasAccount: null == hasAccount ? _self.hasAccount : hasAccount // ignore: cast_nullable_to_non_nullable
as bool,moved: null == moved ? _self.moved : moved // ignore: cast_nullable_to_non_nullable
as bool,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Publisher
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RolesCopyWith<$Res> get roles {
  
  return $RolesCopyWith<$Res>(_self.roles, (value) {
    return _then(_self.copyWith(roles: value));
  });
}/// Create a copy of Publisher
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QualificationsCopyWith<$Res> get qualifications {
  
  return $QualificationsCopyWith<$Res>(_self.qualifications, (value) {
    return _then(_self.copyWith(qualifications: value));
  });
}
}


/// Adds pattern-matching-related methods to [Publisher].
extension PublisherPatterns on Publisher {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Publisher value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Publisher() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Publisher value)  $default,){
final _that = this;
switch (_that) {
case _Publisher():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Publisher value)?  $default,){
final _that = this;
switch (_that) {
case _Publisher() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String firstName,  String lastName,  Gender gender,  PublisherStatus status,  Appointment appointment,  bool verified,  Roles roles,  Qualifications qualifications,  bool hasAccount,  bool moved, @JsonKey(includeIfNull: false)  String? groupId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Publisher() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.gender,_that.status,_that.appointment,_that.verified,_that.roles,_that.qualifications,_that.hasAccount,_that.moved,_that.groupId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String firstName,  String lastName,  Gender gender,  PublisherStatus status,  Appointment appointment,  bool verified,  Roles roles,  Qualifications qualifications,  bool hasAccount,  bool moved, @JsonKey(includeIfNull: false)  String? groupId)  $default,) {final _that = this;
switch (_that) {
case _Publisher():
return $default(_that.id,_that.firstName,_that.lastName,_that.gender,_that.status,_that.appointment,_that.verified,_that.roles,_that.qualifications,_that.hasAccount,_that.moved,_that.groupId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String firstName,  String lastName,  Gender gender,  PublisherStatus status,  Appointment appointment,  bool verified,  Roles roles,  Qualifications qualifications,  bool hasAccount,  bool moved, @JsonKey(includeIfNull: false)  String? groupId)?  $default,) {final _that = this;
switch (_that) {
case _Publisher() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.gender,_that.status,_that.appointment,_that.verified,_that.roles,_that.qualifications,_that.hasAccount,_that.moved,_that.groupId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Publisher extends Publisher {
  const _Publisher({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.firstName = '', this.lastName = '', this.gender = Gender.unknown, this.status = PublisherStatus.publisher, this.appointment = Appointment.none, this.verified = false, this.roles = const Roles(), this.qualifications = const Qualifications(), this.hasAccount = false, this.moved = false, @JsonKey(includeIfNull: false) this.groupId}): super._();
  factory _Publisher.fromJson(Map<String, dynamic> json) => _$PublisherFromJson(json);

/// Firestore document id (= auth uid for publishers with accounts).
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  String firstName;
@override@JsonKey() final  String lastName;
@override@JsonKey() final  Gender gender;
@override@JsonKey() final  PublisherStatus status;
/// Elder / ministerial-servant appointment, denormalized from the private
/// profile ([PublisherPrivate.appointment]) so the admin roster can filter
/// and badge by it without loading every private doc. Admin-set only
/// (firestore.rules blocks self-edits, same as [status] 'none').
@override@JsonKey() final  Appointment appointment;
@override@JsonKey() final  bool verified;
@override@JsonKey() final  Roles roles;
@override@JsonKey() final  Qualifications qualifications;
/// False for records an admin created for members without a login.
@override@JsonKey() final  bool hasAccount;
/// Archived because the publisher moved to another congregation. The
/// record (and their S-21 history) is kept, but access is revoked
/// (marking moved also clears [verified]) and they drop out of schedule
/// pickers and report rosters. Distinct from an unverified/awaiting user.
@override@JsonKey() final  bool moved;
/// Ministry group membership (ministry_groups doc id); null = no group.
/// Admin-assigned only — firestore.rules blocks self-edits of this key.
/// includeIfNull keeps the key absent from toJson() so full-doc
/// self-saves by ungrouped publishers don't trip the affectedKeys rule.
@override@JsonKey(includeIfNull: false) final  String? groupId;

/// Create a copy of Publisher
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublisherCopyWith<_Publisher> get copyWith => __$PublisherCopyWithImpl<_Publisher>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublisherToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Publisher&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.status, status) || other.status == status)&&(identical(other.appointment, appointment) || other.appointment == appointment)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.roles, roles) || other.roles == roles)&&(identical(other.qualifications, qualifications) || other.qualifications == qualifications)&&(identical(other.hasAccount, hasAccount) || other.hasAccount == hasAccount)&&(identical(other.moved, moved) || other.moved == moved)&&(identical(other.groupId, groupId) || other.groupId == groupId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,gender,status,appointment,verified,roles,qualifications,hasAccount,moved,groupId);

@override
String toString() {
  return 'Publisher(id: $id, firstName: $firstName, lastName: $lastName, gender: $gender, status: $status, appointment: $appointment, verified: $verified, roles: $roles, qualifications: $qualifications, hasAccount: $hasAccount, moved: $moved, groupId: $groupId)';
}


}

/// @nodoc
abstract mixin class _$PublisherCopyWith<$Res> implements $PublisherCopyWith<$Res> {
  factory _$PublisherCopyWith(_Publisher value, $Res Function(_Publisher) _then) = __$PublisherCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String firstName, String lastName, Gender gender, PublisherStatus status, Appointment appointment, bool verified, Roles roles, Qualifications qualifications, bool hasAccount, bool moved,@JsonKey(includeIfNull: false) String? groupId
});


@override $RolesCopyWith<$Res> get roles;@override $QualificationsCopyWith<$Res> get qualifications;

}
/// @nodoc
class __$PublisherCopyWithImpl<$Res>
    implements _$PublisherCopyWith<$Res> {
  __$PublisherCopyWithImpl(this._self, this._then);

  final _Publisher _self;
  final $Res Function(_Publisher) _then;

/// Create a copy of Publisher
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? gender = null,Object? status = null,Object? appointment = null,Object? verified = null,Object? roles = null,Object? qualifications = null,Object? hasAccount = null,Object? moved = null,Object? groupId = freezed,}) {
  return _then(_Publisher(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PublisherStatus,appointment: null == appointment ? _self.appointment : appointment // ignore: cast_nullable_to_non_nullable
as Appointment,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as Roles,qualifications: null == qualifications ? _self.qualifications : qualifications // ignore: cast_nullable_to_non_nullable
as Qualifications,hasAccount: null == hasAccount ? _self.hasAccount : hasAccount // ignore: cast_nullable_to_non_nullable
as bool,moved: null == moved ? _self.moved : moved // ignore: cast_nullable_to_non_nullable
as bool,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Publisher
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RolesCopyWith<$Res> get roles {
  
  return $RolesCopyWith<$Res>(_self.roles, (value) {
    return _then(_self.copyWith(roles: value));
  });
}/// Create a copy of Publisher
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QualificationsCopyWith<$Res> get qualifications {
  
  return $QualificationsCopyWith<$Res>(_self.qualifications, (value) {
    return _then(_self.copyWith(qualifications: value));
  });
}
}


/// @nodoc
mixin _$PublisherPrivate {

 String get email; String get phone; String get address;/// yyyy-MM-dd
 String get birthDate;/// yyyy-MM-dd
 String get baptismDate; Hope get hope;/// Set by publisher-admins only (enforced in firestore.rules).
 Appointment get appointment; String get emergencyNote;
/// Create a copy of PublisherPrivate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublisherPrivateCopyWith<PublisherPrivate> get copyWith => _$PublisherPrivateCopyWithImpl<PublisherPrivate>(this as PublisherPrivate, _$identity);

  /// Serializes this PublisherPrivate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublisherPrivate&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.baptismDate, baptismDate) || other.baptismDate == baptismDate)&&(identical(other.hope, hope) || other.hope == hope)&&(identical(other.appointment, appointment) || other.appointment == appointment)&&(identical(other.emergencyNote, emergencyNote) || other.emergencyNote == emergencyNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,phone,address,birthDate,baptismDate,hope,appointment,emergencyNote);

@override
String toString() {
  return 'PublisherPrivate(email: $email, phone: $phone, address: $address, birthDate: $birthDate, baptismDate: $baptismDate, hope: $hope, appointment: $appointment, emergencyNote: $emergencyNote)';
}


}

/// @nodoc
abstract mixin class $PublisherPrivateCopyWith<$Res>  {
  factory $PublisherPrivateCopyWith(PublisherPrivate value, $Res Function(PublisherPrivate) _then) = _$PublisherPrivateCopyWithImpl;
@useResult
$Res call({
 String email, String phone, String address, String birthDate, String baptismDate, Hope hope, Appointment appointment, String emergencyNote
});




}
/// @nodoc
class _$PublisherPrivateCopyWithImpl<$Res>
    implements $PublisherPrivateCopyWith<$Res> {
  _$PublisherPrivateCopyWithImpl(this._self, this._then);

  final PublisherPrivate _self;
  final $Res Function(PublisherPrivate) _then;

/// Create a copy of PublisherPrivate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? phone = null,Object? address = null,Object? birthDate = null,Object? baptismDate = null,Object? hope = null,Object? appointment = null,Object? emergencyNote = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String,baptismDate: null == baptismDate ? _self.baptismDate : baptismDate // ignore: cast_nullable_to_non_nullable
as String,hope: null == hope ? _self.hope : hope // ignore: cast_nullable_to_non_nullable
as Hope,appointment: null == appointment ? _self.appointment : appointment // ignore: cast_nullable_to_non_nullable
as Appointment,emergencyNote: null == emergencyNote ? _self.emergencyNote : emergencyNote // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PublisherPrivate].
extension PublisherPrivatePatterns on PublisherPrivate {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublisherPrivate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublisherPrivate() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublisherPrivate value)  $default,){
final _that = this;
switch (_that) {
case _PublisherPrivate():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublisherPrivate value)?  $default,){
final _that = this;
switch (_that) {
case _PublisherPrivate() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String phone,  String address,  String birthDate,  String baptismDate,  Hope hope,  Appointment appointment,  String emergencyNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublisherPrivate() when $default != null:
return $default(_that.email,_that.phone,_that.address,_that.birthDate,_that.baptismDate,_that.hope,_that.appointment,_that.emergencyNote);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String phone,  String address,  String birthDate,  String baptismDate,  Hope hope,  Appointment appointment,  String emergencyNote)  $default,) {final _that = this;
switch (_that) {
case _PublisherPrivate():
return $default(_that.email,_that.phone,_that.address,_that.birthDate,_that.baptismDate,_that.hope,_that.appointment,_that.emergencyNote);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String phone,  String address,  String birthDate,  String baptismDate,  Hope hope,  Appointment appointment,  String emergencyNote)?  $default,) {final _that = this;
switch (_that) {
case _PublisherPrivate() when $default != null:
return $default(_that.email,_that.phone,_that.address,_that.birthDate,_that.baptismDate,_that.hope,_that.appointment,_that.emergencyNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublisherPrivate implements PublisherPrivate {
  const _PublisherPrivate({this.email = '', this.phone = '', this.address = '', this.birthDate = '', this.baptismDate = '', this.hope = Hope.otherSheep, this.appointment = Appointment.none, this.emergencyNote = ''});
  factory _PublisherPrivate.fromJson(Map<String, dynamic> json) => _$PublisherPrivateFromJson(json);

@override@JsonKey() final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String address;
/// yyyy-MM-dd
@override@JsonKey() final  String birthDate;
/// yyyy-MM-dd
@override@JsonKey() final  String baptismDate;
@override@JsonKey() final  Hope hope;
/// Set by publisher-admins only (enforced in firestore.rules).
@override@JsonKey() final  Appointment appointment;
@override@JsonKey() final  String emergencyNote;

/// Create a copy of PublisherPrivate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublisherPrivateCopyWith<_PublisherPrivate> get copyWith => __$PublisherPrivateCopyWithImpl<_PublisherPrivate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublisherPrivateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublisherPrivate&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.baptismDate, baptismDate) || other.baptismDate == baptismDate)&&(identical(other.hope, hope) || other.hope == hope)&&(identical(other.appointment, appointment) || other.appointment == appointment)&&(identical(other.emergencyNote, emergencyNote) || other.emergencyNote == emergencyNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,phone,address,birthDate,baptismDate,hope,appointment,emergencyNote);

@override
String toString() {
  return 'PublisherPrivate(email: $email, phone: $phone, address: $address, birthDate: $birthDate, baptismDate: $baptismDate, hope: $hope, appointment: $appointment, emergencyNote: $emergencyNote)';
}


}

/// @nodoc
abstract mixin class _$PublisherPrivateCopyWith<$Res> implements $PublisherPrivateCopyWith<$Res> {
  factory _$PublisherPrivateCopyWith(_PublisherPrivate value, $Res Function(_PublisherPrivate) _then) = __$PublisherPrivateCopyWithImpl;
@override @useResult
$Res call({
 String email, String phone, String address, String birthDate, String baptismDate, Hope hope, Appointment appointment, String emergencyNote
});




}
/// @nodoc
class __$PublisherPrivateCopyWithImpl<$Res>
    implements _$PublisherPrivateCopyWith<$Res> {
  __$PublisherPrivateCopyWithImpl(this._self, this._then);

  final _PublisherPrivate _self;
  final $Res Function(_PublisherPrivate) _then;

/// Create a copy of PublisherPrivate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? phone = null,Object? address = null,Object? birthDate = null,Object? baptismDate = null,Object? hope = null,Object? appointment = null,Object? emergencyNote = null,}) {
  return _then(_PublisherPrivate(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String,baptismDate: null == baptismDate ? _self.baptismDate : baptismDate // ignore: cast_nullable_to_non_nullable
as String,hope: null == hope ? _self.hope : hope // ignore: cast_nullable_to_non_nullable
as Hope,appointment: null == appointment ? _self.appointment : appointment // ignore: cast_nullable_to_non_nullable
as Appointment,emergencyNote: null == emergencyNote ? _self.emergencyNote : emergencyNote // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
