// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pw.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PwRecurring {

@JsonKey(includeFromJson: false, includeToJson: false) String get id;/// DateTime.monday..sunday (1..7)
 int get weekday; String get startTime; String get endTime; String get location; Assignment get defaultAssignment;/// yyyy-MM-dd
 String get validFrom; String get validUntil;
/// Create a copy of PwRecurring
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PwRecurringCopyWith<PwRecurring> get copyWith => _$PwRecurringCopyWithImpl<PwRecurring>(this as PwRecurring, _$identity);

  /// Serializes this PwRecurring to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PwRecurring&&(identical(other.id, id) || other.id == id)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.location, location) || other.location == location)&&(identical(other.defaultAssignment, defaultAssignment) || other.defaultAssignment == defaultAssignment)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weekday,startTime,endTime,location,defaultAssignment,validFrom,validUntil);

@override
String toString() {
  return 'PwRecurring(id: $id, weekday: $weekday, startTime: $startTime, endTime: $endTime, location: $location, defaultAssignment: $defaultAssignment, validFrom: $validFrom, validUntil: $validUntil)';
}


}

/// @nodoc
abstract mixin class $PwRecurringCopyWith<$Res>  {
  factory $PwRecurringCopyWith(PwRecurring value, $Res Function(PwRecurring) _then) = _$PwRecurringCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, int weekday, String startTime, String endTime, String location, Assignment defaultAssignment, String validFrom, String validUntil
});


$AssignmentCopyWith<$Res> get defaultAssignment;

}
/// @nodoc
class _$PwRecurringCopyWithImpl<$Res>
    implements $PwRecurringCopyWith<$Res> {
  _$PwRecurringCopyWithImpl(this._self, this._then);

  final PwRecurring _self;
  final $Res Function(PwRecurring) _then;

/// Create a copy of PwRecurring
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? weekday = null,Object? startTime = null,Object? endTime = null,Object? location = null,Object? defaultAssignment = null,Object? validFrom = null,Object? validUntil = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,defaultAssignment: null == defaultAssignment ? _self.defaultAssignment : defaultAssignment // ignore: cast_nullable_to_non_nullable
as Assignment,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as String,validUntil: null == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of PwRecurring
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get defaultAssignment {
  
  return $AssignmentCopyWith<$Res>(_self.defaultAssignment, (value) {
    return _then(_self.copyWith(defaultAssignment: value));
  });
}
}


/// Adds pattern-matching-related methods to [PwRecurring].
extension PwRecurringPatterns on PwRecurring {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PwRecurring value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PwRecurring() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PwRecurring value)  $default,){
final _that = this;
switch (_that) {
case _PwRecurring():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PwRecurring value)?  $default,){
final _that = this;
switch (_that) {
case _PwRecurring() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  int weekday,  String startTime,  String endTime,  String location,  Assignment defaultAssignment,  String validFrom,  String validUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PwRecurring() when $default != null:
return $default(_that.id,_that.weekday,_that.startTime,_that.endTime,_that.location,_that.defaultAssignment,_that.validFrom,_that.validUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  int weekday,  String startTime,  String endTime,  String location,  Assignment defaultAssignment,  String validFrom,  String validUntil)  $default,) {final _that = this;
switch (_that) {
case _PwRecurring():
return $default(_that.id,_that.weekday,_that.startTime,_that.endTime,_that.location,_that.defaultAssignment,_that.validFrom,_that.validUntil);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  int weekday,  String startTime,  String endTime,  String location,  Assignment defaultAssignment,  String validFrom,  String validUntil)?  $default,) {final _that = this;
switch (_that) {
case _PwRecurring() when $default != null:
return $default(_that.id,_that.weekday,_that.startTime,_that.endTime,_that.location,_that.defaultAssignment,_that.validFrom,_that.validUntil);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PwRecurring implements PwRecurring {
  const _PwRecurring({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.weekday = DateTime.saturday, this.startTime = '09:00', this.endTime = '11:00', this.location = '', this.defaultAssignment = const Assignment(), this.validFrom = '', this.validUntil = ''});
  factory _PwRecurring.fromJson(Map<String, dynamic> json) => _$PwRecurringFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
/// DateTime.monday..sunday (1..7)
@override@JsonKey() final  int weekday;
@override@JsonKey() final  String startTime;
@override@JsonKey() final  String endTime;
@override@JsonKey() final  String location;
@override@JsonKey() final  Assignment defaultAssignment;
/// yyyy-MM-dd
@override@JsonKey() final  String validFrom;
@override@JsonKey() final  String validUntil;

/// Create a copy of PwRecurring
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PwRecurringCopyWith<_PwRecurring> get copyWith => __$PwRecurringCopyWithImpl<_PwRecurring>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PwRecurringToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PwRecurring&&(identical(other.id, id) || other.id == id)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.location, location) || other.location == location)&&(identical(other.defaultAssignment, defaultAssignment) || other.defaultAssignment == defaultAssignment)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weekday,startTime,endTime,location,defaultAssignment,validFrom,validUntil);

@override
String toString() {
  return 'PwRecurring(id: $id, weekday: $weekday, startTime: $startTime, endTime: $endTime, location: $location, defaultAssignment: $defaultAssignment, validFrom: $validFrom, validUntil: $validUntil)';
}


}

