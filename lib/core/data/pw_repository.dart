import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../firebase/firebase_providers.dart';
import '../models/models.dart';
import '../utils/dates.dart';

/// Public witnessing.
///
/// A recurring rule *is* its slots: occurrences are expanded from
/// `pw_recurring` on the fly ([expand]), never pre-written. `pw_slots` holds
/// only one-off slots and *exceptions* — the occurrences an admin edited,
/// moved or cancelled, storing just what deviates ([PwSlot.overrides]). A
/// rule edit therefore reaches every occurrence immediately, and no document
/// can outlive the rule it belongs to.
///
/// Slot ids are deterministic and permanent, because applications live at
/// `pw_applications/{slotId}_{uid}` and the security rules let nobody re-key
/// them: an admin may create none (the applicant id must be their own) and
/// update none. So a slot that changed id would silently lose everyone who
/// volunteered for it. Every path here that removes a slot removes its
/// applications too, rather than leaving them pointing at nothing.
class PwRepository {
  PwRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _slots =>
      _db.collection('pw_slots');

  CollectionReference<Map<String, dynamic>> get _recurring =>
      _db.collection('pw_recurring');

  CollectionReference<Map<String, dynamic>> get _applications =>
      _db.collection('pw_applications');

  PwSlot _slotFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      PwSlot.fromJson(doc.data()!).copyWith(id: doc.id);

  PwApplication _applicationFromDoc(
          DocumentSnapshot<Map<String, dynamic>> doc) =>
      PwApplication.fromJson(doc.data()!).copyWith(id: doc.id);

  PwRecurring _ruleFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      PwRecurring.fromJson(doc.data()!).copyWith(id: doc.id);

  /// Documents *held* in the range: one-off slots plus the exceptions that
  /// happen there, including ones moved in from another week.
  Stream<List<PwSlot>> watchRange(String fromDate, String toDate,
          {bool includeCancelled = false}) =>
      _slots
          .where('date', isGreaterThanOrEqualTo: fromDate)
          .where('date', isLessThanOrEqualTo: toDate)
          .snapshots()
          .map((snap) {
        final list = snap.docs
            .map(_slotFromDoc)
            .where((s) => includeCancelled || !s.cancelled)
            .toList();
        list.sort((a, b) => '${a.date} ${a.startTime}'
            .compareTo('${b.date} ${b.startTime}'));
        return list;
      });

  /// Exceptions whose *occurrence* falls in the range, wherever they were
  /// moved to. [expand] needs these to know which slots are already spoken
  /// for; without them an occurrence moved to another week would be expanded
  /// a second time at the slot it left behind.
  ///
  /// Documents written before `seriesDate` existed carry no such field and are
  /// invisible to this query; [repairAndCompact] backfills them.
  Stream<List<PwSlot>> watchSeriesRange(String fromDate, String toDate) =>
      _slots
          .where('seriesDate', isGreaterThanOrEqualTo: fromDate)
          .where('seriesDate', isLessThanOrEqualTo: toDate)
          .snapshots()
          .map((snap) => snap.docs.map(_slotFromDoc).toList());

  /// Writes [slot]. Pass the [rule] an exception belongs to so it records
  /// which fields it overrides — the ones left alone keep following the rule.
  Future<void> saveSlot(PwSlot slot, {PwRecurring? rule}) async {
    var data = slot;
    if (slot.isException && rule != null) {
      data = data.copyWith(
        seriesDate: slot.seriesKey,
        overrides: slot.diffFrom(rule),
      );
    }
    data = data.withRecomputedAssignees();
    if (data.id.isEmpty) {
      await _slots.add(data.toJson());
    } else {
      await _slots.doc(data.id).set(data.toJson());
    }
  }

