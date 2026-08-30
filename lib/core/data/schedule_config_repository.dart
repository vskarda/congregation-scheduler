import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';
import 'admin_mode_provider.dart';
import 'publishers_repository.dart';

/// Doc ids in the `schedule_config` collection.
class ScheduleConfigDoc {
  static const lmm = 'lmm';
  static const weekend = 'weekend';

  /// Public witnessing and the meetings for field service keep no permanent
  /// assignments; their documents exist for [ScheduleConfig.hiddenWeeks].
  static const pw = 'pw';
  static const fsm = 'fsm';

  /// Circuit overseer view settings ([CoVisitConfig]) — a different shape
  /// from the other two, written by the `events` role.
  static const coVisit = 'coVisit';

  static String of(ScheduleKind kind) => switch (kind) {
        ScheduleKind.lmm => lmm,
        ScheduleKind.weekend => weekend,
        ScheduleKind.pw => pw,
        ScheduleKind.fsm => fsm,
      };
}

/// Whether [roles] may edit the schedule [kind] — and so always sees the
/// names assigned in it, whatever the per-week switch says.
bool canEditSchedule(Roles roles, ScheduleKind kind) => switch (kind) {
      ScheduleKind.lmm => roles.canEditLmm(),
      ScheduleKind.weekend => roles.canEditWeekend(),
      ScheduleKind.pw => roles.canEditPublicWitnessing(),
      ScheduleKind.fsm => roles.canEditFieldServiceMeetings(),
    };

/// Whether [roles] may edit one week of the schedule [kind], given the
/// [programKind] that week runs.
///
/// The Memorial replaces whichever meeting it falls on, and the same brothers
/// arrange it wherever it lands — so both meeting-schedule roles may edit a
/// memorial week, in either schedule. firestore.rules grants exactly this;
/// keeping the check here means the UI never offers a write the rules deny.
bool canEditProgram(
  Roles roles,
  ScheduleKind kind,
  MeetingProgramKind programKind,
) {
  if (programKind == MeetingProgramKind.memorial &&
      (kind == ScheduleKind.lmm || kind == ScheduleKind.weekend)) {
    return roles.canEditLmm() || roles.canEditWeekend();
  }
  return canEditSchedule(roles, kind);
}

/// Congregation-level schedule configuration (permanent custom assignments).
/// One document per meeting type; see [ScheduleConfig].
class ScheduleConfigRepository {
  ScheduleConfigRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('schedule_config');

  Stream<ScheduleConfig> watchConfig(String docId) =>
      _col.doc(docId).snapshots().map(_configOf);

  Future<ScheduleConfig> getConfig(String docId) async =>
      _configOf(await _col.doc(docId).get());

  static ScheduleConfig _configOf(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return data == null ? const ScheduleConfig() : ScheduleConfig.fromJson(data);
  }

  /// Writes the permanent custom assignments and *only* those: callers build
  /// a fresh [ScheduleConfig] from the list they hold, which would otherwise
  /// wipe the visibility flags stored in the same document.
  Future<void> saveConfig(String docId, ScheduleConfig config) =>
      _col.doc(docId).set(
        {'permanentAssignments': config.toJson()['permanentAssignments']},
        SetOptions(merge: true),
      );

  /// Shows or hides the names assigned in one week of one schedule.
  ///
  /// An atomic array operation rather than a read-modify-write: two admins
  /// switching two different weeks must not overwrite each other, and the
  /// document also carries the permanent assignments.
  Future<void> setWeekAssigneesVisible(
    String docId,
    String weekId,
    bool visible,
  ) =>
      _col.doc(docId).set(
        {
          'hiddenWeeks': visible
              ? FieldValue.arrayRemove([weekId])
              : FieldValue.arrayUnion([weekId]),
        },
        SetOptions(merge: true),
      );

  /// Circuit overseer view settings. Kept apart from [watchConfig] because
  /// the document holds a different shape ([CoVisitConfig]), not permanent
  /// assignments.
  Stream<CoVisitConfig> watchCoVisitConfig() =>
      _col.doc(ScheduleConfigDoc.coVisit).snapshots().map((doc) {
        final data = doc.data();
        return data == null
            ? const CoVisitConfig()
            : CoVisitConfig.fromJson(data);
      });

