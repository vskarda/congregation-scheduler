# CI/CD — build & publish (Android + iOS)

This project builds and publishes through GitHub Actions:

- **`.github/workflows/ci.yml`** — runs on every PR / push to `main`: format,
  analyze, tests, and Firestore rules tests. No secrets.
- **`.github/workflows/release.yml`** — **manual** (`workflow_dispatch`). Builds
  a signed Android **AAB** → a Google Play track **and** attaches AAB+APK to a
  GitHub Release; builds a signed **IPA** → App Store Connect / **TestFlight**.

> The app takes its Firebase config at runtime, so **no** Firebase files or
> secrets are needed in CI.

---

## 1. What you need up front

| Account | Cost | Used for |
|---|---|---|
| Google Play Developer | $25 once | Play upload |
| Apple Developer Program | $99 / yr | iOS signing + TestFlight |
| A JDK with `keytool` | free | Android keystore (you have Temurin under `C:\Users\Buse\java\`) |
| OpenSSL for Windows | free | iOS certificate `.p12` (see §3.2) |

The app identifiers are already set:

- Android `applicationId`: `org.jwscheduler.congregation_scheduler`
- iOS bundle id: `org.jwscheduler.congregationScheduler`

---

## 2. The GitHub secrets you will create

Add each one at **GitHub → repo → Settings → Secrets and variables → Actions →
New repository secret**.

**Android**

| Secret | What goes in it |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | The `.jks` keystore, base64-encoded (§3.1) |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore (store) password |
| `ANDROID_KEY_ALIAS` | Key alias, e.g. `upload` |
| `ANDROID_KEY_PASSWORD` | Key password (often same as store password) |
| `PLAY_SERVICE_ACCOUNT_JSON` | Full contents of the Play service-account JSON (§3.3) |

**iOS**

| Secret | What goes in it |
|---|---|
| `IOS_DIST_CERT_P12_BASE64` | Apple Distribution cert + private key as `.p12`, base64 (§4.2) |
| `IOS_DIST_CERT_PASSWORD` | The password you set when exporting the `.p12` |
| `IOS_PROVISION_PROFILE_BASE64` | App Store `.mobileprovision`, base64 (§4.3) |
| `APPLE_TEAM_ID` | 10-char Team ID (§4.1) |
| `APPSTORE_API_KEY_ID` | App Store Connect API **Key ID** (§4.4) |
| `APPSTORE_API_ISSUER_ID` | App Store Connect API **Issuer ID** (§4.4) |
| `APPSTORE_API_PRIVATE_KEY` | Full contents of the `.p8` API key file (§4.4) |

### Encoding a binary file to base64 (Windows PowerShell)

Used for the keystore, the `.p12`, and the `.mobileprovision`:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("C:\path\to\file")) |
  Set-Content -NoNewline "C:\path\to\file.b64.txt"
```
C:\Work\jw-sch-cred\upload-keystore.jks
$bytes = [System.IO.File]::ReadAllBytes("upload-keystore.jks")
$base64 = [Convert]::ToBase64String($bytes)
$base64 | Out-File -FilePath "keystore_base64.txt"
```

Open the `.b64.txt`, copy everything, and paste it as the secret value.
(On macOS/Linux the equivalent is `base64 -w0 file`.)

For text secrets (`PLAY_SERVICE_ACCOUNT_JSON`, `APPSTORE_API_PRIVATE_KEY`) paste
the file's raw contents — **no** base64.

---

## 3. Android credentials

### 3.1 Create the upload keystore

Run once (uses `keytool` from your JDK). Pick a folder **outside** the repo:

```powershell
& "C:\Users\Buse\java\<jdk-dir>\bin\keytool.exe" -genkeypair -v `
  -keystore upload-keystore.jks -storetype JKS `
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

It prompts for a keystore password, your name/org, etc. Remember the password
and alias — they become `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`
(`upload`), and `ANDROID_KEY_PASSWORD`.

> **Back this file up somewhere safe.** If you lose it you can no longer ship
> updates to the same Play listing.

Then base64-encode it (§2) into `ANDROID_KEYSTORE_BASE64`.

### 3.2 Create the app in the Play Console (one-time, manual)

The Play Developer API can only upload to an app that already exists.

1. <https://play.google.com/console> → **Create app** → name, language, "App",
   "Free" → create.
2. Fill the minimum required store listing + content rating so the app can
   accept uploads (you can keep it in testing).
3. **Important first upload:** for a brand-new app, upload one AAB **manually**
   to the Internal testing track once (build locally with
   `flutter build appbundle` or use the AAB from a first CI run downloaded from
   the run artifacts). After that, CI uploads work.

### 3.3 Create the Play service account

1. Play Console → **Setup → API access**.
2. Link (or create) a Google Cloud project when prompted.
3. Under **Service accounts** → **Create new service account** → this opens
   Google Cloud Console → **Create service account** (name e.g.
   `play-ci-publisher`) → **Done**.
4. Back in Cloud Console → the service account → **Keys** → **Add key → Create
   new key → JSON** → download. Its **entire contents** = `PLAY_SERVICE_ACCOUNT_JSON`.
5. Back in Play Console → **API access** → find the account → **Grant access** →
   give at least **Release to testing tracks** and **Manage production releases**
   (Admin is simplest) → **Invite/Apply**.

---

## 4. iOS credentials

You'll do most of this in the Apple Developer portal + App Store Connect from a
browser on Windows; the `.p12` is built with OpenSSL (§4.2) so you don't need a
Mac.

### 4.1 Team ID  → `APPLE_TEAM_ID`

<https://developer.apple.com/account> → **Membership details** → copy the
10-character **Team ID**.

### 4.2 Apple Distribution certificate → `.p12`

Apple issues a certificate against a Certificate Signing Request (CSR). Generate
the key + CSR with OpenSSL on Windows:

```powershell
# 1) private key
openssl genrsa -out ios_dist.key 2048
# 2) CSR (fill in your email + name)
  //(does not work) openssl req -new -key ios_dist.key -out ios_dist.csr -subj "/emailAddress=vitezslav.skarda@icloud.com/CN=Vitezslav Skarda/C=CZ"
   //(this one works) MSYS_NO_PATHCONV=1 openssl req -new -key ios_dist.key -out ios_dist.csr -subj "/C=CZ/CN=Vitezslav Skarda/emailAddress=vitezslav.skarda@icloud.com"
```

3. <https://developer.apple.com/account/resources/certificates> → **+** →
   **Apple Distribution** → upload `ios_dist.csr` → **Download** the resulting
   `distribution.cer`.
4. Convert + bundle into a `.p12` (you'll be asked to set an **export password**
   — that becomes `IOS_DIST_CERT_PASSWORD`):

```powershell
openssl x509 -inform DER -in distribution.cer -out distribution.pem
openssl pkcs12 -export -legacy -inkey ios_dist.key -in distribution.pem -out ios_dist.p12
```

5. Base64-encode `ios_dist.p12` (§2) → `IOS_DIST_CERT_P12_BASE64`.

> Keep `ios_dist.key` and `ios_dist.p12` backed up privately.

### 4.3 App ID + App Store provisioning profile → `.mobileprovision`

1. **Identifiers** → **+** → **App IDs → App** → Bundle ID (explicit):
   `org.jwscheduler.congregationScheduler` → register. (Skip if it already
   exists.)
2. **Profiles** → **+** → **App Store** (Distribution) → select the App ID from
   step 1 → select the Apple Distribution certificate from §4.2 → name it e.g.
   `Congregation Scheduler App Store` → **Download** the `.mobileprovision`.
3. Base64-encode it (§2) → `IOS_PROVISION_PROFILE_BASE64`.

> The workflow reads the profile's **name** out of the file automatically, so
> you don't need to configure the name anywhere.

### 4.4 App Store Connect API key → `.p8` + IDs

1. <https://appstoreconnect.apple.com> → **Users and Access** → **Integrations**
   tab → **App Store Connect API** → **+** to generate a key.
2. Role: **App Manager** (enough to upload builds) → **Generate**.
3. **Download** the `AuthKey_XXXXX.p8` — **you can only download it once.**
4. Note the **Key ID** (next to the key) → `APPSTORE_API_KEY_ID`, and the
   **Issuer ID** (top of the Keys page) → `APPSTORE_API_ISSUER_ID`.
5. The full text of the `.p8` → `APPSTORE_API_PRIVATE_KEY`.

### 4.5 Create the app record in App Store Connect (one-time)

App Store Connect → **Apps → +** → **New App** → platform iOS, bundle id
`org.jwscheduler.congregationScheduler`, SKU (any string), name. This must exist
before the first TestFlight upload.

---

## 5. Running a release

Actions tab → **Release** → **Run workflow**:

- **platform**: `android`, `ios`, or `both`
- **play_track**: `internal` (recommended for the first run) → later `beta` /
  `production`
- **version_name** / **build_number**: leave blank to use the pubspec version
  and the GitHub run number (a monotonic build number that satisfies both stores).

Recommended first runs:

1. `platform = android`, `play_track = internal` — confirm it lands in Play
   Internal testing and a GitHub Release appears.
2. `platform = ios` — confirm the build shows up in TestFlight (it takes a few
   minutes to finish "Processing").
3. Then `both`, and graduate the Play track to `production` (uploads as a
   **draft** for you to roll out manually).

---

## 6. Gotchas / notes

- **Android first upload** must be done manually once (§3.2) — the API cannot
  create the app listing. **Symptom if you skip it:** the "Upload AAB to Google
  Play" step fails with a bare `Error: Unknown error occurred.` — that's the
  r0adkll action's generic fallback for a Play API error it can't read a message
  from, and for a new app it almost always means this manual first upload is
  still pending. The workflow's "Explain Play upload failure" step spells this
  out in the run log. The AAB to upload manually is attached to the failed run
  (Artifacts) and to the GitHub Release it created just before the Play step.
- **iOS "Processing" + compliance**: the app declares
  `ITSAppUsesNonExemptEncryption = false` in `Info.plist`, so TestFlight won't
  prompt for export compliance. The first build may still need you to accept
  TestFlight test information before external testers can use it.
- **Build numbers**: driven by the GitHub run number. If you ever reset or move
  CI, pass an explicit `build_number` higher than the last accepted one — both
  stores reject non-increasing build numbers.
- **Keystore / certs are irreplaceable-ish**: back up the `.jks`, the iOS
  `.p12`/`.key`, and the `.p8`. Losing the keystore breaks Play updates; losing
  the `.p8` just means generating a new API key.
- **macOS runner minutes** are billable (and count at a higher rate on private
  repos). iOS builds are manual-only to keep this in check.
- Local `flutter build apk/appbundle --release` still works without any keystore
  — it falls back to debug signing when `android/key.properties` is absent.
