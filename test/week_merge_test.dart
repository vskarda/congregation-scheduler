import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/lmm_schedule/epub_import/week_merge.dart';
import 'package:flutter_test/flutter_test.dart';

LmmPart _part(
  String id,
  LmmSection section,
  LmmPartType type, {
  String title = '',
  String description = '',
  int? min,
  String? assignee,
  String? assistant,
  String? assignee2,
  String? assistant2,
  String? assignee3,
  String? assistant3,
  bool manual = false,
}) => LmmPart(
  id: id,
  section: section,
  type: type,
  title: title,
  description: description,
  durationMin: min,
  assignment: Assignment(publisherIds: [?assignee]),
  assistant: Assignment(publisherIds: [?assistant]),
  assignment2: Assignment(publisherIds: [?assignee2]),
  assistant2: Assignment(publisherIds: [?assistant2]),
  assignment3: Assignment(publisherIds: [?assignee3]),
  assistant3: Assignment(publisherIds: [?assistant3]),
  manual: manual,
);

LmmWeek _existingWeek() => LmmWeek(
  id: '2026-11-02',
  weekLabel: 'NOVEMBER 2-8',
  openingSongNo: 1,
  livingSongNo: 44,
  closingSongNo: 33,
  source: 'epub',
  parts: [
    _part(
      'e-ch',
      LmmSection.opening,
      LmmPartType.chairman,
      assignee: 'chairman',
    ),
    _part(
      'e-op',
      LmmSection.opening,
      LmmPartType.prayer,
      assignee: 'opening-prayer',
    ),
    _part(
      'e-t1',
      LmmSection.treasures,
      LmmPartType.treasures,
      title: 'Old talk',
      min: 10,
      assignee: 'talk',
    ),
    _part(
      'e-gem',
      LmmSection.treasures,
      LmmPartType.gems,
      title: 'Spiritual Gems',
      min: 10,
      assignee: 'gems',
    ),
    _part(
      'e-br',
      LmmSection.treasures,
      LmmPartType.bibleReading,
      title: 'Bible Reading',
      min: 4,
      assignee: 'reader',
      assignee2: 'reader-c2',
      assignee3: 'reader-c3',
    ),
    _part(
      'e-fm1',
      LmmSection.ministry,
      LmmPartType.fieldMinistry,
      title: 'Starting a Conversation',
      min: 3,
      assignee: 'demo1',
      assistant: 'helper1',
      assignee2: 'demo1-c2',
      assistant2: 'helper1-c2',
    ),
    _part(
      'e-fm2',
      LmmSection.ministry,
      LmmPartType.fieldMinistry,
      title: 'Following Up',
      min: 4,
      assignee: 'demo2',
    ),
    _part(
      'e-lv',
      LmmSection.living,
      LmmPartType.living,
      title: 'Local Needs',
      min: 15,
      assignee: 'elder',
    ),
    _part(
      'e-custom',
      LmmSection.living,
      LmmPartType.custom,
      title: 'Announcements',
      assignee: 'custom-guy',
    ),
    _part(
      'e-cbs',
      LmmSection.living,
      LmmPartType.cbsConductor,
      title: 'Congregation Bible Study',
      min: 30,
      assignee: 'conductor',
    ),
    _part(
      'e-cbsr',
      LmmSection.living,
      LmmPartType.cbsReader,
      assignee: 'cbs-reader',
    ),
    _part(
      'e-cp',
      LmmSection.closing,
      LmmPartType.prayer,
      assignee: 'closing-prayer',
    ),
  ],
  attendants: const Assignment(publisherIds: ['attendant']),
  microphones: const Assignment(publisherIds: ['mic']),
  audioVideo: const Assignment(publisherIds: ['av']),
  customAssignments: const [
    CustomAssignment(
      label: 'Cleaning',
      assignment: Assignment(publisherIds: ['cleaner']),
    ),
  ],
);