  /// One-off slots are removed; a recurring occurrence becomes a cancelled
  /// exception so its rule stops expanding it. Either way the applications
  /// for it go: they name a slot that no longer happens, and leaving them
  /// would quietly restore the old volunteers if the slot ever came back.
  Future<void> deleteSlot(PwSlot slot) async {
    final apps = await _applicationRefsFor([slot.id]);
    final batch = _db.batch();
    for (final ref in apps) {
      batch.delete(ref);
    }
    if (!slot.isException) {
      batch.delete(_slots.doc(slot.id));
    } else {
      final seriesDate = slot.seriesKey;
      batch.set(_slots.doc(PwSlot.exceptionId(slot.recurringId, seriesDate)),
          slot.copyWith(seriesDate: seriesDate, cancelled: true).toJson());
    }
    await batch.commit();
  }

  Future<List<PwRecurring>> _allRules() async {
    final snap = await _recurring.get();
    return snap.docs.map(_ruleFromDoc).toList();
  }

  /// Every slot held in `[fromDate, toDate]`, rules expanded. Replaces the
  /// old document-only query, which missed every occurrence no admin had
  /// happened to materialize.
  Future<List<PwSlot>> expandRange(String fromDate, String toDate) async {
    final byDate = await _slots
        .where('date', isGreaterThanOrEqualTo: fromDate)
        .where('date', isLessThanOrEqualTo: toDate)
        .get();
    final bySeriesDate = await _slots
        .where('seriesDate', isGreaterThanOrEqualTo: fromDate)
        .where('seriesDate', isLessThanOrEqualTo: toDate)
        .get();
    return expand(
      byDate.docs.map(_slotFromDoc).toList(),
      bySeriesDate.docs.map(_slotFromDoc).toList(),
      await _allRules(),
      parseDateKey(fromDate),
      parseDateKey(toDate).add(const Duration(days: 1)),
    );
  }

  /// Slots in `[fromDate, toDate]` that [uid] is assigned to, rules expanded
  /// — so a publisher named on a rule sees its occurrences even though no
  /// document exists for them.
  Future<List<PwSlot>> expandAssignedTo(
      String uid, String fromDate, String toDate) async {
    final all = await expandRange(fromDate, toDate);
    return all.where((s) => s.allAssigneeIds.contains(uid)).toList();
  }

