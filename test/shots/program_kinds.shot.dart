import 'package:congregation_scheduler/core/data/admin_mode_provider.dart';
import 'package:congregation_scheduler/core/data/congregation_repository.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/core/widgets/program_kind_actions.dart';
import 'package:congregation_scheduler/features/lmm_schedule/lmm_screen.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '_harness.dart';

/// The three programs a week's meeting can run, plus the part dialog's
/// "keep on import" switch — the screens behind login this change touches.
///
/// Not run by `flutter test`: the name ends in `.shot.dart`.
void main() {
  final weekId = dateKey(mondayOf(DateTime.now()));
  const meta = CongregationMeta(
    lmmWeekday: DateTime.tuesday,
    lmmTime: '18:30',
    name: 'Springfield',
  );
  const publishers = <Publisher>[
    Publisher(id: 'p1', firstName: 'Jan', lastName: 'Novak', verified: true),
    Publisher(id: 'p2', firstName: 'Eva', lastName: 'Novakova', verified: true),
  ];

  LmmWeek week({
    MeetingProgramKind kind = MeetingProgramKind.regular,
    String note = '',
    MemorialProgram? memorial,
  }) =>
      LmmWeek(
        id: weekId,
        weekLabel: 'AUGUST 24-30 | PSALM 45',
        programKind: kind,
        programNote: note,
        memorial: memorial,
        openingSongNo: 132,
        openingSongManual: true,
        livingSongNo: 5,
        closingSongNo: 88,
        parts: const [
          LmmPart(
            id: 'a',
            section: LmmSection.opening,
            type: LmmPartType.chairman,
            assignment: Assignment(publisherIds: ['p1']),
          ),
          LmmPart(
            id: 'b',
            section: LmmSection.treasures,
            type: LmmPartType.treasures,
            title: 'Our own local talk',
            description: 'Written by the elders, kept on import',
            durationMin: 10,
            manual: true,
            assignment: Assignment(publisherIds: ['p2']),
          ),
          LmmPart(
            id: 'c',
            section: LmmSection.treasures,
            type: LmmPartType.bibleReading,
            title: 'Bible reading',
            description: 'Ps 45:1-17 (th study 11)',
            durationMin: 4,
            assignment: Assignment(publisherIds: ['p1']),
          ),
        ],
        attendants: const Assignment(publisherIds: ['p1']),
        microphones: const Assignment(publisherIds: ['p2']),
        audioVideo: const Assignment(publisherIds: ['p1']),
      );

  Future<FakeFirebaseFirestore> seeded(LmmWeek w) async {
    final db = FakeFirebaseFirestore();
    await db.collection('lmm_weeks').doc(weekId).set(w.toJson());
    return db;
  }

  Widget scope(FakeFirebaseFirestore db,
          {Roles roles = const Roles(lmmSchedule: true)}) =>
      ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(db),
          effectiveRolesProvider.overrideWithValue(roles),
          myRolesProvider.overrideWithValue(roles),
          isVerifiedProvider.overrideWithValue(true),
          currentUidProvider.overrideWithValue('p1'),
          myPublisherProvider.overrideWith((ref) => Stream.value(publishers[0])),
          allPublishersProvider.overrideWith((ref) => Stream.value(publishers)),
          congregationMetaProvider.overrideWith((ref) => Stream.value(meta)),
        ],
        child: appFrame(const LmmScreen()),
      );

  testWidgets('regular week, with a pinned part and a pinned song',
      (tester) async {
    await shoot(tester, scope(await seeded(week())),
        name: 'program-regular', size: const Size(900, 900));
  });

  testWidgets('nothing planned, with the note publishers see', (tester) async {
    final db = await seeded(week(
      kind: MeetingProgramKind.nothingPlanned,
      note: 'Regional convention in Brno — no meeting this week.',
    ));
    await shoot(tester, scope(db),
        name: 'program-nothing-planned', size: const Size(900, 500));
  });

  testWidgets('the Memorial in place of the midweek program', (tester) async {
    final db = await seeded(week(
      kind: MeetingProgramKind.memorial,
      memorial: const MemorialProgram(
        openingSongNo: 18,
        openingSongTitle: 'Song of praise',
        closingSongNo: 32,
        closingSongTitle: 'Closing song',
        chairman: Assignment(publisherIds: ['p1']),
        speaker: Assignment(freeText: 'Visiting brother'),
        breadPrayer: Assignment(publisherIds: ['p2']),
        winePrayer: Assignment(publisherIds: ['p1']),
        customFields: [
          CustomAssignment(
            label: 'Emblems',
            assignment: Assignment(publisherIds: ['p2']),
          ),
        ],
      ),
    ));
    await shoot(tester, scope(db),
        name: 'program-memorial', size: const Size(900, 1000));
  });

  testWidgets('the program menu offers the other two kinds', (tester) async {
    await shoot(
      tester,
      scope(await seeded(week())),
      name: 'program-menu',
      size: const Size(900, 700),
      after: (tester) async {
        // Every part tile carries a menu too; the week's own is the
        // WeekMenuAction one.
        await tester.tap(find.byType(PopupMenuButton<WeekMenuAction>));
        await tester.pumpAndSettle();
      },
    );
  });

  testWidgets('the part dialog and its keep-on-import switch', (tester) async {
    await shoot(
      tester,
      scope(await seeded(week())),
      name: 'program-part-dialog',
      size: const Size(900, 900),
      after: (tester) async {
        // The overflow menu of the hand-written part. The week header's own
        // picker is a PopupMenuButton<String> too and comes first, so the
        // part menus start at 1 and the second part is at 2.
        await tester.tap(find.byType(PopupMenuButton<String>).at(2));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Edit part').last);
        await tester.pumpAndSettle();
      },
    );
  });
}
