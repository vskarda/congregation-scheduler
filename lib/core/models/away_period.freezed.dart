// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'away_period.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AwayPeriod {

 String get startDate; String get endDate;
/// Create a copy of AwayPeriod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AwayPeriodCopyWith<AwayPeriod> get copyWith => _$AwayPeriodCopyWithImpl<AwayPeriod>(this as AwayPeriod, _$identity);

  /// Serializes this AwayPeriod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AwayPeriod&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startDate,endDate);

@override
String toString() {
  return 'AwayPeriod(startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $AwayPeriodCopyWith<$Res>  {
  factory $AwayPeriodCopyWith(AwayPeriod value, $Res Function(AwayPeriod) _then) = _$AwayPeriodCopyWithImpl;
@useResult
$Res call({
 String startDate, String endDate
});




}
/// @nodoc
class _$AwayPeriodCopyWithImpl<$Res>
    implements $AwayPeriodCopyWith<$Res> {
  _$AwayPeriodCopyWithImpl(this._self, this._then);

  final AwayPeriod _self;
  final $Res Function(AwayPeriod) _then;

/// Create a copy of AwayPeriod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startDate = null,Object? endDate = null,}) {
  return _then(_self.copyWith(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AwayPeriod].
extension AwayPeriodPatterns on AwayPeriod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AwayPeriod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AwayPeriod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AwayPeriod value)  $default,){
final _that = this;
switch (_that) {
case _AwayPeriod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AwayPeriod value)?  $default,){
final _that = this;
switch (_that) {
case _AwayPeriod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String startDate,  String endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AwayPeriod() when $default != null:
return $default(_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String startDate,  String endDate)  $default,) {final _that = this;
switch (_that) {
case _AwayPeriod():
return $default(_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String startDate,  String endDate)?  $default,) {final _that = this;
switch (_that) {
case _AwayPeriod() when $default != null:
return $default(_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AwayPeriod extends AwayPeriod {
  const _AwayPeriod({required this.startDate, required this.endDate}): super._();
  factory _AwayPeriod.fromJson(Map<String, dynamic> json) => _$AwayPeriodFromJson(json);

@override final  String startDate;
@override final  String endDate;

/// Create a copy of AwayPeriod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AwayPeriodCopyWith<_AwayPeriod> get copyWith => __$AwayPeriodCopyWithImpl<_AwayPeriod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AwayPeriodToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AwayPeriod&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startDate,endDate);

@override
String toString() {
  return 'AwayPeriod(startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$AwayPeriodCopyWith<$Res> implements $AwayPeriodCopyWith<$Res> {
  factory _$AwayPeriodCopyWith(_AwayPeriod value, $Res Function(_AwayPeriod) _then) = __$AwayPeriodCopyWithImpl;
@override @useResult
$Res call({
 String startDate, String endDate
});




}
/// @nodoc
class __$AwayPeriodCopyWithImpl<$Res>
    implements _$AwayPeriodCopyWith<$Res> {
  __$AwayPeriodCopyWithImpl(this._self, this._then);

  final _AwayPeriod _self;
  final $Res Function(_AwayPeriod) _then;

/// Create a copy of AwayPeriod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startDate = null,Object? endDate = null,}) {
  return _then(_AwayPeriod(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PublisherAway {

 List<AwayPeriod> get periods;
/// Create a copy of PublisherAway
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublisherAwayCopyWith<PublisherAway> get copyWith => _$PublisherAwayCopyWithImpl<PublisherAway>(this as PublisherAway, _$identity);

  /// Serializes this PublisherAway to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublisherAway&&const DeepCollectionEquality().equals(other.periods, periods));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(periods));

@override
String toString() {
  return 'PublisherAway(periods: $periods)';
}


}

/// @nodoc
abstract mixin class $PublisherAwayCopyWith<$Res>  {
  factory $PublisherAwayCopyWith(PublisherAway value, $Res Function(PublisherAway) _then) = _$PublisherAwayCopyWithImpl;
@useResult
$Res call({
 List<AwayPeriod> periods
});




}
/// @nodoc
class _$PublisherAwayCopyWithImpl<$Res>
    implements $PublisherAwayCopyWith<$Res> {
  _$PublisherAwayCopyWithImpl(this._self, this._then);

  final PublisherAway _self;
  final $Res Function(PublisherAway) _then;

/// Create a copy of PublisherAway
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? periods = null,}) {
  return _then(_self.copyWith(
periods: null == periods ? _self.periods : periods // ignore: cast_nullable_to_non_nullable
as List<AwayPeriod>,
  ));
}

}


/// Adds pattern-matching-related methods to [PublisherAway].
extension PublisherAwayPatterns on PublisherAway {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublisherAway value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublisherAway() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublisherAway value)  $default,){
final _that = this;
switch (_that) {
case _PublisherAway():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublisherAway value)?  $default,){
final _that = this;
switch (_that) {
case _PublisherAway() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AwayPeriod> periods)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublisherAway() when $default != null:
return $default(_that.periods);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AwayPeriod> periods)  $default,) {final _that = this;
switch (_that) {
case _PublisherAway():
return $default(_that.periods);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AwayPeriod> periods)?  $default,) {final _that = this;
switch (_that) {
case _PublisherAway() when $default != null:
return $default(_that.periods);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublisherAway implements PublisherAway {
  const _PublisherAway({final  List<AwayPeriod> periods = const <AwayPeriod>[]}): _periods = periods;
  factory _PublisherAway.fromJson(Map<String, dynamic> json) => _$PublisherAwayFromJson(json);

 final  List<AwayPeriod> _periods;
@override@JsonKey() List<AwayPeriod> get periods {
  if (_periods is EqualUnmodifiableListView) return _periods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_periods);
}


/// Create a copy of PublisherAway
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublisherAwayCopyWith<_PublisherAway> get copyWith => __$PublisherAwayCopyWithImpl<_PublisherAway>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublisherAwayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublisherAway&&const DeepCollectionEquality().equals(other._periods, _periods));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_periods));

@override
String toString() {
  return 'PublisherAway(periods: $periods)';
}


}

/// @nodoc
abstract mixin class _$PublisherAwayCopyWith<$Res> implements $PublisherAwayCopyWith<$Res> {
  factory _$PublisherAwayCopyWith(_PublisherAway value, $Res Function(_PublisherAway) _then) = __$PublisherAwayCopyWithImpl;
@override @useResult
$Res call({
 List<AwayPeriod> periods
});




}
/// @nodoc
class __$PublisherAwayCopyWithImpl<$Res>
    implements _$PublisherAwayCopyWith<$Res> {
  __$PublisherAwayCopyWithImpl(this._self, this._then);

  final _PublisherAway _self;
  final $Res Function(_PublisherAway) _then;

/// Create a copy of PublisherAway
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? periods = null,}) {
  return _then(_PublisherAway(
periods: null == periods ? _self._periods : periods // ignore: cast_nullable_to_non_nullable
as List<AwayPeriod>,
  ));
}


}

// dart format on
