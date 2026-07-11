// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lmm_week.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LmmPart {

 String get id; LmmSection get section; LmmPartType get type; String get title;/// Instructions/reference from the workbook, e.g. "HOUSE TO HOUSE.
/// Share a Bible truth… (lmd lesson 1 point 5)" or "wcg chap. 15".
 String get description; int? get durationMin; Assignment get assignment;/// Demonstration assistant (field-ministry parts).
 Assignment get assistant;/// Student/assistant slots for auxiliary classes 2 and 3; only used on
/// student parts (see [isStudentPart]) and only shown when
/// CongregationMeta.lmmClassCount enables the class.
 Assignment get assignment2; Assignment get assistant2; Assignment get assignment3; Assignment get assistant3;
/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LmmPartCopyWith<LmmPart> get copyWith => _$LmmPartCopyWithImpl<LmmPart>(this as LmmPart, _$identity);

  /// Serializes this LmmPart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LmmPart&&(identical(other.id, id) || other.id == id)&&(identical(other.section, section) || other.section == section)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&(identical(other.assignment, assignment) || other.assignment == assignment)&&(identical(other.assistant, assistant) || other.assistant == assistant)&&(identical(other.assignment2, assignment2) || other.assignment2 == assignment2)&&(identical(other.assistant2, assistant2) || other.assistant2 == assistant2)&&(identical(other.assignment3, assignment3) || other.assignment3 == assignment3)&&(identical(other.assistant3, assistant3) || other.assistant3 == assistant3));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,section,type,title,description,durationMin,assignment,assistant,assignment2,assistant2,assignment3,assistant3);

@override
String toString() {
  return 'LmmPart(id: $id, section: $section, type: $type, title: $title, description: $description, durationMin: $durationMin, assignment: $assignment, assistant: $assistant, assignment2: $assignment2, assistant2: $assistant2, assignment3: $assignment3, assistant3: $assistant3)';
}


}

/// @nodoc
abstract mixin class $LmmPartCopyWith<$Res>  {
  factory $LmmPartCopyWith(LmmPart value, $Res Function(LmmPart) _then) = _$LmmPartCopyWithImpl;
@useResult
$Res call({
 String id, LmmSection section, LmmPartType type, String title, String description, int? durationMin, Assignment assignment, Assignment assistant, Assignment assignment2, Assignment assistant2, Assignment assignment3, Assignment assistant3
});


$AssignmentCopyWith<$Res> get assignment;$AssignmentCopyWith<$Res> get assistant;$AssignmentCopyWith<$Res> get assignment2;$AssignmentCopyWith<$Res> get assistant2;$AssignmentCopyWith<$Res> get assignment3;$AssignmentCopyWith<$Res> get assistant3;

}
/// @nodoc
class _$LmmPartCopyWithImpl<$Res>
    implements $LmmPartCopyWith<$Res> {
  _$LmmPartCopyWithImpl(this._self, this._then);

  final LmmPart _self;
  final $Res Function(LmmPart) _then;

/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? section = null,Object? type = null,Object? title = null,Object? description = null,Object? durationMin = freezed,Object? assignment = null,Object? assistant = null,Object? assignment2 = null,Object? assistant2 = null,Object? assignment3 = null,Object? assistant3 = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as LmmSection,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LmmPartType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,durationMin: freezed == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int?,assignment: null == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as Assignment,assistant: null == assistant ? _self.assistant : assistant // ignore: cast_nullable_to_non_nullable
as Assignment,assignment2: null == assignment2 ? _self.assignment2 : assignment2 // ignore: cast_nullable_to_non_nullable
as Assignment,assistant2: null == assistant2 ? _self.assistant2 : assistant2 // ignore: cast_nullable_to_non_nullable
as Assignment,assignment3: null == assignment3 ? _self.assignment3 : assignment3 // ignore: cast_nullable_to_non_nullable
as Assignment,assistant3: null == assistant3 ? _self.assistant3 : assistant3 // ignore: cast_nullable_to_non_nullable
as Assignment,
  ));
}
/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assignment {
  
  return $AssignmentCopyWith<$Res>(_self.assignment, (value) {
    return _then(_self.copyWith(assignment: value));
  });
}/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assistant {
  
  return $AssignmentCopyWith<$Res>(_self.assistant, (value) {
    return _then(_self.copyWith(assistant: value));
  });
}/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assignment2 {
  
  return $AssignmentCopyWith<$Res>(_self.assignment2, (value) {
    return _then(_self.copyWith(assignment2: value));
  });
}/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assistant2 {
  
  return $AssignmentCopyWith<$Res>(_self.assistant2, (value) {
    return _then(_self.copyWith(assistant2: value));
  });
}/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assignment3 {
  
  return $AssignmentCopyWith<$Res>(_self.assignment3, (value) {
    return _then(_self.copyWith(assignment3: value));
  });
}/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assistant3 {
  
  return $AssignmentCopyWith<$Res>(_self.assistant3, (value) {
    return _then(_self.copyWith(assistant3: value));
  });
}
}


