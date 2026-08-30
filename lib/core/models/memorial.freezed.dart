// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memorial.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemorialProgram {

/// Opening song. [songTitle] is a snapshot; [songNo] is the catalog
/// number when picked from the song list, null for free text.
 String get songTitle;@JsonKey(includeIfNull: false) int? get songNo; Assignment get chairman; Assignment get speaker;/// The two prayers said over the emblems.
 Assignment get breadPrayer; Assignment get winePrayer;/// Extra program fields (label + assignment/free text), this Memorial
/// only — the schedule's permanent custom assignments recur on every
/// week and belong to the week document instead.
 List<CustomAssignment> get customFields;
/// Create a copy of MemorialProgram
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemorialProgramCopyWith<MemorialProgram> get copyWith => _$MemorialProgramCopyWithImpl<MemorialProgram>(this as MemorialProgram, _$identity);

  /// Serializes this MemorialProgram to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemorialProgram&&(identical(other.songTitle, songTitle) || other.songTitle == songTitle)&&(identical(other.songNo, songNo) || other.songNo == songNo)&&(identical(other.chairman, chairman) || other.chairman == chairman)&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.breadPrayer, breadPrayer) || other.breadPrayer == breadPrayer)&&(identical(other.winePrayer, winePrayer) || other.winePrayer == winePrayer)&&const DeepCollectionEquality().equals(other.customFields, customFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,songTitle,songNo,chairman,speaker,breadPrayer,winePrayer,const DeepCollectionEquality().hash(customFields));

@override
String toString() {
  return 'MemorialProgram(songTitle: $songTitle, songNo: $songNo, chairman: $chairman, speaker: $speaker, breadPrayer: $breadPrayer, winePrayer: $winePrayer, customFields: $customFields)';
}


}

/// @nodoc
abstract mixin class $MemorialProgramCopyWith<$Res>  {
  factory $MemorialProgramCopyWith(MemorialProgram value, $Res Function(MemorialProgram) _then) = _$MemorialProgramCopyWithImpl;
@useResult
$Res call({
 String songTitle,@JsonKey(includeIfNull: false) int? songNo, Assignment chairman, Assignment speaker, Assignment breadPrayer, Assignment winePrayer, List<CustomAssignment> customFields
});


$AssignmentCopyWith<$Res> get chairman;$AssignmentCopyWith<$Res> get speaker;$AssignmentCopyWith<$Res> get breadPrayer;$AssignmentCopyWith<$Res> get winePrayer;

}
/// @nodoc
class _$MemorialProgramCopyWithImpl<$Res>
    implements $MemorialProgramCopyWith<$Res> {
  _$MemorialProgramCopyWithImpl(this._self, this._then);

  final MemorialProgram _self;
  final $Res Function(MemorialProgram) _then;

/// Create a copy of MemorialProgram
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? songTitle = null,Object? songNo = freezed,Object? chairman = null,Object? speaker = null,Object? breadPrayer = null,Object? winePrayer = null,Object? customFields = null,}) {
  return _then(_self.copyWith(
songTitle: null == songTitle ? _self.songTitle : songTitle // ignore: cast_nullable_to_non_nullable
as String,songNo: freezed == songNo ? _self.songNo : songNo // ignore: cast_nullable_to_non_nullable
as int?,chairman: null == chairman ? _self.chairman : chairman // ignore: cast_nullable_to_non_nullable
as Assignment,speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as Assignment,breadPrayer: null == breadPrayer ? _self.breadPrayer : breadPrayer // ignore: cast_nullable_to_non_nullable
as Assignment,winePrayer: null == winePrayer ? _self.winePrayer : winePrayer // ignore: cast_nullable_to_non_nullable
as Assignment,customFields: null == customFields ? _self.customFields : customFields // ignore: cast_nullable_to_non_nullable
as List<CustomAssignment>,
  ));
}
/// Create a copy of MemorialProgram
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get chairman {
  
  return $AssignmentCopyWith<$Res>(_self.chairman, (value) {
    return _then(_self.copyWith(chairman: value));
  });
}/// Create a copy of MemorialProgram
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get speaker {
  
  return $AssignmentCopyWith<$Res>(_self.speaker, (value) {
    return _then(_self.copyWith(speaker: value));
  });
}/// Create a copy of MemorialProgram
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get breadPrayer {
  
  return $AssignmentCopyWith<$Res>(_self.breadPrayer, (value) {
    return _then(_self.copyWith(breadPrayer: value));
  });
}/// Create a copy of MemorialProgram
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get winePrayer {
  
  return $AssignmentCopyWith<$Res>(_self.winePrayer, (value) {
    return _then(_self.copyWith(winePrayer: value));
  });
}
}


