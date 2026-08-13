import 'package:congregation_scheduler/core/data/admin_mode_provider.dart';
import 'package:congregation_scheduler/core/data/congregation_repository.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/data/schedule_config_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/features/events/my_assignments_provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Per-week "Show to publishers": which weeks of a schedule show the names
/// assigned in them, where the flag is stored, and what it keeps out of a
/// publisher's own assignment list (and so out of their reminders).
void main() {
  const uid = 'me';
  final monday = mondayOf(DateTime.now().add(const Duration(days: 7)));
  final weekId = dateKey(monday);
  final otherWeekId = dateKey(monday.add(const Duration(days: 7)));

  group('the stored flag', () {
    test('a week is shown unless it is listed as hidden', () {
      const config = ScheduleConfig(hiddenWeeks: ['2026-08-10']);
      expect(config.showsAssignees('2026-08-10'), isFalse);
      expect(config.showsAssignees('2026-08-17'), isTrue);
      expect(const ScheduleConfig().showsAssignees('2026-08-10'), isTrue,
          reason: 'an untouched congregation shows every week');
    });

    test('survives a round trip', () {
      const config = ScheduleConfig(hiddenWeeks: ['2026-08-10']);
      expect(ScheduleConfig.fromJson(config.toJson()), config);
    });

    test('hiding and showing a week is idempotent', () async {
      final db = FakeFirebaseFirestore();
      final repo = ScheduleConfigRepository(db);
      final doc = db.collection('schedule_config').doc(ScheduleConfigDoc.pw);

      await repo.setWeekAssigneesVisible(ScheduleConfigDoc.pw, weekId, false);
      await repo.setWeekAssigneesVisible(ScheduleConfigDoc.pw, weekId, false);
      expect((await doc.get()).data()!['hiddenWeeks'], [weekId]);

      await repo.setWeekAssigneesVisible(ScheduleConfigDoc.pw, weekId, true);
      await repo.setWeekAssigneesVisible(ScheduleConfigDoc.pw, weekId, true);
      expect((await doc.get()).data()!['hiddenWeeks'], isEmpty);
    });

    // The two schedule screens build a fresh ScheduleConfig from the list of
    // permanent assignments they hold, so a whole-document write would drop
    // the hidden weeks stored beside them.
    test('editing the permanent assignments leaves the hidden weeks alone',
        () async {
      final db = FakeFirebaseFirestore();
      final repo = ScheduleConfigRepository(db);
      await repo.setWeekAssigneesVisible(ScheduleConfigDoc.lmm, weekId, false);

      await repo.saveConfig(
        ScheduleConfigDoc.lmm,
        const ScheduleConfig(
            permanentAssignments: [CustomAssignment(id: 'a', label: 'Sound')]),
      );

      final config = await repo.getConfig(ScheduleConfigDoc.lmm);
      expect(config.permanentAssignments.single.label, 'Sound');
      expect(config.hiddenWeeks, [weekId]);
    });
  });

  group('who sees the names', () {
    ProviderContainer containerWith(FakeFirebaseFirestore db, Roles roles) {
      final container = ProviderContainer(overrides: [
        firestoreProvider.overrideWithValue(db),
        effectiveRolesProvider.overrideWithValue(roles),
        isVerifiedProvider.overrideWithValue(true),
      ]);
      addTearDown(container.dispose);
      return container;
    }

    Future<bool> visible(ProviderContainer container, ScheduleKind kind) async {
      final arg = (kind: kind, weekId: weekId);
      // Subscribe first: an unlistened provider never resolves its stream.
      // The config needs its own listener — for an admin the visibility
      // provider short-circuits and never watches it.
      container.listen(scheduleConfigProvider(kind), (_, _) {});
      container.listen(weekAssigneesVisibleProvider(arg), (_, _) {});
      await container.read(scheduleConfigProvider(kind).future);
      return container.read(weekAssigneesVisibleProvider(arg));
    }

    test('a publisher does not, on a week switched off', () async {
      final db = FakeFirebaseFirestore();
      await ScheduleConfigRepository(db)
          .setWeekAssigneesVisible(ScheduleConfigDoc.lmm, weekId, false);
      final container = containerWith(db, const Roles());

      expect(await visible(container, ScheduleKind.lmm), isFalse);
      // Each schedule is switched on its own, and only for the week named.
      expect(await visible(container, ScheduleKind.weekend), isTrue);
      expect(
          container.read(weekAssigneesVisibleProvider(
              (kind: ScheduleKind.lmm, weekId: otherWeekId))),
          isTrue);
    });

    test('the schedule\'s admins always do', () async {
      final db = FakeFirebaseFirestore();
      await ScheduleConfigRepository(db)
          .setWeekAssigneesVisible(ScheduleConfigDoc.lmm, weekId, false);
      final container = containerWith(db, const Roles(lmmSchedule: true));

      expect(await visible(container, ScheduleKind.lmm), isTrue);
    });
  });

  group('my assignments', () {
    /// One midweek part and one weekend talk, both assigned to [uid] next
    /// week, plus that week's meetings-for-field-service occurrence.
    Future<FakeFirebaseFirestore> seed() async {
      final db = FakeFirebaseFirestore();
      await db.collection('lmm_weeks').doc(weekId).set(LmmWeek(
            id: weekId,
            parts: const [
              LmmPart(
                id: 'p1',
                section: LmmSection.treasures,
                type: LmmPartType.bibleReading,
                assignment: Assignment(publisherIds: [uid]),
              ),
            ],
            allAssigneeIds: const [uid],
          ).toJson());
      await db.collection('weekend_weeks').doc(weekId).set(WeekendWeek(
            id: weekId,
            wtReader: const Assignment(publisherIds: [uid]),
            allAssigneeIds: const [uid],
          ).toJson());
      await db.collection('fsm_meetings').doc('m1').set(FsmMeeting(
            id: 'm1',
            date: dateKey(monday.add(const Duration(days: 1))),
            time: '09:30',
            location: 'Kingdom Hall',
            assignment: const Assignment(publisherIds: [uid]),
            allAssigneeIds: const [uid],
          ).toJson());
      return db;
    }

    Future<List<MyAssignmentEntry>> mine(
      FakeFirebaseFirestore db, {
      Roles roles = const Roles(),
    }) {
      final container = ProviderContainer(overrides: [
        firestoreProvider.overrideWithValue(db),
        currentUidProvider.overrideWithValue(uid),
        myRolesProvider.overrideWithValue(roles),
        congregationMetaProvider
            .overrideWith((ref) => Stream.value(const CongregationMeta())),
      ]);
      addTearDown(container.dispose);
      return container.read(myUpcomingAssignmentsProvider.future);
    }

    test('lists every assignment while the weeks are shown', () async {
      final entries = await mine(await seed());
      expect(
          entries.map((e) => e.source),
          containsAll([
            AssignmentSource.lmm,
            AssignmentSource.weekend,
            AssignmentSource.fsm,
          ]));
    });

    test('drops the ones from weeks switched off', () async {
      final db = await seed();
      final repo = ScheduleConfigRepository(db);
      await repo.setWeekAssigneesVisible(ScheduleConfigDoc.lmm, weekId, false);
      await repo.setWeekAssigneesVisible(ScheduleConfigDoc.fsm, weekId, false);

      final entries = await mine(db);
      expect(entries.map((e) => e.source), [AssignmentSource.weekend],
          reason: 'an unannounced assignment must not reach the reminders');
    });

    test('keeps them for the admin of that schedule', () async {
      final db = await seed();
      await ScheduleConfigRepository(db)
          .setWeekAssigneesVisible(ScheduleConfigDoc.lmm, weekId, false);

      final entries = await mine(db, roles: const Roles(lmmSchedule: true));
      expect(entries.map((e) => e.source), contains(AssignmentSource.lmm));
    });
  });
}