/// Adds pattern-matching-related methods to [LmmPart].
extension LmmPartPatterns on LmmPart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LmmPart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LmmPart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LmmPart value)  $default,){
final _that = this;
switch (_that) {
case _LmmPart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LmmPart value)?  $default,){
final _that = this;
switch (_that) {
case _LmmPart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LmmSection section,  LmmPartType type,  String title,  String description,  int? durationMin,  Assignment assignment,  Assignment assistant,  Assignment assignment2,  Assignment assistant2,  Assignment assignment3,  Assignment assistant3)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LmmPart() when $default != null:
return $default(_that.id,_that.section,_that.type,_that.title,_that.description,_that.durationMin,_that.assignment,_that.assistant,_that.assignment2,_that.assistant2,_that.assignment3,_that.assistant3);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LmmSection section,  LmmPartType type,  String title,  String description,  int? durationMin,  Assignment assignment,  Assignment assistant,  Assignment assignment2,  Assignment assistant2,  Assignment assignment3,  Assignment assistant3)  $default,) {final _that = this;
switch (_that) {
case _LmmPart():
return $default(_that.id,_that.section,_that.type,_that.title,_that.description,_that.durationMin,_that.assignment,_that.assistant,_that.assignment2,_that.assistant2,_that.assignment3,_that.assistant3);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LmmSection section,  LmmPartType type,  String title,  String description,  int? durationMin,  Assignment assignment,  Assignment assistant,  Assignment assignment2,  Assignment assistant2,  Assignment assignment3,  Assignment assistant3)?  $default,) {final _that = this;
switch (_that) {
case _LmmPart() when $default != null:
return $default(_that.id,_that.section,_that.type,_that.title,_that.description,_that.durationMin,_that.assignment,_that.assistant,_that.assignment2,_that.assistant2,_that.assignment3,_that.assistant3);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LmmPart extends LmmPart {
  const _LmmPart({this.id = '', this.section = LmmSection.treasures, this.type = LmmPartType.custom, this.title = '', this.description = '', this.durationMin, this.assignment = const Assignment(), this.assistant = const Assignment(), this.assignment2 = const Assignment(), this.assistant2 = const Assignment(), this.assignment3 = const Assignment(), this.assistant3 = const Assignment()}): super._();
  factory _LmmPart.fromJson(Map<String, dynamic> json) => _$LmmPartFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  LmmSection section;
@override@JsonKey() final  LmmPartType type;
@override@JsonKey() final  String title;
/// Instructions/reference from the workbook, e.g. "HOUSE TO HOUSE.
/// Share a Bible truth… (lmd lesson 1 point 5)" or "wcg chap. 15".
@override@JsonKey() final  String description;
@override final  int? durationMin;
@override@JsonKey() final  Assignment assignment;
/// Demonstration assistant (field-ministry parts).
@override@JsonKey() final  Assignment assistant;
/// Student/assistant slots for auxiliary classes 2 and 3; only used on
/// student parts (see [isStudentPart]) and only shown when
/// CongregationMeta.lmmClassCount enables the class.
@override@JsonKey() final  Assignment assignment2;
@override@JsonKey() final  Assignment assistant2;
@override@JsonKey() final  Assignment assignment3;
@override@JsonKey() final  Assignment assistant3;

/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LmmPartCopyWith<_LmmPart> get copyWith => __$LmmPartCopyWithImpl<_LmmPart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LmmPartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LmmPart&&(identical(other.id, id) || other.id == id)&&(identical(other.section, section) || other.section == section)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&(identical(other.assignment, assignment) || other.assignment == assignment)&&(identical(other.assistant, assistant) || other.assistant == assistant)&&(identical(other.assignment2, assignment2) || other.assignment2 == assignment2)&&(identical(other.assistant2, assistant2) || other.assistant2 == assistant2)&&(identical(other.assignment3, assignment3) || other.assignment3 == assignment3)&&(identical(other.assistant3, assistant3) || other.assistant3 == assistant3));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,section,type,title,description,durationMin,assignment,assistant,assignment2,assistant2,assignment3,assistant3);

@override
String toString() {
  return 'LmmPart(id: $id, section: $section, type: $type, title: $title, description: $description, durationMin: $durationMin, assignment: $assignment, assistant: $assistant, assignment2: $assignment2, assistant2: $assistant2, assignment3: $assignment3, assistant3: $assistant3)';
}


}

