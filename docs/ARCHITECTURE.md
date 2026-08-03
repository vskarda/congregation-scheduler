# Architecture

Flutter app (Android / iOS / Web) + self-hosted Firebase (Auth + Firestore),
one Firebase project per congregation, **Spark (free) plan only**: no Cloud
Functions, no Firebase Storage. All logic is client-side; access control is
entirely in `firestore.rules`.

## Runtime Firebase initialization

There is no `google-services.json` / `firebase_options.dart` baked into the
app. On first run the Setup wizard accepts a Firebase **web** config JSON
(pasted or scanned from QR), stores it in `shared_preferences`, and
`core/firebase/firebase_bootstrap.dart` calls
`Firebase.initializeApp(options: FirebaseOptions(...))` with those values on
every launch. The same web config works on Android/iOS/Web because only
Auth + Firestore REST/gRPC endpoints are used.

One platform caveat: Apple's native Firebase SDK aborts (uncaught
Objective-C `NSException` → SIGABRT, uncatchable from Dart) when initialized
with a *web* app id (`1:<sender>:web:<hex>`), while Android accepts it. So
`parseOptions` rewrites the app-id platform token to `ios` on iOS/macOS only
(`_appIdForPlatform`); the app id isn't used for Auth/Firestore auth (that's
`apiKey` + `projectId`), and the stored/shared config keeps the original web
id so the QR/JSON invite stays cross-platform.

## Layers

```
features/<feature>/
  data/        Firestore repositories (typed mappers around collections)
  domain/      freezed models + pure logic (parsers, calculators)
  presentation/ screens + widgets + Riverpod providers
core/          bootstrap, config, theme, l10n, shared widgets
```

- **State**: Riverpod. Firestore streams exposed as `StreamProvider`s;
  mutations via repository classes.
- **Routing**: go_router with redirect guards:
  no config → `/setup`; signed out → `/login`; unverified → `/awaiting`;
  admin routes additionally check the role flags on the own publisher doc.
- **i18n**: ARB files (`app_en.arb`, `app_cs.arb`, `app_tr.arb`), `flutter
  gen-l10n`. JW terminology is copied verbatim from the official forms in
  `example-forms/` — see [ADDING-A-LANGUAGE.md](ADDING-A-LANGUAGE.md) for the
  full procedure (also covers the per-language parser keyword lists).

## Key domain decisions

- **Assignment field** (`Assignment` model): `{publisherIds: [uid], freeText:
  String?}` everywhere a person can be assigned. Free text always allowed as
  an alternative to picking publishers. Rendering highlights the current
  user's own uid.
- **Week documents** are keyed by the Monday of the week (`yyyy-MM-dd`) in
  `lmm_weeks`, `weekend_weeks`. Every week doc carries a denormalized
  `allAssigneeIds` array so "my upcoming assignments" is a simple
  `array-contains` query per collection.
- **Least-recently-assigned ordering** in the publisher picker is computed on
  the fly from the last ~18 months of loaded week docs (small data), never
  from denormalized counters.
- **Files without Firebase Storage**: binary content is chunked into ~900 KB
  `Blob` fields under `files/{id}/chunks/{n}` (Firestore doc limit is 1 MiB),
  capped at 10 MB per file; anything larger should be an external link.
- **Reports** live at `reports/{yyyy-MM}/entries/{publisherId}` and snapshot
  the publisher's pioneer status (`statusAtMonth`) so S-1 group counts stay
  correct historically. Publishers without smartphones get publisher docs
  created by an admin (random id) and admin-entered reports.
- **S-1** is computed client-side by a pure calculator over one month of
  entries + last 6 months of activity + the month's attendance docs.
- **Public witnessing recurrence**: same model as field service meetings
  below — `PwRepository.expand` builds slots from `pw_recurring` on the fly and
  `pw_slots` holds only one-off slots and exceptions. What is PW-specific is
  that **slot ids are permanent**: applications live at
  `pw_applications/{slotId}_{uid}` and the security rules let nobody re-key
  them (an admin may create none, because the applicant id must be their own,
  and update none), so a slot that changed id would silently lose everyone who
  volunteered. Hence `detachFrom` rewrites in place rather than creating a new
  document, and every path that removes a slot removes its applications too.
  `repairAndCompact` additionally sweeps applications naming slots nothing
  produces any more; past ones are kept as the record of who volunteered.
