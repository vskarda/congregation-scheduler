import 'dart:convert';

import 'package:congregation_scheduler/core/firebase/firebase_bootstrap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('FirebaseBootstrap.normalizeConfigText', () {
    test('accepts strict JSON', () {
      final result = FirebaseBootstrap.normalizeConfigText(
          '{"apiKey": "k", "projectId": "p", "appId": "a"}');
      expect(result, isNotNull);
      expect(FirebaseBootstrap.parseOptions(result!), isNotNull);
    });

    test('accepts the JS snippet from the Firebase console', () {
      const snippet = '''
const firebaseConfig = {
  apiKey: 'AIzaX',
  authDomain: "demo.firebaseapp.com",
  projectId: "demo",
  storageBucket: "demo.firebasestorage.app",
  messagingSenderId: "123",
  appId: "1:123:web:abc",
};
''';
      final result = FirebaseBootstrap.normalizeConfigText(snippet);
      expect(result, isNotNull);
      final options = FirebaseBootstrap.parseOptions(result!);
      expect(options, isNotNull);
      expect(options!.apiKey, 'AIzaX');
      expect(options.projectId, 'demo');
      expect(options.messagingSenderId, '123');
    });

    test('rejects garbage', () {
      expect(FirebaseBootstrap.normalizeConfigText('hello'), isNull);
    });
  });

  group('FirebaseBootstrap.parseOptions', () {
    test('unwraps invite payloads', () {
      const payload =
          '{"firebaseConfig": {"apiKey": "k", "projectId": "p", '
          '"appId": "a"}, "congregationName": "Test"}';
      final options = FirebaseBootstrap.parseOptions(payload);
      expect(options, isNotNull);
      expect(options!.projectId, 'p');
    });

    test('rejects configs missing required fields', () {
      expect(
          FirebaseBootstrap.parseOptions('{"apiKey": "k"}'), isNull);
    });

    test('unwraps a doubly-nested envelope', () {
      // Shape produced when an already-corrupted invite payload (see the
      // storedConfig self-heal tests below) is wrapped again.
      const payload = '{"firebaseConfig": {"firebaseConfig": {"apiKey": "k", '
          '"projectId": "p", "appId": "a"}, "congregationName": "Inner"}, '
          '"congregationName": "Outer"}';
      final options = FirebaseBootstrap.parseOptions(payload);
      expect(options, isNotNull);
      expect(options!.projectId, 'p');
      expect(options.apiKey, 'k');
    });
  });

  group('FirebaseBootstrap.storedConfig self-heal', () {
    const flatConfig = '{"apiKey":"k","projectId":"p","appId":"a"}';

    test('returns a bare stored config unchanged', () async {
      SharedPreferences.setMockInitialValues(
          {FirebaseBootstrap.prefsKey: flatConfig});
      final result = await FirebaseBootstrap.storedConfig();
      expect(result, flatConfig);
    });

    test('flattens a wrapped invite envelope and rewrites prefs', () async {
      const wrapped = '{"firebaseConfig": {"apiKey": "k", "projectId": "p", '
          '"appId": "a"}, "congregationName": "Test"}';
      SharedPreferences.setMockInitialValues(
          {FirebaseBootstrap.prefsKey: wrapped});

      final result = await FirebaseBootstrap.storedConfig();
      final decoded = jsonDecode(result!) as Map<String, dynamic>;
      expect(decoded.containsKey('firebaseConfig'), isFalse);
      expect(decoded['apiKey'], 'k');
      expect(decoded['projectId'], 'p');

      // The fix persisted, so a fresh read returns the same flat value.
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(FirebaseBootstrap.prefsKey), result);
    });

    test('flattens a doubly-wrapped envelope, matching the reported bug',
        () async {
      const doublyWrapped =
          '{"firebaseConfig": {"firebaseConfig": {"apiKey": "k", '
          '"projectId": "p", "appId": "a"}, "congregationName": "Inner"}, '
          '"congregationName": "Outer"}';
      SharedPreferences.setMockInitialValues(
          {FirebaseBootstrap.prefsKey: doublyWrapped});

      final result = await FirebaseBootstrap.storedConfig();
      final decoded = jsonDecode(result!) as Map<String, dynamic>;
      expect(decoded.containsKey('firebaseConfig'), isFalse);
      expect(decoded['apiKey'], 'k');
    });

    test('an invite built from a healed config wraps only once', () async {
      const wrapped = '{"firebaseConfig": {"apiKey": "k", "projectId": "p", '
          '"appId": "a"}, "congregationName": "Test"}';
      SharedPreferences.setMockInitialValues(
          {FirebaseBootstrap.prefsKey: wrapped});

      final config = await FirebaseBootstrap.storedConfig();
      // Mirrors the payload construction in invite_dialog.dart.
      final payload = jsonEncode({
        'firebaseConfig': jsonDecode(config!),
        'congregationName': 'Test',
      });
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      final inner = decoded['firebaseConfig'] as Map<String, dynamic>;
      expect(inner.containsKey('firebaseConfig'), isFalse);
      expect(inner['apiKey'], 'k');
    });
  });

  group('FirebaseBootstrap.parseOptions app id platform adaptation', () {
    const webConfig =
        '{"apiKey": "k", "projectId": "p", "appId": "1:123:web:abc"}';

    tearDown(() => debugDefaultTargetPlatformOverride = null);

    test('rewrites the web platform token to ios on Apple platforms', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(
          FirebaseBootstrap.parseOptions(webConfig)!.appId, '1:123:ios:abc');

      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      expect(
          FirebaseBootstrap.parseOptions(webConfig)!.appId, '1:123:ios:abc');
    });

    test('keeps the original web app id on Android', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(
          FirebaseBootstrap.parseOptions(webConfig)!.appId, '1:123:web:abc');
    });

    test('leaves a non-web app id untouched on iOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      const iosConfig =
          '{"apiKey": "k", "projectId": "p", "appId": "1:123:ios:def"}';
      expect(
          FirebaseBootstrap.parseOptions(iosConfig)!.appId, '1:123:ios:def');
    });
  });
}
