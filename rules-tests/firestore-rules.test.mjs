// Firestore security rules tests. Run from rules-tests/ with:
//   npm test
// (starts the Firestore emulator via firebase-tools; requires Java 11+)
import { readFileSync } from 'node:fs';
import { after, before, beforeEach, describe, it } from 'node:test';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  query,
  setDoc,
  updateDoc,
  where,
} from 'firebase/firestore';

/** @type {import('@firebase/rules-unit-testing').RulesTestEnvironment} */
let env;

const FOUNDER = 'founder-uid';
const FULL_ADMIN = 'full-admin-uid';
const ADMIN = 'admin-uid'; // publishers + reports admin
const LMM_ADMIN = 'lmm-admin-uid';
const WEEKEND_ADMIN = 'weekend-admin-uid';
const FSM_ADMIN = 'fsm-admin-uid';
const ATTENDANCE_ADMIN = 'attendance-admin-uid';
const PW_ADMIN = 'pw-admin-uid';
const VERIFIED = 'verified-uid';
const UNVERIFIED = 'unverified-uid';
// Verified publisher with the public-witnessing qualification.
const QUALIFIED = 'qualified-uid';

const basePublisher = {
  firstName: 'Test',
  lastName: 'User',
  gender: 'male',
  status: 'publisher',
  verified: true,
  hasAccount: true,
  roles: {
    infoBoard: false,
    events: false,
    lmmSchedule: false,
    weekendSchedule: false,
    publicWitnessing: false,
    fieldServiceMeetings: false,
    territories: false,
    reports: false,
    attendance: false,
    publishers: false,
    fullAdmin: false,
  },
  qualifications: {},
};

function db(uid) {
  return env.authenticatedContext(uid).firestore();
}

async function seed() {
  await env.withSecurityRulesDisabled(async (ctx) => {
    const f = ctx.firestore();
    await setDoc(doc(f, 'congregation/meta'), {
      name: 'Test Cong',
      founderUid: FOUNDER,
    });
    await setDoc(doc(f, `publishers/${FULL_ADMIN}`), {
      ...basePublisher,
      roles: { ...basePublisher.roles, fullAdmin: true },
    });
    await setDoc(doc(f, `publishers/${ADMIN}`), {
      ...basePublisher,
      roles: { ...basePublisher.roles, publishers: true, reports: true },
    });
    await setDoc(doc(f, `publishers/${LMM_ADMIN}`), {
      ...basePublisher,
      roles: { ...basePublisher.roles, lmmSchedule: true },
    });
    await setDoc(doc(f, `publishers/${WEEKEND_ADMIN}`), {
      ...basePublisher,
      roles: { ...basePublisher.roles, weekendSchedule: true },
    });
    await setDoc(doc(f, `publishers/${FSM_ADMIN}`), {
      ...basePublisher,
      roles: { ...basePublisher.roles, fieldServiceMeetings: true },
    });
    await setDoc(doc(f, `publishers/${ATTENDANCE_ADMIN}`), {
      ...basePublisher,
      roles: { ...basePublisher.roles, attendance: true },
    });
    await setDoc(doc(f, `publishers/${PW_ADMIN}`), {
      ...basePublisher,
      roles: { ...basePublisher.roles, publicWitnessing: true },
    });
    await setDoc(doc(f, `publishers/${QUALIFIED}`), {
      ...basePublisher,
      qualifications: { publicWitnessing: true },
    });
    await setDoc(doc(f, `publishers/${VERIFIED}`), { ...basePublisher });
    await setDoc(doc(f, `publishers/${UNVERIFIED}`), {
      ...basePublisher,
      verified: false,
    });
    await setDoc(doc(f, `publishers/${VERIFIED}/private/profile`), {
      email: 'v@example.com',
      phone: '123',
      birthDate: '1990-01-01',
      emergencyNote: 'call mom',
    });
    await setDoc(doc(f, 'lmm_weeks/2026-07-06'), {
      parts: [],
      allAssigneeIds: [],
    });
    await setDoc(doc(f, 'territory_assignments/ta1'), {
      territoryId: 't1',
      publisherId: VERIFIED,
      assignedDate: '2026-06-01',
      returnedDate: '',
      returnNotes: '',
    });
    await setDoc(doc(f, 'reports/2026-06/entries/' + VERIFIED), {
      month: '2026-06',
      participated: true,
    });
    await setDoc(doc(f, 'attendance/2026-06-01_weekend'), {
      date: '2026-06-01',
      meetingType: 'weekend',
      inPerson: 50,
      online: 10,
    });
    await setDoc(doc(f, 'public_talks/catalog'), {
      titles: { 1: 'How Well Do You Know God?' },
      updatedAt: '2026-07-01',
      source: 'S-99_E.pdf',
    });
    await setDoc(doc(f, 'fsm_meetings/m1'), {
      date: '2026-07-11',
      time: '09:00',
      location: 'Kingdom Hall',
      assignment: { publisherIds: [], freeText: '' },
      recurringId: '',
      cancelled: false,
      allAssigneeIds: [],
    });
    await setDoc(doc(f, 'pw_slots/slot1'), {
      date: '2026-08-01',
      startTime: '09:00',
      endTime: '11:00',
      location: 'Town square',
      assignment: { publisherIds: [], freeText: '' },
      recurringId: '',
      cancelled: false,
      allAssigneeIds: [],
    });
    await setDoc(doc(f, `pw_applications/slot1_${QUALIFIED}`), {
      slotId: 'slot1',
      date: '2026-08-01',
      publisherId: QUALIFIED,
      appliedAt: null,
    });
    await setDoc(doc(f, 'pw_applications/slot1_other-uid'), {
      slotId: 'slot1',
      date: '2026-08-01',
      publisherId: 'other-uid',
      appliedAt: null,
    });
  });
}

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-rules-test',
    firestore: { rules: readFileSync('../firestore.rules', 'utf8') },
  });
});

