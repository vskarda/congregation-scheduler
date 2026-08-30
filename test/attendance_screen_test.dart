import 'package:congregation_scheduler/core/data/admin_mode_provider.dart';
import 'package:congregation_scheduler/core/data/congregation_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/features/attendance/attendance_history_card.dart';
import 'package:congregation_scheduler/features/attendance/attendance_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

/// The attendance admin screen (monthly averages + past-meetings history,
/// full attendance right only) and the history card's fill-in/edit/delete
/// dialog. Recording from the meeting views lives in
/// meeting_attendance_card_test.dart.
void main() {
  // Bypasses the auth gate; defaults are LMM Tuesday, weekend Sunday.
  overrides(FakeFirebaseFirestore db, {Roles roles = const Roles(fullAdmin: true)}) => [
        firestoreProvider.overrideWithValue(db),
        effectiveRolesProvider.overrideWithValue(roles),
        congregationMetaProvider
            .overrideWith((ref) => Stream.value(const CongregationMeta())),
      ];

  Widget wrapScreen(FakeFirebaseFirestore db,
          {Roles roles = const Roles(fullAdmin: true)}) =>
      ProviderScope(
        overrides: overrides(db, roles: roles),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // The app shell provides the Scaffold (snackbars) in production.
          home: const Scaffold(body: AttendanceScreen()),
        ),
      );

  Widget wrapCard(FakeFirebaseFirestore db, List<AttendanceEntry> entries,
          String fromDate) =>
      ProviderScope(
        overrides: overrides(db),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: AttendanceHistoryCard(
                  entries: entries, canEdit: true, fromDate: fromDate),
            ),
          ),
        ),
      );

  Finder field(String label) => find.widgetWithText(TextField, label);

  String textOf(Finder finder, WidgetTester tester) =>
      tester.widget<TextField>(finder).controller!.text;

  testWidgets('history lists unrecorded past meetings and fills them in',
      (tester) async {
    final db = FakeFirebaseFirestore();
    final prevMonth = addMonths(DateTime.now(), -1);
    final fromDate = '${monthKey(prevMonth)}-01';

    final tuesdays = <DateTime>[];
    var expectedMeetings = 0;
    for (var d = prevMonth;
        d.month == prevMonth.month;
        d = DateTime(d.year, d.month, d.day + 1)) {
      if (d.weekday == DateTime.tuesday) tuesdays.add(d);
      if (d.weekday == DateTime.tuesday || d.weekday == DateTime.sunday) {
        expectedMeetings++;
      }
    }
    final seededDate = dateKey(tuesdays.first);
    final tapDate = dateKey(tuesdays.last);
    final seededId = AttendanceEntry.docId(seededDate, MeetingType.lmm);
    // Total-only record: the legacy/paper-record shape.
    await db
        .collection('attendance')
        .doc(seededId)
        .set({'date': seededDate, 'meetingType': 'lmm', 'total': 50});
    final entries = [
      AttendanceEntry(
          id: seededId,
          date: seededDate,
          meetingType: MeetingType.lmm,
          total: 50),
    ];

    await tester.pumpWidget(wrapCard(db, entries, fromDate));
    await tester.pumpAndSettle();

    // Expand last month's group.
    final monthTitle =
        find.text(DateFormat.yMMMM('en').format(prevMonth));
    await tester.ensureVisible(monthTitle);
    await tester.tap(monthTitle);
    await tester.pumpAndSettle();

    expect(find.text('1/$expectedMeetings recorded'), findsOneWidget);
    expect(find.text('Not recorded'), findsWidgets);
    expect(find.text('Total: 50'), findsOneWidget);

    // Fill in an unrecorded meeting: two counts derive the total.
    final row = find.text('$tapDate  ·  Midweek meeting');
    await tester.ensureVisible(row);
    await tester.tap(row);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.enterText(field('In person'), '30');
    await tester.pump();
    await tester.enterText(field('Online'), '5');
    await tester.pump();
    expect(textOf(field('Total'), tester), '35');

    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);

    final saved = await db
        .collection('attendance')
        .doc(AttendanceEntry.docId(tapDate, MeetingType.lmm))
        .get();
    expect(saved.exists, isTrue);
    expect(saved.data(),
        {'date': tapDate, 'meetingType': 'lmm', 'inPerson': 30, 'online': 5, 'total': 35});
  });

  testWidgets('editing a recorded meeting prefills and delete removes it',
      (tester) async {
    final db = FakeFirebaseFirestore();
    final prevMonth = addMonths(DateTime.now(), -1);
    final fromDate = '${monthKey(prevMonth)}-01';
    var day = prevMonth;
    while (day.weekday != DateTime.tuesday) {
      day = DateTime(day.year, day.month, day.day + 1);
    }
    final date = dateKey(day);
    final id = AttendanceEntry.docId(date, MeetingType.lmm);
    await db
        .collection('attendance')
        .doc(id)
        .set({'date': date, 'meetingType': 'lmm', 'total': 50});
    final entries = [
      AttendanceEntry(
          id: id, date: date, meetingType: MeetingType.lmm, total: 50),
    ];

    await tester.pumpWidget(wrapCard(db, entries, fromDate));
    await tester.pumpAndSettle();

    final monthTitle =
        find.text(DateFormat.yMMMM('en').format(prevMonth));
    await tester.ensureVisible(monthTitle);
    await tester.tap(monthTitle);
    await tester.pumpAndSettle();

    final row = find.text('$date  ·  Midweek meeting');
    await tester.ensureVisible(row);
    await tester.tap(row);
    await tester.pumpAndSettle();

    expect(textOf(field('Total'), tester), '50');

    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect((await db.collection('attendance').doc(id).get()).exists, isFalse);
  });

  // What a week runs decides which meeting the history expects of it: an
  // assembly week is not chased for a count it will never have, and a
  // Memorial is expected under its own meeting type.
  testWidgets('a week with nothing planned expects no midweek meeting',
      (tester) async {
    final db = FakeFirebaseFirestore();
    final prevMonth = addMonths(DateTime.now(), -1);
    final fromDate = '${monthKey(prevMonth)}-01';
    var day = prevMonth;
    while (day.weekday != DateTime.tuesday) {
      day = DateTime(day.year, day.month, day.day + 1);
    }
    final date = dateKey(day);
    await db.collection('lmm_weeks').doc(weekIdOf(day)).set(
          LmmWeek(
            id: weekIdOf(day),
            programKind: MeetingProgramKind.nothingPlanned,
          ).toJson(),
        );

    await tester.pumpWidget(wrapCard(db, const [], fromDate));
    await tester.pumpAndSettle();

    final monthTitle = find.text(DateFormat.yMMMM('en').format(prevMonth));
    await tester.ensureVisible(monthTitle);
    await tester.tap(monthTitle);
    await tester.pumpAndSettle();

    expect(find.text('$date  ·  Midweek meeting'), findsNothing);
    // Every other Tuesday of the month is still expected.
    expect(find.textContaining('Midweek meeting'), findsWidgets);
  });

  testWidgets('a Memorial week is expected under its own meeting type',
      (tester) async {
    final db = FakeFirebaseFirestore();
    final prevMonth = addMonths(DateTime.now(), -1);
    final fromDate = '${monthKey(prevMonth)}-01';
    var day = prevMonth;
    while (day.weekday != DateTime.tuesday) {
      day = DateTime(day.year, day.month, day.day + 1);
    }
    final date = dateKey(day);
    await db.collection('lmm_weeks').doc(weekIdOf(day)).set(
          LmmWeek(
            id: weekIdOf(day),
            programKind: MeetingProgramKind.memorial,
          ).toJson(),
        );

    await tester.pumpWidget(wrapCard(db, const [], fromDate));
    await tester.pumpAndSettle();

    final monthTitle = find.text(DateFormat.yMMMM('en').format(prevMonth));
    await tester.ensureVisible(monthTitle);
    await tester.tap(monthTitle);
    await tester.pumpAndSettle();

    expect(find.text('$date  ·  Memorial'), findsOneWidget);
    expect(find.text('$date  ·  Midweek meeting'), findsNothing);
  });

  testWidgets('record-attendance-only role sees nothing on this screen',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await tester.pumpWidget(
        wrapScreen(db, roles: const Roles(recordAttendance: true)));
    await tester.pumpAndSettle();

    // The right records from the meeting views and gets no nav entry here;
    // a deep link must not hand it the averages or the history either.
    expect(find.text('Record attendance'), findsNothing);
    expect(find.text('Monthly averages'), findsNothing);
    expect(find.text('Past meetings'), findsNothing);
  });

  testWidgets('full attendance role sees the overview and history',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await tester
        .pumpWidget(wrapScreen(db, roles: const Roles(attendance: true)));
    await tester.pumpAndSettle();

    // The record form moved to the meeting views.
    expect(find.text('Record attendance'), findsNothing);
    expect(find.text('Monthly averages'), findsOneWidget);
    expect(find.text('Past meetings'), findsOneWidget);
  });

  test('the attendance nav entry is gated on the full right, not recording',
      () {
    expect(const Roles(recordAttendance: true).canRecordAttendance(), isTrue);
    expect(const Roles(recordAttendance: true).canEditAttendance(), isFalse);
    expect(const Roles(attendance: true).canEditAttendance(), isTrue);
  });
}
