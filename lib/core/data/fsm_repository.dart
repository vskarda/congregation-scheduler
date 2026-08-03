import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../firebase/firebase_providers.dart';
import '../models/models.dart';
import '../utils/dates.dart';

/// Meetings for field service.
///
/// A recurring rule *is* its meetings: occurrences are expanded from
/// `fsm_recurring` on the fly ([expand]), never pre-written. `fsm_meetings`
/// holds only one-off meetings and *exceptions* — the occurrences an admin
/// edited, moved or cancelled, storing just what deviates
/// ([FsmMeeting.overrides]). A rule edit therefore reaches every occurrence
/// immediately, and no document can outlive the rule it belongs to.
class FsmRepository {
  FsmRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _meetings =>
      _db.collection('fsm_meetings');

  CollectionReference<Map<String, dynamic>> get _recurring =>
      _db.collection('fsm_recurring');

  FsmMeeting _meetingFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      FsmMeeting.fromJson(doc.data()!).copyWith(id: doc.id);

  FsmRecurring _ruleFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      FsmRecurring.fromJson(doc.data()!).copyWith(id: doc.id);

  /// Documents *held* in the range: one-off meetings plus the exceptions that
  /// happen there, including ones moved in from another week.
  Stream<List<FsmMeeting>> watchRange(String fromDate, String toDate,
          {bool includeCancelled = false}) =>
      _meetings
          .where('date', isGreaterThanOrEqualTo: fromDate)
          .where('date', isLessThanOrEqualTo: toDate)
          .snapshots()
          .map((snap) {
        final list = snap.docs
            .map(_meetingFromDoc)
            .where((m) => includeCancelled || !m.cancelled)
            .toList();
        list.sort(
            (a, b) => '${a.date} ${a.time}'.compareTo('${b.date} ${b.time}'));
        return list;
      });

  /// Exceptions whose *occurrence* falls in the range, wherever they were
  /// moved to. [expand] needs these to know which slots are already spoken
  /// for; without them an occurrence moved to another week would be expanded
  /// a second time at the slot it left behind.
  ///
  /// Documents written before `seriesDate` existed carry no such field and are
  /// invisible to this query; [repairAndCompact] backfills them.
  Stream<List<FsmMeeting>> watchSeriesRange(String fromDate, String toDate) =>
      _meetings
          .where('seriesDate', isGreaterThanOrEqualTo: fromDate)
          .where('seriesDate', isLessThanOrEqualTo: toDate)
          .snapshots()
          .map((snap) => snap.docs.map(_meetingFromDoc).toList());

  /// Writes [meeting]. Pass the [rule] an exception belongs to so it records
  /// which fields it overrides — the ones left alone keep following the rule.
  Future<void> saveMeeting(FsmMeeting meeting, {FsmRecurring? rule}) async {
    var data = meeting;
    if (meeting.isException && rule != null) {
      data = data.copyWith(
        seriesDate: meeting.seriesKey,
        overrides: meeting.diffFrom(rule),
      );
    }
    data = data.withRecomputedAssignees();
    if (data.id.isEmpty) {
      await _meetings.add(data.toJson());
    } else {
      await _meetings.doc(data.id).set(data.toJson());
    }
  }

  /// One-off meetings are removed; a recurring occurrence becomes a cancelled
  /// exception so its rule stops expanding it.
  Future<void> deleteMeeting(FsmMeeting meeting) async {
    if (!meeting.isException) {
      await _meetings.doc(meeting.id).delete();
      return;
    }
    final seriesDate = meeting.seriesKey;
    await _meetings
        .doc(FsmMeeting.exceptionId(meeting.recurringId, seriesDate))
        .set(meeting.copyWith(seriesDate: seriesDate, cancelled: true).toJson());
  }

  Future<List<FsmRecurring>> _allRules() async {
    final snap = await _recurring.get();
    return snap.docs.map(_ruleFromDoc).toList();
  }

