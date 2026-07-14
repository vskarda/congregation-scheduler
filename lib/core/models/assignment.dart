import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignment.freezed.dart';
part 'assignment.g.dart';

/// Whoever can be assigned anywhere in the app: a set of publishers and/or a
/// free-text entry (visiting speakers, handwritten names, notes).
@freezed
abstract class Assignment with _$Assignment {
  const Assignment._();

  const factory Assignment({
    @Default(<String>[]) List<String> publisherIds,
    @Default('') String freeText,
  }) = _Assignment;

  factory Assignment.fromJson(Map<String, dynamic> json) =>
      _$AssignmentFromJson(json);

  bool get isEmpty => publisherIds.isEmpty && freeText.trim().isEmpty;

  bool get isNotEmpty => !isEmpty;

  bool contains(String publisherId) => publisherIds.contains(publisherId);

  /// Rewrites [from] to [to] in [publisherIds], keeping order and dropping
  /// the duplicate if [to] was already assigned. Returns `this` unchanged
  /// when [from] is absent. Used when connecting an admin-created record to
  /// a registered account (the record's random doc id becomes the auth uid).
  Assignment replaceAssignee(String from, String to) {
    if (!publisherIds.contains(from)) return this;
    final ids = <String>[];
    for (final id in publisherIds) {
      final mapped = id == from ? to : id;
      if (!ids.contains(mapped)) ids.add(mapped);
    }
    return copyWith(publisherIds: ids);
  }
}

/// A named, admin-defined extra assignment slot ("Custom label field").
@freezed
abstract class CustomAssignment with _$CustomAssignment {
  const factory CustomAssignment({
    /// Stable id linking a week's stored assignee to a permanent template
    /// (see [ScheduleConfig.permanentAssignments]). Empty for one-off,
    /// this-week-only custom assignments.
    @Default('') String id,
    @Default('') String label,
    @Default(Assignment()) Assignment assignment,
  }) = _CustomAssignment;

  factory CustomAssignment.fromJson(Map<String, dynamic> json) =>
      _$CustomAssignmentFromJson(json);
}
