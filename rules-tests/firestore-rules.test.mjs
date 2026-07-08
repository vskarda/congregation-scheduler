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
const ADMIN = 'admin-uid'; // publishers + reports admin
const LMM_ADMIN = 'lmm-admin-uid';
const VERIFIED = 'verified-uid';
const UNVERIFIED = 'unverified-uid';

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
    await setDoc(doc(f, `publishers/${ADMIN}`), {
      ...basePublisher,
      roles: { ...basePublisher.roles, publishers: true, reports: true },
    });
    await setDoc(doc(f, `publishers/${LMM_ADMIN}`), {
      ...basePublisher,
      roles: { ...basePublisher.roles, lmmSchedule: true },
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