  /// Every meeting held in `[fromDate, toDate]`, rules expanded. Replaces the
  /// old document-only query, which missed every occurrence no admin had
  /// happened to materialize.
  Future<List<FsmMeeting>> expandRange(String fromDate, String toDate) async {
    final byDate = await _meetings
        .where('date', isGreaterThanOrEqualTo: fromDate)
        .where('date', isLessThanOrEqualTo: toDate)
        .get();
    final bySeriesDate = await _meetings
        .where('seriesDate', isGreaterThanOrEqualTo: fromDate)
        .where('seriesDate', isLessThanOrEqualTo: toDate)
        .get();
    return expand(
      byDate.docs.map(_meetingFromDoc).toList(),
      bySeriesDate.docs.map(_meetingFromDoc).toList(),
      await _allRules(),
      parseDateKey(fromDate),
      parseDateKey(toDate).add(const Duration(days: 1)),
    );
  }

  /// Meetings in `[fromDate, toDate]` that [uid] is assigned to, rules
  /// expanded — so a publisher named on a rule sees its occurrences even
  /// though no document exists for them.
  Future<List<FsmMeeting>> expandAssignedTo(
      String uid, String fromDate, String toDate) async {
    final all = await expandRange(fromDate, toDate);
    return all.where((m) => m.allAssigneeIds.contains(uid)).toList();
  }

  /// Rewrites every reference to [fromId] onto [toId] in meetings (including
  /// cancelled ones, so no stale id lingers) and recurring rules' default
  /// assignments; used when connecting an admin-created record to a
  /// registered account. Idempotent.
  Future<void> replaceAssigneeInAll(String fromId, String toId) async {
    final meetings =
        await _meetings.where('allAssigneeIds', arrayContains: fromId).get();
    // Firestore caps a WriteBatch at 500 operations.
    for (var i = 0; i < meetings.docs.length; i += 400) {
      final batch = _db.batch();
      for (final doc in meetings.docs.skip(i).take(400)) {
        batch.set(doc.reference,
            _meetingFromDoc(doc).replaceAssignee(fromId, toId).toJson());
      }
      await batch.commit();
    }
    // Rules carry no allAssigneeIds index — scan all (the list is tiny).
    final rules = await _recurring.get();
    final batch = _db.batch();
    var dirty = false;
    for (final doc in rules.docs) {
      final rule = _ruleFromDoc(doc);
      if (!rule.defaultAssignment.contains(fromId)) continue;
      batch.set(
          doc.reference,
          rule
              .copyWith(
                  defaultAssignment:
                      rule.defaultAssignment.replaceAssignee(fromId, toId))
              .toJson());
      dirty = true;
    }
    if (dirty) await batch.commit();
  }

  Stream<List<FsmRecurring>> watchRecurring() =>
      _recurring.snapshots().map((snap) {
        final list = snap.docs.map(_ruleFromDoc).toList();
        list.sort((a, b) =>
            (a.weekday * 10000 + int.parse(a.time.replaceAll(':', '')))
                .compareTo(
                    b.weekday * 10000 + int.parse(b.time.replaceAll(':', ''))));
        return list;
      });

  /// Saving a rule needs no follow-up: its occurrences are expanded from it,
  /// so the change is live everywhere the moment it is written.
  Future<String> saveRecurring(FsmRecurring rule) async {
    if (rule.id.isEmpty) {
      final doc = await _recurring.add(rule.toJson());
      return doc.id;
    }
    await _recurring.doc(rule.id).set(rule.toJson());
    return rule.id;
  }

  /// Deletes the rule without leaving anything pointing at it:
  ///
  /// - past occurrences are frozen into stand-alone one-off meetings, so the
  ///   history the rule used to supply survives it;
  /// - customized exceptions are detached the same way, so admin work is
  ///   never silently destroyed;
  /// - plain future occurrences and cancellation tombstones are deleted —
  ///   with the rule gone they stand for nothing.
  ///
  /// History is frozen back to [AppConfig.pickerHistoryMonths] (as far as the
  /// assignment history ever looks) or the rule's `validFrom`, whichever is
  /// later, to bound the write count.
  Future<void> deleteRecurring(String ruleId, {DateTime? now}) async {
    final ruleDoc = await _recurring.doc(ruleId).get();
    final rule = ruleDoc.exists ? _ruleFromDoc(ruleDoc) : null;
    final today = now ?? DateTime.now();
    final todayKey = dateKey(today);

    final existing =
        await _meetings.where('recurringId', isEqualTo: ruleId).get();
    final exceptions = existing.docs.map(_meetingFromDoc).toList();
    final byOccurrence = {for (final m in exceptions) m.seriesKey: m};

    final deletes = <String>[];
    final creates = <FsmMeeting>[];
    final frozen = <String>{};

    if (rule != null) {
      final historyStart = addMonths(today, -AppConfig.pickerHistoryMonths);
      final validFrom = tryParseDateKey(rule.validFrom);
      final from = validFrom != null && validFrom.isAfter(historyStart)
          ? validFrom
          : historyStart;
      for (final date in materializedDates(rule, from, today)) {
        frozen.add(date);
        final existingException = byOccurrence[date];
        if (existingException != null && existingException.cancelled) continue;
        creates.add((existingException ?? FsmMeeting.fromRule(rule, date))
            .detachFrom(rule));
      }
    }

    for (final meeting in exceptions) {
      deletes.add(meeting.id);
      if (frozen.contains(meeting.seriesKey)) continue; // already handled above
      if (meeting.cancelled) continue;
      final isFuture = meeting.date.compareTo(todayKey) >= 0;
      // Plain future occurrences go with the rule; anything customized, and
      // any past occurrence, survives as a stand-alone meeting.
      if (isFuture && meeting.overrides.isEmpty) continue;
      creates.add(meeting.detachFrom(rule));
    }

    await _applyChanges(deletes: deletes, creates: creates);
    await _recurring.doc(ruleId).delete();
  }

