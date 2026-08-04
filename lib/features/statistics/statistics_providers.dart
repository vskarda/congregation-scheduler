import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/data/reports_repository.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
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
/// (the same rule the S-1 applies). Entries whose publisher record no longer
/// exists are kept — there is nothing to judge them by.
///
/// Both callers await the roster rather than reading the already-loaded map,
/// so the first result is the filtered one: recomputing after the stream
/// arrives would mean re-reading every month of the service year.
List<MinistryReport> _countableIn(String month, List<MinistryReport> entries,
        Map<String, Publisher> byId) =>
    entries
        .where((r) => byId[r.publisherId]?.onRosterInMonth(month) ?? true)
        .toList();

Future<Map<String, Publisher>> _rosterById(Ref ref) async {
  final all = await ref.watch(allPublishersProvider.future);
  return {for (final p in all) p.id: p};
}

/// One list of reports per month of the given service year (12 entries,
/// September first; months without data yield empty lists).
final serviceYearReportsProvider =
    FutureProvider.autoDispose.family<List<List<MinistryReport>>, int>(
        (ref, serviceYear) async {
  final repo = ref.watch(reportsRepositoryProvider);
  final byId = await _rosterById(ref);
  return Future.wait(serviceYearMonths(serviceYear).map((month) async =>
      _countableIn(month, await repo.getMonth(month), byId)));
});

/// Previous calendar month's reports — the month whose reporting is
/// typically complete; used for the self-reported share on the usage card.
final lastMonthReportsProvider =
    StreamProvider.autoDispose<List<MinistryReport>>((ref) async* {
  final month = monthKey(addMonths(DateTime.now(), -1));
  final byId = await _rosterById(ref);
  yield* ref
      .watch(reportsRepositoryProvider)
      .watchMonth(month)
      .map((entries) => _countableIn(month, entries, byId));
});