/// Adds pattern-matching-related methods to [MemorialProgram].
extension MemorialProgramPatterns on MemorialProgram {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemorialProgram value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemorialProgram() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemorialProgram value)  $default,){
final _that = this;
switch (_that) {
case _MemorialProgram():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemorialProgram value)?  $default,){
final _that = this;
switch (_that) {
case _MemorialProgram() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String songTitle, @JsonKey(includeIfNull: false)  int? songNo,  Assignment chairman,  Assignment speaker,  Assignment breadPrayer,  Assignment winePrayer,  List<CustomAssignment> customFields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemorialProgram() when $default != null:
return $default(_that.songTitle,_that.songNo,_that.chairman,_that.speaker,_that.breadPrayer,_that.winePrayer,_that.customFields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String songTitle, @JsonKey(includeIfNull: false)  int? songNo,  Assignment chairman,  Assignment speaker,  Assignment breadPrayer,  Assignment winePrayer,  List<CustomAssignment> customFields)  $default,) {final _that = this;
switch (_that) {
case _MemorialProgram():
return $default(_that.songTitle,_that.songNo,_that.chairman,_that.speaker,_that.breadPrayer,_that.winePrayer,_that.customFields);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String songTitle, @JsonKey(includeIfNull: false)  int? songNo,  Assignment chairman,  Assignment speaker,  Assignment breadPrayer,  Assignment winePrayer,  List<CustomAssignment> customFields)?  $default,) {final _that = this;
switch (_that) {
case _MemorialProgram() when $default != null:
return $default(_that.songTitle,_that.songNo,_that.chairman,_that.speaker,_that.breadPrayer,_that.winePrayer,_that.customFields);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemorialProgram extends MemorialProgram {
  const _MemorialProgram({this.songTitle = '', @JsonKey(includeIfNull: false) this.songNo, this.chairman = const Assignment(), this.speaker = const Assignment(), this.breadPrayer = const Assignment(), this.winePrayer = const Assignment(), final  List<CustomAssignment> customFields = const <CustomAssignment>[]}): _customFields = customFields,super._();
  factory _MemorialProgram.fromJson(Map<String, dynamic> json) => _$MemorialProgramFromJson(json);

/// Opening song. [songTitle] is a snapshot; [songNo] is the catalog
/// number when picked from the song list, null for free text.
@override@JsonKey() final  String songTitle;
@override@JsonKey(includeIfNull: false) final  int? songNo;
@override@JsonKey() final  Assignment chairman;
@override@JsonKey() final  Assignment speaker;
/// The two prayers said over the emblems.
@override@JsonKey() final  Assignment breadPrayer;
@override@JsonKey() final  Assignment winePrayer;
/// Extra program fields (label + assignment/free text), this Memorial
/// only — the schedule's permanent custom assignments recur on every
/// week and belong to the week document instead.
 final  List<CustomAssignment> _customFields;
/// Extra program fields (label + assignment/free text), this Memorial
/// only — the schedule's permanent custom assignments recur on every
/// week and belong to the week document instead.
@override@JsonKey() List<CustomAssignment> get customFields {
  if (_customFields is EqualUnmodifiableListView) return _customFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_customFields);
}


/// Create a copy of MemorialProgram
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemorialProgramCopyWith<_MemorialProgram> get copyWith => __$MemorialProgramCopyWithImpl<_MemorialProgram>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemorialProgramToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemorialProgram&&(identical(other.songTitle, songTitle) || other.songTitle == songTitle)&&(identical(other.songNo, songNo) || other.songNo == songNo)&&(identical(other.chairman, chairman) || other.chairman == chairman)&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.breadPrayer, breadPrayer) || other.breadPrayer == breadPrayer)&&(identical(other.winePrayer, winePrayer) || other.winePrayer == winePrayer)&&const DeepCollectionEquality().equals(other._customFields, _customFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,songTitle,songNo,chairman,speaker,breadPrayer,winePrayer,const DeepCollectionEquality().hash(_customFields));

@override
String toString() {
  return 'MemorialProgram(songTitle: $songTitle, songNo: $songNo, chairman: $chairman, speaker: $speaker, breadPrayer: $breadPrayer, winePrayer: $winePrayer, customFields: $customFields)';
}


}

