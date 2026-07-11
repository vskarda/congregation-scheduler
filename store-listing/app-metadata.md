# App metadata (both stores)

Field-by-field values to enter into Google Play Console and App Store
Connect. Anything in `[BRACKETS]` is a placeholder you need to confirm or
fill in before submitting.

## Identity

| Field | Value |
|---|---|
| App name | `Congregation Scheduler` |
| Android `applicationId` | `org.jwscheduler.congregation_scheduler` |
| iOS bundle id | `org.jwscheduler.congregationScheduler` |
| Developer / publisher account name | `[DEVELOPER NAME]` — the name shown publicly on both stores as the app's developer. Given the app serves a religious minority community, consider whether you want your legal name, or a neutral project name (e.g. "JW Scheduler Project"), to appear here. Not something to guess on your behalf. |
| Version (first submission) | `1.0.0` (matches `pubspec.yaml`, build number auto from CI per `docs/CI-CD.md`) |

## Categorization

| Field | Value |
|---|---|
| Primary category | **Productivity** (both stores) |
| Secondary/alt category (Play only, optional) | Lifestyle |
| Tags (Play, optional, up to 5) | scheduling, church, volunteer, community, calendar |

## Contact & links

| Field | Value |
|---|---|
| Support e-mail (public, both stores require it) | `[SUPPORT EMAIL]` — default suggestion `vskarda@gmail.com` per existing project docs, confirm you want this public before submitting |
| Support URL | `https://github.com/vskarda/congregation-scheduler` (public repo; README + `docs/SETUP-ADMIN.md` double as support docs) or a dedicated `docs/support.html` if you'd rather not point users at the repo directly |
| Marketing URL (App Store, optional) | Same as support URL, or leave blank |
| Privacy policy URL (**required by both stores**) | `https://vskarda.github.io/congregation-scheduler/privacy-policy.html` — live only after GitHub Pages is enabled, see `store-listing/README.md` |

## Pricing & distribution

| Field | Value |
|---|---|
| Price | Free (both stores) |
| Ads | None — declare "No ads" on both stores |
| In-app purchases | None |
| Countries/regions | All (the app itself has no region lock; individual congregations self-host regardless of where their members are) |

## Notes

- The app currently ships English, Czech, and Turkish UI (`lib/l10n/app_{en,cs,tr}.arb`).
  Store *listing text* was scoped to English-only for this first pass
  (confirmed with the user) — both consoles let you add cs/tr listings
  later without blocking submission.
- Export compliance is already declared in `ios/Runner/Info.plist`
  (`ITSAppUsesNonExemptEncryption = false`), so no extra App Store Connect
  action is needed there beyond confirming the same answer if asked again
  at submission time.
