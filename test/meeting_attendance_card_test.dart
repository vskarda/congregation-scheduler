import 'package:congregation_scheduler/core/data/admin_mode_provider.dart';
import 'package:congregation_scheduler/core/data/congregation_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/features/attendance/meeting_attendance_card.dart';
import 'package:congregation_scheduler/features/lmm_schedule/lmm_screen.dart';
import 'package:congregation_scheduler/features/weekend_schedule/weekend_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Recording attendance from the midweek and weekend meeting views: the date
/// is derived from the schedule being shown, never picked.
void main() {
  // Defaults are LMM Tuesday, weekend Sunday.
  overrides(FakeFirebaseFirestore db, Roles roles) => [
        firestoreProvider.overrideWithValue(db),
        effectiveRolesProvider.overrideWithValue(roles),
        congregationMetaProvider
            .overrideWith((ref) => Stream.value(const CongregationMeta())),
      ];

  Widget wrap(FakeFirebaseFirestore db, Widget child,
          {Roles roles = const Roles(recordAttendance: true)}) =>
      ProviderScope(
        overrides: overrides(db, roles),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // The app shell provides the Scaffold (snackbars) in production.
          home: Scaffold(body: child),
        ),
      );

  Finder field(String label) => find.widgetWithText(TextField, label);

  String textOf(Finder finder, WidgetTester tester) =>
      tester.widget<TextField>(finder).controller!.text;

  testWidgets('midweek view records against the derived meeting date',
      (tester) async {
    final db = FakeFirebaseFirestore();
    // Two weeks back, so the meeting is in the past whatever day it runs.
    final weekId = weekIdOf(DateTime.now().subtract(const Duration(days: 14)));
    // LMM weekday is Tuesday: the Monday key plus one day.
    final expectedDate =
        dateKey(parseDateKey(weekId).add(const Duration(days: 1)));
    await db.collection('lmm_weeks').doc(weekId).set(LmmWeek(id: weekId).toJson());

    await tester.pumpWidget(wrap(db, LmmWeekView(weekId: weekId)));
    await tester.pumpAndSettle();

    // Counts only — the schedule already says which meeting this is, so
    // there is no date (or meeting-type) input to get wrong.
    expect(find.text('Record attendance'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));

    await tester.enterText(field('In person'), '40');
    await tester.pump();
    await tester.enterText(field('Online'), '10');
    await tester.pump();
    expect(textOf(field('Total'), tester), '50');

    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    final docs = (await db.collection('attendance').get()).docs;
    expect(docs, hasLength(1));
    expect(docs.single.id, '${expectedDate}_lmm');
    expect(docs.single.data(), {
      'date': expectedDate,
      'meetingType': 'lmm',
      'inPerson': 40,
      'online': 10,
      'total': 50,
    });
  });

  testWidgets('weekend view records against the derived meeting date',
      (tester) async {
    final db = FakeFirebaseFirestore();
    // The pager opens on the current week, whose weekend meeting may still be
    // ahead; one week back is always past.
    final weekId = weekIdOf(DateTime.now().subtract(const Duration(days: 7)));
    // Weekend weekday is Sunday: the Monday key plus six days.
    final expectedDate =
        dateKey(parseDateKey(weekId).add(const Duration(days: 6)));
    await db
        .collection('weekend_weeks')
        .doc(weekId)
        .set(WeekendWeek(id: weekId).toJson());

    await tester.pumpWidget(wrap(db, const WeekendScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();

    await tester.enterText(field('Total'), '85');
    await tester.pump();
    // The weekend list is taller than the test viewport.
    final save = find.widgetWithText(FilledButton, 'Save');
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();

    final docs = (await db.collection('attendance').get()).docs;
    expect(docs, hasLength(1));
    expect(docs.single.id, '${expectedDate}_weekend');
    expect(docs.single.data(),
        {'date': expectedDate, 'meetingType': 'weekend', 'total': 85});
  });

  testWidgets('prefills the counts already recorded for the meeting',
      (tester) async {
    final db = FakeFirebaseFirestore();
    final date = dateKey(DateTime.now().subtract(const Duration(days: 3)));
    await db.collection('attendance').doc('${date}_lmm').set(
        {'date': date, 'meetingType': 'lmm', 'inPerson': 30, 'online': 5, 'total': 35});

    // The form seeds its controllers once, so this only passes if the card
    // waits for the stored entry before building it.
    await tester.pumpWidget(wrap(
        db,
        MeetingAttendanceCard(
            date: parseDateKey(date), meetingType: MeetingType.lmm)));
    await tester.pumpAndSettle();

    expect(textOf(field('In person'), tester), '30');
    expect(textOf(field('Online'), tester), '5');
    expect(textOf(field('Total'), tester), '35');
  });

  testWidgets('hidden for a meeting that has not happened yet', (tester) async {
    final db = FakeFirebaseFirestore();
    await tester.pumpWidget(wrap(
        db,
        MeetingAttendanceCard(
          date: DateTime.now().add(const Duration(days: 1)),
          meetingType: MeetingType.lmm,
        )));
    await tester.pumpAndSettle();

    expect(find.text('Record attendance'), findsNothing);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('shown today, and only to roles that may record', (tester) async {
    final db = FakeFirebaseFirestore();
    Widget card() => MeetingAttendanceCard(
        date: DateTime.now(), meetingType: MeetingType.weekend);

    await tester.pumpWidget(wrap(db, card(), roles: const Roles()));
    await tester.pumpAndSettle();
    expect(find.text('Record attendance'), findsNothing);

    await tester.pumpWidget(
        wrap(db, card(), roles: const Roles(recordAttendance: true)));
    await tester.pumpAndSettle();
    expect(find.text('Record attendance'), findsOneWidget);

    await tester
        .pumpWidget(wrap(db, card(), roles: const Roles(fullAdmin: true)));
    await tester.pumpAndSettle();
    expect(find.text('Record attendance'), findsOneWidget);
  });
}