/// @nodoc
abstract mixin class _$LmmPartCopyWith<$Res> implements $LmmPartCopyWith<$Res> {
  factory _$LmmPartCopyWith(_LmmPart value, $Res Function(_LmmPart) _then) = __$LmmPartCopyWithImpl;
@override @useResult
$Res call({
 String id, LmmSection section, LmmPartType type, String title, String description, int? durationMin, Assignment assignment, Assignment assistant, Assignment assignment2, Assignment assistant2, Assignment assignment3, Assignment assistant3
});


@override $AssignmentCopyWith<$Res> get assignment;@override $AssignmentCopyWith<$Res> get assistant;@override $AssignmentCopyWith<$Res> get assignment2;@override $AssignmentCopyWith<$Res> get assistant2;@override $AssignmentCopyWith<$Res> get assignment3;@override $AssignmentCopyWith<$Res> get assistant3;

}
/// @nodoc
class __$LmmPartCopyWithImpl<$Res>
    implements _$LmmPartCopyWith<$Res> {
  __$LmmPartCopyWithImpl(this._self, this._then);

  final _LmmPart _self;
  final $Res Function(_LmmPart) _then;

/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? section = null,Object? type = null,Object? title = null,Object? description = null,Object? durationMin = freezed,Object? assignment = null,Object? assistant = null,Object? assignment2 = null,Object? assistant2 = null,Object? assignment3 = null,Object? assistant3 = null,}) {
  return _then(_LmmPart(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as LmmSection,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LmmPartType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,durationMin: freezed == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int?,assignment: null == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as Assignment,assistant: null == assistant ? _self.assistant : assistant // ignore: cast_nullable_to_non_nullable
as Assignment,assignment2: null == assignment2 ? _self.assignment2 : assignment2 // ignore: cast_nullable_to_non_nullable
as Assignment,assistant2: null == assistant2 ? _self.assistant2 : assistant2 // ignore: cast_nullable_to_non_nullable
as Assignment,assignment3: null == assignment3 ? _self.assignment3 : assignment3 // ignore: cast_nullable_to_non_nullable
as Assignment,assistant3: null == assistant3 ? _self.assistant3 : assistant3 // ignore: cast_nullable_to_non_nullable
as Assignment,
  ));
}

/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assignment {
  
  return $AssignmentCopyWith<$Res>(_self.assignment, (value) {
    return _then(_self.copyWith(assignment: value));
  });
}/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assistant {
  
  return $AssignmentCopyWith<$Res>(_self.assistant, (value) {
    return _then(_self.copyWith(assistant: value));
  });
}/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assignment2 {
  
  return $AssignmentCopyWith<$Res>(_self.assignment2, (value) {
    return _then(_self.copyWith(assignment2: value));
  });
}/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assistant2 {
  
  return $AssignmentCopyWith<$Res>(_self.assistant2, (value) {
    return _then(_self.copyWith(assistant2: value));
  });
}/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assignment3 {
  
  return $AssignmentCopyWith<$Res>(_self.assignment3, (value) {
    return _then(_self.copyWith(assignment3: value));
  });
}/// Create a copy of LmmPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assistant3 {
  
  return $AssignmentCopyWith<$Res>(_self.assistant3, (value) {
    return _then(_self.copyWith(assistant3: value));
  });
}
}


