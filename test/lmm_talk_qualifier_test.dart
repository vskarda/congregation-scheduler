import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/lmm_schedule/lmm_screen.dart';
import 'package:flutter_test/flutter_test.dart';

/// The "Talk" student assignment (EN "Talk", CS "Proslov", TR "Konuşma") is
/// delivered by a brother, so the qualified list is restricted to males with
/// the student-assignments qualification. Detection is by workbook title.
void main() {
  LmmPart ministry(String title) => LmmPart(
        id: title,
        section: LmmSection.ministry,
        type: LmmPartType.fieldMinistry,
        title: title,
      );

  Publisher pub({required Gender gender, required bool fieldMinistry}) =>
      Publisher(
        id: 'p',
        gender: gender,
        qualifications: Qualifications(fieldMinistry: fieldMinistry),
      );

  group('isStudentTalk', () {
    test('matches the Talk title in every supported language', () {
      expect(isStudentTalk(ministry('Talk')), isTrue);
      expect(isStudentTalk(ministry('Proslov')), isTrue);
      expect(isStudentTalk(ministry('Konuşma')), isTrue);
      // Case-insensitive and tolerant of a trailing reference.
      expect(isStudentTalk(ministry('TALK (lmd lesson 4)')), isTrue);
    });

    test('does not match other ministry assignments', () {
      expect(isStudentTalk(ministry('Starting a Conversation')), isFalse);
      expect(isStudentTalk(ministry('Making Disciples')), isFalse);
    });

    test('never matches outside the ministry section', () {
      // A "Public talk" belongs to the weekend, not the ministry section.
      expect(
        isStudentTalk(const LmmPart(
          section: LmmSection.living,
          type: LmmPartType.custom,
          title: 'Public talk',
        )),
        isFalse,
      );
    });
  });

  group('lmmStudentQualifier', () {
    test('a Talk requires a male with the student-assignments qualification',
        () {
      final qualifies = lmmStudentQualifier(ministry('Talk'));
      expect(qualifies(pub(gender: Gender.male, fieldMinistry: true)), isTrue);
      expect(
          qualifies(pub(gender: Gender.female, fieldMinistry: true)), isFalse);
      expect(qualifies(pub(gender: Gender.male, fieldMinistry: false)), isFalse);
    });

    test('a non-Talk ministry part keeps the student-assignments rule only',
        () {
      final qualifies = lmmStudentQualifier(ministry('Return Visit'));
      expect(qualifies(pub(gender: Gender.female, fieldMinistry: true)), isTrue);
      expect(qualifies(pub(gender: Gender.male, fieldMinistry: false)), isFalse);
    });
  });
}
