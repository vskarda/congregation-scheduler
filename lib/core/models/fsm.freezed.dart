// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fsm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FsmRecurring {

@JsonKey(includeFromJson: false, includeToJson: false) String get id;/// DateTime.monday..sunday (1..7)
 int get weekday; String get time; String get location; Assignment get defaultAssignment;/// yyyy-MM-dd
 String get validFrom; String get validUntil;
/// Create a copy of FsmRecurring
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FsmRecurringCopyWith<FsmRecurring> get copyWith => _$FsmRecurringCopyWithImpl<FsmRecurring>(this as FsmRecurring, _$identity);

  /// Serializes this FsmRecurring to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FsmRecurring&&(identical(other.id, id) || other.id == id)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.time, time) || other.time == time)&&(identical(other.location, location) || other.location == location)&&(identical(other.defaultAssignment, defaultAssignment) || other.defaultAssignment == defaultAssignment)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weekday,time,location,defaultAssignment,validFrom,validUntil);

@override
String toString() {
  return 'FsmRecurring(id: $id, weekday: $weekday, time: $time, location: $location, defaultAssignment: $defaultAssignment, validFrom: $validFrom, validUntil: $validUntil)';
}


}

/// @nodoc
abstract mixin class $FsmRecurringCopyWith<$Res>  {
  factory $FsmRecurringCopyWith(FsmRecurring value, $Res Function(FsmRecurring) _then) = _$FsmRecurringCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, int weekday, String time, String location, Assignment defaultAssignment, String validFrom, String validUntil
});


$AssignmentCopyWith<$Res> get defaultAssignment;

}
/// @nodoc
class _$FsmRecurringCopyWithImpl<$Res>
    implements $FsmRecurringCopyWith<$Res> {
  _$FsmRecurringCopyWithImpl(this._self, this._then);

  final FsmRecurring _self;
  final $Res Function(FsmRecurring) _then;

/// Create a copy of FsmRecurring
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? weekday = null,Object? time = null,Object? location = null,Object? defaultAssignment = null,Object? validFrom = null,Object? validUntil = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,defaultAssignment: null == defaultAssignment ? _self.defaultAssignment : defaultAssignment // ignore: cast_nullable_to_non_nullable
as Assignment,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as String,validUntil: null == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of FsmRecurring
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get defaultAssignment {
  
  return $AssignmentCopyWith<$Res>(_self.defaultAssignment, (value) {
    return _then(_self.copyWith(defaultAssignment: value));
  });
}
}


/// Adds pattern-matching-related methods to [FsmRecurring].
extension FsmRecurringPatterns on FsmRecurring {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FsmRecurring value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FsmRecurring() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FsmRecurring value)  $default,){
final _that = this;
switch (_that) {
case _FsmRecurring():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FsmRecurring value)?  $default,){
final _that = this;
switch (_that) {
case _FsmRecurring() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  int weekday,  String time,  String location,  Assignment defaultAssignment,  String validFrom,  String validUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FsmRecurring() when $default != null:
return $default(_that.id,_that.weekday,_that.time,_that.location,_that.defaultAssignment,_that.validFrom,_that.validUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  int weekday,  String time,  String location,  Assignment defaultAssignment,  String validFrom,  String validUntil)  $default,) {final _that = this;
switch (_that) {
case _FsmRecurring():
return $default(_that.id,_that.weekday,_that.time,_that.location,_that.defaultAssignment,_that.validFrom,_that.validUntil);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  int weekday,  String time,  String location,  Assignment defaultAssignment,  String validFrom,  String validUntil)?  $default,) {final _that = this;
switch (_that) {
case _FsmRecurring() when $default != null:
return $default(_that.id,_that.weekday,_that.time,_that.location,_that.defaultAssignment,_that.validFrom,_that.validUntil);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FsmRecurring implements FsmRecurring {
  const _FsmRecurring({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.weekday = DateTime.saturday, this.time = '09:00', this.location = '', this.defaultAssignment = const Assignment(), this.validFrom = '', this.validUntil = ''});
  factory _FsmRecurring.fromJson(Map<String, dynamic> json) => _$FsmRecurringFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
/// DateTime.monday..sunday (1..7)
@override@JsonKey() final  int weekday;
@override@JsonKey() final  String time;
@override@JsonKey() final  String location;
@override@JsonKey() final  Assignment defaultAssignment;
/// yyyy-MM-dd
@override@JsonKey() final  String validFrom;
@override@JsonKey() final  String validUntil;

/// Create a copy of FsmRecurring
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FsmRecurringCopyWith<_FsmRecurring> get copyWith => __$FsmRecurringCopyWithImpl<_FsmRecurring>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FsmRecurringToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FsmRecurring&&(identical(other.id, id) || other.id == id)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.time, time) || other.time == time)&&(identical(other.location, location) || other.location == location)&&(identical(other.defaultAssignment, defaultAssignment) || other.defaultAssignment == defaultAssignment)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weekday,time,location,defaultAssignment,validFrom,validUntil);

@override
String toString() {
  return 'FsmRecurring(id: $id, weekday: $weekday, time: $time, location: $location, defaultAssignment: $defaultAssignment, validFrom: $validFrom, validUntil: $validUntil)';
}


}