- **Field-service-meeting recurrence**: the rule *is* the meetings. Nothing is
  pre-written — `FsmRepository.expand` builds occurrences from `fsm_recurring`
  on the fly, so a rule edit reaches every one of them at once.
  `fsm_meetings` holds only one-off meetings and *exceptions*: the occurrences
  an admin edited, moved or cancelled. An exception's `overrides` names the
  fields it is authoritative for; everything else keeps following the rule, so
  changing one week's conductor does not freeze that week's location. Its
  identity is `seriesDate` (the slot in the series, also the doc id suffix),
  kept apart from `date` (when it actually happens) so an occurrence can be
  moved without colliding with its own series. Deleting a rule freezes its
  past occurrences into stand-alone meetings and detaches customized ones, so
  no document is ever left pointing at a rule that no longer exists.
  `repairAndCompact` runs once per admin session to reconnect and compact data
  written by the earlier materializing model.

## Security model

See header comment of [`firestore.rules`](../firestore.rules). Highlights:

- `publishers/{uid}.verified` gates every congregation collection.
- Granular section roles (`roles.infoBoard`, `roles.lmmSchedule`, …) +
  `roles.fullAdmin`; self-service profile updates may not touch
  `verified` / `roles` / `qualifications` (enforced with `diff()`).
- Sensitive personal data (e-mail, phone, birth date, emergency note) lives
  in `publishers/{uid}/private/profile`, readable only by the publisher and
  publisher-admins, because Firestore rules cannot hide individual fields.
- First-admin bootstrap relies on Firestore `create` matching only
  non-existing docs: whoever creates `congregation/meta` first is the
  founder; second racers are rejected by the `update` rule.
- Note: a publisher-admin can grant any role, including `fullAdmin` — roles
  are a convenience layer among trusted brothers, not mutual hard isolation.

### Data on the device

Firestore offline persistence keeps a local copy of every document the
signed-in user has read — for a publisher-admin that is the whole
congregation's private profiles. Two consequences are handled explicitly:

- **Sign-out.** `FirebaseAuth.signOut()` does not touch that copy, so
  sign-out and account deletion go through
  `core/firebase/local_cache.dart`, which marks the cache and lets `main()`
  clear it on the next launch. That indirection is not optional:
  `clearPersistence()` only succeeds before a Firestore client has started
  and while no listener is attached, which is true exactly once per launch.
- **Backups.** On Android the cache is excluded from cloud backup and
  device-to-device transfer (`android/app/src/main/res/xml/backup_rules.xml`
  and `data_extraction_rules.xml`); the rest of the app's data still travels,
  so restoring to a new phone keeps the congregation config and the session.
  iOS has no equivalent exclusion yet — an iCloud backup still carries the
  cache until the user signs out.

### Data in transit

Everything leaves the device over TLS: Auth and Firestore through the
Firebase SDKs, the pub-media API through the https URLs in
`core/config/app_config.dart`. The workbook download URL is the one address
that arrives from a remote response, so `epubUrlFromPubMedia` refuses
anything that is not https. That check has to live in Dart: `package:http`
uses `dart:io`'s `HttpClient`, which does not consult Android's
cleartext-traffic policy, so the platform would not block an `http://` URL.

Known gap, accepted while the web build stays dev-only: `launchUrl` in the
info-board and territory screens opens an admin-entered URL without checking
its scheme. On a *distributed* web build a `javascript:` URL would run in the
app's origin, so add an https/http allowlist before publishing one.

## Meeting Workbook import

`features/lmm_schedule/epub_import/` unzips the `.epub` (package `archive`),
walks the OPF spine to find the weekly XHTML documents (skipping the
`-extracted` reference files), and extracts week ranges, the weekly
scripture, songs, and parts. Section/part detection is structure-first
(`dc-icon--gem/wheat/sheep` wrapper classes, `<h3>N. Title</h3>` +
`(10 min.) instructions` detail paragraphs in the 2024+ markup) with
language-aware text fallbacks for the legacy inline format (Czech `mwb_B_*`,
English `mwb_E_*`, Turkish `mwb_T_*`). Part instructions land in
`LmmPart.description`.

Re-importing an existing week merges via `week_merge.dart`: program content
is refreshed while part ids, assignments and support roles are preserved
(parts matched by section/type in order; manual custom parts survive).

The "check online" action queries the pub-media API (template in
`core/config/app_config.dart`) for the current and next issue — the JSON
response carries the epub URL under `files.{lang}.EPUB[0].file.url`,
unpublished issues answer 404 and are skipped. Web builds may be blocked by
CORS — file import is the universal path.
