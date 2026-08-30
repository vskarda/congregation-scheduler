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
- **What a week's meeting runs** is one field on the week document,
  `programKind` (`MeetingProgramKind`), chosen per week *and* per meeting:
  `regular`, `nothingPlanned` (an assembly or convention week — publishers see
  `programNote` instead of a program and no attendance is expected), or
  `memorial` (`MemorialProgram`, embedded in the same document). Nothing is
  deleted when the kind changes: the regular program stays in the document and
  comes back with it, which is why `allAssigneeIds` unions *every* stored slot
  — the connect-publisher migration must still find a week whose Memorial is
  dormant — while the display, reminder and rotation-history layers filter by
  the kind actually running. The Memorial needs no day or time of its own: the
  week's existing `meetingWeekday` / `meetingTime` override moves it, the same
  mechanism a circuit overseer's visit uses. It is arranged by either
  meeting-schedule role in either collection (firestore.rules grants exactly
  that, `canEditProgram` mirrors it in the UI); deleting the week stays with
  the schedule's own role, because that would take the whole program with it.
- **Memorial attendance** is recorded in `attendance` like any other meeting,
  under `MeetingType.memorial`, so it is entered and corrected through the
  same form and the same roles. It is never one of `kCountedMeetingTypes`, and
  that constant — not `MeetingType.values` — is what the monthly averages, the
  statistics screen, the attendance history and the S-88 record sheet iterate.
  The S-1 and the record sheet name `lmm`/`weekend` explicitly and are
  unaffected. `test/s1_calculator_test.dart` and
  `test/statistics_model_test.dart` pin the exclusion down.
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
  entries + last 6 months of activity + the month's attendance docs. The
  roster is consulted for exactly one thing: dropping entries a recorded
  moving date places in another congregation by that month (`excludedIds`).
  So a closed month keeps its numbers unless a *date* says the publisher had
  already left — an entry filed on the 10th by someone who moved on the 15th
  is theirs, not ours, and neither the group lines nor the six-month actives
  count it. Entries whose publisher record is gone *and* whose departure was
  never recorded keep counting: a deletion says nothing about where the person
  went, and tidying the roster must not silently change a filed month. A
  record archived *without* a date counts in no month at all, which is why the
  detail screen flags one and points at "Change moving date".
  `test/s1_moved_publisher_test.dart` pins every one of these cases down.
  Everything else the S-1 reads is recomputed every time it is opened, on
  purpose: a late report, a corrected attendance count and above all a fixed
  `statusAtMonth` must reach the month they belong to, however long
  afterwards. The one change that must *not* reach it is roster housekeeping,
  which is what `former_publishers` is for (below).
- **Departures outlive their records.** Report entries are keyed by publisher
  id under `reports/{month}/entries`, but the moving date that says which
  months belong to the next congregation lives on `publishers/{uid}` — so
  deleting the record would hand those months straight back to this
  congregation's S-1, months after they were handed in. Deleting a record that
  is marked moved therefore writes `former_publishers/{uid}` first: the
  departure and nothing else, no name, nothing personal (deleting a publisher
  must really delete them). `movedAwayBy()` merges roster and tombstones into
  one exclusion set, and the S-1, the service-year statistics and the usage
  card all take their cut from it, so the screens cannot disagree. A record
  deleted while still a member leaves no tombstone — there is nothing to
  remember. Registering again on the same auth uid clears an old one
  (`createWithId`), or the returning publisher's new reports would vanish from
  the S-1 without a word. `test/s1_deleted_publisher_test.dart` covers it.
- **Moving away** is one date, `publishers/{uid}.movedDate`, and it may be in
  the future — until it arrives the record behaves like any other member's.
  It cuts on two different scales: *day-level* for meetings, assignments and
  app access (`hasMovedBy`), *month-level* both for report rosters and for
  which entries a month may count, where the month containing the move
  already belongs to the new congregation, so the last month claimed is the
  one before it (`onRosterInMonth`). Membership and age statistics read the
  roster as of today; the report-driven figures (S-1, service-year field
  service, the usage card) apply the month-level cut month by month, so a
  publisher's history stays in the years they were here and stops where they
  left. Access is not revoked by a client sweep — with no Cloud Functions
  there is nothing to run one — but by `firestore.rules`, which compares
  `request.time` against the denormalized `movedAt` timestamp (rules cannot
  parse a date string). The client mirrors that cut in `isVerifiedProvider`
  and the router, otherwise a publisher past their date would be let into an
  app whose every read the backend denies. A record archived before this
  field existed has no date, and counts neither on a roster nor in any
  month's figures until an admin sets one. The date survives the record it was
  written on — see "Departures outlive their records" above.
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
- **A week's meeting day is a per-week override.** `lmm_weeks` /
  `weekend_weeks` may carry `meetingWeekday` + `meetingTime`; absent means
  "follow `congregation/meta`" (`weekdayOr` / `timeOr`). A circuit overseer's
  visit sets the midweek one to Tuesday, an assembly moves either. Because the
  keys are absent on ordinary weeks, the handful that deviate can be found
  with a single `where('meetingWeekday', >= 1)` query
  (`getWeekdayOverrides`) — that is how the attendance history knows which day
  to expect a meeting on, instead of listing the regular day as never recorded
  and the real one as a stray extra, and how the week picker can label 25
  weeks with their real meeting dates in one read. Both schedules are headed
  by that date (`MeetingWeekHeader`): tapping it picks another week, the
  pencil beside it moves this one. Every consumer of the meeting date goes
  through the override: both schedule views, "my assignments" (and so the
  reminders), and the attendance history. `mergeParsedWeek` carries it across
  a workbook re-import — the workbook says nothing about when a meeting is
  held.
