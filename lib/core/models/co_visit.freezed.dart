// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'co_visit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoVisitItem {

/// Stable within the visit document, so editing one item never disturbs
/// another.
 String get id; CoVisitSection get section;/// yyyy-MM-dd; empty when no day has been settled yet.
 String get date;/// HH:mm; empty when no time has been settled yet.
 String get time; Assignment get assignment; String get address; String get note;
/// Create a copy of CoVisitItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoVisitItemCopyWith<CoVisitItem> get copyWith => _$CoVisitItemCopyWithImpl<CoVisitItem>(this as CoVisitItem, _$identity);

  /// Serializes this CoVisitItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoVisitItem&&(identical(other.id, id) || other.id == id)&&(identical(other.section, section) || other.section == section)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.assignment, assignment) || other.assignment == assignment)&&(identical(other.address, address) || other.address == address)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,section,date,time,assignment,address,note);

@override
String toString() {
  return 'CoVisitItem(id: $id, section: $section, date: $date, time: $time, assignment: $assignment, address: $address, note: $note)';
}


}

/// @nodoc
abstract mixin class $CoVisitItemCopyWith<$Res>  {
  factory $CoVisitItemCopyWith(CoVisitItem value, $Res Function(CoVisitItem) _then) = _$CoVisitItemCopyWithImpl;
@useResult
$Res call({
 String id, CoVisitSection section, String date, String time, Assignment assignment, String address, String note
});


$AssignmentCopyWith<$Res> get assignment;

}
/// @nodoc
class _$CoVisitItemCopyWithImpl<$Res>
    implements $CoVisitItemCopyWith<$Res> {
  _$CoVisitItemCopyWithImpl(this._self, this._then);

  final CoVisitItem _self;
  final $Res Function(CoVisitItem) _then;

/// Create a copy of CoVisitItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? section = null,Object? date = null,Object? time = null,Object? assignment = null,Object? address = null,Object? note = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as CoVisitSection,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,assignment: null == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as Assignment,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of CoVisitItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignmentCopyWith<$Res> get assignment {
  
  return $AssignmentCopyWith<$Res>(_self.assignment, (value) {
    return _then(_self.copyWith(assignment: value));
  });
}
}


