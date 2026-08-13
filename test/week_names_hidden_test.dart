import 'package:congregation_scheduler/core/data/admin_mode_provider.dart';
import 'package:congregation_scheduler/core/data/congregation_repository.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/data/schedule_config_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/features/field_service_meetings/fsm_screen.dart';
import 'package:congregation_scheduler/features/lmm_schedule/lmm_screen.dart';
import 'package:congregation_scheduler/features/public_witnessing/pw_screen.dart';
import 'package:congregation_scheduler/features/weekend_schedule/weekend_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A week switched off with "Show to publishers" keeps its program and loses
/// its names — for everyone but the admins of that schedule, who go on
/// planning it as before.
void main() {
  final weekId = dateKey(mondayOf(DateTime.now()));
  // Sunday of the week on screen: whatever day the suite runs on, it is never
  // in the past, so the apply/withdraw controls are the live ones.
  final sunday = dateKey(mondayOf(DateTime.now()).add(const Duration(days: 6)));
  const meta = CongregationMeta(
      lmmWeekday: DateTime.wednesday, lmmTime: '18:30', name: 'Springfield');
  const anna = Publisher(
    id: 'p1',
    firstName: 'Anna',
    lastName: 'Nováková',
    verified: true,
    qualifications: Qualifications(publicWitnessing: true),
  );

  AppLocalizations l10n() => lookupAppLocalizations(const Locale('en'));

  /// A surface tall enough for a whole week to be built at once — a list
  /// item scrolled out of view is not merely invisible, it does not exist,
  /// and "the names are gone" would pass for the wrong reason.
  void tallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1000, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Future<void> hide(FakeFirebaseFirestore db, String docId) =>
      ScheduleConfigRepository(db)
          .setWeekAssigneesVisible(docId, weekId, false);

  Widget wrap(FakeFirebaseFirestore db, Roles roles, Widget screen) =>
      ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(db),
          effectiveRolesProvider.overrideWithValue(roles),
          myRolesProvider.overrideWithValue(roles),
          isVerifiedProvider.overrideWithValue(true),
          currentUidProvider.overrideWithValue(anna.id),
          myPublisherProvider.overrideWith((ref) => Stream.value(anna)),
          allPublishersProvider.overrideWith((ref) => Stream.value([anna])),
          congregationMetaProvider.overrideWith((ref) => Stream.value(meta)),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: screen),
        ),
      );

  group('midweek meeting', () {
    Future<FakeFirebaseFirestore> seed() async {
      final db = FakeFirebaseFirestore();
      await db.collection('lmm_weeks').doc(weekId).set(LmmWeek(
            id: weekId,
            weekLabel: 'August 10-16',
            parts: const [
              LmmPart(
                id: 'p1',
                section: LmmSection.treasures,
                type: LmmPartType.bibleReading,
                title: 'Bible reading',
                assignment: Assignment(publisherIds: ['p1']),
              ),
            ],
            attendants: const Assignment(publisherIds: ['p1']),
          ).toJson());
      return db;
    }

    testWidgets('a publisher gets the program without the names',
        (tester) async {
      tallScreen(tester);
      final db = await seed();
      await hide(db, ScheduleConfigDoc.lmm);
      await tester.pumpWidget(wrap(db, const Roles(), const LmmScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Bible reading'), findsOneWidget);
      expect(find.text(anna.fullName), findsNothing);
      // The support card is nothing but names, so it goes as a whole.
      expect(find.text(l10n().supportAttendants), findsNothing);
      expect(find.text(l10n().weekShowToPublishers), findsNothing);
    });

    testWidgets('its admin keeps them, and the switch', (tester) async {
      tallScreen(tester);
      final db = await seed();
      await hide(db, ScheduleConfigDoc.lmm);
      await tester.pumpWidget(
          wrap(db, const Roles(lmmSchedule: true), const LmmScreen()));
      await tester.pumpAndSettle();

      expect(find.text(anna.fullName), findsWidgets);
      expect(find.text(l10n().supportAttendants), findsOneWidget);
      expect(find.text(l10n().weekShowToPublishersOff), findsOneWidget);
    });

    testWidgets('the switch stores the week it was turned off on',
        (tester) async {
      tallScreen(tester);
      final db = await seed();
      await tester.pumpWidget(
          wrap(db, const Roles(lmmSchedule: true), const LmmScreen()));
      await tester.pumpAndSettle();

      expect(find.text(l10n().weekShowToPublishersOn), findsOneWidget);
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      final stored =
          await db.collection('schedule_config').doc('lmm').get();
      expect(stored.data()!['hiddenWeeks'], [weekId]);
      expect(find.text(l10n().weekShowToPublishersOff), findsOneWidget);
    });
  });

  group('weekend meeting', () {
    Future<FakeFirebaseFirestore> seed() async {
      final db = FakeFirebaseFirestore();
      await db.collection('weekend_weeks').doc(weekId).set(WeekendWeek(
            id: weekId,
            talkTitle: 'Who Really Rules the World?',
            speaker: const Assignment(publisherIds: ['p1']),
          ).toJson());
      return db;
    }

    testWidgets('the talk stays, the speaker goes', (tester) async {
      tallScreen(tester);
      final db = await seed();
      await hide(db, ScheduleConfigDoc.weekend);
      await tester.pumpWidget(wrap(db, const Roles(), const WeekendScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Who Really Rules the World?'), findsOneWidget);
      expect(find.text(l10n().weekendSpeaker), findsNothing);
      expect(find.text(anna.fullName), findsNothing);
    });

    testWidgets('its admin keeps the speaker', (tester) async {
      tallScreen(tester);
      final db = await seed();
      await hide(db, ScheduleConfigDoc.weekend);
      await tester.pumpWidget(
          wrap(db, const Roles(weekendSchedule: true), const WeekendScreen()));
      await tester.pumpAndSettle();

      expect(find.text(l10n().weekendSpeaker), findsOneWidget);
      expect(find.text(anna.fullName), findsOneWidget);
    });
  });

  group('meetings for field service', () {
    Future<FakeFirebaseFirestore> seed() async {
      final db = FakeFirebaseFirestore();
      await db.collection('fsm_meetings').doc('m1').set(FsmMeeting(
            id: 'm1',
            date: sunday,
            time: '09:30',
            location: 'Kingdom Hall',
            note: 'Bring tracts',
            assignment: const Assignment(publisherIds: ['p1']),
          ).toJson());
      return db;
    }

    testWidgets('the meeting stays, the conductor goes', (tester) async {
      tallScreen(tester);
      final db = await seed();
      await hide(db, ScheduleConfigDoc.fsm);
      await tester.pumpWidget(wrap(db, const Roles(), const FsmScreen()));
      await tester.pumpAndSettle();

      expect(find.textContaining('Kingdom Hall'), findsOneWidget);
      expect(find.text('Bring tracts'), findsOneWidget);
      expect(find.text(anna.fullName), findsNothing);
    });

    testWidgets('its admin keeps the conductor', (tester) async {
      tallScreen(tester);
      final db = await seed();
      await hide(db, ScheduleConfigDoc.fsm);
      await tester.pumpWidget(wrap(
          db, const Roles(fieldServiceMeetings: true), const FsmScreen()));
      await tester.pumpAndSettle();

      expect(find.text(anna.fullName), findsOneWidget);
    });
  });

  group('public witnessing', () {
    Future<FakeFirebaseFirestore> seed() async {
      final db = FakeFirebaseFirestore();
      await db.collection('pw_slots').doc('s1').set(PwSlot(
            id: 's1',
            date: sunday,
            startTime: '10:00',
            endTime: '12:00',
            location: 'Main square',
            assignment: const Assignment(publisherIds: ['p1']),
            allAssigneeIds: const ['p1'],
          ).toJson());
      return db;
    }

    testWidgets('the slot stays, the names go', (tester) async {
      tallScreen(tester);
      final db = await seed();
      await hide(db, ScheduleConfigDoc.pw);
      await tester.pumpWidget(wrap(db, const Roles(), const PwScreen()));
      await tester.pumpAndSettle();

      expect(find.textContaining('Main square'), findsOneWidget);
      expect(find.text(anna.fullName), findsNothing);
    });

    // The hand is the only handle a publisher has on a slot; being assigned
    // to one — which a hidden week does not show them — must not take it
    // away, and withdrawing an application never touches the assignment.
    testWidgets('an assigned publisher can still apply and withdraw',
        (tester) async {
      tallScreen(tester);
      final db = await seed();
      await hide(db, ScheduleConfigDoc.pw);
      await tester.pumpWidget(wrap(db, const Roles(), const PwScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.front_hand_outlined));
      await tester.pumpAndSettle();
      expect((await db.collection('pw_applications').get()).docs, hasLength(1));

      await tester.tap(find.byIcon(Icons.front_hand));
      await tester.pumpAndSettle();
      expect((await db.collection('pw_applications').get()).docs, isEmpty);

      final slot = await db.collection('pw_slots').doc('s1').get();
      expect(slot.data()!['allAssigneeIds'], ['p1'],
          reason: 'withdrawing an application is not a resignation');
    });
  });
}
