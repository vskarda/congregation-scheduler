# Adding a language — deriving correct JW terminology

This guide is written for future (AI or human) iterations that add a new app
language. Its single most important rule:

> **Never translate JW terminology yourself. Copy it, character for
> character, from the official forms in `example-forms/`.**
>
> Machine/LLM translations of theocratic terms look plausible and are wrong.
> Real examples that shipped before this rule existed: Czech "Duchovní perly"
> (official: "Hledání duchovních drahokamů"), Czech "KŘESŤANSKÝ ŽIVOT"
> (official: "ŽIVOT KŘESŤANA"), Turkish "Kutsal Kitap İncelemeleri" on the
> S-1 (official: "Kutsal Kitap Tetkiki").

## 1. Get the official forms first

Before touching any `.arb` file, obtain these official forms from jw.org in
the target language and commit them to `example-forms/`:

| File | Form | Format | Provides terminology for |
|---|---|---|---|
| `S-140_<CODE>.docx` | Midweek Meeting Schedule | docx | meeting sections, part names, rooms, chairman/student/assistant, schedule PDF title |
| `S-1_<CODE>.pdf` | Congregation's Field Service and Meeting Attendance Report | pdf | S-1 screen labels, publisher groups, attendance wording |
| `S-21_<CODE>.pdf` | Congregation's Publisher Record | pdf | publisher record/profile labels, report columns, statuses, hope, gender, appointments, months of the service year |

`<CODE>` is the **JW publication language symbol**, not an ISO code:
`E` = English, `B` = Czech, `TK` = Turkish, etc. (It appears in the form
footer, e.g. `S-21-TK 11/23`, and in workbook filenames, e.g.
`mwb_TK_202607.epub`.) Search jw.org for the form number ("S-140") with the
site set to the target language.

Optional but useful when the language supports the related features:
`S-89` (student assignment slip) and `S-99` (public talk titles).

## 2. Extracting the text

- **docx (S-140)**: a docx is a zip; read `word/document.xml` and strip tags
  (`</w:p>` marks a line break). PowerShell example used for the existing
  languages: open with `System.IO.Compression.ZipFile`, regex-replace
  `</w:p>` → newline, then `<[^>]+>` → nothing. Note the S-140 template
  repeats each week block four times — you only need one block.
- **pdf (S-1, S-21)**: read the text layer (AI file readers or `pdftotext`).
  Beware extraction artifacts: diacritics may come out decomposed
  ("Do ˘gum tarihi" = "Doğum tarihi") and reading order can interleave
  columns. When in doubt, cross-check against the rendered page.

## 3. Terminology map: form label → ARB key

Create `lib/l10n/app_<locale>.arb` from `app_en.arb` (the template). Most
keys are ordinary app UI — translate those normally. The keys below carry
**JW terminology** and must come from the forms.

### From the S-140 (midweek meeting)

| ARB key | Form label (E / B / TK as worked examples) | Match |
|---|---|---|
| `lmmScheduleTitle` | form title: Midweek Meeting Schedule / Program shromáždění v týdnu / Hafta İçi İbadeti Programı | verbatim |
| `navLmm`, `attMeetingLmm` | the meeting name inside that title: Midweek meeting / Shromáždění v týdnu / Hafta İçi İbadeti | verbatim (casing per app UI) |
| `sectionTreasures` | TREASURES FROM GOD’S WORD / POKLADY Z BOŽÍHO SLOVA / TANRI’NIN SÖZÜNDEKİ HAZİNELER | verbatim, ALL CAPS as printed |
| `sectionMinistry` | APPLY YOURSELF TO THE FIELD MINISTRY / ZLEPŠUJ SE VE SLUŽBĚ / TARLA HİZMETİNDE KENDİNİZİ GELİŞTİRİN | verbatim, ALL CAPS |
| `sectionLiving` | LIVING AS CHRISTIANS / ŽIVOT KŘESŤANA / HIRİSTİYANLAR OLARAK YAŞAM TARZIMIZ | verbatim, ALL CAPS |
| `partChairman` | Chairman: / Předsedající: / Başkanlık Eden: | verbatim, drop the colon |
| `partGems` | Spiritual Gems / Hledání duchovních drahokamů / Ruhi Hazineler | verbatim, drop the "(10 min.)" |
| `partBibleReading` | Bible Reading / Čtení Bible / Kutsal Kitap Okuması | verbatim |
| `partCbs` | Congregation Bible Study / Sborové studium Bible / Cemaat Kutsal Kitap İncelemesi | verbatim |
| `partCbsReader` | second half of Conductor/Reader: / Vede/Čte: / İdareci/Okuyucu: — as a noun | derived from form |
| `partAssistant`, `roleAssistant` | second half of Student/Assistant: / Student/Partner: / Öğrenci/Yardımcı: | verbatim |
| `partOpeningPrayer`, `partClosingPrayer` | from "Prayer:" / "Modlitba:" / "Dua:" + opening/closing qualifier | derived |
| `lmmClassMain` | Main Hall / Hlavní sál / Ana Salon | verbatim |
| `lmmClassN` | from the second-room name: Auxiliary Classroom / 2. sál / İkinci Salon. Use the numbered-room pattern when the language has one ("{index}. sál", "{index}. Salon"); keep a generic "Class {index}" style otherwise | derived |
| `lmmSongs` | plural of Song [Number] / Píseň č. / İlahi [No] | derived |
| `q*` qualification labels (`qTreasures`, `qGems`, `qBibleReading`, `qLiving`, `qChairman`, …) | same terms as above in sentence/title case | same wording, casing may differ |