beforeEach(async () => {
  await env.clearFirestore();
  await seed();
});

after(async () => {
  await env.cleanup();
});

describe('unverified users', () => {
  it('cannot read congregation data', async () => {
    await assertFails(getDoc(doc(db(UNVERIFIED), 'lmm_weeks/2026-07-06')));
    await assertFails(
      getDocs(collection(db(UNVERIFIED), 'events')),
    );
    await assertFails(
      getDoc(doc(db(UNVERIFIED), `publishers/${VERIFIED}`)),
    );
  });

  it('can read own publisher doc and congregation meta', async () => {
    await assertSucceeds(
      getDoc(doc(db(UNVERIFIED), `publishers/${UNVERIFIED}`)),
    );
    await assertSucceeds(getDoc(doc(db(UNVERIFIED), 'congregation/meta')));
  });

  it('self-registration must be unverified without roles', async () => {
    const newUid = 'newcomer';
    await assertSucceeds(
      setDoc(doc(db(newUid), `publishers/${newUid}`), {
        ...basePublisher,
        verified: false,
      }),
    );
    await env.clearFirestore();
    await seed();
    await assertFails(
      setDoc(doc(db(newUid), `publishers/${newUid}`), {
        ...basePublisher,
        verified: true,
      }),
    );
    await assertFails(
      setDoc(doc(db(newUid), `publishers/${newUid}`), {
        ...basePublisher,
        verified: false,
        roles: { ...basePublisher.roles, fullAdmin: true },
      }),
    );
  });
});

describe('privilege escalation', () => {
  it('publisher cannot verify themselves or grant roles', async () => {
    await assertFails(
      updateDoc(doc(db(UNVERIFIED), `publishers/${UNVERIFIED}`), {
        verified: true,
      }),
    );
    await assertFails(
      updateDoc(doc(db(VERIFIED), `publishers/${VERIFIED}`), {
        'roles.fullAdmin': true,
      }),
    );
    await assertFails(
      updateDoc(doc(db(VERIFIED), `publishers/${VERIFIED}`), {
        'qualifications.publicTalk': true,
      }),
    );
  });

  it('publisher can edit their own profile fields', async () => {
    await assertSucceeds(
      updateDoc(doc(db(VERIFIED), `publishers/${VERIFIED}`), {
        firstName: 'Changed',
        status: 'auxPioneer',
      }),
    );
  });

  it('publishers-admin can verify and grant roles', async () => {
    await assertSucceeds(
      updateDoc(doc(db(ADMIN), `publishers/${UNVERIFIED}`), {
        verified: true,
      }),
    );
    await assertSucceeds(
      updateDoc(doc(db(ADMIN), `publishers/${VERIFIED}`), {
        'roles.lmmSchedule': true,
      }),
    );
  });
});

