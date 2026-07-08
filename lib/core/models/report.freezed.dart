// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MinistryReport {

/// = publisher document id.
@JsonKey(includeFromJson: false, includeToJson: false) String get publisherId;/// yyyy-MM
 String get month; bool get participated; int? get bibleStudies;/// Field service hours (pioneers).
 int? get hours;/// Credit hours (Bethel, construction, pioneer school, …).
 int? get creditHours; String get comments;/// Publisher status snapshot for the reported month; drives the S-1
/// group breakdown even when the status changes later.
 PublisherStatus get statusAtMonth;@NullableTimestampConverter() DateTime? get submittedAt;/// 'self' or the uid of the admin who entered a paper report.
 String get enteredBy;
/// Create a copy of MinistryReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MinistryReportCopyWith<MinistryReport> get copyWith => _$MinistryReportCopyWithImpl<MinistryReport>(this as MinistryReport, _$identity);

  /// Serializes this MinistryReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MinistryReport&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId)&&(identical(other.month, month) || other.month == month)&&(identical(other.participated, participated) || other.participated == participated)&&(identical(other.bibleStudies, bibleStudies) || other.bibleStudies == bibleStudies)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.creditHours, creditHours) || other.creditHours == creditHours)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.statusAtMonth, statusAtMonth) || other.statusAtMonth == statusAtMonth)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.enteredBy, enteredBy) || other.enteredBy == enteredBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publisherId,month,participated,bibleStudies,hours,creditHours,comments,statusAtMonth,submittedAt,enteredBy);

@override
String toString() {
  return 'MinistryReport(publisherId: $publisherId, month: $month, participated: $participated, bibleStudies: $bibleStudies, hours: $hours, creditHours: $creditHours, comments: $comments, statusAtMonth: $statusAtMonth, submittedAt: $submittedAt, enteredBy: $enteredBy)';
}


}

