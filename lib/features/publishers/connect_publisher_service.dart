import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/data/fsm_repository.dart';
import '../../core/data/lmm_repository.dart';
import '../../core/data/ministry_groups_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/data/pw_repository.dart';
import '../../core/data/reports_repository.dart';
import '../../core/data/schedule_config_repository.dart';
import '../../core/data/territories_repository.dart';
import '../../core/data/weekend_repository.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';

/// Sections of the connect migration, in execution order; reported through
/// `onProgress` so the UI can show what is running (and what failed).
enum ConnectSection {
  reports,
  territories,
  groups,
  lmm,
  weekend,
  publicWitnessing,
  fieldServiceMeetings,
  profile,
}

/// Connects an admin-created publisher record (random doc id,
/// `hasAccount == false`) to a self-registered account (doc id == auth uid):
/// rewrites every reference to the record's id onto the uid, merges the two
/// publisher docs, and deletes the record.
///
/// Firestore doc ids are immutable and there are no Cloud Functions on the
/// Spark plan, so this runs as a client-side migration. It is NOT atomic;
/// instead every step is idempotent and the record is deleted last, so the
/// record stays the source of truth until everything moved and a failed run
/// can simply be retried until it converges.
///
/// The caller must be a full admin — the writes span every role-gated
/// collection (firestore.rules would deny anyone else; the UI additionally
/// hides the action).
class ConnectPublisherService {
  ConnectPublisherService({
    required this.publishers,
    required this.reports,
    required this.territories,
    required this.groups,
    required this.lmm,
    required this.weekend,
    required this.pw,
    required this.fsm,
    required this.scheduleConfig,
  });

  final PublishersRepository publishers;
  final ReportsRepository reports;
  final TerritoriesRepository territories;
  final MinistryGroupsRepository groups;
  final LmmRepository lmm;
  final WeekendRepository weekend;
  final PwRepository pw;
  final FsmRepository fsm;
  final ScheduleConfigRepository scheduleConfig;

  Future<void> connect({
    required String recordId,
    required String accountUid,
    void Function(ConnectSection section)? onProgress,
    DateTime? now,
  }) async {
    final record = await publishers.getOne(recordId);
    final account = await publishers.getOne(accountUid);
    if (record == null || account == null) {
      throw StateError('connect: publisher doc missing');
    }
    if (recordId == accountUid || record.hasAccount || !account.hasAccount) {
      throw StateError('connect: not a record/account pair');
    }
    // account.verified is deliberately NOT required to be false: a retry
    // after a partial failure runs with the account already verified.

    onProgress?.call(ConnectSection.reports);
    await reports.migratePublisherId(
        recordId, accountUid, _reportMonths(now ?? DateTime.now()));

    onProgress?.call(ConnectSection.territories);
    await territories.reassignPublisher(recordId, accountUid);

    onProgress?.call(ConnectSection.groups);
    await groups.replaceDesignations(recordId, accountUid);

    onProgress?.call(ConnectSection.lmm);
    await lmm.replaceAssigneeInAll(recordId, accountUid);
    await scheduleConfig.replaceAssignee(
        ScheduleConfigDoc.lmm, recordId, accountUid);

    onProgress?.call(ConnectSection.weekend);
    await weekend.replaceAssigneeInAll(recordId, accountUid);
    await scheduleConfig.replaceAssignee(
        ScheduleConfigDoc.weekend, recordId, accountUid);

    onProgress?.call(ConnectSection.publicWitnessing);
    await pw.replaceAssigneeInAll(recordId, accountUid);

    onProgress?.call(ConnectSection.fieldServiceMeetings);
    await fsm.replaceAssigneeInAll(recordId, accountUid);

    onProgress?.call(ConnectSection.profile);
    // Registration only ever fills first name, last name and e-mail, and an
    // awaiting account has no profile editor at all — so those three are the
    // only values the newly created account may impose on the merged profile
    // (the person knows their own spelling; the e-mail is the login
    // identity). Every other field is merged so that the connect can never
    // destroy information: the admin-curated record wins wherever it holds a
    // real value, and wherever it sits at its default the account's value —
    // which an admin may well have filled in on the account before noticing
    // the duplicate record — is kept instead of being blanked.
    final merged = record.copyWith(
      id: accountUid,
      firstName: account.firstName.isNotEmpty
          ? account.firstName
          : record.firstName,
      lastName:
          account.lastName.isNotEmpty ? account.lastName : record.lastName,
      gender: record.gender != Gender.unknown ? record.gender : account.gender,
      status: record.status != PublisherStatus.publisher
          ? record.status
          : account.status,
      appointment: record.appointment != Appointment.none
          ? record.appointment
          : account.appointment,
      qualifications:
          _unionQualifications(record.qualifications, account.qualifications),
      groupId: (record.groupId?.isNotEmpty ?? false)
          ? record.groupId
          : account.groupId,
      verified: true,
      hasAccount: true,
      moved: false,
      roles: _unionRoles(record.roles, account.roles),
    );
    await publishers.update(merged);

    final recordPrivate =
        await publishers.getPrivate(recordId) ?? const PublisherPrivate();
    final accountPrivate =
        await publishers.getPrivate(accountUid) ?? const PublisherPrivate();
    // Same rule as the public doc: the record is authoritative, but every
    // field it leaves blank falls back to the account, so personal data
    // entered on the account before the connect (e.g. birth/baptism dates) is
    // preserved instead of wiped. The login e-mail is the one field the
    // account always wins (auth identity).
    String pick(String r, String a) => r.isNotEmpty ? r : a;
    await publishers.setPrivate(
        accountUid,
        PublisherPrivate(
          email: pick(accountPrivate.email, recordPrivate.email),
          phone: pick(recordPrivate.phone, accountPrivate.phone),
          address: pick(recordPrivate.address, accountPrivate.address),
          birthDate: pick(recordPrivate.birthDate, accountPrivate.birthDate),
          baptismDate:
              pick(recordPrivate.baptismDate, accountPrivate.baptismDate),
          hope: recordPrivate.hope != Hope.otherSheep
              ? recordPrivate.hope
              : accountPrivate.hope,
          // Kept in sync with the denormalized public appointment on `merged`.
          appointment: merged.appointment,
          emergencyNote:
              pick(recordPrivate.emergencyNote, accountPrivate.emergencyNote),
        ));

    // Away periods live in a sub-document that the delete below wipes along
    // with the record, so they have to be carried over explicitly. Union of
    // both sides, deduplicated (identical spans are equal by value) and
    // sorted, so a retry after a partial failure converges instead of
    // piling up duplicates.
    final recordAway = await publishers.getAway(recordId);
    if (recordAway.periods.isNotEmpty) {
      final accountAway = await publishers.getAway(accountUid);
      final periods = <AwayPeriod>[
        ...accountAway.periods,
        for (final p in recordAway.periods)
          if (!accountAway.periods.contains(p)) p,
      ]..sort((a, b) => a.startDate.compareTo(b.startDate));
      await publishers.setAway(accountUid, PublisherAway(periods: periods));
    }

    // Delete last: the record stays the source of truth until every
    // reference has been moved. Removes the doc, its private profile and its
    // away periods.
    await publishers.delete(recordId);
  }

