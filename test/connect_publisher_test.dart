import 'package:congregation_scheduler/core/data/fsm_repository.dart';
import 'package:congregation_scheduler/core/data/lmm_repository.dart';
import 'package:congregation_scheduler/core/data/ministry_groups_repository.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/data/pw_repository.dart';
import 'package:congregation_scheduler/core/data/reports_repository.dart';
import 'package:congregation_scheduler/core/data/schedule_config_repository.dart';
import 'package:congregation_scheduler/core/data/territories_repository.dart';
import 'package:congregation_scheduler/core/data/weekend_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/publishers/connect_publisher_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

/// Connecting an admin-created record (random doc id, no account) to a
/// self-registered account (doc id == auth uid): every reference to the
/// record's id is rewritten onto the uid, the publisher docs are merged
/// (account keeps its typed name and login e-mail, the record wins
/// everything else) and the record is deleted last.
void main() {
  const recordId = 'rec-1';
  const uid = 'uid-1';
  final now = DateTime(2026, 7, 14); // service year 2026

  late FakeFirebaseFirestore db;
  late PublishersRepository publishers;
  late ReportsRepository reports;
  late ConnectPublisherService service;

  Future<bool> exists(String path) async => (await db.doc(path).get()).exists;

  setUp(() async {
    db = FakeFirebaseFirestore();
    publishers = PublishersRepository(db);
    reports = ReportsRepository(db);
    service = ConnectPublisherService(
      publishers: publishers,
      reports: reports,
      territories: TerritoriesRepository(db),
      groups: MinistryGroupsRepository(db),
      lmm: LmmRepository(db),
      weekend: WeekendRepository(db),
      pw: PwRepository(db),
      fsm: FsmRepository(db),
      scheduleConfig: ScheduleConfigRepository(db),
    );

    // The admin-curated record (no login) and the freshly registered account.
    await publishers.createWithId(
      recordId,
      const Publisher(
        firstName: 'Jana',
        lastName: 'Novakova',
        gender: Gender.female,
        status: PublisherStatus.regularPioneer,
        verified: true,
        hasAccount: false,
        groupId: 'g1',
        qualifications:
            Qualifications(fieldMinistry: true, publicWitnessing: true),
      ),
    );
    await publishers.setPrivate(
        recordId,
        const PublisherPrivate(
            phone: '+420 777 000 000',
            address: 'Street 1',
            baptismDate: '2000-05-01'));
    await publishers.createWithId(
      uid,
      const Publisher(
          firstName: 'Jana', lastName: 'Nováková', hasAccount: true),
    );
    await publishers.setPrivate(
        uid, const PublisherPrivate(email: 'jana@example.com'));

    // Reports: one record-only month, one colliding month (both reported),
    // one outside the probed window (documented limitation: stays behind).
    await reports.submit(const MinistryReport(
        publisherId: recordId,
        month: '2026-05',
        participated: true,
        hours: 30));
    await reports.submit(const MinistryReport(
        publisherId: recordId, month: '2026-06', hours: 10));
    await reports.submit(const MinistryReport(
        publisherId: uid, month: '2026-06', participated: true, hours: 55));
    await reports.submit(const MinistryReport(
        publisherId: recordId, month: '2015-03', hours: 5));

    await TerritoriesRepository(db).assign(const TerritoryAssignment(
        territoryId: 't1', publisherId: recordId, assignedDate: '2026-01-10'));

    await MinistryGroupsRepository(db).saveGroup(const MinistryGroup(
        id: 'g1', name: 'Group 1', overseerId: recordId, assistantId: 'x'));

    await LmmRepository(db).saveWeek(const LmmWeek(
      id: '2026-07-13',
      parts: [
        LmmPart(assignment: Assignment(publisherIds: [recordId])),
      ],
      attendants: Assignment(publisherIds: [recordId, 'other']),
    ));

    await WeekendRepository(db).saveWeek(const WeekendWeek(
      id: '2026-07-13',
      speaker: Assignment(publisherIds: [recordId]),
      // The account was also picked here — the merge must deduplicate.
      chairman: Assignment(publisherIds: [recordId, uid]),
    ));

    await ScheduleConfigRepository(db).saveConfig(
        ScheduleConfigDoc.lmm,
        const ScheduleConfig(permanentAssignments: [
          CustomAssignment(
              id: 'perm1',
              label: 'Cleaning',
              assignment: Assignment(publisherIds: [recordId])),
        ]));

    final pw = PwRepository(db);
    await pw.saveSlot(const PwSlot(
        id: 'slot1',
        date: '2026-07-18',
        assignment: Assignment(publisherIds: [recordId])));
    await pw.saveRecurring(const PwRecurring(
        id: 'rule1',
        defaultAssignment: Assignment(publisherIds: [recordId])));

    final fsm = FsmRepository(db);
    await fsm.saveMeeting(const FsmMeeting(
        id: 'm1',
        date: '2026-07-18',
        assignment: Assignment(publisherIds: [recordId])));
    await fsm.saveRecurring(const FsmRecurring(
        id: 'frule1',
        defaultAssignment: Assignment(publisherIds: [recordId])));
  });

  test('moves history onto the account, merges docs, deletes the record',
      () async {
    final sections = <ConnectSection>[];
    await service.connect(
        recordId: recordId,
        accountUid: uid,
        onProgress: sections.add,
        now: now);

    // Progress reported in execution order.
    expect(sections, ConnectSection.values);

    // Merged publisher doc: account's typed name and login e-mail win,
    // the record wins everything else; verified with union'd (no) roles.
    final merged = await publishers.getOne(uid);
    expect(merged, isNotNull);
    expect(merged!.firstName, 'Jana');
    expect(merged.lastName, 'Nováková');
    expect(merged.gender, Gender.female);
    expect(merged.status, PublisherStatus.regularPioneer);
    expect(merged.qualifications.fieldMinistry, isTrue);
    expect(merged.verified, isTrue);
    expect(merged.hasAccount, isTrue);
    expect(merged.groupId, 'g1');
    final private = await publishers.getPrivate(uid);
    expect(private!.email, 'jana@example.com');
    expect(private.phone, '+420 777 000 000');
    expect(private.baptismDate, '2000-05-01');

    // The record and its private profile are gone.
    expect(await exists('publishers/$recordId'), isFalse);
    expect(await exists('publishers/$recordId/private/profile'), isFalse);

    // Reports moved; on the colliding month the account's own entry wins.
    final may = await db.doc('reports/2026-05/entries/$uid').get();
    expect(may.data()!['hours'], 30);
    expect(await exists('reports/2026-05/entries/$recordId'), isFalse);
    final june = await db.doc('reports/2026-06/entries/$uid').get();
    expect(june.data()!['hours'], 55);
    expect(await exists('reports/2026-06/entries/$recordId'), isFalse);
    // Outside the probed window: stays behind (documented limitation).
    expect(await exists('reports/2015-03/entries/$recordId'), isTrue);

    // Territory assignment rewritten.
    final territory =
        await db.collection('territory_assignments').get();
    expect(territory.docs.single.data()['publisherId'], uid);

    // Group overseer designation rewritten, assistant untouched.
    final group = (await db.doc('ministry_groups/g1').get()).data()!;
    expect(group['overseerId'], uid);
    expect(group['assistantId'], 'x');

    // LMM week: part + attendants + denormalized union rewritten.
    final lmmWeek = (await db.doc('lmm_weeks/2026-07-13').get()).data()!;
    expect(lmmWeek['parts'][0]['assignment']['publisherIds'], [uid]);
    expect(lmmWeek['attendants']['publisherIds'], [uid, 'other']);
    expect(lmmWeek['allAssigneeIds'], ['other', uid]);

    // Weekend week: speaker rewritten; chairman deduplicated.
    final weekend =
        (await db.doc('weekend_weeks/2026-07-13').get()).data()!;
    expect(weekend['speaker']['publisherIds'], [uid]);
    expect(weekend['chairman']['publisherIds'], [uid]);

    // Permanent custom-assignment template rewritten.
    final config = (await db.doc('schedule_config/lmm').get()).data()!;
    expect(config['permanentAssignments'][0]['assignment']['publisherIds'],
        [uid]);

    // PW slot + recurring rule rewritten.
    final slot = (await db.doc('pw_slots/slot1').get()).data()!;
    expect(slot['assignment']['publisherIds'], [uid]);
    expect(slot['allAssigneeIds'], [uid]);
    final rule = (await db.doc('pw_recurring/rule1').get()).data()!;
    expect(rule['defaultAssignment']['publisherIds'], [uid]);

    // FSM meeting + recurring rule rewritten.
    final meeting = (await db.doc('fsm_meetings/m1').get()).data()!;
    expect(meeting['assignment']['publisherIds'], [uid]);
    final frule = (await db.doc('fsm_recurring/frule1').get()).data()!;
    expect(frule['defaultAssignment']['publisherIds'], [uid]);
  });

  test('preserves account private data the record lacks; record wins conflicts',
      () async {
    // Birth date entered on the account before connecting; the record has no
    // birth date but does have a phone that must win the conflict.
    await publishers.setPrivate(
        uid,
        const PublisherPrivate(
          email: 'jana@example.com',
          birthDate: '1990-03-15',
          phone: 'account-phone',
        ));

    await service.connect(recordId: recordId, accountUid: uid, now: now);

    final private = (await publishers.getPrivate(uid))!;
    expect(private.birthDate, '1990-03-15'); // kept from account
    expect(private.baptismDate, '2000-05-01'); // from record
    expect(private.phone, '+420 777 000 000'); // record wins the conflict
    expect(private.email, 'jana@example.com'); // account login identity
  });

  test('works when the account was already verified (retry path)', () async {
    final account = await publishers.getOne(uid);
    await publishers.update(account!.copyWith(verified: true));

    await service.connect(recordId: recordId, accountUid: uid, now: now);

    expect(await exists('publishers/$recordId'), isFalse);
    expect((await publishers.getOne(uid))!.verified, isTrue);
  });

  test('reference migrations are idempotent (safe to re-run)', () async {
    final months = ['2026-05', '2026-06'];
    await reports.migratePublisherId(recordId, uid, months);
    await reports.migratePublisherId(recordId, uid, months);
    final june = await db.doc('reports/2026-06/entries/$uid').get();
    expect(june.data()!['hours'], 55);

    final lmm = LmmRepository(db);
    await lmm.replaceAssigneeInAll(recordId, uid);
    await lmm.replaceAssigneeInAll(recordId, uid);
    final week = (await db.doc('lmm_weeks/2026-07-13').get()).data()!;
    expect(week['attendants']['publisherIds'], [uid, 'other']);
  });

  test('rejects anything but a record/account pair', () async {
    // Two accounts.
    await publishers.createWithId(
        'uid-2', const Publisher(firstName: 'B', hasAccount: true));
    await expectLater(
        service.connect(recordId: 'uid-2', accountUid: uid, now: now),
        throwsStateError);
    // Two records.
    await publishers.createWithId(
        'rec-2', const Publisher(firstName: 'C', hasAccount: false));
    await expectLater(
        service.connect(recordId: recordId, accountUid: 'rec-2', now: now),
        throwsStateError);
    // Same doc.
    await expectLater(
        service.connect(recordId: uid, accountUid: uid, now: now),
        throwsStateError);
    // Missing doc.
    await expectLater(
        service.connect(recordId: 'nope', accountUid: uid, now: now),
        throwsStateError);
    // Nothing was migrated or deleted by the failed attempts.
    expect(await exists('publishers/$recordId'), isTrue);
    expect(await exists('reports/2026-05/entries/$recordId'), isTrue);
  });
}
