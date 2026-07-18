import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../firebase/firebase_providers.dart';
import '../models/models.dart';
import '../utils/dates.dart';

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

  Future<void> saveMeeting(FsmMeeting meeting) async {
    final data = meeting.withRecomputedAssignees();
    if (meeting.id.isEmpty) {
      await _meetings.add(data.toJson());
    } else {
      await _meetings.doc(meeting.id).set(data.toJson());
    }
  }

  /// One-off meetings are removed; recurring instances are kept as cancelled
  /// so the materializer doesn't bring them back.
  Future<void> deleteMeeting(FsmMeeting meeting) async {
    if (meeting.recurringId.isEmpty) {
      await _meetings.doc(meeting.id).delete();
    } else {
      await _meetings
          .doc(meeting.id)
          .set(meeting.copyWith(cancelled: true).toJson());
    }
  }

  Future<List<FsmMeeting>> getRange(String fromDate, String toDate) async {
    final snap = await _meetings
        .where('date', isGreaterThanOrEqualTo: fromDate)
        .where('date', isLessThanOrEqualTo: toDate)
        .get();
    return snap.docs.map(_meetingFromDoc).where((m) => !m.cancelled).toList();
  }

  Future<List<FsmMeeting>> getAssignedTo(String uid) async {
    final snap =
        await _meetings.where('allAssigneeIds', arrayContains: uid).get();
    return snap.docs
        .map(_meetingFromDoc)
        .where((m) => !m.cancelled)
        .toList();
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

  Future<String> saveRecurring(FsmRecurring rule) async {
    if (rule.id.isEmpty) {
      final doc = await _recurring.add(rule.toJson());
      return doc.id;
    }
    await _recurring.doc(rule.id).set(rule.toJson());
    return rule.id;
  }

  /// Deletes the rule and its own future instances (past instances are kept
  /// for history, matching [deleteMeeting]'s preservation philosophy). Past
  /// instances stay orphaned by design; only future ones would otherwise
  /// linger forever in the weekly overview with no rule left to manage them.
  Future<void> deleteRecurring(String ruleId, {DateTime? now}) async {
    await _recurring.doc(ruleId).delete();
    final todayKey = dateKey(now ?? DateTime.now());
    final existing =
        await _meetings.where('recurringId', isEqualTo: ruleId).get();
    final futureDocs = existing.docs.where((d) {
      final date = d.data()['date'] as String?;
      return date != null && date.compareTo(todayKey) >= 0;
    }).toList();
    for (var i = 0; i < futureDocs.length; i += 400) {
      final batch = _db.batch();
      for (final doc in futureDocs.skip(i).take(400)) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }

  /// Deletes every future concrete meeting (one-off and recurring-generated)
  /// and every recurring rule, so nothing regenerates. Past meetings are kept
  /// for history/reporting. Used by the "remove all future meetings" reset
  /// action, which also sweeps up instances orphaned by a rule that was
  /// already deleted via the old, non-cleaning [deleteRecurring].
  Future<void> deleteAllFutureMeetings({DateTime? now}) async {
    final todayKey = dateKey(now ?? DateTime.now());
    final futureMeetings =
        await _meetings.where('date', isGreaterThanOrEqualTo: todayKey).get();
    for (var i = 0; i < futureMeetings.docs.length; i += 400) {
      final batch = _db.batch();
      for (final doc in futureMeetings.docs.skip(i).take(400)) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }

    final rules = await _recurring.get();
    for (var i = 0; i < rules.docs.length; i += 400) {
      final batch = _db.batch();
      for (final doc in rules.docs.skip(i).take(400)) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }

  /// Creates missing concrete meetings for [rule] from today until
  /// [AppConfig.fsmMaterializeMonthsAhead] months ahead. Meeting ids are
  /// deterministic (`{ruleId}_{date}`) so existing (possibly edited or
  /// cancelled) instances are left untouched.
  ///
  /// Unlike PW, existing instances are looked up by `recurringId` only and
  /// filtered by date client-side — an equality+range query would need a
  /// composite index no congregation ever provisions.
  Future<void> materializeRule(FsmRecurring rule, {DateTime? now}) async {
    final today = now ?? DateTime.now();
    final horizon = addMonths(today, AppConfig.fsmMaterializeMonthsAhead + 1);
    final dates = materializedDates(rule, today, horizon);
    if (dates.isEmpty) return;

    final existing =
        await _meetings.where('recurringId', isEqualTo: rule.id).get();
    final todayKey = dateKey(today);
    final existingDates = existing.docs
        .map((d) => d.data()['date'] as String?)
        .where((d) => d != null && d.compareTo(todayKey) >= 0)
        .toSet();

    final batch = _db.batch();
    var writes = 0;
    for (final date in dates) {
      if (existingDates.contains(date)) continue;
      final meeting = FsmMeeting(
        date: date,
        time: rule.time,
        location: rule.location,
        note: rule.note,
        assignment: rule.defaultAssignment,
        recurringId: rule.id,
      ).withRecomputedAssignees();
      batch.set(_meetings.doc('${rule.id}_$date'), meeting.toJson());
      writes++;
    }
    if (writes > 0) await batch.commit();
  }

  /// Pure helper (unit-tested): dates the rule should produce in
  /// [from, until), respecting validFrom/validUntil.
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

  /// Pure helper (unit-tested): merges [concrete] meetings with virtual
  /// instances expanded from [rules] for [from, untilExclusive), so recurring
  /// meetings are visible even where the materializer never wrote docs
  /// (regular publishers, past weeks, beyond the horizon).
  ///
  /// [concrete] must include cancelled instances — they suppress their
  /// virtual counterpart but are excluded from the result. Virtual meetings
  /// carry the deterministic materializer id (`{ruleId}_{date}`) so editing
  /// or deleting one writes the exact doc the materializer would create.
  static List<FsmMeeting> mergeWithRules(List<FsmMeeting> concrete,
      List<FsmRecurring> rules, DateTime from, DateTime untilExclusive) {
    final covered = concrete
        .where((m) => m.recurringId.isNotEmpty)
        .map((m) => '${m.recurringId}_${m.date}')
        .toSet();
    final result = concrete.where((m) => !m.cancelled).toList();
    for (final rule in rules) {
      for (final date in materializedDates(rule, from, untilExclusive)) {
        if (covered.contains('${rule.id}_$date')) continue;
        result.add(FsmMeeting(
          id: '${rule.id}_$date',
          date: date,
          time: rule.time,
          location: rule.location,
          note: rule.note,
          assignment: rule.defaultAssignment,
          recurringId: rule.id,
        ).withRecomputedAssignees());
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
