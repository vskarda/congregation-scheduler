import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/features/s1_report/s1_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The Freeze / Unfreeze control on the S-1 screen. The screen opens on last
/// month, which is over and therefore freezable.
void main() {
  final lastMonth = monthKey(addMonths(DateTime.now(), -1));

  const anna = Publisher(
      id: 'p1', firstName: 'Anna', lastName: 'Novak', verified: true);

  Future<void> report(FakeFirebaseFirestore db, String id, int studies) => db
      .collection('reports')
      .doc(lastMonth)
      .collection('entries')
      .doc(id)
      .set(MinistryReport(
              month: lastMonth, participated: true, bibleStudies: studies)
          .toJson());

  /// The S-1 is a tall page; a default 800x600 test viewport puts the freeze
  /// control below the fold, where taps do not land.
  setUp(() {
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher
        .implicitView!;
    view.physicalSize = const Size(900, 2000);
    view.devicePixelRatio = 1;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  });

  Widget wrap(FakeFirebaseFirestore db) => ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(db),
          allPublishersProvider.overrideWith((ref) => Stream.value([anna])),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: S1Screen()),
        ),
      );

  testWidgets('freezing keeps the figures a late report would have changed',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await report(db, 'p1', 2);
    await tester.pumpWidget(wrap(db));
    await tester.pumpAndSettle();

    expect(find.text('2'), findsWidgets, reason: 'one report, two studies');

    await tester.tap(find.text('Freeze figures'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Frozen on'), findsOneWidget);
    expect(find.text('Freeze figures'), findsNothing);
    expect((await db.collection('s1_records').doc(lastMonth).get()).exists,
        isTrue);

    // A second publisher reports late. The screen must keep showing what was
    // handed in.
    await report(db, 'p2', 5);
    await tester.pumpAndSettle();
    expect(find.text('7'), findsNothing, reason: 'frozen studies stay at 2');

    // Unfreezing asks first, then recomputes from what is there now.
    await tester.tap(find.text('Unfreeze'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Unfreeze'));
    await tester.pumpAndSettle();

    expect(find.text('Freeze figures'), findsOneWidget);
    expect(find.text('7'), findsOneWidget, reason: '2 + 5 studies, live again');
    expect((await db.collection('s1_records').doc(lastMonth).get()).exists,
        isFalse);
  });

  testWidgets('the current month offers no freeze button', (tester) async {
    final db = FakeFirebaseFirestore();
    await tester.pumpWidget(wrap(db));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();

    expect(find.text('Freeze figures'), findsNothing);
    expect(find.text('A month can be frozen once it has ended.'),
        findsOneWidget);
  });
}