Not on the form (app-specific, translate for clarity, don't invent
terminology): `sectionOpening`, `sectionClosing`, `partMinutes`
(use the form's minutes abbreviation: "min." / "min" / "dk."),
`weekNoSchedule`, editor strings.

### From the S-1 (congregation report)

| ARB key | Form label (E / B / TK) | Match |
|---|---|---|
| `s1Count` | Number of Reports / Počet těch, kdo podali zprávu / Rapor Sayısı | verbatim |
| `s1Studies` | Bible Studies / Biblická studia / Kutsal Kitap Tetkiki | verbatim |
| `s1Hours` | Hours / Hodiny / Saat — app appends "(total)" clarifier | official term + clarifier |
| `s1Publishers` | Publishers / Zvěstovatelé / Müjdeciler | verbatim |
| `s1AuxPioneers` | Auxiliary Pioneers / Pomocní průkopníci / Öncü Yardımcıları | verbatim |
| `s1RegPioneers` | Regular Pioneers / Pravidelní průkopníci / Daimi Öncüler | verbatim |
| `s1Active` | Active Publishers / Činní zvěstovatelé / Faal Müjdeciler — app appends the "(reported at least once in the last 6 months)" explanation | official term + explanation |
| `s1AvgWeekend` | Average Weekend Meeting Attendance / Průměrná návštěvnost shromáždění o víkendu / Hafta Sonu İbadetine Ortalama Katılım | verbatim |
| `s1AvgMid` | not on the form — mirror the weekend phrasing with the midweek meeting name | derived |
| `navWeekend`, `attMeetingWeekend` | the weekend-meeting name inside the attendance label: Weekend Meeting / shromáždění o víkendu / Hafta Sonu İbadeti | verbatim |

`s1Note` is app-specific explanatory text — translate freely but reuse the
official group names in it.

### From the S-21 (publisher record) — everything here prints on the exported PDF, so match it exactly

| ARB key | Form label (E / B / TK) |
|---|---|
| `s21Title` | CONGREGATION’S PUBLISHER RECORD / KARTA SBOROVÉHO ZVĚSTOVATELE / CEMAAT MÜJDECİ KAYIT KARTI |
| `s21Name` | Name: / Jméno: / İsim: |
| `s21DateOfBirth` | Date of birth: / Datum narození: / Doğum tarihi: |
| `s21DateOfBaptism` | Date of baptism: / Datum křtu: / Vaftiz tarihi: |
| `genderMale` / `genderFemale` | Male / Muž / Erkek — Female / Žena / Kadın |
| `hopeOtherSheep` / `hopeAnointed` | Other sheep / Jiná ovce / Başka koyun — Anointed / Pomazaný / Meshedilmiş |
| `appointmentElder` / `appointmentMinisterialServant` | Elder / Starší / İhtiyar — Ministerial servant / Služební pomocník / Hizmet görevlisi |
| `statusRegPioneer` / `statusSpecialPioneer` / `statusFieldMissionary` | Regular pioneer / Pravidelný průkopník / Daimi öncü — Special pioneer / Zvláštní průkopník / Özel öncü — Field missionary / Misionář / Görevli vaiz |
| `statusAuxPioneer` | table column: Auxiliary Pioneer / Pomocný průkopník / Öncü Yardımcısı |
| `serviceYear` | Service Year / Služební rok / Hizmet Yılı (+ `{year}`) |
| `reportParticipated` | Shared in Ministry / Byl ve službě / Hizmete Katıldım — the app may deviate for gender-neutral UI (cs uses "Byl/a ve službě"); a deliberate, documented exception |
| `reportStudies` | Bible Studies / Biblická studia / Kutsal Kitap Tetkiki. If the form abbreviates ("K.K. Tetkiki"), expand using the S-1's unabbreviated wording |
| `s21HoursHeader` | Hours (If pioneer or field missionary) / Hodiny (pokud je průkopník nebo misionář) / Saat (Eğer öncü ya da görevli vaiz ise) |
| `s21Remarks` | Remarks / Poznámky / Açıklamalar |
| `s21Total` | Total / Celkem / Toplam |
| `s21FormCode` | the footer, verbatim: `S-21-E 11/23` → `S-21-<CODE> <version>` for the new language's card |

`statusPublisher` is not on these forms; take it from the S-1 row
("Publisher" singular of `s1Publishers`).

### Not derivable from these three forms

Weekend-meeting terms (`weekendTalkTitle`, `weekendSpeaker`, `weekendWtReader`,
`qPublicTalk`), support roles (`supportAttendants`, `qAttendant`, microphones,
audio/video), public witnessing, field-service meetings. Sources, in order of
preference: an official form if one exists (add it to `example-forms/`),
the Meeting Workbook / Watchtower in that language on jw.org, or the
established local congregation usage. Flag any term you could not source
officially in the PR description.

## 4. Hardcoded per-language Dart lists (the ARB alone is not enough)

Import parsers match against **publication text**, so each new language must
extend these lists. Take the wording from a real Meeting Workbook epub and a
real S-21 PDF in that language, not from your ARB translations.

1. **`lib/features/lmm_schedule/epub_import/mwb_parser.dart`**
   - month-name map (like `_enMonths`/`_csMonths`/`_trMonths`) — use the
     grammatical form that appears in the weekly date ranges (Czech needs
     genitive!);
   - `_songPattern` — the word for "song" (SONG|PÍSEŇ|İLAHİ…);
   - `_durationPattern` — the minutes abbreviation (min|dk|…);
   - `_sectionFromText` — the three section headings (fallback only; current
     epubs are detected structure-first via `dc-icon--gem/wheat/sheep`);
   - gems / bible-reading / CBS keyword lists in `parseWeekDocument`.
   Keywords are compared via `_matchKey`: **uppercase, diacritics kept,
   Turkish `İ` folded to `I`** — write keywords accordingly (e.g.
   `'KUTSAL KITAP OKUMASI'`, `'DUCHOVNÍCH DRAHOKAMŮ'`). Prefer a distinctive
   substring over the full heading; keep old variants as legacy.
2. **`lib/features/lmm_schedule/lmm_screen.dart` → `_talkTitleKeywords`** —
   the workbook title of the student "Talk" part (en `talk`, cs `proslov`,
   tr `konuşma`), lowercase. Drives the brother-only/no-assistant rule.
3. **`lib/features/publishers/s21/s21_import_parser.dart`** —
   `_labelPhrases` (one entry per label from the official S-21) and
   `_monthPhrases`. Entries must be **pre-normalized** the way
   `_normalizeToken` produces them: lowercase, diacritics stripped, ASCII
   letters/digits only, no spaces (`"Datum narození"` → `datumnarozeni`).
   If the new alphabet has letters missing from `_diacriticsMap`, extend the
   map. Also check `_creditRe` covers the language's word for credit hours.
4. **`lib/features/weekend_schedule/talk_catalog/s99_parser.dart`** —
   language-independent (numbers + titles); normally no change.

## 5. Remaining plumbing

- `lib/l10n/app_<locale>.arb` + run `flutter gen-l10n` (config in
  `l10n.yaml`; generated files under `lib/l10n/generated/` are committed).
- Language picker: add `language<Name>` key to all ARB files and a
  `PopupMenuItem` in `lib/core/l10n/language_menu_button.dart`.
- `supportedLocales` comes from the generated `AppLocalizations` — no manual
  registration beyond the ARB file.
- Workbook online check (CDN): verify the pub-media API language symbol used
  by the workbook fetch matches `<CODE>`.

## 6. Style rules & pitfalls

- Section names stay **ALL CAPS** exactly as printed, including diacritics
  (`ŽIVOT KŘESŤANA`, not `Život křesťana` and not `ZIVOT KRESTANA`).
- Copy typographic apostrophes/quotes as printed (`GOD’S`, `TANRI’NIN`).
- Turkish dotted/dotless i: `İbadeti` vs `Ibadeti` are different words —
  never ASCII-fold display strings (folding is only for parser match keys).
- When the same concept appears in multiple keys (`sectionLiving` vs
  `qLiving`, `statusRegPioneer` vs `s1RegPioneers`), keep the **same official
  term**, adjusting only casing/number.
- Explanatory app additions are welcome *around* the official term, in
  parentheses — see `s1Active`, `s1Hours` — never instead of it.

## 7. Verification checklist

1. `flutter gen-l10n` reports 0 untranslated messages for the new locale;
   `flutter analyze` clean.
2. `flutter test` — extend `test/mwb_parser_test.dart` with a legacy-format
   fixture week in the new language (copy the wording from a real workbook,
   like the existing `_csWeek`/`_trWeek`).
3. Import a real `mwb_<CODE>_*.epub`: sections, gems/bible-reading/CBS types
   and songs all detected.
4. Import a filled official S-21 PDF in the language: profile fields,
   statuses and monthly rows land correctly.
5. Export the S-21 and the midweek schedule PDF in the new language and
   diff every label against `example-forms/S-21_<CODE>.pdf` and
   `S-140_<CODE>.docx`.
