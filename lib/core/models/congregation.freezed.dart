// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'congregation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CongregationMeta {

 String get name; String get founderUid;/// DateTime.monday..DateTime.sunday (1..7)
 int get lmmWeekday;/// "HH:mm"
 String get lmmTime;/// Midweek meeting classes (1 = main hall only, 2-3 add auxiliary
/// classes with their own student assignments).
 int get lmmClassCount; int get weekendWeekday; String get weekendTime;/// One-time marker: elder/MS appointments have been copied from each
/// private profile onto the public publisher doc. Set by the client
/// backfill (full admin only) so it runs at most once per congregation.
 bool get appointmentBackfilled;
/// Create a copy of CongregationMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CongregationMetaCopyWith<CongregationMeta> get copyWith => _$CongregationMetaCopyWithImpl<CongregationMeta>(this as CongregationMeta, _$identity);

  /// Serializes this CongregationMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CongregationMeta&&(identical(other.name, name) || other.name == name)&&(identical(other.founderUid, founderUid) || other.founderUid == founderUid)&&(identical(other.lmmWeekday, lmmWeekday) || other.lmmWeekday == lmmWeekday)&&(identical(other.lmmTime, lmmTime) || other.lmmTime == lmmTime)&&(identical(other.lmmClassCount, lmmClassCount) || other.lmmClassCount == lmmClassCount)&&(identical(other.weekendWeekday, weekendWeekday) || other.weekendWeekday == weekendWeekday)&&(identical(other.weekendTime, weekendTime) || other.weekendTime == weekendTime)&&(identical(other.appointmentBackfilled, appointmentBackfilled) || other.appointmentBackfilled == appointmentBackfilled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,founderUid,lmmWeekday,lmmTime,lmmClassCount,weekendWeekday,weekendTime,appointmentBackfilled);

@override
String toString() {
  return 'CongregationMeta(name: $name, founderUid: $founderUid, lmmWeekday: $lmmWeekday, lmmTime: $lmmTime, lmmClassCount: $lmmClassCount, weekendWeekday: $weekendWeekday, weekendTime: $weekendTime, appointmentBackfilled: $appointmentBackfilled)';
}


}

