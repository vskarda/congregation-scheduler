// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 's1_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$S1Group {

 int get count; int get studies;/// Field service + credit hours.
 int get hours;
/// Create a copy of S1Group
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$S1GroupCopyWith<S1Group> get copyWith => _$S1GroupCopyWithImpl<S1Group>(this as S1Group, _$identity);

  /// Serializes this S1Group to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is S1Group&&(identical(other.count, count) || other.count == count)&&(identical(other.studies, studies) || other.studies == studies)&&(identical(other.hours, hours) || other.hours == hours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,studies,hours);

@override
String toString() {
  return 'S1Group(count: $count, studies: $studies, hours: $hours)';
}


}

/// @nodoc
abstract mixin class $S1GroupCopyWith<$Res>  {
  factory $S1GroupCopyWith(S1Group value, $Res Function(S1Group) _then) = _$S1GroupCopyWithImpl;
@useResult
$Res call({
 int count, int studies, int hours
});




}
/// @nodoc
class _$S1GroupCopyWithImpl<$Res>
    implements $S1GroupCopyWith<$Res> {
  _$S1GroupCopyWithImpl(this._self, this._then);

  final S1Group _self;
  final $Res Function(S1Group) _then;

/// Create a copy of S1Group
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? studies = null,Object? hours = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,studies: null == studies ? _self.studies : studies // ignore: cast_nullable_to_non_nullable
as int,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [S1Group].
extension S1GroupPatterns on S1Group {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _S1Group value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _S1Group() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _S1Group value)  $default,){
final _that = this;
switch (_that) {
case _S1Group():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _S1Group value)?  $default,){
final _that = this;
switch (_that) {
case _S1Group() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  int studies,  int hours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _S1Group() when $default != null:
return $default(_that.count,_that.studies,_that.hours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  int studies,  int hours)  $default,) {final _that = this;
switch (_that) {
case _S1Group():
return $default(_that.count,_that.studies,_that.hours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  int studies,  int hours)?  $default,) {final _that = this;
switch (_that) {
case _S1Group() when $default != null:
return $default(_that.count,_that.studies,_that.hours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _S1Group implements S1Group {
  const _S1Group({this.count = 0, this.studies = 0, this.hours = 0});
  factory _S1Group.fromJson(Map<String, dynamic> json) => _$S1GroupFromJson(json);

@override@JsonKey() final  int count;
@override@JsonKey() final  int studies;
/// Field service + credit hours.
@override@JsonKey() final  int hours;

/// Create a copy of S1Group
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$S1GroupCopyWith<_S1Group> get copyWith => __$S1GroupCopyWithImpl<_S1Group>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$S1GroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _S1Group&&(identical(other.count, count) || other.count == count)&&(identical(other.studies, studies) || other.studies == studies)&&(identical(other.hours, hours) || other.hours == hours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,studies,hours);

@override
String toString() {
  return 'S1Group(count: $count, studies: $studies, hours: $hours)';
}


}

/// @nodoc
abstract mixin class _$S1GroupCopyWith<$Res> implements $S1GroupCopyWith<$Res> {
  factory _$S1GroupCopyWith(_S1Group value, $Res Function(_S1Group) _then) = __$S1GroupCopyWithImpl;
@override @useResult
$Res call({
 int count, int studies, int hours
});




}
/// @nodoc
class __$S1GroupCopyWithImpl<$Res>
    implements _$S1GroupCopyWith<$Res> {
  __$S1GroupCopyWithImpl(this._self, this._then);

  final _S1Group _self;
  final $Res Function(_S1Group) _then;

/// Create a copy of S1Group
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? studies = null,Object? hours = null,}) {
  return _then(_S1Group(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,studies: null == studies ? _self.studies : studies // ignore: cast_nullable_to_non_nullable
as int,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$S1Record {

/// yyyy-MM, = doc id.
 String get month;/// Distinct persons with a positive report in the last 6 months
/// (including this month).
 int get activePublishers; int? get avgMidweekAttendance; int? get avgWeekendAttendance; S1Group get publishers; S1Group get auxiliaryPioneers; S1Group get regularPioneers;/// When the figures were frozen; null on a freshly computed result.
@NullableTimestampConverter() DateTime? get frozenAt;/// Uid of whoever froze the month (empty for the automatic sweep).
 String get frozenBy;/// Written by the automatic sweep rather than by the Freeze button.
 bool get auto;
/// Create a copy of S1Record
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$S1RecordCopyWith<S1Record> get copyWith => _$S1RecordCopyWithImpl<S1Record>(this as S1Record, _$identity);

  /// Serializes this S1Record to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is S1Record&&(identical(other.month, month) || other.month == month)&&(identical(other.activePublishers, activePublishers) || other.activePublishers == activePublishers)&&(identical(other.avgMidweekAttendance, avgMidweekAttendance) || other.avgMidweekAttendance == avgMidweekAttendance)&&(identical(other.avgWeekendAttendance, avgWeekendAttendance) || other.avgWeekendAttendance == avgWeekendAttendance)&&(identical(other.publishers, publishers) || other.publishers == publishers)&&(identical(other.auxiliaryPioneers, auxiliaryPioneers) || other.auxiliaryPioneers == auxiliaryPioneers)&&(identical(other.regularPioneers, regularPioneers) || other.regularPioneers == regularPioneers)&&(identical(other.frozenAt, frozenAt) || other.frozenAt == frozenAt)&&(identical(other.frozenBy, frozenBy) || other.frozenBy == frozenBy)&&(identical(other.auto, auto) || other.auto == auto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,activePublishers,avgMidweekAttendance,avgWeekendAttendance,publishers,auxiliaryPioneers,regularPioneers,frozenAt,frozenBy,auto);

@override
String toString() {
  return 'S1Record(month: $month, activePublishers: $activePublishers, avgMidweekAttendance: $avgMidweekAttendance, avgWeekendAttendance: $avgWeekendAttendance, publishers: $publishers, auxiliaryPioneers: $auxiliaryPioneers, regularPioneers: $regularPioneers, frozenAt: $frozenAt, frozenBy: $frozenBy, auto: $auto)';
}


}

/// @nodoc
abstract mixin class $S1RecordCopyWith<$Res>  {
  factory $S1RecordCopyWith(S1Record value, $Res Function(S1Record) _then) = _$S1RecordCopyWithImpl;
@useResult
$Res call({
 String month, int activePublishers, int? avgMidweekAttendance, int? avgWeekendAttendance, S1Group publishers, S1Group auxiliaryPioneers, S1Group regularPioneers,@NullableTimestampConverter() DateTime? frozenAt, String frozenBy, bool auto
});


$S1GroupCopyWith<$Res> get publishers;$S1GroupCopyWith<$Res> get auxiliaryPioneers;$S1GroupCopyWith<$Res> get regularPioneers;

}
/// @nodoc
class _$S1RecordCopyWithImpl<$Res>
    implements $S1RecordCopyWith<$Res> {
  _$S1RecordCopyWithImpl(this._self, this._then);

  final S1Record _self;
  final $Res Function(S1Record) _then;

/// Create a copy of S1Record
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? activePublishers = null,Object? avgMidweekAttendance = freezed,Object? avgWeekendAttendance = freezed,Object? publishers = null,Object? auxiliaryPioneers = null,Object? regularPioneers = null,Object? frozenAt = freezed,Object? frozenBy = null,Object? auto = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,activePublishers: null == activePublishers ? _self.activePublishers : activePublishers // ignore: cast_nullable_to_non_nullable
as int,avgMidweekAttendance: freezed == avgMidweekAttendance ? _self.avgMidweekAttendance : avgMidweekAttendance // ignore: cast_nullable_to_non_nullable
as int?,avgWeekendAttendance: freezed == avgWeekendAttendance ? _self.avgWeekendAttendance : avgWeekendAttendance // ignore: cast_nullable_to_non_nullable
as int?,publishers: null == publishers ? _self.publishers : publishers // ignore: cast_nullable_to_non_nullable
as S1Group,auxiliaryPioneers: null == auxiliaryPioneers ? _self.auxiliaryPioneers : auxiliaryPioneers // ignore: cast_nullable_to_non_nullable
as S1Group,regularPioneers: null == regularPioneers ? _self.regularPioneers : regularPioneers // ignore: cast_nullable_to_non_nullable
as S1Group,frozenAt: freezed == frozenAt ? _self.frozenAt : frozenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,frozenBy: null == frozenBy ? _self.frozenBy : frozenBy // ignore: cast_nullable_to_non_nullable
as String,auto: null == auto ? _self.auto : auto // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of S1Record
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$S1GroupCopyWith<$Res> get publishers {
  
  return $S1GroupCopyWith<$Res>(_self.publishers, (value) {
    return _then(_self.copyWith(publishers: value));
  });
}/// Create a copy of S1Record
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$S1GroupCopyWith<$Res> get auxiliaryPioneers {
  
  return $S1GroupCopyWith<$Res>(_self.auxiliaryPioneers, (value) {
    return _then(_self.copyWith(auxiliaryPioneers: value));
  });
}/// Create a copy of S1Record
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$S1GroupCopyWith<$Res> get regularPioneers {
  
  return $S1GroupCopyWith<$Res>(_self.regularPioneers, (value) {
    return _then(_self.copyWith(regularPioneers: value));
  });
}
}


/// Adds pattern-matching-related methods to [S1Record].
extension S1RecordPatterns on S1Record {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _S1Record value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _S1Record() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _S1Record value)  $default,){
final _that = this;
switch (_that) {
case _S1Record():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _S1Record value)?  $default,){
final _that = this;
switch (_that) {
case _S1Record() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String month,  int activePublishers,  int? avgMidweekAttendance,  int? avgWeekendAttendance,  S1Group publishers,  S1Group auxiliaryPioneers,  S1Group regularPioneers, @NullableTimestampConverter()  DateTime? frozenAt,  String frozenBy,  bool auto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _S1Record() when $default != null:
return $default(_that.month,_that.activePublishers,_that.avgMidweekAttendance,_that.avgWeekendAttendance,_that.publishers,_that.auxiliaryPioneers,_that.regularPioneers,_that.frozenAt,_that.frozenBy,_that.auto);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String month,  int activePublishers,  int? avgMidweekAttendance,  int? avgWeekendAttendance,  S1Group publishers,  S1Group auxiliaryPioneers,  S1Group regularPioneers, @NullableTimestampConverter()  DateTime? frozenAt,  String frozenBy,  bool auto)  $default,) {final _that = this;
switch (_that) {
case _S1Record():
return $default(_that.month,_that.activePublishers,_that.avgMidweekAttendance,_that.avgWeekendAttendance,_that.publishers,_that.auxiliaryPioneers,_that.regularPioneers,_that.frozenAt,_that.frozenBy,_that.auto);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String month,  int activePublishers,  int? avgMidweekAttendance,  int? avgWeekendAttendance,  S1Group publishers,  S1Group auxiliaryPioneers,  S1Group regularPioneers, @NullableTimestampConverter()  DateTime? frozenAt,  String frozenBy,  bool auto)?  $default,) {final _that = this;
switch (_that) {
case _S1Record() when $default != null:
return $default(_that.month,_that.activePublishers,_that.avgMidweekAttendance,_that.avgWeekendAttendance,_that.publishers,_that.auxiliaryPioneers,_that.regularPioneers,_that.frozenAt,_that.frozenBy,_that.auto);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _S1Record extends S1Record {
  const _S1Record({this.month = '', this.activePublishers = 0, this.avgMidweekAttendance, this.avgWeekendAttendance, this.publishers = const S1Group(), this.auxiliaryPioneers = const S1Group(), this.regularPioneers = const S1Group(), @NullableTimestampConverter() this.frozenAt, this.frozenBy = '', this.auto = false}): super._();
  factory _S1Record.fromJson(Map<String, dynamic> json) => _$S1RecordFromJson(json);

/// yyyy-MM, = doc id.
@override@JsonKey() final  String month;
/// Distinct persons with a positive report in the last 6 months
/// (including this month).
@override@JsonKey() final  int activePublishers;
@override final  int? avgMidweekAttendance;
@override final  int? avgWeekendAttendance;
@override@JsonKey() final  S1Group publishers;
@override@JsonKey() final  S1Group auxiliaryPioneers;
@override@JsonKey() final  S1Group regularPioneers;
/// When the figures were frozen; null on a freshly computed result.
@override@NullableTimestampConverter() final  DateTime? frozenAt;
/// Uid of whoever froze the month (empty for the automatic sweep).
@override@JsonKey() final  String frozenBy;
/// Written by the automatic sweep rather than by the Freeze button.
@override@JsonKey() final  bool auto;

/// Create a copy of S1Record
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$S1RecordCopyWith<_S1Record> get copyWith => __$S1RecordCopyWithImpl<_S1Record>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$S1RecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _S1Record&&(identical(other.month, month) || other.month == month)&&(identical(other.activePublishers, activePublishers) || other.activePublishers == activePublishers)&&(identical(other.avgMidweekAttendance, avgMidweekAttendance) || other.avgMidweekAttendance == avgMidweekAttendance)&&(identical(other.avgWeekendAttendance, avgWeekendAttendance) || other.avgWeekendAttendance == avgWeekendAttendance)&&(identical(other.publishers, publishers) || other.publishers == publishers)&&(identical(other.auxiliaryPioneers, auxiliaryPioneers) || other.auxiliaryPioneers == auxiliaryPioneers)&&(identical(other.regularPioneers, regularPioneers) || other.regularPioneers == regularPioneers)&&(identical(other.frozenAt, frozenAt) || other.frozenAt == frozenAt)&&(identical(other.frozenBy, frozenBy) || other.frozenBy == frozenBy)&&(identical(other.auto, auto) || other.auto == auto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,activePublishers,avgMidweekAttendance,avgWeekendAttendance,publishers,auxiliaryPioneers,regularPioneers,frozenAt,frozenBy,auto);

@override
String toString() {
  return 'S1Record(month: $month, activePublishers: $activePublishers, avgMidweekAttendance: $avgMidweekAttendance, avgWeekendAttendance: $avgWeekendAttendance, publishers: $publishers, auxiliaryPioneers: $auxiliaryPioneers, regularPioneers: $regularPioneers, frozenAt: $frozenAt, frozenBy: $frozenBy, auto: $auto)';
}


}

/// @nodoc
abstract mixin class _$S1RecordCopyWith<$Res> implements $S1RecordCopyWith<$Res> {
  factory _$S1RecordCopyWith(_S1Record value, $Res Function(_S1Record) _then) = __$S1RecordCopyWithImpl;
@override @useResult
$Res call({
 String month, int activePublishers, int? avgMidweekAttendance, int? avgWeekendAttendance, S1Group publishers, S1Group auxiliaryPioneers, S1Group regularPioneers,@NullableTimestampConverter() DateTime? frozenAt, String frozenBy, bool auto
});


@override $S1GroupCopyWith<$Res> get publishers;@override $S1GroupCopyWith<$Res> get auxiliaryPioneers;@override $S1GroupCopyWith<$Res> get regularPioneers;

}
/// @nodoc
class __$S1RecordCopyWithImpl<$Res>
    implements _$S1RecordCopyWith<$Res> {
  __$S1RecordCopyWithImpl(this._self, this._then);

  final _S1Record _self;
  final $Res Function(_S1Record) _then;

/// Create a copy of S1Record
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? activePublishers = null,Object? avgMidweekAttendance = freezed,Object? avgWeekendAttendance = freezed,Object? publishers = null,Object? auxiliaryPioneers = null,Object? regularPioneers = null,Object? frozenAt = freezed,Object? frozenBy = null,Object? auto = null,}) {
  return _then(_S1Record(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,activePublishers: null == activePublishers ? _self.activePublishers : activePublishers // ignore: cast_nullable_to_non_nullable
as int,avgMidweekAttendance: freezed == avgMidweekAttendance ? _self.avgMidweekAttendance : avgMidweekAttendance // ignore: cast_nullable_to_non_nullable
as int?,avgWeekendAttendance: freezed == avgWeekendAttendance ? _self.avgWeekendAttendance : avgWeekendAttendance // ignore: cast_nullable_to_non_nullable
as int?,publishers: null == publishers ? _self.publishers : publishers // ignore: cast_nullable_to_non_nullable
as S1Group,auxiliaryPioneers: null == auxiliaryPioneers ? _self.auxiliaryPioneers : auxiliaryPioneers // ignore: cast_nullable_to_non_nullable
as S1Group,regularPioneers: null == regularPioneers ? _self.regularPioneers : regularPioneers // ignore: cast_nullable_to_non_nullable
as S1Group,frozenAt: freezed == frozenAt ? _self.frozenAt : frozenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,frozenBy: null == frozenBy ? _self.frozenBy : frozenBy // ignore: cast_nullable_to_non_nullable
as String,auto: null == auto ? _self.auto : auto // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of S1Record
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$S1GroupCopyWith<$Res> get publishers {
  
  return $S1GroupCopyWith<$Res>(_self.publishers, (value) {
    return _then(_self.copyWith(publishers: value));
  });
}/// Create a copy of S1Record
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$S1GroupCopyWith<$Res> get auxiliaryPioneers {
  
  return $S1GroupCopyWith<$Res>(_self.auxiliaryPioneers, (value) {
    return _then(_self.copyWith(auxiliaryPioneers: value));
  });
}/// Create a copy of S1Record
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$S1GroupCopyWith<$Res> get regularPioneers {
  
  return $S1GroupCopyWith<$Res>(_self.regularPioneers, (value) {
    return _then(_self.copyWith(regularPioneers: value));
  });
}
}

// dart format on
