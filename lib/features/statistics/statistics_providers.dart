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

/// One list of reports per month of the given service year (12 entries,
/// September first; months without data yield empty lists).
final serviceYearReportsProvider =
    FutureProvider.autoDispose.family<List<List<MinistryReport>>, int>(
        (ref, serviceYear) async {
  final repo = ref.watch(reportsRepositoryProvider);
  return Future.wait(
      serviceYearMonths(serviceYear).map((month) => repo.getMonth(month)));
});

/// Previous calendar month's reports — the month whose reporting is
/// typically complete; used for the self-reported share on the usage card.
final lastMonthReportsProvider =
    StreamProvider.autoDispose<List<MinistryReport>>((ref) {
  final month = monthKey(addMonths(DateTime.now(), -1));
  return ref.watch(reportsRepositoryProvider).watchMonth(month);
});
