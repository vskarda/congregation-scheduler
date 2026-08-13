import '../../../core/data/publishers_repository.dart';
import '../../../core/data/reports_repository.dart';
import '../../../core/models/models.dart';
import '../../../core/utils/dates.dart';
import 's21_pdf.dart';

/// Months queried in parallel. Two service years are 24 queries — few enough
/// to finish quickly, too many to fire at the backend in one go.
const _monthFetchRound = 6;

/// Publishers whose private profiles are fetched per round; see
/// [PublishersRepository.getPrivatesBatched].
const _privateFetchBatch = 10;

/// Gathers the card data for an S-21 export of many publishers at once.
///
/// Reports are read **by month, not by publisher**: one query over
/// `reports/{month}/entries` returns every publisher's entry for that month,
/// so the whole export costs one query per month (24 for two service years)
/// regardless of congregation size. Fetching per publisher instead — the way
/// the single-publisher export does — would mean a document read for every
/// publisher × month pair: thousands of them on a full roster. The month-wide
/// query needs the reports role;
/// private profiles need the publishers role (firestore.rules), which is what
/// gates the button offering this export.
///
/// [onProgress] reports completed steps out of a total covering both the month
/// queries and the private-profile rounds, so the caller can drive a progress
/// bar across the whole load.
Future<List<S21Card>> loadS21Cards({
  required List<Publisher> publishers,
  required PublishersRepository publishersRepo,
  required ReportsRepository reportsRepo,
  required List<int> years,
  void Function(int done, int total)? onProgress,
}) async {
  final months = [for (final year in years) ...serviceYearMonths(year)];
  // Steps: one per month query, plus one per round of private profiles.
  final privateRounds = (publishers.length / _privateFetchBatch).ceil();
  final total = months.length + privateRounds;
  var done = 0;
  void tick(int steps) {
    done += steps;
    onProgress?.call(done, total);
  }

  onProgress?.call(0, total);

  // month key -> publisher id -> that publisher's report for the month.
  final byMonth = <String, Map<String, MinistryReport>>{};
  for (var i = 0; i < months.length; i += _monthFetchRound) {
    final round = months.skip(i).take(_monthFetchRound).toList();
    final entries = await Future.wait(round.map(reportsRepo.getMonth));
    for (var j = 0; j < round.length; j++) {
      byMonth[round[j]] = {
        for (final report in entries[j]) report.publisherId: report,
      };
    }
    tick(round.length);
  }

  final privates = await publishersRepo.getPrivatesBatched(
    [for (final p in publishers) p.id],
    batch: _privateFetchBatch,
    onRound: () => tick(1),
  );

  return [
    for (var i = 0; i < publishers.length; i++)
      S21Card(
        publisher: publishers[i],
        private: privates[i],
        years: [
          for (final year in years)
            S21YearReports(
              serviceYear: year,
              reportsByMonth: {
                // A month without an entry maps to null, exactly as the
                // single-publisher record view receives it.
                for (final month in serviceYearMonths(year))
                  month: byMonth[month]?[publishers[i].id],
              },
            ),
        ],
      ),
  ];
}