LmmWeek _parsedWeek() => LmmWeek(
  id: '2026-11-02',
  weekLabel: 'NOVEMBER 2-8 | JEREMIAH 49-50',
  openingSongNo: 2,
  livingSongNo: 45,
  closingSongNo: 34,
  source: 'cdn',
  parts: [
    _part('p-ch', LmmSection.opening, LmmPartType.chairman),
    _part('p-op', LmmSection.opening, LmmPartType.prayer),
    _part(
      'p-t1',
      LmmSection.treasures,
      LmmPartType.treasures,
      title: 'New talk',
      min: 10,
    ),
    _part(
      'p-gem',
      LmmSection.treasures,
      LmmPartType.gems,
      title: 'Spiritual Gems',
      min: 10,
    ),
    _part(
      'p-br',
      LmmSection.treasures,
      LmmPartType.bibleReading,
      title: 'Bible Reading',
      description: 'Jer 50:24-40 (th study 11)',
      min: 4,
    ),
    _part(
      'p-fm1',
      LmmSection.ministry,
      LmmPartType.fieldMinistry,
      title: 'Starting a Conversation',
      description: 'HOUSE TO HOUSE.',
      min: 3,
    ),
    _part(
      'p-fm2',
      LmmSection.ministry,
      LmmPartType.fieldMinistry,
      title: 'Following Up',
      min: 4,
    ),
    _part(
      'p-fm3',
      LmmSection.ministry,
      LmmPartType.fieldMinistry,
      title: 'Making Disciples',
      min: 5,
    ),
    _part(
      'p-lv',
      LmmSection.living,
      LmmPartType.living,
      title: 'Never Forget',
      description: 'Discussion.',
      min: 15,
    ),
    _part(
      'p-cbs',
      LmmSection.living,
      LmmPartType.cbsConductor,
      title: 'Congregation Bible Study',
      description: 'wcg chap. 15',
      min: 30,
    ),
    _part('p-cbsr', LmmSection.living, LmmPartType.cbsReader),
    _part('p-cp', LmmSection.closing, LmmPartType.prayer),
  ],
);

