import 'package:congregation_scheduler/core/data/admin_mode_provider.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/core/utils/dates.dart';
import 'package:congregation_scheduler/core/widgets/service_year_picker_dialog.dart';
import 'package:congregation_scheduler/features/home/app_shell.dart';
import 'package:congregation_scheduler/features/territories/territories_screen.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '_harness.dart';

/// The two record-sheet exports as an admin meets them: the app-bar action on
/// each screen, and the service-year picker each one opens.
///
/// A picture only — what these screens *do* is asserted in
/// `test/record_export_actions_test.dart` (who is offered the action) and
/// `test/service_year_picker_test.dart` (what the dialog returns), which run
/// in CI. Not run by `flutter test`: the name ends in `.shot.dart`, not
/// `_test.dart`.
void main() {
  const publishers = <Publisher>[
    Publisher(id: 'p1', firstName: 'Jan', lastName: 'Novak', verified: true),
    Publisher(
        id: 'p2', firstName: 'Petra', lastName: 'Dvorakova', verified: true),
  ];

  Future<FakeFirebaseFirestore> seeded() async {
    final db = FakeFirebaseFirestore();
    for (final (i, name) in ['1', '2', '12A', 'Ostrov sever'].indexed) {
      await db.collection('territories').doc('t$i').set(
          Territory(name: name, notes: i == 0 ? 'Blocks 1-4' : '').toJson());
    }
    await db.collection('territory_assignments').doc('a0').set(
        const TerritoryAssignment(
                territoryId: 't0',
                publisherId: 'p1',
                assignedDate: '2025-09-03')
            .toJson());
    await db.collection('territory_assignments').doc('a1').set(
        const TerritoryAssignment(
                territoryId: 't2',
                publisherId: 'p2',
                assignedDate: '2025-10-05',
                returnedDate: '2025-12-01')
            .toJson());
    return db;
  }

  Future<Widget> shell(
      FakeFirebaseFirestore db, String location, Widget child) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        firestoreProvider.overrideWithValue(db),
        effectiveRolesProvider.overrideWithValue(const Roles(fullAdmin: true)),
        myRolesProvider.overrideWithValue(const Roles(fullAdmin: true)),
        allPublishersProvider.overrideWith((ref) => Stream.value(publishers)),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AppShell(location: location, child: child),
      ),
    );
  }

  testWidgets('territories screen, export action in the app bar',
      (tester) async {
    final app =
        await shell(await seeded(), '/territories', const TerritoriesScreen());
    await shoot(tester, app,
        name: 'record-territories', size: const Size(1100, 700));
  });

  testWidgets('attendance screen, export action in the app bar',
      (tester) async {
    final app = await shell(
        await seeded(), '/admin/attendance', const SizedBox.shrink());
    await shoot(tester, app,
        name: 'record-attendance', size: const Size(1100, 400));
  });

  testWidgets('the service year picker, as the attendance export opens it',
      (tester) async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final year = serviceYearOf(DateTime.now());
    await shoot(
      tester,
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showServiceYearPicker(
              context,
              title: l10n.attRecordDialogTitle,
              initialYear: year,
              subtitle: (picked) => l10n.attRecordCovers(
                  [picked - 1, picked].map(l10n.serviceYear).join(' · ')),
            ),
            child: const Text('open'),
          ),
        ),
      ),
      name: 'record-year-picker-closed',
      size: const Size(560, 320),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('out/record-year-picker.png'));
  });
}
