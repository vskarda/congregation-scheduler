// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceEntry {

@JsonKey(includeFromJson: false, includeToJson: false) String get id;/// yyyy-MM-dd
 String get date; MeetingType get meetingType;@JsonKey(includeIfNull: false) int? get inPerson;@JsonKey(includeIfNull: false) int? get online;/// Stored explicitly (not derived) so a total-only record is possible;
/// legacy docs lack this field and fall back to inPerson + online.
@JsonKey(includeIfNull: false) int? get total;
/// Create a copy of AttendanceEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceEntryCopyWith<AttendanceEntry> get copyWith => _$AttendanceEntryCopyWithImpl<AttendanceEntry>(this as AttendanceEntry, _$identity);

  /// Serializes this AttendanceEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.meetingType, meetingType) || other.meetingType == meetingType)&&(identical(other.inPerson, inPerson) || other.inPerson == inPerson)&&(identical(other.online, online) || other.online == online)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,meetingType,inPerson,online,total);

@override
String toString() {
  return 'AttendanceEntry(id: $id, date: $date, meetingType: $meetingType, inPerson: $inPerson, online: $online, total: $total)';
}


}

/// @nodoc
abstract mixin class $AttendanceEntryCopyWith<$Res>  {
  factory $AttendanceEntryCopyWith(AttendanceEntry value, $Res Function(AttendanceEntry) _then) = _$AttendanceEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String date, MeetingType meetingType,@JsonKey(includeIfNull: false) int? inPerson,@JsonKey(includeIfNull: false) int? online,@JsonKey(includeIfNull: false) int? total
});




}
/// @nodoc
class _$AttendanceEntryCopyWithImpl<$Res>
    implements $AttendanceEntryCopyWith<$Res> {
  _$AttendanceEntryCopyWithImpl(this._self, this._then);

  final AttendanceEntry _self;
  final $Res Function(AttendanceEntry) _then;

/// Create a copy of AttendanceEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? meetingType = null,Object? inPerson = freezed,Object? online = freezed,Object? total = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,meetingType: null == meetingType ? _self.meetingType : meetingType // ignore: cast_nullable_to_non_nullable
as MeetingType,inPerson: freezed == inPerson ? _self.inPerson : inPerson // ignore: cast_nullable_to_non_nullable
as int?,online: freezed == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceEntry].
extension AttendanceEntryPatterns on AttendanceEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceEntry value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String date,  MeetingType meetingType, @JsonKey(includeIfNull: false)  int? inPerson, @JsonKey(includeIfNull: false)  int? online, @JsonKey(includeIfNull: false)  int? total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceEntry() when $default != null:
return $default(_that.id,_that.date,_that.meetingType,_that.inPerson,_that.online,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String date,  MeetingType meetingType, @JsonKey(includeIfNull: false)  int? inPerson, @JsonKey(includeIfNull: false)  int? online, @JsonKey(includeIfNull: false)  int? total)  $default,) {final _that = this;
switch (_that) {
case _AttendanceEntry():
return $default(_that.id,_that.date,_that.meetingType,_that.inPerson,_that.online,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String date,  MeetingType meetingType, @JsonKey(includeIfNull: false)  int? inPerson, @JsonKey(includeIfNull: false)  int? online, @JsonKey(includeIfNull: false)  int? total)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceEntry() when $default != null:
return $default(_that.id,_that.date,_that.meetingType,_that.inPerson,_that.online,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceEntry extends AttendanceEntry {
  const _AttendanceEntry({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.date = '', this.meetingType = MeetingType.lmm, @JsonKey(includeIfNull: false) this.inPerson, @JsonKey(includeIfNull: false) this.online, @JsonKey(includeIfNull: false) this.total}): super._();
  factory _AttendanceEntry.fromJson(Map<String, dynamic> json) => _$AttendanceEntryFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
/// yyyy-MM-dd
@override@JsonKey() final  String date;
@override@JsonKey() final  MeetingType meetingType;
@override@JsonKey(includeIfNull: false) final  int? inPerson;
@override@JsonKey(includeIfNull: false) final  int? online;
/// Stored explicitly (not derived) so a total-only record is possible;
/// legacy docs lack this field and fall back to inPerson + online.
@override@JsonKey(includeIfNull: false) final  int? total;

/// Create a copy of AttendanceEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceEntryCopyWith<_AttendanceEntry> get copyWith => __$AttendanceEntryCopyWithImpl<_AttendanceEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.meetingType, meetingType) || other.meetingType == meetingType)&&(identical(other.inPerson, inPerson) || other.inPerson == inPerson)&&(identical(other.online, online) || other.online == online)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,meetingType,inPerson,online,total);

@override
String toString() {
  return 'AttendanceEntry(id: $id, date: $date, meetingType: $meetingType, inPerson: $inPerson, online: $online, total: $total)';
}


}

/// @nodoc
abstract mixin class _$AttendanceEntryCopyWith<$Res> implements $AttendanceEntryCopyWith<$Res> {
  factory _$AttendanceEntryCopyWith(_AttendanceEntry value, $Res Function(_AttendanceEntry) _then) = __$AttendanceEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String date, MeetingType meetingType,@JsonKey(includeIfNull: false) int? inPerson,@JsonKey(includeIfNull: false) int? online,@JsonKey(includeIfNull: false) int? total
});




}
/// @nodoc
class __$AttendanceEntryCopyWithImpl<$Res>
    implements _$AttendanceEntryCopyWith<$Res> {
  __$AttendanceEntryCopyWithImpl(this._self, this._then);

  final _AttendanceEntry _self;
  final $Res Function(_AttendanceEntry) _then;

/// Create a copy of AttendanceEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? meetingType = null,Object? inPerson = freezed,Object? online = freezed,Object? total = freezed,}) {
  return _then(_AttendanceEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,meetingType: null == meetingType ? _self.meetingType : meetingType // ignore: cast_nullable_to_non_nullable
as MeetingType,inPerson: freezed == inPerson ? _self.inPerson : inPerson // ignore: cast_nullable_to_non_nullable
as int?,online: freezed == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