void main() {
  group('mergeParsedWeek', () {
    test('takes program content from the parsed week', () {
      final merged = mergeParsedWeek(
        existing: _existingWeek(),
        parsed: _parsedWeek(),
      );
      expect(merged.weekLabel, 'NOVEMBER 2-8 | JEREMIAH 49-50');
      expect(merged.openingSongNo, 2);
      expect(merged.livingSongNo, 45);
      expect(merged.closingSongNo, 34);
      expect(merged.source, 'cdn');

      final talk = merged.parts.firstWhere(
        (p) => p.type == LmmPartType.treasures,
      );
      expect(talk.title, 'New talk');
      final reading = merged.parts.firstWhere(
        (p) => p.type == LmmPartType.bibleReading,
      );
      expect(reading.description, 'Jer 50:24-40 (th study 11)');
    });

    test('keeps assignments, assistants and part ids by type and order', () {
      final merged = mergeParsedWeek(
        existing: _existingWeek(),
        parsed: _parsedWeek(),
      );

      LmmPart byType(LmmPartType t) =>
          merged.parts.firstWhere((p) => p.type == t);
      expect(byType(LmmPartType.chairman).assignment.publisherIds, [
        'chairman',
      ]);
      expect(byType(LmmPartType.chairman).id, 'e-ch');
      expect(byType(LmmPartType.gems).assignment.publisherIds, ['gems']);
      expect(byType(LmmPartType.bibleReading).assignment.publisherIds, [
        'reader',
      ]);
      expect(byType(LmmPartType.bibleReading).assignment2.publisherIds, [
        'reader-c2',
      ]);
      expect(byType(LmmPartType.bibleReading).assignment3.publisherIds, [
        'reader-c3',
      ]);
      expect(byType(LmmPartType.cbsConductor).assignment.publisherIds, [
        'conductor',
      ]);
      expect(byType(LmmPartType.cbsReader).assignment.publisherIds, [
        'cbs-reader',
      ]);

      final prayers = merged.parts
          .where((p) => p.type == LmmPartType.prayer)
          .toList();
      expect(prayers.first.assignment.publisherIds, ['opening-prayer']);
      expect(prayers.last.assignment.publisherIds, ['closing-prayer']);

      final demos = merged.parts
          .where((p) => p.type == LmmPartType.fieldMinistry)
          .toList();
      expect(demos[0].assignment.publisherIds, ['demo1']);
      expect(demos[0].assistant.publisherIds, ['helper1']);
      expect(demos[0].assignment2.publisherIds, ['demo1-c2']);
      expect(demos[0].assistant2.publisherIds, ['helper1-c2']);
      expect(demos[0].id, 'e-fm1');
      expect(demos[1].assignment.publisherIds, ['demo2']);
      expect(demos[1].assignment2.isEmpty, isTrue);
      // Newly added third demo has no previous counterpart.
      expect(demos[2].assignment.isEmpty, isTrue);
      expect(demos[2].assignment2.isEmpty, isTrue);
      expect(demos[2].assistant2.isEmpty, isTrue);
      expect(demos[2].id, 'p-fm3');
    });

    test('keeps manually added custom parts in their section', () {
      final merged = mergeParsedWeek(
        existing: _existingWeek(),
        parsed: _parsedWeek(),
      );
      final custom = merged.parts.firstWhere(
        (p) => p.type == LmmPartType.custom,
      );
      expect(custom.id, 'e-custom');
      expect(custom.assignment.publisherIds, ['custom-guy']);
      expect(custom.section, LmmSection.living);
      // Inserted after the last living part, before the closing prayer.
      final customIndex = merged.parts.indexOf(custom);
      expect(merged.parts[customIndex - 1].section, LmmSection.living);
      expect(merged.parts.last.type, LmmPartType.prayer);
    });

    test('a hand-written part keeps its own text, and its assignment', () {
      final existing = _existingWeek();
      final edited = [
        for (final p in existing.parts)
          if (p.id == 'e-t1')
            p.copyWith(
              title: 'Local needs — elders',
              description: 'Our own arrangement',
              durationMin: 12,
              manual: true,
            )
          else
            p,
      ];

      final merged = mergeParsedWeek(
        existing: existing.copyWith(parts: edited),
        parsed: _parsedWeek(),
      );

      final talk = merged.parts.firstWhere(
        (p) => p.type == LmmPartType.treasures,
      );
      expect(talk.title, 'Local needs — elders');
      expect(talk.description, 'Our own arrangement');
      expect(talk.durationMin, 12);
      expect(talk.manual, isTrue);
      // Protecting the text must not cost the part its assignee or its id.
      expect(talk.assignment.publisherIds, ['talk']);
      expect(talk.id, 'e-t1');

      // Everything untouched still refreshes from the workbook.
      final reading = merged.parts.firstWhere(
        (p) => p.type == LmmPartType.bibleReading,
      );
      expect(reading.description, 'Jer 50:24-40 (th study 11)');
      expect(reading.manual, isFalse);
    });

    test('a hand-written part survives when the parse has no counterpart', () {
      final existing = _existingWeek();
      // A fourth demonstration the workbook does not have: without the flag
      // it would be dropped, because only custom parts used to survive.
      final withExtra = existing.copyWith(parts: [
        ...existing.parts,
        _part(
          'e-fm-extra',
          LmmSection.ministry,
          LmmPartType.fieldMinistry,
          title: 'Our own demonstration',
          assignee: 'demo-extra',
          manual: true,
        ),
      ]);
      // A parse with a single ministry part, so the extra has no match.
      final parsed = _parsedWeek();
      final thin = parsed.copyWith(parts: [
        for (final p in parsed.parts)
          if (p.id != 'p-fm2' && p.id != 'p-fm3') p,
      ]);

      final merged = mergeParsedWeek(existing: withExtra, parsed: thin);
      final extra = merged.parts.firstWhere((p) => p.id == 'e-fm-extra');
      expect(extra.title, 'Our own demonstration');
      expect(extra.assignment.publisherIds, ['demo-extra']);
      expect(extra.section, LmmSection.ministry);
    });

    test('a hand-picked song slot is kept, the others refresh', () {
      final merged = mergeParsedWeek(
        existing: _existingWeek().copyWith(
          openingSongNo: 7,
          openingSongTitle: 'Our pick',
          openingSongManual: true,
        ),
        parsed: _parsedWeek(),
      );
      expect(merged.openingSongNo, 7);
      expect(merged.openingSongTitle, 'Our pick');
      expect(merged.openingSongManual, isTrue);
      // Untouched slots still take the workbook's numbers.
      expect(merged.livingSongNo, 45);
      expect(merged.closingSongNo, 34);
    });

    test('protectedByMerge counts what the import would leave alone', () {
      final existing = _existingWeek().copyWith(
        openingSongManual: true,
        livingSongManual: true,
        parts: [
          for (final p in _existingWeek().parts)
            if (p.id == 'e-t1') p.copyWith(manual: true) else p,
        ],
      );
      final kept = protectedByMerge(existing: existing, parsed: _parsedWeek());
      // The hand-written part, plus the custom part that always survives.
      expect(kept.parts, 1);
      expect(kept.songs, 2);
      expect(
        protectedByMerge(existing: _existingWeek(), parsed: _parsedWeek()),
        (parts: 0, songs: 0),
      );
    });

    test('the program a week runs is the week own, not the workbook one',
        () {
      final merged = mergeParsedWeek(
        existing: _existingWeek().copyWith(
          programKind: MeetingProgramKind.memorial,
          programNote: 'assembly',
          memorial: const MemorialProgram(
            chairman: Assignment(publisherIds: ['chair']),
          ),
        ),
        parsed: _parsedWeek(),
      );
      expect(merged.programKind, MeetingProgramKind.memorial);
      expect(merged.programNote, 'assembly');
      expect(merged.memorial?.chairman.publisherIds, ['chair']);
      // The imported program still lands underneath, ready for the switch back.
      expect(merged.weekLabel, 'NOVEMBER 2-8 | JEREMIAH 49-50');
      expect(merged.parts, isNotEmpty);
    });

    test('keeps support-role assignments', () {
      final merged = mergeParsedWeek(
        existing: _existingWeek(),
        parsed: _parsedWeek(),
      );
      expect(merged.attendants.publisherIds, ['attendant']);
      expect(merged.microphones.publisherIds, ['mic']);
      expect(merged.audioVideo.publisherIds, ['av']);
      expect(merged.customAssignments, hasLength(1));
      expect(merged.customAssignments.single.assignment.publisherIds, [
        'cleaner',
      ]);
    });
  });
}
