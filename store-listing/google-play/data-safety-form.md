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
| Can users request data deletion? | Yes — in-app self-service deletion (see below), plus admin-initiated removal |
| Is there an account-deletion mechanism? | Yes — any signed-in user can permanently delete their own account in-app under **My profile → Delete my account** (also on the awaiting-verification and complete-profile screens). It removes the login, the personal profile documents and the user's public-witnessing applications; previously submitted ministry reports remain with the congregation. |
| Do you commit to the Play Families Policy? | Not applicable — app is not designed for or targeted at children |

## Data deletion request link (required if accounts can be created)

Deletion is available **in-app** (**My profile → Delete my account**), so a
web URL is not strictly required. If Play's form still demands a link, point
it at the privacy policy's "Data retention & deletion" section, which
documents the in-app steps.
