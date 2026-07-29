import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_bootstrap.dart';
import 'firebase_providers.dart';

/// Disposal of the on-device Firestore cache.
///
/// Offline persistence (enabled in [FirebaseBootstrap]) keeps a local copy of
/// every document the signed-in user has read. For someone holding
/// `roles.publishers` that includes every `publishers/{uid}/private/profile`
/// — e-mail, phone, address, birth date, emergency note — and for
/// `roles.reports` every publisher's field-service history. Signing out does
/// not touch that copy, so on a shared or handed-on device one person's data
/// outlives their session.
///
/// The cache cannot be dropped while the app is running: `clearPersistence()`
/// only succeeds before a Firestore client has started and while no listener
/// is attached. Sign-out therefore just *marks* the cache and [clearIfStale]
/// does the work from `main()` on the next launch — the one moment that
/// precondition holds.
///
/// Nothing user-visible changes: signing back in needs the network anyway, and
/// the first sync after a clear repopulates the cache.
abstract final class LocalCache {
  static const prefsKey = 'firestore_cache_stale';

  /// Marks the cache for deletion at the next launch. Call this *before*
  /// signing out, so an interrupted sign-out still errs towards clearing.
  static Future<void> markStale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefsKey, true);
  }

  /// Clears a marked cache. Must run after Firebase came up but before the
  /// first Firestore read, i.e. from `main()` ahead of `runApp`.
  ///
  /// The flag survives anything short of a completed deletion — a launch with
  /// no stored config, or a client that had already started — so the clear is
  /// simply retried on the following launch rather than being lost.
  static Future<void> clearIfStale() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(prefsKey) != true) return;
    if (!FirebaseBootstrap.isInitialized) return;
    try {
      await FirebaseFirestore.instance.clearPersistence();
    } catch (_) {
      return;
    }
    await prefs.remove(prefsKey);
  }
}

/// Signs out and schedules the local cache for deletion. Use this everywhere
/// instead of calling `FirebaseAuth.signOut()` directly, so no sign-out path
/// leaves the previous user's documents on the device.
Future<void> signOutAndClearLocalCache(WidgetRef ref) async {
  await LocalCache.markStale();
  await ref.read(firebaseAuthProvider).signOut();
}