/// @nodoc
mixin _$LmmWeek {

@JsonKey(includeFromJson: false, includeToJson: false) String get id;/// Human label from the workbook, e.g. "JULY 6-12 | PSALM 45".
 String get weekLabel; List<String> get songs;/// epub | cdn | manual
 String get source; List<LmmPart> get parts; Assignment get attendants; Assignment get microphones; Assignment get audioVideo; List<CustomAssignment> get customAssignments;/// Denormalized union of every assigned publisher id, kept in sync on
/// save; enables array-contains "my assignments" queries.
 List<String> get allAssigneeIds;
/// Create a copy of LmmWeek
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LmmWeekCopyWith<LmmWeek> get copyWith => _$LmmWeekCopyWithImpl<LmmWeek>(this as LmmWeek, _$identity);

  /// Serializes this LmmWeek to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LmmWeek&&(identical(other.id, id) || other.id == id)&&(identical(other.weekLabel, weekLabel) || other.weekLabel == weekLabel)&&const DeepCollectionEquality().equals(other.songs, songs)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other.parts, parts)&&(identical(other.attendants, attendants) || other.attendants == attendants)&&(identical(other.microphones, microphones) || other.microphones == microphones)&&(identical(other.audioVideo, audioVideo) || other.audioVideo == audioVideo)&&const DeepCollectionEquality().equals(other.customAssignments, customAssignments)&&const DeepCollectionEquality().equals(other.allAssigneeIds, allAssigneeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weekLabel,const DeepCollectionEquality().hash(songs),source,const DeepCollectionEquality().hash(parts),attendants,microphones,audioVideo,const DeepCollectionEquality().hash(customAssignments),const DeepCollectionEquality().hash(allAssigneeIds));

@override
String toString() {
  return 'LmmWeek(id: $id, weekLabel: $weekLabel, songs: $songs, source: $source, parts: $parts, attendants: $attendants, microphones: $microphones, audioVideo: $audioVideo, customAssignments: $customAssignments, allAssigneeIds: $allAssigneeIds)';
}


}

/// @nodoc
abstract mixin class $LmmWeekCopyWith<$Res>  {
  factory $LmmWeekCopyWith(LmmWeek value, $Res Function(LmmWeek) _then) = _$LmmWeekCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String weekLabel, List<String> songs, String source, List<LmmPart> parts, Assignment attendants, Assignment microphones, Assignment audioVideo, List<CustomAssignment> customAssignments, List<String> allAssigneeIds
});


$AssignmentCopyWith<$Res> get attendants;$AssignmentCopyWith<$Res> get microphones;$AssignmentCopyWith<$Res> get audioVideo;

}
/// @nodoc
class _$LmmWeekCopyWithImpl<$Res>
    implements $LmmWeekCopyWith<$Res> {
  _$LmmWeekCopyWithImpl(this._self, this._then);

  final LmmWeek _self;
  final $Res Function(LmmWeek) _then;

/// Create a copy of LmmWeek
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? weekLabel = null,Object? songs = null,Object? source = null,Object? parts = null,Object? attendants = null,Object? microphones = null,Object? audioVideo = null,Object? customAssignments = null,Object? allAssigneeIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,weekLabel: null == weekLabel ? _self.weekLabel : weekLabel // ignore: cast_nullable_to_non_nullable
as String,songs: null == songs ? _self.songs : songs // ignore: cast_nullable_to_non_nullable
as List<String>,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<LmmPart>,attendants: null == attendants ? _self.attendants : attendants // ignore: cast_nullable_to_non_nullable
as Assignment,microphones: null == microphones ? _self.microphones : microphones // ignore: cast_nullable_to_non_nullable
as Assignment,audioVideo: null == audioVideo ? _self.audioVideo : audioVideo // ignore: cast_nullable_to_non_nullable
as Assignment,customAssignments: null == customAssignments ? _self.customAssignments : customAssignments // ignore: cast_nullable_to_non_nullable
as List<CustomAssignment>,allAssigneeIds: null == allAssigneeIds ? _self.allAssigneeIds : allAssigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of LmmWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get attendants {
  
  return $AssignmentCopyWith<$Res>(_self.attendants, (value) {
    return _then(_self.copyWith(attendants: value));
  });
}/// Create a copy of LmmWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get microphones {
  
  return $AssignmentCopyWith<$Res>(_self.microphones, (value) {
    return _then(_self.copyWith(microphones: value));
  });
}/// Create a copy of LmmWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get audioVideo {
  
  return $AssignmentCopyWith<$Res>(_self.audioVideo, (value) {
    return _then(_self.copyWith(audioVideo: value));
  });
}
}


