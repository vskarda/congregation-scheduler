---
name: verify
description: Build, launch and drive this Flutter app to verify a change end-to-end on this machine (no Android SDK — use the web build).
---

# Verifying changes in this app

No Android SDK on this machine; the reliable runtime surface is Flutter web.

## Build & serve

```powershell
& "$env:USERPROFILE\flutter\bin\flutter.bat" build web --release   # ~2.5 min
python -m http.server 8377 --directory build\web                   # run in background
```

The app boots to the `/setup` screen when no Firebase config is stored, so
first-run/setup flows are fully drivable without any Firebase project.
Flows behind login need a real Firebase backend — not drivable here.

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

## Flows worth driving

- First-run setup: `/setup` (config paste, QR button, setup guide link).
- Setup guide: `/setup/help` — copy-rules button must yield the exact
  `firestore.rules` content; screenshots must render; back button pops to `/setup`.