/// @nodoc
abstract mixin class _$FsmRecurringCopyWith<$Res> implements $FsmRecurringCopyWith<$Res> {
  factory _$FsmRecurringCopyWith(_FsmRecurring value, $Res Function(_FsmRecurring) _then) = __$FsmRecurringCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, int weekday, String time, String location, Assignment defaultAssignment, String validFrom, String validUntil
});


@override $AssignmentCopyWith<$Res> get defaultAssignment;

}
/// @nodoc
class __$FsmRecurringCopyWithImpl<$Res>
    implements _$FsmRecurringCopyWith<$Res> {
  __$FsmRecurringCopyWithImpl(this._self, this._then);

  final _FsmRecurring _self;
  final $Res Function(_FsmRecurring) _then;

/// Create a copy of FsmRecurring
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? weekday = null,Object? time = null,Object? location = null,Object? defaultAssignment = null,Object? validFrom = null,Object? validUntil = null,}) {
  return _then(_FsmRecurring(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,defaultAssignment: null == defaultAssignment ? _self.defaultAssignment : defaultAssignment // ignore: cast_nullable_to_non_nullable
as Assignment,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as String,validUntil: null == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of FsmRecurring
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get defaultAssignment {
  
  return $AssignmentCopyWith<$Res>(_self.defaultAssignment, (value) {
    return _then(_self.copyWith(defaultAssignment: value));
  });
}
}


/// @nodoc
mixin _$FsmMeeting {

@JsonKey(includeFromJson: false, includeToJson: false) String get id;/// yyyy-MM-dd
 String get date; String get time; String get location; Assignment get assignment;/// Set when this meeting was generated from a recurring rule.
 String get recurringId;/// A "deleted" recurring instance is kept as cancelled so the
/// materializer doesn't recreate it.
 bool get cancelled; List<String> get allAssigneeIds;
/// Create a copy of FsmMeeting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FsmMeetingCopyWith<FsmMeeting> get copyWith => _$FsmMeetingCopyWithImpl<FsmMeeting>(this as FsmMeeting, _$identity);

  /// Serializes this FsmMeeting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FsmMeeting&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.location, location) || other.location == location)&&(identical(other.assignment, assignment) || other.assignment == assignment)&&(identical(other.recurringId, recurringId) || other.recurringId == recurringId)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&const DeepCollectionEquality().equals(other.allAssigneeIds, allAssigneeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,time,location,assignment,recurringId,cancelled,const DeepCollectionEquality().hash(allAssigneeIds));

@override
String toString() {
  return 'FsmMeeting(id: $id, date: $date, time: $time, location: $location, assignment: $assignment, recurringId: $recurringId, cancelled: $cancelled, allAssigneeIds: $allAssigneeIds)';
}


}

/// @nodoc
abstract mixin class $FsmMeetingCopyWith<$Res>  {
  factory $FsmMeetingCopyWith(FsmMeeting value, $Res Function(FsmMeeting) _then) = _$FsmMeetingCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String date, String time, String location, Assignment assignment, String recurringId, bool cancelled, List<String> allAssigneeIds
});


$AssignmentCopyWith<$Res> get assignment;

}
/// @nodoc
class _$FsmMeetingCopyWithImpl<$Res>
    implements $FsmMeetingCopyWith<$Res> {
  _$FsmMeetingCopyWithImpl(this._self, this._then);

  final FsmMeeting _self;
  final $Res Function(FsmMeeting) _then;

/// Create a copy of FsmMeeting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? time = null,Object? location = null,Object? assignment = null,Object? recurringId = null,Object? cancelled = null,Object? allAssigneeIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,assignment: null == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as Assignment,recurringId: null == recurringId ? _self.recurringId : recurringId // ignore: cast_nullable_to_non_nullable
as String,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as bool,allAssigneeIds: null == allAssigneeIds ? _self.allAssigneeIds : allAssigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of FsmMeeting
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assignment {
  
  return $AssignmentCopyWith<$Res>(_self.assignment, (value) {
    return _then(_self.copyWith(assignment: value));
  });
}
}