- **A week's names are shown or hidden per week**, for each of the four
  schedules that name anyone: `schedule_config/{lmm,weekend,pw,fsm}` carries
  `hiddenWeeks`, the Monday keys switched off. Absent means shown, so only the
  weeks that deviate are listed and an untouched congregation keeps showing
  everything. It lives there rather than on the week document because two of
  the four have no week document at all — public witnessing and the meetings
  for field service expand their occurrences from the recurring rules — and
  one mechanism for all four is one provider
  (`weekAssigneesVisibleProvider`) and one switch widget. Off, a publisher
  still gets the whole program — titles, songs, times, locations, notes — and
  no name at all, their own included: the assignment rows, the support-
  assignments card and the week's lines in "my assignments" all go, and with
  them the reminders, because an assignment that is not announced must not
  buzz. The schedule's own admins always see the names, which is why the
  provider keys on `effectiveRolesProvider` — "view as publisher" previews
  exactly what the congregation sees, while the reminders keep using the real
  roles so previewing never cancels an admin's own. The circuit overseer view
  renders `fsm_meetings` itself, so its ministry rows follow the
  meetings-for-field-service switch, not the visit's. Public witnessing keeps
  its apply/withdraw hand on every slot, assigned ones included: an
  application and an assignment are different things, and on a hidden week the
  hand is the only handle a publisher has. Cosmetic, exactly like
  `CoVisit.hiddenSections` below: the week documents stay readable by every
  verified user, because rules cannot hide individual fields and there are no
  Cloud Functions to project them.
- **Circuit overseer's visit**: one `co_visits/{weekId}` document per visit,
  keyed by the Monday like the schedule weeks; the visit itself runs Tuesday
  to Sunday. It holds a flat list of items (meal, shepherding visit, meeting
  with the pioneers, meeting with the elders and ministerial servants, other),
  each with an optional day, time, assignment, address and note — *nothing* is
  required, because a visit is planned in pieces. `hiddenSections` hides a
  whole section from publishers (and, unless asked for, from the printout);
  `schedule_config/coVisit` hides the whole view until an admin publishes it.
  Both are cosmetic: `co_visits` is readable by every verified user, like the
  schedules.
  The view spans three roles on purpose and never pretends otherwise. The
  visit belongs to `events`; the week's **meetings for field service are not
  copied into it** — the ministry section renders `fsm_meetings` itself, so
  both views edit one set of documents, under `fieldServiceMeetings`; the
  midweek meeting day belongs to `lmmSchedule`. An events-admin holding
  neither of the other two sees both sections and is told who edits them, and
  `createCoVisit` skips the writes it may not make rather than letting them
  fail. The two "in the ministry with the circuit overseer / with his wife"
  slots live on `FsmMeeting` (`withCo`, `withCoWife`) for the same reason:
  they are properties of that meeting. A rule names no companions, so
  `diffFrom` reports them the moment they are set — without that,
  `repairAndCompact` would file a companion-only exception as a redundant copy
  of its rule and delete it.
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
- The `email` in that document is **contact data, not the sign-in identity**.
  The identity lives in Firebase Auth, and with no Cloud Functions on the
  Spark plan only its owner can change it: "Change sign-in e-mail" on the
  profile re-authenticates with the password and calls
  `verifyBeforeUpdateEmail`, which mails the confirmation link to the *new*
  address — nothing goes to the old one, which is what makes it work for a
  mailbox nobody can reach any more. The change lands when that link is
  opened, ending the session, so the publisher signs in again with the new
  address. `AuthService.startEmailChange` moves the contact copy along, but
  only while it still holds the address being replaced, and best-effort: the
  link is already out, and a congregation still on the previous rules would
  deny the write.
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

Hand-written content is never overwritten. `LmmPart.manual` marks a part
whose title or description an admin typed — the part dialog sets it as soon
as either field is edited, and shows it as a switch so a part can be handed
back to the workbook. A manual part keeps its title, description and duration
through a re-import, and survives even when the parse has no counterpart for
it at all (which also fixes an older hole: only `custom` parts used to be
rescued, so a hand-added `living` part could be dropped). The three song slots
carry the same flag (`openingSongManual` / `livingSongManual` /
`closingSongManual`), set by picking a song and toggled by the pin on the row.
`protectedByMerge` counts what a merge would leave alone, which is what the
import preview reports before anything is saved.

The "check online" action queries the pub-media API (template in
`core/config/app_config.dart`) for the current and next issue — the JSON
response carries the epub URL under `files.{lang}.EPUB[0].file.url`,
unpublished issues answer 404 and are skipped. Web builds may be blocked by
CORS — file import is the universal path.
