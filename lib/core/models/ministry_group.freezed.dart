// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ministry_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MinistryGroup {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get name;/// Publisher id of the group overseer ('' = none). Chosen among members.
 String get overseerId;/// Publisher id of the overseer's assistant ('' = none).
 String get assistantId;
/// Create a copy of MinistryGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MinistryGroupCopyWith<MinistryGroup> get copyWith => _$MinistryGroupCopyWithImpl<MinistryGroup>(this as MinistryGroup, _$identity);

  /// Serializes this MinistryGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MinistryGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.overseerId, overseerId) || other.overseerId == overseerId)&&(identical(other.assistantId, assistantId) || other.assistantId == assistantId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,overseerId,assistantId);

@override
String toString() {
  return 'MinistryGroup(id: $id, name: $name, overseerId: $overseerId, assistantId: $assistantId)';
}


}

/// @nodoc
abstract mixin class $MinistryGroupCopyWith<$Res>  {
  factory $MinistryGroupCopyWith(MinistryGroup value, $Res Function(MinistryGroup) _then) = _$MinistryGroupCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String name, String overseerId, String assistantId
});




}
/// @nodoc
class _$MinistryGroupCopyWithImpl<$Res>
    implements $MinistryGroupCopyWith<$Res> {
  _$MinistryGroupCopyWithImpl(this._self, this._then);

  final MinistryGroup _self;
  final $Res Function(MinistryGroup) _then;

/// Create a copy of MinistryGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? overseerId = null,Object? assistantId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overseerId: null == overseerId ? _self.overseerId : overseerId // ignore: cast_nullable_to_non_nullable
as String,assistantId: null == assistantId ? _self.assistantId : assistantId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MinistryGroup].
extension MinistryGroupPatterns on MinistryGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MinistryGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MinistryGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MinistryGroup value)  $default,){
final _that = this;
switch (_that) {
case _MinistryGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MinistryGroup value)?  $default,){
final _that = this;
switch (_that) {
case _MinistryGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String name,  String overseerId,  String assistantId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MinistryGroup() when $default != null:
return $default(_that.id,_that.name,_that.overseerId,_that.assistantId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String name,  String overseerId,  String assistantId)  $default,) {final _that = this;
switch (_that) {
case _MinistryGroup():
return $default(_that.id,_that.name,_that.overseerId,_that.assistantId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String name,  String overseerId,  String assistantId)?  $default,) {final _that = this;
switch (_that) {
case _MinistryGroup() when $default != null:
return $default(_that.id,_that.name,_that.overseerId,_that.assistantId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MinistryGroup implements MinistryGroup {
  const _MinistryGroup({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.name = '', this.overseerId = '', this.assistantId = ''});
  factory _MinistryGroup.fromJson(Map<String, dynamic> json) => _$MinistryGroupFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  String name;
/// Publisher id of the group overseer ('' = none). Chosen among members.
@override@JsonKey() final  String overseerId;
/// Publisher id of the overseer's assistant ('' = none).
@override@JsonKey() final  String assistantId;

/// Create a copy of MinistryGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MinistryGroupCopyWith<_MinistryGroup> get copyWith => __$MinistryGroupCopyWithImpl<_MinistryGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MinistryGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MinistryGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.overseerId, overseerId) || other.overseerId == overseerId)&&(identical(other.assistantId, assistantId) || other.assistantId == assistantId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,overseerId,assistantId);

@override
String toString() {
  return 'MinistryGroup(id: $id, name: $name, overseerId: $overseerId, assistantId: $assistantId)';
}


}

/// @nodoc
abstract mixin class _$MinistryGroupCopyWith<$Res> implements $MinistryGroupCopyWith<$Res> {
  factory _$MinistryGroupCopyWith(_MinistryGroup value, $Res Function(_MinistryGroup) _then) = __$MinistryGroupCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String name, String overseerId, String assistantId
});




}
/// @nodoc
class __$MinistryGroupCopyWithImpl<$Res>
    implements _$MinistryGroupCopyWith<$Res> {
  __$MinistryGroupCopyWithImpl(this._self, this._then);

  final _MinistryGroup _self;
  final $Res Function(_MinistryGroup) _then;

/// Create a copy of MinistryGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? overseerId = null,Object? assistantId = null,}) {
  return _then(_MinistryGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overseerId: null == overseerId ? _self.overseerId : overseerId // ignore: cast_nullable_to_non_nullable
as String,assistantId: null == assistantId ? _self.assistantId : assistantId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
