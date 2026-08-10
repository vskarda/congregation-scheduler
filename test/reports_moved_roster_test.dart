import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/features/reports/admin_reports_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Which months a publisher who moved away is still expected to report for.
/// The screen opens on last month, so the dates here are relative to it.
void main() {
  final lastMonth = addMonths(DateTime.now(), -1);
  final monthBefore = addMonths(DateTime.now(), -2);

  Widget wrap(FakeFirebaseFirestore db, List<Publisher> publishers,
          {List<FormerPublisher> former = const []}) =>
      ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(db),
          allPublishersProvider.overrideWith((ref) => Stream.value(publishers)),
          formerPublishersProvider.overrideWith((ref) => Stream.value(former)),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: AdminReportsScreen()),
        ),
      );

  Publisher person(String name, {String? movedDate}) => Publisher(
        id: name,
        firstName: name,
        lastName: name,
        moved: movedDate != null,
        movedDate: movedDate,
      );

  testWidgets('a publisher who left drops out of the months after the move',
      (tester) async {
    // Left on the 10th of last month: last month already belongs to the new
    // congregation, the month before it does not.
    final left = person('Leaver', movedDate: '${monthKey(lastMonth)}-10');
    await tester.pumpWidget(wrap(FakeFirebaseFirestore(), [
      person('Stayer'),
      left,
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Stayer Stayer'), findsOneWidget);
    expect(find.text('Leaver Leaver'), findsNothing);
    expect(find.text('Reported: 0 / 1'), findsOneWidget);

    // Step back one month — they were still here, so the report is expected
    // (and enterable) exactly as before.
    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    expect(find.text('Leaver Leaver'), findsOneWidget);
    expect(find.text('Reported: 0 / 2'), findsOneWidget);
  });

  testWidgets('a move still ahead changes nothing yet', (tester) async {
    final moving = person('Mover',
        movedDate: dateKey(DateTime.now().add(const Duration(days: 40))));
    await tester.pumpWidget(wrap(FakeFirebaseFirestore(), [moving]));
    await tester.pumpAndSettle();

    expect(find.text('Mover Mover'), findsOneWidget);
    expect(find.text('Reported: 0 / 1'), findsOneWidget);
  });

  testWidgets('a report for a month they had left is shown, not counted',
      (tester) async {
    // Reports are the record of what happened: one entered for a month the
    // roster no longer claims stays visible and correctable, but it counts
    // for nobody — the S-1 drops it, and this list has to say so or the two
    // screens contradict each other.
    final db = FakeFirebaseFirestore();
    await db
        .collection('reports')
        .doc(monthKey(lastMonth))
        .collection('entries')
        .doc('Leaver')
        .set(MinistryReport(month: monthKey(lastMonth), participated: true)
            .toJson());

    await tester.pumpWidget(wrap(db, [
      person('Stayer'),
      person('Leaver', movedDate: '${monthKey(monthBefore)}-05'),
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Leaver Leaver'), findsOneWidget);
    expect(find.textContaining('Moved — not counted'), findsOneWidget);
    // Only the one person who still owes a report is in the tally.
    expect(find.text('Reported: 0 / 1'), findsOneWidget);
  });

  testWidgets('an entry whose record was deleted is shown as a former member',
      (tester) async {
    // It still counts on the S-1 (nothing says the person left), so it has to
    // be visible here — and openable, or a wrong figure could never be put
    // right once the record is gone.
    final db = FakeFirebaseFirestore();
    await db
        .collection('reports')
        .doc(monthKey(lastMonth))
        .collection('entries')
        .doc('deleted-id')
        .set(MinistryReport(month: monthKey(lastMonth), participated: true)
            .toJson());

    await tester.pumpWidget(wrap(db, [person('Stayer')]));
    await tester.pumpAndSettle();

    expect(find.text('Former member'), findsOneWidget);
    expect(find.textContaining('Moved — not counted'), findsNothing);
    // Nobody is waiting for a report from them, so the tally is unchanged.
    expect(find.text('Reported: 0 / 1'), findsOneWidget);

    await tester.tap(find.text('Former member'));
    await tester.pumpAndSettle();
    expect(find.text('Enter report — Former member'), findsOneWidget);
  });

  testWidgets('a deleted publisher who had moved is marked as not counted',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await db
        .collection('reports')
        .doc(monthKey(lastMonth))
        .collection('entries')
        .doc('deleted-id')
        .set(MinistryReport(month: monthKey(lastMonth), participated: true)
            .toJson());

    await tester.pumpWidget(wrap(
      db,
      [person('Stayer')],
      former: [
        FormerPublisher(
            id: 'deleted-id', movedDate: '${monthKey(monthBefore)}-05'),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('Former member'), findsOneWidget);
    expect(find.textContaining('Moved — not counted'), findsOneWidget);
  });
}
