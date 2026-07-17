import '../../core/models/models.dart';

/// Pure statistics computations for the admin Statistics screen.
///
/// Everything here is derived from data the app already stores (publishers,
/// private profiles, reports, attendance) — no telemetry is collected.
/// Publishers marked [Publisher.moved] are excluded from every figure.

/// Publishers on the active roster: not moved away. Records with status
/// 'none' stay in [total] (they are members the congregation tracks) but are
/// excluded from publisher/pioneer counts, mirroring the S-1 rules.
List<Publisher> activeRoster(List<Publisher> all) =>
    all.where((p) => !p.moved).toList();

// ---------------------------------------------------------------------------
// Membership & pioneers
// ---------------------------------------------------------------------------

class MembershipStats {
  const MembershipStats({
    required this.total,
    required this.byStatus,
    required this.pioneers,
    required this.elders,
    required this.ministerialServants,
    required this.byGender,
    required this.groupSizes,
    required this.ungrouped,
  });

  /// Everyone on the active roster (including status 'none').
  final int total;

  /// Count per status, only statuses that occur (status 'none' included
  /// under its own key so the card can show it as "not a publisher").
  final Map<PublisherStatus, int> byStatus;

  /// All pioneer statuses combined ([Publisher.isPioneer]).
  final int pioneers;
  final int elders;
  final int ministerialServants;
  final Map<Gender, int> byGender;

  /// Group name -> member count, insertion-ordered by the given group list.
  final Map<String, int> groupSizes;

  /// Active roster members without a ministry group.
  final int ungrouped;
}

MembershipStats computeMembership(
    List<Publisher> all, List<MinistryGroup> groups) {
  final roster = activeRoster(all);
  final byStatus = <PublisherStatus, int>{};
  final byGender = <Gender, int>{};
  var elders = 0, servants = 0, pioneers = 0;
  for (final p in roster) {
    byStatus[p.status] = (byStatus[p.status] ?? 0) + 1;
    byGender[p.gender] = (byGender[p.gender] ?? 0) + 1;
    if (p.isPioneer) pioneers++;
    if (p.appointment == Appointment.elder) elders++;
    if (p.appointment == Appointment.ministerialServant) servants++;
  }
  final groupSizes = <String, int>{
    for (final g in groups)
      g.name: roster.where((p) => p.groupId == g.id).length,
  };
  final groupIds = groups.map((g) => g.id).toSet();
  final ungrouped = roster
      .where((p) => p.groupId == null || !groupIds.contains(p.groupId))
      .length;
  return MembershipStats(
    total: roster.length,
    byStatus: byStatus,
    pioneers: pioneers,
    elders: elders,
    ministerialServants: servants,
    byGender: byGender,
    groupSizes: groupSizes,
    ungrouped: ungrouped,
  );
}

// ---------------------------------------------------------------------------
// Age distribution
// ---------------------------------------------------------------------------

/// Age bands shown on the statistics screen, in display order.
enum AgeBand { under18, from18to29, from30to44, from45to64, over65, unknown }

class AgeStats {
  const AgeStats({required this.byBand, required this.averageAge});

  final Map<AgeBand, int> byBand;

  /// Mean age of everyone with a known birth date; null when nobody has one.
  final double? averageAge;

  int get known =>
      byBand.entries.fold(0, (sum, e) => sum + (e.key == AgeBand.unknown ? 0 : e.value));
}

/// Whole years between [birth] and [asOf], counting a birthday not yet
/// reached this year as one year less.
int ageInYears(DateTime birth, DateTime asOf) {
  var age = asOf.year - birth.year;
  final hadBirthday = asOf.month > birth.month ||
      (asOf.month == birth.month && asOf.day >= birth.day);
  if (!hadBirthday) age--;
  return age;
}

AgeBand bandOf(int age) => switch (age) {
      < 18 => AgeBand.under18,
      < 30 => AgeBand.from18to29,
      < 45 => AgeBand.from30to44,
      < 65 => AgeBand.from45to64,
      _ => AgeBand.over65,
    };

/// [birthDates] carries one entry per roster member; null = unknown.
AgeStats computeAges(List<DateTime?> birthDates, DateTime asOf) {
  final byBand = <AgeBand, int>{for (final b in AgeBand.values) b: 0};
  var sum = 0, known = 0;
  for (final birth in birthDates) {
    if (birth == null) {
      byBand[AgeBand.unknown] = byBand[AgeBand.unknown]! + 1;
      continue;
    }
    final age = ageInYears(birth, asOf);
    byBand[bandOf(age)] = byBand[bandOf(age)]! + 1;
    sum += age;
    known++;
  }
  return AgeStats(
    byBand: byBand,
    averageAge: known == 0 ? null : sum / known,
  );
}

// ---------------------------------------------------------------------------
// Meeting attendance
// ---------------------------------------------------------------------------

class AttendanceStats {
  const AttendanceStats({
    required this.avg3Months,
    required this.avg12Months,
    required this.monthlySeries,
  });

  /// type -> average over the last 3 / 12 calendar months; null = no data.
  final Map<MeetingType, int?> avg3Months;
  final Map<MeetingType, int?> avg12Months;

  /// month key (yyyy-MM) -> type -> monthly average; months sorted ascending,
  /// spanning the last 12 months that have any data.
  final Map<String, Map<MeetingType, int>> monthlySeries;
}

