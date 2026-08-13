import 'package:congregation_scheduler/core/data/admin_mode_provider.dart';
import 'package:congregation_scheduler/core/data/congregation_repository.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/core/widgets/week_navigator.dart';
import 'package:congregation_scheduler/features/field_service_meetings/fsm_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

/// The meetings-for-field-service screen: its week picker is the plain
/// week-range one (no meeting to name, nothing to move), and a new meeting
/// starts in the week being looked at.
void main() {
  final thisMonday = mondayOf(DateTime.now());

  DateTime mondayAfter(int weeks) =>
      DateTime(thisMonday.year, thisMonday.month, thisMonday.day + 7 * weeks);

  Widget wrap(FakeFirebaseFirestore db) => ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(db),
          effectiveRolesProvider
              .overrideWithValue(const Roles(fieldServiceMeetings: true)),
          myRolesProvider
              .overrideWithValue(const Roles(fieldServiceMeetings: true)),
          isVerifiedProvider.overrideWithValue(true),
          allPublishersProvider.overrideWith((ref) => Stream.value(const [])),
          congregationMetaProvider
              .overrideWith((ref) => Stream.value(const CongregationMeta())),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const FsmScreen(),
        ),
      );

  testWidgets('picks weeks by range, with no meeting day to change',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await tester.pumpWidget(wrap(db));
    await tester.pumpAndSettle();

    expect(find.text(weekRangeLabel('en', thisMonday)), findsOneWidget);
    // No pencil here: these meetings have no congregation meeting day.
    expect(find.byIcon(Icons.edit_outlined), findsNothing);

    await tester.tap(find.byType(WeekPickerButton));
    await tester.pumpAndSettle();
    expect(find.text(weekRangeLabel('en', mondayAfter(-4))), findsOneWidget);
    expect(find.text(weekRangeLabel('en', mondayAfter(20))), findsOneWidget);
  });

  testWidgets('a new meeting starts in the week being looked at',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await tester.pumpWidget(wrap(db));
    await tester.pumpAndSettle();

    // Page two weeks ahead, then add a meeting.
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    final date = find.descendant(
        of: find.widgetWithText(ListTile, l10n.fsmDate),
        matching: find.byType(Text));
    expect(tester.widgetList<Text>(date).last.data,
        dateKey(mondayAfter(2)),
        reason: 'today would be the wrong week');

    // And it saves onto that day.
    await tester.tap(find.widgetWithText(FilledButton, l10n.commonSave));
    await tester.pumpAndSettle();

    final stored = await db.collection('fsm_meetings').get();
    expect(stored.docs.single.data()['date'], dateKey(mondayAfter(2)));
  });

  testWidgets('adding from the current week still starts today',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await tester.pumpWidget(wrap(db));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    final date = find.descendant(
        of: find.widgetWithText(ListTile, l10n.fsmDate),
        matching: find.byType(Text));
    expect(tester.widgetList<Text>(date).last.data,
        DateFormat('yyyy-MM-dd').format(DateTime.now()));
  });
}
