import 'package:congregation_scheduler/core/data/admin_mode_provider.dart';
import 'package:congregation_scheduler/core/data/congregation_repository.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/features/lmm_schedule/lmm_screen.dart';
import 'package:congregation_scheduler/features/weekend_schedule/weekend_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A week can run something other than its regular program: nothing at all
/// (an assembly week), or the Memorial. Both replace the program on screen,
/// neither destroys it, and each behaves the same in the midweek and the
/// weekend view — the Memorial can fall on either day.
void main() {
  final weekId = dateKey(mondayOf(DateTime.now()));
  // Both meetings land inside the week on screen whatever day the suite runs.
  const meta = CongregationMeta(
    lmmWeekday: DateTime.wednesday,
    lmmTime: '18:30',
    weekendWeekday: DateTime.sunday,
    weekendTime: '10:00',
  );
  const anna = Publisher(
    id: 'p1',
    firstName: 'Anna',
    lastName: 'Nováková',
    verified: true,
  );

  AppLocalizations l10n() => lookupAppLocalizations(const Locale('en'));

  /// Tall enough for a whole week to be built at once: an item scrolled out
  /// of a ListView does not exist, and "it is gone" would pass for the wrong
  /// reason.
  void tallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1000, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

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

  const memorial = MemorialProgram(
    songTitle: 'Song of praise',
    songNo: 18,
    chairman: Assignment(publisherIds: ['p1']),
    speaker: Assignment(freeText: 'Visiting brother'),
  );

  LmmWeek midweek({
    MeetingProgramKind kind = MeetingProgramKind.regular,
    String note = '',
    MemorialProgram? memorialProgram,
  }) =>
      LmmWeek(
        id: weekId,
        weekLabel: 'August 10-16',
        programKind: kind,
        programNote: note,
        memorial: memorialProgram,
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
        microphones: const Assignment(publisherIds: ['p1']),
      );

  WeekendWeek weekend({
    MeetingProgramKind kind = MeetingProgramKind.regular,
    String note = '',
    MemorialProgram? memorialProgram,
  }) =>
      WeekendWeek(
        id: weekId,
        talkTitle: 'A public talk',
        programKind: kind,
        programNote: note,
        memorial: memorialProgram,
        speaker: const Assignment(publisherIds: ['p1']),
        attendants: const Assignment(publisherIds: ['p1']),
        microphones: const Assignment(publisherIds: ['p1']),
      );

  Future<FakeFirebaseFirestore> seedMidweek(LmmWeek week) async {
    final db = FakeFirebaseFirestore();
    await db.collection('lmm_weeks').doc(weekId).set(week.toJson());
    return db;
  }

  Future<FakeFirebaseFirestore> seedWeekend(WeekendWeek week) async {
    final db = FakeFirebaseFirestore();
    await db.collection('weekend_weeks').doc(weekId).set(week.toJson());
    return db;
  }

  group('nothing planned', () {
    testWidgets('the midweek program gives way to the note', (tester) async {
      tallScreen(tester);
      final db = await seedMidweek(midweek(
        kind: MeetingProgramKind.nothingPlanned,
        note: 'Regional convention in Brno',
      ));
      await tester.pumpWidget(wrap(db, const Roles(), const LmmScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Regional convention in Brno'), findsOneWidget);
      // Twice: the week header names the program, the card repeats it.
      expect(find.text(l10n().programKindNothingPlanned), findsWidgets);
      // Nothing of the program, and nothing of the support roles.
      expect(find.text('Bible reading'), findsNothing);
      expect(find.text(l10n().supportAttendants), findsNothing);
      // No meeting, nothing to record.
      expect(find.text(l10n().attAdd), findsNothing);
    });

    testWidgets('a week with no note still says there is no meeting',
        (tester) async {
      tallScreen(tester);
      final db = await seedMidweek(
          midweek(kind: MeetingProgramKind.nothingPlanned));
      await tester.pumpWidget(wrap(db, const Roles(), const LmmScreen()));
      await tester.pumpAndSettle();

      expect(find.text(l10n().weekNothingPlannedHint), findsOneWidget);
    });

    testWidgets('the weekend talk gives way to the note too', (tester) async {
      tallScreen(tester);
      final db = await seedWeekend(weekend(
        kind: MeetingProgramKind.nothingPlanned,
        note: 'Circuit assembly',
      ));
      await tester.pumpWidget(wrap(db, const Roles(), const WeekendScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Circuit assembly'), findsOneWidget);
      expect(find.text('A public talk'), findsNothing);
      expect(find.text(l10n().attAdd), findsNothing);
    });

    testWidgets('switching back restores the program untouched',
        (tester) async {
      tallScreen(tester);
      final db = await seedMidweek(midweek(
        kind: MeetingProgramKind.nothingPlanned,
        note: 'Regional convention',
      ));
      await tester.pumpWidget(
          wrap(db, const Roles(lmmSchedule: true), const LmmScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n().weekRestoreProgram));
      await tester.pumpAndSettle();

      expect(find.text('Bible reading'), findsOneWidget);
      expect(find.text(anna.fullName), findsWidgets);
      final stored = await db.collection('lmm_weeks').doc(weekId).get();
      expect(stored.data()!['programKind'], 'regular');
      // The note is kept as well, ready for the next assembly week.
      expect(stored.data()!['programNote'], 'Regional convention');
    });
  });

  // The switch that decides whether a workbook re-import may overwrite a
  // part's text (see LmmPart.manual and mergeParsedWeek).
  group('keep on import', () {
    /// The dialog's own switch: "Show to publishers" is a SwitchListTile
    /// too, and it stays in the tree behind the dialog.
    bool switchValue(WidgetTester tester) => tester
        .widget<SwitchListTile>(find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(SwitchListTile),
        ))
        .value;

    /// Opens the edit dialog of the part tile at [tileIndex]. The week
    /// header's own picker is a PopupMenuButton<String> too and comes first
    /// in the tree, so the part menus start at 1.
    Future<void> openPartDialog(WidgetTester tester, int tileIndex) async {
      await tester.tap(find.byType(PopupMenuButton<String>).at(tileIndex + 1));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n().partEdit).last);
      await tester.pumpAndSettle();
    }

    LmmWeek weekWithParts() => LmmWeek(
          id: weekId,
          parts: const [
            LmmPart(
              id: 'a',
              section: LmmSection.treasures,
              type: LmmPartType.treasures,
              title: 'From the workbook',
            ),
            LmmPart(
              id: 'b',
              section: LmmSection.treasures,
              type: LmmPartType.gems,
              title: 'Our own wording',
              manual: true,
            ),
          ],
        );

    testWidgets('is off for a workbook part and on for a hand-written one',
        (tester) async {
      tallScreen(tester);
      final db = await seedMidweek(weekWithParts());
      await tester.pumpWidget(
          wrap(db, const Roles(lmmSchedule: true), const LmmScreen()));
      await tester.pumpAndSettle();

      await openPartDialog(tester, 0);
      expect(switchValue(tester), isFalse);
      await tester.tap(find.text(l10n().commonCancel));
      await tester.pumpAndSettle();

      await openPartDialog(tester, 1);
      expect(switchValue(tester), isTrue);
    });

    testWidgets('editing the title switches it on and the save keeps it',
        (tester) async {
      tallScreen(tester);
      final db = await seedMidweek(weekWithParts());
      await tester.pumpWidget(
          wrap(db, const Roles(lmmSchedule: true), const LmmScreen()));
      await tester.pumpAndSettle();

      await openPartDialog(tester, 0);
      await tester.enterText(
          find.widgetWithText(TextField, 'From the workbook'), 'Local needs');
      await tester.pumpAndSettle();
      expect(switchValue(tester), isTrue);

      await tester.tap(find.widgetWithText(FilledButton, l10n().commonSave));
      await tester.pumpAndSettle();

      final stored = await db.collection('lmm_weeks').doc(weekId).get();
      final parts = stored.data()!['parts'] as List<dynamic>;
      final edited = parts.firstWhere((p) => p['id'] == 'a');
      expect(edited['title'], 'Local needs');
      expect(edited['manual'], isTrue);
      // The part left alone keeps its own flag.
      expect(parts.firstWhere((p) => p['id'] == 'b')['manual'], isTrue);
    });

    testWidgets('a part added by hand starts protected', (tester) async {
      tallScreen(tester);
      final db = await seedMidweek(weekWithParts());
      await tester.pumpWidget(
          wrap(db, const Roles(lmmSchedule: true), const LmmScreen()));
      await tester.pumpAndSettle();

      // The add button of the Living as Christians section.
      await tester.tap(find.byTooltip(l10n().partAdd).at(3));
      await tester.pumpAndSettle();
      expect(switchValue(tester), isTrue);
    });
  });

  group('memorial', () {
    testWidgets('replaces the midweek program with its own slots',
        (tester) async {
      tallScreen(tester);
      final db = await seedMidweek(midweek(
        kind: MeetingProgramKind.memorial,
        memorialProgram: memorial,
      ));
      await tester.pumpWidget(wrap(db, const Roles(), const LmmScreen()));
      await tester.pumpAndSettle();

      expect(find.text(l10n().programKindMemorial), findsWidgets);
      expect(find.text(l10n().memorialBreadPrayer), findsOneWidget);
      expect(find.text(l10n().memorialWinePrayer), findsOneWidget);
      expect(find.text('Visiting brother'), findsOneWidget);
      expect(find.text('Bible reading'), findsNothing);
    });

    testWidgets('replaces the weekend program just the same', (tester) async {
      tallScreen(tester);
      final db = await seedWeekend(weekend(
        kind: MeetingProgramKind.memorial,
        memorialProgram: memorial,
      ));
      await tester.pumpWidget(wrap(db, const Roles(), const WeekendScreen()));
      await tester.pumpAndSettle();

      expect(find.text(l10n().memorialBreadPrayer), findsOneWidget);
      expect(find.text('A public talk'), findsNothing);
    });

    testWidgets('arranges attendants and audio/video, but no microphones',
        (tester) async {
      tallScreen(tester);
      final db = await seedMidweek(midweek(
        kind: MeetingProgramKind.memorial,
        memorialProgram: memorial,
      ));
      await tester.pumpWidget(
          wrap(db, const Roles(lmmSchedule: true), const LmmScreen()));
      await tester.pumpAndSettle();

      expect(find.text(l10n().supportAttendants), findsOneWidget);
      expect(find.text(l10n().supportAudioVideo), findsOneWidget);
      expect(find.text(l10n().supportMicrophones), findsNothing);
    });

    testWidgets('a weekend admin may plan one on the midweek week',
        (tester) async {
      tallScreen(tester);
      final db = await seedMidweek(midweek(
        kind: MeetingProgramKind.memorial,
        memorialProgram: memorial,
      ));
      await tester.pumpWidget(
          wrap(db, const Roles(weekendSchedule: true), const LmmScreen()));
      await tester.pumpAndSettle();

      // Editable: the program menu is offered...
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      // ...without the delete, which would take the midweek program with it.
      expect(find.text(l10n().weekDelete), findsNothing);
      expect(find.text(l10n().weekRestoreProgram), findsOneWidget);
    });

    testWidgets('a weekend admin cannot edit a regular midweek week',
        (tester) async {
      tallScreen(tester);
      final db = await seedMidweek(midweek());
      await tester.pumpWidget(
          wrap(db, const Roles(weekendSchedule: true), const LmmScreen()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.more_vert), findsNothing);
      expect(find.text(l10n().weekShowToPublishers), findsNothing);
    });

    testWidgets('records its attendance under its own meeting type',
        (tester) async {
      tallScreen(tester);
      final db = await seedMidweek(midweek(
        kind: MeetingProgramKind.memorial,
        memorialProgram: memorial,
      ));
      await tester.pumpWidget(
        wrap(
          db,
          const Roles(lmmSchedule: true, recordAttendance: true),
          const LmmScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n().attAdd), findsOneWidget);
      await tester.enterText(
          find.widgetWithText(TextField, l10n().attTotal), '142');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, l10n().commonSave));
      await tester.pumpAndSettle();

      final meetingDate = dateKey(
          meetingDateOf(weekId, meta.lmmWeekday)!);
      final memorialDoc = await db
          .collection('attendance')
          .doc('${meetingDate}_memorial')
          .get();
      expect(memorialDoc.exists, isTrue);
      expect(memorialDoc.data()!['total'], 142);
      // Never filed against the midweek meeting, which did not happen.
      final lmmDoc =
          await db.collection('attendance').doc('${meetingDate}_lmm').get();
      expect(lmmDoc.exists, isFalse);
    });
  });
}
