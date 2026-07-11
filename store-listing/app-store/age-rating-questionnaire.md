# App Store Connect — Age rating questionnaire

Draft answers for **App Store Connect → App → Age Rating**. Apple
overhauled this into a more granular, points-based questionnaire in 2024
(now producing ratings such as 4+, 9+, 13+, 16+, 18+ depending on region)
— the exact question set may look different from this draft by the time
you submit, but the answers should map the same way since nothing in the
app touches mature content.

| Question theme | Answer |
|---|---|
| Cartoon/fantasy or realistic violence | None |
| Sexual content or nudity | None |
| Profanity or crude humor | None |
| Alcohol, tobacco, or drug use/references | None |
| Mature/suggestive themes | None |
| Horror/fear themes | None |
| Gambling (simulated or real-money) | None |
| Contests | None |
| Unrestricted web access | No — links open in the system browser via `url_launcher`, the app has no in-app browser |
| User-generated content, unmoderated and shared broadly | No — content is scoped to a single congregation's verified members via Firestore security rules, not shared publicly |
| Messaging / communication with other users | No dedicated chat/messaging feature |
| Medical/treatment information | No |

**Expected outcome:** the lowest available tier (4+, or whatever the
current lowest band is called), since no question triggers a restriction.

Fill in the live questionnaire yourself when submitting — this file is a
drafting aid, not a substitute for the actual App Store Connect form.
