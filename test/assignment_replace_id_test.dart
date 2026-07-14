import 'package:congregation_scheduler/core/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pure id-remap helpers used by the "connect record to account" migration:
/// every occurrence of the record's random doc id is rewritten to the
/// account's auth uid, deduplicating when both were assigned.
void main() {
  group('Assignment.replaceAssignee', () {
    test('rewrites the id keeping order', () {
      const a = Assignment(publisherIds: ['x', 'old', 'y']);
      expect(a.replaceAssignee('old', 'new').publisherIds,
          ['x', 'new', 'y']);
    });

    test('drops the duplicate when the target is already assigned', () {
      const a = Assignment(publisherIds: ['new', 'old']);
      expect(a.replaceAssignee('old', 'new').publisherIds, ['new']);
    });

    test('returns the same instance when the id is absent', () {
      const a = Assignment(publisherIds: ['x'], freeText: 'guest');
      expect(identical(a.replaceAssignee('old', 'new'), a), isTrue);
    });
  });

  group('LmmWeek.replaceAssignee', () {
    test('remaps all part slots, support roles and custom assignments', () {
      const week = LmmWeek(
        id: '2026-07-13',
        parts: [
          LmmPart(
            assignment: Assignment(publisherIds: ['old']),
            assistant: Assignment(publisherIds: ['helper']),
            assignment2: Assignment(publisherIds: ['old']),
            assistant2: Assignment(publisherIds: ['old', 'new']),
            assignment3: Assignment(publisherIds: ['old']),
            assistant3: Assignment(publisherIds: ['old']),
          ),
        ],
        attendants: Assignment(publisherIds: ['old', 'other']),
        microphones: Assignment(publisherIds: ['other']),
        audioVideo: Assignment(publisherIds: ['old']),
        customAssignments: [
          CustomAssignment(
              label: 'Cleaning',
              assignment: Assignment(publisherIds: ['old'])),
        ],
      );

      final updated = week.replaceAssignee('old', 'new');

      final part = updated.parts.single;
      expect(part.assignment.publisherIds, ['new']);
      expect(part.assistant.publisherIds, ['helper']);
      expect(part.assignment2.publisherIds, ['new']);
      // Deduplicated: 'new' was already assigned next to 'old'.
      expect(part.assistant2.publisherIds, ['new']);
      expect(part.assignment3.publisherIds, ['new']);
      expect(part.assistant3.publisherIds, ['new']);
      expect(updated.attendants.publisherIds, ['new', 'other']);
      expect(updated.microphones.publisherIds, ['other']);
      expect(updated.audioVideo.publisherIds, ['new']);
      expect(updated.customAssignments.single.assignment.publisherIds,
          ['new']);
      // The denormalized union is recomputed (sorted, no stale id).
      expect(updated.allAssigneeIds, ['helper', 'new', 'other']);
    });
  });

  group('WeekendWeek.replaceAssignee', () {
    test('remaps program, custom fields and support roles', () {
      const week = WeekendWeek(
        id: '2026-07-13',
        speaker: Assignment(publisherIds: ['old']),
        chairman: Assignment(publisherIds: ['old', 'new']),
        wtReader: Assignment(publisherIds: ['reader']),
        customFields: [
          CustomAssignment(
              label: 'WT Study',
              assignment: Assignment(publisherIds: ['old'])),
        ],
        attendants: Assignment(publisherIds: ['old']),
        customAssignments: [
          CustomAssignment(
              label: 'Cleaning',
              assignment: Assignment(publisherIds: ['old'])),
        ],
      );

      final updated = week.replaceAssignee('old', 'new');

      expect(updated.speaker.publisherIds, ['new']);
      expect(updated.chairman.publisherIds, ['new']);
      expect(updated.wtReader.publisherIds, ['reader']);
      expect(updated.customFields.single.assignment.publisherIds, ['new']);
      expect(updated.attendants.publisherIds, ['new']);
      expect(updated.customAssignments.single.assignment.publisherIds,
          ['new']);
      expect(updated.allAssigneeIds, ['new', 'reader']);
    });
  });

  test('PwSlot.replaceAssignee remaps and recomputes assignee ids', () {
    const slot = PwSlot(
      id: 'slot1',
      date: '2026-07-18',
      assignment: Assignment(publisherIds: ['old', 'other']),
      allAssigneeIds: ['old', 'other'],
    );
    final updated = slot.replaceAssignee('old', 'new');
    expect(updated.assignment.publisherIds, ['new', 'other']);
    expect(updated.allAssigneeIds, ['new', 'other']);
  });

  test('FsmMeeting.replaceAssignee remaps and recomputes assignee ids', () {
    const meeting = FsmMeeting(
      id: 'm1',
      date: '2026-07-18',
      assignment: Assignment(publisherIds: ['old']),
      allAssigneeIds: ['old'],
    );
    final updated = meeting.replaceAssignee('old', 'new');
    expect(updated.assignment.publisherIds, ['new']);
    expect(updated.allAssigneeIds, ['new']);
  });
}
