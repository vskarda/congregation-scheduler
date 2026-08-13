import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/data/reports_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/publishers/s21/s21_batch_export.dart';
import 'package:congregation_scheduler/features/publishers/s21/s21_pdf.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore db;
  late PublishersRepository publishersRepo;
  late ReportsRepository reportsRepo;

  const publishers = [
    Publisher(id: 'p1', firstName: 'Ann', lastName: 'Adams'),
    Publisher(id: 'p2', firstName: 'Ben', lastName: 'Brown'),
    // No private profile and no reports: an admin-created record.
    Publisher(id: 'p3', firstName: 'Cid', lastName: 'Clark'),
  ];

  Future<void> seedReport(String month, String id, int hours) => db
      .collection('reports')
      .doc(month)
      .collection('entries')
      .doc(id)
      .set({'month': month, 'participated': true, 'hours': hours});

  setUp(() async {
    db = FakeFirebaseFirestore();
    publishersRepo = PublishersRepository(db);
    reportsRepo = ReportsRepository(db);
    for (final p in publishers) {
      await db.collection('publishers').doc(p.id).set(p.toJson());
    }
    await publishersRepo.setPrivate('p1',
        const PublisherPrivate(birthDate: '1990-01-15', hope: Hope.anointed));
    await publishersRepo.setPrivate(
        'p2', const PublisherPrivate(baptismDate: '2005-06-11'));
    // Two service years: 2026 runs Sep 2025 – Aug 2026, 2025 the year before.
    await seedReport('2025-09', 'p1', 10);
    await seedReport('2026-08', 'p1', 20);
    await seedReport('2024-09', 'p1', 30);
    await seedReport('2025-10', 'p2', 40);
  });

  Future<List<S21Card>> load({void Function(int, int)? onProgress}) =>
      loadS21Cards(
        publishers: publishers,
        publishersRepo: publishersRepo,
        reportsRepo: reportsRepo,
        years: const [2026, 2025],
        onProgress: onProgress,
      );

  test('builds one card per publisher, in the given order', () async {
    final cards = await load();
    expect(cards.map((c) => c.publisher.id), ['p1', 'p2', 'p3']);
    for (final card in cards) {
      expect(card.years.map((y) => y.serviceYear), [2026, 2025]);
    }
  });

  test('maps each month to its report, across the service-year boundary',
      () async {
    final cards = await load();
    final p1 = cards.first;
    final current = p1.years.first;
    final previous = p1.years.last;
    expect(current.serviceYear, 2026);
    // A service year spans two calendar years: Sep 2025 and Aug 2026 both
    // belong to service year 2026.
    expect(current.reportsByMonth['2025-09']?.hours, 10);
    expect(current.reportsByMonth['2026-08']?.hours, 20);
    expect(previous.reportsByMonth['2024-09']?.hours, 30);
    // Every month of the year is present; the ones without an entry are null.
    expect(current.reportsByMonth.length, 12);
    expect(current.reportsByMonth['2025-10'], isNull);
    // Reports are keyed by publisher: p2's month must not leak onto p1.
    expect(cards[1].years.first.reportsByMonth['2025-10']?.hours, 40);
  });

  test('carries the private profile of each publisher', () async {
    final cards = await load();
    expect(cards[0].private?.birthDate, '1990-01-15');
    expect(cards[0].private?.hope, Hope.anointed);
    expect(cards[1].private?.baptismDate, '2005-06-11');
  });

  test('a publisher with no profile and no reports still gets a card',
      () async {
    final cards = await load();
    final p3 = cards.last;
    expect(p3.private, isNull);
    expect(p3.years, hasLength(2));
    expect(p3.years.first.reportsByMonth.length, 12);
    expect(p3.years.first.reportsByMonth.values.whereType<MinistryReport>(),
        isEmpty);
  });

  test('reads reports by month, not once per publisher', () async {
    final counting = _CountingReportsRepository(db);
    await loadS21Cards(
      publishers: publishers,
      publishersRepo: publishersRepo,
      reportsRepo: counting,
      years: const [2026, 2025],
    );
    // One query per month of the two service years, whatever the roster size.
    // The per-publisher path would cost publishers × months document reads.
    expect(counting.monthQueries, 24);
    expect(counting.perPublisherFetches, 0);
  });

  test('reports progress from zero up to the final step', () async {
    final steps = <({int done, int total})>[];
    await load(
        onProgress: (done, total) => steps.add((done: done, total: total)));
    expect(steps.first.done, 0);
    expect(steps.last.done, steps.last.total);
    // Monotonic and never past the total it announced.
    for (var i = 1; i < steps.length; i++) {
      expect(steps[i].done, greaterThanOrEqualTo(steps[i - 1].done));
      expect(steps[i].done, lessThanOrEqualTo(steps[i].total));
    }
  });
}

/// Counts how the reports were fetched, so the export's read cost is asserted
/// rather than assumed.
class _CountingReportsRepository extends ReportsRepository {
  _CountingReportsRepository(super.db);

  int monthQueries = 0;
  int perPublisherFetches = 0;

  @override
  Future<List<MinistryReport>> getMonth(String month) {
    monthQueries++;
    return super.getMonth(month);
  }

  @override
  Future<Map<String, MinistryReport?>> getMineForMonths(
      String publisherId, List<String> months) {
    perPublisherFetches++;
    return super.getMineForMonths(publisherId, months);
  }
}
