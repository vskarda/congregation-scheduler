import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congregation_scheduler/core/data/territories_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/territories/territories_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'support/live_harness.dart';

/// Smoke tests against the real test congregation (`.credits/`).
///
/// Deliberately few: this suite exists to prove the live connection works and
/// to be the template for verifying a *new* feature by hand against real
/// rules and real data. Broad behavioural coverage stays in `test/`, where it
/// runs offline against fake_cloud_firestore in seconds.
///
/// Run with `scripts/live-test.ps1`. Without credentials every test skips.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final creds = LiveCredentials.fromEnvironment();
  if (creds == null) {
    testWidgets('live congregation tests (no .credits/ supplied)', (_) async {},
        skip: true);
    return;
  }

  setUpAll(() => LiveHarness.signInAsAdmin(creds));
  tearDownAll(LiveHarness.cleanUp);

  testWidgets('the login in .credits/ is a verified full admin', (_) async {
    final doc = await FirebaseFirestore.instance
        .collection('publishers')
        .doc(LiveHarness.adminUid)
        .get();

    expect(doc.exists, isTrue,
        reason: 'no publishers/${LiveHarness.adminUid} doc for this account');
    final me = Publisher.fromJson(doc.data()!);
    expect(me.verified, isTrue);
    expect(me.roles.fullAdmin, isTrue,
        reason: '.credits/.login must belong to a congregation admin');
  });

  // Guards against the fakes in test/ drifting away from what the real
  // project actually stores — the one thing an offline test cannot catch.
  testWidgets('live documents still parse into the app models', (_) async {
    final db = FirebaseFirestore.instance;

    final meta = await db.collection('congregation').doc('meta').get();
    expect(meta.exists, isTrue, reason: 'congregation/meta is missing');
    expect(() => CongregationMeta.fromJson(meta.data()!), returnsNormally);

    final publishers = await db.collection('publishers').get();
    expect(publishers.docs, isNotEmpty);
    for (final doc in publishers.docs) {
      expect(() => Publisher.fromJson(doc.data()), returnsNormally,
          reason: 'publishers/${doc.id} no longer matches Publisher');
    }
  });

  testWidgets('a repository write is accepted by the deployed rules',
      (_) async {
    final db = FirebaseFirestore.instance;
    final repo = TerritoriesRepository(db);
    final id = LiveHarness.testId('territory');
    final ref = LiveHarness.track(db.collection('territories').doc(id));

    await repo.saveTerritory(Territory(id: id, name: 'Live check $id'));
    final saved = await ref.get();
    expect(saved.exists, isTrue);
    expect(Territory.fromJson(saved.data()!).name, 'Live check $id');

    await repo.deleteTerritory(id);
    expect((await ref.get()).exists, isFalse);
  });

  testWidgets('a screen renders data read from the live project',
      (tester) async {
    final db = FirebaseFirestore.instance;
    final id = LiveHarness.testId('screen');
    final name = 'Live screen $id';
    await LiveHarness.track(db.collection('territories').doc(id))
        .set(Territory(name: name).toJson());

    await tester.pumpWidget(await LiveHarness.wrap(const TerritoriesScreen()));

    // Roles come from the real signed-in publisher doc, so this also proves
    // the admin actually sees the admin view.
    await LiveHarness.waitFor(
        tester, () => find.text(name).evaluate().isNotEmpty,
        reason: 'the seeded territory to appear');
  });
}
