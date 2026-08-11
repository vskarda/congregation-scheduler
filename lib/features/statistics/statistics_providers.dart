import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/data/reports_repository.dart';
import '../../core/data/territories_repository.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/roster.dart';
import 'statistics_model.dart';

/// Birth dates of the active roster, one entry per member (null = unknown),
/// loaded from each private profile. Full-admin only — the rules deny private
/// reads otherwise; individual failed reads count as unknown rather than
/// failing the whole card. One-shot and autoDispose: re-read when the
/// screen is (re)opened, not streamed, to keep the N-document read cost
/// bounded.
final rosterBirthDatesProvider =
    FutureProvider.autoDispose<List<DateTime?>>((ref) async {
  if (!ref.watch(myRolesProvider).fullAdmin) return const [];
  final all = await ref.watch(allPublishersProvider.future);
  final repo = ref.watch(publishersRepositoryProvider);
  return Future.wait(activeRoster(all).map((p) async {
    try {
      final priv = await repo.getPrivate(p.id);
      return tryParseDateKey(priv?.birthDate);
    } catch (_) {
      return null;
    }
  }));
});

/// Entries a month may count: everything except reports of publishers who had
/// already moved away by then, which belong to the congregation they moved to
/// (the same rule the S-1 applies, via the same helper — including departures
/// whose publisher record has since been deleted). Entries with neither a
/// record nor a recorded departure are kept: there is nothing to judge them by.
///
/// Both callers await the roster rather than reading the already-loaded map,
/// so the first result is the filtered one: recomputing after the stream
/// arrives would mean re-reading every month of the service year.
List<MinistryReport> _countableIn(
        String month, List<MinistryReport> entries, _Roster roster) =>
    entries
        .where((r) => !movedAwayBy(month, roster.publishers, roster.former)
            .contains(r.publisherId))
        .toList();

/// The two sources of the month-level cut, loaded once per query.
class _Roster {
  const _Roster(this.publishers, this.former);
  final List<Publisher> publishers;
  final List<FormerPublisher> former;
}

Future<_Roster> _roster(Ref ref) async => _Roster(
      await ref.watch(allPublishersProvider.future),
      await ref.watch(formerPublishersProvider.future),
    );

/// One list of reports per month of the given service year (12 entries,
/// September first; months without data yield empty lists).
final serviceYearReportsProvider =
    FutureProvider.autoDispose.family<List<List<MinistryReport>>, int>(
        (ref, serviceYear) async {
  final repo = ref.watch(reportsRepositoryProvider);
  final roster = await _roster(ref);
  return Future.wait(serviceYearMonths(serviceYear).map((month) async =>
      _countableIn(month, await repo.getMonth(month), roster)));
});

/// The two collections the territory card rolls up. Both are the streams the
/// Territories screen already runs (a full admin passes the rules' territory
/// role), paired here so the card shows one loading/error state instead of
/// two half-drawn ones.
typedef TerritorySources = ({
  List<Territory> territories,
  List<TerritoryAssignment> assignments,
});

final territoryStatsSourcesProvider =
    Provider.autoDispose<AsyncValue<TerritorySources>>((ref) {
  final territories = ref.watch(territoriesProvider);
  final assignments = ref.watch(allTerritoryAssignmentsProvider);
  return territories.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    data: (territoryList) => assignments.when(
      loading: () => const AsyncValue.loading(),
      error: (e, st) => AsyncValue.error(e, st),
      data: (assignmentList) => AsyncValue.data(
          (territories: territoryList, assignments: assignmentList)),
    ),
  );
});

/// Previous calendar month's reports — the month whose reporting is
/// typically complete; used for the self-reported share on the usage card.
final lastMonthReportsProvider =
    StreamProvider.autoDispose<List<MinistryReport>>((ref) async* {
  final month = monthKey(addMonths(DateTime.now(), -1));
  final roster = await _roster(ref);
  yield* ref
      .watch(reportsRepositoryProvider)
      .watchMonth(month)
      .map((entries) => _countableIn(month, entries, roster));
});