describe('founder bootstrap', () => {
  it('meta can only be created, never re-created', async () => {
    // Seeded meta exists: a signed-in user cannot overwrite it.
    await assertFails(
      setDoc(doc(db('someone'), 'congregation/meta'), {
        name: 'Hijack',
        founderUid: 'someone',
      }),
    );
  });

  it('fresh project: first creator wins and becomes founder', async () => {
    await env.clearFirestore();
    await assertSucceeds(
      setDoc(doc(db(FOUNDER), 'congregation/meta'), {
        name: 'New Cong',
        founderUid: FOUNDER,
      }),
    );
    // Founder may create their own privileged publisher doc.
    await assertSucceeds(
      setDoc(doc(db(FOUNDER), `publishers/${FOUNDER}`), {
        ...basePublisher,
        verified: true,
        roles: { ...basePublisher.roles, fullAdmin: true },
      }),
    );
    // A non-founder cannot create a verified doc for themselves.
    await assertFails(
      setDoc(doc(db('other'), 'publishers/other'), {
        ...basePublisher,
        verified: true,
        roles: { ...basePublisher.roles, fullAdmin: true },
      }),
    );
  });

  it('cannot claim founding with someone else as founderUid', async () => {
    await env.clearFirestore();
    await assertFails(
      setDoc(doc(db('mallory'), 'congregation/meta'), {
        name: 'X',
        founderUid: FOUNDER,
      }),
    );
  });
});

describe('congregation settings', () => {
  it('full admin updates congregation meta', async () => {
    await assertSucceeds(
      setDoc(
        doc(db(FULL_ADMIN), 'congregation/meta'),
        { name: 'Renamed Cong' },
        { merge: true },
      ),
    );
  });

  it('full admin re-creates absent meta only with own founderUid', async () => {
    // Mirrors the client fix: when congregation/meta is missing, the Settings
    // save becomes a create and must stamp the caller's uid as founderUid.
    await env.clearFirestore();
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), `publishers/${FULL_ADMIN}`), {
        ...basePublisher,
        roles: { ...basePublisher.roles, fullAdmin: true },
      });
    });
    await assertFails(
      setDoc(
        doc(db(FULL_ADMIN), 'congregation/meta'),
        { name: 'Rebuilt', founderUid: FOUNDER },
        { merge: true },
      ),
    );
    await assertSucceeds(
      setDoc(
        doc(db(FULL_ADMIN), 'congregation/meta'),
        { name: 'Rebuilt', founderUid: FULL_ADMIN },
        { merge: true },
      ),
    );
  });

  it('verified non-admin cannot update congregation meta', async () => {
    await assertFails(
      setDoc(
        doc(db(VERIFIED), 'congregation/meta'),
        { name: 'Hijack' },
        { merge: true },
      ),
    );
  });
});

describe('section roles', () => {
  it('verified publishers read schedules but cannot write', async () => {
    await assertSucceeds(
      getDoc(doc(db(VERIFIED), 'lmm_weeks/2026-07-06')),
    );
    await assertFails(
      setDoc(doc(db(VERIFIED), 'lmm_weeks/2026-07-13'), { parts: [] }),
    );
  });

  it('lmm admin writes lmm but not weekend', async () => {
    await assertSucceeds(
      setDoc(doc(db(LMM_ADMIN), 'lmm_weeks/2026-07-13'), { parts: [] }),
    );
    await assertFails(
      setDoc(doc(db(LMM_ADMIN), 'weekend_weeks/2026-07-13'), {}),
    );
  });
});

describe('public witnessing slots', () => {
  it('verified publisher reads slots but cannot write', async () => {
    await assertSucceeds(getDoc(doc(db(VERIFIED), 'pw_slots/slot1')));
    await assertFails(
      setDoc(doc(db(VERIFIED), 'pw_slots/slot2'), { date: '2026-08-02' }),
    );
    await assertFails(
      setDoc(doc(db(VERIFIED), 'pw_recurring/r1'), { weekday: 6 }),
    );
  });

  it('only the pw admin writes slots', async () => {
    await assertSucceeds(
      setDoc(doc(db(PW_ADMIN), 'pw_slots/slot2'), { date: '2026-08-02' }),
    );
    await assertFails(
      setDoc(doc(db(LMM_ADMIN), 'pw_slots/slot3'), { date: '2026-08-03' }),
    );
  });
});