/// Adds pattern-matching-related methods to [FsmMeeting].
extension FsmMeetingPatterns on FsmMeeting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FsmMeeting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FsmMeeting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FsmMeeting value)  $default,){
final _that = this;
switch (_that) {
case _FsmMeeting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FsmMeeting value)?  $default,){
final _that = this;
switch (_that) {
case _FsmMeeting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String date,  String time,  String location,  Assignment assignment,  String recurringId,  bool cancelled,  List<String> allAssigneeIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FsmMeeting() when $default != null:
return $default(_that.id,_that.date,_that.time,_that.location,_that.assignment,_that.recurringId,_that.cancelled,_that.allAssigneeIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String date,  String time,  String location,  Assignment assignment,  String recurringId,  bool cancelled,  List<String> allAssigneeIds)  $default,) {final _that = this;
switch (_that) {
case _FsmMeeting():
return $default(_that.id,_that.date,_that.time,_that.location,_that.assignment,_that.recurringId,_that.cancelled,_that.allAssigneeIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String date,  String time,  String location,  Assignment assignment,  String recurringId,  bool cancelled,  List<String> allAssigneeIds)?  $default,) {final _that = this;
switch (_that) {
case _FsmMeeting() when $default != null:
return $default(_that.id,_that.date,_that.time,_that.location,_that.assignment,_that.recurringId,_that.cancelled,_that.allAssigneeIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FsmMeeting extends FsmMeeting {
  const _FsmMeeting({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.date = '', this.time = '09:00', this.location = '', this.assignment = const Assignment(), this.recurringId = '', this.cancelled = false, final  List<String> allAssigneeIds = const <String>[]}): _allAssigneeIds = allAssigneeIds,super._();
  factory _FsmMeeting.fromJson(Map<String, dynamic> json) => _$FsmMeetingFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
/// yyyy-MM-dd
@override@JsonKey() final  String date;
@override@JsonKey() final  String time;
@override@JsonKey() final  String location;
@override@JsonKey() final  Assignment assignment;
/// Set when this meeting was generated from a recurring rule.
@override@JsonKey() final  String recurringId;
/// A "deleted" recurring instance is kept as cancelled so the
/// materializer doesn't recreate it.
@override@JsonKey() final  bool cancelled;
 final  List<String> _allAssigneeIds;
@override@JsonKey() List<String> get allAssigneeIds {
  if (_allAssigneeIds is EqualUnmodifiableListView) return _allAssigneeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allAssigneeIds);
}


/// Create a copy of FsmMeeting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FsmMeetingCopyWith<_FsmMeeting> get copyWith => __$FsmMeetingCopyWithImpl<_FsmMeeting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FsmMeetingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FsmMeeting&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.location, location) || other.location == location)&&(identical(other.assignment, assignment) || other.assignment == assignment)&&(identical(other.recurringId, recurringId) || other.recurringId == recurringId)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&const DeepCollectionEquality().equals(other._allAssigneeIds, _allAssigneeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,time,location,assignment,recurringId,cancelled,const DeepCollectionEquality().hash(_allAssigneeIds));

@override
String toString() {
  return 'FsmMeeting(id: $id, date: $date, time: $time, location: $location, assignment: $assignment, recurringId: $recurringId, cancelled: $cancelled, allAssigneeIds: $allAssigneeIds)';
}


}

/// @nodoc
abstract mixin class _$FsmMeetingCopyWith<$Res> implements $FsmMeetingCopyWith<$Res> {
  factory _$FsmMeetingCopyWith(_FsmMeeting value, $Res Function(_FsmMeeting) _then) = __$FsmMeetingCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String date, String time, String location, Assignment assignment, String recurringId, bool cancelled, List<String> allAssigneeIds
});


@override $AssignmentCopyWith<$Res> get assignment;

}
/// @nodoc
class __$FsmMeetingCopyWithImpl<$Res>
    implements _$FsmMeetingCopyWith<$Res> {
  __$FsmMeetingCopyWithImpl(this._self, this._then);

  final _FsmMeeting _self;
  final $Res Function(_FsmMeeting) _then;

/// Create a copy of FsmMeeting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? time = null,Object? location = null,Object? assignment = null,Object? recurringId = null,Object? cancelled = null,Object? allAssigneeIds = null,}) {
  return _then(_FsmMeeting(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,assignment: null == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as Assignment,recurringId: null == recurringId ? _self.recurringId : recurringId // ignore: cast_nullable_to_non_nullable
as String,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as bool,allAssigneeIds: null == allAssigneeIds ? _self._allAssigneeIds : allAssigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of FsmMeeting
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
