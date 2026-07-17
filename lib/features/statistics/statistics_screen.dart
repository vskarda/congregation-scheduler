import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/attendance_repository.dart';
import '../../core/data/ministry_groups_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/l10n/enum_labels.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import 'statistics_model.dart';
import 'statistics_providers.dart';

/// Full-admin, read-only congregation & app statistics. Everything shown is
/// derived from data the app already stores — no usage tracking.
class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Defensive: the nav entry and the router's /admin redirect already gate
    // this screen; render nothing if reached without full-admin rights.
    if (!ref.watch(effectiveRolesProvider).fullAdmin) {
      return const SizedBox.shrink();
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: const [
            _MembershipCard(),
            _AgeCard(),
            _AttendanceCard(),
            _FieldServiceCard(),
            _UsageCard(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared presentation widgets
// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...children,
            ],
          ),
        ),
      );
}

/// A row of prominent number tiles.
class _StatTiles extends StatelessWidget {
  const _StatTiles(this.tiles);

  /// (value, label) pairs.
  final List<(String, String)> tiles;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 24,
        runSpacing: 12,
        children: [
          for (final (value, label) in tiles)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: Theme.of(context).textTheme.titleLarge),
                Text(label, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
        ],
      );
}

/// Label + count + horizontal proportion bar.
class _StatBar extends StatelessWidget {
  const _StatBar({
    required this.label,
    required this.value,
    required this.fraction,
  });

  final String label;
  final String value;

  /// 0..1 share of the bar to fill.
  final double fraction;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(label)),
                Text(value, style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: 2),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: fraction.clamp(0.0, 1.0),
                minHeight: 6,
              ),
            ),
          ],
        ),
      );
}

class _Subtitle extends StatelessWidget {
  const _Subtitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 2),
        child: Text(text, style: Theme.of(context).textTheme.labelMedium),
      );
}

class _NoData extends StatelessWidget {
  const _NoData();

  @override
  Widget build(BuildContext context) => Text(
        context.l10n.statNoData,
        style: TextStyle(color: Theme.of(context).disabledColor),
      );
}

Widget _asyncCard<T>(
  BuildContext context,
  AsyncValue<T> async,
  String title,
  List<Widget> Function(T data) body,
) =>
    _SectionCard(
      title: title,
      children: switch (async) {
        AsyncData(:final value) => body(value),
        AsyncError(:final error) => [
            Text(context.l10n.commonErrorDetail(error.toString()))
          ],
        _ => const [
            Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            )
          ],
      },
    );

// ---------------------------------------------------------------------------
// Membership & pioneers
// ---------------------------------------------------------------------------

class _MembershipCard extends ConsumerWidget {
  const _MembershipCard();

  /// Display order: publishers first, then pioneer statuses, 'none' last.
  static const _statusOrder = [
    PublisherStatus.publisher,
    PublisherStatus.auxiliaryPioneer,
    PublisherStatus.regularPioneer,
    PublisherStatus.specialPioneer,
    PublisherStatus.fieldMissionary,
    PublisherStatus.none,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final publishersAsync = ref.watch(allPublishersProvider);
    final groups = ref.watch(ministryGroupsProvider).value ?? const [];

    return _asyncCard(context, publishersAsync, l10n.statMembershipTitle,
        (publishers) {
      final stats = computeMembership(publishers, groups);
      if (stats.total == 0) return const [_NoData()];
      final total = stats.total;
      return [
        _StatTiles([
          ('$total', l10n.statTotalMembers),
          ('${stats.pioneers}', l10n.statPioneers),
          ('${stats.elders}', l10n.appointmentElder),
          ('${stats.ministerialServants}', l10n.appointmentMinisterialServant),
        ]),
        _Subtitle(l10n.profileStatus),
        for (final status in _statusOrder)
          if ((stats.byStatus[status] ?? 0) > 0)
            _StatBar(
              label: statusLabel(l10n, status),
              value: '${stats.byStatus[status]}',
              fraction: stats.byStatus[status]! / total,
            ),
        _Subtitle(l10n.profileGender),
        for (final gender in Gender.values)
          if ((stats.byGender[gender] ?? 0) > 0)
            _StatBar(
              label: genderLabel(l10n, gender),
              value: '${stats.byGender[gender]}',
              fraction: stats.byGender[gender]! / total,
            ),
        if (stats.groupSizes.isNotEmpty) ...[
          _Subtitle(l10n.navMinistryGroups),
          for (final entry in stats.groupSizes.entries)
            _StatBar(
              label: entry.key,
              value: '${entry.value}',
              fraction: total == 0 ? 0 : entry.value / total,
            ),
          if (stats.ungrouped > 0)
            _StatBar(
              label: l10n.mgNoGroup,
              value: '${stats.ungrouped}',
              fraction: stats.ungrouped / total,
            ),
        ],
      ];
    });
  }
}

