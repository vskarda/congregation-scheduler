import 'package:congregation_scheduler/core/data/congregation_repository.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/auth/auth_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the disambiguation the "set up a new congregation" fix hinges on:
/// the founder is only demoted to a join when a read *positively* shows the
/// congregation belongs to someone else — not on a transient denial.
void main() {
  late FakeFirebaseFirestore db;
  late MockFirebaseAuth auth;
  late AuthService service;

  Future<Publisher?> readPublisher(String uid) async {
    final doc = await db.collection('publishers').doc(uid).get();
    final data = doc.data();
    return data == null ? null : Publisher.fromJson(data);
  }

  Future<CongregationMeta?> readMeta() async {
    final doc = await db.collection('congregation').doc('meta').get();
    final data = doc.data();
    return data == null ? null : CongregationMeta.fromJson(data);
  }

  setUp(() {
    db = FakeFirebaseFirestore();
    auth = MockFirebaseAuth();
    service = AuthService(
      auth,
      CongregationRepository(db),
      PublishersRepository(db),
    );
  });

  test('fresh project: first user becomes verified full-admin founder',
      () async {
    await service.registerNewCongregation(
      congregationName: 'Alpha',
      email: 'founder@example.com',
      password: 'pw123456',
      firstName: 'Fa',
      lastName: 'Ther',
    );
    final uid = auth.currentUser!.uid;

    final meta = await readMeta();
    expect(meta, isNotNull);
    expect(meta!.founderUid, uid);
    expect(meta.name, 'Alpha');

    final me = await readPublisher(uid);
    expect(me, isNotNull);
    expect(me!.verified, isTrue);
    expect(me.roles.fullAdmin, isTrue);
  });

  test('congregation already founded by someone else falls back to a join',
      () async {
    await db.collection('congregation').doc('meta').set(
          const CongregationMeta(name: 'Existing', founderUid: 'someone-else')
              .toJson(),
        );

    await expectLater(
      service.registerNewCongregation(
        congregationName: 'Alpha',
        email: 'founder@example.com',
        password: 'pw123456',
        firstName: 'Fa',
        lastName: 'Ther',
      ),
      throwsA(isA<CongregationExistsException>()),
    );
    final uid = auth.currentUser!.uid;

    // The existing founder is untouched; the newcomer is an unverified joiner.
    expect((await readMeta())!.founderUid, 'someone-else');
    final me = await readPublisher(uid);
    expect(me, isNotNull);
    expect(me!.verified, isFalse);
    expect(me.roles.fullAdmin, isFalse);
  });
}