/// @nodoc
abstract mixin class $MinistryReportCopyWith<$Res>  {
  factory $MinistryReportCopyWith(MinistryReport value, $Res Function(MinistryReport) _then) = _$MinistryReportCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String publisherId, String month, bool participated, int? bibleStudies, int? hours, int? creditHours, String comments, PublisherStatus statusAtMonth,@NullableTimestampConverter() DateTime? submittedAt, String enteredBy
});




}
/// @nodoc
class _$MinistryReportCopyWithImpl<$Res>
    implements $MinistryReportCopyWith<$Res> {
  _$MinistryReportCopyWithImpl(this._self, this._then);

  final MinistryReport _self;
  final $Res Function(MinistryReport) _then;

/// Create a copy of MinistryReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publisherId = null,Object? month = null,Object? participated = null,Object? bibleStudies = freezed,Object? hours = freezed,Object? creditHours = freezed,Object? comments = null,Object? statusAtMonth = null,Object? submittedAt = freezed,Object? enteredBy = null,}) {
  return _then(_self.copyWith(
publisherId: null == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,participated: null == participated ? _self.participated : participated // ignore: cast_nullable_to_non_nullable
as bool,bibleStudies: freezed == bibleStudies ? _self.bibleStudies : bibleStudies // ignore: cast_nullable_to_non_nullable
as int?,hours: freezed == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as int?,creditHours: freezed == creditHours ? _self.creditHours : creditHours // ignore: cast_nullable_to_non_nullable
as int?,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String,statusAtMonth: null == statusAtMonth ? _self.statusAtMonth : statusAtMonth // ignore: cast_nullable_to_non_nullable
as PublisherStatus,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,enteredBy: null == enteredBy ? _self.enteredBy : enteredBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MinistryReport].
extension MinistryReportPatterns on MinistryReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MinistryReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MinistryReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MinistryReport value)  $default,){
final _that = this;
switch (_that) {
case _MinistryReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MinistryReport value)?  $default,){
final _that = this;
switch (_that) {
case _MinistryReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String publisherId,  String month,  bool participated,  int? bibleStudies,  int? hours,  int? creditHours,  String comments,  PublisherStatus statusAtMonth, @NullableTimestampConverter()  DateTime? submittedAt,  String enteredBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MinistryReport() when $default != null:
return $default(_that.publisherId,_that.month,_that.participated,_that.bibleStudies,_that.hours,_that.creditHours,_that.comments,_that.statusAtMonth,_that.submittedAt,_that.enteredBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String publisherId,  String month,  bool participated,  int? bibleStudies,  int? hours,  int? creditHours,  String comments,  PublisherStatus statusAtMonth, @NullableTimestampConverter()  DateTime? submittedAt,  String enteredBy)  $default,) {final _that = this;
switch (_that) {
case _MinistryReport():
return $default(_that.publisherId,_that.month,_that.participated,_that.bibleStudies,_that.hours,_that.creditHours,_that.comments,_that.statusAtMonth,_that.submittedAt,_that.enteredBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String publisherId,  String month,  bool participated,  int? bibleStudies,  int? hours,  int? creditHours,  String comments,  PublisherStatus statusAtMonth, @NullableTimestampConverter()  DateTime? submittedAt,  String enteredBy)?  $default,) {final _that = this;
switch (_that) {
case _MinistryReport() when $default != null:
return $default(_that.publisherId,_that.month,_that.participated,_that.bibleStudies,_that.hours,_that.creditHours,_that.comments,_that.statusAtMonth,_that.submittedAt,_that.enteredBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MinistryReport extends MinistryReport {
  const _MinistryReport({@JsonKey(includeFromJson: false, includeToJson: false) this.publisherId = '', this.month = '', this.participated = false, this.bibleStudies, this.hours, this.creditHours, this.comments = '', this.statusAtMonth = PublisherStatus.publisher, @NullableTimestampConverter() this.submittedAt, this.enteredBy = 'self'}): super._();
  factory _MinistryReport.fromJson(Map<String, dynamic> json) => _$MinistryReportFromJson(json);

/// = publisher document id.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String publisherId;
/// yyyy-MM
@override@JsonKey() final  String month;
@override@JsonKey() final  bool participated;
@override final  int? bibleStudies;
/// Field service hours (pioneers).
@override final  int? hours;
/// Credit hours (Bethel, construction, pioneer school, …).
@override final  int? creditHours;
@override@JsonKey() final  String comments;
/// Publisher status snapshot for the reported month; drives the S-1
/// group breakdown even when the status changes later.
@override@JsonKey() final  PublisherStatus statusAtMonth;
@override@NullableTimestampConverter() final  DateTime? submittedAt;
/// 'self' or the uid of the admin who entered a paper report.
@override@JsonKey() final  String enteredBy;

/// Create a copy of MinistryReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MinistryReportCopyWith<_MinistryReport> get copyWith => __$MinistryReportCopyWithImpl<_MinistryReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MinistryReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MinistryReport&&(identical(other.publisherId, publisherId) || other.publisherId == publisherId)&&(identical(other.month, month) || other.month == month)&&(identical(other.participated, participated) || other.participated == participated)&&(identical(other.bibleStudies, bibleStudies) || other.bibleStudies == bibleStudies)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.creditHours, creditHours) || other.creditHours == creditHours)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.statusAtMonth, statusAtMonth) || other.statusAtMonth == statusAtMonth)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.enteredBy, enteredBy) || other.enteredBy == enteredBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publisherId,month,participated,bibleStudies,hours,creditHours,comments,statusAtMonth,submittedAt,enteredBy);

@override
String toString() {
  return 'MinistryReport(publisherId: $publisherId, month: $month, participated: $participated, bibleStudies: $bibleStudies, hours: $hours, creditHours: $creditHours, comments: $comments, statusAtMonth: $statusAtMonth, submittedAt: $submittedAt, enteredBy: $enteredBy)';
}


}

/// @nodoc
abstract mixin class _$MinistryReportCopyWith<$Res> implements $MinistryReportCopyWith<$Res> {
  factory _$MinistryReportCopyWith(_MinistryReport value, $Res Function(_MinistryReport) _then) = __$MinistryReportCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String publisherId, String month, bool participated, int? bibleStudies, int? hours, int? creditHours, String comments, PublisherStatus statusAtMonth,@NullableTimestampConverter() DateTime? submittedAt, String enteredBy
});




}
/// @nodoc
class __$MinistryReportCopyWithImpl<$Res>
    implements _$MinistryReportCopyWith<$Res> {
  __$MinistryReportCopyWithImpl(this._self, this._then);

  final _MinistryReport _self;
  final $Res Function(_MinistryReport) _then;

/// Create a copy of MinistryReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publisherId = null,Object? month = null,Object? participated = null,Object? bibleStudies = freezed,Object? hours = freezed,Object? creditHours = freezed,Object? comments = null,Object? statusAtMonth = null,Object? submittedAt = freezed,Object? enteredBy = null,}) {
  return _then(_MinistryReport(
publisherId: null == publisherId ? _self.publisherId : publisherId // ignore: cast_nullable_to_non_nullable
as String,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as String,participated: null == participated ? _self.participated : participated // ignore: cast_nullable_to_non_nullable
as bool,bibleStudies: freezed == bibleStudies ? _self.bibleStudies : bibleStudies // ignore: cast_nullable_to_non_nullable
as int?,hours: freezed == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as int?,creditHours: freezed == creditHours ? _self.creditHours : creditHours // ignore: cast_nullable_to_non_nullable
as int?,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String,statusAtMonth: null == statusAtMonth ? _self.statusAtMonth : statusAtMonth // ignore: cast_nullable_to_non_nullable
as PublisherStatus,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,enteredBy: null == enteredBy ? _self.enteredBy : enteredBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