  /// Rewrites every reference to [fromId] onto [toId] in slots (including
  /// cancelled ones, so no stale id lingers) and recurring rules' default
  /// assignments; used when connecting an admin-created record to a
  /// registered account. Idempotent. Applications need no migration — a
  /// record without an account cannot have applied.
  Future<void> replaceAssigneeInAll(String fromId, String toId) async {
    final slots =
        await _slots.where('allAssigneeIds', arrayContains: fromId).get();
    // Firestore caps a WriteBatch at 500 operations.
    for (var i = 0; i < slots.docs.length; i += 400) {
      final batch = _db.batch();
      for (final doc in slots.docs.skip(i).take(400)) {
        batch.set(doc.reference,
            _slotFromDoc(doc).replaceAssignee(fromId, toId).toJson());
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

  /// Applies [uid] for [slot]. Idempotent thanks to the deterministic doc id;
  /// works for slots that exist only as an expansion of their rule, whose ids
  /// are equally deterministic.
  Future<void> applyForSlot(PwSlot slot, String uid) =>
      _applications.doc(PwApplication.docId(slot.id, uid)).set({
        'slotId': slot.id,
        'date': slot.date,
        'publisherId': uid,
        'appliedAt': FieldValue.serverTimestamp(),
      });

  Future<void> withdrawApplication(String slotId, String uid) =>
      _applications.doc(PwApplication.docId(slotId, uid)).delete();

  /// Removes every application belonging to [uid] (used when the user deletes
  /// their own account). The self-read/self-delete rules require the caller to
  /// still be a verified publisher, so this must run before the publisher doc
  /// is deleted.
  Future<void> deleteAllForPublisher(String uid) async {
    final apps =
        await _applications.where('publisherId', isEqualTo: uid).get();
    if (apps.docs.isEmpty) return;
    final batch = _db.batch();
    for (final doc in apps.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  /// Firestore caps `whereIn` at 30 values, so slot ids are queried in
  /// chunks. A week is normally one query; the chunking is what stops a busy
  /// week from silently returning a truncated applicant list.
  static const int whereInLimit = 30;

  static List<List<String>> chunkIds(List<String> ids) => [
        for (var i = 0; i < ids.length; i += whereInLimit)
          ids.skip(i).take(whereInLimit).toList(),
      ];

  /// Applications for [slotIds], grouped by slot. Admin-only query. Keyed by
  /// slot rather than by the applications' denormalized `date`, which goes
  /// stale when an admin moves a slot and which nobody is allowed to correct.
  Stream<Map<String, List<PwApplication>>> watchApplicationsForSlots(
      List<String> slotIds) {
    if (slotIds.isEmpty) return Stream.value(const {});
    return _applications
        .where('slotId', whereIn: slotIds)
        .snapshots()
        .map((snap) {
      final bySlot = <String, List<PwApplication>>{};
      for (final doc in snap.docs) {
        final app = _applicationFromDoc(doc);
        (bySlot[app.slotId] ??= []).add(app);
      }
      return bySlot;
    });
  }

  /// Applications for one slot, oldest first. Admin-only query; queried by
  /// slotId (not the denormalized date) so it stays correct even if an admin
  /// moved the slot to another date.
  Future<List<PwApplication>> getApplicationsForSlot(String slotId) async {
    final snap = await _applications.where('slotId', isEqualTo: slotId).get();
    final list = snap.docs.map(_applicationFromDoc).toList();
    list.sort((a, b) => (a.appliedAt ?? DateTime(2000))
        .compareTo(b.appliedAt ?? DateTime(2000)));
    return list;
  }

  /// The caller's own applications. Must filter by publisherId only so the
  /// query is provable against the self-read security rule.
  Stream<List<PwApplication>> watchMyApplications(String uid) => _applications
      .where('publisherId', isEqualTo: uid)
      .snapshots()
      .map((snap) => snap.docs.map(_applicationFromDoc).toList());

  /// Document references of every application for [slotIds].
  Future<List<DocumentReference<Map<String, dynamic>>>> _applicationRefsFor(
      List<String> slotIds) async {
    final refs = <DocumentReference<Map<String, dynamic>>>[];
    for (final chunk in chunkIds(slotIds)) {
      final snap = await _applications.where('slotId', whereIn: chunk).get();
      refs.addAll(snap.docs.map((d) => d.reference));
    }
    return refs;
  }

  Stream<List<PwRecurring>> watchRecurring() =>
      _recurring.snapshots().map((snap) {
        final list = snap.docs.map(_ruleFromDoc).toList();
        list.sort((a, b) => (a.weekday * 10000 +
                int.parse(a.startTime.replaceAll(':', '')))
            .compareTo(b.weekday * 10000 +
                int.parse(b.startTime.replaceAll(':', ''))));
        return list;
      });

  /// Saving a rule needs no follow-up: its occurrences are expanded from it,
  /// so the change is live everywhere the moment it is written.
  Future<String> saveRecurring(PwRecurring rule) async {
    if (rule.id.isEmpty) {
      final doc = await _recurring.add(rule.toJson());
      return doc.id;
    }
    await _recurring.doc(rule.id).set(rule.toJson());
    return rule.id;
  }

  /// Deletes the rule without leaving anything pointing at it:
  ///
  /// - past occurrences are frozen into stand-alone slots at their own ids,
  ///   so both the history the rule used to supply and the applications keyed
  ///   to those ids survive it;
  /// - customized exceptions are detached the same way, so admin work and its
  ///   applicants are never silently destroyed;
  /// - plain future occurrences and cancellation tombstones are deleted, with
  ///   their applications — with the rule gone they stand for nothing.
  ///
  /// History is frozen back to [AppConfig.pickerHistoryMonths] (as far as the
  /// assignment history ever looks) or the rule's `validFrom`, whichever is
  /// later, to bound the write count.
  Future<void> deleteRecurring(String ruleId, {DateTime? now}) async {
    final ruleDoc = await _recurring.doc(ruleId).get();
    final rule = ruleDoc.exists ? _ruleFromDoc(ruleDoc) : null;
    final today = now ?? DateTime.now();
    final todayKey = dateKey(today);

    final existing = await _slots.where('recurringId', isEqualTo: ruleId).get();
    final exceptions = existing.docs.map(_slotFromDoc).toList();
    final byOccurrence = {for (final s in exceptions) s.seriesKey: s};

    final deletes = <String>[];
    final writes = <PwSlot>[];
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
        if (existingException != null && existingException.cancelled) {
          deletes.add(existingException.id);
          continue;
        }
        writes.add(
            (existingException ?? PwSlot.fromRule(rule, date)).detachFrom(rule));
      }
    }

    for (final slot in exceptions) {
      if (frozen.contains(slot.seriesKey)) continue; // handled above
      final isFuture = slot.date.compareTo(todayKey) >= 0;
      // Plain future occurrences go with the rule; anything customized, and
      // any past occurrence, survives as a stand-alone slot.
      if (slot.cancelled || (isFuture && slot.overrides.isEmpty)) {
        deletes.add(slot.id);
      } else {
        writes.add(slot.detachFrom(rule));
      }
    }

    await _applyChanges(deletes: deletes, writes: writes);
    // Frozen and detached slots keep their ids, so only what was actually
    // removed loses its applicants.
    await _deleteApplicationsFor(deletes);
    await _recurring.doc(ruleId).delete();
  }

  /// Deletes every future slot (one-off and recurring) and every recurring
  /// rule, so nothing comes back. Past slots are kept: each rule goes through
  /// [deleteRecurring], which freezes its past occurrences first.
  Future<void> deleteAllFutureSlots({DateTime? now}) async {
    final today = now ?? DateTime.now();
    for (final rule in await _allRules()) {
      await deleteRecurring(rule.id, now: today);
    }
    await _deleteSlotsFrom(dateKey(today));
  }

  /// Deletes every slot from [weekId] (a Monday) onwards and stops the
  /// recurring rules there, so nothing regenerates. A rule that already ran
  /// before the cut-off is clamped with `validUntil`, which keeps its earlier
  /// occurrences expandable; a rule starting on or after it is deleted
  /// outright. Slots before [weekId] are untouched.
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
    await _deleteSlotsFrom(weekId);
  }

  /// Deletes every slot document held on or after [fromDate], plus the
  /// exceptions whose occurrence is on or after it but which were moved to an
  /// earlier date — they belong to a series that is going away.
  ///
  /// Applications go with them, both those dated from [fromDate] on (which
  /// covers occurrences that never had a document of their own) and those
  /// naming one of the deleted documents (which covers slots an admin had
  /// moved, whose applications carry the date they were applied for).
  Future<void> _deleteSlotsFrom(String fromDate) async {
    final byDate =
        await _slots.where('date', isGreaterThanOrEqualTo: fromDate).get();
    final bySeriesDate = await _slots
        .where('seriesDate', isGreaterThanOrEqualTo: fromDate)
        .get();
    final ids = {
      for (final doc in [...byDate.docs, ...bySeriesDate.docs]) doc.id,
    };
    await _applyChanges(deletes: ids.toList(), writes: const []);

    final dated = await _applications
        .where('date', isGreaterThanOrEqualTo: fromDate)
        .get();
    final refs = {
      for (final doc in dated.docs) doc.id: doc.reference,
      for (final ref in await _applicationRefsFor(ids.toList()))
        ref.id: ref,
    }.values.toList();
    await _deleteApplicationRefs(refs);
  }

  /// Deletes every application naming one of [slotIds].
  Future<void> _deleteApplicationsFor(List<String> slotIds) async {
    if (slotIds.isEmpty) return;
    await _deleteApplicationRefs(await _applicationRefsFor(slotIds));
  }

  Future<void> _deleteApplicationRefs(
      List<DocumentReference<Map<String, dynamic>>> refs) async {
    for (var i = 0; i < refs.length; i += 400) {
      final batch = _db.batch();
      for (final ref in refs.skip(i).take(400)) {
        batch.delete(ref);
      }
      await batch.commit();
    }
  }

  /// Reconnects `pw_slots` to `pw_recurring`, compacts away the snapshot
  /// copies the old materializer wrote, and sweeps up applications left
  /// pointing at slots nothing produces any more. Idempotent, batched and
  /// safe to run on every admin session — a second run has nothing to do.
  ///
  /// Per document carrying a `recurringId`:
  ///
  /// - backfills `seriesDate` (from the deterministic doc id, else the date);
  /// - **rule still produces this occurrence** → recomputes `overrides`; a
  ///   document deviating in nothing is deleted, because the rule renders it;
  /// - **rule exists but no longer produces it** — its weekday or validity
  ///   window changed underneath — → deleted when it carries no customization,
  ///   detached into a one-off slot when it does;
  /// - **rule is gone** → re-adopted by a rule that produces exactly this date
  ///   if there is one, otherwise detached into a one-off slot.
  ///
  /// Compaction never changes a slot's id, so applications stay attached: the
  /// occurrence an expanded rule renders carries the same deterministic id the
  /// deleted document had. Re-adoption is the one path that can move a
  /// document, and it takes that slot's applications with it — they can only
  /// be deleted, never re-keyed.
  Future<void> repairAndCompact({DateTime? now}) async {
    final rules = await _allRules();
    final rulesById = {for (final rule in rules) rule.id: rule};
    // A range over the empty string matches every document that has a rule id.
    final linked = await _slots.where('recurringId', isGreaterThan: '').get();

    final deletes = <String>[];
    final writes = <PwSlot>[];
    final orphanedApplicationSlotIds = <String>[];

    for (final doc in linked.docs) {
      final stored = _slotFromDoc(doc);
      var slot = stored.copyWith(seriesDate: _seriesDateOf(doc.id, stored));
      var rule = rulesById[slot.recurringId];

      if (rule == null) {
        // The rule is gone — most often deleted and recreated under a new id.
        // Re-adopt onto whichever rule produces the day this happens, else
        // set it free as a one-off slot.
        final adopting = _adoptingRule(rules, slot.date);
        if (adopting == null) {
          if (stored.cancelled) {
            deletes.add(doc.id);
            orphanedApplicationSlotIds.add(doc.id);
          } else {
            writes.add(slot.detachFrom(null));
          }
          continue;
        }
        rule = adopting;
        slot = slot.copyWith(recurringId: rule.id, seriesDate: slot.date);
      }

      // A document that records its overrides is authoritative — recomputing
      // them would mistake fields the rule has since changed for deliberate
      // customization. Only the old materializer's snapshot copies need them
      // worked out, and those carry every field, so the diff is meaningful.
      final isSnapshotCopy = stored.overrides.isEmpty && !stored.cancelled;
      final overrides = isSnapshotCopy ? slot.diffFrom(rule) : stored.overrides;

      if (!producesOn(rule, slot.seriesKey)) {
        // Left behind by a weekday or validity-window change.
        if (!stored.cancelled && overrides.isNotEmpty) {
          // A snapshot copy is complete on its own; a lean exception has to
          // borrow the fields it never overrode before its rule goes away.
          writes.add(isSnapshotCopy ? slot.detachFrom(null) : slot.detachFrom(rule));
        } else {
          deletes.add(doc.id);
          orphanedApplicationSlotIds.add(doc.id);
        }
        continue;
      }

      if (!stored.cancelled && overrides.isEmpty) {
        // A plain copy: the rule renders it now, under this very same id, so
        // its applications keep resolving.
        deletes.add(doc.id);
        continue;
      }

      final repaired = slot.copyWith(overrides: overrides);
      final expectedId = PwSlot.exceptionId(rule.id, repaired.seriesKey);
      if (doc.id != expectedId) {
        deletes.add(doc.id);
        orphanedApplicationSlotIds.add(doc.id);
        writes.add(repaired.copyWith(id: expectedId));
      } else if (repaired.recurringId != stored.recurringId ||
          repaired.seriesDate != stored.seriesDate ||
          !_sameOverrides(repaired.overrides, stored.overrides)) {
        writes.add(repaired);
      }
    }

    await _applyChanges(deletes: deletes, writes: writes);
    await _sweepApplications(rules, orphanedApplicationSlotIds, now: now);
  }

  /// Deletes applications that name a slot nothing produces any more —
  /// [knownOrphanSlotIds] from this repair pass, plus any future application
  /// whose slot neither exists as a document nor is expanded by a rule.
  ///
  /// Only future applications are swept. Past ones are the record of who
  /// actually volunteered and are always kept, however their slot ended up.
  Future<void> _sweepApplications(
      List<PwRecurring> rules, List<String> knownOrphanSlotIds,
      {DateTime? now}) async {
    final todayKey = dateKey(now ?? DateTime.now());
    final future = await _applications
        .where('date', isGreaterThanOrEqualTo: todayKey)
        .get();
    if (future.docs.isEmpty) return;

    final dead = knownOrphanSlotIds.toSet();
    final live = <String>{};
    final slotDocs =
        await _slots.where('date', isGreaterThanOrEqualTo: todayKey).get();
    for (final doc in slotDocs.docs) {
      // A tombstone is not a slot: nothing renders it, so its applications
      // name an occurrence that no longer happens.
      (_slotFromDoc(doc).cancelled ? dead : live).add(doc.id);
    }

    final refs = <DocumentReference<Map<String, dynamic>>>[];
    for (final doc in future.docs) {
      final slotId = _applicationFromDoc(doc).slotId;
      if (live.contains(slotId)) continue;
      // With no document of its own it has to be an occurrence some rule
      // still expands, or it names nothing at all.
      if (dead.contains(slotId) || !_isExpandedSlotId(rules, slotId)) {
        refs.add(doc.reference);
      }
    }
    await _deleteApplicationRefs(refs);
  }

  /// Whether [slotId] is `{ruleId}_{seriesDate}` for a rule that still
  /// produces that occurrence. Rule ids may themselves contain underscores,
  /// so only the final segment is treated as the date.
  static bool _isExpandedSlotId(List<PwRecurring> rules, String slotId) {
    final underscore = slotId.lastIndexOf('_');
    if (underscore < 0) return false;
    final ruleId = slotId.substring(0, underscore);
    final seriesDate = slotId.substring(underscore + 1);
    for (final rule in rules) {
      if (rule.id == ruleId && producesOn(rule, seriesDate)) return true;
    }
    return false;
  }

  /// Applies the changes in batches below Firestore's 500-operation cap.
  /// Deletes are enqueued before writes so a document moved to a different id
  /// can never be removed after it was rewritten.
  Future<void> _applyChanges({
    required List<String> deletes,
    required List<PwSlot> writes,
  }) async {
    final ops = <void Function(WriteBatch)>[
      for (final id in deletes) (batch) => batch.delete(_slots.doc(id)),
      for (final slot in writes)
        (batch) => batch.set(slot.id.isEmpty ? _slots.doc() : _slots.doc(slot.id),
            slot.copyWith(id: '').withRecomputedAssignees().toJson()),
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
  /// for, which survives even where the `date` field was later moved — and is
  /// the date its applications are keyed to.
  static String _seriesDateOf(String docId, PwSlot slot) {
    if (slot.seriesDate.isNotEmpty) return slot.seriesDate;
    final underscore = docId.lastIndexOf('_');
    if (underscore >= 0) {
      final suffix = docId.substring(underscore + 1);
      if (tryParseDateKey(suffix) != null) return suffix;
    }
    return slot.date;
  }

  /// The rule that would produce an occurrence on [date], if any — used to
  /// re-adopt documents orphaned by a rule that was deleted and recreated.
  static PwRecurring? _adoptingRule(List<PwRecurring> rules, String date) {
    for (final rule in rules) {
      if (producesOn(rule, date)) return rule;
    }
    return null;
  }

  static bool _sameOverrides(List<String> a, List<String> b) =>
      a.length == b.length && a.every(b.contains);

  /// Pure helper: whether [rule] produces an occurrence exactly on [date].
  static bool producesOn(PwRecurring rule, String date) {
    final day = tryParseDateKey(date);
    if (day == null) return false;
    return materializedDates(rule, day, day.add(const Duration(days: 1)))
        .isNotEmpty;
  }

  /// Pure helper: whether [rule] produced any occurrence before [cutoff]. A
  /// rule without `validFrom` has no start bound, so it always did.
  static bool runsBefore(PwRecurring rule, DateTime cutoff) {
    final validFrom = tryParseDateKey(rule.validFrom);
    if (validFrom == null) return true;
    return materializedDates(rule, validFrom, cutoff).isNotEmpty;
  }

  /// Pure helper (unit-tested): dates the rule should produce in
  /// `[from, until)`, respecting validFrom/validUntil.
  static List<String> materializedDates(
      PwRecurring rule, DateTime from, DateTime until) {
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

  /// Pure helper (unit-tested): every slot held in `[from, untilExclusive)`.
  ///
  /// [byDate] are the documents *held* in the window (one-off slots,
  /// exceptions happening there, cancellation tombstones); [bySeriesDate] are
  /// the exceptions whose *occurrence* falls in it, wherever they were moved
  /// to. Both are needed: the first says what to show, the second which slots
  /// are already spoken for.
  ///
  /// An exception inherits every field it does not override from its rule, so
  /// rule edits keep reaching customized occurrences. One whose rule is gone
  /// is rendered from its own stored fields rather than dropped.
  static List<PwSlot> expand(
      List<PwSlot> byDate,
      List<PwSlot> bySeriesDate,
      List<PwRecurring> rules,
      DateTime from,
      DateTime untilExclusive) {
    final rulesById = {for (final rule in rules) rule.id: rule};
    final claimed = <String>{
      for (final slot in [...byDate, ...bySeriesDate])
        if (slot.isException)
          PwSlot.exceptionId(slot.recurringId, slot.seriesKey),
    };

    final result = <PwSlot>[];
    for (final slot in byDate) {
      if (slot.cancelled) continue;
      final rule = rulesById[slot.recurringId];
      result.add(rule == null ? slot : slot.applyRule(rule));
    }
    for (final rule in rules) {
      for (final date in materializedDates(rule, from, untilExclusive)) {
        if (claimed.contains(PwSlot.exceptionId(rule.id, date))) continue;
        result.add(PwSlot.fromRule(rule, date));
      }
    }
    result.sort((a, b) =>
        '${a.date} ${a.startTime}'.compareTo('${b.date} ${b.startTime}'));
    return result;
  }
}

final pwRepositoryProvider =
    Provider<PwRepository>((ref) => PwRepository(ref.watch(firestoreProvider)));

final pwRecurringProvider = StreamProvider<List<PwRecurring>>(
    (ref) => ref.watch(pwRepositoryProvider).watchRecurring());
