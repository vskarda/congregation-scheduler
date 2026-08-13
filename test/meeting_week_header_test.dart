import 'package:congregation_scheduler/core/data/admin_mode_provider.dart';
import 'package:congregation_scheduler/core/data/congregation_repository.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/core/widgets/week_navigator.dart';
import 'package:congregation_scheduler/features/lmm_schedule/lmm_screen.dart';
import 'package:congregation_scheduler/features/weekend_schedule/weekend_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

/// The week header of the midweek and weekend schedules: it names the meeting
/// of the week on screen, picks another week by its meeting date, and (for
/// admins) moves this week's meeting — the row that used to sit inside the
/// schedule itself.
void main() {
  const meta = CongregationMeta(
    lmmWeekday: DateTime.wednesday,
    lmmTime: '18:30',
    weekendWeekday: DateTime.sunday,
    weekendTime: '10:00',
  );

  final thisMonday = mondayOf(DateTime.now());
  String weekIdAfter(int weeks) => dateKey(
      DateTime(thisMonday.year, thisMonday.month, thisMonday.day + 7 * weeks));

  Widget wrap(FakeFirebaseFirestore db, Widget screen,
          {Roles roles = const Roles(fullAdmin: true)}) =>
      ProviderScope(
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
          home: Scaffold(body: screen),
        ),
      );

  /// The header drops the year for the current one, to keep the title on a
  /// single line on a phone.
  String dayLabel(DateTime day) =>
      '${DateFormat.EEEE('en').format(day)}, '
      '${day.year == DateTime.now().year ? DateFormat.MMMd('en').format(day) : DateFormat.yMMMd('en').format(day)}';

  DateTime meetingOf(String weekId, int weekday) =>
      meetingDateOf(weekId, weekday)!;

  testWidgets('names the congregation meeting day of the week on screen',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await tester.pumpWidget(wrap(db, const LmmScreen()));
    await tester.pumpAndSettle();

    expect(
        find.text(dayLabel(meetingOf(dateKey(thisMonday), DateTime.wednesday))),
        findsOneWidget);
    expect(find.textContaining('18:30'), findsOneWidget);
  });

  testWidgets('follows a week that moved its meeting', (tester) async {
    final db = FakeFirebaseFirestore();
    await db.collection('lmm_weeks').doc(dateKey(thisMonday)).set(const LmmWeek(
            id: 'x', meetingWeekday: DateTime.tuesday, meetingTime: '19:00')
        .toJson());

    await tester.pumpWidget(wrap(db, const LmmScreen()));
    await tester.pumpAndSettle();

    expect(
        find.text(dayLabel(meetingOf(dateKey(thisMonday), DateTime.tuesday))),
        findsOneWidget);
    expect(find.textContaining('19:00'), findsOneWidget);
    expect(
        find.textContaining(
            lookupAppLocalizations(const Locale('en')).meetingWeekChanged),
        findsOneWidget);
  });

  testWidgets('the menu offers 4 weeks back and 20 forward, and jumps',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await tester.pumpWidget(wrap(db, const WeekendScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(WeekPickerButton));
    await tester.pumpAndSettle();

    // Dates, not week ranges: each week is offered by its meeting day.
    final fourBack = meetingOf(weekIdAfter(-4), DateTime.sunday);
    final twentyAhead = meetingOf(weekIdAfter(20), DateTime.sunday);
    expect(find.text(DateFormat.yMMMEd('en').format(fourBack)), findsOneWidget);
    expect(find.text(DateFormat.yMMMEd('en').format(twentyAhead)),
        findsOneWidget);
    expect(find.text(DateFormat.yMMMEd('en').format(
            meetingOf(weekIdAfter(21), DateTime.sunday))),
        findsNothing);

    // The menu scrolls; the last week is built but off-screen.
    final farWeek = find.text(DateFormat.yMMMEd('en').format(twentyAhead));
    await tester.ensureVisible(farWeek);
    await tester.pumpAndSettle();
    await tester.tap(farWeek);
    await tester.pumpAndSettle();

    expect(find.text(dayLabel(twentyAhead)), findsOneWidget);
  });

  testWidgets('the pencil moves this week and is admin-only', (tester) async {
    final db = FakeFirebaseFirestore();

    await tester.pumpWidget(wrap(db, const LmmScreen(), roles: const Roles()));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.edit_outlined), findsNothing);

    await tester.pumpWidget(wrap(db, const LmmScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    await tester.tap(find.text(l10n.meetingWeekDifferent));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wednesday').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tuesday').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    // The week document is created just to carry the moved meeting.
    final stored =
        await db.collection('lmm_weeks').doc(dateKey(thisMonday)).get();
    expect(stored.data()!['meetingWeekday'], DateTime.tuesday);
    expect(
        find.text(dayLabel(meetingOf(dateKey(thisMonday), DateTime.tuesday))),
        findsOneWidget);
  });

  testWidgets('the schedule itself no longer carries the meeting row',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await db
        .collection('weekend_weeks')
        .doc(dateKey(thisMonday))
        .set(const WeekendWeek(id: 'x', talkTitle: 'A talk').toJson());

    await tester.pumpWidget(wrap(db, const WeekendScreen()));
    await tester.pumpAndSettle();

    // One pencil (the header's), not a second one inside the schedule.
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
  });

  group('weekPickerMondays', () {
    test('spans 4 weeks back and 20 forward', () {
      final mondays = weekPickerMondays(now: DateTime(2026, 4, 15));
      expect(mondays, hasLength(25));
      expect(mondays.first, DateTime(2026, 3, 16));
      expect(mondays.last, DateTime(2026, 8, 31));
    });

    test('adds the week on screen when it lies outside the span', () {
      final mondays = weekPickerMondays(
          now: DateTime(2026, 4, 15), include: DateTime(2027, 1, 6));
      expect(mondays, hasLength(26));
      expect(mondays.last, DateTime(2027, 1, 4));
    });

    test('does not duplicate a week already in the span', () {
      final mondays = weekPickerMondays(
          now: DateTime(2026, 4, 15), include: DateTime(2026, 4, 16));
      expect(mondays, hasLength(25));
    });
  });
}