  /// Month keys probed for report entries: the current service year and
  /// [AppConfig.connectReportsHistoryYears] - 1 before it. Older entries
  /// cannot be found client-side (the publisher id only lives in the doc id).
  static List<String> _reportMonths(DateTime now) {
    final current = serviceYearOf(now);
    return [
      for (var y = current;
          y > current - AppConfig.connectReportsHistoryYears;
          y--)
        ...serviceYearMonths(y),
    ];
  }

  /// Never drop something either side is already marked as able to do.
  static Qualifications _unionQualifications(
          Qualifications a, Qualifications b) =>
      Qualifications(
        chairman: a.chairman || b.chairman,
        prayer: a.prayer || b.prayer,
        treasures: a.treasures || b.treasures,
        gems: a.gems || b.gems,
        bibleReading: a.bibleReading || b.bibleReading,
        fieldMinistry: a.fieldMinistry || b.fieldMinistry,
        livingParts: a.livingParts || b.livingParts,
        cbsConductor: a.cbsConductor || b.cbsConductor,
        cbsReader: a.cbsReader || b.cbsReader,
        publicTalk: a.publicTalk || b.publicTalk,
        weekendChairman: a.weekendChairman || b.weekendChairman,
        wtReader: a.wtReader || b.wtReader,
        attendant: a.attendant || b.attendant,
        microphone: a.microphone || b.microphone,
        audioVideo: a.audioVideo || b.audioVideo,
        publicWitnessing: a.publicWitnessing || b.publicWitnessing,
        ministryMeetingConductor:
            a.ministryMeetingConductor || b.ministryMeetingConductor,
      );

  /// Never drop a privilege either side already has.
  static Roles _unionRoles(Roles a, Roles b) => Roles(
        infoBoard: a.infoBoard || b.infoBoard,
        events: a.events || b.events,
        lmmSchedule: a.lmmSchedule || b.lmmSchedule,
        weekendSchedule: a.weekendSchedule || b.weekendSchedule,
        publicWitnessing: a.publicWitnessing || b.publicWitnessing,
        fieldServiceMeetings: a.fieldServiceMeetings || b.fieldServiceMeetings,
        territories: a.territories || b.territories,
        reports: a.reports || b.reports,
        attendance: a.attendance || b.attendance,
        recordAttendance: a.recordAttendance || b.recordAttendance,
        publishers: a.publishers || b.publishers,
        fullAdmin: a.fullAdmin || b.fullAdmin,
      );
}

final connectPublisherServiceProvider = Provider<ConnectPublisherService>(
  (ref) => ConnectPublisherService(
    publishers: ref.watch(publishersRepositoryProvider),
    reports: ref.watch(reportsRepositoryProvider),
    territories: ref.watch(territoriesRepositoryProvider),
    groups: ref.watch(ministryGroupsRepositoryProvider),
    lmm: ref.watch(lmmRepositoryProvider),
    weekend: ref.watch(weekendRepositoryProvider),
    pw: ref.watch(pwRepositoryProvider),
    fsm: ref.watch(fsmRepositoryProvider),
    scheduleConfig: ref.watch(scheduleConfigRepositoryProvider),
  ),
);
