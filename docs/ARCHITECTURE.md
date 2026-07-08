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
finds the weekly XHTML files, and extracts week ranges, songs, and parts with
language-aware patterns (Czech `mwb_B_*`, English `mwb_E_*`). The optional
CDN check downloads the same epub from a URL constant in
`core/config/app_config.dart` (placeholder until provided; web builds may be
blocked by CORS — file import is the universal path).