describe('public witnessing applications', () => {
  const application = (slotId, uid) => ({
    slotId,
    date: '2026-08-08',
    publisherId: uid,
    appliedAt: null,
  });

  it('qualified publisher applies, incl. for a virtual slot id', async () => {
    await assertSucceeds(
      setDoc(
        doc(db(QUALIFIED), `pw_applications/rule1_2026-08-08_${QUALIFIED}`),
        application('rule1_2026-08-08', QUALIFIED),
      ),
    );
  });

  it('doc id must be {slotId}_{uid}', async () => {
    await assertFails(
      setDoc(
        doc(db(QUALIFIED), `pw_applications/mismatch_${QUALIFIED}`),
        application('rule1_2026-08-08', QUALIFIED),
      ),
    );
  });

  it('cannot apply on behalf of someone else', async () => {
    await assertFails(
      setDoc(
        doc(db(QUALIFIED), 'pw_applications/rule1_2026-08-08_other-uid'),
        application('rule1_2026-08-08', 'other-uid'),
      ),
    );
  });

  it('unqualified and unverified publishers cannot apply', async () => {
    await assertFails(
      setDoc(
        doc(db(VERIFIED), `pw_applications/rule1_2026-08-08_${VERIFIED}`),
        application('rule1_2026-08-08', VERIFIED),
      ),
    );
    await assertFails(
      setDoc(
        doc(db(UNVERIFIED), `pw_applications/rule1_2026-08-08_${UNVERIFIED}`),
        application('rule1_2026-08-08', UNVERIFIED),
      ),
    );
  });

  it('rejects extra fields and malformed dates', async () => {
    await assertFails(
      setDoc(
        doc(db(QUALIFIED), `pw_applications/rule1_2026-08-08_${QUALIFIED}`),
        { ...application('rule1_2026-08-08', QUALIFIED), note: 'pick me' },
      ),
    );
    await assertFails(
      setDoc(
        doc(db(QUALIFIED), `pw_applications/rule1_2026-08-08_${QUALIFIED}`),
        { ...application('rule1_2026-08-08', QUALIFIED), date: 'whenever' },
      ),
    );
  });

  it('publisher lists only own applications', async () => {
    await assertSucceeds(
      getDocs(
        query(
          collection(db(QUALIFIED), 'pw_applications'),
          where('publisherId', '==', QUALIFIED),
        ),
      ),
    );
    await assertFails(
      getDocs(collection(db(QUALIFIED), 'pw_applications')),
    );
    await assertFails(
      getDoc(doc(db(QUALIFIED), 'pw_applications/slot1_other-uid')),
    );
  });

  it('pw admin sees all applications, other admins none', async () => {
    await assertSucceeds(
      getDocs(collection(db(PW_ADMIN), 'pw_applications')),
    );
    await assertSucceeds(
      getDocs(
        query(
          collection(db(PW_ADMIN), 'pw_applications'),
          where('date', '>=', '2026-07-27'),
          where('date', '<=', '2026-08-02'),
        ),
      ),
    );
    await assertFails(
      getDocs(collection(db(LMM_ADMIN), 'pw_applications')),
    );
  });

  it('publisher withdraws own application only', async () => {
    await assertSucceeds(
      deleteDoc(doc(db(QUALIFIED), `pw_applications/slot1_${QUALIFIED}`)),
    );
    await assertFails(
      deleteDoc(doc(db(QUALIFIED), 'pw_applications/slot1_other-uid')),
    );
  });

  it('pw admin deletes any application', async () => {
    await assertSucceeds(
      deleteDoc(doc(db(PW_ADMIN), 'pw_applications/slot1_other-uid')),
    );
  });

  it('applications are immutable once created', async () => {
    await assertFails(
      updateDoc(doc(db(QUALIFIED), `pw_applications/slot1_${QUALIFIED}`), {
        date: '2026-08-02',
      }),
    );
    await assertFails(
      updateDoc(doc(db(PW_ADMIN), `pw_applications/slot1_${QUALIFIED}`), {
        date: '2026-08-02',
      }),
    );
  });
});

