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
}) =>
    LmmPart(
      id: id,
      section: section,
      type: type,
      title: title,
      description: description,
      durationMin: min,
      assignment: Assignment(publisherIds: [?assignee]),
      assistant: Assignment(publisherIds: [?assistant]),
    );

LmmWeek _existingWeek() => LmmWeek(
      id: '2026-11-02',
      weekLabel: 'NOVEMBER 2-8',
      songs: ['1', '44', '33'],
      source: 'epub',
      parts: [
        _part('e-ch', LmmSection.opening, LmmPartType.chairman,
            assignee: 'chairman'),
        _part('e-op', LmmSection.opening, LmmPartType.prayer,
            assignee: 'opening-prayer'),
        _part('e-t1', LmmSection.treasures, LmmPartType.treasures,
            title: 'Old talk', min: 10, assignee: 'talk'),
        _part('e-gem', LmmSection.treasures, LmmPartType.gems,
            title: 'Spiritual Gems', min: 10, assignee: 'gems'),
        _part('e-br', LmmSection.treasures, LmmPartType.bibleReading,
            title: 'Bible Reading', min: 4, assignee: 'reader'),
        _part('e-fm1', LmmSection.ministry, LmmPartType.fieldMinistry,
            title: 'Starting a Conversation',
            min: 3,
            assignee: 'demo1',
            assistant: 'helper1'),
        _part('e-fm2', LmmSection.ministry, LmmPartType.fieldMinistry,
            title: 'Following Up', min: 4, assignee: 'demo2'),
        _part('e-lv', LmmSection.living, LmmPartType.living,
            title: 'Local Needs', min: 15, assignee: 'elder'),
        _part('e-custom', LmmSection.living, LmmPartType.custom,
            title: 'Announcements', assignee: 'custom-guy'),
        _part('e-cbs', LmmSection.living, LmmPartType.cbsConductor,
            title: 'Congregation Bible Study', min: 30,
            assignee: 'conductor'),
        _part('e-cbsr', LmmSection.living, LmmPartType.cbsReader,
            assignee: 'cbs-reader'),
        _part('e-cp', LmmSection.closing, LmmPartType.prayer,
            assignee: 'closing-prayer'),
      ],
      attendants: const Assignment(publisherIds: ['attendant']),
      microphones: const Assignment(publisherIds: ['mic']),
      audioVideo: const Assignment(publisherIds: ['av']),
      customAssignments: const [
        CustomAssignment(
            label: 'Cleaning',
            assignment: Assignment(publisherIds: ['cleaner'])),
      ],
    );

LmmWeek _parsedWeek() => LmmWeek(
      id: '2026-11-02',
      weekLabel: 'NOVEMBER 2-8 | JEREMIAH 49-50',
      songs: ['2', '45', '34'],
      source: 'cdn',
      parts: [
        _part('p-ch', LmmSection.opening, LmmPartType.chairman),
        _part('p-op', LmmSection.opening, LmmPartType.prayer),
        _part('p-t1', LmmSection.treasures, LmmPartType.treasures,
            title: 'New talk', min: 10),
        _part('p-gem', LmmSection.treasures, LmmPartType.gems,
            title: 'Spiritual Gems', min: 10),
        _part('p-br', LmmSection.treasures, LmmPartType.bibleReading,
            title: 'Bible Reading',
            description: 'Jer 50:24-40 (th study 11)',
            min: 4),
        _part('p-fm1', LmmSection.ministry, LmmPartType.fieldMinistry,
            title: 'Starting a Conversation',
            description: 'HOUSE TO HOUSE.',
            min: 3),
        _part('p-fm2', LmmSection.ministry, LmmPartType.fieldMinistry,
            title: 'Following Up', min: 4),
        _part('p-fm3', LmmSection.ministry, LmmPartType.fieldMinistry,
            title: 'Making Disciples', min: 5),
        _part('p-lv', LmmSection.living, LmmPartType.living,
            title: 'Never Forget', description: 'Discussion.', min: 15),
        _part('p-cbs', LmmSection.living, LmmPartType.cbsConductor,
            title: 'Congregation Bible Study',
            description: 'wcg chap. 15',
            min: 30),
        _part('p-cbsr', LmmSection.living, LmmPartType.cbsReader),
        _part('p-cp', LmmSection.closing, LmmPartType.prayer),
      ],
    );

