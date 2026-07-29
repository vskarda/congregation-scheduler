import 'dart:convert';

import 'package:congregation_scheduler/features/lmm_schedule/epub_import/pub_media.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String body(String url, {String lang = 'E'}) => jsonEncode({
        'files': {
          lang: {
            'EPUB': [
              {
                'file': {'url': url},
              },
            ],
          },
        },
      });

  group('epubUrlFromPubMedia', () {
    test('returns the https download url', () {
      const url = 'https://cfp2.jw-cdn.org/a/x/mwb_E.epub';
      expect(epubUrlFromPubMedia(body(url), 'E'), url);
    });

    test('is case-insensitive about the scheme', () {
      expect(
        epubUrlFromPubMedia(body('HTTPS://cfp2.jw-cdn.org/mwb_E.epub'), 'E'),
        'HTTPS://cfp2.jw-cdn.org/mwb_E.epub',
      );
    });

    // The response is remote input and Dart's HttpClient ignores Android's
    // cleartext-traffic policy, so a downgraded url must be refused here or
    // the workbook downloads in the clear.
    test('refuses a cleartext download url', () {
      expect(
        epubUrlFromPubMedia(body('http://cfp2.jw-cdn.org/mwb_E.epub'), 'E'),
        isNull,
      );
    });

    test('refuses non-http schemes', () {
      for (final url in [
        'file:///data/local/tmp/evil.epub',
        'ftp://example.org/mwb_E.epub',
        '//cfp2.jw-cdn.org/mwb_E.epub',
        'mwb_E.epub',
      ]) {
        expect(epubUrlFromPubMedia(body(url), 'E'), isNull, reason: url);
      }
    });

    test('returns null for an empty url or a missing language', () {
      expect(epubUrlFromPubMedia(body(''), 'E'), isNull);
      expect(epubUrlFromPubMedia(body('https://x/mwb_B.epub', lang: 'B'), 'E'),
          isNull);
    });

    test('returns null for a malformed response', () {
      expect(epubUrlFromPubMedia('not json', 'E'), isNull);
      expect(epubUrlFromPubMedia('{"files":{"E":{"EPUB":[]}}}', 'E'), isNull);
    });
  });
}
