/// The three attendance counts; any one can be derived from the other two.
enum AttendanceField { inPerson, online, total }

/// Bidirectional "two of three" solver: whenever two counts are known the
/// third is filled in (total = inPerson + online). Tracks which fields the
/// user actually typed into so the least-recently-typed field is the one
/// recomputed — editing any field, including a previously computed one,
/// immediately re-derives its counterpart.
class AttendanceAutoCalc {
  /// User-typed fields, most recent last. Computed fills are not recorded.
  final List<AttendanceField> _order = [];

  /// Recompute preference when the user has typed nothing else yet: the
  /// total is the natural derived value, then online.
  static const _priority = [
    AttendanceField.total,
    AttendanceField.online,
    AttendanceField.inPerson,
  ];

  /// The user emptied [field]; forget it so it becomes the preferred
  /// recompute target again.
  void clear(AttendanceField field) => _order.remove(field);

  /// Records that the user typed a value into [field] and returns the field
  /// to recompute with its derived value, or null when the other counts
  /// don't yet determine one. A negative value means the two driver counts
  /// contradict each other (e.g. in person exceeds total); the caller should
  /// surface an error instead of filling it in.
  ({AttendanceField field, int value})? edit(
    AttendanceField field, {
    int? inPerson,
    int? online,
    int? total,
  }) {
    _order.remove(field);
    _order.add(field);
    final candidates = AttendanceField.values.where((f) => f != field).toList()
      ..sort((a, b) {
        // Never-typed (-1) loses to typed, older typed loses to newer, so the
        // edited field plus the most recently typed other field drive the
        // computation.
        final byRecency = _order.indexOf(a).compareTo(_order.indexOf(b));
        if (byRecency != 0) return byRecency;
        return _priority.indexOf(a).compareTo(_priority.indexOf(b));
      });
    final target = candidates.first;
    final value = switch (target) {
      AttendanceField.total =>
        inPerson != null && online != null ? inPerson + online : null,
      AttendanceField.online =>
        total != null && inPerson != null ? total - inPerson : null,
      AttendanceField.inPerson =>
        total != null && online != null ? total - online : null,
    };
    if (value == null) return null;
    return (field: target, value: value);
  }
}