  /// Deletes every future meeting (one-off and recurring) and every recurring
  /// rule, so nothing comes back. Past meetings are kept: each rule goes
  /// through [deleteRecurring], which freezes its past occurrences first.
  Future<void> deleteAllFutureMeetings({DateTime? now}) async {
    final today = now ?? DateTime.now();
    for (final rule in await _allRules()) {
      await deleteRecurring(rule.id, now: today);
    }
    await _deleteMeetingsFrom(dateKey(today));
  }

  /// Deletes every meeting from [weekId] (a Monday) onwards and stops the
  /// recurring rules there, so nothing regenerates. A rule that already ran
  /// before the cut-off is clamped with `validUntil`, which keeps its earlier
  /// occurrences expandable; a rule starting on or after it is deleted
  /// outright. Meetings before [weekId] are untouched.
  Future<void> deleteFromWeek(String weekId, {DateTime? now}) async {
    final today = now ?? DateTime.now();
    final cutoff = parseDateKey(weekId);
    final lastKept = dateKey(cutoff.subtract(const Duration(days: 1)));

    for (final rule in await _allRules()) {
      if (!runsBefore(rule, cutoff)) {
        await deleteRecurring(rule.id, now: today);
        continue;
      }
      // `>= cutoff`, not `> cutoff`: a rule ending exactly on the cut-off
      // Monday still produces an occurrence inside the deleted range.
      final validUntil = tryParseDateKey(rule.validUntil);
      if (validUntil == null || !validUntil.isBefore(cutoff)) {
        await _recurring
            .doc(rule.id)
            .set(rule.copyWith(validUntil: lastKept).toJson());
      }
    }
    await _deleteMeetingsFrom(weekId);
  }

  /// Deletes every meeting document held on or after [fromDate], plus the
  /// exceptions whose occurrence is on or after it but which were moved to an
  /// earlier date — they belong to a series that is going away.
  Future<void> _deleteMeetingsFrom(String fromDate) async {
    final byDate =
        await _meetings.where('date', isGreaterThanOrEqualTo: fromDate).get();
    final bySeriesDate = await _meetings
        .where('seriesDate', isGreaterThanOrEqualTo: fromDate)
        .get();
    final ids = {
      for (final doc in [...byDate.docs, ...bySeriesDate.docs]) doc.id,
    };
    await _applyChanges(deletes: ids.toList(), creates: const []);
  }