/// Adds pattern-matching-related methods to [CoVisitItem].
extension CoVisitItemPatterns on CoVisitItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoVisitItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoVisitItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoVisitItem value)  $default,){
final _that = this;
switch (_that) {
case _CoVisitItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoVisitItem value)?  $default,){
final _that = this;
switch (_that) {
case _CoVisitItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  CoVisitSection section,  String date,  String time,  Assignment assignment,  String address,  String note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoVisitItem() when $default != null:
return $default(_that.id,_that.section,_that.date,_that.time,_that.assignment,_that.address,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  CoVisitSection section,  String date,  String time,  Assignment assignment,  String address,  String note)  $default,) {final _that = this;
switch (_that) {
case _CoVisitItem():
return $default(_that.id,_that.section,_that.date,_that.time,_that.assignment,_that.address,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  CoVisitSection section,  String date,  String time,  Assignment assignment,  String address,  String note)?  $default,) {final _that = this;
switch (_that) {
case _CoVisitItem() when $default != null:
return $default(_that.id,_that.section,_that.date,_that.time,_that.assignment,_that.address,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoVisitItem extends CoVisitItem {
  const _CoVisitItem({this.id = '', this.section = CoVisitSection.other, this.date = '', this.time = '', this.assignment = const Assignment(), this.address = '', this.note = ''}): super._();
  factory _CoVisitItem.fromJson(Map<String, dynamic> json) => _$CoVisitItemFromJson(json);

/// Stable within the visit document, so editing one item never disturbs
/// another.
@override@JsonKey() final  String id;
@override@JsonKey() final  CoVisitSection section;
/// yyyy-MM-dd; empty when no day has been settled yet.
@override@JsonKey() final  String date;
/// HH:mm; empty when no time has been settled yet.
@override@JsonKey() final  String time;
@override@JsonKey() final  Assignment assignment;
@override@JsonKey() final  String address;
@override@JsonKey() final  String note;

/// Create a copy of CoVisitItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoVisitItemCopyWith<_CoVisitItem> get copyWith => __$CoVisitItemCopyWithImpl<_CoVisitItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoVisitItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoVisitItem&&(identical(other.id, id) || other.id == id)&&(identical(other.section, section) || other.section == section)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.assignment, assignment) || other.assignment == assignment)&&(identical(other.address, address) || other.address == address)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,section,date,time,assignment,address,note);

@override
String toString() {
  return 'CoVisitItem(id: $id, section: $section, date: $date, time: $time, assignment: $assignment, address: $address, note: $note)';
}


}

/// @nodoc
abstract mixin class _$CoVisitItemCopyWith<$Res> implements $CoVisitItemCopyWith<$Res> {
  factory _$CoVisitItemCopyWith(_CoVisitItem value, $Res Function(_CoVisitItem) _then) = __$CoVisitItemCopyWithImpl;
@override @useResult
$Res call({
 String id, CoVisitSection section, String date, String time, Assignment assignment, String address, String note
});


@override $AssignmentCopyWith<$Res> get assignment;

}
/// @nodoc
class __$CoVisitItemCopyWithImpl<$Res>
    implements _$CoVisitItemCopyWith<$Res> {
  __$CoVisitItemCopyWithImpl(this._self, this._then);

  final _CoVisitItem _self;
  final $Res Function(_CoVisitItem) _then;

/// Create a copy of CoVisitItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? section = null,Object? date = null,Object? time = null,Object? assignment = null,Object? address = null,Object? note = null,}) {
  return _then(_CoVisitItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as CoVisitSection,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,assignment: null == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as Assignment,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of CoVisitItem
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
mixin _$CoVisit {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; List<CoVisitItem> get items;/// [CoVisitSection] names the admin has hidden for this visit. Hidden
/// sections stay visible (dimmed) to the admins who may edit the visit,
/// disappear for everyone else, and print only on request.
 List<String> get hiddenSections;/// Denormalized union of every assigned publisher id, kept in sync on
/// save; enables array-contains "my assignments" queries.
 List<String> get allAssigneeIds;
/// Create a copy of CoVisit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoVisitCopyWith<CoVisit> get copyWith => _$CoVisitCopyWithImpl<CoVisit>(this as CoVisit, _$identity);

  /// Serializes this CoVisit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoVisit&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.hiddenSections, hiddenSections)&&const DeepCollectionEquality().equals(other.allAssigneeIds, allAssigneeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(hiddenSections),const DeepCollectionEquality().hash(allAssigneeIds));

@override
String toString() {
  return 'CoVisit(id: $id, items: $items, hiddenSections: $hiddenSections, allAssigneeIds: $allAssigneeIds)';
}


}

/// @nodoc
abstract mixin class $CoVisitCopyWith<$Res>  {
  factory $CoVisitCopyWith(CoVisit value, $Res Function(CoVisit) _then) = _$CoVisitCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, List<CoVisitItem> items, List<String> hiddenSections, List<String> allAssigneeIds
});




}
/// @nodoc
class _$CoVisitCopyWithImpl<$Res>
    implements $CoVisitCopyWith<$Res> {
  _$CoVisitCopyWithImpl(this._self, this._then);

  final CoVisit _self;
  final $Res Function(CoVisit) _then;

/// Create a copy of CoVisit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? items = null,Object? hiddenSections = null,Object? allAssigneeIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CoVisitItem>,hiddenSections: null == hiddenSections ? _self.hiddenSections : hiddenSections // ignore: cast_nullable_to_non_nullable
as List<String>,allAssigneeIds: null == allAssigneeIds ? _self.allAssigneeIds : allAssigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CoVisit].
extension CoVisitPatterns on CoVisit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoVisit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoVisit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoVisit value)  $default,){
final _that = this;
switch (_that) {
case _CoVisit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoVisit value)?  $default,){
final _that = this;
switch (_that) {
case _CoVisit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  List<CoVisitItem> items,  List<String> hiddenSections,  List<String> allAssigneeIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoVisit() when $default != null:
return $default(_that.id,_that.items,_that.hiddenSections,_that.allAssigneeIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  List<CoVisitItem> items,  List<String> hiddenSections,  List<String> allAssigneeIds)  $default,) {final _that = this;
switch (_that) {
case _CoVisit():
return $default(_that.id,_that.items,_that.hiddenSections,_that.allAssigneeIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  List<CoVisitItem> items,  List<String> hiddenSections,  List<String> allAssigneeIds)?  $default,) {final _that = this;
switch (_that) {
case _CoVisit() when $default != null:
return $default(_that.id,_that.items,_that.hiddenSections,_that.allAssigneeIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoVisit extends CoVisit {
  const _CoVisit({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', final  List<CoVisitItem> items = const <CoVisitItem>[], final  List<String> hiddenSections = const <String>[], final  List<String> allAssigneeIds = const <String>[]}): _items = items,_hiddenSections = hiddenSections,_allAssigneeIds = allAssigneeIds,super._();
  factory _CoVisit.fromJson(Map<String, dynamic> json) => _$CoVisitFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
 final  List<CoVisitItem> _items;
@override@JsonKey() List<CoVisitItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// [CoVisitSection] names the admin has hidden for this visit. Hidden
/// sections stay visible (dimmed) to the admins who may edit the visit,
/// disappear for everyone else, and print only on request.
 final  List<String> _hiddenSections;
/// [CoVisitSection] names the admin has hidden for this visit. Hidden
/// sections stay visible (dimmed) to the admins who may edit the visit,
/// disappear for everyone else, and print only on request.
@override@JsonKey() List<String> get hiddenSections {
  if (_hiddenSections is EqualUnmodifiableListView) return _hiddenSections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hiddenSections);
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


/// Create a copy of CoVisit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoVisitCopyWith<_CoVisit> get copyWith => __$CoVisitCopyWithImpl<_CoVisit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoVisitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoVisit&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._hiddenSections, _hiddenSections)&&const DeepCollectionEquality().equals(other._allAssigneeIds, _allAssigneeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_hiddenSections),const DeepCollectionEquality().hash(_allAssigneeIds));

@override
String toString() {
  return 'CoVisit(id: $id, items: $items, hiddenSections: $hiddenSections, allAssigneeIds: $allAssigneeIds)';
}


}

/// @nodoc
abstract mixin class _$CoVisitCopyWith<$Res> implements $CoVisitCopyWith<$Res> {
  factory _$CoVisitCopyWith(_CoVisit value, $Res Function(_CoVisit) _then) = __$CoVisitCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, List<CoVisitItem> items, List<String> hiddenSections, List<String> allAssigneeIds
});




}
/// @nodoc
class __$CoVisitCopyWithImpl<$Res>
    implements _$CoVisitCopyWith<$Res> {
  __$CoVisitCopyWithImpl(this._self, this._then);

  final _CoVisit _self;
  final $Res Function(_CoVisit) _then;

/// Create a copy of CoVisit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? items = null,Object? hiddenSections = null,Object? allAssigneeIds = null,}) {
  return _then(_CoVisit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CoVisitItem>,hiddenSections: null == hiddenSections ? _self._hiddenSections : hiddenSections // ignore: cast_nullable_to_non_nullable
as List<String>,allAssigneeIds: null == allAssigneeIds ? _self._allAssigneeIds : allAssigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$CoVisitConfig {

/// Whether publishers see the circuit overseer view at all. Off until an
/// admin turns it on, so a half-planned visit is not on show.
///
/// This hides the view; it does not protect it. `co_visits` is readable by
/// every verified user (firestore.rules), exactly like the schedules.
 bool get visibleToPublishers;
/// Create a copy of CoVisitConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoVisitConfigCopyWith<CoVisitConfig> get copyWith => _$CoVisitConfigCopyWithImpl<CoVisitConfig>(this as CoVisitConfig, _$identity);

  /// Serializes this CoVisitConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoVisitConfig&&(identical(other.visibleToPublishers, visibleToPublishers) || other.visibleToPublishers == visibleToPublishers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,visibleToPublishers);

@override
String toString() {
  return 'CoVisitConfig(visibleToPublishers: $visibleToPublishers)';
}


}

/// @nodoc
abstract mixin class $CoVisitConfigCopyWith<$Res>  {
  factory $CoVisitConfigCopyWith(CoVisitConfig value, $Res Function(CoVisitConfig) _then) = _$CoVisitConfigCopyWithImpl;
@useResult
$Res call({
 bool visibleToPublishers
});




}
/// @nodoc
class _$CoVisitConfigCopyWithImpl<$Res>
    implements $CoVisitConfigCopyWith<$Res> {
  _$CoVisitConfigCopyWithImpl(this._self, this._then);

  final CoVisitConfig _self;
  final $Res Function(CoVisitConfig) _then;

/// Create a copy of CoVisitConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? visibleToPublishers = null,}) {
  return _then(_self.copyWith(
visibleToPublishers: null == visibleToPublishers ? _self.visibleToPublishers : visibleToPublishers // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CoVisitConfig].
extension CoVisitConfigPatterns on CoVisitConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoVisitConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoVisitConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoVisitConfig value)  $default,){
final _that = this;
switch (_that) {
case _CoVisitConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoVisitConfig value)?  $default,){
final _that = this;
switch (_that) {
case _CoVisitConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool visibleToPublishers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoVisitConfig() when $default != null:
return $default(_that.visibleToPublishers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool visibleToPublishers)  $default,) {final _that = this;
switch (_that) {
case _CoVisitConfig():
return $default(_that.visibleToPublishers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool visibleToPublishers)?  $default,) {final _that = this;
switch (_that) {
case _CoVisitConfig() when $default != null:
return $default(_that.visibleToPublishers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoVisitConfig implements CoVisitConfig {
  const _CoVisitConfig({this.visibleToPublishers = false});
  factory _CoVisitConfig.fromJson(Map<String, dynamic> json) => _$CoVisitConfigFromJson(json);

/// Whether publishers see the circuit overseer view at all. Off until an
/// admin turns it on, so a half-planned visit is not on show.
///
/// This hides the view; it does not protect it. `co_visits` is readable by
/// every verified user (firestore.rules), exactly like the schedules.
@override@JsonKey() final  bool visibleToPublishers;

/// Create a copy of CoVisitConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoVisitConfigCopyWith<_CoVisitConfig> get copyWith => __$CoVisitConfigCopyWithImpl<_CoVisitConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoVisitConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoVisitConfig&&(identical(other.visibleToPublishers, visibleToPublishers) || other.visibleToPublishers == visibleToPublishers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,visibleToPublishers);

@override
String toString() {
  return 'CoVisitConfig(visibleToPublishers: $visibleToPublishers)';
}


}

/// @nodoc
abstract mixin class _$CoVisitConfigCopyWith<$Res> implements $CoVisitConfigCopyWith<$Res> {
  factory _$CoVisitConfigCopyWith(_CoVisitConfig value, $Res Function(_CoVisitConfig) _then) = __$CoVisitConfigCopyWithImpl;
@override @useResult
$Res call({
 bool visibleToPublishers
});




}
/// @nodoc
class __$CoVisitConfigCopyWithImpl<$Res>
    implements _$CoVisitConfigCopyWith<$Res> {
  __$CoVisitConfigCopyWithImpl(this._self, this._then);

  final _CoVisitConfig _self;
  final $Res Function(_CoVisitConfig) _then;

/// Create a copy of CoVisitConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? visibleToPublishers = null,}) {
  return _then(_CoVisitConfig(
visibleToPublishers: null == visibleToPublishers ? _self.visibleToPublishers : visibleToPublishers // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
