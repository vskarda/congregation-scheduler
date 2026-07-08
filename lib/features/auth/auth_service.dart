import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/congregation_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/models/models.dart';

/// Thrown when "set up new congregation" is chosen but congregation/meta
/// already exists; the account has been converted to a normal join.
class CongregationExistsException implements Exception {
  const CongregationExistsException();
}

class AuthService {
  AuthService(this._auth, this._congregations, this._publishers);

  final FirebaseAuth _auth;
  final CongregationRepository _congregations;
  final PublishersRepository _publishers;

  Future<void> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  /// Join an existing congregation: account + unverified publisher doc.
  Future<void> registerJoin({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password);
    final uid = cred.user!.uid;
    await _createProfileDocs(uid, email, firstName, lastName, verified: false);
  }

  /// Found a brand-new congregation: whoever creates congregation/meta first
  /// becomes founder and gets a fully privileged publisher doc.
  Future<void> registerNewCongregation({
    required String congregationName,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password);
    final uid = cred.user!.uid;
    try {
      await _congregations.createMeta(
          CongregationMeta(name: congregationName.trim(), founderUid: uid));
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        // Someone founded it already — fall back to a normal join.
        await _createProfileDocs(uid, email, firstName, lastName,
            verified: false);
        throw const CongregationExistsException();
      }
      rethrow;
    }
    await _createProfileDocs(uid, email, firstName, lastName, verified: true);
  }

  /// Recovery path for interrupted registrations.
  Future<void> completeProfile({
    required String firstName,
    required String lastName,
  }) async {
    final user = _auth.currentUser!;
    await _createProfileDocs(
        user.uid, user.email ?? '', firstName, lastName,
        verified: false);
  }

  Future<void> _createProfileDocs(
    String uid,
    String email,
    String firstName,
    String lastName, {
    required bool verified,
  }) async {
    await _publishers.createWithId(
      uid,
      Publisher(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        verified: verified,
        roles: verified ? const Roles(fullAdmin: true) : const Roles(),
        hasAccount: true,
      ),
    );
    await _publishers.setPrivate(uid, PublisherPrivate(email: email.trim()));
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService(
      ref.watch(firebaseAuthProvider),
      ref.watch(congregationRepositoryProvider),
      ref.watch(publishersRepositoryProvider),
    ));
