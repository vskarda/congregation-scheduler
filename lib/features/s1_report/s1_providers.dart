import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/attendance_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/data/reports_repository.dart';
import '../../core/data/s1_repository.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import 's1_calculator.dart';

/// A month is frozen automatically once it is this many months in the past —
/// by then the S-1 has been handed in and late arrivals must not rewrite it.
const kS1FreezeAfterMonths = 2;

/// How far back the first automatic sweep reaches. Bounded on purpose: this
/// runs on the Spark plan, and a congregation with years of imported S-21
/// history would otherwise read its whole past on one screen opening.
const kS1AutoFreezeBackfillMonths = 12;

/// Everything one month's S-1 is computed from. Kept as a value so the
/// automatic sweep can see whether a month holds any data at all — a month
/// with no reports and no attendance is not a month of zeros, it is a month
/// nobody has entered yet, and freezing it would enshrine the emptiness.
class S1Inputs {
  const S1Inputs({
    required this.month,
    required this.lastSixMonths,
    required this.attendance,
    required this.excludedIds,
  });

  final String month;

  /// Six lists, newest (= [month]) first.
  final List<List<MinistryReport>> lastSixMonths;
  final List<AttendanceEntry> attendance;
  final Set<String> excludedIds;

  List<MinistryReport> get monthReports => lastSixMonths.first;

  bool get hasData => monthReports.isNotEmpty || attendance.isNotEmpty;

  S1Record compute() => computeS1(
        month: month,
        monthReports: monthReports,
        lastSixMonths: lastSixMonths,
        monthAttendance: attendance,
        excludedIds: excludedIds,
      );
}

/// Ids of publishers who had already left the congregation by [month].
Set<String> s1ExcludedIds(String month, List<Publisher> publishers) => {
      for (final p in publishers)
        if (!p.onRosterInMonth(month)) p.id,
    };

/// Loads one month's inputs. [reportsByMonth] lets a caller that already holds
/// report months (the sweep, which walks a whole window at once) reuse them
/// instead of re-reading the six-month tail for every candidate.
Future<S1Inputs> loadS1Inputs(
  Ref ref,
  String month, {
  Map<String, List<MinistryReport>>? reportsByMonth,
  List<Publisher>? publishers,
}) async {
  final reportsRepo = ref.watch(reportsRepositoryProvider);
  final monthDate = parseMonthKey(month);

  final lastSix = <List<MinistryReport>>[];
  for (var i = 0; i < 6; i++) {
    final key = monthKey(addMonths(monthDate, -i));
    lastSix.add(reportsByMonth?[key] ?? await reportsRepo.getMonth(key));
  }
  final attendance = await ref
      .watch(attendanceRepositoryProvider)
      .getRange('$month-01', '$month-31');
  // Who had already left by this month. Watching the roster (rather than
  // reading it once) is deliberate: recording a move updates the form right
  // away, where this per-month provider would otherwise hold its numbers for
  // the rest of the session.
  final List<Publisher> roster =
      publishers ?? await ref.watch(allPublishersProvider.future);
  return S1Inputs(
    month: month,
    lastSixMonths: lastSix,
    attendance: attendance,
    excludedIds: s1ExcludedIds(month, roster),
  );
}

/// The month's figures as they stand right now, whether or not it is frozen.
/// Freezing reads this; the screen reads it only for unfrozen months.
final liveS1Provider = FutureProvider.family<S1Record, String>(
    (ref, month) async => (await loadS1Inputs(ref, month)).compute());

/// Every frozen month, keyed by month. Invalidate after freezing, unfreezing
/// or sweeping — nothing else can change it while the app is open.
final frozenS1Provider = FutureProvider<Map<String, S1Record>>(
    (ref) => ref.watch(s1RepositoryProvider).getAll());

/// What the S-1 screen shows: the frozen figures when the month has been
/// frozen, the live computation otherwise.
final s1ResultProvider =
    FutureProvider.family<S1Record, String>((ref, month) async {
  final frozen = await ref.watch(frozenS1Provider.future);
  return frozen[month] ?? await ref.watch(liveS1Provider(month).future);
});

/// Newest month that may be frozen: everything before the current one.
bool s1CanFreeze(String month, DateTime now) =>
    month.compareTo(monthKey(now)) < 0;
