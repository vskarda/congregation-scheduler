import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congregation_scheduler/core/firebase/firebase_bootstrap.dart';
import 'package:congregation_scheduler/core/firebase/firebase_providers.dart';
import 'package:congregation_scheduler/l10n/generated/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Credentials for the live test congregation, injected at build time.
///
/// A web build has no filesystem, so `.credits/` cannot be read from inside
/// the test. `scripts/live-test.ps1` reads the folder and forwards the values
/// as `--dart-define`s. They are base64-encoded so that JSON braces, quotes
/// and password punctuation survive the shell without escaping.
///
/// Everything is read at run time and nothing is committed, so rotating the
/// credentials means editing `.credits/` — no code change.
class LiveCredentials {
  const LiveCredentials({
    required this.firebaseConfig,
    required this.email,
    required this.password,
  });

  /// Firebase web config JSON, as pasted into the Setup wizard.
  final String firebaseConfig;
  final String email;
  final String password;

  static const _configB64 = String.fromEnvironment('LIVE_FIREBASE_CONFIG_B64');
  static const _emailB64 = String.fromEnvironment('LIVE_ADMIN_EMAIL_B64');
  static const _passwordB64 = String.fromEnvironment('LIVE_ADMIN_PASSWORD_B64');

  /// Null when the suite was run without credentials, which is the signal to
  /// skip rather than fail — `flutter test` and CI must stay green for
  /// everyone who has no access to the test congregation.
  static LiveCredentials? fromEnvironment() {
    if (_configB64.isEmpty || _emailB64.isEmpty || _passwordB64.isEmpty) {
      return null;
    }
    return LiveCredentials(
      firebaseConfig: _decode(_configB64),
      email: _decode(_emailB64),
      password: _decode(_passwordB64),
    );
  }

  static String _decode(String value) => utf8.decode(base64.decode(value));
}

/// Connects the tests to the real congregation project and provides the few
/// helpers a live test needs that an offline widget test does not.
abstract final class LiveHarness {
  static bool _firebaseUp = false;
  static String? _adminUid;

  /// Uid of the signed-in congregation admin. Valid after [signInAsAdmin].
  static String get adminUid =>
      _adminUid ?? (throw StateError('call signInAsAdmin() first'));

  /// Project the tests are pointed at — worth asserting on before any write.
  static String get projectId => Firebase.app().options.projectId;

  /// Initializes Firebase from the supplied config and signs in the admin.
  /// Safe to call from every `setUpAll`; the work happens once.
  static Future<void> signInAsAdmin(LiveCredentials creds) async {
    if (!_firebaseUp) {
      final options = FirebaseBootstrap.parseOptions(creds.firebaseConfig);
      if (options == null) {
        throw StateError(
            '.credits/.congregation.json is not a usable Firebase config');
      }
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: options);
      }
      // Deliberately unlike the app (which enables persistence): a test must
      // observe the server, not a cached replica left by an earlier run.
      FirebaseFirestore.instance.settings =
          const Settings(persistenceEnabled: false);
      // Lets firebaseReadyProvider — and therefore the router — come up true.
      FirebaseBootstrap.isInitialized = true;
      _firebaseUp = true;
    }
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      await auth.signInWithEmailAndPassword(
          email: creds.email.trim(), password: creds.password);
    }
    _adminUid = auth.currentUser!.uid;
  }

  /// Wraps [home] the way the app does, against the *real* Firestore.
  ///
  /// Only `sharedPreferencesProvider` is overridden, because it throws unless
  /// something supplies it; every other provider resolves to the live
  /// instance, so rules, indexes and document shapes are all exercised. A test
  /// that does need to override something should build its own [ProviderScope]
  /// inline — Riverpod 3 does not export the `Override` type, so it cannot be
  /// named in a signature here.
  static Future<Widget> wrap(Widget home) async {
    final prefs = await SharedPreferences.getInstance();
    return ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    );
  }

  /// Pumps until [condition] holds.
  ///
  /// `pumpAndSettle` cannot be used here: a live Firestore listener keeps the
  /// frame pipeline busy and never reaches a steady state, so it times out
  /// even when the screen is perfectly fine.
  static Future<void> waitFor(
    WidgetTester tester,
    bool Function() condition, {
    String? reason,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 100));
      if (condition()) return;
    }
    fail('timed out after $timeout waiting for ${reason ?? 'condition'}');
  }

  // --- throwaway data -------------------------------------------------

  /// Distinguishes this run's documents from a previous one's.
  static final String runId =
      DateTime.now().millisecondsSinceEpoch.toRadixString(36);

  static final List<DocumentReference<Map<String, dynamic>>> _created = [];

  /// Id for a document this run creates. The `test_` prefix keeps live data
  /// visibly separate and lets [sweepOrphans] clean up after a crashed run.
  static String testId(String label) => 'test_${runId}_$label';

  /// Registers [ref] for deletion by [cleanUp].
  static DocumentReference<Map<String, dynamic>> track(
      DocumentReference<Map<String, dynamic>> ref) {
    _created.add(ref);
    return ref;
  }

  /// Deletes everything [track]ed, newest first. Best-effort: a failure here
  /// must not mask the actual test result.
  static Future<void> cleanUp() async {
    for (final ref in _created.reversed) {
      try {
        await ref.delete();
      } catch (_) {}
    }
    _created.clear();
  }

  /// Removes `test_`-prefixed leftovers from [collection], including those of
  /// earlier runs that ended before [cleanUp] could run. The range is a
  /// prefix match: '`' (0x60) is the next code point after '_' (0x5F).
  static Future<int> sweepOrphans(String collection) async {
    final snap = await FirebaseFirestore.instance
        .collection(collection)
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: 'test_')
        .where(FieldPath.documentId, isLessThan: 'test`')
        .get();
    for (final doc in snap.docs) {
      await doc.reference.delete();
    }
    return snap.docs.length;
  }
}
