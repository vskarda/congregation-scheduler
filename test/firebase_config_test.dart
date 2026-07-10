import 'package:congregation_scheduler/core/firebase/firebase_bootstrap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

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