AttendanceStats computeAttendance(List<AttendanceEntry> entries,
    {required String currentMonth}) {
  // month -> type -> totals of individual meetings.
  final byMonth = <String, Map<MeetingType, List<int>>>{};
  for (final e in entries) {
    if (e.date.length < 7 || !e.hasData) continue;
    final month = e.date.substring(0, 7);
    if (month.compareTo(currentMonth) > 0) continue;
    byMonth
        .putIfAbsent(month, () => {})
        .putIfAbsent(e.meetingType, () => [])
        .add(e.resolvedTotal);
  }
  final months = byMonth.keys.toList()..sort();
  final last12 = months.length <= 12
      ? months
      : months.sublist(months.length - 12);
  final last3 = last12.length <= 3
      ? last12
      : last12.sublist(last12.length - 3);

  int? averageOver(List<String> monthKeys, MeetingType type) {
    final totals = [
      for (final m in monthKeys) ...?byMonth[m]?[type],
    ];
    if (totals.isEmpty) return null;
    return (totals.reduce((a, b) => a + b) / totals.length).round();
  }

  int? monthlyAvg(String month, MeetingType type) {
    final totals = byMonth[month]?[type];
    if (totals == null || totals.isEmpty) return null;
    return (totals.reduce((a, b) => a + b) / totals.length).round();
  }

  return AttendanceStats(
    avg3Months: {
      for (final t in MeetingType.values) t: averageOver(last3, t),
    },
    avg12Months: {
      for (final t in MeetingType.values) t: averageOver(last12, t),
    },
    monthlySeries: {
      for (final m in last12)
        m: {
          for (final t in MeetingType.values)
            if (monthlyAvg(m, t) != null) t: monthlyAvg(m, t)!,
        },
    },
  );
}

// ---------------------------------------------------------------------------
// Field service (service-year rollup)
// ---------------------------------------------------------------------------

class FieldServiceStats {
  const FieldServiceStats({
    required this.totalHours,
    required this.totalStudies,
    required this.pioneerHours,
    required this.publisherHours,
    required this.reportsSubmitted,
    required this.participated,
    required this.monthsWithData,
  });

  /// Field service + credit hours across the service year.
  final int totalHours;
  final int totalStudies;

  /// Hours split by the status snapshot on each report.
  final int pioneerHours;
  final int publisherHours;

  /// Report documents present across the year (one per publisher per month).
  final int reportsSubmitted;

  /// Reports with participated == true.
  final int participated;

  /// Months of the service year that have at least one report.
  final int monthsWithData;
}

/// [monthReports] holds one list per month of the service year (12 entries,
/// possibly empty lists for months without data).
FieldServiceStats computeFieldService(List<List<MinistryReport>> monthReports) {
  var hours = 0, studies = 0, pioneerHours = 0, publisherHours = 0;
  var submitted = 0, participated = 0, monthsWithData = 0;
  for (final month in monthReports) {
    if (month.isNotEmpty) monthsWithData++;
    for (final r in month) {
      submitted++;
      if (r.participated) participated++;
      hours += r.totalHours;
      studies += r.bibleStudies ?? 0;
      final pioneer = r.statusAtMonth != PublisherStatus.publisher &&
          r.statusAtMonth != PublisherStatus.none;
      if (pioneer) {
        pioneerHours += r.totalHours;
      } else {
        publisherHours += r.totalHours;
      }
    }
  }
  return FieldServiceStats(
    totalHours: hours,
    totalStudies: studies,
    pioneerHours: pioneerHours,
    publisherHours: publisherHours,
    reportsSubmitted: submitted,
    participated: participated,
    monthsWithData: monthsWithData,
  );
}

// ---------------------------------------------------------------------------
// App usage (derived — no tracking)
// ---------------------------------------------------------------------------

class AppUsageStats {
  const AppUsageStats({
    required this.total,
    required this.withAccount,
    required this.awaitingVerification,
    required this.fullAdmins,
    required this.sectionAdmins,
    required this.selfReported,
    required this.adminEntered,
  });

  final int total;

  /// Roster members who registered an app login.
  final int withAccount;

  /// Registered but not yet verified by an admin.
  final int awaitingVerification;
  final int fullAdmins;

  /// Members with at least one section role but not fullAdmin.
  final int sectionAdmins;

  /// Last month's reports entered by the publishers themselves vs by an
  /// admin (paper reports) — a proxy for real app adoption.
  final int selfReported;
  final int adminEntered;
}

AppUsageStats computeAppUsage(
    List<Publisher> all, List<MinistryReport> lastMonthReports) {
  final roster = activeRoster(all);
  var withAccount = 0, awaiting = 0, fullAdmins = 0, sectionAdmins = 0;
  for (final p in roster) {
    if (p.hasAccount) withAccount++;
    if (p.hasAccount && !p.verified) awaiting++;
    if (p.roles.fullAdmin) {
      fullAdmins++;
    } else if (p.roles.any) {
      sectionAdmins++;
    }
  }
  final selfReported =
      lastMonthReports.where((r) => r.enteredBy == 'self').length;
  return AppUsageStats(
    total: roster.length,
    withAccount: withAccount,
    awaitingVerification: awaiting,
    fullAdmins: fullAdmins,
    sectionAdmins: sectionAdmins,
    selfReported: selfReported,
    adminEntered: lastMonthReports.length - selfReported,
  );
}