// ---------------------------------------------------------------------------
// Age distribution
// ---------------------------------------------------------------------------

class _AgeCard extends ConsumerWidget {
  const _AgeCard();

  static String _bandLabel(AppLocalizations l10n, AgeBand band) =>
      switch (band) {
        AgeBand.under18 => l10n.statAgeUnder18,
        AgeBand.from18to29 => '18–29',
        AgeBand.from30to44 => '30–44',
        AgeBand.from45to64 => '45–64',
        AgeBand.over65 => '65+',
        AgeBand.unknown => l10n.statAgeUnknown,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final birthDatesAsync = ref.watch(rosterBirthDatesProvider);

    return _asyncCard(context, birthDatesAsync, l10n.statAgeTitle,
        (birthDates) {
      final stats = computeAges(birthDates, DateTime.now());
      if (stats.known == 0) return const [_NoData()];
      final total = birthDates.length;
      return [
        _StatTiles([
          (stats.averageAge!.toStringAsFixed(0), l10n.statAgeAverage),
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            l10n.statAgeKnownDetail(stats.known, total),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 8),
        for (final band in AgeBand.values)
          if (stats.byBand[band]! > 0)
            _StatBar(
              label: _bandLabel(l10n, band),
              value: '${stats.byBand[band]}',
              fraction: stats.byBand[band]! / total,
            ),
      ];
    });
  }
}

// ---------------------------------------------------------------------------
// Meeting attendance
// ---------------------------------------------------------------------------

class _AttendanceCard extends ConsumerWidget {
  const _AttendanceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final entriesAsync = ref.watch(attendanceEntriesProvider);

    return _asyncCard(context, entriesAsync, l10n.statAttendanceTitle,
        (entries) {
      final stats = computeAttendance(entries,
          currentMonth: monthKey(DateTime.now()));
      if (stats.monthlySeries.isEmpty) return const [_NoData()];
      final monthFmt = DateFormat.yMMM(locale);
      // Bars show the most recent months; scale each type to its own peak.
      final months = stats.monthlySeries.keys.toList();
      final shown = months.length <= 6 ? months : months.sublist(months.length - 6);

      String dash(int? v) => v?.toString() ?? '—';

      List<Widget> series(MeetingType type) {
        final peak = shown
            .map((m) => stats.monthlySeries[m]?[type] ?? 0)
            .fold(0, (a, b) => a > b ? a : b);
        if (peak == 0) return const [];
        return [
          _Subtitle(type == MeetingType.lmm
              ? l10n.attMeetingLmm
              : l10n.attMeetingWeekend),
          for (final m in shown)
            if (stats.monthlySeries[m]?[type] != null)
              _StatBar(
                label: monthFmt.format(parseMonthKey(m)),
                value: '${stats.monthlySeries[m]![type]}',
                fraction: stats.monthlySeries[m]![type]! / peak,
              ),
        ];
      }

      return [
        _StatTiles([
          (dash(stats.avg3Months[MeetingType.lmm]),
              '${l10n.attMeetingLmm} · ${l10n.statAvg3Months}'),
          (dash(stats.avg3Months[MeetingType.weekend]),
              '${l10n.attMeetingWeekend} · ${l10n.statAvg3Months}'),
          (dash(stats.avg12Months[MeetingType.lmm]),
              '${l10n.attMeetingLmm} · ${l10n.statAvg12Months}'),
          (dash(stats.avg12Months[MeetingType.weekend]),
              '${l10n.attMeetingWeekend} · ${l10n.statAvg12Months}'),
        ]),
        ...series(MeetingType.lmm),
        ...series(MeetingType.weekend),
      ];
    });
  }
}

