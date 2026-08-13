import 'package:freezed_annotation/freezed_annotation.dart';

import 'assignment.dart';
import 'enums.dart';

part 'co_visit.freezed.dart';
part 'co_visit.g.dart';

/// One arrangement made for the circuit overseer's visit — a meal, a
/// shepherding visit, a meeting with the pioneers, and so on.
///
/// Nothing here is required: an item may carry only a note, or only a day,
/// and renders (and prints) with whatever it has. [assignment] is unused by
/// the sections that name no one ([CoVisitSection.pioneers],
/// [CoVisitSection.elders]).
@freezed
abstract class CoVisitItem with _$CoVisitItem {
  const CoVisitItem._();

  const factory CoVisitItem({
    /// Stable within the visit document, so editing one item never disturbs
    /// another.
    @Default('') String id,
    @Default(CoVisitSection.other) CoVisitSection section,

    /// yyyy-MM-dd; empty when no day has been settled yet.
    @Default('') String date,

    /// HH:mm; empty when no time has been settled yet.
    @Default('') String time,
    @Default(Assignment()) Assignment assignment,
    @Default('') String address,
    @Default('') String note,
  }) = _CoVisitItem;

  factory CoVisitItem.fromJson(Map<String, dynamic> json) =>
      _$CoVisitItemFromJson(json);

  /// Nothing has been filled in — used to drop an item an admin opened and
  /// left blank rather than storing an empty row.
  bool get isBlank =>
      date.isEmpty &&
      time.isEmpty &&
      assignment.isEmpty &&
      address.trim().isEmpty &&
      note.trim().isEmpty;

  CoVisitItem replaceAssignee(String from, String to) =>
      copyWith(assignment: assignment.replaceAssignee(from, to));
}

/// A circuit overseer's visit, keyed by the Monday (yyyy-MM-dd) of its week.
/// The visit itself always runs Tuesday to Sunday of that week.
@freezed
abstract class CoVisit with _$CoVisit {
  const CoVisit._();

  const factory CoVisit({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default(<CoVisitItem>[]) List<CoVisitItem> items,

    /// [CoVisitSection] names the admin has hidden for this visit. Hidden
    /// sections stay visible (dimmed) to the admins who may edit the visit,
    /// disappear for everyone else, and print only on request.
    @Default(<String>[]) List<String> hiddenSections,

    /// Denormalized union of every assigned publisher id, kept in sync on
    /// save; enables array-contains "my assignments" queries.
    @Default(<String>[]) List<String> allAssigneeIds,
  }) = _CoVisit;

  factory CoVisit.fromJson(Map<String, dynamic> json) =>
      _$CoVisitFromJson(json);

  /// Tuesday of the visit week, given its Monday key.
  static DateTime startOf(DateTime monday) =>
      DateTime(monday.year, monday.month, monday.day + 1);

  /// Sunday of the visit week, given its Monday key.
  static DateTime endOf(DateTime monday) =>
      DateTime(monday.year, monday.month, monday.day + 6);

  /// The six days a visit spans, Tuesday first.
  static List<DateTime> daysOf(DateTime monday) => [
        for (var i = 1; i <= 6; i++)
          DateTime(monday.year, monday.month, monday.day + i),
      ];

  bool isHidden(CoVisitSection section) =>
      hiddenSections.contains(section.name);

  CoVisit withSectionHidden(CoVisitSection section, bool hidden) {
    final names = hiddenSections.where((s) => s != section.name).toList();
    if (hidden) names.add(section.name);
    return copyWith(hiddenSections: names);
  }

  /// Items of one section, earliest first. Items with no day (or no time)
  /// sort to the back — they are still being arranged.
  List<CoVisitItem> itemsOf(CoVisitSection section) {
    final list = items.where((i) => i.section == section).toList();
    list.sort((a, b) {
      final byDate = _blankLast(a.date).compareTo(_blankLast(b.date));
      if (byDate != 0) return byDate;
      return _blankLast(a.time).compareTo(_blankLast(b.time));
    });
    return list;
  }

  /// Replaces the item with [item]'s id, or appends it when it is new.
  CoVisit withItem(CoVisitItem item) {
    final list = [...items];
    final at = list.indexWhere((i) => i.id == item.id);
    if (at < 0) {
      list.add(item);
    } else {
      list[at] = item;
    }
    return copyWith(items: list);
  }

  CoVisit withoutItem(String itemId) =>
      copyWith(items: items.where((i) => i.id != itemId).toList());

  CoVisit withRecomputedAssignees() {
    final ids = <String>{
      for (final item in items) ...item.assignment.publisherIds,
    };
    return copyWith(allAssigneeIds: ids.toList()..sort());
  }

  /// Rewrites every occurrence of publisher id [from] to [to] and recomputes
  /// [allAssigneeIds]. Used when connecting an admin-created record to a
  /// registered account.
  CoVisit replaceAssignee(String from, String to) => copyWith(
        items: [for (final i in items) i.replaceAssignee(from, to)],
      ).withRecomputedAssignees();
}

/// Sorts an empty value after every non-empty one (yyyy-MM-dd and HH:mm both
/// compare correctly as plain strings, and '￿' follows every digit).
String _blankLast(String value) => value.isEmpty ? '￿' : value;

/// Congregation-wide settings of the circuit overseer view, stored at
/// `schedule_config/coVisit`.
///
/// It lives next to the other schedule configuration rather than on
/// `congregation/meta` for one concrete reason: meta is full-admin-write-only,
/// while `schedule_config/{docId}` is writable by the role that owns the
/// schedule — here `events`, the same role that plans the visit.
@freezed
abstract class CoVisitConfig with _$CoVisitConfig {
  const factory CoVisitConfig({
    /// Whether publishers see the circuit overseer view at all. Off until an
    /// admin turns it on, so a half-planned visit is not on show.
    ///
    /// This hides the view; it does not protect it. `co_visits` is readable by
    /// every verified user (firestore.rules), exactly like the schedules.
    @Default(false) bool visibleToPublishers,
  }) = _CoVisitConfig;

  factory CoVisitConfig.fromJson(Map<String, dynamic> json) =>
      _$CoVisitConfigFromJson(json);
}
