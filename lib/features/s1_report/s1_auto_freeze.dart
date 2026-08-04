import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/data/reports_repository.dart';
import '../../core/data/s1_repository.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import 's1_providers.dart';

/// Freezes months that have aged past [kS1FreezeAfterMonths] without anyone
/// pressing the button, so a congregation that never thinks about freezing
/// still ends up with its submitted figures preserved.
///
/// Runs once per app session, when a reports admin opens the S-1 screen —
/// there are no Cloud Functions on the Spark plan, so a sweep can only ride
/// along with someone's screen. Everything about it is built to stay cheap:
///
///  * the bookmark (`s1_records/_autofreeze`) records the newest month already
///    considered, so later runs look at the one month that has since crossed
///    the line, not the whole window;
///  * the very first run reaches back [kS1AutoFreezeBackfillMonths] months and
///    no further;
///  * the report months are read once for the whole window and shared between
///    candidates, whose six-month actives ranges overlap heavily;
///  * a month with neither reports nor attendance is skipped rather than
///    frozen at zero — a congregation that imports its S-21 history later must
///    still get real figures for those months.
///
/// Returns how many months it froze. Failures (denied writes on a deployment
/// with older rules, a dropped connection) surface as a provider error the
/// screen ignores: this is background tidying, not something to interrupt the
/// admin with.
final s1AutoFreezeProvider = FutureProvider<int>((ref) async {
  // Taken as it stands rather than awaited: the sweep is started by the S-1
  // screen, which nobody reaches before the shell has loaded their publisher
  // document and built the navigation out of its roles.
  final me = ref.watch(myPublisherProvider).value;
  if (me == null || !me.roles.canEditReports()) return 0;

  final repo = ref.read(s1RepositoryProvider);
  final threshold =
      monthKey(addMonths(DateTime.now(), -kS1FreezeAfterMonths));
  final scanned = await repo.autoFreezeScannedThrough();
  final start = scanned == null
      ? monthKey(addMonths(
          parseMonthKey(threshold), -(kS1AutoFreezeBackfillMonths - 1)))
      : monthKey(addMonths(parseMonthKey(scanned), 1));

  final months = monthsBetween(start, threshold);
  if (months.isEmpty) return 0;

  final frozen = await ref.watch(frozenS1Provider.future);
  final candidates = [
    for (final month in months)
      if (!frozen.containsKey(month)) month,
  ];
  if (candidates.isEmpty) {
    await repo.saveAutoFreezeScannedThrough(threshold);
    return 0;
  }

  // The window plus the five months before it: the oldest candidate's
  // six-month actives count reaches back that far.
  final reportsRepo = ref.read(reportsRepositoryProvider);
  final window =
      monthsBetween(monthKey(addMonths(parseMonthKey(start), -5)), threshold);
  final reportsByMonth = <String, List<MinistryReport>>{};
  for (var i = 0; i < window.length; i += 12) {
    final chunk = window.skip(i).take(12).toList();
    final loaded = await Future.wait(chunk.map(reportsRepo.getMonth));
    for (var j = 0; j < chunk.length; j++) {
      reportsByMonth[chunk[j]] = loaded[j];
    }
  }

  // Read once rather than through the roster stream: the sweep is a one-shot
  // job, and on most openings it has already returned above without paying
  // for this.
  final publishers = await ref.read(publishersRepositoryProvider).getAll();
  var count = 0;
  for (final month in candidates) {
    final inputs = await loadS1Inputs(ref, month,
        reportsByMonth: reportsByMonth, publishers: publishers);
    if (!inputs.hasData) continue;
    await repo.freeze(
        inputs.compute().copyWith(frozenAt: DateTime.now(), auto: true));
    count++;
  }
  await repo.saveAutoFreezeScannedThrough(threshold);
  if (count > 0) ref.invalidate(frozenS1Provider);
  return count;
});
