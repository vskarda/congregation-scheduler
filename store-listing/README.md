# Store publishing package

Everything needed to submit **Congregation Scheduler** to the Google Play
Store and Apple App Store, prepared as reviewable drafts. Nothing here has
been submitted anywhere — every file is a document for you to review, fill
in placeholders, and paste into the respective consoles.

This is the *content* half of publishing. The *build/signing/upload*
pipeline already exists — see [`docs/CI-CD.md`](../docs/CI-CD.md).

## Two blockers found while preparing this — read first

1. ~~**App icon is still the Flutter default template icon.**~~
   **RESOLVED.** A real app icon (calendar + congregation + checkmark on a
   blue gradient) now ships on Android (legacy + adaptive), iOS, and web,
   generated from [`../icon.png`](../icon.png). The Play Store 512×512 icon
   and 1024×500 feature graphic are prepared under `assets/` for manual
   upload in the Play Console. See
   [`assets/ICON-AND-GRAPHICS-TODO.md`](assets/ICON-AND-GRAPHICS-TODO.md).
2. ~~**No self-service "delete my account" feature.**~~ **RESOLVED.**
   Any signed-in user can now permanently delete their account in-app
   (**My profile → Delete my account**, also reachable from the
   awaiting-verification and complete-profile screens), satisfying Apple's
   App Store Review Guideline 5.1.1(v). Deletion re-authenticates with the
   password, removes the Firebase Auth login plus the profile documents and
   the user's public-witnessing applications; submitted ministry reports
   stay stored with the congregation. A sole full-admin is blocked from
   deleting (it would lock the congregation out) and told to grant another
   admin first. Note: this needs the updated `firestore.rules` published in
   the congregation's Firebase project (see
   [`docs/SETUP-ADMIN.md`](../docs/SETUP-ADMIN.md) step 4).

## File index

| File | Purpose |
|---|---|
| [`privacy-policy.md`](privacy-policy.md) | Canonical privacy policy text |
| [`../docs/privacy-policy.html`](../docs/privacy-policy.html) | Same content, standalone HTML, published via GitHub Pages (see below) |
| [`app-metadata.md`](app-metadata.md) | App name, category, contact/support/marketing URLs, keywords |
| [`release-notes-v1.md`](release-notes-v1.md) | "What's new" text for the first submission |
| [`descriptions/google-play.md`](descriptions/google-play.md) | Play short + full description, character-counted |
| [`descriptions/app-store.md`](descriptions/app-store.md) | App Store subtitle, promo text, description, keywords, character-counted |
| [`google-play/data-safety-form.md`](google-play/data-safety-form.md) | Draft answers for Play's Data Safety questionnaire |
| [`google-play/content-rating-questionnaire.md`](google-play/content-rating-questionnaire.md) | Draft answers for Play's IARC content rating |
| [`app-store/app-privacy-questions.md`](app-store/app-privacy-questions.md) | Draft answers for Apple's App Privacy ("nutrition label") |
| [`app-store/age-rating-questionnaire.md`](app-store/age-rating-questionnaire.md) | Draft answers for Apple's age rating questionnaire |
| [`screenshots/SHOT-LIST.md`](screenshots/SHOT-LIST.md) | What to capture, in what order, at what pixel sizes |
| [`assets/ICON-AND-GRAPHICS-TODO.md`](assets/ICON-AND-GRAPHICS-TODO.md) | Icon + Play feature graphic — **done**; how they were generated + what to upload |

All store-listing text was prepared in **English only** for this first
pass (confirmed choice) — both consoles let you add Czech/Turkish listings
later without blocking submission, independent of the app's own cs/en/tr
UI localization.

## Submission checklist

1. **Fill in every `[PLACEHOLDER]`** across these files — search for
   `[` to find them all. Key ones: developer/publisher name, support
   e-mail, "last updated" date on the privacy policy, account-deletion
   process description.
2. **Upload the Play Store graphics** — `assets/play-store-icon-512.png`
   and `assets/play-feature-graphic-1024x500.png` (the in-app/iOS icons
   already ship with the build). See `assets/ICON-AND-GRAPHICS-TODO.md`.
3. **Capture screenshots** per `screenshots/SHOT-LIST.md`, once you have
   an Android device/emulator or iOS simulator available.
4. **Publish the privacy policy** — enable GitHub Pages for this repo
   (**Settings → Pages → Deploy from a branch → `main` / `/docs`**; the
   repo is already public, so this works on the free plan). The live URL
   will be `https://vskarda.github.io/congregation-scheduler/privacy-policy.html`.
   I have **not** enabled this for you — it's a one-click repo setting,
   flag when you'd like it turned on. Verify the page loads before
   pasting the URL anywhere.
5. **Google Play Console**: create the app listing (one-time manual step,
   see `docs/CI-CD.md` §3.2), paste in `descriptions/google-play.md`,
   `app-metadata.md` fields, walk `google-play/content-rating-questionnaire.md`
   and `google-play/data-safety-form.md` live, upload icon/feature
   graphic/screenshots, do the first manual AAB upload.
6. **App Store Connect**: create the app record (one-time manual step, see
   `docs/CI-CD.md` §4.5), paste in `descriptions/app-store.md`,
   `app-metadata.md` fields, walk `app-store/app-privacy-questions.md` and
   `app-store/age-rating-questionnaire.md` live, upload icon/screenshots.
   **Resolve blocker #2 above before this step**, or expect a rejection.
7. **Run the release pipeline** — `.github/workflows/release.yml`
   (`workflow_dispatch`) per `docs/CI-CD.md` §5, starting with
   `platform=android, play_track=internal`, then `ios`, then `both`.

## Keeping this in sync

If app functionality changes (new permissions, new data collected, an
account-deletion feature ships), update `privacy-policy.md` **and**
`docs/privacy-policy.html` together, and revisit
`google-play/data-safety-form.md` / `app-store/app-privacy-questions.md`
since both stores require accurate, current answers on every release that
changes data handling.
