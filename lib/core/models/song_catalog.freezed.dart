// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song_catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SongCatalog {

/// Song number (as string — JSON map keys) -> title.
 Map<String, String> get titles;/// yyyy-MM-dd of the last fetch.
 String get updatedAt;/// Publication language last fetched (E / B / TK).
 String get lang;
/// Create a copy of SongCatalog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SongCatalogCopyWith<SongCatalog> get copyWith => _$SongCatalogCopyWithImpl<SongCatalog>(this as SongCatalog, _$identity);

  /// Serializes this SongCatalog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SongCatalog&&const DeepCollectionEquality().equals(other.titles, titles)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lang, lang) || other.lang == lang));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(titles),updatedAt,lang);

@override
String toString() {
  return 'SongCatalog(titles: $titles, updatedAt: $updatedAt, lang: $lang)';
}


}

/// @nodoc
abstract mixin class $SongCatalogCopyWith<$Res>  {
  factory $SongCatalogCopyWith(SongCatalog value, $Res Function(SongCatalog) _then) = _$SongCatalogCopyWithImpl;
@useResult
$Res call({
 Map<String, String> titles, String updatedAt, String lang
});




}
/// @nodoc
class _$SongCatalogCopyWithImpl<$Res>
    implements $SongCatalogCopyWith<$Res> {
  _$SongCatalogCopyWithImpl(this._self, this._then);

  final SongCatalog _self;
  final $Res Function(SongCatalog) _then;

/// Create a copy of SongCatalog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titles = null,Object? updatedAt = null,Object? lang = null,}) {
  return _then(_self.copyWith(
titles: null == titles ? _self.titles : titles // ignore: cast_nullable_to_non_nullable
as Map<String, String>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SongCatalog].
extension SongCatalogPatterns on SongCatalog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SongCatalog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SongCatalog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SongCatalog value)  $default,){
final _that = this;
switch (_that) {
case _SongCatalog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SongCatalog value)?  $default,){
final _that = this;
switch (_that) {
case _SongCatalog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, String> titles,  String updatedAt,  String lang)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SongCatalog() when $default != null:
return $default(_that.titles,_that.updatedAt,_that.lang);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, String> titles,  String updatedAt,  String lang)  $default,) {final _that = this;
switch (_that) {
case _SongCatalog():
return $default(_that.titles,_that.updatedAt,_that.lang);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, String> titles,  String updatedAt,  String lang)?  $default,) {final _that = this;
switch (_that) {
case _SongCatalog() when $default != null:
return $default(_that.titles,_that.updatedAt,_that.lang);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SongCatalog extends SongCatalog {
  const _SongCatalog({final  Map<String, String> titles = const <String, String>{}, this.updatedAt = '', this.lang = ''}): _titles = titles,super._();
  factory _SongCatalog.fromJson(Map<String, dynamic> json) => _$SongCatalogFromJson(json);

/// Song number (as string — JSON map keys) -> title.
 final  Map<String, String> _titles;
/// Song number (as string — JSON map keys) -> title.
@override@JsonKey() Map<String, String> get titles {
  if (_titles is EqualUnmodifiableMapView) return _titles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_titles);
}

/// yyyy-MM-dd of the last fetch.
@override@JsonKey() final  String updatedAt;
/// Publication language last fetched (E / B / TK).
@override@JsonKey() final  String lang;

/// Create a copy of SongCatalog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SongCatalogCopyWith<_SongCatalog> get copyWith => __$SongCatalogCopyWithImpl<_SongCatalog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SongCatalogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SongCatalog&&const DeepCollectionEquality().equals(other._titles, _titles)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lang, lang) || other.lang == lang));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_titles),updatedAt,lang);

@override
String toString() {
  return 'SongCatalog(titles: $titles, updatedAt: $updatedAt, lang: $lang)';
}


}

/// @nodoc
abstract mixin class _$SongCatalogCopyWith<$Res> implements $SongCatalogCopyWith<$Res> {
  factory _$SongCatalogCopyWith(_SongCatalog value, $Res Function(_SongCatalog) _then) = __$SongCatalogCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String> titles, String updatedAt, String lang
});




}
/// @nodoc
class __$SongCatalogCopyWithImpl<$Res>
    implements _$SongCatalogCopyWith<$Res> {
  __$SongCatalogCopyWithImpl(this._self, this._then);

  final _SongCatalog _self;
  final $Res Function(_SongCatalog) _then;

/// Create a copy of SongCatalog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titles = null,Object? updatedAt = null,Object? lang = null,}) {
  return _then(_SongCatalog(
titles: null == titles ? _self._titles : titles // ignore: cast_nullable_to_non_nullable
as Map<String, String>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
