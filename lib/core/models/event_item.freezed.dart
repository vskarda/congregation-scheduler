// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventItem {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get title; EventType get type;/// yyyy-MM-dd (inclusive range; single-day events leave dateTo empty)
 String get dateFrom; String get dateTo; String get location; String get notes;
/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventItemCopyWith<EventItem> get copyWith => _$EventItemCopyWithImpl<EventItem>(this as EventItem, _$identity);

  /// Serializes this EventItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.location, location) || other.location == location)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,type,dateFrom,dateTo,location,notes);

@override
String toString() {
  return 'EventItem(id: $id, title: $title, type: $type, dateFrom: $dateFrom, dateTo: $dateTo, location: $location, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $EventItemCopyWith<$Res>  {
  factory $EventItemCopyWith(EventItem value, $Res Function(EventItem) _then) = _$EventItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String title, EventType type, String dateFrom, String dateTo, String location, String notes
});




}
/// @nodoc
class _$EventItemCopyWithImpl<$Res>
    implements $EventItemCopyWith<$Res> {
  _$EventItemCopyWithImpl(this._self, this._then);

  final EventItem _self;
  final $Res Function(EventItem) _then;

/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? type = null,Object? dateFrom = null,Object? dateTo = null,Object? location = null,Object? notes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EventType,dateFrom: null == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as String,dateTo: null == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EventItem].
extension EventItemPatterns on EventItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventItem value)  $default,){
final _that = this;
switch (_that) {
case _EventItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventItem value)?  $default,){
final _that = this;
switch (_that) {
case _EventItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String title,  EventType type,  String dateFrom,  String dateTo,  String location,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventItem() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.dateFrom,_that.dateTo,_that.location,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String title,  EventType type,  String dateFrom,  String dateTo,  String location,  String notes)  $default,) {final _that = this;
switch (_that) {
case _EventItem():
return $default(_that.id,_that.title,_that.type,_that.dateFrom,_that.dateTo,_that.location,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String title,  EventType type,  String dateFrom,  String dateTo,  String location,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _EventItem() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.dateFrom,_that.dateTo,_that.location,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventItem implements EventItem {
  const _EventItem({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.title = '', this.type = EventType.other, this.dateFrom = '', this.dateTo = '', this.location = '', this.notes = ''});
  factory _EventItem.fromJson(Map<String, dynamic> json) => _$EventItemFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  String title;
@override@JsonKey() final  EventType type;
/// yyyy-MM-dd (inclusive range; single-day events leave dateTo empty)
@override@JsonKey() final  String dateFrom;
@override@JsonKey() final  String dateTo;
@override@JsonKey() final  String location;
@override@JsonKey() final  String notes;

/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventItemCopyWith<_EventItem> get copyWith => __$EventItemCopyWithImpl<_EventItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.location, location) || other.location == location)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,type,dateFrom,dateTo,location,notes);

@override
String toString() {
  return 'EventItem(id: $id, title: $title, type: $type, dateFrom: $dateFrom, dateTo: $dateTo, location: $location, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$EventItemCopyWith<$Res> implements $EventItemCopyWith<$Res> {
  factory _$EventItemCopyWith(_EventItem value, $Res Function(_EventItem) _then) = __$EventItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String title, EventType type, String dateFrom, String dateTo, String location, String notes
});




}
/// @nodoc
class __$EventItemCopyWithImpl<$Res>
    implements _$EventItemCopyWith<$Res> {
  __$EventItemCopyWithImpl(this._self, this._then);

  final _EventItem _self;
  final $Res Function(_EventItem) _then;

/// Create a copy of EventItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? type = null,Object? dateFrom = null,Object? dateTo = null,Object? location = null,Object? notes = null,}) {
  return _then(_EventItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EventType,dateFrom: null == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as String,dateTo: null == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