  Future<void> saveCoVisitConfig(CoVisitConfig config) =>
      _col.doc(ScheduleConfigDoc.coVisit).set(config.toJson());

  /// Rewrites publisher id [fromId] to [toId] in the permanent
  /// custom-assignment templates of [docId]; used when connecting an
  /// admin-created record to a registered account. Idempotent.
  Future<void> replaceAssignee(String docId, String fromId, String toId) async {
    final data = (await _col.doc(docId).get()).data();
    if (data == null) return;
    final config = ScheduleConfig.fromJson(data);
    if (!config.permanentAssignments
        .any((c) => c.assignment.contains(fromId))) {
      return;
    }
    await saveConfig(
        docId,
        ScheduleConfig(permanentAssignments: [
          for (final c in config.permanentAssignments)
            c.copyWith(assignment: c.assignment.replaceAssignee(fromId, toId)),
        ]));
  }
}

final scheduleConfigRepositoryProvider = Provider<ScheduleConfigRepository>(
  (ref) => ScheduleConfigRepository(ref.watch(firestoreProvider)),
);

/// Permanent custom assignments for the midweek (LMM) meeting.
final lmmPermanentAssignmentsProvider =
    StreamProvider<List<CustomAssignment>>((ref) {
  return ref
      .watch(scheduleConfigRepositoryProvider)
      .watchConfig(ScheduleConfigDoc.lmm)
      .map((c) => c.permanentAssignments);
});

/// Permanent custom assignments for the weekend meeting.
final weekendPermanentAssignmentsProvider =
    StreamProvider<List<CustomAssignment>>((ref) {
  return ref
      .watch(scheduleConfigRepositoryProvider)
      .watchConfig(ScheduleConfigDoc.weekend)
      .map((c) => c.permanentAssignments);
});

/// One-shot twin of the two providers above, for the month PDF export.
///
/// Both are StreamProviders, and a StreamProvider's `.future` only completes
/// while something is listening. The screens watch them from inside a
/// conditional branch (the weekend card is built only when names are shown),
/// so the export cannot rely on a listener being there.
final permanentAssignmentsOnceProvider =
    FutureProvider.family<List<CustomAssignment>, String>((ref, docId) async {
  final config = await ref.watch(scheduleConfigRepositoryProvider)
      .getConfig(docId);
  return config.permanentAssignments;
});

/// Configuration document of one schedule, for the per-week visibility
/// flags. Kept apart from the two permanent-assignment providers above so
/// those keep their `.future` behaviour for the PDF export.
final scheduleConfigProvider =
    StreamProvider.family<ScheduleConfig, ScheduleKind>((ref, kind) {
  // Mirrors the rule on schedule_config: verified users may read it.
  if (!ref.watch(isVerifiedProvider)) {
    return Stream.value(const ScheduleConfig());
  }
  return ref
      .watch(scheduleConfigRepositoryProvider)
      .watchConfig(ScheduleConfigDoc.of(kind));
});

/// Whether this user is shown the names assigned in one week of one
/// schedule: its admins always, everyone else unless the week is switched
/// off. Keyed on the *effective* roles, so an admin who hides the admin UI
/// sees exactly what the congregation sees.
final weekAssigneesVisibleProvider =
    Provider.family<bool, ({ScheduleKind kind, String weekId})>((ref, args) {
  if (canEditSchedule(ref.watch(effectiveRolesProvider), args.kind)) {
    return true;
  }
  final config =
      ref.watch(scheduleConfigProvider(args.kind)).value ?? const ScheduleConfig();
  return config.showsAssignees(args.weekId);
});

/// Circuit overseer view settings; defaults (view hidden from publishers)
/// until an admin writes the document.
final coVisitConfigProvider = StreamProvider<CoVisitConfig>((ref) {
  // Mirrors the rule on schedule_config: verified users may read it.
  if (!ref.watch(isVerifiedProvider)) {
    return Stream.value(const CoVisitConfig());
  }
  return ref.watch(scheduleConfigRepositoryProvider).watchCoVisitConfig();
});
