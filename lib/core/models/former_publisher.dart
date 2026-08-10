import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';
import 'publisher.dart';

part 'former_publisher.freezed.dart';
part 'former_publisher.g.dart';

/// What is kept at `former_publishers/{publisherId}` when a publisher who had
/// moved away is deleted: the id and the departure, nothing else.
///
/// The moving date lives on the publisher document, but the report entries it
/// speaks for outlive that document — they are keyed by publisher id under
/// `reports/{month}/entries`. Delete the record and the date goes with it, and
/// months the person had already left would quietly hand their reports back to
/// this congregation's S-1. So the date is written here first, and the
/// month-level cut carries on being applied to somebody who is no longer on
/// any roster.
///
/// Deliberately holds no name, no contact details, nothing personal:
/// deleting a publisher must really delete them. A record deleted while still
/// a member leaves no tombstone at all — nothing says the person left, and
/// their reports go on counting, as they always have.
@freezed
abstract class FormerPublisher with _$FormerPublisher {
  const factory FormerPublisher({
    /// Firestore document id = the id the deleted publisher record had, which
    /// is also the id of their report entries.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,

    /// Always true — a tombstone is only written for a departure — but stored
    /// so the same rule can be applied as to a live record.
    @Default(true) bool moved,

    /// `yyyy-MM-dd`; null on records archived before the date existed, which
    /// read as gone throughout.
    @JsonKey(includeIfNull: false) String? movedDate,
    @NullableTimestampConverter() DateTime? deletedAt,
  }) = _FormerPublisher;

  const FormerPublisher._();

  factory FormerPublisher.fromJson(Map<String, dynamic> json) =>
      _$FormerPublisherFromJson(json);

  /// Same cut as `Publisher.onRosterInMonth`, applied after the record is gone.
  bool onRosterInMonth(String month) =>
      onRosterInMonthOf(moved: moved, movedDate: movedDate, month: month);
}
