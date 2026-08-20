import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/data/schedule_config_repository.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/publishers/publishers_providers.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The export callbacks (S-21 card, month schedule PDF, circuit overseer PDF)
/// run from a button and await their data. Nothing guarantees that the screen
/// underneath is listening to the streaming providers at that moment — an
/// unassigned week never renders an `AssignmentText`, and a hidden weekend
/// week never builds the permanent-assignments card — so each export reads a
/// one-shot `FutureProvider` twin instead.
///
/// These tests hold that line: every provider here must resolve with **no
/// listener at all**. Turning one back into a StreamProvider, or letting one
/// await a streaming provider's `.future`, hangs the export with a spinner
/// that never stops. See riverpod_future_contract_test.dart for the mechanism.
void main() {
  const admin = Publisher(
    id: 'admin',
    firstName: 'A',
    lastName: 'Dmin',
    verified: true,
    roles: Roles(fullAdmin: true),
  );

  Future<ProviderContainer> container() async {
    final db = FakeFirebaseFirestore();
    await db.collection('publishers').doc(admin.id).set(admin.toJson());
    await db.collection('publishers').doc('p1').set(
        const Publisher(id: 'p1', firstName: 'Jan', lastName: 'Novak')
            .toJson());
    await db
        .collection('publishers')
        .doc('p1')
        .collection('private')
        .doc('profile')
        .set(const PublisherPrivate(email: 'p1@example.com').toJson());

    final c = ProviderContainer(overrides: [
      firestoreProvider.overrideWithValue(db),
      currentUidProvider.overrideWithValue(admin.id),
      myRolesProvider.overrideWithValue(const Roles(fullAdmin: true)),
      isVerifiedProvider.overrideWithValue(true),
    ]);
    addTearDown(c.dispose);
    return c;
  }

  /// Fails with a clear message instead of hanging the whole suite.
  Future<T> within<T>(Future<T> future) => future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => fail(
            'never resolved — the provider is streaming, or awaits one that is'),
      );

  test('publisherPrivateOnceProvider resolves with no listener', () async {
    final c = await container();
    final private = await within(c.read(publisherPrivateOnceProvider('p1').future));
    expect(private?.email, 'p1@example.com');
  });

  test('publisherPrivateOnceProvider keeps the permission guard', () async {
    final db = FakeFirebaseFirestore();
    await db
        .collection('publishers')
        .doc('p1')
        .collection('private')
        .doc('profile')
        .set(const PublisherPrivate(email: 'p1@example.com').toJson());
    // A verified member who is neither p1 nor a publishers-admin.
    final c = ProviderContainer(overrides: [
      firestoreProvider.overrideWithValue(db),
      currentUidProvider.overrideWithValue('someone-else'),
      myRolesProvider.overrideWithValue(const Roles()),
      isVerifiedProvider.overrideWithValue(true),
    ]);
    addTearDown(c.dispose);
    expect(await within(c.read(publisherPrivateOnceProvider('p1').future)),
        isNull);
  });

  test('publishersByIdOnceProvider resolves with no listener', () async {
    final c = await container();
    final byId = await within(c.read(publishersByIdOnceProvider.future));
    expect(byId.keys, containsAll(<String>['admin', 'p1']));
  });

  test('publishersByIdOnceProvider keeps the verified guard', () async {
    final c = ProviderContainer(overrides: [
      firestoreProvider.overrideWithValue(FakeFirebaseFirestore()),
      currentUidProvider.overrideWithValue('nobody'),
      isVerifiedProvider.overrideWithValue(false),
    ]);
    addTearDown(c.dispose);
    expect(await within(c.read(publishersByIdOnceProvider.future)), isEmpty);
  });

  test('permanentAssignmentsOnceProvider resolves with no listener', () async {
    final c = await container();
    for (final doc in [ScheduleConfigDoc.lmm, ScheduleConfigDoc.weekend]) {
      expect(await within(c.read(permanentAssignmentsOnceProvider(doc).future)),
          isEmpty,
          reason: 'no config document written yet');
    }
  });
}