// ---------------------------------------------------------------------------
// Field service (per service year)
// ---------------------------------------------------------------------------

class _FieldServiceCard extends ConsumerStatefulWidget {
  const _FieldServiceCard();

  @override
  ConsumerState<_FieldServiceCard> createState() => _FieldServiceCardState();
}

class _FieldServiceCardState extends ConsumerState<_FieldServiceCard> {
  late int _serviceYear = serviceYearOf(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final reportsAsync = ref.watch(serviceYearReportsProvider(_serviceYear));
    final currentYear = serviceYearOf(DateTime.now());

    final header = Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => setState(() => _serviceYear--),
        ),
        Expanded(
          child: Text(
            l10n.statServiceYear('${_serviceYear - 1}/$_serviceYear'),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _serviceYear >= currentYear
              ? null
              : () => setState(() => _serviceYear++),
        ),
      ],
    );

    return _asyncCard(context, reportsAsync, l10n.statFieldServiceTitle,
        (monthReports) {
      final stats = computeFieldService(monthReports);
      if (stats.reportsSubmitted == 0) return [header, const _NoData()];
      return [
        header,
        _StatTiles([
          ('${stats.totalHours}', l10n.reportHours),
          ('${stats.totalStudies}', l10n.reportStudies),
          ('${stats.reportsSubmitted}', l10n.statReportsSubmitted),
          (
            '${stats.participated} / ${stats.reportsSubmitted}',
            l10n.statParticipated
          ),
        ]),
        if (stats.totalHours > 0) ...[
          const SizedBox(height: 8),
          _StatBar(
            label: l10n.statPioneerHours,
            value: '${stats.pioneerHours}',
            fraction: stats.pioneerHours / stats.totalHours,
          ),
          _StatBar(
            label: l10n.statPublisherHours,
            value: '${stats.publisherHours}',
            fraction: stats.publisherHours / stats.totalHours,
          ),
        ],
      ];
    });
  }
}

// ---------------------------------------------------------------------------
// App usage (derived — no tracking)
// ---------------------------------------------------------------------------

class _UsageCard extends ConsumerWidget {
  const _UsageCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final publishersAsync = ref.watch(allPublishersProvider);
    final lastMonth = ref.watch(lastMonthReportsProvider).value ?? const [];

    return _asyncCard(context, publishersAsync, l10n.statUsageTitle,
        (publishers) {
      final stats = computeAppUsage(publishers, lastMonth);
      if (stats.total == 0) return const [_NoData()];
      final reports = stats.selfReported + stats.adminEntered;
      return [
        _StatBar(
          label: l10n.statWithAccount,
          value: '${stats.withAccount} / ${stats.total}',
          fraction: stats.withAccount / stats.total,
        ),
        if (reports > 0)
          _StatBar(
            label: l10n.statSelfReported,
            value: '${stats.selfReported} / $reports',
            fraction: stats.selfReported / reports,
          ),
        const SizedBox(height: 8),
        _StatTiles([
          ('${stats.awaitingVerification}', l10n.statAwaiting),
          ('${stats.fullAdmins}', l10n.statFullAdmins),
          ('${stats.sectionAdmins}', l10n.statSectionAdmins),
        ]),
      ];
    });
  }
}