describe('private profiles', () => {
  it('only self and publishers-admin read private data', async () => {
    await assertSucceeds(
      getDoc(doc(db(VERIFIED), `publishers/${VERIFIED}/private/profile`)),
    );
    await assertSucceeds(
      getDoc(doc(db(ADMIN), `publishers/${VERIFIED}/private/profile`)),
    );
    await assertFails(
      getDoc(
        doc(db(LMM_ADMIN), `publishers/${VERIFIED}/private/profile`),
      ),
    );
  });

  it('email is immutable for account holders', async () => {
    await assertFails(
      updateDoc(doc(db(VERIFIED), `publishers/${VERIFIED}/private/profile`), {
        email: 'other@example.com',
      }),
    );
    await assertSucceeds(
      updateDoc(doc(db(VERIFIED), `publishers/${VERIFIED}/private/profile`), {
        phone: '999',
      }),
    );
  });

  it('self edits baptism date and hope, not appointment', async () => {
    await assertSucceeds(
      updateDoc(doc(db(VERIFIED), `publishers/${VERIFIED}/private/profile`), {
        baptismDate: '2005-06-11',
        hope: 'anointed',
      }),
    );
    await assertFails(
      updateDoc(doc(db(VERIFIED), `publishers/${VERIFIED}/private/profile`), {
        appointment: 'elder',
      }),
    );
  });

  it('self full-doc save on a legacy doc keeps appointment at default', async () => {
    // The app always rewrites the whole document; the seeded doc predates
    // the appointment field.
    const fullDoc = {
      email: 'v@example.com',
      phone: '123',
      address: '',
      birthDate: '1990-01-01',
      baptismDate: '2005-06-11',
      hope: 'otherSheep',
      emergencyNote: 'call mom',
    };
    await assertSucceeds(
      setDoc(doc(db(VERIFIED), `publishers/${VERIFIED}/private/profile`), {
        ...fullDoc,
        appointment: 'none',
      }),
    );
    await assertFails(
      setDoc(doc(db(VERIFIED), `publishers/${VERIFIED}/private/profile`), {
        ...fullDoc,
        appointment: 'ministerialServant',
      }),
    );
  });

  it('self must carry an admin-set appointment through unchanged', async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(
        doc(ctx.firestore(), `publishers/${VERIFIED}/private/profile`),
        { email: 'v@example.com', appointment: 'elder' },
      );
    });
    await assertSucceeds(
      setDoc(doc(db(VERIFIED), `publishers/${VERIFIED}/private/profile`), {
        email: 'v@example.com',
        phone: '999',
        appointment: 'elder',
      }),
    );
    await assertFails(
      setDoc(doc(db(VERIFIED), `publishers/${VERIFIED}/private/profile`), {
        email: 'v@example.com',
        phone: '999',
        appointment: 'none',
      }),
    );
  });

  it('self create may not set an appointment', async () => {
    await assertFails(
      setDoc(
        doc(db(LMM_ADMIN), `publishers/${LMM_ADMIN}/private/profile`),
        { email: 'lmm@example.com', appointment: 'elder' },
      ),
    );
    await assertSucceeds(
      setDoc(
        doc(db(LMM_ADMIN), `publishers/${LMM_ADMIN}/private/profile`),
        { email: 'lmm@example.com', appointment: 'none' },
      ),
    );
  });

  it('publishers-admin sets appointment on others', async () => {
    await assertSucceeds(
      updateDoc(doc(db(ADMIN), `publishers/${VERIFIED}/private/profile`), {
        appointment: 'elder',
      }),
    );
  });
});

describe('reports', () => {
  it('publisher writes own entry, cannot touch others', async () => {
    await assertSucceeds(
      setDoc(doc(db(VERIFIED), `reports/2026-07/entries/${VERIFIED}`), {
        month: '2026-07',
        participated: true,
      }),
    );
    await assertFails(
      setDoc(doc(db(VERIFIED), `reports/2026-07/entries/${ADMIN}`), {
        month: '2026-07',
        participated: true,
      }),
    );
    await assertFails(
      getDoc(doc(db(VERIFIED), `reports/2026-06/entries/${ADMIN}`)),
    );
  });

  it('reports-admin reads the month and enters paper reports', async () => {
    await assertSucceeds(
      getDocs(collection(db(ADMIN), 'reports/2026-06/entries')),
    );
    await assertSucceeds(
      setDoc(doc(db(ADMIN), `reports/2026-06/entries/paper-person`), {
        month: '2026-06',
        participated: true,
      }),
    );
  });
});

