# Google Play Console — Data Safety questionnaire

Draft answers for **Play Console → App content → Data safety**. Question
wording changes over time — treat this as a mapping of *what the app
actually does* onto the form's categories, and re-check the live wording
when you fill it in.

## Does your app collect or share any of the required user data types?

**Yes** — but everything below is written to the congregation's own
Firebase project, not to any server the developer operates. Frame every
answer with that context where the form allows free text.

## Data types collected

| Play category | Collected? | Notes |
|---|---|---|
| **Personal info** — Name | Yes | Publisher name |
| **Personal info** — Email address | Yes | Firebase Auth login |
| **Personal info** — Phone number | Yes | Optional profile field |
| **Personal info** — Address | No | Territory addresses are congregation-entered text about *territory locations*, not the user's own address |
| **Personal info** — Date of birth | Yes | Optional profile field |
| **Personal info** — Other info (emergency contact note) | Yes | Free-text field, admin-visible |
| **Financial info** | No | — |
| **Location** | No | No device location APIs used; territory/map links are user-typed text |
| **Photos or videos** | Yes | Files attached to the information board / reports (chunked into Firestore, ≤10 MB) |
| **Files and docs** | Yes | Same as above (PDFs etc.) |
| **App activity** — App interactions / in-app search history | No | No analytics SDK in the app |
| **App info and performance** — Crash logs, diagnostics | No | No crash-reporting SDK (no Crashlytics) |
| **Device or other IDs** | No | No advertising ID / device ID collection |

## Purpose of collection

For every "Yes" row: **App functionality** (account creation, scheduling,
congregation record-keeping). Not used for analytics, advertising,
personalization, or fraud prevention.

## Is data shared with third parties?

**No**, in the Play sense of "shared" (transferred to a company for that
company's own purposes). Data is *processed* by Google Firebase purely as
infrastructure on behalf of the congregation's administrator — this is
normally declared as a **service provider**, not a "share," but confirm
against Play's current definitions when filling in the form.

## Security practices

| Question | Answer |
|---|---|
| Is data encrypted in transit? | Yes (Firestore/Firebase Auth use TLS) |
| Can users request data deletion? | Yes, in principle — currently via the congregation administrator (see below); note the account-deletion gap |
| Is there an account-deletion mechanism? | **Gap** — the app currently only has an admin-initiated "remove publisher" action, not individual self-service account deletion. Play's policy accepts a *web-based* deletion path even if not in-app; at minimum, document a request process (e.g. e-mail the developer/administrator) and link it here before submitting. See `store-listing/README.md` blocker list. |
| Do you commit to the Play Families Policy? | Not applicable — app is not designed for or targeted at children |

## Data deletion request link (required if accounts can be created)

`[PLACEHOLDER]` — point this at either: (a) an in-app deletion flow once
built, or (b) a short page/e-mail process describing how a user asks their
administrator (or the developer, for account-level data) to delete their
account. Do not leave this blank — Play requires it whenever the app
supports account creation.