/// @nodoc
abstract mixin class $CongregationMetaCopyWith<$Res>  {
  factory $CongregationMetaCopyWith(CongregationMeta value, $Res Function(CongregationMeta) _then) = _$CongregationMetaCopyWithImpl;
@useResult
$Res call({
 String name, String founderUid, int lmmWeekday, String lmmTime, int lmmClassCount, int weekendWeekday, String weekendTime, bool appointmentBackfilled
});




}
/// @nodoc
class _$CongregationMetaCopyWithImpl<$Res>
    implements $CongregationMetaCopyWith<$Res> {
  _$CongregationMetaCopyWithImpl(this._self, this._then);

  final CongregationMeta _self;
  final $Res Function(CongregationMeta) _then;

/// Create a copy of CongregationMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? founderUid = null,Object? lmmWeekday = null,Object? lmmTime = null,Object? lmmClassCount = null,Object? weekendWeekday = null,Object? weekendTime = null,Object? appointmentBackfilled = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,founderUid: null == founderUid ? _self.founderUid : founderUid // ignore: cast_nullable_to_non_nullable
as String,lmmWeekday: null == lmmWeekday ? _self.lmmWeekday : lmmWeekday // ignore: cast_nullable_to_non_nullable
as int,lmmTime: null == lmmTime ? _self.lmmTime : lmmTime // ignore: cast_nullable_to_non_nullable
as String,lmmClassCount: null == lmmClassCount ? _self.lmmClassCount : lmmClassCount // ignore: cast_nullable_to_non_nullable
as int,weekendWeekday: null == weekendWeekday ? _self.weekendWeekday : weekendWeekday // ignore: cast_nullable_to_non_nullable
as int,weekendTime: null == weekendTime ? _self.weekendTime : weekendTime // ignore: cast_nullable_to_non_nullable
as String,appointmentBackfilled: null == appointmentBackfilled ? _self.appointmentBackfilled : appointmentBackfilled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CongregationMeta].
extension CongregationMetaPatterns on CongregationMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CongregationMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CongregationMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CongregationMeta value)  $default,){
final _that = this;
switch (_that) {
case _CongregationMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CongregationMeta value)?  $default,){
final _that = this;
switch (_that) {
case _CongregationMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String founderUid,  int lmmWeekday,  String lmmTime,  int lmmClassCount,  int weekendWeekday,  String weekendTime,  bool appointmentBackfilled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CongregationMeta() when $default != null:
return $default(_that.name,_that.founderUid,_that.lmmWeekday,_that.lmmTime,_that.lmmClassCount,_that.weekendWeekday,_that.weekendTime,_that.appointmentBackfilled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String founderUid,  int lmmWeekday,  String lmmTime,  int lmmClassCount,  int weekendWeekday,  String weekendTime,  bool appointmentBackfilled)  $default,) {final _that = this;
switch (_that) {
case _CongregationMeta():
return $default(_that.name,_that.founderUid,_that.lmmWeekday,_that.lmmTime,_that.lmmClassCount,_that.weekendWeekday,_that.weekendTime,_that.appointmentBackfilled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String founderUid,  int lmmWeekday,  String lmmTime,  int lmmClassCount,  int weekendWeekday,  String weekendTime,  bool appointmentBackfilled)?  $default,) {final _that = this;
switch (_that) {
case _CongregationMeta() when $default != null:
return $default(_that.name,_that.founderUid,_that.lmmWeekday,_that.lmmTime,_that.lmmClassCount,_that.weekendWeekday,_that.weekendTime,_that.appointmentBackfilled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CongregationMeta implements CongregationMeta {
  const _CongregationMeta({this.name = '', this.founderUid = '', this.lmmWeekday = DateTime.tuesday, this.lmmTime = '18:30', this.lmmClassCount = 1, this.weekendWeekday = DateTime.sunday, this.weekendTime = '10:00', this.appointmentBackfilled = false});
  factory _CongregationMeta.fromJson(Map<String, dynamic> json) => _$CongregationMetaFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  String founderUid;
/// DateTime.monday..DateTime.sunday (1..7)
@override@JsonKey() final  int lmmWeekday;
/// "HH:mm"
@override@JsonKey() final  String lmmTime;
/// Midweek meeting classes (1 = main hall only, 2-3 add auxiliary
/// classes with their own student assignments).
@override@JsonKey() final  int lmmClassCount;
@override@JsonKey() final  int weekendWeekday;
@override@JsonKey() final  String weekendTime;
/// One-time marker: elder/MS appointments have been copied from each
/// private profile onto the public publisher doc. Set by the client
/// backfill (full admin only) so it runs at most once per congregation.
@override@JsonKey() final  bool appointmentBackfilled;

/// Create a copy of CongregationMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CongregationMetaCopyWith<_CongregationMeta> get copyWith => __$CongregationMetaCopyWithImpl<_CongregationMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CongregationMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CongregationMeta&&(identical(other.name, name) || other.name == name)&&(identical(other.founderUid, founderUid) || other.founderUid == founderUid)&&(identical(other.lmmWeekday, lmmWeekday) || other.lmmWeekday == lmmWeekday)&&(identical(other.lmmTime, lmmTime) || other.lmmTime == lmmTime)&&(identical(other.lmmClassCount, lmmClassCount) || other.lmmClassCount == lmmClassCount)&&(identical(other.weekendWeekday, weekendWeekday) || other.weekendWeekday == weekendWeekday)&&(identical(other.weekendTime, weekendTime) || other.weekendTime == weekendTime)&&(identical(other.appointmentBackfilled, appointmentBackfilled) || other.appointmentBackfilled == appointmentBackfilled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,founderUid,lmmWeekday,lmmTime,lmmClassCount,weekendWeekday,weekendTime,appointmentBackfilled);

@override
String toString() {
  return 'CongregationMeta(name: $name, founderUid: $founderUid, lmmWeekday: $lmmWeekday, lmmTime: $lmmTime, lmmClassCount: $lmmClassCount, weekendWeekday: $weekendWeekday, weekendTime: $weekendTime, appointmentBackfilled: $appointmentBackfilled)';
}


}

/// @nodoc
abstract mixin class _$CongregationMetaCopyWith<$Res> implements $CongregationMetaCopyWith<$Res> {
  factory _$CongregationMetaCopyWith(_CongregationMeta value, $Res Function(_CongregationMeta) _then) = __$CongregationMetaCopyWithImpl;
@override @useResult
$Res call({
 String name, String founderUid, int lmmWeekday, String lmmTime, int lmmClassCount, int weekendWeekday, String weekendTime, bool appointmentBackfilled
});




}
/// @nodoc
class __$CongregationMetaCopyWithImpl<$Res>
    implements _$CongregationMetaCopyWith<$Res> {
  __$CongregationMetaCopyWithImpl(this._self, this._then);

  final _CongregationMeta _self;
  final $Res Function(_CongregationMeta) _then;

/// Create a copy of CongregationMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? founderUid = null,Object? lmmWeekday = null,Object? lmmTime = null,Object? lmmClassCount = null,Object? weekendWeekday = null,Object? weekendTime = null,Object? appointmentBackfilled = null,}) {
  return _then(_CongregationMeta(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,founderUid: null == founderUid ? _self.founderUid : founderUid // ignore: cast_nullable_to_non_nullable
as String,lmmWeekday: null == lmmWeekday ? _self.lmmWeekday : lmmWeekday // ignore: cast_nullable_to_non_nullable
as int,lmmTime: null == lmmTime ? _self.lmmTime : lmmTime // ignore: cast_nullable_to_non_nullable
as String,lmmClassCount: null == lmmClassCount ? _self.lmmClassCount : lmmClassCount // ignore: cast_nullable_to_non_nullable
as int,weekendWeekday: null == weekendWeekday ? _self.weekendWeekday : weekendWeekday // ignore: cast_nullable_to_non_nullable
as int,weekendTime: null == weekendTime ? _self.weekendTime : weekendTime // ignore: cast_nullable_to_non_nullable
as String,appointmentBackfilled: null == appointmentBackfilled ? _self.appointmentBackfilled : appointmentBackfilled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
