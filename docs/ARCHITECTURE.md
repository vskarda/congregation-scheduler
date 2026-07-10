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
- **i18n**: ARB files (`app_en.arb`, `app_cs.arb`), `flutter gen-l10n`.

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
- **Public witnessing recurrence**: `pw_recurring` rules are materialized
  into concrete `pw_slots` ~3 months ahead whenever an admin opens the PW
  admin screen; individual slots stay editable/deletable.

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

## Meeting Workbook import

`features/lmm_schedule/epub_import/` unzips the `.epub` (package `archive`),
walks the OPF spine to find the weekly XHTML documents (skipping the
`-extracted` reference files), and extracts week ranges, the weekly
scripture, songs, and parts. Section/part detection is structure-first
(`dc-icon--gem/wheat/sheep` wrapper classes, `<h3>N. Title</h3>` +
`(10 min.) instructions` detail paragraphs in the 2024+ markup) with
language-aware text fallbacks for the legacy inline format (Czech `mwb_B_*`,
English `mwb_E_*`). Part instructions land in `LmmPart.description`.

Re-importing an existing week merges via `week_merge.dart`: program content
is refreshed while part ids, assignments and support roles are preserved
(parts matched by section/type in order; manual custom parts survive).

The "check online" action queries the pub-media API (template in
`core/config/app_config.dart`) for the current and next issue — the JSON
response carries the epub URL under `files.{lang}.EPUB[0].file.url`,
unpublished issues answer 404 and are skipped. Web builds may be blocked by
CORS — file import is the universal path.
