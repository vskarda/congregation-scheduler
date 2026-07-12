# App icon & store graphics — DONE

**Resolved.** The app no longer ships the stock Flutter template icon. A
real app icon (calendar + congregation + checkmark on a blue gradient,
avoiding any official Jehovah's Witnesses/Watch Tower emblems) has been
generated for every platform, plus the Play Store graphics.

## Source & regeneration

- **Master artwork**: [`../../icon.png`](../../icon.png) at the repo root
  (611×579, full-bleed blue gradient, opaque).
- **Generator script**: [`../../scripts/make_icons.py`](../../scripts/make_icons.py)
  crops the source to a centred square (no distortion — it only trims
  background), resizes to 1024×1024, and derives the adaptive-icon layers
  and the store graphics. Re-run with `python scripts/make_icons.py`
  (needs `pillow` + `numpy`).
- **Platform icons** are produced by `flutter_launcher_icons` — config in
  [`../../flutter_launcher_icons.yaml`](../../flutter_launcher_icons.yaml).
  Regenerate with `dart run flutter_launcher_icons`.

## What's already wired into the app (no console upload needed)

These are committed in the repo and ship with the build:

- **Android launcher icons** — `android/app/src/main/res/mipmap-*/ic_launcher.png`
  (legacy) plus an **adaptive icon** (`mipmap-anydpi-v26/ic_launcher.xml`
  with `drawable-*/ic_launcher_foreground.png` + `..._background.png`). The
  foreground glyph sits inside the adaptive safe zone, so it isn't clipped
  by round/squircle launcher masks.
- **iOS app icon** — every size under
  `ios/Runner/Assets.xcassets/AppIcon.appiconset/`, including the
  1024×1024 marketing icon (no alpha, no rounded corners — Apple masks its
  own). This 1024 icon *is* the App Store icon; Apple pulls it from the
  build, so there's nothing separate to upload.
- **Web/PWA icons** — `web/icons/` + `web/favicon.png`, and the theme /
  background colours in `web/manifest.json` (`#1063B4`).

## What you still upload by hand in the Play Console

Google Play does **not** read these from the build — upload them in the
Play Console listing:

| Deliverable | File | Play Console field |
|---|---|---|
| Store icon (512×512, 32-bit PNG w/ alpha) | [`play-store-icon-512.png`](play-store-icon-512.png) | Store listing → App icon |
| Feature graphic (1024×500) | [`play-feature-graphic-1024x500.png`](play-feature-graphic-1024x500.png) | Store listing → Graphics → Feature graphic |

Also kept here for reference / re-use:

- [`app-icon-1024.png`](app-icon-1024.png) — the 1024×1024 master (same
  artwork Apple already gets from the build).

## Notes

- The feature graphic uses the app's own **NotoSans** faces
  (`assets/fonts/`) and the tagline *"Self-hosted scheduling for your
  congregation"* — swap the wording in `make_icons.py` if you prefer the
  full 80-char short description.
- Screenshots are still outstanding — see
  [`../screenshots/SHOT-LIST.md`](../screenshots/SHOT-LIST.md).