void main() {
  group('mergeParsedWeek', () {
    test('takes program content from the parsed week', () {
      final merged =
          mergeParsedWeek(existing: _existingWeek(), parsed: _parsedWeek());
      expect(merged.weekLabel, 'NOVEMBER 2-8 | JEREMIAH 49-50');
      expect(merged.songs, ['2', '45', '34']);
      expect(merged.source, 'cdn');

      final talk = merged.parts
          .firstWhere((p) => p.type == LmmPartType.treasures);
      expect(talk.title, 'New talk');
      final reading = merged.parts
          .firstWhere((p) => p.type == LmmPartType.bibleReading);
      expect(reading.description, 'Jer 50:24-40 (th study 11)');
    });

    test('keeps assignments, assistants and part ids by type and order', () {
      final merged =
          mergeParsedWeek(existing: _existingWeek(), parsed: _parsedWeek());

      LmmPart byType(LmmPartType t) =>
          merged.parts.firstWhere((p) => p.type == t);
      expect(byType(LmmPartType.chairman).assignment.publisherIds,
          ['chairman']);
      expect(byType(LmmPartType.chairman).id, 'e-ch');
      expect(byType(LmmPartType.gems).assignment.publisherIds, ['gems']);
      expect(byType(LmmPartType.bibleReading).assignment.publisherIds,
          ['reader']);
      expect(byType(LmmPartType.cbsConductor).assignment.publisherIds,
          ['conductor']);
      expect(byType(LmmPartType.cbsReader).assignment.publisherIds,
          ['cbs-reader']);

      final prayers =
          merged.parts.where((p) => p.type == LmmPartType.prayer).toList();
      expect(prayers.first.assignment.publisherIds, ['opening-prayer']);
      expect(prayers.last.assignment.publisherIds, ['closing-prayer']);

      final demos = merged.parts
          .where((p) => p.type == LmmPartType.fieldMinistry)
          .toList();
      expect(demos[0].assignment.publisherIds, ['demo1']);
      expect(demos[0].assistant.publisherIds, ['helper1']);
      expect(demos[0].id, 'e-fm1');
      expect(demos[1].assignment.publisherIds, ['demo2']);
      // Newly added third demo has no previous counterpart.
      expect(demos[2].assignment.isEmpty, isTrue);
      expect(demos[2].id, 'p-fm3');
    });

    test('keeps manually added custom parts in their section', () {
      final merged =
          mergeParsedWeek(existing: _existingWeek(), parsed: _parsedWeek());
      final custom = merged.parts
          .firstWhere((p) => p.type == LmmPartType.custom);
      expect(custom.id, 'e-custom');
      expect(custom.assignment.publisherIds, ['custom-guy']);
      expect(custom.section, LmmSection.living);
      // Inserted after the last living part, before the closing prayer.
      final customIndex = merged.parts.indexOf(custom);
      expect(merged.parts[customIndex - 1].section, LmmSection.living);
      expect(merged.parts.last.type, LmmPartType.prayer);
    });

    test('keeps support-role assignments', () {
      final merged =
          mergeParsedWeek(existing: _existingWeek(), parsed: _parsedWeek());
      expect(merged.attendants.publisherIds, ['attendant']);
      expect(merged.microphones.publisherIds, ['mic']);
      expect(merged.audioVideo.publisherIds, ['av']);
      expect(merged.customAssignments, hasLength(1));
      expect(merged.customAssignments.single.assignment.publisherIds,
          ['cleaner']);
    });
  });
}
