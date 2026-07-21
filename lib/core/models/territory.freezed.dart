// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'territory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Territory {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get name;/// Link to a map (e.g. Google My Maps).
 String get mapUrl; String get notes;
/// Create a copy of Territory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TerritoryCopyWith<Territory> get copyWith => _$TerritoryCopyWithImpl<Territory>(this as Territory, _$identity);

  /// Serializes this Territory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Territory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mapUrl, mapUrl) || other.mapUrl == mapUrl)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mapUrl,notes);

@override
String toString() {
  return 'Territory(id: $id, name: $name, mapUrl: $mapUrl, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $TerritoryCopyWith<$Res>  {
  factory $TerritoryCopyWith(Territory value, $Res Function(Territory) _then) = _$TerritoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String name, String mapUrl, String notes
});




}
/// @nodoc
class _$TerritoryCopyWithImpl<$Res>
    implements $TerritoryCopyWith<$Res> {
  _$TerritoryCopyWithImpl(this._self, this._then);

  final Territory _self;
  final $Res Function(Territory) _then;

/// Create a copy of Territory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? mapUrl = null,Object? notes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mapUrl: null == mapUrl ? _self.mapUrl : mapUrl // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Territory].
extension TerritoryPatterns on Territory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Territory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Territory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Territory value)  $default,){
final _that = this;
switch (_that) {
case _Territory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Territory value)?  $default,){
final _that = this;
switch (_that) {
case _Territory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String name,  String mapUrl,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Territory() when $default != null:
return $default(_that.id,_that.name,_that.mapUrl,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String name,  String mapUrl,  String notes)  $default,) {final _that = this;
switch (_that) {
case _Territory():
return $default(_that.id,_that.name,_that.mapUrl,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String name,  String mapUrl,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _Territory() when $default != null:
return $default(_that.id,_that.name,_that.mapUrl,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Territory implements Territory {
  const _Territory({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.name = '', this.mapUrl = '', this.notes = ''});
  factory _Territory.fromJson(Map<String, dynamic> json) => _$TerritoryFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  String name;
/// Link to a map (e.g. Google My Maps).
@override@JsonKey() final  String mapUrl;
@override@JsonKey() final  String notes;

/// Create a copy of Territory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TerritoryCopyWith<_Territory> get copyWith => __$TerritoryCopyWithImpl<_Territory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TerritoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Territory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mapUrl, mapUrl) || other.mapUrl == mapUrl)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mapUrl,notes);

@override
String toString() {
  return 'Territory(id: $id, name: $name, mapUrl: $mapUrl, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$TerritoryCopyWith<$Res> implements $TerritoryCopyWith<$Res> {
  factory _$TerritoryCopyWith(_Territory value, $Res Function(_Territory) _then) = __$TerritoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String name, String mapUrl, String notes
});




}
/// @nodoc
class __$TerritoryCopyWithImpl<$Res>
    implements _$TerritoryCopyWith<$Res> {
  __$TerritoryCopyWithImpl(this._self, this._then);

  final _Territory _self;
  final $Res Function(_Territory) _then;

/// Create a copy of Territory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? mapUrl = null,Object? notes = null,}) {
  return _then(_Territory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mapUrl: null == mapUrl ? _self.mapUrl : mapUrl // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TerritoryAssignment {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get territoryId; String get publisherId;/// yyyy-MM-dd
 String get assignedDate; String get returnedDate; String get returnNotes;
/// Create a copy of TerritoryAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TerritoryAssignmentCopyWith<TerritoryAssignment> get copyWith => _$TerritoryAssignmentCopyWithImpl<TerritoryAssignment>(this as TerritoryAssignment, _$identity);

  /// Serializes this TerritoryAssignment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TerritoryAssignment&&(identical(other.id, id) || other.id == id)&&(identical(other.territoryId, territoryId) || other.territoryId == territoryId)&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId)&&(identical(other.assignedDate, assignedDate) || other.assignedDate == assignedDate)&&(identical(other.returnedDate, returnedDate) || other.returnedDate == returnedDate)&&(identical(other.returnNotes, returnNotes) || other.returnNotes == returnNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,territoryId,publisherId,assignedDate,returnedDate,returnNotes);

@override
String toString() {
  return 'TerritoryAssignment(id: $id, territoryId: $territoryId, publisherId: $publisherId, assignedDate: $assignedDate, returnedDate: $returnedDate, returnNotes: $returnNotes)';
}


}

/// @nodoc
abstract mixin class $TerritoryAssignmentCopyWith<$Res>  {
  factory $TerritoryAssignmentCopyWith(TerritoryAssignment value, $Res Function(TerritoryAssignment) _then) = _$TerritoryAssignmentCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String territoryId, String publisherId, String assignedDate, String returnedDate, String returnNotes
});




}
/// @nodoc
class _$TerritoryAssignmentCopyWithImpl<$Res>
    implements $TerritoryAssignmentCopyWith<$Res> {
  _$TerritoryAssignmentCopyWithImpl(this._self, this._then);

  final TerritoryAssignment _self;
  final $Res Function(TerritoryAssignment) _then;

/// Create a copy of TerritoryAssignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? territoryId = null,Object? publisherId = null,Object? assignedDate = null,Object? returnedDate = null,Object? returnNotes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,territoryId: null == territoryId ? _self.territoryId : territoryId // ignore: cast_nullable_to_non_nullable
as String,publisherId: null == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String,assignedDate: null == assignedDate ? _self.assignedDate : assignedDate // ignore: cast_nullable_to_non_nullable
as String,returnedDate: null == returnedDate ? _self.returnedDate : returnedDate // ignore: cast_nullable_to_non_nullable
as String,returnNotes: null == returnNotes ? _self.returnNotes : returnNotes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TerritoryAssignment].
extension TerritoryAssignmentPatterns on TerritoryAssignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TerritoryAssignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TerritoryAssignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TerritoryAssignment value)  $default,){
final _that = this;
switch (_that) {
case _TerritoryAssignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TerritoryAssignment value)?  $default,){
final _that = this;
switch (_that) {
case _TerritoryAssignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String territoryId,  String publisherId,  String assignedDate,  String returnedDate,  String returnNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TerritoryAssignment() when $default != null:
return $default(_that.id,_that.territoryId,_that.publisherId,_that.assignedDate,_that.returnedDate,_that.returnNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String territoryId,  String publisherId,  String assignedDate,  String returnedDate,  String returnNotes)  $default,) {final _that = this;
switch (_that) {
case _TerritoryAssignment():
return $default(_that.id,_that.territoryId,_that.publisherId,_that.assignedDate,_that.returnedDate,_that.returnNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String territoryId,  String publisherId,  String assignedDate,  String returnedDate,  String returnNotes)?  $default,) {final _that = this;
switch (_that) {
case _TerritoryAssignment() when $default != null:
return $default(_that.id,_that.territoryId,_that.publisherId,_that.assignedDate,_that.returnedDate,_that.returnNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TerritoryAssignment extends TerritoryAssignment {
  const _TerritoryAssignment({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.territoryId = '', this.publisherId = '', this.assignedDate = '', this.returnedDate = '', this.returnNotes = ''}): super._();
  factory _TerritoryAssignment.fromJson(Map<String, dynamic> json) => _$TerritoryAssignmentFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  String territoryId;
@override@JsonKey() final  String publisherId;
/// yyyy-MM-dd
@override@JsonKey() final  String assignedDate;
@override@JsonKey() final  String returnedDate;
@override@JsonKey() final  String returnNotes;

/// Create a copy of TerritoryAssignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TerritoryAssignmentCopyWith<_TerritoryAssignment> get copyWith => __$TerritoryAssignmentCopyWithImpl<_TerritoryAssignment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TerritoryAssignmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TerritoryAssignment&&(identical(other.id, id) || other.id == id)&&(identical(other.territoryId, territoryId) || other.territoryId == territoryId)&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId)&&(identical(other.assignedDate, assignedDate) || other.assignedDate == assignedDate)&&(identical(other.returnedDate, returnedDate) || other.returnedDate == returnedDate)&&(identical(other.returnNotes, returnNotes) || other.returnNotes == returnNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,territoryId,publisherId,assignedDate,returnedDate,returnNotes);

@override
String toString() {
  return 'TerritoryAssignment(id: $id, territoryId: $territoryId, publisherId: $publisherId, assignedDate: $assignedDate, returnedDate: $returnedDate, returnNotes: $returnNotes)';
}


}

/// @nodoc
abstract mixin class _$TerritoryAssignmentCopyWith<$Res> implements $TerritoryAssignmentCopyWith<$Res> {
  factory _$TerritoryAssignmentCopyWith(_TerritoryAssignment value, $Res Function(_TerritoryAssignment) _then) = __$TerritoryAssignmentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String territoryId, String publisherId, String assignedDate, String returnedDate, String returnNotes
});




}
/// @nodoc
class __$TerritoryAssignmentCopyWithImpl<$Res>
    implements _$TerritoryAssignmentCopyWith<$Res> {
  __$TerritoryAssignmentCopyWithImpl(this._self, this._then);

  final _TerritoryAssignment _self;
  final $Res Function(_TerritoryAssignment) _then;

/// Create a copy of TerritoryAssignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? territoryId = null,Object? publisherId = null,Object? assignedDate = null,Object? returnedDate = null,Object? returnNotes = null,}) {
  return _then(_TerritoryAssignment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,territoryId: null == territoryId ? _self.territoryId : territoryId // ignore: cast_nullable_to_non_nullable
as String,publisherId: null == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String,assignedDate: null == assignedDate ? _self.assignedDate : assignedDate // ignore: cast_nullable_to_non_nullable
as String,returnedDate: null == returnedDate ? _self.returnedDate : returnedDate // ignore: cast_nullable_to_non_nullable
as String,returnNotes: null == returnNotes ? _self.returnNotes : returnNotes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
