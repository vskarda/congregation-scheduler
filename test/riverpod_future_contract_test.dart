import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Executable documentation of the one Riverpod rule this app keeps tripping
/// over, and a canary for the next `flutter_riverpod` upgrade.
///
/// **A StreamProvider's `.future` only completes while something is listening
/// to that provider.** Riverpod 3 disposes a provider that has no listener, so
/// an unlistened stream is torn down before its first value arrives and the
/// await never returns — silently, with no error at the call site. `ref.watch`
/// registers a listener; `ref.read` does not.
///
/// The practical consequences, each pinned by a case below:
///  - in a provider body, depend with `ref.watch(dep.future)`, never
///    `ref.read(dep.future)` (case D);
///  - in a widget callback, never await a StreamProvider's `.future` unless
///    that exact provider (same family key) is watched by a widget that is
///    certainly on screen — prefer a one-shot `FutureProvider` twin;
///  - in a test, `container.read(p.future)` needs a `container.listen(p, …)`
///    first (case B vs A).
void main() {
  /// Emits asynchronously, the way a Firestore snapshot does. A synchronous
  /// `Stream.value` would mask the bug.
  final source = StreamProvider<int>((ref) async* {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    yield 42;
  });

  final watchesSource = FutureProvider<int>((ref) => ref.watch(source.future));
  final readsSource = FutureProvider<int>((ref) => ref.read(source.future));

  /// Resolves [future], reporting a hang as a timeout rather than stalling
  /// the suite.
  Future<int?> settle(Future<int> future) =>
      future.timeout(const Duration(milliseconds: 500)).then<int?>((v) => v,
          onError: (_) => null);

  test('A. outer watches source, outer is listened -> resolves', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.listen(watchesSource, (_, _) {});
    expect(await settle(c.read(watchesSource.future)), 42);
  });

  test('B. outer watches source, outer NOT listened -> hangs', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    expect(await settle(c.read(watchesSource.future)), isNull,
        reason: 'an unlistened provider chain never resolves');
  });

  test('C. outer READS source, even though outer is listened -> hangs',
      () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.listen(readsSource, (_, _) {});
    expect(await settle(c.read(readsSource.future)), isNull,
        reason: 'ref.read registers no listener on source, so it is disposed');
  });

  test('D. bare stream .future, nothing listening -> hangs', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    expect(await settle(c.read(source.future)), isNull);
  });

  test('E. bare stream .future, with a listener -> resolves', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.listen(source, (_, _) {});
    expect(await settle(c.read(source.future)), 42);
  });
}
