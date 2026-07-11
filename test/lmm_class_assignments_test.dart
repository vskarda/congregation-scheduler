import 'package:congregation_scheduler/core/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LmmPart auxiliary classes', () {
    test('json without class fields parses to empty class assignments', () {
      final part = LmmPart.fromJson({
        'id': 'p1',
        'section': 'treasures',
        'type': 'bibleReading',
        'title': 'Bible Reading',
        'assignment': {
          'publisherIds': ['reader'],
          'freeText': '',
        },
        'assistant': {'publisherIds': <String>[], 'freeText': ''},
      });
      expect(part.assignment.publisherIds, ['reader']);
      expect(part.assignment2.isEmpty, isTrue);
      expect(part.assistant2.isEmpty, isTrue);
      expect(part.assignment3.isEmpty, isTrue);
      expect(part.assistant3.isEmpty, isTrue);
    });

    test('json round-trip preserves class assignments', () {
      const part = LmmPart(
        id: 'p1',
        section: LmmSection.ministry,
        type: LmmPartType.fieldMinistry,
        assignment: Assignment(publisherIds: ['a1']),
        assistant: Assignment(publisherIds: ['h1']),
        assignment2: Assignment(publisherIds: ['a2']),
        assistant2: Assignment(publisherIds: ['h2']),
        assignment3: Assignment(publisherIds: ['a3']),
        assistant3: Assignment(publisherIds: ['h3']),
      );
      final restored = LmmPart.fromJson(part.toJson());
      expect(restored.assignment2.publisherIds, ['a2']);
      expect(restored.assistant2.publisherIds, ['h2']);
      expect(restored.assignment3.publisherIds, ['a3']);
      expect(restored.assistant3.publisherIds, ['h3']);
    });

    test('assignmentFor/assistantFor map class index to fields', () {
      const part = LmmPart(
        assignment: Assignment(publisherIds: ['a1']),
        assistant: Assignment(publisherIds: ['h1']),
        assignment2: Assignment(publisherIds: ['a2']),
        assistant2: Assignment(publisherIds: ['h2']),
        assignment3: Assignment(publisherIds: ['a3']),
        assistant3: Assignment(publisherIds: ['h3']),
      );
      expect(part.assignmentFor(1).publisherIds, ['a1']);
      expect(part.assignmentFor(2).publisherIds, ['a2']);
      expect(part.assignmentFor(3).publisherIds, ['a3']);
      expect(part.assistantFor(1).publisherIds, ['h1']);
      expect(part.assistantFor(2).publisherIds, ['h2']);
      expect(part.assistantFor(3).publisherIds, ['h3']);
    });

    test('withAssignmentFor/withAssistantFor write only the given class', () {
      const empty = LmmPart();
      const a = Assignment(publisherIds: ['x']);

      expect(empty.withAssignmentFor(1, a).assignment, a);
      expect(empty.withAssignmentFor(2, a).assignment2, a);
      expect(empty.withAssignmentFor(2, a).assignment.isEmpty, isTrue);
      expect(empty.withAssignmentFor(3, a).assignment3, a);
      expect(empty.withAssistantFor(1, a).assistant, a);
      expect(empty.withAssistantFor(2, a).assistant2, a);
      expect(empty.withAssistantFor(3, a).assistant3, a);
      expect(empty.withAssistantFor(3, a).assistant.isEmpty, isTrue);
    });

    test('isStudentPart is true only for bibleReading and fieldMinistry', () {
      for (final type in LmmPartType.values) {
        final part = LmmPart(type: type);
        expect(
          part.isStudentPart,
          type == LmmPartType.bibleReading || type == LmmPartType.fieldMinistry,
          reason: type.name,
        );
      }
    });

    test('withRecomputedAssignees includes class 2/3 assignees', () {
      const week = LmmWeek(
        id: '2026-07-06',
        parts: [
          LmmPart(
            id: 'p1',
            type: LmmPartType.bibleReading,
            assignment: Assignment(publisherIds: ['a1']),
            assignment2: Assignment(publisherIds: ['a2']),
            assignment3: Assignment(publisherIds: ['a3']),
          ),
          LmmPart(
            id: 'p2',
            type: LmmPartType.fieldMinistry,
            assistant: Assignment(publisherIds: ['h1']),
            assistant2: Assignment(publisherIds: ['h2']),
            assistant3: Assignment(publisherIds: ['a1']), // duplicate
          ),
        ],
      );
      final ids = week.withRecomputedAssignees().allAssigneeIds;
      expect(ids, ['a1', 'a2', 'a3', 'h1', 'h2']);
    });
  });

  group('CongregationMeta.lmmClassCount', () {
    test('defaults to 1 for pre-feature documents', () {
      expect(CongregationMeta.fromJson(const {}).lmmClassCount, 1);
    });

    test('round-trips through json', () {
      const meta = CongregationMeta(lmmClassCount: 3);
      expect(CongregationMeta.fromJson(meta.toJson()).lmmClassCount, 3);
    });
  });
}
