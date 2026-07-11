# App Store Connect — App Privacy ("nutrition label") questionnaire

Draft answers for **App Store Connect → App → App Privacy**. Apple's
per-data-type questionnaire changes wording periodically — use this as a
mapping from what the app actually does, and confirm current wording live.

## Do you or your third-party partners collect data from this app?

**Yes.**

## Data types, mapped to Apple's categories

| Apple category | Collected? | Linked to identity? | Used for tracking? | Notes |
|---|---|---|---|---|
| Contact Info — Name | Yes | Yes | No | Publisher name |
| Contact Info — Email Address | Yes | Yes | No | Firebase Auth login |
| Contact Info — Phone Number | Yes | Yes | No | Optional profile field |
| Contact Info — Physical Address | No | — | — | Territory data is about locations to visit, not the user's own address |
| Health & Fitness | No | — | — | — |
| Financial Info | No | — | — | — |
| Location | No | — | — | No device geolocation APIs used |
| Sensitive Info (e.g. religious beliefs) | Consider **Yes** | Yes | No | The app's *context* (a Jehovah's Witnesses congregation) makes membership itself sensitive/religious information, even though the app doesn't have a dedicated "religion" field. Review this row carefully in App Store Connect — Apple's definition of "Sensitive Info" and whether congregation membership qualifies may need your own judgment call or Apple guidance. |
| User Content — Photos or Videos | Yes | Yes | No | Info-board / report attachments |
| User Content — Other User Content | Yes | Yes | No | Ministry reports, assignments, territory notes |
| Identifiers — User ID | Yes | Yes | No | Firebase Auth UID, used only for the app's own access control |
| Identifiers — Device ID | No | — | — | No advertising/device identifiers collected |
| Usage Data | No | — | — | No analytics SDK |
| Diagnostics | No | — | — | No crash-reporting SDK |
| Purchases | No | — | — | Free app |
| Browsing History | No | — | — | — |
| Search History | No | — | — | — |

## "Used to track you" (Apple's ATT definition)

**No** for every data type — nothing is linked with data from other
companies' apps/websites for advertising, and there's no third-party
advertising or analytics SDK in `pubspec.yaml`. App Tracking Transparency
prompt is **not needed**.

## Data linked to the user vs. not linked

Everything collected is linked to the user's own account within their
congregation's Firebase project (needed for the app's core scheduling
function), so "linked to identity" = Yes throughout, as marked above.

## Data use purposes (per data type)

**App Functionality** only — account creation/sign-in, scheduling,
congregation record-keeping. Not analytics, not advertising, not
third-party advertising, not personalization beyond showing a user their
own data.

## Note for the reviewer conversation (optional but recommended)

Consider adding an App Review note explaining the self-hosted architecture
(no backend operated by the developer) — this is unusual enough that it
may otherwise raise questions during human review of the privacy
questionnaire.
