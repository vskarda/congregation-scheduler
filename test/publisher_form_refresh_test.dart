import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/publishers/publisher_form.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The document behind an open [PublisherForm] can change under it — the
/// connect-record merge runs from the card right above it on the admin's
/// publisher detail, and the publisher may edit their own profile from their
/// device. The form must follow those changes (it is keyed by publisher id,
/// which a connect does not change) without discarding what the user typed.
void main() {
  // English labels used by the finders below.
  const phoneLabel = 'Phone number';
  const addressLabel = 'Address';

  /// The account as registration leaves it: name and e-mail, nothing else.
  const account = Publisher(
      id: 'uid-1', firstName: 'Jana', lastName: 'Nováková', hasAccount: true);
  const accountPrivate = PublisherPrivate(email: 'jana@example.com');

  /// The same doc after the record was connected onto it.
  const merged = Publisher(
    id: 'uid-1',
    firstName: 'Jana',
    lastName: 'Nováková',
    gender: Gender.female,
    status: PublisherStatus.regularPioneer,
    appointment: Appointment.elder,
    verified: true,
    hasAccount: true,
  );
  const mergedPrivate = PublisherPrivate(
    email: 'jana@example.com',
    phone: '+420 777 000 000',
    address: 'Street 1',
    birthDate: '1990-03-15',
    baptismDate: '2000-05-01',
    appointment: Appointment.elder,
  );

  Future<void> pump(
    WidgetTester tester,
    Publisher publisher,
    PublisherPrivate private,
  ) async {
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: PublisherForm(
              // Same key the admin detail screen uses: the publisher id does
              // not change when a record is connected onto the account.
              key: ValueKey('${publisher.id}-admin-form'),
              publisher: publisher,
              private: private,
              showAppointment: true,
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  String textOf(String label) {
    final field = find.widgetWithText(TextField, label);
    return (find
            .descendant(of: field, matching: find.byType(EditableText))
            .evaluate()
            .single
            .widget as EditableText)
        .controller
        .text;
  }

  testWidgets('adopts data that arrived after the form was built',
      (tester) async {
    await pump(tester, account, accountPrivate);
    expect(textOf(phoneLabel), '');

    await pump(tester, merged, mergedPrivate);

    expect(textOf(phoneLabel), '+420 777 000 000');
    expect(textOf(addressLabel), 'Street 1');
    expect(find.text('1990-03-15'), findsOneWidget);
    expect(find.text('2000-05-01'), findsOneWidget);
    // Dropdowns are keyed by their value, so finding the key proves both that
    // the new value was adopted and that the field was rebuilt to show it
    // (a DropdownButtonFormField only seeds itself from initialValue once).
    expect(find.byKey(const ValueKey('gender-Gender.female')), findsOneWidget);
    expect(find.byKey(const ValueKey('status-PublisherStatus.regularPioneer')),
        findsOneWidget);
    expect(find.byKey(const ValueKey('appointment-Appointment.elder')),
        findsOneWidget);
  });

  testWidgets('keeps what the user has typed', (tester) async {
    await pump(tester, account, accountPrivate);
    await tester.enterText(
        find.widgetWithText(TextField, phoneLabel), 'being typed');

    await pump(tester, merged, mergedPrivate);

    // The edited field survives; untouched ones still follow the document.
    expect(textOf(phoneLabel), 'being typed');
    expect(textOf(addressLabel), 'Street 1');
  });
}
