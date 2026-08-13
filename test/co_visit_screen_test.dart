import 'package:congregation_scheduler/core/data/admin_mode_provider.dart';
import 'package:congregation_scheduler/core/data/congregation_repository.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/data/schedule_config_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/co_visit/co_visit_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The circuit overseer view, with an eye on who may edit what: the visit
/// belongs to the `events` role, but its meetings for field service belong to
/// `fieldServiceMeetings` and the midweek meeting day to `lmmSchedule`. An
/// events-admin holding none of the other two must see those sections without
/// being offered edits the rules would deny.
void main() {
  const weekId = '2026-04-13'; // Monday; the visit runs 14–19 April
  const meta = CongregationMeta(
      lmmWeekday: DateTime.wednesday, lmmTime: '18:30', name: 'Springfield');

  Future<void> seedVisit(FakeFirebaseFirestore db,
      {List<String> hidden = const []}) {
    return db.collection('co_visits').doc(weekId).set(
          const CoVisit(id: weekId, items: [
            CoVisitItem(
              id: 'a',
              section: CoVisitSection.meal,
              date: '2026-04-14',
              time: '12:00',
              address: 'Hlavní 12',
            ),
          ]).copyWith(hiddenSections: hidden).toJson(),
        );
  }

  Future<void> seedVisibility(FakeFirebaseFirestore db, bool visible) {
    return db
        .collection('schedule_config')
        .doc('coVisit')
        .set(CoVisitConfig(visibleToPublishers: visible).toJson());
  }

  Widget wrap(FakeFirebaseFirestore db, Roles roles) => ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(db),
          effectiveRolesProvider.overrideWithValue(roles),
          isVerifiedProvider.overrideWithValue(true),
          allPublishersProvider.overrideWith((ref) => Stream.value(const [])),
          congregationMetaProvider.overrideWith((ref) => Stream.value(meta)),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: CoVisitScreen()),
        ),
      );

  AppLocalizations l10n() => lookupAppLocalizations(const Locale('en'));

  testWidgets('publishers see nothing until an admin publishes the view',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await seedVisit(db);
    await seedVisibility(db, false);

    await tester.pumpWidget(wrap(db, const Roles()));
    await tester.pumpAndSettle();

    expect(find.text(l10n().coVisitNotPublished), findsOneWidget);
    expect(find.text(l10n().coSectionMeal), findsNothing);
  });

  testWidgets('a published visit is readable, with no edit affordances',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await seedVisit(db);
    await seedVisibility(db, true);

    await tester.pumpWidget(wrap(db, const Roles()));
    await tester.pumpAndSettle();

    expect(find.text(l10n().coSectionMeal), findsOneWidget);
    expect(find.text('12:00  ·  Hlavní 12'), findsOneWidget);
    expect(find.text(l10n().coVisitVisibleToPublishers), findsNothing);
    expect(find.byIcon(Icons.add), findsNothing);
    expect(find.byIcon(Icons.delete_outline), findsNothing);
  });

  testWidgets('hidden sections reach admins only', (tester) async {
    final db = FakeFirebaseFirestore();
    await seedVisit(db, hidden: ['meal']);
    await seedVisibility(db, true);

    await tester.pumpWidget(wrap(db, const Roles()));
    await tester.pumpAndSettle();
    expect(find.text(l10n().coSectionMeal), findsNothing);

    await tester.pumpWidget(wrap(db, const Roles(events: true)));
    await tester.pumpAndSettle();
    expect(find.text(l10n().coSectionMeal), findsOneWidget);
    expect(find.text(l10n().coSectionHidden), findsOneWidget);
  });

  testWidgets(
      'an events-admin without the other roles is told who edits those',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await seedVisit(db);

    await tester.pumpWidget(wrap(db, const Roles(events: true)));
    await tester.pumpAndSettle();

    // Its own sections are editable...
    expect(find.text(l10n().coVisitVisibleToPublishers), findsOneWidget);
    expect(find.byIcon(Icons.add), findsWidgets);
    // ...but the two that belong elsewhere say so instead.
    expect(find.text(l10n().coMinistryOtherAdmins), findsOneWidget);
    expect(find.text(l10n().coMidweekOtherAdmins), findsOneWidget);
  });

  testWidgets('holding every role removes those notices', (tester) async {
    final db = FakeFirebaseFirestore();
    await seedVisit(db);

    await tester.pumpWidget(wrap(
        db,
        const Roles(
            events: true, fieldServiceMeetings: true, lmmSchedule: true)));
    await tester.pumpAndSettle();

    expect(find.text(l10n().coMinistryOtherAdmins), findsNothing);
    expect(find.text(l10n().coMidweekOtherAdmins), findsNothing);
  });

  // The ministry section renders fsm_meetings, so it obeys that view's own
  // per-week switch: the same documents must not be readable here after
  // being hidden there.
  testWidgets('the ministry names follow the field-service switch',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await seedVisit(db);
    await seedVisibility(db, true);
    await db.collection('fsm_meetings').doc('m1').set(const FsmMeeting(
          id: 'm1',
          date: '2026-04-14',
          time: '09:30',
          location: 'Kingdom Hall',
          assignment: Assignment(freeText: 'Petr Svoboda'),
        ).toJson());

    await tester.pumpWidget(wrap(db, const Roles()));
    await tester.pumpAndSettle();
    expect(find.text('09:30  ·  Kingdom Hall'), findsOneWidget);
    expect(find.text('Petr Svoboda'), findsOneWidget);

    await ScheduleConfigRepository(db)
        .setWeekAssigneesVisible(ScheduleConfigDoc.fsm, weekId, false);
    await tester.pumpWidget(wrap(db, const Roles()));
    await tester.pumpAndSettle();
    expect(find.text('09:30  ·  Kingdom Hall'), findsOneWidget);
    expect(find.text('Petr Svoboda'), findsNothing);

    // Its own admins go on planning it.
    await tester.pumpWidget(wrap(db, const Roles(fieldServiceMeetings: true)));
    await tester.pumpAndSettle();
    expect(find.text('Petr Svoboda'), findsOneWidget);
  });

  testWidgets('the visit week shows the midweek meeting it moved',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await seedVisit(db);
    await db.collection('lmm_weeks').doc(weekId).set(
        const LmmWeek(id: weekId, meetingWeekday: DateTime.tuesday)
            .toJson());

    await tester.pumpWidget(wrap(db, const Roles(events: true)));
    await tester.pumpAndSettle();

    expect(find.text('Tuesday  ·  18:30'), findsOneWidget);
    expect(find.text(l10n().meetingWeekChanged), findsOneWidget);
  });
}
