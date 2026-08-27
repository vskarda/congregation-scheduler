import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/publishers/roster_export_scope.dart';
import 'package:flutter_test/flutter_test.dart';

/// What the bulk exports warn about: whether the roster listing they were
/// started from really is "every publisher in the congregation".
void main() {
  final today = DateTime(2026, 3, 15);

  const ann = Publisher(id: 'p1', firstName: 'Ann');
  const ben = Publisher(id: 'p2', firstName: 'Ben');
  const cara = Publisher(
      id: 'p3', firstName: 'Cara', status: PublisherStatus.regularPioneer);
  // On the roster for scheduling, but files no field-service report.
  const dan =
      Publisher(id: 'p4', firstName: 'Dan', status: PublisherStatus.none);
  const gone = Publisher(
      id: 'p5', firstName: 'Eve', moved: true, movedDate: '2026-01-31');
  const leaving = Publisher(
      id: 'p6', firstName: 'Fay', moved: true, movedDate: '2026-09-30');

  test('the whole roster of publishers is the unsurprising case', () {
    final scope = RosterExportScope.of(
        all: const [ann, ben, cara],
        listed: const [ann, ben, cara],
        today: today);

    expect(scope.isEveryPublisher, isTrue);
    expect(scope.publishers, 3);
    expect(scope.listed, 3);
    expect(scope.missing, 0);
    expect(scope.extra, 0);
  });

  test('a narrowed list counts the publishers left out', () {
    final scope = RosterExportScope.of(
        all: const [ann, ben, cara], listed: const [cara], today: today);

    expect(scope.isEveryPublisher, isFalse);
    expect(scope.listed, 1);
    expect(scope.publishers, 3);
    expect(scope.missing, 2);
    expect(scope.extra, 0);
  });

  test('a listed non-publisher is counted as an extra, not as a publisher', () {
    final scope = RosterExportScope.of(
        all: const [ann, dan], listed: const [ann, dan], today: today);

    expect(scope.isEveryPublisher, isFalse);
    expect(scope.publishers, 1);
    expect(scope.listed, 2);
    expect(scope.missing, 0);
    expect(scope.extra, 1);
  });

  test('someone who has moved away is neither expected nor free to list', () {
    final hidden = RosterExportScope.of(
        all: const [ann, gone], listed: const [ann], today: today);
    expect(hidden.publishers, 1, reason: 'the departed one is not expected');
    expect(hidden.isEveryPublisher, isTrue);

    final shown = RosterExportScope.of(
        all: const [ann, gone], listed: const [ann, gone], today: today);
    expect(shown.extra, 1, reason: 'their S-21 would land in the file');
    expect(shown.isEveryPublisher, isFalse);
  });

  test('a departure still ahead leaves them a publisher like anyone else', () {
    final scope = RosterExportScope.of(
        all: const [ann, leaving], listed: const [ann, leaving], today: today);

    expect(scope.publishers, 2);
    expect(scope.extra, 0);
    expect(scope.isEveryPublisher, isTrue);
  });

  test('narrowed and mixed at once reports both sides', () {
    final scope = RosterExportScope.of(
        all: const [ann, ben, cara, dan],
        listed: const [ann, dan],
        today: today);

    expect(scope.publishers, 3);
    expect(scope.listed, 2);
    expect(scope.missing, 2, reason: 'Ben and Cara are filtered out');
    expect(scope.extra, 1, reason: 'Dan is not a publisher');
  });

  test('an empty listing is still measured against the roster', () {
    final scope = RosterExportScope.of(
        all: const [ann, ben], listed: const [], today: today);

    expect(scope.listed, 0);
    expect(scope.missing, 2);
    expect(scope.isEveryPublisher, isFalse);
  });
}
