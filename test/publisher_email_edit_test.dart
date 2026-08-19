import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/publishers/publisher_form.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The e-mail on the profile is contact data, not the sign-in identity, so it
/// is editable even for publishers who have an app account — that is how an
/// address nobody can reach any more gets corrected. Changing it here does
/// not touch how they sign in, and both copies of the form say so.
void main() {
  const uid = 'uid-1';
  const emailLabel = 'E-mail';
  const account = Publisher(
      id: uid, firstName: 'Jana', lastName: 'Nováková', hasAccount: true);
  const accountPrivate = PublisherPrivate(email: 'old@example.com');

  late FakeFirebaseFirestore db;

  setUp(() {
    db = FakeFirebaseFirestore();
  });

  Future<void> pump(WidgetTester tester, {required bool adminView}) async {
    // Tall surface: the whole form (Save button included) fits without
    // scrolling, so taps land where the finder says they will.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        publishersRepositoryProvider
            .overrideWithValue(PublishersRepository(db)),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: PublisherForm(
              key: const ValueKey('$uid-form'),
              publisher: account,
              private: accountPrivate,
              showAppointment: adminView,
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> tapSave(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
  }

  Future<Map<String, dynamic>?> savedPrivate() async => (await db
          .collection('publishers')
          .doc(uid)
          .collection('private')
          .doc('profile')
          .get())
      .data();

  testWidgets('an account holder can be given a new contact address',
      (tester) async {
    await pump(tester, adminView: true);

    // A disabled field would swallow this, which is what used to happen.
    await tester.enterText(
        find.widgetWithText(TextField, emailLabel), 'new@example.com');
    await tapSave(tester);

    expect((await savedPrivate())?['email'], 'new@example.com');
  });

  testWidgets('an address that is not one is rejected', (tester) async {
    await pump(tester, adminView: true);

    await tester.enterText(
        find.widgetWithText(TextField, emailLabel), 'not-an-address');
    await tapSave(tester);

    expect(find.text('That is not a valid e-mail address.'), findsOneWidget);
    expect(await savedPrivate(), isNull, reason: 'nothing was written');
  });

  testWidgets('each form says what the address is and is not', (tester) async {
    await pump(tester, adminView: false);
    expect(find.textContaining('Change sign-in e-mail'), findsOneWidget);

    await pump(tester, adminView: true);
    expect(
        find.textContaining('does not change the address this publisher'),
        findsOneWidget);
  });
}
