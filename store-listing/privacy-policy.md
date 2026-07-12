# Privacy Policy — Congregation Scheduler

**Last updated:** [DATE — fill in on publish]

Congregation Scheduler ("the app") is developed independently by
[DEVELOPER NAME / PLACEHOLDER] ("we", "us"). This policy explains what data
the app handles and, importantly, **who controls it** — because of how the
app is built, that is usually not us.

> **This app is not affiliated with, endorsed by, or produced by the Watch
> Tower Bible and Tract Society or any official Jehovah's Witnesses entity.**
> It is an independent, unofficial tool built for congregations to
> self-host their own scheduling data.

## 1. The app is self-hosted — we do not run a server

Congregation Scheduler has no central backend operated by us. Each
congregation's administrator creates and owns a **free Firebase project**
under their own Google account, and the app connects directly to that
project. This means:

- Your congregation's data lives in infrastructure your own administrator
  controls, not on servers we operate.
- We (the app developer) have **no access, login, or backdoor** to any
  congregation's data. We cannot see, export, or delete it — only your
  congregation's administrator(s) can, through their own Firebase console.
- Each congregation's administrator is effectively the data controller for
  that congregation's data. If you have questions about how your specific
  congregation's data is handled, contact your local administrator first.

## 2. What data the app collects, and where it goes

All of the data below is written directly from your device to **your
congregation's own Firebase project** (Google Cloud infrastructure, in
whatever region your administrator selected when creating it). None of it
passes through, or is stored by, any server we operate.

| Category | Examples | Notes |
|---|---|---|
| Account data | E-mail address, password (handled by Firebase Authentication) | Needed to sign in |
| Profile data | Name, phone number, birth date, an emergency-contact note | Entered by you or an administrator; visible only to you and administrators with the relevant role |
| Scheduling & assignment data | Meeting parts, roles, qualifications, attendance counts | Visible to verified members of your congregation per their granted roles |
| Ministry activity | Field-service reports, monthly summaries | Entered by you or an administrator |
| Territory data | Addresses/notes you or your congregation enter, map links | Text you type in, not derived from device location |
| Files you upload | PDFs, images attached to the information board or reports | Stored (chunked) inside your congregation's Firestore database, capped at 10 MB per file |

We do **not** collect analytics, usage statistics, advertising identifiers,
or crash reports. The app contains no analytics SDK, no advertising SDK,
and no third-party tracker of any kind — only Firebase Authentication and
Firestore (the database), both operated by Google on behalf of your
congregation's administrator.

## 3. Device permissions

| Permission | Why the app asks for it |
|---|---|
| Camera | To scan a congregation's invitation QR code during setup/registration |
| Photo library | To pick a previously-saved QR code image instead of scanning live |
| Calendar | To add a meeting or assignment to your device calendar, only when you choose to |
| Contacts | Required by the underlying calendar-event API on some platforms; the app does not read or store your contacts |
| Internet | To communicate with your congregation's Firebase project |

The app requests each permission only at the moment it's needed for the
action you took, and none of them are used for tracking.

## 4. Who can see your data

Access is controlled by Firestore security rules published by your
congregation's administrator (the app ships a reference rules file that
every self-hosted instance uses). In short:

- Nothing is visible until an administrator marks your account "verified."
- Sensitive fields (e-mail, phone, birth date, emergency note) are only
  readable by you and administrators with publisher-management rights.
- Administrators can grant granular roles (e.g. schedule editing, reports)
  to other verified members.

## 5. Third parties

The only third party involved is **Google Firebase**, which provides the
authentication and database infrastructure your congregation's
administrator chose to use. We do not sell data, share it with advertisers,
or transmit it anywhere else. Google's own privacy practices for Firebase
apply to data at that layer; see
[Google's Privacy Policy](https://policies.google.com/privacy) and
[Firebase's data processing terms](https://firebase.google.com/terms/data-processing-terms).

## 6. Data retention & deletion

Because there is no central server, data retention is controlled entirely
by your congregation's administrator through their Firebase project:

- You can permanently delete your own account from within the app, at any
  time, under **My profile → Delete my account** (also available from the
  awaiting-verification and complete-profile screens before you are
  verified). This removes your login and your personal profile (name,
  contact details and other profile fields). Ministry reports you already
  submitted remain part of the congregation's records.
- An administrator can remove a publisher record (and that publisher's
  private profile data) from within the app.
- An administrator can delete data, or the entire Firebase project, at any
  time from the Firebase console — this permanently removes the
  congregation's data.

## 7. Children's data

The app is a scheduling tool used by congregation administrators and
members generally acting in a volunteer capacity; it is not directed at
children, and we do not knowingly collect data specifically from children
independent of a responsible administrator entering or supervising that
data on the congregation's behalf.

## 8. Changes to this policy

If this policy changes, the "Last updated" date above will change and, for
material changes, we will note it in the app's release notes.

## 9. Contact

Questions about the app itself (not your congregation's specific data —
contact your administrator for that): **[SUPPORT EMAIL — confirm before
publishing, e.g. vskarda@gmail.com]**.
