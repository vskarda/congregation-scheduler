// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekend_week.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeekendWeek {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get talkTitle;/// S-99 talk number when the title was picked from the catalog;
/// null for free-text titles. The stored [talkTitle] is a snapshot.
@JsonKey(includeIfNull: false) int? get talkNo;/// Opening song. [songTitle] is a snapshot; [songNo] is the catalog number
/// when picked from the song list, null for free text.
 String get songTitle;@JsonKey(includeIfNull: false) int? get songNo; Assignment get speaker; Assignment get chairman; Assignment get wtReader;/// Extra program fields (label + assignment/free text).
 List<CustomAssignment> get customFields; Assignment get attendants; Assignment get microphones; Assignment get audioVideo; List<CustomAssignment> get customAssignments; List<String> get allAssigneeIds;
/// Create a copy of WeekendWeek
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekendWeekCopyWith<WeekendWeek> get copyWith => _$WeekendWeekCopyWithImpl<WeekendWeek>(this as WeekendWeek, _$identity);

  /// Serializes this WeekendWeek to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekendWeek&&(identical(other.id, id) || other.id == id)&&(identical(other.talkTitle, talkTitle) || other.talkTitle == talkTitle)&&(identical(other.talkNo, talkNo) || other.talkNo == talkNo)&&(identical(other.songTitle, songTitle) || other.songTitle == songTitle)&&(identical(other.songNo, songNo) || other.songNo == songNo)&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.chairman, chairman) || other.chairman == chairman)&&(identical(other.wtReader, wtReader) || other.wtReader == wtReader)&&const DeepCollectionEquality().equals(other.customFields, customFields)&&(identical(other.attendants, attendants) || other.attendants == attendants)&&(identical(other.microphones, microphones) || other.microphones == microphones)&&(identical(other.audioVideo, audioVideo) || other.audioVideo == audioVideo)&&const DeepCollectionEquality().equals(other.customAssignments, customAssignments)&&const DeepCollectionEquality().equals(other.allAssigneeIds, allAssigneeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,talkTitle,talkNo,songTitle,songNo,speaker,chairman,wtReader,const DeepCollectionEquality().hash(customFields),attendants,microphones,audioVideo,const DeepCollectionEquality().hash(customAssignments),const DeepCollectionEquality().hash(allAssigneeIds));

@override
String toString() {
  return 'WeekendWeek(id: $id, talkTitle: $talkTitle, talkNo: $talkNo, songTitle: $songTitle, songNo: $songNo, speaker: $speaker, chairman: $chairman, wtReader: $wtReader, customFields: $customFields, attendants: $attendants, microphones: $microphones, audioVideo: $audioVideo, customAssignments: $customAssignments, allAssigneeIds: $allAssigneeIds)';
}


}

/// @nodoc
abstract mixin class $WeekendWeekCopyWith<$Res>  {
  factory $WeekendWeekCopyWith(WeekendWeek value, $Res Function(WeekendWeek) _then) = _$WeekendWeekCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String talkTitle,@JsonKey(includeIfNull: false) int? talkNo, String songTitle,@JsonKey(includeIfNull: false) int? songNo, Assignment speaker, Assignment chairman, Assignment wtReader, List<CustomAssignment> customFields, Assignment attendants, Assignment microphones, Assignment audioVideo, List<CustomAssignment> customAssignments, List<String> allAssigneeIds
});


