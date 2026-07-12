# Congregation Setup Guide (First Admin)

This app is **self-hosted**: your congregation's data lives in your own free
Google Firebase project. Nobody else — including the app authors — can access
it. Setting it up takes about 15 minutes and requires no programming.

You need: a Google account and a computer with a web browser.

## 1. Create a Firebase project

1. Open <https://console.firebase.google.com> and sign in.
2. Click **Add project** (Create a project).
3. Name it e.g. `congregation-mytown` → **Continue**.
4. Disable Google Analytics (not needed) → **Create project**.
5. Stay on the free **Spark** plan — the app is designed to never need billing.

## 2. Enable Email/Password sign-in

1. In the left menu: **Security → Authentication** → **Get started**.
2. Tab **Sign-in method** → **Email/Password** → enable the first toggle
   (leave "Email link" off) → **Save**.

## 3. Create the Firestore database

1. Left menu: **Databases & Storage → Firestore** → **Create database**.
2. Choose Standard edition
3. Choose a location close to you (e.g. `europe-west3` for Central Europe).
   This cannot be changed later.
4. Start in **production mode** → **Create**.

## 4. Install the security rules

The rules decide who may read and write which data (e.g. only verified
publishers can see schedules, only you can edit them).

1. In **Firestore Database**, open the **Rules** tab.
2. Delete everything in the editor.
3. Copy the entire contents of the file [`firestore.rules`](../firestore.rules)
   from this project and paste it in.
4. Click **Publish**.

> Re-do this step whenever a new app version ships an updated
> `firestore.rules` file. In particular, self-service **"Delete my account"**
> only works once the current rules are published (they let a user remove
> their own publisher record).

## 5. Get the app configuration

1. Click the ⚙️ gear icon (top left) → **Project settings**.
2. Make sure you are on the **General** tab at the top of the page.
3. Click the **Web** icon (`</>`).
3. Nickname: `congregation-app` → **Register app** (no hosting needed).
4. You will see a code block containing `const firebaseConfig = { ... }`.
   Copy just the part between `{` and `}` **including the braces**, e.g.:

   ```json
   {
     "apiKey": "AIza....",
     "authDomain": "congregation-mytown.firebaseapp.com",
     "projectId": "congregation-mytown",
     "storageBucket": "congregation-mytown.firebasestorage.app",
     "messagingSenderId": "1234567890",
     "appId": "1:1234567890:web:abc123"
   }
   ```

   This configuration is **not a secret** — it only identifies your project;
   the security rules from step 4 are what protect the data.

## 6. First run of the app

1. Install / open the app. On first start it shows the **Setup** screen.
2. Paste the configuration JSON from step 5 (or scan it as a QR code if you
   have one) → **Connect**.
3. Choose **"I'm setting up a new congregation"**.
4. Enter the congregation name and register with your e-mail and a password.
   You are now the first administrator with full rights.

## 7. Invite the other publishers

1. In the app: **Admin → Publishers → Invite**.
2. Show them the QR code (or send the invite link). Scanning it configures
   their app automatically; they register with their own e-mail + password.
3. New members appear in **Admin → Publishers** as *unverified*. Open each
   one, check their identity, and tick **Verified** — only then can they see
   any congregation data.
4. Grant additional rights (schedule editing, reports, …) per person in the
   same screen, and set what they can be assigned to under **Assign**.

## Troubleshooting

- **"Permission denied" everywhere** → step 4 (rules) was skipped or the user
  is not verified yet.
- **Registration fails** → Email/Password provider not enabled (step 2).
- **"Client is offline" / connection errors** → Firestore database not
  created yet (step 3), or the pasted config JSON is incomplete.
