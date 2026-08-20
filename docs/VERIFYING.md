# Verifying a change locally

This is a Windows dev box with **no Android SDK** and **no Java on PATH**, so
several checks that would normally be a Gradle or `java` invocation need a bit
of setup. That setup lives in `scripts/`, not in anyone's notes.

Every script finds its own toolchain (`scripts/_tools.ps1`) and fails with a
message saying what to install. They are PowerShell 5.1 compatible.

| Command | Checks | Needs | Time |
| --- | --- | --- | --- |
| `flutter test` | Unit + widget tests | — | ~2 min |
| `flutter analyze` | Static analysis | — | ~2 min |
| `scripts\rules-test.ps1` | `firestore.rules` against the emulator | portable JRE under `~/java` | ~40 s |
| `scripts\verify-manifest.ps1` | No `READ_MEDIA_*` in the merged Android manifest | portable JRE, network on first run | ~10 s cached |
| `scripts\serve-web.ps1` | Builds + serves the web app to drive by hand or with Playwright | Python | ~2.5 min |
| `scripts\shot.ps1` | Renders a login-gated screen to a PNG | — | ~10 s |
| `scripts\live-test.ps1` | A feature against a **real** congregation | chromedriver, `.credits/` | varies |

## What CI does and does not cover

`.github/workflows/ci.yml` runs on every PR: analyze, `flutter test`, the
Firestore rules tests, and the Android manifest check (which runs the very
same `verify-manifest.ps1` under `pwsh`, so the local script cannot rot).

Two things CI cannot do for you:

- **`dart format` is red for pre-existing reasons.** `pubspec.yaml` pins
  `sdk: ^3.12.2`, so the formatter emits the new "tall" style while the
  codebase is written in the old short one — roughly 75 untouched files are
  flagged. Match the surrounding style in the code you touch; do **not**
  reformat the repo as a side effect of a feature. Fixing it properly is a
  dedicated commit.
- **The live suite has no CI job.** It writes to a real project and needs
  secrets, so it is run deliberately, by a person. See
  [TESTING-LIVE.md](TESTING-LIVE.md).

## Firestore rules — `scripts\rules-test.ps1`

```powershell
scripts\rules-test.ps1            # ~40 s, starts the Firestore emulator
scripts\rules-test.ps1 -Install   # first run, or after a dependency bump
```

The emulator is a Java process. There is no `java` on PATH here, only a
portable Temurin JRE unpacked under `~/java`; the script finds it by glob (the
directory name carries its version) and sets `JAVA_HOME` for the run only.

Nearly all of the runtime is emulator boot, not test execution, so there is
little point running a subset.

## Android manifest — `scripts\verify-manifest.ps1`

`open_filex` declares `READ_MEDIA_IMAGES`/`VIDEO`/`AUDIO` in its library
manifest. This app only ever hands it a file it wrote into its own cache
directory, so those are stripped with `tools:node="remove"` in
`android/app/src/main/AndroidManifest.xml` to satisfy Google Play's photo and
video permissions policy. **A dependency bump can quietly reintroduce them.**

Without an Android SDK there is no Gradle to do the merge, so the script drives
AGP's `manifest-merger` directly from eight cached jars.

Two things make the result trustworthy, and both matter:

- The merger version is **derived** from the AGP version in
  `android/settings.gradle.kts` (offset 23: AGP 9.0.1 → tools 32.0.1), and the
  library manifest is read from the **pub cache** at the version pinned in
  `pubspec.lock`. Neither is pinned in the script, so an upgrade is picked up
  instead of being silently tested against something stale.
- A **control run** repeats the merge with the removal directives stripped and
  requires the permissions to reappear. Without it, a harness that quietly
  stopped merging the library manifest would report a reassuring pass. Never
  trust a green run made with `-NoControl`.

Gotchas already encoded in the script, listed here because they cost time to
rediscover:

- `--property PACKAGE=` auto-injects the `applicationId` placeholder; passing
  it again via `--placeholder` throws *"Multiple entries with same key"*.
- `--remove-tools-declarations` is essential — without it the CLI leaves
  `tools:node="remove"` markers in the output and a successful removal looks
  like a failure.
- The plugin manifest declares no `<uses-sdk>`; the script injects one matching
  the app, or the merger infers legacy defaults and adds phantom
  `WRITE_EXTERNAL_STORAGE` / `READ_PHONE_STATE` that a real build never has.

## Seeing a change — `scripts\serve-web.ps1`

```powershell
scripts\serve-web.ps1                        # build + serve on :8377
scripts\serve-web.ps1 -SkipBuild -Background # reuse the build, detach
```

The app boots to `/setup` when no Firebase config is stored, so the whole
first-run flow is drivable **with no Firebase project at all**. Anything behind
login needs a real backend.

The Playwright recipe for driving it — Flutter renders to canvas, so you enable
the semantics DOM first, wheel-scroll instead of `scrollIntoViewIfNeeded`, and
click merged `ExpansionTile` nodes by coordinate — lives in
`.claude/skills/verify/SKILL.md`.

Plain static server, no SPA fallback: a deep link like `/setup/help` 404s.
Navigate from `/`, which is what the app's routing does anyway.

## Looking at a gated screen — `scripts\shot.ps1`

The web route stops at `/setup`, so it cannot show you an admin screen. A shot
pumps one with `fake_cloud_firestore` and provider overrides at a fixed size
and writes a PNG.

```powershell
scripts\shot.ps1                                          # the example
scripts\shot.ps1 -Target test\shots\my_screen.shot.dart -Open
```

Text renders as Ahem boxes, but column widths, alignment, row tints and icon
states are all legible — enough to catch a layout defect no `find.text`
assertion would notice. That is how the reports-table header-width bug was
found.

Write a new one by copying `test/shots/example.shot.dart`. Two conventions:

- **`*.shot.dart`, not `*_test.dart`.** `flutter test` only auto-discovers the
  latter, so shots never run in CI; the script passes the path explicitly.
- **The PNGs are gitignored.** They are a visual probe, not a regression
  golden — Flutter renders differently here than on Linux CI, so committing
  them would mean a permanently red check.

Build the `ProviderScope` at the call site rather than passing an overrides
list into the harness: Riverpod 3 does not export the `Override` type, so an
explicitly typed `List<Override>` will not compile.
