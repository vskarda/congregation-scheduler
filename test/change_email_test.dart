import 'package:cloud_firestore/cloud_firestore.dart';
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

/// Self-service change of the sign-in e-mail. The password re-authenticates
/// the session before Firebase mails the confirmation link, and the contact
/// copy in private/profile follows along — but only while it still holds the
/// address being replaced, and never at the cost of the change itself.
///
/// Each test uses a distinct mock-user identity: mock_exceptions stores its
/// stubs in a process-global registry keyed by object equality, and MockUsers
/// with identical fields would otherwise share (leak) stubs across tests.
void main() {
  late FakeFirebaseFirestore db;

  AuthService serviceFor(MockUser user) => AuthService(
        MockFirebaseAuth(signedIn: true, mockUser: user),
        CongregationRepository(db),
        PublishersRepository(db),
        PwRepository(db),
      );

  DocumentReference<Map<String, dynamic>> privateDoc(String uid) =>
      db.collection('publishers').doc(uid).collection('private').doc('profile');

  Future<void> seedProfile(String uid, String email) =>
      privateDoc(uid).set(PublisherPrivate(email: email, phone: '123').toJson());

  Future<String?> storedEmail(String uid) async =>
      (await privateDoc(uid).get()).data()?['email'] as String?;

  setUp(() {
    db = FakeFirebaseFirestore();
  });

  test('re-authenticates, then asks Firebase to verify the new address',
      () async {
    final user = MockUser(uid: 'u-reach', email: 'old@example.com');
    // A marker lets us prove re-auth succeeded and control reached the actual
    // call (MockUser.verifyBeforeUpdateEmail is a no-op).
    whenCalling(Invocation.method(#verifyBeforeUpdateEmail, null))
        .on(user)
        .thenThrow(FirebaseAuthException(code: 'reached-verify'));

    await expectLater(
      serviceFor(user)
          .startEmailChange(password: 'pw', newEmail: 'new@example.com'),
      throwsA(isA<FirebaseAuthException>()
          .having((e) => e.code, 'code', 'reached-verify')),
    );
  });

  test('wrong password aborts before any mail goes out', () async {
    final user = MockUser(uid: 'u-wrong', email: 'old@example.com');
    whenCalling(Invocation.method(#reauthenticateWithCredential, null))
        .on(user)
        .thenThrow(FirebaseAuthException(code: 'wrong-password'));
    // Would surface instead of 'wrong-password' if it were (wrongly) reached.
    whenCalling(Invocation.method(#verifyBeforeUpdateEmail, null))
        .on(user)
        .thenThrow(FirebaseAuthException(code: 'reached-verify'));

    await expectLater(
      serviceFor(user)
          .startEmailChange(password: 'wrong', newEmail: 'new@example.com'),
      throwsA(isA<FirebaseAuthException>()
          .having((e) => e.code, 'code', 'wrong-password')),
    );
  });

  test('moves the contact copy that still held the old address', () async {
    final user = MockUser(uid: 'u-mirror', email: 'old@example.com');
    await seedProfile('u-mirror', 'OLD@Example.com'); // case must not matter

    await serviceFor(user)
        .startEmailChange(password: 'pw', newEmail: ' new@example.com ');

    expect(await storedEmail('u-mirror'), 'new@example.com');
    expect((await privateDoc('u-mirror').get()).data()?['phone'], '123',
        reason: 'the rest of the profile is written back unchanged');
  });

  test('leaves a deliberately different contact address alone', () async {
    final user = MockUser(uid: 'u-kept', email: 'login@example.com');
    await seedProfile('u-kept', 'family@example.com');

    await serviceFor(user)
        .startEmailChange(password: 'pw', newEmail: 'new@example.com');

    expect(await storedEmail('u-kept'), 'family@example.com');
  });

  test('a record without a private profile is simply skipped', () async {
    final user = MockUser(uid: 'u-none', email: 'old@example.com');

    await expectLater(
      serviceFor(user)
          .startEmailChange(password: 'pw', newEmail: 'new@example.com'),
      completes,
    );
  });

  // A congregation still running the previous firestore.rules denies the
  // write. The link has already gone out by then, so the change must not be
  // reported as failed — the address can be corrected on the profile later.
  test('a denied contact-copy write does not fail the change', () async {
    final user = MockUser(uid: 'u-denied', email: 'old@example.com');
    await seedProfile('u-denied', 'old@example.com');
    whenCalling(Invocation.method(#set, null))
        .on(privateDoc('u-denied'))
        .thenThrow(FirebaseException(
            plugin: 'firestore', code: 'permission-denied'));

    await expectLater(
      serviceFor(user)
          .startEmailChange(password: 'pw', newEmail: 'new@example.com'),
      completes,
    );
    expect(await storedEmail('u-denied'), 'old@example.com');
  });
}
