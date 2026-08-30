import 'package:congregation_scheduler/core/data/schedule_config_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

/// The three programs a week's meeting can run ([MeetingProgramKind]) and the
/// Memorial payload both meeting schedules can carry.
void main() {
  const memorial = MemorialProgram(
    songTitle: 'Song',
    songNo: 18,
    chairman: Assignment(publisherIds: ['chair']),
    speaker: Assignment(freeText: 'Visiting brother'),
    breadPrayer: Assignment(publisherIds: ['bread']),
    winePrayer: Assignment(publisherIds: ['wine']),
    customFields: [
      CustomAssignment(
        label: 'Emblems',
        assignment: Assignment(publisherIds: ['emblems']),
      ),
    ],
  );

  group('MemorialProgram', () {
    test('names every publisher it holds, free text aside', () {
      expect(
        memorial.publisherIds.toSet(),
        {'chair', 'bread', 'wine', 'emblems'},
      );
    });

    test('rewrites an id in every slot', () {
      final moved = memorial.replaceAssignee('chair', 'account-uid');
      expect(moved.chairman.publisherIds, ['account-uid']);
      expect(moved.breadPrayer.publisherIds, ['bread']);
      expect(moved.speaker.freeText, 'Visiting brother');

      final custom = memorial.replaceAssignee('emblems', 'account-uid');
      expect(custom.customFields.single.assignment.publisherIds,
          ['account-uid']);
    });
  });

  group('LmmWeek', () {
    test('a dormant Memorial still counts towards allAssigneeIds', () {
      // The connect-publisher migration finds weeks by this array, so a
      // Memorial switched off must not hide its names from it.
      final week = LmmWeek(
        id: '2026-04-06',
        parts: const [
          LmmPart(
            id: 'a',
            type: LmmPartType.chairman,
            assignment: Assignment(publisherIds: ['regular-chair']),
          ),
        ],
        memorial: memorial,
      ).withRecomputedAssignees();

      expect(week.programKind, MeetingProgramKind.regular);
      expect(week.allAssigneeIds, contains('chair'));
      expect(week.allAssigneeIds, contains('regular-chair'));
    });

    test('replaceAssignee reaches the Memorial too', () {
      final week = LmmWeek(id: '2026-04-06', memorial: memorial)
          .replaceAssignee('wine', 'account-uid');
      expect(week.memorial?.winePrayer.publisherIds, ['account-uid']);
      expect(week.allAssigneeIds, contains('account-uid'));
      expect(week.allAssigneeIds, isNot(contains('wine')));
    });

    test('memorialOrEmpty spares every caller a null check', () {
      expect(const LmmWeek(id: 'x').memorialOrEmpty, const MemorialProgram());
      expect(const LmmWeek(id: 'x').isRegular, isTrue);
      expect(
        const LmmWeek(id: 'x', programKind: MeetingProgramKind.nothingPlanned)
            .isRegular,
        isFalse,
      );
    });

    test('the program kind and note survive a JSON round trip', () {
      final week = LmmWeek(
        id: '2026-04-06',
        programKind: MeetingProgramKind.nothingPlanned,
        programNote: 'Regional convention',
        memorial: memorial,
      );
      final back = LmmWeek.fromJson(week.toJson()).copyWith(id: week.id);
      expect(back.programKind, MeetingProgramKind.nothingPlanned);
      expect(back.programNote, 'Regional convention');
      expect(back.memorial?.chairman.publisherIds, ['chair']);
    });

    test('a document written before program kinds existed reads as regular',
        () {
      final legacy = LmmWeek.fromJson(const {
        'weekLabel': 'JULY 6-12',
        'parts': <dynamic>[],
      });
      expect(legacy.programKind, MeetingProgramKind.regular);
      expect(legacy.programNote, '');
      expect(legacy.memorial, isNull);
      expect(legacy.openingSongManual, isFalse);
    });
  });

  group('WeekendWeek', () {
    test('carries the same Memorial as the midweek week', () {
      final week = WeekendWeek(
        id: '2026-04-06',
        programKind: MeetingProgramKind.memorial,
        speaker: const Assignment(publisherIds: ['dormant-speaker']),
        memorial: memorial,
      ).withRecomputedAssignees();

      expect(week.isRegular, isFalse);
      expect(week.allAssigneeIds, contains('chair'));
      // Dormant, but still findable — same contract as the midweek week.
      expect(week.allAssigneeIds, contains('dormant-speaker'));

      final back = WeekendWeek.fromJson(week.toJson());
      expect(back.programKind, MeetingProgramKind.memorial);
      expect(back.memorial?.speaker.freeText, 'Visiting brother');
    });

    test('replaceAssignee reaches the Memorial too', () {
      final week = WeekendWeek(id: '2026-04-06', memorial: memorial)
          .replaceAssignee('bread', 'account-uid');
      expect(week.memorial?.breadPrayer.publisherIds, ['account-uid']);
    });
  });

  group('canEditProgram', () {
    const lmmAdmin = Roles(lmmSchedule: true);
    const weekendAdmin = Roles(weekendSchedule: true);

    test('a regular week belongs to its own schedule role', () {
      expect(
        canEditProgram(lmmAdmin, ScheduleKind.lmm, MeetingProgramKind.regular),
        isTrue,
      );
      expect(
        canEditProgram(
            weekendAdmin, ScheduleKind.lmm, MeetingProgramKind.regular),
        isFalse,
      );
      expect(
        canEditProgram(lmmAdmin, ScheduleKind.lmm,
            MeetingProgramKind.nothingPlanned),
        isTrue,
      );
      expect(
        canEditProgram(weekendAdmin, ScheduleKind.lmm,
            MeetingProgramKind.nothingPlanned),
        isFalse,
      );
    });

    test('a Memorial week belongs to both meeting roles, in either schedule',
        () {
      for (final kind in [ScheduleKind.lmm, ScheduleKind.weekend]) {
        expect(canEditProgram(lmmAdmin, kind, MeetingProgramKind.memorial),
            isTrue);
        expect(canEditProgram(weekendAdmin, kind, MeetingProgramKind.memorial),
            isTrue);
      }
    });

    test('a Memorial grants nothing to a publisher with no meeting role', () {
      expect(
        canEditProgram(const Roles(events: true), ScheduleKind.lmm,
            MeetingProgramKind.memorial),
        isFalse,
      );
      expect(
        canEditProgram(const Roles(fullAdmin: true), ScheduleKind.weekend,
            MeetingProgramKind.memorial),
        isTrue,
      );
    });

    test('the other schedules are unaffected by the Memorial rule', () {
      expect(
        canEditProgram(const Roles(publicWitnessing: true), ScheduleKind.pw,
            MeetingProgramKind.memorial),
        isTrue,
      );
      expect(
        canEditProgram(
            lmmAdmin, ScheduleKind.pw, MeetingProgramKind.memorial),
        isFalse,
      );
    });
  });
}
