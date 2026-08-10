import '../models/models.dart';

/// Ids of everyone whose report entries a given month may not count: they had
/// already moved away by then, so those entries belong to the congregation
/// they moved to.
///
/// Both sources apply the same month-level cut. [publishers] is the roster as
/// it stands; [former] are the departures of records that have since been
/// deleted, which would otherwise be handed back to this congregation the
/// moment somebody tidied the roster (see [FormerPublisher]). An entry with
/// neither a record nor a tombstone keeps counting — nothing says the person
/// left, and a filed month must not lose a number over a deletion.
Set<String> movedAwayBy(
  String month,
  List<Publisher> publishers,
  List<FormerPublisher> former,
) =>
    {
      for (final p in publishers)
        if (!p.onRosterInMonth(month)) p.id,
      for (final f in former)
        if (!f.onRosterInMonth(month)) f.id,
    };
