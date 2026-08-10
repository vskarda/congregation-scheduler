// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'former_publisher.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormerPublisher {

/// Firestore document id = the id the deleted publisher record had, which
/// is also the id of their report entries.
@JsonKey(includeFromJson: false, includeToJson: false) String get id;/// Always true — a tombstone is only written for a departure — but stored
/// so the same rule can be applied as to a live record.
 bool get moved;/// `yyyy-MM-dd`; null on records archived before the date existed, which
/// read as gone throughout.
@JsonKey(includeIfNull: false) String? get movedDate;@NullableTimestampConverter() DateTime? get deletedAt;
/// Create a copy of FormerPublisher
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormerPublisherCopyWith<FormerPublisher> get copyWith => _$FormerPublisherCopyWithImpl<FormerPublisher>(this as FormerPublisher, _$identity);

  /// Serializes this FormerPublisher to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormerPublisher&&(identical(other.id, id) || other.id == id)&&(identical(other.moved, moved) || other.moved == moved)&&(identical(other.movedDate, movedDate) || other.movedDate == movedDate)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,moved,movedDate,deletedAt);

@override
String toString() {
  return 'FormerPublisher(id: $id, moved: $moved, movedDate: $movedDate, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $FormerPublisherCopyWith<$Res>  {
  factory $FormerPublisherCopyWith(FormerPublisher value, $Res Function(FormerPublisher) _then) = _$FormerPublisherCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, bool moved,@JsonKey(includeIfNull: false) String? movedDate,@NullableTimestampConverter() DateTime? deletedAt
});




}
/// @nodoc
class _$FormerPublisherCopyWithImpl<$Res>
    implements $FormerPublisherCopyWith<$Res> {
  _$FormerPublisherCopyWithImpl(this._self, this._then);

  final FormerPublisher _self;
  final $Res Function(FormerPublisher) _then;

/// Create a copy of FormerPublisher
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? moved = null,Object? movedDate = freezed,Object? deletedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,moved: null == moved ? _self.moved : moved // ignore: cast_nullable_to_non_nullable
as bool,movedDate: freezed == movedDate ? _self.movedDate : movedDate // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FormerPublisher].
extension FormerPublisherPatterns on FormerPublisher {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormerPublisher value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormerPublisher() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormerPublisher value)  $default,){
final _that = this;
switch (_that) {
case _FormerPublisher():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormerPublisher value)?  $default,){
final _that = this;
switch (_that) {
case _FormerPublisher() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  bool moved, @JsonKey(includeIfNull: false)  String? movedDate, @NullableTimestampConverter()  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormerPublisher() when $default != null:
return $default(_that.id,_that.moved,_that.movedDate,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  bool moved, @JsonKey(includeIfNull: false)  String? movedDate, @NullableTimestampConverter()  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _FormerPublisher():
return $default(_that.id,_that.moved,_that.movedDate,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  bool moved, @JsonKey(includeIfNull: false)  String? movedDate, @NullableTimestampConverter()  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _FormerPublisher() when $default != null:
return $default(_that.id,_that.moved,_that.movedDate,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormerPublisher extends FormerPublisher {
  const _FormerPublisher({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.moved = true, @JsonKey(includeIfNull: false) this.movedDate, @NullableTimestampConverter() this.deletedAt}): super._();
  factory _FormerPublisher.fromJson(Map<String, dynamic> json) => _$FormerPublisherFromJson(json);

/// Firestore document id = the id the deleted publisher record had, which
/// is also the id of their report entries.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
/// Always true — a tombstone is only written for a departure — but stored
/// so the same rule can be applied as to a live record.
@override@JsonKey() final  bool moved;
/// `yyyy-MM-dd`; null on records archived before the date existed, which
/// read as gone throughout.
@override@JsonKey(includeIfNull: false) final  String? movedDate;
@override@NullableTimestampConverter() final  DateTime? deletedAt;

/// Create a copy of FormerPublisher
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormerPublisherCopyWith<_FormerPublisher> get copyWith => __$FormerPublisherCopyWithImpl<_FormerPublisher>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormerPublisherToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormerPublisher&&(identical(other.id, id) || other.id == id)&&(identical(other.moved, moved) || other.moved == moved)&&(identical(other.movedDate, movedDate) || other.movedDate == movedDate)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,moved,movedDate,deletedAt);

@override
String toString() {
  return 'FormerPublisher(id: $id, moved: $moved, movedDate: $movedDate, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$FormerPublisherCopyWith<$Res> implements $FormerPublisherCopyWith<$Res> {
  factory _$FormerPublisherCopyWith(_FormerPublisher value, $Res Function(_FormerPublisher) _then) = __$FormerPublisherCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, bool moved,@JsonKey(includeIfNull: false) String? movedDate,@NullableTimestampConverter() DateTime? deletedAt
});




}
/// @nodoc
class __$FormerPublisherCopyWithImpl<$Res>
    implements _$FormerPublisherCopyWith<$Res> {
  __$FormerPublisherCopyWithImpl(this._self, this._then);

  final _FormerPublisher _self;
  final $Res Function(_FormerPublisher) _then;

/// Create a copy of FormerPublisher
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? moved = null,Object? movedDate = freezed,Object? deletedAt = freezed,}) {
  return _then(_FormerPublisher(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,moved: null == moved ? _self.moved : moved // ignore: cast_nullable_to_non_nullable
as bool,movedDate: freezed == movedDate ? _self.movedDate : movedDate // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
