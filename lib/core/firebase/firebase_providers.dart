import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_bootstrap.dart';

/// Overridden in main() with the real instance (loaded before runApp).
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('overridden in main'),
);

class FirebaseReadyNotifier extends Notifier<bool> {
  @override
  bool build() => FirebaseBootstrap.isInitialized;

  void markReady() => state = true;
}

/// Whether Firebase has been initialized with a stored congregation config.
final firebaseReadyProvider =
    NotifierProvider<FirebaseReadyNotifier, bool>(FirebaseReadyNotifier.new);

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  ref.watch(firebaseReadyProvider);
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  ref.watch(firebaseReadyProvider);
  return FirebaseFirestore.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  if (!ref.watch(firebaseReadyProvider)) {
    return Stream<User?>.value(null);
  }
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final currentUidProvider =
    Provider<String?>((ref) => ref.watch(authStateProvider).value?.uid);