$AssignmentCopyWith<$Res> get speaker;$AssignmentCopyWith<$Res> get chairman;$AssignmentCopyWith<$Res> get wtReader;$AssignmentCopyWith<$Res> get attendants;$AssignmentCopyWith<$Res> get microphones;$AssignmentCopyWith<$Res> get audioVideo;

}
/// @nodoc
class _$WeekendWeekCopyWithImpl<$Res>
    implements $WeekendWeekCopyWith<$Res> {
  _$WeekendWeekCopyWithImpl(this._self, this._then);

  final WeekendWeek _self;
  final $Res Function(WeekendWeek) _then;

/// Create a copy of WeekendWeek
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? talkTitle = null,Object? talkNo = freezed,Object? songTitle = null,Object? songNo = freezed,Object? speaker = null,Object? chairman = null,Object? wtReader = null,Object? customFields = null,Object? attendants = null,Object? microphones = null,Object? audioVideo = null,Object? customAssignments = null,Object? allAssigneeIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,talkTitle: null == talkTitle ? _self.talkTitle : talkTitle // ignore: cast_nullable_to_non_nullable
as String,talkNo: freezed == talkNo ? _self.talkNo : talkNo // ignore: cast_nullable_to_non_nullable
as int?,songTitle: null == songTitle ? _self.songTitle : songTitle // ignore: cast_nullable_to_non_nullable
as String,songNo: freezed == songNo ? _self.songNo : songNo // ignore: cast_nullable_to_non_nullable
as int?,speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as Assignment,chairman: null == chairman ? _self.chairman : chairman // ignore: cast_nullable_to_non_nullable
as Assignment,wtReader: null == wtReader ? _self.wtReader : wtReader // ignore: cast_nullable_to_non_nullable
as Assignment,customFields: null == customFields ? _self.customFields : customFields // ignore: cast_nullable_to_non_nullable
as List<CustomAssignment>,attendants: null == attendants ? _self.attendants : attendants // ignore: cast_nullable_to_non_nullable
as Assignment,microphones: null == microphones ? _self.microphones : microphones // ignore: cast_nullable_to_non_nullable
as Assignment,audioVideo: null == audioVideo ? _self.audioVideo : audioVideo // ignore: cast_nullable_to_non_nullable
as Assignment,customAssignments: null == customAssignments ? _self.customAssignments : customAssignments // ignore: cast_nullable_to_non_nullable
as List<CustomAssignment>,allAssigneeIds: null == allAssigneeIds ? _self.allAssigneeIds : allAssigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of WeekendWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get speaker {
  
  return $AssignmentCopyWith<$Res>(_self.speaker, (value) {
    return _then(_self.copyWith(speaker: value));
  });
}/// Create a copy of WeekendWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get chairman {
  
  return $AssignmentCopyWith<$Res>(_self.chairman, (value) {
    return _then(_self.copyWith(chairman: value));
  });
}/// Create a copy of WeekendWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get wtReader {
  
  return $AssignmentCopyWith<$Res>(_self.wtReader, (value) {
    return _then(_self.copyWith(wtReader: value));
  });
}/// Create a copy of WeekendWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get attendants {
  
  return $AssignmentCopyWith<$Res>(_self.attendants, (value) {
    return _then(_self.copyWith(attendants: value));
  });
}/// Create a copy of WeekendWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get microphones {
  
  return $AssignmentCopyWith<$Res>(_self.microphones, (value) {
    return _then(_self.copyWith(microphones: value));
  });
}/// Create a copy of WeekendWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get audioVideo {
  
  return $AssignmentCopyWith<$Res>(_self.audioVideo, (value) {
    return _then(_self.copyWith(audioVideo: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeekendWeek].
extension WeekendWeekPatterns on WeekendWeek {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekendWeek value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekendWeek() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekendWeek value)  $default,){
final _that = this;
switch (_that) {
case _WeekendWeek():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekendWeek value)?  $default,){
final _that = this;
switch (_that) {
case _WeekendWeek() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String talkTitle, @JsonKey(includeIfNull: false)  int? talkNo,  String songTitle, @JsonKey(includeIfNull: false)  int? songNo,  Assignment speaker,  Assignment chairman,  Assignment wtReader,  List<CustomAssignment> customFields,  Assignment attendants,  Assignment microphones,  Assignment audioVideo,  List<CustomAssignment> customAssignments,  List<String> allAssigneeIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekendWeek() when $default != null:
return $default(_that.id,_that.talkTitle,_that.talkNo,_that.songTitle,_that.songNo,_that.speaker,_that.chairman,_that.wtReader,_that.customFields,_that.attendants,_that.microphones,_that.audioVideo,_that.customAssignments,_that.allAssigneeIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String talkTitle, @JsonKey(includeIfNull: false)  int? talkNo,  String songTitle, @JsonKey(includeIfNull: false)  int? songNo,  Assignment speaker,  Assignment chairman,  Assignment wtReader,  List<CustomAssignment> customFields,  Assignment attendants,  Assignment microphones,  Assignment audioVideo,  List<CustomAssignment> customAssignments,  List<String> allAssigneeIds)  $default,) {final _that = this;
switch (_that) {
case _WeekendWeek():
return $default(_that.id,_that.talkTitle,_that.talkNo,_that.songTitle,_that.songNo,_that.speaker,_that.chairman,_that.wtReader,_that.customFields,_that.attendants,_that.microphones,_that.audioVideo,_that.customAssignments,_that.allAssigneeIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String talkTitle, @JsonKey(includeIfNull: false)  int? talkNo,  String songTitle, @JsonKey(includeIfNull: false)  int? songNo,  Assignment speaker,  Assignment chairman,  Assignment wtReader,  List<CustomAssignment> customFields,  Assignment attendants,  Assignment microphones,  Assignment audioVideo,  List<CustomAssignment> customAssignments,  List<String> allAssigneeIds)?  $default,) {final _that = this;
switch (_that) {
case _WeekendWeek() when $default != null:
return $default(_that.id,_that.talkTitle,_that.talkNo,_that.songTitle,_that.songNo,_that.speaker,_that.chairman,_that.wtReader,_that.customFields,_that.attendants,_that.microphones,_that.audioVideo,_that.customAssignments,_that.allAssigneeIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeekendWeek extends WeekendWeek {
  const _WeekendWeek({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.talkTitle = '', @JsonKey(includeIfNull: false) this.talkNo, this.songTitle = '', @JsonKey(includeIfNull: false) this.songNo, this.speaker = const Assignment(), this.chairman = const Assignment(), this.wtReader = const Assignment(), final  List<CustomAssignment> customFields = const <CustomAssignment>[], this.attendants = const Assignment(), this.microphones = const Assignment(), this.audioVideo = const Assignment(), final  List<CustomAssignment> customAssignments = const <CustomAssignment>[], final  List<String> allAssigneeIds = const <String>[]}): _customFields = customFields,_customAssignments = customAssignments,_allAssigneeIds = allAssigneeIds,super._();
  factory _WeekendWeek.fromJson(Map<String, dynamic> json) => _$WeekendWeekFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  String talkTitle;
/// S-99 talk number when the title was picked from the catalog;
/// null for free-text titles. The stored [talkTitle] is a snapshot.
@override@JsonKey(includeIfNull: false) final  int? talkNo;
/// Opening song. [songTitle] is a snapshot; [songNo] is the catalog number
/// when picked from the song list, null for free text.
@override@JsonKey() final  String songTitle;
@override@JsonKey(includeIfNull: false) final  int? songNo;
@override@JsonKey() final  Assignment speaker;
@override@JsonKey() final  Assignment chairman;
@override@JsonKey() final  Assignment wtReader;
/// Extra program fields (label + assignment/free text).
 final  List<CustomAssignment> _customFields;
/// Extra program fields (label + assignment/free text).
@override@JsonKey() List<CustomAssignment> get customFields {
  if (_customFields is EqualUnmodifiableListView) return _customFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_customFields);
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

 final  List<String> _allAssigneeIds;
@override@JsonKey() List<String> get allAssigneeIds {
  if (_allAssigneeIds is EqualUnmodifiableListView) return _allAssigneeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allAssigneeIds);
}


/// Create a copy of WeekendWeek
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekendWeekCopyWith<_WeekendWeek> get copyWith => __$WeekendWeekCopyWithImpl<_WeekendWeek>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeekendWeekToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekendWeek&&(identical(other.id, id) || other.id == id)&&(identical(other.talkTitle, talkTitle) || other.talkTitle == talkTitle)&&(identical(other.talkNo, talkNo) || other.talkNo == talkNo)&&(identical(other.songTitle, songTitle) || other.songTitle == songTitle)&&(identical(other.songNo, songNo) || other.songNo == songNo)&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.chairman, chairman) || other.chairman == chairman)&&(identical(other.wtReader, wtReader) || other.wtReader == wtReader)&&const DeepCollectionEquality().equals(other._customFields, _customFields)&&(identical(other.attendants, attendants) || other.attendants == attendants)&&(identical(other.microphones, microphones) || other.microphones == microphones)&&(identical(other.audioVideo, audioVideo) || other.audioVideo == audioVideo)&&const DeepCollectionEquality().equals(other._customAssignments, _customAssignments)&&const DeepCollectionEquality().equals(other._allAssigneeIds, _allAssigneeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,talkTitle,talkNo,songTitle,songNo,speaker,chairman,wtReader,const DeepCollectionEquality().hash(_customFields),attendants,microphones,audioVideo,const DeepCollectionEquality().hash(_customAssignments),const DeepCollectionEquality().hash(_allAssigneeIds));

@override
String toString() {
  return 'WeekendWeek(id: $id, talkTitle: $talkTitle, talkNo: $talkNo, songTitle: $songTitle, songNo: $songNo, speaker: $speaker, chairman: $chairman, wtReader: $wtReader, customFields: $customFields, attendants: $attendants, microphones: $microphones, audioVideo: $audioVideo, customAssignments: $customAssignments, allAssigneeIds: $allAssigneeIds)';
}


}

/// @nodoc
abstract mixin class _$WeekendWeekCopyWith<$Res> implements $WeekendWeekCopyWith<$Res> {
  factory _$WeekendWeekCopyWith(_WeekendWeek value, $Res Function(_WeekendWeek) _then) = __$WeekendWeekCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String talkTitle,@JsonKey(includeIfNull: false) int? talkNo, String songTitle,@JsonKey(includeIfNull: false) int? songNo, Assignment speaker, Assignment chairman, Assignment wtReader, List<CustomAssignment> customFields, Assignment attendants, Assignment microphones, Assignment audioVideo, List<CustomAssignment> customAssignments, List<String> allAssigneeIds
});


@override $AssignmentCopyWith<$Res> get speaker;@override $AssignmentCopyWith<$Res> get chairman;@override $AssignmentCopyWith<$Res> get wtReader;@override $AssignmentCopyWith<$Res> get attendants;@override $AssignmentCopyWith<$Res> get microphones;@override $AssignmentCopyWith<$Res> get audioVideo;

}
/// @nodoc
class __$WeekendWeekCopyWithImpl<$Res>
    implements _$WeekendWeekCopyWith<$Res> {
  __$WeekendWeekCopyWithImpl(this._self, this._then);

  final _WeekendWeek _self;
  final $Res Function(_WeekendWeek) _then;

/// Create a copy of WeekendWeek
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? talkTitle = null,Object? talkNo = freezed,Object? songTitle = null,Object? songNo = freezed,Object? speaker = null,Object? chairman = null,Object? wtReader = null,Object? customFields = null,Object? attendants = null,Object? microphones = null,Object? audioVideo = null,Object? customAssignments = null,Object? allAssigneeIds = null,}) {
  return _then(_WeekendWeek(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,talkTitle: null == talkTitle ? _self.talkTitle : talkTitle // ignore: cast_nullable_to_non_nullable
as String,talkNo: freezed == talkNo ? _self.talkNo : talkNo // ignore: cast_nullable_to_non_nullable
as int?,songTitle: null == songTitle ? _self.songTitle : songTitle // ignore: cast_nullable_to_non_nullable
as String,songNo: freezed == songNo ? _self.songNo : songNo // ignore: cast_nullable_to_non_nullable
as int?,speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as Assignment,chairman: null == chairman ? _self.chairman : chairman // ignore: cast_nullable_to_non_nullable
as Assignment,wtReader: null == wtReader ? _self.wtReader : wtReader // ignore: cast_nullable_to_non_nullable
as Assignment,customFields: null == customFields ? _self._customFields : customFields // ignore: cast_nullable_to_non_nullable
as List<CustomAssignment>,attendants: null == attendants ? _self.attendants : attendants // ignore: cast_nullable_to_non_nullable
as Assignment,microphones: null == microphones ? _self.microphones : microphones // ignore: cast_nullable_to_non_nullable
as Assignment,audioVideo: null == audioVideo ? _self.audioVideo : audioVideo // ignore: cast_nullable_to_non_nullable
as Assignment,customAssignments: null == customAssignments ? _self._customAssignments : customAssignments // ignore: cast_nullable_to_non_nullable
as List<CustomAssignment>,allAssigneeIds: null == allAssigneeIds ? _self._allAssigneeIds : allAssigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of WeekendWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get speaker {
  
  return $AssignmentCopyWith<$Res>(_self.speaker, (value) {
    return _then(_self.copyWith(speaker: value));
  });
}/// Create a copy of WeekendWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get chairman {
  
  return $AssignmentCopyWith<$Res>(_self.chairman, (value) {
    return _then(_self.copyWith(chairman: value));
  });
}/// Create a copy of WeekendWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get wtReader {
  
  return $AssignmentCopyWith<$Res>(_self.wtReader, (value) {
    return _then(_self.copyWith(wtReader: value));
  });
}/// Create a copy of WeekendWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get attendants {
  
  return $AssignmentCopyWith<$Res>(_self.attendants, (value) {
    return _then(_self.copyWith(attendants: value));
  });
}/// Create a copy of WeekendWeek
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get microphones {
  
  return $AssignmentCopyWith<$Res>(_self.microphones, (value) {
    return _then(_self.copyWith(microphones: value));
  });
}/// Create a copy of WeekendWeek
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
