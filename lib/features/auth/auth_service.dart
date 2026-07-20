import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/congregation_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/data/pw_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/models/models.dart';

/// Thrown when "set up new congregation" is chosen but congregation/meta
/// already exists; the account has been converted to a normal join.
class CongregationExistsException implements Exception {
  const CongregationExistsException();
}

/// Thrown when founding a new congregation could not reach Firestore after
/// retries (a freshly-created project is still warming up). The just-created
/// auth account is rolled back so the user can simply try again.
class DatabaseNotReadyException implements Exception {
  const DatabaseNotReadyException();
}

/// Outcome of trying to claim founder status for a new congregation.
enum _FounderOutcome { founded, alreadyExists, notReady }

class AuthService {
  AuthService(this._auth, this._congregations, this._publishers, this._pw);

  final FirebaseAuth _auth;
  final CongregationRepository _congregations;
  final PublishersRepository _publishers;
  final PwRepository _pw;

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
  ///
  /// A freshly-created Firebase project (and the newly-minted auth token) can
  /// take a moment to become reachable, so the first Firestore writes are made
  /// resilient: the founder is only demoted to a normal join when a read
  /// *positively* confirms the congregation already belongs to someone else;
  /// transient failures are retried, and an unrecoverable cold start rolls the
  /// account back rather than leaving a half-registered user.
  Future<void> registerNewCongregation({
    required String congregationName,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password);
    final user = cred.user!;
    // Make sure the fresh ID token has reached Firestore before the first
    // write; otherwise the write can look unauthenticated and be denied.
    await user.getIdToken();
    final uid = user.uid;

    switch (await _establishFounder(uid, congregationName.trim())) {
      case _FounderOutcome.founded:
        await _retry(() => _createProfileDocs(uid, email, firstName, lastName,
            verified: true));
      case _FounderOutcome.alreadyExists:
        // Confirmed by a read: someone else founded it — fall back to a join.
        await _retry(() => _createProfileDocs(uid, email, firstName, lastName,
            verified: false));
        throw const CongregationExistsException();
      case _FounderOutcome.notReady:
        // Never reached the database. Roll back (safe: congregation/meta does
        // not exist yet, so this cannot orphan a founded congregation).
        try {
          await user.delete();
        } catch (_) {
          // Best-effort rollback.
        }
        throw const DatabaseNotReadyException();
    }
  }

  /// Claims founder status for [uid], tolerating a cold project/token by
  /// probing `congregation/meta` before each create attempt.
  Future<_FounderOutcome> _establishFounder(String uid, String name) async {
    for (var attempt = 0; attempt < _maxAttempts; attempt++) {
      if (attempt > 0) await Future<void>.delayed(_backoff(attempt - 1));
      CongregationMeta? meta;
      try {
        meta = await _congregations.getMeta();
      } on FirebaseException catch (e) {
        if (_isTransient(e)) continue; // token/DB not ready yet — retry
        rethrow;
      }
      if (meta != null) {
        return meta.founderUid == uid
            ? _FounderOutcome.founded
            : _FounderOutcome.alreadyExists;
      }
      // No meta yet — try to become the founder.
      try {
        await _congregations
            .createMeta(CongregationMeta(name: name, founderUid: uid));
        return _FounderOutcome.founded;
      } on FirebaseException catch (e) {
        if (_isTransient(e)) continue; // cold DB / lost race — re-probe
        rethrow;
      }
    }
    return _FounderOutcome.notReady;
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

  /// Permanently deletes the signed-in user's account (Apple Guideline
  /// 5.1.1(v)). The password re-authenticates the (possibly stale) session so
  /// Firebase permits `user.delete()`; it also fails fast on a wrong password
  /// before any data is removed.
  ///
  /// Order matters: Firestore self-deletes need `request.auth.uid ==
  /// publisherId`, and the PW rules need the caller to still be a verified
  /// publisher — so we clear the sub-resources and the publisher doc *before*
  /// deleting the auth user. Doc deletes are idempotent, so an interrupted
  /// registration (no publisher doc) is handled too.
  Future<void> deleteAccount({required String password}) async {
    final user = _auth.currentUser!;
    final email = user.email;
    if (email != null && email.isNotEmpty) {
      final cred = EmailAuthProvider.credential(email: email, password: password);
      await user.reauthenticateWithCredential(cred);
    }
    final uid = user.uid;
    // Best-effort: a PW read hiccup must not block account deletion.
    try {
      await _pw.deleteAllForPublisher(uid);
    } on FirebaseException catch (_) {}
    // Removes publishers/{uid} and its private/profile sub-doc in one batch.
    try {
      await _publishers.delete(uid);
    } on FirebaseException catch (_) {}
    await user.delete();
  }

  /// Changes the signed-in user's password. The current password
  /// re-authenticates the (possibly stale) session so Firebase permits
  /// `user.updatePassword()`, and fails fast on a wrong current password
  /// before the new one is applied.
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser!;
    final email = user.email;
    if (email != null && email.isNotEmpty) {
      final cred =
          EmailAuthProvider.credential(email: email, password: currentPassword);
      await user.reauthenticateWithCredential(cred);
    }
    await user.updatePassword(newPassword);
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

  static const _maxAttempts = 5;

  /// Firestore error codes worth retrying while a fresh project / auth token
  /// settles. `permission-denied` is included because a not-yet-propagated
  /// token makes an authorized write look unauthenticated.
  static const _transientCodes = <String>{
    'permission-denied',
    'unavailable',
    'deadline-exceeded',
    'aborted',
    'internal',
    'unknown',
  };

  bool _isTransient(Object e) =>
      e is FirebaseException && _transientCodes.contains(e.code);

  Duration _backoff(int n) =>
      Duration(milliseconds: (250 * (1 << n)).clamp(250, 2000));

  /// Runs [op], retrying transient Firestore failures with backoff.
  Future<T> _retry<T>(Future<T> Function() op) async {
    for (var attempt = 0;; attempt++) {
      try {
        return await op();
      } on FirebaseException catch (e) {
        if (!_isTransient(e) || attempt >= _maxAttempts - 1) rethrow;
        await Future<void>.delayed(_backoff(attempt));
      }
    }
  }
}

/// True while a "set up new congregation" registration is running. The router
/// consults it to avoid bouncing the founder to the complete-profile screen
/// during the brief window where they are signed in without a publisher doc.
class RegistrationInProgressNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final registrationInProgressProvider =
    NotifierProvider<RegistrationInProgressNotifier, bool>(
        RegistrationInProgressNotifier.new);

final authServiceProvider = Provider<AuthService>((ref) => AuthService(
      ref.watch(firebaseAuthProvider),
      ref.watch(congregationRepositoryProvider),
      ref.watch(publishersRepositoryProvider),
      ref.watch(pwRepositoryProvider),
    ));
