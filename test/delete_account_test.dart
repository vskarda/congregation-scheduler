import 'package:congregation_scheduler/core/data/congregation_repository.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/data/pw_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

/// Self-service account deletion (Apple Guideline 5.1.1(v)): the user's
/// profile docs and their own PW applications are removed, other publishers'
/// data is left untouched.
void main() {
  const uid = 'me-uid';
  late FakeFirebaseFirestore db;
  late AuthService service;

  Future<bool> exists(String path) async =>
      (await db.doc(path).get()).exists;

  setUp(() async {
    db = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: uid, email: 'me@example.com'),
    );
    service = AuthService(
      auth,
      CongregationRepository(db),
      PublishersRepository(db),
      PwRepository(db),
    );

    final publishers = PublishersRepository(db);
    await publishers.createWithId(
      uid,
      const Publisher(firstName: 'Me', verified: true, hasAccount: true),
    );
    await publishers.setPrivate(uid, const PublisherPrivate(email: 'me@example.com'));
    // My application, plus one belonging to someone else.
    await db.collection('pw_applications').doc('slot1_$uid').set({
      'slotId': 'slot1',
      'date': '2026-08-01',
      'publisherId': uid,
      'appliedAt': null,
    });
    await db.collection('pw_applications').doc('slot1_other').set({
      'slotId': 'slot1',
      'date': '2026-08-01',
      'publisherId': 'other',
      'appliedAt': null,
    });
  });

  test('removes own profile docs and applications, keeps others', () async {
    await service.deleteAccount(password: 'pw123456');

    expect(await exists('publishers/$uid'), isFalse);
    expect(await exists('publishers/$uid/private/profile'), isFalse);
    expect(await exists('pw_applications/slot1_$uid'), isFalse);
    // Another publisher's application is untouched.
    expect(await exists('pw_applications/slot1_other'), isTrue);
  });

  test('wrong password aborts before any data is deleted', () async {
    final user = MockUser(uid: uid, email: 'me@example.com');
    // Make re-authentication fail, as a wrong password would.
    whenCalling(Invocation.method(#reauthenticateWithCredential, null))
        .on(user)
        .thenThrow(FirebaseAuthException(code: 'wrong-password'));
    final auth = MockFirebaseAuth(signedIn: true, mockUser: user);
    final guarded = AuthService(
      auth,
      CongregationRepository(db),
      PublishersRepository(db),
      PwRepository(db),
    );

    await expectLater(
      guarded.deleteAccount(password: 'nope'),
      throwsA(isA<FirebaseAuthException>()),
    );
    // Nothing was removed.
    expect(await exists('publishers/$uid'), isTrue);
    expect(await exists('pw_applications/slot1_$uid'), isTrue);
  });
}