/// Adds pattern-matching-related methods to [LmmWeek].
extension LmmWeekPatterns on LmmWeek {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LmmWeek value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LmmWeek() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LmmWeek value)  $default,){
final _that = this;
switch (_that) {
case _LmmWeek():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LmmWeek value)?  $default,){
final _that = this;
switch (_that) {
case _LmmWeek() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String weekLabel,  List<String> songs,  String source,  List<LmmPart> parts,  Assignment attendants,  Assignment microphones,  Assignment audioVideo,  List<CustomAssignment> customAssignments,  List<String> allAssigneeIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LmmWeek() when $default != null:
return $default(_that.id,_that.weekLabel,_that.songs,_that.source,_that.parts,_that.attendants,_that.microphones,_that.audioVideo,_that.customAssignments,_that.allAssigneeIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String weekLabel,  List<String> songs,  String source,  List<LmmPart> parts,  Assignment attendants,  Assignment microphones,  Assignment audioVideo,  List<CustomAssignment> customAssignments,  List<String> allAssigneeIds)  $default,) {final _that = this;
switch (_that) {
case _LmmWeek():
return $default(_that.id,_that.weekLabel,_that.songs,_that.source,_that.parts,_that.attendants,_that.microphones,_that.audioVideo,_that.customAssignments,_that.allAssigneeIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String weekLabel,  List<String> songs,  String source,  List<LmmPart> parts,  Assignment attendants,  Assignment microphones,  Assignment audioVideo,  List<CustomAssignment> customAssignments,  List<String> allAssigneeIds)?  $default,) {final _that = this;
switch (_that) {
case _LmmWeek() when $default != null:
return $default(_that.id,_that.weekLabel,_that.songs,_that.source,_that.parts,_that.attendants,_that.microphones,_that.audioVideo,_that.customAssignments,_that.allAssigneeIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LmmWeek extends LmmWeek {
  const _LmmWeek({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.weekLabel = '', final  List<String> songs = const <String>[], this.source = 'manual', final  List<LmmPart> parts = const <LmmPart>[], this.attendants = const Assignment(), this.microphones = const Assignment(), this.audioVideo = const Assignment(), final  List<CustomAssignment> customAssignments = const <CustomAssignment>[], final  List<String> allAssigneeIds = const <String>[]}): _songs = songs,_parts = parts,_customAssignments = customAssignments,_allAssigneeIds = allAssigneeIds,super._();
  factory _LmmWeek.fromJson(Map<String, dynamic> json) => _$LmmWeekFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
/// Human label from the workbook, e.g. "JULY 6-12 | PSALM 45".
@override@JsonKey() final  String weekLabel;
 final  List<String> _songs;
@override@JsonKey() List<String> get songs {
  if (_songs is EqualUnmodifiableListView) return _songs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_songs);
}

/// epub | cdn | manual
@override@JsonKey() final  String source;
 final  List<LmmPart> _parts;
@override@JsonKey() List<LmmPart> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}

@override@JsonKey() final  Assignment attendants;
@override@JsonKey() final  Assignment microphones;
@override@JsonKey() final  Assignment audioVideo;
 final  List<CustomAssignment> _customAssignments;
@override@JsonKey() List<CustomAssignment> get customAssignments {
  if (_customAssignments is EqualUnmodifiableListView) return _customAssignments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_customAssignments);
}

/// Denormalized union of every assigned publisher id, kept in sync on
/// save; enables array-contains "my assignments" queries.
 final  List<String> _allAssigneeIds;
/// Denormalized union of every assigned publisher id, kept in sync on
/// save; enables array-contains "my assignments" queries.
@override@JsonKey() List<String> get allAssigneeIds {
  if (_allAssigneeIds is EqualUnmodifiableListView) return _allAssigneeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allAssigneeIds);
}


/// Create a copy of LmmWeek
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LmmWeekCopyWith<_LmmWeek> get copyWith => __$LmmWeekCopyWithImpl<_LmmWeek>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LmmWeekToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LmmWeek&&(identical(other.id, id) || other.id == id)&&(identical(other.weekLabel, weekLabel) || other.weekLabel == weekLabel)&&const DeepCollectionEquality().equals(other._songs, _songs)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other._parts, _parts)&&(identical(other.attendants, attendants) || other.attendants == attendants)&&(identical(other.microphones, microphones) || other.microphones == microphones)&&(identical(other.audioVideo, audioVideo) || other.audioVideo == audioVideo)&&const DeepCollectionEquality().equals(other._customAssignments, _customAssignments)&&const DeepCollectionEquality().equals(other._allAssigneeIds, _allAssigneeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weekLabel,const DeepCollectionEquality().hash(_songs),source,const DeepCollectionEquality().hash(_parts),attendants,microphones,audioVideo,const DeepCollectionEquality().hash(_customAssignments),const DeepCollectionEquality().hash(_allAssigneeIds));

@override
String toString() {
  return 'LmmWeek(id: $id, weekLabel: $weekLabel, songs: $songs, source: $source, parts: $parts, attendants: $attendants, microphones: $microphones, audioVideo: $audioVideo, customAssignments: $customAssignments, allAssigneeIds: $allAssigneeIds)';
}


}