  /// Reconnects `fsm_meetings` to `fsm_recurring` and compacts away the
  /// snapshot copies the old materializer wrote. Idempotent, batched and safe
  /// to run on every admin session — a second run has nothing to do.
  ///
  /// Per document carrying a `recurringId`:
  ///
  /// - backfills `seriesDate` (from the deterministic doc id, else the date);
  /// - **rule still produces this occurrence** → recomputes `overrides`; a
  ///   document deviating in nothing is deleted, because the rule renders it;
  /// - **rule exists but no longer produces it** — its weekday or validity
  ///   window changed underneath — → deleted when it carries no customization,
  ///   detached into a one-off meeting when it does;
  /// - **rule is gone** → re-adopted by a rule that produces exactly this date
  ///   if there is one, otherwise detached into a one-off meeting.
  ///
  /// Nothing an admin typed is deleted, and no document is left pointing at a
  /// rule that does not exist.
  Future<void> repairAndCompact() async {
    final rules = await _allRules();
    final rulesById = {for (final rule in rules) rule.id: rule};
    // A range over the empty string matches every document that has a rule id.
    final linked =
        await _meetings.where('recurringId', isGreaterThan: '').get();
    if (linked.docs.isEmpty) return;

    final deletes = <String>[];
    final updates = <String, FsmMeeting>{};
    final creates = <FsmMeeting>[];

    for (final doc in linked.docs) {
      final stored = _meetingFromDoc(doc);
      var meeting = stored.copyWith(seriesDate: _seriesDateOf(doc.id, stored));
      var rule = rulesById[meeting.recurringId];

      if (rule == null) {
        // The rule is gone — most often deleted and recreated under a new id.
        // Re-adopt onto whichever rule produces the day this happens, else
        // set it free as a one-off meeting.
        final adopting = _adoptingRule(rules, meeting.date);
        if (adopting == null) {
          deletes.add(doc.id);
          if (!stored.cancelled) creates.add(meeting.detachFrom(null));
          continue;
        }
        rule = adopting;
        meeting =
            meeting.copyWith(recurringId: rule.id, seriesDate: meeting.date);
      }

      // A document that records its overrides is authoritative — recomputing
      // them would mistake fields the rule has since changed for deliberate
      // customization. Only the old materializer's snapshot copies need them
      // worked out, and those carry every field, so the diff is meaningful.
      final isSnapshotCopy = stored.overrides.isEmpty && !stored.cancelled;
      final overrides =
          isSnapshotCopy ? meeting.diffFrom(rule) : stored.overrides;

      if (!producesOn(rule, meeting.seriesKey)) {
        // Left behind by a weekday or validity-window change.
        deletes.add(doc.id);
        if (!stored.cancelled && overrides.isNotEmpty) {
          // A snapshot copy is complete on its own; a lean exception has to
          // borrow the fields it never overrode before its rule goes away.
          creates.add(
              isSnapshotCopy ? meeting.detachFrom(null) : meeting.detachFrom(rule));
        }
        continue;
      }

      if (!stored.cancelled && overrides.isEmpty) {
        deletes.add(doc.id); // A plain copy: the rule renders it now.
        continue;
      }

      final repaired = meeting.copyWith(overrides: overrides);
      final expectedId = FsmMeeting.exceptionId(rule.id, repaired.seriesKey);
      if (doc.id != expectedId) {
        deletes.add(doc.id);
        creates.add(repaired.copyWith(id: expectedId));
      } else if (repaired.recurringId != stored.recurringId ||
          repaired.seriesDate != stored.seriesDate ||
          !_sameOverrides(repaired.overrides, stored.overrides)) {
        updates[doc.id] = repaired;
      }
    }

    await _applyChanges(deletes: deletes, updates: updates, creates: creates);
  }

  /// Applies the changes in batches below Firestore's 500-operation cap.
  /// Deletes are enqueued before creates so a document moved to a different
  /// id can never be removed after it was rewritten.
  Future<void> _applyChanges({
    required List<String> deletes,
    required List<FsmMeeting> creates,
    Map<String, FsmMeeting> updates = const {},
  }) async {
    final ops = <void Function(WriteBatch)>[
      for (final id in deletes) (batch) => batch.delete(_meetings.doc(id)),
      for (final entry in updates.entries)
        (batch) => batch.set(_meetings.doc(entry.key),
            entry.value.withRecomputedAssignees().toJson()),
      for (final meeting in creates)
        (batch) => batch.set(
            meeting.id.isEmpty ? _meetings.doc() : _meetings.doc(meeting.id),
            meeting.copyWith(id: '').withRecomputedAssignees().toJson()),
    ];
    for (var i = 0; i < ops.length; i += 400) {
      final batch = _db.batch();
      for (final op in ops.skip(i).take(400)) {
        op(batch);
      }
      await batch.commit();
    }
  }

