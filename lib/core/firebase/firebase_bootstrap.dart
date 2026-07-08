import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Initializes Firebase at runtime from a congregation-provided web config
/// JSON instead of compiled-in options, so one app binary can serve any
/// self-hosted congregation.
abstract final class FirebaseBootstrap {
  static const prefsKey = 'firebase_config_json';

  static bool isInitialized = false;

  /// Accepts what admins actually paste from the Firebase console: either
  /// strict JSON or the JS `const firebaseConfig = { apiKey: '…', … };`
  /// snippet. Returns normalized JSON text, or null if it can't be salvaged.
  static String? normalizeConfigText(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start < 0 || end <= start) return null;
    var s = text.substring(start, end + 1);
    // Quote bare JS identifiers used as keys.
    s = s.replaceAllMapped(
      RegExp(r'([{,]\s*)([A-Za-z_][A-Za-z0-9_]*)\s*:'),
      (m) => '${m[1]}"${m[2]}":',
    );
    s = s.replaceAll("'", '"');
    // Drop trailing commas.
    s = s.replaceAllMapped(RegExp(r',(\s*[}\]])'), (m) => m[1]!);
    try {
      final decoded = jsonDecode(s);
      if (decoded is! Map<String, dynamic>) return null;
      return jsonEncode(decoded);
    } on FormatException {
      return null;
    }
  }

  static FirebaseOptions? parseOptions(String jsonText) {
    Object? raw;
    try {
      raw = jsonDecode(jsonText);
    } on FormatException {
      return null;
    }
    if (raw is! Map<String, dynamic>) return null;
    // Invite QR codes wrap the config: {"firebaseConfig": {...}, ...}.
    if (raw['firebaseConfig'] is Map) {
      raw = (raw['firebaseConfig'] as Map).cast<String, dynamic>();
    }
    final apiKey = raw['apiKey'];
    final appId = raw['appId'];
    final projectId = raw['projectId'];
    if (apiKey is! String || appId is! String || projectId is! String) {
      return null;
    }
    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      projectId: projectId,
      messagingSenderId: (raw['messagingSenderId'] as String?) ?? '',
      authDomain: raw['authDomain'] as String?,
      storageBucket: raw['storageBucket'] as String?,
      measurementId: raw['measurementId'] as String?,
    );
  }

  /// Called from main() before runApp. Returns true when a stored config
  /// exists and Firebase came up with it.
  static Future<bool> tryInitializeFromStoredConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(prefsKey);
    if (stored == null) return false;
    final options = parseOptions(stored);
    if (options == null) return false;
    try {
      await Firebase.initializeApp(options: options);
      isInitialized = true;
      _configureFirestore();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Setup-wizard path: normalize, initialize, verify the project actually
  /// answers, then persist. Throws [FormatException] for unparsable input and
  /// rethrows Firebase errors for unreachable/invalid projects.
  ///
  /// Returns false when the config was stored but the default Firebase app
  /// already exists with different options — an app restart is required.
  static Future<bool> initializeAndStore(String rawText) async {
    final normalized = normalizeConfigText(rawText);
    final options = normalized == null ? null : parseOptions(normalized);
    if (normalized == null || options == null) {
      throw const FormatException('invalid firebase config');
    }
    if (Firebase.apps.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(prefsKey, normalized);
      return false;
    }
    await Firebase.initializeApp(options: options);
    _configureFirestore();
    try {
      // Reachability probe: rules deny unauthenticated reads with
      // permission-denied, which still proves the project id + API key work.
      await FirebaseFirestore.instance
          .collection('congregation')
          .doc('meta')
          .get(const GetOptions(source: Source.server));
    } on FirebaseException catch (e) {
      if (e.code != 'permission-denied') rethrow;
    }
    isInitialized = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsKey, normalized);
    return true;
  }

  static Future<String?> storedConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(prefsKey);
  }

  /// Removing the config requires an app restart to take effect (the default
  /// Firebase app cannot be re-initialized with different options).
  static Future<void> clearStoredConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefsKey);
  }

  static void _configureFirestore() {
    try {
      FirebaseFirestore.instance.settings =
          const Settings(persistenceEnabled: true);
    } catch (_) {
      // Persistence is best-effort (may be unsupported in some browsers).
    }
  }
}