/// @nodoc
abstract mixin class _$MemorialProgramCopyWith<$Res> implements $MemorialProgramCopyWith<$Res> {
  factory _$MemorialProgramCopyWith(_MemorialProgram value, $Res Function(_MemorialProgram) _then) = __$MemorialProgramCopyWithImpl;
@override @useResult
$Res call({
 String songTitle,@JsonKey(includeIfNull: false) int? songNo, Assignment chairman, Assignment speaker, Assignment breadPrayer, Assignment winePrayer, List<CustomAssignment> customFields
});


@override $AssignmentCopyWith<$Res> get chairman;@override $AssignmentCopyWith<$Res> get speaker;@override $AssignmentCopyWith<$Res> get breadPrayer;@override $AssignmentCopyWith<$Res> get winePrayer;

}
/// @nodoc
class __$MemorialProgramCopyWithImpl<$Res>
    implements _$MemorialProgramCopyWith<$Res> {
  __$MemorialProgramCopyWithImpl(this._self, this._then);

  final _MemorialProgram _self;
  final $Res Function(_MemorialProgram) _then;

/// Create a copy of MemorialProgram
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? songTitle = null,Object? songNo = freezed,Object? chairman = null,Object? speaker = null,Object? breadPrayer = null,Object? winePrayer = null,Object? customFields = null,}) {
  return _then(_MemorialProgram(
songTitle: null == songTitle ? _self.songTitle : songTitle // ignore: cast_nullable_to_non_nullable
as String,songNo: freezed == songNo ? _self.songNo : songNo // ignore: cast_nullable_to_non_nullable
as int?,chairman: null == chairman ? _self.chairman : chairman // ignore: cast_nullable_to_non_nullable
as Assignment,speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as Assignment,breadPrayer: null == breadPrayer ? _self.breadPrayer : breadPrayer // ignore: cast_nullable_to_non_nullable
as Assignment,winePrayer: null == winePrayer ? _self.winePrayer : winePrayer // ignore: cast_nullable_to_non_nullable
as Assignment,customFields: null == customFields ? _self._customFields : customFields // ignore: cast_nullable_to_non_nullable
as List<CustomAssignment>,
  ));
}

/// Create a copy of MemorialProgram
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get chairman {
  
  return $AssignmentCopyWith<$Res>(_self.chairman, (value) {
    return _then(_self.copyWith(chairman: value));
  });
}/// Create a copy of MemorialProgram
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get speaker {
  
  return $AssignmentCopyWith<$Res>(_self.speaker, (value) {
    return _then(_self.copyWith(speaker: value));
  });
}/// Create a copy of MemorialProgram
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get breadPrayer {
  
  return $AssignmentCopyWith<$Res>(_self.breadPrayer, (value) {
    return _then(_self.copyWith(breadPrayer: value));
  });
}/// Create a copy of MemorialProgram
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get winePrayer {
  
  return $AssignmentCopyWith<$Res>(_self.winePrayer, (value) {
    return _then(_self.copyWith(winePrayer: value));
  });
}
}

// dart format on
