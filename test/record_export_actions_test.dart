import 'package:congregation_scheduler/core/data/admin_mode_provider.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/attendance/attendance_record_pdf_button.dart';
import 'package:congregation_scheduler/features/home/app_shell.dart';
import 'package:congregation_scheduler/features/territories/territory_record_pdf_button.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Who gets offered the two record-sheet exports. Both are admin printouts —
/// they sit in the app bar of one screen each and nowhere else.
void main() {
  Future<void> pumpShell(
    WidgetTester tester, {
    required String location,
    required Roles roles,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        firestoreProvider.overrideWithValue(FakeFirebaseFirestore()),
        effectiveRolesProvider.overrideWithValue(roles),
        myRolesProvider.overrideWithValue(roles),
        allPublishersProvider.overrideWith((ref) => Stream.value(const [])),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AppShell(location: location, child: const SizedBox.shrink()),
      ),
    ));
    await tester.pumpAndSettle();
  }

  group('territory record', () {
    testWidgets('offered to a territory admin on the territories screen',
        (tester) async {
      await pumpShell(tester,
          location: '/territories', roles: const Roles(territories: true));

      expect(find.byType(TerritoryRecordPdfButton), findsOneWidget);
    });

    testWidgets('not offered without the territories right', (tester) async {
      await pumpShell(tester,
          location: '/territories', roles: const Roles(attendance: true));

      expect(find.byType(TerritoryRecordPdfButton), findsNothing);
    });

    testWidgets('not offered on another screen', (tester) async {
      await pumpShell(tester,
          location: '/lmm', roles: const Roles(fullAdmin: true));

      expect(find.byType(TerritoryRecordPdfButton), findsNothing);
    });
  });

  group('attendance record', () {
    testWidgets('offered to an attendance admin on the attendance screen',
        (tester) async {
      await pumpShell(tester,
          location: '/admin/attendance', roles: const Roles(attendance: true));

      expect(find.byType(AttendanceRecordPdfButton), findsOneWidget);
    });

    testWidgets('not offered to someone who may only record the counts',
        (tester) async {
      // Record-only rights never reach /admin/attendance; the sheet prints the
      // averages and the history that screen exists to show.
      await pumpShell(tester,
          location: '/admin/attendance',
          roles: const Roles(recordAttendance: true));

      expect(find.byType(AttendanceRecordPdfButton), findsNothing);
    });

    testWidgets('not offered on another screen', (tester) async {
      await pumpShell(tester,
          location: '/weekend', roles: const Roles(fullAdmin: true));

      expect(find.byType(AttendanceRecordPdfButton), findsNothing);
    });
  });

  testWidgets('both hidden while the admin UI is switched off', (tester) async {
    // "View as publisher" empties effectiveRoles; the actions must go with it.
    await pumpShell(tester, location: '/territories', roles: const Roles());

    expect(find.byType(TerritoryRecordPdfButton), findsNothing);
    expect(find.byType(AttendanceRecordPdfButton), findsNothing);
  });
}