/// @nodoc
abstract mixin class _$LmmWeekCopyWith<$Res> implements $LmmWeekCopyWith<$Res> {
  factory _$LmmWeekCopyWith(_LmmWeek value, $Res Function(_LmmWeek) _then) = __$LmmWeekCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String weekLabel, List<String> songs, String source, List<LmmPart> parts, Assignment attendants, Assignment microphones, Assignment audioVideo, List<CustomAssignment> customAssignments, List<String> allAssigneeIds
});


@override $AssignmentCopyWith<$Res> get attendants;@override $AssignmentCopyWith<$Res> get microphones;@override $AssignmentCopyWith<$Res> get audioVideo;

}
/// @nodoc
class __$LmmWeekCopyWithImpl<$Res>
    implements _$LmmWeekCopyWith<$Res> {
  __$LmmWeekCopyWithImpl(this._self, this._then);

  final _LmmWeek _self;
  final $Res Function(_LmmWeek) _then;

/// Create a copy of LmmWeek
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? weekLabel = null,Object? songs = null,Object? source = null,Object? parts = null,Object? attendants = null,Object? microphones = null,Object? audioVideo = null,Object? customAssignments = null,Object? allAssigneeIds = null,}) {
  return _then(_LmmWeek(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,weekLabel: null == weekLabel ? _self.weekLabel : weekLabel // ignore: cast_nullable_to_non_nullable
as String,songs: null == songs ? _self._songs : songs // ignore: cast_nullable_to_non_nullable
as List<String>,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<LmmPart>,attendants: null == attendants ? _self.attendants : attendants // ignore: cast_nullable_to_non_nullable
as Assignment,microphones: null == microphones ? _self.microphones : microphones // ignore: cast_nullable_to_non_nullable
as Assignment,audioVideo: null == audioVideo ? _self.audioVideo : audioVideo // ignore: cast_nullable_to_non_nullable
as Assignment,customAssignments: null == customAssignments ? _self._customAssignments : customAssignments // ignore: cast_nullable_to_non_nullable
as List<CustomAssignment>,allAssigneeIds: null == allAssigneeIds ? _self._allAssigneeIds : allAssigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of LmmWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get attendants {
  
  return $AssignmentCopyWith<$Res>(_self.attendants, (value) {
    return _then(_self.copyWith(attendants: value));
  });
}/// Create a copy of LmmWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get microphones {
  
  return $AssignmentCopyWith<$Res>(_self.microphones, (value) {
    return _then(_self.copyWith(microphones: value));
  });
}/// Create a copy of LmmWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get audioVideo {
  
  return $AssignmentCopyWith<$Res>(_self.audioVideo, (value) {
    return _then(_self.copyWith(audioVideo: value));
  });
}
}

// dart format on
