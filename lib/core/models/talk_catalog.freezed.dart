// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'talk_catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TalkCatalog {

/// Talk number (as string — JSON map keys) -> approved title.
 Map<String, String> get titles;/// yyyy-MM-dd of the last import or manual edit.
 String get updatedAt;/// Name of the imported file, for reference.
 String get source;
/// Create a copy of TalkCatalog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TalkCatalogCopyWith<TalkCatalog> get copyWith => _$TalkCatalogCopyWithImpl<TalkCatalog>(this as TalkCatalog, _$identity);

  /// Serializes this TalkCatalog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TalkCatalog&&const DeepCollectionEquality().equals(other.titles, titles)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(titles),updatedAt,source);

@override
String toString() {
  return 'TalkCatalog(titles: $titles, updatedAt: $updatedAt, source: $source)';
}


}

/// @nodoc
abstract mixin class $TalkCatalogCopyWith<$Res>  {
  factory $TalkCatalogCopyWith(TalkCatalog value, $Res Function(TalkCatalog) _then) = _$TalkCatalogCopyWithImpl;
@useResult
$Res call({
 Map<String, String> titles, String updatedAt, String source
});




}
/// @nodoc
class _$TalkCatalogCopyWithImpl<$Res>
    implements $TalkCatalogCopyWith<$Res> {
  _$TalkCatalogCopyWithImpl(this._self, this._then);

  final TalkCatalog _self;
  final $Res Function(TalkCatalog) _then;

/// Create a copy of TalkCatalog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titles = null,Object? updatedAt = null,Object? source = null,}) {
  return _then(_self.copyWith(
titles: null == titles ? _self.titles : titles // ignore: cast_nullable_to_non_nullable
as Map<String, String>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TalkCatalog].
extension TalkCatalogPatterns on TalkCatalog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TalkCatalog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TalkCatalog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TalkCatalog value)  $default,){
final _that = this;
switch (_that) {
case _TalkCatalog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TalkCatalog value)?  $default,){
final _that = this;
switch (_that) {
case _TalkCatalog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, String> titles,  String updatedAt,  String source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TalkCatalog() when $default != null:
return $default(_that.titles,_that.updatedAt,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, String> titles,  String updatedAt,  String source)  $default,) {final _that = this;
switch (_that) {
case _TalkCatalog():
return $default(_that.titles,_that.updatedAt,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, String> titles,  String updatedAt,  String source)?  $default,) {final _that = this;
switch (_that) {
case _TalkCatalog() when $default != null:
return $default(_that.titles,_that.updatedAt,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TalkCatalog extends TalkCatalog {
  const _TalkCatalog({final  Map<String, String> titles = const <String, String>{}, this.updatedAt = '', this.source = ''}): _titles = titles,super._();
  factory _TalkCatalog.fromJson(Map<String, dynamic> json) => _$TalkCatalogFromJson(json);

/// Talk number (as string — JSON map keys) -> approved title.
 final  Map<String, String> _titles;
/// Talk number (as string — JSON map keys) -> approved title.
@override@JsonKey() Map<String, String> get titles {
  if (_titles is EqualUnmodifiableMapView) return _titles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_titles);
}

/// yyyy-MM-dd of the last import or manual edit.
@override@JsonKey() final  String updatedAt;
/// Name of the imported file, for reference.
@override@JsonKey() final  String source;

/// Create a copy of TalkCatalog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TalkCatalogCopyWith<_TalkCatalog> get copyWith => __$TalkCatalogCopyWithImpl<_TalkCatalog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TalkCatalogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TalkCatalog&&const DeepCollectionEquality().equals(other._titles, _titles)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_titles),updatedAt,source);

@override
String toString() {
  return 'TalkCatalog(titles: $titles, updatedAt: $updatedAt, source: $source)';
}


}

/// @nodoc
abstract mixin class _$TalkCatalogCopyWith<$Res> implements $TalkCatalogCopyWith<$Res> {
  factory _$TalkCatalogCopyWith(_TalkCatalog value, $Res Function(_TalkCatalog) _then) = __$TalkCatalogCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String> titles, String updatedAt, String source
});




}
/// @nodoc
class __$TalkCatalogCopyWithImpl<$Res>
    implements _$TalkCatalogCopyWith<$Res> {
  __$TalkCatalogCopyWithImpl(this._self, this._then);

  final _TalkCatalog _self;
  final $Res Function(_TalkCatalog) _then;

/// Create a copy of TalkCatalog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titles = null,Object? updatedAt = null,Object? source = null,}) {
  return _then(_TalkCatalog(
titles: null == titles ? _self._titles : titles // ignore: cast_nullable_to_non_nullable
as Map<String, String>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
