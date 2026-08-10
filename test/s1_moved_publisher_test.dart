import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/s1_report/s1_calculator.dart';
import 'package:congregation_scheduler/features/s1_report/s1_screen.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Which report entries a month's S-1 counts once publishers move away.
///
/// The figures come from `reports/{month}/entries` and the month's attendance;
/// the roster is consulted for one thing only — dropping entries that a
/// recorded departure says belong to the congregation the person moved to.
/// So a closed month keeps its numbers unless a *date* places the publisher
/// elsewhere by then.
void main() {
  const month = '2026-06';

  /// p1: publisher, participated, 2 studies. p2: regular pioneer, 50 hours.
  /// Both report May and June.
  Future<FakeFirebaseFirestore> seed() async {
    final db = FakeFirebaseFirestore();
    for (final m in const ['2026-05', month]) {
      final entries = db.collection('reports').doc(m).collection('entries');
      await entries.doc('p1').set(MinistryReport(
            month: m,
            participated: true,
            bibleStudies: 2,
          ).toJson());
      await entries.doc('p2').set(MinistryReport(
            month: m,
            participated: true,
            hours: 50,
            bibleStudies: 3,
            statusAtMonth: PublisherStatus.regularPioneer,
          ).toJson());
    }

    await db.collection('attendance').doc('$month-02_lmm').set(
        const AttendanceEntry(
                date: '$month-02', meetingType: MeetingType.lmm, total: 50)
            .toJson());
    return db;
  }

  /// The roster is overridden rather than seeded: allPublishersProvider is
  /// gated on the signed-in user being verified, and there is no auth here.
  Future<S1Result> s1For(
    FakeFirebaseFirestore db,
    List<Publisher> publishers, {
    String on = month,
  }) {
    final container = ProviderContainer(
      overrides: [
        firestoreProvider.overrideWithValue(db),
        allPublishersProvider.overrideWith((ref) => Stream.value(publishers)),
      ],
    );
    addTearDown(container.dispose);
    return container.read(s1ResultProvider(on).future);
  }

  Publisher anna({bool moved = false, String? movedDate}) => Publisher(
        id: 'p1',
        firstName: 'Anna',
        lastName: 'Novak',
        verified: !moved,
        moved: moved,
        movedDate: movedDate,
      );

  const petr = Publisher(
    id: 'p2',
    firstName: 'Petr',
    lastName: 'Svoboda',
    status: PublisherStatus.regularPioneer,
    verified: true,
  );

  test('a publisher who moved during the month is off that month', () async {
    // Filed their report on the 10th, moved on the 15th: the month is the new
    // congregation's to report, so nothing of theirs counts here.
    final result = await s1For(await seed(),
        [anna(moved: true, movedDate: '$month-15'), petr]);

    expect(result.publishers.count, 0);
    expect(result.publishers.studies, 0);
    expect(result.activePublishers, 1); // p2 only
    // The pioneer beside them is untouched.
    expect(result.regularPioneers.count, 1);
    expect(result.regularPioneers.hours, 50);
    expect(result.avgMidweekAttendance, 50);
  });

  test('the months before the move still count in full', () async {
    final may = await s1For(
        await seed(), [anna(moved: true, movedDate: '$month-15')],
        on: '2026-05');

    expect(may.publishers.count, 1);
    expect(may.publishers.studies, 2);
    expect(may.activePublishers, 2); // p1 in May, p2 from both months
  });

  test('a move after the month leaves the month alone', () async {
    // The invariant that matters: recording a departure must not rewrite the
    // months the publisher was here for.
    final result = await s1For(await seed(),
        [anna(moved: true, movedDate: '2026-09-01'), petr]);

    expect(result.publishers.count, 1);
    expect(result.publishers.studies, 2);
    expect(result.activePublishers, 2);
  });

  test('the move month is dropped whatever day of it they left', () async {
    // Month-level cut: the report for a partial month goes to the
    // congregation they moved to, even when they were here for nearly all of
    // it (test/publisher_moved_test.dart pins the rule itself).
    final db = await seed();
    for (final day in const ['01', '30']) {
      final result =
          await s1For(db, [anna(moved: true, movedDate: '$month-$day'), petr]);
      expect(result.publishers.count, 0, reason: 'moved on the $day');
    }
  });

  test('a record archived without a date counts in no month', () async {
    // There is no month to draw the line at, so none of their reports can be
    // claimed. Only setting the date gives the earlier months back — which is
    // what the publisher detail screen says out loud.
    final db = await seed();
    final roster = [anna(moved: true), petr];
    expect((await s1For(db, roster)).publishers.count, 0);
    expect((await s1For(db, roster, on: '2026-05')).publishers.count, 0);
  });

  test('an entry whose publisher record is gone still counts', () async {
    // Nothing says the person moved away — they may just have been tidied off
    // the roster — so a closed month must not lose the number.
    final db = await seed();
    final before = await s1For(db, [anna(), petr]);
    final after = await s1For(db, [petr]);

    expect(after.publishers.count, before.publishers.count);
    expect(after.activePublishers, before.activePublishers);
  });

  test('a report without participation never reaches the S-1 groups', () async {
    // An empty report counts as reported on the Reports overview but is not a
    // publisher on the S-1 — the likeliest reason someone seems to vanish
    // from a month they were still here for.
    final db = await seed();
    await db
        .collection('reports')
        .doc(month)
        .collection('entries')
        .doc('p1')
        .set(const MinistryReport(month: month, comments: 'moved away')
            .toJson());

    final result = await s1For(db, [anna(), petr]);
    expect(result.publishers.count, 0);
    expect(result.activePublishers, 2); // still active from May
  });
}
