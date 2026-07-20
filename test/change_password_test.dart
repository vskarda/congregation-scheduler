import 'package:congregation_scheduler/core/data/congregation_repository.dart';
import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/data/pw_repository.dart';
import 'package:congregation_scheduler/features/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

/// Self-service password change: the current password re-authenticates the
/// session before Firebase applies the new one, and a wrong current password
/// aborts before `updatePassword` is ever reached.
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

  setUp(() {
    db = FakeFirebaseFirestore();
  });

  test('re-authenticates, then reaches updatePassword', () async {
    final user = MockUser(uid: 'u-reach', email: 'reach@example.com');
    // A marker on updatePassword lets us prove re-auth succeeded and control
    // reached the actual password update (MockUser.updatePassword is a no-op).
    whenCalling(Invocation.method(#updatePassword, null))
        .on(user)
        .thenThrow(FirebaseAuthException(code: 'reached-update'));
    final service = serviceFor(user);

    await expectLater(
      service.updatePassword(
          currentPassword: 'old-password', newPassword: 'new-password'),
      throwsA(isA<FirebaseAuthException>()
          .having((e) => e.code, 'code', 'reached-update')),
    );
  });

  test('completes when the current password is correct', () async {
    final user = MockUser(uid: 'u-ok', email: 'ok@example.com');
    final service = serviceFor(user);

    await expectLater(
      service.updatePassword(
          currentPassword: 'old-password', newPassword: 'new-password'),
      completes,
    );
  });

  test('wrong current password aborts before updatePassword', () async {
    final user = MockUser(uid: 'u-wrong', email: 'wrong@example.com');
    // Re-auth fails as a wrong current password would; the marker on
    // updatePassword would surface instead if it were (wrongly) reached.
    whenCalling(Invocation.method(#reauthenticateWithCredential, null))
        .on(user)
        .thenThrow(FirebaseAuthException(code: 'wrong-password'));
    whenCalling(Invocation.method(#updatePassword, null))
        .on(user)
        .thenThrow(FirebaseAuthException(code: 'reached-update'));
    final service = serviceFor(user);

    await expectLater(
      service.updatePassword(
          currentPassword: 'wrong', newPassword: 'new-password'),
      throwsA(isA<FirebaseAuthException>()
          .having((e) => e.code, 'code', 'wrong-password')),
    );
  });
}
