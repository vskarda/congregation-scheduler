---
name: verify
description: Build, launch and drive this Flutter app to verify a change end-to-end on this machine (no Android SDK — use the web build).
---

# Verifying changes in this app

No Android SDK on this machine; the reliable runtime surface is Flutter web.

The mechanics are scripted — see [docs/VERIFYING.md](../../../docs/VERIFYING.md)
for the full table. Use the scripts rather than reconstructing the commands:

```powershell
scripts\rules-test.ps1        # Firestore rules (finds the portable JRE)
scripts\verify-manifest.ps1   # merged Android manifest, no Android SDK needed
scripts\serve-web.ps1 -Background   # build + serve on :8377, prints the PID
scripts\shot.ps1 -Target test\shots\<x>.shot.dart   # look at a gated screen
```

What follows is only what a script cannot capture: how to drive the running
app.

## Choosing a route

- **Behind login?** The served web build only reaches `/setup` without a real
  Firebase project. To *look at* an admin screen, write a shot
  (`test/shots/example.shot.dart` is the template) — that renders it with
  fakes. To *exercise* one for real, use `scripts\live-test.ps1`.
- **First-run / setup flows?** Fully drivable on the web build with no Firebase
  project at all.

## Drive with Playwright

- `npm i playwright` in a scratch dir; the ms-playwright browser cache may
  not match the installed version, so launch with the system browser:
  `chromium.launch({ channel: 'chrome' })` (fallback `'msedge'`).
- Flutter renders to canvas. Enable the accessibility DOM first, then click
  by role/name:

  ```js
  await page.goto('http://localhost:8377/');
  await page.waitForTimeout(8000); // canvaskit boot
  await page.evaluate(() => document.querySelector('flt-semantics-placeholder')?.click());
  await page.getByRole('button', { name: 'Connect' }).click();
  ```

- Gotchas seen in practice:
  - Scrolling: semantic `scrollIntoViewIfNeeded` is unreliable; loop
    `page.mouse.wheel(0, 400)` until the target's `boundingBox()` is in view.
  - `ExpansionTile` (and some tappables) get merged into one `role=group`
    semantics node — click them by raw coordinates (`page.mouse.click`).
  - Clipboard asserts: grant `['clipboard-read', 'clipboard-write']` on the
    context; Windows clipboard converts LF to CRLF, normalize before comparing.
  - `url_launcher` links: catch the new tab via `context.waitForEvent('page')`.
  - Locale probe: `browser.newContext({ locale: 'cs-CZ' })` switches the app
    language (cs/tr supported).
  - Capture `page.on('pageerror')` — a clean run reports none.
  - No SPA fallback on the static server: deep links 404, navigate from `/`.

## Flows worth driving

- First-run setup: `/setup` (config paste, QR button, setup guide link).
- Setup guide: `/setup/help` — copy-rules button must yield the exact
  `firestore.rules` content; screenshots must render; back button pops to `/setup`.

## Writing tests, not just driving

Gotchas that bite in `flutter test`:

- Riverpod 3 exports neither `Override` nor `ProviderListenable`/`ProviderBase`
  — an overrides list in a helper must stay untyped, or build the
  `ProviderScope` at the call site.
- Screens shown inside `AppShell` have no `Scaffold`; wrap in
  `Scaffold(body: ...)` or `ScaffoldMessenger.showSnackBar` asserts.
- `congregationMetaProvider` gates on auth — override it with
  `Stream.value(const CongregationMeta())`.
- Real async (`rootBundle`, file I/O) does not progress under `tester.pump`;
  it needs `tester.runAsync`. A PDF export driven through a widget test will
  appear to hang at font loading for this reason, not because of a bug.
- Never `await ref.read(someStreamProvider.future)` in a widget callback — see
  `test/riverpod_future_contract_test.dart`.
