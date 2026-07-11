# Google Play Console — Content rating (IARC) questionnaire

Draft answers for **Play Console → App content → Content ratings**. The
IARC questionnaire's exact wording/categories can change — treat this as a
draft to walk through live, not a copy-paste form.

Category to select at the start: **Reference, News, or Educational**
(closest fit; "Productivity"-type apps generally fall under this
questionnaire branch) or whatever the current console offers closest to a
utility/productivity app with no entertainment content.

| Question theme | Answer | Why |
|---|---|---|
| Violence | None | No violent content anywhere in the app |
| Sexual content / nudity | None | — |
| Profanity / crude humor | None | — |
| Controlled substances (alcohol, tobacco, drugs) | None | — |
| Gambling (real or simulated) | None | — |
| User-generated content shared publicly | No | Content (info board posts, reports, files) is scoped to the congregation's own verified members via Firestore rules, not shared publicly or with strangers |
| Unrestricted internet/web access | No | The app doesn't embed an open web browser (only `url_launcher` opens links in the system browser, and `open_filex` opens files in the OS) |
| User-to-user communication | No chat/messaging feature | Members see each other's contact info and assignments if an admin grants that visibility, but there's no in-app messaging/chat |
| Shares user location | No | No device geolocation used |
| Digital purchases | No | — |

**Expected outcome:** the most permissive rating tier on every store this
maps to (Google's "Everyone", PEGI 3, USK 0, ESRB Everyone, etc.), since
nothing in the app triggers a content flag.

Fill in the live questionnaire yourself — Play requires this be submitted
by the account holder, not pre-filled externally.