describe('territory assignments', () => {
  it('publisher lists only own assignments', async () => {
    await assertSucceeds(
      getDocs(
        query(
          collection(db(VERIFIED), 'territory_assignments'),
          where('publisherId', '==', VERIFIED),
        ),
      ),
    );
    await assertFails(
      getDocs(collection(db(VERIFIED), 'territory_assignments')),
    );
  });

  it('publisher may only return their own territory', async () => {
    await assertSucceeds(
      updateDoc(doc(db(VERIFIED), 'territory_assignments/ta1'), {
        returnedDate: '2026-07-08',
        returnNotes: 'done',
      }),
    );
    await assertFails(
      updateDoc(doc(db(VERIFIED), 'territory_assignments/ta1'), {
        publisherId: 'someone-else',
      }),
    );
    await assertFails(
      deleteDoc(doc(db(VERIFIED), 'territory_assignments/ta1')),
    );
  });
});

describe('public talk titles catalog', () => {
  it('verified publisher reads the catalog but cannot write', async () => {
    await assertSucceeds(getDoc(doc(db(VERIFIED), 'public_talks/catalog')));
    await assertFails(
      setDoc(doc(db(VERIFIED), 'public_talks/catalog'), {
        titles: { 1: 'Hijacked' },
      }),
    );
  });

  it('unverified user cannot read the catalog', async () => {
    await assertFails(getDoc(doc(db(UNVERIFIED), 'public_talks/catalog')));
  });

  it('weekend admin can replace the catalog', async () => {
    await assertSucceeds(
      setDoc(doc(db(WEEKEND_ADMIN), 'public_talks/catalog'), {
        titles: { 1: 'How Well Do You Know God?', 2: 'New Title' },
        updatedAt: '2026-07-10',
        source: 'S-99_B.pdf',
      }),
    );
  });

  it('weekend admin writes weekend weeks carrying a talk number', async () => {
    await assertSucceeds(
      setDoc(doc(db(WEEKEND_ADMIN), 'weekend_weeks/2026-07-13'), {
        talkTitle: 'How Well Do You Know God?',
        talkNo: 1,
        allAssigneeIds: [],
      }),
    );
  });
});

describe('field service meetings', () => {
  it('verified publisher reads meetings but cannot write', async () => {
    await assertSucceeds(getDoc(doc(db(VERIFIED), 'fsm_meetings/m1')));
    await assertFails(
      setDoc(doc(db(VERIFIED), 'fsm_meetings/m2'), {
        date: '2026-07-18',
        time: '09:00',
      }),
    );
  });

  it('unverified user cannot read meetings', async () => {
    await assertFails(getDoc(doc(db(UNVERIFIED), 'fsm_meetings/m1')));
  });

  it('fsm admin writes meetings and recurring rules', async () => {
    await assertSucceeds(
      setDoc(doc(db(FSM_ADMIN), 'fsm_meetings/m2'), {
        date: '2026-07-18',
        time: '09:00',
        location: 'Kingdom Hall',
        assignment: { publisherIds: [], freeText: '' },
        recurringId: '',
        cancelled: false,
        allAssigneeIds: [],
      }),
    );
    await assertSucceeds(
      setDoc(doc(db(FSM_ADMIN), 'fsm_recurring/r1'), {
        weekday: 6,
        time: '09:00',
        location: 'Kingdom Hall',
        defaultAssignment: { publisherIds: [], freeText: '' },
        validFrom: '2026-07-01',
        validUntil: '',
      }),
    );
  });

  it('other section admins cannot write fsm collections', async () => {
    await assertFails(
      setDoc(doc(db(LMM_ADMIN), 'fsm_meetings/m3'), { date: '2026-07-18' }),
    );
    await assertFails(
      setDoc(doc(db(LMM_ADMIN), 'fsm_recurring/r2'), { weekday: 6 }),
    );
  });
});

describe('attendance', () => {
  it('verified publisher without the attendance role cannot read or write', async () => {
    await assertFails(
      getDoc(doc(db(VERIFIED), 'attendance/2026-06-01_weekend')),
    );
    await assertFails(
      setDoc(doc(db(VERIFIED), 'attendance/2026-07-05_weekend'), {
        date: '2026-07-05',
        meetingType: 'weekend',
        inPerson: 40,
        online: 5,
      }),
    );
  });

  it('attendance admin can read and write entries', async () => {
    await assertSucceeds(
      getDoc(doc(db(ATTENDANCE_ADMIN), 'attendance/2026-06-01_weekend')),
    );
    await assertSucceeds(
      setDoc(doc(db(ATTENDANCE_ADMIN), 'attendance/2026-07-05_weekend'), {
        date: '2026-07-05',
        meetingType: 'weekend',
        inPerson: 40,
        online: 5,
      }),
    );
  });
});
