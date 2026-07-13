// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assignment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Assignment {

 List<String> get publisherIds; String get freeText;
/// Create a copy of Assignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignmentCopyWith<Assignment> get copyWith => _$AssignmentCopyWithImpl<Assignment>(this as Assignment, _$identity);

  /// Serializes this Assignment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Assignment&&const DeepCollectionEquality().equals(other.publisherIds, publisherIds)&&(identical(other.freeText, freeText) || other.freeText == freeText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(publisherIds),freeText);

@override
String toString() {
  return 'Assignment(publisherIds: $publisherIds, freeText: $freeText)';
}


}

/// @nodoc
abstract mixin class $AssignmentCopyWith<$Res>  {
  factory $AssignmentCopyWith(Assignment value, $Res Function(Assignment) _then) = _$AssignmentCopyWithImpl;
@useResult
$Res call({
 List<String> publisherIds, String freeText
});




}
/// @nodoc
class _$AssignmentCopyWithImpl<$Res>
    implements $AssignmentCopyWith<$Res> {
  _$AssignmentCopyWithImpl(this._self, this._then);

  final Assignment _self;
  final $Res Function(Assignment) _then;

/// Create a copy of Assignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publisherIds = null,Object? freeText = null,}) {
  return _then(_self.copyWith(
publisherIds: null == publisherIds ? _self.publisherIds : publisherIds // ignore: cast_nullable_to_non_nullable
as List<String>,freeText: null == freeText ? _self.freeText : freeText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Assignment].
extension AssignmentPatterns on Assignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Assignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Assignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Assignment value)  $default,){
final _that = this;
switch (_that) {
case _Assignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Assignment value)?  $default,){
final _that = this;
switch (_that) {
case _Assignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> publisherIds,  String freeText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Assignment() when $default != null:
return $default(_that.publisherIds,_that.freeText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> publisherIds,  String freeText)  $default,) {final _that = this;
switch (_that) {
case _Assignment():
return $default(_that.publisherIds,_that.freeText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> publisherIds,  String freeText)?  $default,) {final _that = this;
switch (_that) {
case _Assignment() when $default != null:
return $default(_that.publisherIds,_that.freeText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Assignment extends Assignment {
  const _Assignment({final  List<String> publisherIds = const <String>[], this.freeText = ''}): _publisherIds = publisherIds,super._();
  factory _Assignment.fromJson(Map<String, dynamic> json) => _$AssignmentFromJson(json);

 final  List<String> _publisherIds;
@override@JsonKey() List<String> get publisherIds {
  if (_publisherIds is EqualUnmodifiableListView) return _publisherIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_publisherIds);
}

@override@JsonKey() final  String freeText;

/// Create a copy of Assignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignmentCopyWith<_Assignment> get copyWith => __$AssignmentCopyWithImpl<_Assignment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssignmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Assignment&&const DeepCollectionEquality().equals(other._publisherIds, _publisherIds)&&(identical(other.freeText, freeText) || other.freeText == freeText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_publisherIds),freeText);

@override
String toString() {
  return 'Assignment(publisherIds: $publisherIds, freeText: $freeText)';
}


}

/// @nodoc
abstract mixin class _$AssignmentCopyWith<$Res> implements $AssignmentCopyWith<$Res> {
  factory _$AssignmentCopyWith(_Assignment value, $Res Function(_Assignment) _then) = __$AssignmentCopyWithImpl;
@override @useResult
$Res call({
 List<String> publisherIds, String freeText
});




}
/// @nodoc
class __$AssignmentCopyWithImpl<$Res>
    implements _$AssignmentCopyWith<$Res> {
  __$AssignmentCopyWithImpl(this._self, this._then);

  final _Assignment _self;
  final $Res Function(_Assignment) _then;

/// Create a copy of Assignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publisherIds = null,Object? freeText = null,}) {
  return _then(_Assignment(
publisherIds: null == publisherIds ? _self._publisherIds : publisherIds // ignore: cast_nullable_to_non_nullable
as List<String>,freeText: null == freeText ? _self.freeText : freeText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CustomAssignment {

/// Stable id linking a week's stored assignee to a permanent template
/// (see [ScheduleConfig.permanentAssignments]). Empty for one-off,
/// this-week-only custom assignments.
 String get id; String get label; Assignment get assignment;
/// Create a copy of CustomAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomAssignmentCopyWith<CustomAssignment> get copyWith => _$CustomAssignmentCopyWithImpl<CustomAssignment>(this as CustomAssignment, _$identity);

  /// Serializes this CustomAssignment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomAssignment&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.assignment, assignment) || other.assignment == assignment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,assignment);

@override
String toString() {
  return 'CustomAssignment(id: $id, label: $label, assignment: $assignment)';
}


}

/// @nodoc
abstract mixin class $CustomAssignmentCopyWith<$Res>  {
  factory $CustomAssignmentCopyWith(CustomAssignment value, $Res Function(CustomAssignment) _then) = _$CustomAssignmentCopyWithImpl;
@useResult
$Res call({
 String id, String label, Assignment assignment
});


$AssignmentCopyWith<$Res> get assignment;

}
/// @nodoc
class _$CustomAssignmentCopyWithImpl<$Res>
    implements $CustomAssignmentCopyWith<$Res> {
  _$CustomAssignmentCopyWithImpl(this._self, this._then);

  final CustomAssignment _self;
  final $Res Function(CustomAssignment) _then;

/// Create a copy of CustomAssignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? assignment = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,assignment: null == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as Assignment,
  ));
}
/// Create a copy of CustomAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assignment {
  
  return $AssignmentCopyWith<$Res>(_self.assignment, (value) {
    return _then(_self.copyWith(assignment: value));
  });
}
}


/// Adds pattern-matching-related methods to [CustomAssignment].
extension CustomAssignmentPatterns on CustomAssignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomAssignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomAssignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomAssignment value)  $default,){
final _that = this;
switch (_that) {
case _CustomAssignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomAssignment value)?  $default,){
final _that = this;
switch (_that) {
case _CustomAssignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  Assignment assignment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomAssignment() when $default != null:
return $default(_that.id,_that.label,_that.assignment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  Assignment assignment)  $default,) {final _that = this;
switch (_that) {
case _CustomAssignment():
return $default(_that.id,_that.label,_that.assignment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  Assignment assignment)?  $default,) {final _that = this;
switch (_that) {
case _CustomAssignment() when $default != null:
return $default(_that.id,_that.label,_that.assignment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomAssignment implements CustomAssignment {
  const _CustomAssignment({this.id = '', this.label = '', this.assignment = const Assignment()});
  factory _CustomAssignment.fromJson(Map<String, dynamic> json) => _$CustomAssignmentFromJson(json);

/// Stable id linking a week's stored assignee to a permanent template
/// (see [ScheduleConfig.permanentAssignments]). Empty for one-off,
/// this-week-only custom assignments.
@override@JsonKey() final  String id;
@override@JsonKey() final  String label;
@override@JsonKey() final  Assignment assignment;

/// Create a copy of CustomAssignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomAssignmentCopyWith<_CustomAssignment> get copyWith => __$CustomAssignmentCopyWithImpl<_CustomAssignment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomAssignmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomAssignment&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.assignment, assignment) || other.assignment == assignment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,assignment);

@override
String toString() {
  return 'CustomAssignment(id: $id, label: $label, assignment: $assignment)';
}


}

/// @nodoc
abstract mixin class _$CustomAssignmentCopyWith<$Res> implements $CustomAssignmentCopyWith<$Res> {
  factory _$CustomAssignmentCopyWith(_CustomAssignment value, $Res Function(_CustomAssignment) _then) = __$CustomAssignmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, Assignment assignment
});


@override $AssignmentCopyWith<$Res> get assignment;

}
/// @nodoc
class __$CustomAssignmentCopyWithImpl<$Res>
    implements _$CustomAssignmentCopyWith<$Res> {
  __$CustomAssignmentCopyWithImpl(this._self, this._then);

  final _CustomAssignment _self;
  final $Res Function(_CustomAssignment) _then;

/// Create a copy of CustomAssignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? assignment = null,}) {
  return _then(_CustomAssignment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,assignment: null == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as Assignment,
  ));
}

/// Create a copy of CustomAssignment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assignment {
  
  return $AssignmentCopyWith<$Res>(_self.assignment, (value) {
    return _then(_self.copyWith(assignment: value));
  });
}
}

// dart format on
