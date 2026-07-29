import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'core/firebase/firebase_providers.dart';
import 'core/firebase/local_cache.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await FirebaseBootstrap.tryInitializeFromStoredConfig();
  // Drops a Firestore cache left behind by an earlier sign-out. Has to happen
  // here, before the first read attaches a listener — see [LocalCache].
  await LocalCache.clearIfStale();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const CongregationApp(),
    ),
  );
}
