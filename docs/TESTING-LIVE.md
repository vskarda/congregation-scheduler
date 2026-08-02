# Live congregation tests

A small suite that runs against a **real** Firebase congregation project
instead of a fake one. Its purpose is verifying a new feature end to end —
real security rules, real document shapes, real streams — not broad
regression coverage. That stays in [`test/`](../test), which runs offline
against `fake_cloud_firestore` in seconds and needs no credentials.

Keep this suite small. Every test here costs a browser launch, network round
trips and Spark-plan quota.

## Credentials

Put the test congregation's details in `.credits/` (gitignored, never
committed):

| File | Content |
| --- | --- |
| `.credits/.congregation.json` | The Firebase **web** config JSON, exactly as pasted into the Setup wizard. The invite envelope (`{"firebaseConfig": {…}}`) is accepted too. |
| `.credits/.login` | `{"email": "…", "password": "…"}`, or two bare lines — email, then password. |

The account must be a **verified full admin** of that congregation; the first
test asserts this so a wrong or demoted account fails with a clear message
rather than a confusing permission error later.

Nothing is baked into the source. Rotating the credentials means editing
these two files.

## Running

Requires [chromedriver](https://developer.chrome.com/docs/chromedriver)
matching your installed Chrome major version, on `PATH`:

```powershell
scripts\live-test.ps1
```

The script prints the target project id and admin e-mail before starting —
check them, because the suite creates and deletes documents there.

To point it at another file:

```powershell
scripts\live-test.ps1 -Target integration_test\my_feature_live_test.dart
```

Without `.credits/`, every test **skips** rather than fails, so `flutter test`
and CI stay green for anyone without access.

## Why it can't run under `flutter test`

`cloud_firestore` needs platform channels, which the Dart VM test runner does
not provide. Live tests therefore run as `integration_test` on Chrome via
`flutter drive`. This project has no `windows/` target and no Android SDK
configured, so Chrome is the only option.

Since a web build has no filesystem, `.credits/` cannot be read from inside a
test. `scripts/live-test.ps1` reads the files and passes them as base64
`--dart-define`s — base64 so JSON braces, quotes and password punctuation
survive the shell unescaped.

## Writing a new live test

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final creds = LiveCredentials.fromEnvironment();
  if (creds == null) {
    testWidgets('my feature', (_) async {}, skip: true);
    return;
  }

  setUpAll(() => LiveHarness.signInAsAdmin(creds));
  tearDownAll(LiveHarness.cleanUp);

  testWidgets('my feature writes what the rules expect', (tester) async {
    final db = FirebaseFirestore.instance;
    final id = LiveHarness.testId('thing');
    final ref = LiveHarness.track(db.collection('things').doc(id));
    await ref.set({'name': 'x'});

    await tester.pumpWidget(await LiveHarness.wrap(const MyScreen()));
    await LiveHarness.waitFor(
        tester, () => find.text('x').evaluate().isNotEmpty);
  });
}
```

Three rules of thumb:

- **Namespace every write.** `LiveHarness.testId()` prefixes ids with
  `test_<runId>_`, and `LiveHarness.track()` registers the document so
  `cleanUp` removes it. `LiveHarness.sweepOrphans('collection')` clears
  leftovers from a run that crashed before cleanup.
- **Never use `pumpAndSettle`.** A live Firestore listener keeps the frame
  pipeline busy and never reaches a steady state, so it times out even when
  the screen is fine. Use `LiveHarness.waitFor`.
- **Don't override providers.** `LiveHarness.wrap` overrides only
  `sharedPreferencesProvider` (which throws unless supplied). Everything else
  resolves live — that is the point. A test that genuinely needs an override
  should build its own `ProviderScope`; Riverpod 3 does not export the
  `Override` type, so it cannot be a parameter here.

## What this suite does not do

It does not replace the [`rules-tests/`](../rules-tests) emulator suite, which
proves `firestore.rules` is *correct*. These tests exercise whatever rules are
currently **deployed** to the project, which is a different question — and one
worth asking after every rules change.

There is no CI job. The suite writes to a real project and needs secrets, so
it is run deliberately, by a person, against a disposable congregation.
