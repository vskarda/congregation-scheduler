# Congregation Scheduler

Self-hosted congregation management app (Flutter + Firebase) for Jehovah's
Witnesses congregations. Each congregation runs its own free Firebase
project — the app binary contains no backend credentials; the first admin
pastes/scans the Firebase web config on first launch and invites everyone
else with a QR code.

**Features**

- Information board (texts, PDF/image documents, links, visibility windows)
- Events + "my upcoming assignments" overview
- Life and Ministry Meeting schedule with `.epub` workbook import (en/cs),
  qualification-aware publisher picker (least-recently-assigned first),
  free-text overrides, attendants/microphones/audio-video/custom assignments
- Weekend meeting schedule (talk, speaker, chairman, Watchtower reader,
  custom fields)
- Public witnessing schedule with recurring slots
- Territories (assignment, return with notes, map links, statistics)
- Ministry reports (self-service + admin paper entry), publisher record by
  service year, S-1 monthly summary
- Meeting attendance (in-person/online, monthly averages)
- Publisher management: verification, granular per-section admin roles,
  assignment qualifications, emergency notes
- Czech, English, and Turkish UI

**Platforms:** Android, iOS, Web. **State:** Riverpod. **Backend:** Firebase
Auth + Firestore on the free Spark plan (no Cloud Functions, no Firebase
Storage — files are stored chunked in Firestore, max 10 MB).

## Getting started

- Congregation admins: follow [docs/SETUP-ADMIN.md](docs/SETUP-ADMIN.md)
  (create Firebase project → paste `firestore.rules` → connect the app).
- Developers: see [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

```sh
flutter pub get
flutter gen-l10n
dart run build_runner build   # freezed/json codegen
flutter run -d chrome         # or an Android/iOS device
```

## Tests

```powershell
flutter test                  # unit + widget tests
scripts\rules-test.ps1        # Firestore rules against the emulator
scripts\verify-manifest.ps1   # no broad media permissions in the merged manifest
scripts\serve-web.ps1         # build + serve the web app to click through
scripts\shot.ps1              # render a login-gated screen to a PNG
scripts\live-test.ps1         # against a real congregation (needs .credits/)
```

The scripts locate their own toolchain — this machine has no Android SDK and
no Java on PATH — and say what to install when they cannot. What each one
covers, and what CI does *not*, is in [docs/VERIFYING.md](docs/VERIFYING.md).

The live suite verifies a new feature against real rules and real data; see
[docs/TESTING-LIVE.md](docs/TESTING-LIVE.md). It skips without credentials.

## Releases

```sh
flutter build apk --release   # Android (requires Android SDK)
flutter build web --release   # deploy build/web to any static host
flutter build ipa --release   # iOS (requires macOS + Xcode)
```