/// @nodoc
abstract mixin class _$PwRecurringCopyWith<$Res> implements $PwRecurringCopyWith<$Res> {
  factory _$PwRecurringCopyWith(_PwRecurring value, $Res Function(_PwRecurring) _then) = __$PwRecurringCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, int weekday, String startTime, String endTime, String location, Assignment defaultAssignment, String validFrom, String validUntil
});


@override $AssignmentCopyWith<$Res> get defaultAssignment;

}
/// @nodoc
class __$PwRecurringCopyWithImpl<$Res>
    implements _$PwRecurringCopyWith<$Res> {
  __$PwRecurringCopyWithImpl(this._self, this._then);

  final _PwRecurring _self;
  final $Res Function(_PwRecurring) _then;

/// Create a copy of PwRecurring
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? weekday = null,Object? startTime = null,Object? endTime = null,Object? location = null,Object? defaultAssignment = null,Object? validFrom = null,Object? validUntil = null,}) {
  return _then(_PwRecurring(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,defaultAssignment: null == defaultAssignment ? _self.defaultAssignment : defaultAssignment // ignore: cast_nullable_to_non_nullable
as Assignment,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as String,validUntil: null == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PwRecurring
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
mixin _$PwSlot {

@JsonKey(includeFromJson: false, includeToJson: false) String get id;/// yyyy-MM-dd
 String get date; String get startTime; String get endTime; String get location; Assignment get assignment;/// Set when this slot was generated from a recurring rule.
 String get recurringId;/// A "deleted" recurring instance is kept as cancelled so the
/// materializer doesn't recreate it.
 bool get cancelled; List<String> get allAssigneeIds;
/// Create a copy of PwSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PwSlotCopyWith<PwSlot> get copyWith => _$PwSlotCopyWithImpl<PwSlot>(this as PwSlot, _$identity);

  /// Serializes this PwSlot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PwSlot&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.location, location) || other.location == location)&&(identical(other.assignment, assignment) || other.assignment == assignment)&&(identical(other.recurringId, recurringId) || other.recurringId == recurringId)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&const DeepCollectionEquality().equals(other.allAssigneeIds, allAssigneeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,startTime,endTime,location,assignment,recurringId,cancelled,const DeepCollectionEquality().hash(allAssigneeIds));

@override
String toString() {
  return 'PwSlot(id: $id, date: $date, startTime: $startTime, endTime: $endTime, location: $location, assignment: $assignment, recurringId: $recurringId, cancelled: $cancelled, allAssigneeIds: $allAssigneeIds)';
}


}

/// @nodoc
abstract mixin class $PwSlotCopyWith<$Res>  {
  factory $PwSlotCopyWith(PwSlot value, $Res Function(PwSlot) _then) = _$PwSlotCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String date, String startTime, String endTime, String location, Assignment assignment, String recurringId, bool cancelled, List<String> allAssigneeIds
});


$AssignmentCopyWith<$Res> get assignment;

}
/// @nodoc
class _$PwSlotCopyWithImpl<$Res>
    implements $PwSlotCopyWith<$Res> {
  _$PwSlotCopyWithImpl(this._self, this._then);

  final PwSlot _self;
  final $Res Function(PwSlot) _then;

/// Create a copy of PwSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? startTime = null,Object? endTime = null,Object? location = null,Object? assignment = null,Object? recurringId = null,Object? cancelled = null,Object? allAssigneeIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,assignment: null == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as Assignment,recurringId: null == recurringId ? _self.recurringId : recurringId // ignore: cast_nullable_to_non_nullable
as String,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as bool,allAssigneeIds: null == allAssigneeIds ? _self.allAssigneeIds : allAssigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of PwSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assignment {
  
  return $AssignmentCopyWith<$Res>(_self.assignment, (value) {
    return _then(_self.copyWith(assignment: value));
  });
}
}


/// Adds pattern-matching-related methods to [PwSlot].
extension PwSlotPatterns on PwSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PwSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PwSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PwSlot value)  $default,){
final _that = this;
switch (_that) {
case _PwSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PwSlot value)?  $default,){
final _that = this;
switch (_that) {
case _PwSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String date,  String startTime,  String endTime,  String location,  Assignment assignment,  String recurringId,  bool cancelled,  List<String> allAssigneeIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PwSlot() when $default != null:
return $default(_that.id,_that.date,_that.startTime,_that.endTime,_that.location,_that.assignment,_that.recurringId,_that.cancelled,_that.allAssigneeIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String date,  String startTime,  String endTime,  String location,  Assignment assignment,  String recurringId,  bool cancelled,  List<String> allAssigneeIds)  $default,) {final _that = this;
switch (_that) {
case _PwSlot():
return $default(_that.id,_that.date,_that.startTime,_that.endTime,_that.location,_that.assignment,_that.recurringId,_that.cancelled,_that.allAssigneeIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String date,  String startTime,  String endTime,  String location,  Assignment assignment,  String recurringId,  bool cancelled,  List<String> allAssigneeIds)?  $default,) {final _that = this;
switch (_that) {
case _PwSlot() when $default != null:
return $default(_that.id,_that.date,_that.startTime,_that.endTime,_that.location,_that.assignment,_that.recurringId,_that.cancelled,_that.allAssigneeIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PwSlot extends PwSlot {
  const _PwSlot({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.date = '', this.startTime = '09:00', this.endTime = '11:00', this.location = '', this.assignment = const Assignment(), this.recurringId = '', this.cancelled = false, final  List<String> allAssigneeIds = const <String>[]}): _allAssigneeIds = allAssigneeIds,super._();
  factory _PwSlot.fromJson(Map<String, dynamic> json) => _$PwSlotFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
/// yyyy-MM-dd
@override@JsonKey() final  String date;
@override@JsonKey() final  String startTime;
@override@JsonKey() final  String endTime;
@override@JsonKey() final  String location;
@override@JsonKey() final  Assignment assignment;
/// Set when this slot was generated from a recurring rule.
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


/// Create a copy of PwSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PwSlotCopyWith<_PwSlot> get copyWith => __$PwSlotCopyWithImpl<_PwSlot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PwSlotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PwSlot&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.location, location) || other.location == location)&&(identical(other.assignment, assignment) || other.assignment == assignment)&&(identical(other.recurringId, recurringId) || other.recurringId == recurringId)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&const DeepCollectionEquality().equals(other._allAssigneeIds, _allAssigneeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,startTime,endTime,location,assignment,recurringId,cancelled,const DeepCollectionEquality().hash(_allAssigneeIds));

@override
String toString() {
  return 'PwSlot(id: $id, date: $date, startTime: $startTime, endTime: $endTime, location: $location, assignment: $assignment, recurringId: $recurringId, cancelled: $cancelled, allAssigneeIds: $allAssigneeIds)';
}


}

/// @nodoc
abstract mixin class _$PwSlotCopyWith<$Res> implements $PwSlotCopyWith<$Res> {
  factory _$PwSlotCopyWith(_PwSlot value, $Res Function(_PwSlot) _then) = __$PwSlotCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String date, String startTime, String endTime, String location, Assignment assignment, String recurringId, bool cancelled, List<String> allAssigneeIds
});


@override $AssignmentCopyWith<$Res> get assignment;

}
/// @nodoc
class __$PwSlotCopyWithImpl<$Res>
    implements _$PwSlotCopyWith<$Res> {
  __$PwSlotCopyWithImpl(this._self, this._then);

  final _PwSlot _self;
  final $Res Function(_PwSlot) _then;

/// Create a copy of PwSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? startTime = null,Object? endTime = null,Object? location = null,Object? assignment = null,Object? recurringId = null,Object? cancelled = null,Object? allAssigneeIds = null,}) {
  return _then(_PwSlot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,assignment: null == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as Assignment,recurringId: null == recurringId ? _self.recurringId : recurringId // ignore: cast_nullable_to_non_nullable
as String,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as bool,allAssigneeIds: null == allAssigneeIds ? _self._allAssigneeIds : allAssigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of PwSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assignment {
  
  return $AssignmentCopyWith<$Res>(_self.assignment, (value) {
    return _then(_self.copyWith(assignment: value));
  });
}
}


/// @nodoc
mixin _$PwApplication {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get slotId;/// yyyy-MM-dd; denormalized copy of the slot date for range queries.
 String get date;/// == the applicant's auth uid.
 String get publisherId;@NullableTimestampConverter() DateTime? get appliedAt;
/// Create a copy of PwApplication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PwApplicationCopyWith<PwApplication> get copyWith => _$PwApplicationCopyWithImpl<PwApplication>(this as PwApplication, _$identity);

  /// Serializes this PwApplication to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PwApplication&&(identical(other.id, id) || other.id == id)&&(identical(other.slotId, slotId) || other.slotId == slotId)&&(identical(other.date, date) || other.date == date)&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slotId,date,publisherId,appliedAt);

@override
String toString() {
  return 'PwApplication(id: $id, slotId: $slotId, date: $date, publisherId: $publisherId, appliedAt: $appliedAt)';
}


}

/// @nodoc
abstract mixin class $PwApplicationCopyWith<$Res>  {
  factory $PwApplicationCopyWith(PwApplication value, $Res Function(PwApplication) _then) = _$PwApplicationCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String slotId, String date, String publisherId,@NullableTimestampConverter() DateTime? appliedAt
});




}
/// @nodoc
class _$PwApplicationCopyWithImpl<$Res>
    implements $PwApplicationCopyWith<$Res> {
  _$PwApplicationCopyWithImpl(this._self, this._then);

  final PwApplication _self;
  final $Res Function(PwApplication) _then;

/// Create a copy of PwApplication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slotId = null,Object? date = null,Object? publisherId = null,Object? appliedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slotId: null == slotId ? _self.slotId : slotId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,publisherId: null == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String,appliedAt: freezed == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PwApplication].
extension PwApplicationPatterns on PwApplication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PwApplication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PwApplication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PwApplication value)  $default,){
final _that = this;
switch (_that) {
case _PwApplication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PwApplication value)?  $default,){
final _that = this;
switch (_that) {
case _PwApplication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String slotId,  String date,  String publisherId, @NullableTimestampConverter()  DateTime? appliedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PwApplication() when $default != null:
return $default(_that.id,_that.slotId,_that.date,_that.publisherId,_that.appliedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String slotId,  String date,  String publisherId, @NullableTimestampConverter()  DateTime? appliedAt)  $default,) {final _that = this;
switch (_that) {
case _PwApplication():
return $default(_that.id,_that.slotId,_that.date,_that.publisherId,_that.appliedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String slotId,  String date,  String publisherId, @NullableTimestampConverter()  DateTime? appliedAt)?  $default,) {final _that = this;
switch (_that) {
case _PwApplication() when $default != null:
return $default(_that.id,_that.slotId,_that.date,_that.publisherId,_that.appliedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PwApplication implements PwApplication {
  const _PwApplication({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.slotId = '', this.date = '', this.publisherId = '', @NullableTimestampConverter() this.appliedAt});
  factory _PwApplication.fromJson(Map<String, dynamic> json) => _$PwApplicationFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  String slotId;
/// yyyy-MM-dd; denormalized copy of the slot date for range queries.
@override@JsonKey() final  String date;
/// == the applicant's auth uid.
@override@JsonKey() final  String publisherId;
@override@NullableTimestampConverter() final  DateTime? appliedAt;

/// Create a copy of PwApplication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PwApplicationCopyWith<_PwApplication> get copyWith => __$PwApplicationCopyWithImpl<_PwApplication>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PwApplicationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PwApplication&&(identical(other.id, id) || other.id == id)&&(identical(other.slotId, slotId) || other.slotId == slotId)&&(identical(other.date, date) || other.date == date)&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slotId,date,publisherId,appliedAt);

@override
String toString() {
  return 'PwApplication(id: $id, slotId: $slotId, date: $date, publisherId: $publisherId, appliedAt: $appliedAt)';
}


}

/// @nodoc
abstract mixin class _$PwApplicationCopyWith<$Res> implements $PwApplicationCopyWith<$Res> {
  factory _$PwApplicationCopyWith(_PwApplication value, $Res Function(_PwApplication) _then) = __$PwApplicationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String slotId, String date, String publisherId,@NullableTimestampConverter() DateTime? appliedAt
});




}
/// @nodoc
class __$PwApplicationCopyWithImpl<$Res>
    implements _$PwApplicationCopyWith<$Res> {
  __$PwApplicationCopyWithImpl(this._self, this._then);

  final _PwApplication _self;
  final $Res Function(_PwApplication) _then;

/// Create a copy of PwApplication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slotId = null,Object? date = null,Object? publisherId = null,Object? appliedAt = freezed,}) {
  return _then(_PwApplication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slotId: null == slotId ? _self.slotId : slotId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,publisherId: null == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String,appliedAt: freezed == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
