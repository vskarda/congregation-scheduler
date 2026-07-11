# Screenshot shot list

No screenshots were captured as part of this task — this machine has no
Android SDK and no Mac/Xcode (per `docs/CI-CD.md`), so there's no way to
produce real device/simulator screenshots here. This is the plan for
capturing them once you have access to a device, emulator, or simulator.

## Required sizes

**Google Play** (phone screenshots — 2 to 8 required):
- Any resolution with each side between 320px and 3840px
- Aspect ratio between 16:9 and 9:16 (portrait phone screenshots, e.g.
  1080×1920 or 1080×2400, are the safe default)
- JPEG or 24-bit PNG, **no alpha channel**
- A 7" and/or 10" tablet set is optional but recommended since the app
  runs on tablets too

**App Store** (per device size class actually supported — required for
each class you don't get auto-scaled for):
- iPhone 6.7" display (e.g. iPhone 15 Pro Max class): 1290×2796
- iPhone 6.5" display: 1242×2688 or 1284×2778 (check current Apple specs
  at submission time — these numbers shift with new device sizes)
- iPad Pro 12.9" (3rd gen or later): 2048×2732 — **required** because
  `Info.plist` declares iPad orientations (`UISupportedInterfaceOrientations~ipad`),
  meaning the app is built as a universal binary, not iPhone-only
- 3 to 10 screenshots per size class

Apple can auto-generate some smaller size classes from your largest
upload, but it's safer to capture each class natively on a matching
simulator if you have Xcode access.

## Screens to capture, in this order

1. **Setup / QR invite** — `lib/features/setup` — the "paste or scan
   Firebase config" screen, and/or the QR invite screen from
   `lib/features/publishers`. This is the single most differentiating
   screen (shows the self-hosted pitch visually).
2. **Home / "my upcoming assignments"** — `lib/features/home` — the
   personal overview a regular publisher sees after logging in.
3. **Life and Ministry Meeting schedule** — `lib/features/lmm_schedule` —
   a populated week showing parts and assignments.
4. **Weekend meeting schedule** — `lib/features/weekend_schedule`.
5. **Public witnessing schedule** — `lib/features/public_witnessing` —
   ideally showing recurring slots.
6. **Territories** — `lib/features/territories` — a territory list or
   detail with a map link.
7. **Reports / S-1 summary** — `lib/features/reports` or
   `lib/features/s1_report` — the monthly summary view.
8. **Publisher management** — `lib/features/publishers` — the admin view
   with verification/roles (use fake/demo names, not a real
   congregation's data).
9. *(Optional)* **Information board** — `lib/features/info_board`.

Use a demo/test Firebase project with placeholder names when capturing —
**do not screenshot a real congregation's data** for a public store
listing.

## Capture method

- **Android**: install the Android SDK (currently not installed per
  project notes) and either run `flutter build apk` on a device/emulator
  and use its screenshot tool, or use `flutter screenshot` /
  Android Studio's device screenshot button while `flutter run` is active.
- **iOS**: needs a Mac with Xcode; run on the Simulator and use
  Cmd+S / the Simulator's screenshot menu, sized per the device you pick.
- **Quick preview only, not for submission**: `flutter run -d chrome`
  (confirmed working per project notes) gives a fast look at each screen
  in a browser, but browser chrome and lack of a real status bar make
  these unsuitable as the actual uploaded screenshots for either store.
