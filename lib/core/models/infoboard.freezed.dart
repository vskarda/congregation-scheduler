// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'infoboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InfoboardItem {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; InfoItemType get type; String get title;/// Text content for [InfoItemType.text].
 String get body;/// files/{fileId} reference for [InfoItemType.file].
 String get fileId;/// Optional external URL for [InfoItemType.text] announcements.
 String get url;/// Visibility window (yyyy-MM-dd, inclusive); empty = unbounded.
 String get showFrom; String get showUntil;@NullableTimestampConverter() DateTime? get createdAt; String get createdBy;
/// Create a copy of InfoboardItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InfoboardItemCopyWith<InfoboardItem> get copyWith => _$InfoboardItemCopyWithImpl<InfoboardItem>(this as InfoboardItem, _$identity);

  /// Serializes this InfoboardItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InfoboardItem&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.url, url) || other.url == url)&&(identical(other.showFrom, showFrom) || other.showFrom == showFrom)&&(identical(other.showUntil, showUntil) || other.showUntil == showUntil)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,body,fileId,url,showFrom,showUntil,createdAt,createdBy);

@override
String toString() {
  return 'InfoboardItem(id: $id, type: $type, title: $title, body: $body, fileId: $fileId, url: $url, showFrom: $showFrom, showUntil: $showUntil, createdAt: $createdAt, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class $InfoboardItemCopyWith<$Res>  {
  factory $InfoboardItemCopyWith(InfoboardItem value, $Res Function(InfoboardItem) _then) = _$InfoboardItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, InfoItemType type, String title, String body, String fileId, String url, String showFrom, String showUntil,@NullableTimestampConverter() DateTime? createdAt, String createdBy
});




}
/// @nodoc
class _$InfoboardItemCopyWithImpl<$Res>
    implements $InfoboardItemCopyWith<$Res> {
  _$InfoboardItemCopyWithImpl(this._self, this._then);

  final InfoboardItem _self;
  final $Res Function(InfoboardItem) _then;

/// Create a copy of InfoboardItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? body = null,Object? fileId = null,Object? url = null,Object? showFrom = null,Object? showUntil = null,Object? createdAt = freezed,Object? createdBy = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InfoItemType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,showFrom: null == showFrom ? _self.showFrom : showFrom // ignore: cast_nullable_to_non_nullable
as String,showUntil: null == showUntil ? _self.showUntil : showUntil // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InfoboardItem].
extension InfoboardItemPatterns on InfoboardItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InfoboardItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InfoboardItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InfoboardItem value)  $default,){
final _that = this;
switch (_that) {
case _InfoboardItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InfoboardItem value)?  $default,){
final _that = this;
switch (_that) {
case _InfoboardItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  InfoItemType type,  String title,  String body,  String fileId,  String url,  String showFrom,  String showUntil, @NullableTimestampConverter()  DateTime? createdAt,  String createdBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InfoboardItem() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.body,_that.fileId,_that.url,_that.showFrom,_that.showUntil,_that.createdAt,_that.createdBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  InfoItemType type,  String title,  String body,  String fileId,  String url,  String showFrom,  String showUntil, @NullableTimestampConverter()  DateTime? createdAt,  String createdBy)  $default,) {final _that = this;
switch (_that) {
case _InfoboardItem():
return $default(_that.id,_that.type,_that.title,_that.body,_that.fileId,_that.url,_that.showFrom,_that.showUntil,_that.createdAt,_that.createdBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  InfoItemType type,  String title,  String body,  String fileId,  String url,  String showFrom,  String showUntil, @NullableTimestampConverter()  DateTime? createdAt,  String createdBy)?  $default,) {final _that = this;
switch (_that) {
case _InfoboardItem() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.body,_that.fileId,_that.url,_that.showFrom,_that.showUntil,_that.createdAt,_that.createdBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InfoboardItem extends InfoboardItem {
  const _InfoboardItem({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.type = InfoItemType.text, this.title = '', this.body = '', this.fileId = '', this.url = '', this.showFrom = '', this.showUntil = '', @NullableTimestampConverter() this.createdAt, this.createdBy = ''}): super._();
  factory _InfoboardItem.fromJson(Map<String, dynamic> json) => _$InfoboardItemFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  InfoItemType type;
@override@JsonKey() final  String title;
/// Text content for [InfoItemType.text].
@override@JsonKey() final  String body;
/// files/{fileId} reference for [InfoItemType.file].
@override@JsonKey() final  String fileId;
/// Optional external URL for [InfoItemType.text] announcements.
@override@JsonKey() final  String url;
/// Visibility window (yyyy-MM-dd, inclusive); empty = unbounded.
@override@JsonKey() final  String showFrom;
@override@JsonKey() final  String showUntil;
@override@NullableTimestampConverter() final  DateTime? createdAt;
@override@JsonKey() final  String createdBy;

/// Create a copy of InfoboardItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InfoboardItemCopyWith<_InfoboardItem> get copyWith => __$InfoboardItemCopyWithImpl<_InfoboardItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InfoboardItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InfoboardItem&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.url, url) || other.url == url)&&(identical(other.showFrom, showFrom) || other.showFrom == showFrom)&&(identical(other.showUntil, showUntil) || other.showUntil == showUntil)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,body,fileId,url,showFrom,showUntil,createdAt,createdBy);

@override
String toString() {
  return 'InfoboardItem(id: $id, type: $type, title: $title, body: $body, fileId: $fileId, url: $url, showFrom: $showFrom, showUntil: $showUntil, createdAt: $createdAt, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class _$InfoboardItemCopyWith<$Res> implements $InfoboardItemCopyWith<$Res> {
  factory _$InfoboardItemCopyWith(_InfoboardItem value, $Res Function(_InfoboardItem) _then) = __$InfoboardItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, InfoItemType type, String title, String body, String fileId, String url, String showFrom, String showUntil,@NullableTimestampConverter() DateTime? createdAt, String createdBy
});




}
/// @nodoc
class __$InfoboardItemCopyWithImpl<$Res>
    implements _$InfoboardItemCopyWith<$Res> {
  __$InfoboardItemCopyWithImpl(this._self, this._then);

  final _InfoboardItem _self;
  final $Res Function(_InfoboardItem) _then;

/// Create a copy of InfoboardItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? body = null,Object? fileId = null,Object? url = null,Object? showFrom = null,Object? showUntil = null,Object? createdAt = freezed,Object? createdBy = null,}) {
  return _then(_InfoboardItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InfoItemType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,showFrom: null == showFrom ? _self.showFrom : showFrom // ignore: cast_nullable_to_non_nullable
as String,showUntil: null == showUntil ? _self.showUntil : showUntil // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StoredFileMeta {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get name; String get mimeType; int get sizeBytes; int get chunkCount;
/// Create a copy of StoredFileMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoredFileMetaCopyWith<StoredFileMeta> get copyWith => _$StoredFileMetaCopyWithImpl<StoredFileMeta>(this as StoredFileMeta, _$identity);

  /// Serializes this StoredFileMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoredFileMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.chunkCount, chunkCount) || other.chunkCount == chunkCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mimeType,sizeBytes,chunkCount);

@override
String toString() {
  return 'StoredFileMeta(id: $id, name: $name, mimeType: $mimeType, sizeBytes: $sizeBytes, chunkCount: $chunkCount)';
}


}

/// @nodoc
abstract mixin class $StoredFileMetaCopyWith<$Res>  {
  factory $StoredFileMetaCopyWith(StoredFileMeta value, $Res Function(StoredFileMeta) _then) = _$StoredFileMetaCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String name, String mimeType, int sizeBytes, int chunkCount
});




}
/// @nodoc
class _$StoredFileMetaCopyWithImpl<$Res>
    implements $StoredFileMetaCopyWith<$Res> {
  _$StoredFileMetaCopyWithImpl(this._self, this._then);

  final StoredFileMeta _self;
  final $Res Function(StoredFileMeta) _then;

/// Create a copy of StoredFileMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? mimeType = null,Object? sizeBytes = null,Object? chunkCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,chunkCount: null == chunkCount ? _self.chunkCount : chunkCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StoredFileMeta].
extension StoredFileMetaPatterns on StoredFileMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoredFileMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoredFileMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoredFileMeta value)  $default,){
final _that = this;
switch (_that) {
case _StoredFileMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoredFileMeta value)?  $default,){
final _that = this;
switch (_that) {
case _StoredFileMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String name,  String mimeType,  int sizeBytes,  int chunkCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoredFileMeta() when $default != null:
return $default(_that.id,_that.name,_that.mimeType,_that.sizeBytes,_that.chunkCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String name,  String mimeType,  int sizeBytes,  int chunkCount)  $default,) {final _that = this;
switch (_that) {
case _StoredFileMeta():
return $default(_that.id,_that.name,_that.mimeType,_that.sizeBytes,_that.chunkCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String name,  String mimeType,  int sizeBytes,  int chunkCount)?  $default,) {final _that = this;
switch (_that) {
case _StoredFileMeta() when $default != null:
return $default(_that.id,_that.name,_that.mimeType,_that.sizeBytes,_that.chunkCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoredFileMeta implements StoredFileMeta {
  const _StoredFileMeta({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.name = '', this.mimeType = '', this.sizeBytes = 0, this.chunkCount = 0});
  factory _StoredFileMeta.fromJson(Map<String, dynamic> json) => _$StoredFileMetaFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String mimeType;
@override@JsonKey() final  int sizeBytes;
@override@JsonKey() final  int chunkCount;

/// Create a copy of StoredFileMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoredFileMetaCopyWith<_StoredFileMeta> get copyWith => __$StoredFileMetaCopyWithImpl<_StoredFileMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoredFileMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoredFileMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.chunkCount, chunkCount) || other.chunkCount == chunkCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mimeType,sizeBytes,chunkCount);

@override
String toString() {
  return 'StoredFileMeta(id: $id, name: $name, mimeType: $mimeType, sizeBytes: $sizeBytes, chunkCount: $chunkCount)';
}


}

/// @nodoc
abstract mixin class _$StoredFileMetaCopyWith<$Res> implements $StoredFileMetaCopyWith<$Res> {
  factory _$StoredFileMetaCopyWith(_StoredFileMeta value, $Res Function(_StoredFileMeta) _then) = __$StoredFileMetaCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String name, String mimeType, int sizeBytes, int chunkCount
});




}
/// @nodoc
class __$StoredFileMetaCopyWithImpl<$Res>
    implements _$StoredFileMetaCopyWith<$Res> {
  __$StoredFileMetaCopyWithImpl(this._self, this._then);

  final _StoredFileMeta _self;
  final $Res Function(_StoredFileMeta) _then;

/// Create a copy of StoredFileMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? mimeType = null,Object? sizeBytes = null,Object? chunkCount = null,}) {
  return _then(_StoredFileMeta(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,chunkCount: null == chunkCount ? _self.chunkCount : chunkCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