  /// The occurrence a document written before `seriesDate` existed stands for:
  /// the old materializer's deterministic id ended in the date it was written
  /// for, which survives even where the `date` field was later moved.
  static String _seriesDateOf(String docId, FsmMeeting meeting) {
    if (meeting.seriesDate.isNotEmpty) return meeting.seriesDate;
    final underscore = docId.lastIndexOf('_');
    if (underscore >= 0) {
      final suffix = docId.substring(underscore + 1);
      if (tryParseDateKey(suffix) != null) return suffix;
    }
    return meeting.date;
  }

  /// The rule that would produce an occurrence on [date], if any — used to
  /// re-adopt documents orphaned by a rule that was deleted and recreated.
  static FsmRecurring? _adoptingRule(List<FsmRecurring> rules, String date) {
    for (final rule in rules) {
      if (producesOn(rule, date)) return rule;
    }
    return null;
  }

  static bool _sameOverrides(List<String> a, List<String> b) =>
      a.length == b.length && a.every(b.contains);

  /// Pure helper: whether [rule] produces an occurrence exactly on [date].
  static bool producesOn(FsmRecurring rule, String date) {
    final day = tryParseDateKey(date);
    if (day == null) return false;
    return materializedDates(rule, day, day.add(const Duration(days: 1)))
        .isNotEmpty;
  }

  /// Pure helper: whether [rule] produced any occurrence before [cutoff]. A
  /// rule without `validFrom` has no start bound, so it always did.
  static bool runsBefore(FsmRecurring rule, DateTime cutoff) {
    final validFrom = tryParseDateKey(rule.validFrom);
    if (validFrom == null) return true;
    return materializedDates(rule, validFrom, cutoff).isNotEmpty;
  }

  /// Pure helper (unit-tested): dates the rule should produce in
  /// `[from, until)`, respecting validFrom/validUntil.
  static List<String> materializedDates(
      FsmRecurring rule, DateTime from, DateTime until) {
    final validFrom = tryParseDateKey(rule.validFrom);
    final validUntil = tryParseDateKey(rule.validUntil);
    var day = DateTime(from.year, from.month, from.day);
    if (validFrom != null && validFrom.isAfter(day)) day = validFrom;
    // Advance to the rule's weekday.
    day = day.add(Duration(days: (rule.weekday - day.weekday) % 7));
    final result = <String>[];
    while (day.isBefore(until)) {
      if (validUntil != null && day.isAfter(validUntil)) break;
      result.add(dateKey(day));
      day = day.add(const Duration(days: 7));
    }
    return result;
  }

  /// Pure helper (unit-tested): every meeting held in `[from, untilExclusive)`.
  ///
  /// [byDate] are the documents *held* in the window (one-off meetings,
  /// exceptions happening there, cancellation tombstones); [bySeriesDate] are
  /// the exceptions whose *occurrence* falls in it, wherever they were moved
  /// to. Both are needed: the first says what to show, the second which slots
  /// are already spoken for.
  ///
  /// An exception inherits every field it does not override from its rule, so
  /// rule edits keep reaching customized occurrences. One whose rule is gone
  /// is rendered from its own stored fields rather than dropped.
  static List<FsmMeeting> expand(
      List<FsmMeeting> byDate,
      List<FsmMeeting> bySeriesDate,
      List<FsmRecurring> rules,
      DateTime from,
      DateTime untilExclusive) {
    final rulesById = {for (final rule in rules) rule.id: rule};
    final claimed = <String>{
      for (final meeting in [...byDate, ...bySeriesDate])
        if (meeting.isException)
          FsmMeeting.exceptionId(meeting.recurringId, meeting.seriesKey),
    };

    final result = <FsmMeeting>[];
    for (final meeting in byDate) {
      if (meeting.cancelled) continue;
      final rule = rulesById[meeting.recurringId];
      result.add(rule == null ? meeting : meeting.applyRule(rule));
    }
    for (final rule in rules) {
      for (final date in materializedDates(rule, from, untilExclusive)) {
        if (claimed.contains(FsmMeeting.exceptionId(rule.id, date))) continue;
        result.add(FsmMeeting.fromRule(rule, date));
      }
    }
    result.sort(
        (a, b) => '${a.date} ${a.time}'.compareTo('${b.date} ${b.time}'));
    return result;
  }
}

final fsmRepositoryProvider = Provider<FsmRepository>(
    (ref) => FsmRepository(ref.watch(firestoreProvider)));

final fsmRecurringProvider = StreamProvider<List<FsmRecurring>>(
    (ref) => ref.watch(fsmRepositoryProvider).watchRecurring());
