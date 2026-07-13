// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleConfig {

 List<CustomAssignment> get permanentAssignments;
/// Create a copy of ScheduleConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleConfigCopyWith<ScheduleConfig> get copyWith => _$ScheduleConfigCopyWithImpl<ScheduleConfig>(this as ScheduleConfig, _$identity);

  /// Serializes this ScheduleConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleConfig&&const DeepCollectionEquality().equals(other.permanentAssignments, permanentAssignments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(permanentAssignments));

@override
String toString() {
  return 'ScheduleConfig(permanentAssignments: $permanentAssignments)';
}


}

/// @nodoc
abstract mixin class $ScheduleConfigCopyWith<$Res>  {
  factory $ScheduleConfigCopyWith(ScheduleConfig value, $Res Function(ScheduleConfig) _then) = _$ScheduleConfigCopyWithImpl;
@useResult
$Res call({
 List<CustomAssignment> permanentAssignments
});




}
/// @nodoc
class _$ScheduleConfigCopyWithImpl<$Res>
    implements $ScheduleConfigCopyWith<$Res> {
  _$ScheduleConfigCopyWithImpl(this._self, this._then);

  final ScheduleConfig _self;
  final $Res Function(ScheduleConfig) _then;

/// Create a copy of ScheduleConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? permanentAssignments = null,}) {
  return _then(_self.copyWith(
permanentAssignments: null == permanentAssignments ? _self.permanentAssignments : permanentAssignments // ignore: cast_nullable_to_non_nullable
as List<CustomAssignment>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleConfig].
extension ScheduleConfigPatterns on ScheduleConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleConfig value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CustomAssignment> permanentAssignments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleConfig() when $default != null:
return $default(_that.permanentAssignments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CustomAssignment> permanentAssignments)  $default,) {final _that = this;
switch (_that) {
case _ScheduleConfig():
return $default(_that.permanentAssignments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CustomAssignment> permanentAssignments)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleConfig() when $default != null:
return $default(_that.permanentAssignments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleConfig implements ScheduleConfig {
  const _ScheduleConfig({final  List<CustomAssignment> permanentAssignments = const <CustomAssignment>[]}): _permanentAssignments = permanentAssignments;
  factory _ScheduleConfig.fromJson(Map<String, dynamic> json) => _$ScheduleConfigFromJson(json);

 final  List<CustomAssignment> _permanentAssignments;
@override@JsonKey() List<CustomAssignment> get permanentAssignments {
  if (_permanentAssignments is EqualUnmodifiableListView) return _permanentAssignments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permanentAssignments);
}


/// Create a copy of ScheduleConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleConfigCopyWith<_ScheduleConfig> get copyWith => __$ScheduleConfigCopyWithImpl<_ScheduleConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleConfig&&const DeepCollectionEquality().equals(other._permanentAssignments, _permanentAssignments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_permanentAssignments));

@override
String toString() {
  return 'ScheduleConfig(permanentAssignments: $permanentAssignments)';
}


}

/// @nodoc
abstract mixin class _$ScheduleConfigCopyWith<$Res> implements $ScheduleConfigCopyWith<$Res> {
  factory _$ScheduleConfigCopyWith(_ScheduleConfig value, $Res Function(_ScheduleConfig) _then) = __$ScheduleConfigCopyWithImpl;
@override @useResult
$Res call({
 List<CustomAssignment> permanentAssignments
});




}
/// @nodoc
class __$ScheduleConfigCopyWithImpl<$Res>
    implements _$ScheduleConfigCopyWith<$Res> {
  __$ScheduleConfigCopyWithImpl(this._self, this._then);

  final _ScheduleConfig _self;
  final $Res Function(_ScheduleConfig) _then;

/// Create a copy of ScheduleConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? permanentAssignments = null,}) {
  return _then(_ScheduleConfig(
permanentAssignments: null == permanentAssignments ? _self._permanentAssignments : permanentAssignments // ignore: cast_nullable_to_non_nullable
as List<CustomAssignment>,
  ));
}


}

// dart format on
