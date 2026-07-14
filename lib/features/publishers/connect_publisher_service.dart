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
    // The admin-curated record is authoritative for everything except the
    // name the person typed at registration (they know their own spelling;
    // empty fields fall back to the record) and the login e-mail.
    final merged = record.copyWith(
      id: accountUid,
      firstName: account.firstName.isNotEmpty
          ? account.firstName
          : record.firstName,
      lastName:
          account.lastName.isNotEmpty ? account.lastName : record.lastName,
      verified: true,
      hasAccount: true,
      moved: false,
      roles: _unionRoles(record.roles, account.roles),
    );
    await publishers.update(merged);

    final recordPrivate =
        await publishers.getPrivate(recordId) ?? const PublisherPrivate();
    final accountEmail = (await publishers.getPrivate(accountUid))?.email;
    await publishers.setPrivate(
        accountUid,
        recordPrivate.copyWith(
          email: (accountEmail != null && accountEmail.isNotEmpty)
              ? accountEmail
              : recordPrivate.email,
        ));

    // Delete last: the record stays the source of truth until every
    // reference has been moved. Removes the doc and its private profile.
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
