import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../firebase/firebase_providers.dart';
import '../models/models.dart';
import '../utils/dates.dart';

class PwRepository {
  PwRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _slots =>
      _db.collection('pw_slots');

  CollectionReference<Map<String, dynamic>> get _recurring =>
      _db.collection('pw_recurring');

  PwSlot _slotFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      PwSlot.fromJson(doc.data()!).copyWith(id: doc.id);

  PwRecurring _ruleFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      PwRecurring.fromJson(doc.data()!).copyWith(id: doc.id);

  Stream<List<PwSlot>> watchRange(String fromDate, String toDate) => _slots
          .where('date', isGreaterThanOrEqualTo: fromDate)
          .where('date', isLessThanOrEqualTo: toDate)
          .snapshots()
          .map((snap) {
        final list = snap.docs
            .map(_slotFromDoc)
            .where((s) => !s.cancelled)
            .toList();
        list.sort((a, b) => '${a.date} ${a.startTime}'
            .compareTo('${b.date} ${b.startTime}'));
        return list;
      });

  Future<void> saveSlot(PwSlot slot) async {
    final data = slot.withRecomputedAssignees();
    if (slot.id.isEmpty) {
      await _slots.add(data.toJson());
    } else {
      await _slots.doc(slot.id).set(data.toJson());
    }
  }

  /// One-off slots are removed; recurring instances are kept as cancelled so
  /// the materializer doesn't bring them back.
  Future<void> deleteSlot(PwSlot slot) async {
    if (slot.recurringId.isEmpty) {
      await _slots.doc(slot.id).delete();
    } else {
      await _slots.doc(slot.id).set(
          slot.copyWith(cancelled: true).toJson());
    }
  }

  Future<List<PwSlot>> getRange(String fromDate, String toDate) async {
    final snap = await _slots
        .where('date', isGreaterThanOrEqualTo: fromDate)
        .where('date', isLessThanOrEqualTo: toDate)
        .get();
    return snap.docs.map(_slotFromDoc).where((s) => !s.cancelled).toList();
  }

  Future<List<PwSlot>> getAssignedTo(String uid) async {
    final snap =
        await _slots.where('allAssigneeIds', arrayContains: uid).get();
    return snap.docs
        .map(_slotFromDoc)
        .where((s) => !s.cancelled)
        .toList();
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

  Future<String> saveRecurring(PwRecurring rule) async {
    if (rule.id.isEmpty) {
      final doc = await _recurring.add(rule.toJson());
      return doc.id;
    }
    await _recurring.doc(rule.id).set(rule.toJson());
    return rule.id;
  }

  Future<void> deleteRecurring(String ruleId) =>
      _recurring.doc(ruleId).delete();

  /// Creates missing concrete slots for [rule] from today until
  /// [AppConfig.pwMaterializeMonthsAhead] months ahead. Slot ids are
  /// deterministic (`{ruleId}_{date}`) so existing (possibly edited or
  /// cancelled) instances are left untouched.
  Future<void> materializeRule(PwRecurring rule, {DateTime? now}) async {
    final today = now ?? DateTime.now();
    final horizon = addMonths(today, AppConfig.pwMaterializeMonthsAhead + 1);
    final dates = materializedDates(rule, today, horizon);
    if (dates.isEmpty) return;

    final existing = await _slots
        .where('recurringId', isEqualTo: rule.id)
        .where('date', isGreaterThanOrEqualTo: dateKey(today))
        .get();
    final existingDates =
        existing.docs.map((d) => d.data()['date'] as String?).toSet();

    final batch = _db.batch();
    var writes = 0;
    for (final date in dates) {
      if (existingDates.contains(date)) continue;
      final slot = PwSlot(
        date: date,
        startTime: rule.startTime,
        endTime: rule.endTime,
        location: rule.location,
        assignment: rule.defaultAssignment,
        recurringId: rule.id,
      ).withRecomputedAssignees();
      batch.set(_slots.doc('${rule.id}_$date'), slot.toJson());
      writes++;
    }
    if (writes > 0) await batch.commit();
  }

  /// Pure helper (unit-tested): dates the rule should produce in
  /// [from, until), respecting validFrom/validUntil.
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
}

final pwRepositoryProvider =
    Provider<PwRepository>((ref) => PwRepository(ref.watch(firestoreProvider)));

final pwRecurringProvider = StreamProvider<List<PwRecurring>>(
    (ref) => ref.watch(pwRepositoryProvider).watchRecurring());
