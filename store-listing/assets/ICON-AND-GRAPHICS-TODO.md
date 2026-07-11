# App icon & store graphics — TODO

**Blocker for submission.** The app currently ships the stock Flutter
template icon (the blue Flutter "F" logo) on both platforms — confirmed by
viewing `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png`
and the equivalent `android/app/src/main/res/mipmap-*/ic_launcher.png`
files. Neither store will reject a submission purely for using a generic
icon, but shipping the default template icon looks unfinished/untrustworthy
to reviewers and users, and is worth fixing before a real launch. Designing
the actual artwork is out of scope for this task (no design brief or
brand assets were provided) — this file just specifies what's needed.

## What to produce

1. **Master icon**: a single 1024×1024 PNG, no transparency, no rounded
   corners (both stores apply their own corner mask). Simple, flat,
   works at very small sizes (down to ~20×20 for iOS settings icons) —
   avoid fine detail or small text.
2. Once you have the master icon, regenerate all platform sizes with:
   ```sh
   flutter pub add --dev flutter_launcher_icons
   ```
   then configure `flutter_launcher_icons.yaml` pointing at the new
   1024×1024 source and run:
   ```sh
   dart run flutter_launcher_icons
   ```
   This replaces every file under `android/app/src/main/res/mipmap-*/` and
   `ios/Runner/Assets.xcassets/AppIcon.appiconset/`.
3. **Google Play Store icon**: 512×512 PNG, 32-bit with alpha, uploaded
   separately in Play Console (distinct from the in-app launcher icon
   asset, though usually the same artwork).
4. **Google Play feature graphic**: 1024×500 PNG/JPEG, shown at the top of
   the Play Store listing. Needs its own design (not just the icon scaled
   up) — e.g. icon + app name + a short tagline on a background.
5. *(Optional, App Store)* **App Store promotional artwork** — Apple no
   longer requires a separate feature graphic, but a clean 1024×1024 icon
   is the only hard requirement there.

## Suggested direction (not a final design)

Something evoking scheduling/calendar + community, avoiding any official
Jehovah's Witnesses/Watch Tower Society logos, emblems, or trade dress
(per the independence disclaimer in the privacy policy and store
descriptions) — e.g. a simple calendar-grid or checkmark glyph.
