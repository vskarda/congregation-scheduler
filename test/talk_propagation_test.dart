import 'package:congregation_scheduler/core/data/weekend_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WeekendRepository.updateTalkTitles', () {
    late FakeFirebaseFirestore db;
    late WeekendRepository repo;

    Future<void> seedWeek(String id, {int? talkNo, String title = ''}) =>
        db.collection('weekend_weeks').doc(id).set(WeekendWeek(
              talkTitle: title,
              talkNo: talkNo,
            ).toJson());

    Future<String?> titleOf(String id) async =>
        (await db.collection('weekend_weeks').doc(id).get())
            .data()?['talkTitle'] as String?;

    setUp(() async {
      db = FakeFirebaseFirestore();
      repo = WeekendRepository(db);
      await seedWeek('2026-06-01', talkNo: 5, title: 'Old Five');
      await seedWeek('2026-07-06', talkNo: 5, title: 'Old Five');
      await seedWeek('2026-07-13', talkNo: 5, title: 'Old Five');
      await seedWeek('2026-07-20', talkNo: 7, title: 'Same Seven');
      await seedWeek('2026-07-27', title: 'Free text talk');
    });

    test('rewrites only current-and-future weeks with changed titles',
        () async {
      final updated = await repo.updateTalkTitles(
        {5: 'New Five', 7: 'Same Seven'},
        fromWeekId: '2026-07-06',
      );

      expect(updated, 2);
      // Past week keeps the wording that was delivered.
      expect(await titleOf('2026-06-01'), 'Old Five');
      // Current and future weeks referencing talk 5 get the new wording.
      expect(await titleOf('2026-07-06'), 'New Five');
      expect(await titleOf('2026-07-13'), 'New Five');
      // Unchanged title is not rewritten; free text is untouched.
      expect(await titleOf('2026-07-20'), 'Same Seven');
      expect(await titleOf('2026-07-27'), 'Free text talk');
    });

    test('numbers missing from the map leave weeks untouched', () async {
      final updated =
          await repo.updateTalkTitles({99: 'Unused'}, fromWeekId: '2026-01-01');
      expect(updated, 0);
      expect(await titleOf('2026-07-06'), 'Old Five');
    });

    test('talkNo survives a round trip and stays absent for free text',
        () async {
      final withNo = await db.collection('weekend_weeks').doc('2026-07-06').get();
      expect(WeekendWeek.fromJson(withNo.data()!).talkNo, 5);
      final freeText =
          await db.collection('weekend_weeks').doc('2026-07-27').get();
      expect(freeText.data()!.containsKey('talkNo'), isFalse);
      expect(WeekendWeek.fromJson(freeText.data()!).talkNo, isNull);
    });
  });
}
