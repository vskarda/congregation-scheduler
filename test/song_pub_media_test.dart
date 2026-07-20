import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:congregation_scheduler/features/songs/song_pub_media.dart';

void main() {
  String body(List<Map<String, String>> tracks, {String lang = 'E'}) =>
      jsonEncode({
        'files': {
          lang: {
            'MP3': [
              for (final t in tracks) {'title': t['title']},
            ],
          },
        },
      });

  group('songTitlesFromPubMedia', () {
    test('parses "N. Title" tracks into a number->title map', () {
      final titles = songTitlesFromPubMedia(
        body([
          {'title': "1. Jehovah's Attributes"},
          {'title': '2. Jehovah Is Your Name'},
        ]),
        'E',
      );
      expect(titles, {1: "Jehovah's Attributes", 2: 'Jehovah Is Your Name'});
    });

    test('keeps the first occurrence, dropping audio-described duplicates', () {
      final titles = songTitlesFromPubMedia(
        body([
          {'title': "1. Jehovah's Attributes"},
          {'title': "1. Jehovah's Attributes (With Audio Descriptions)"},
        ]),
        'E',
      );
      expect(titles, {1: "Jehovah's Attributes"});
    });

    test('resolves the language key', () {
      final titles = songTitlesFromPubMedia(
        body([
          {'title': '1. Jehovovy vlastnosti'},
        ], lang: 'B'),
        'B',
      );
      expect(titles, {1: 'Jehovovy vlastnosti'});
    });

    test('returns null for a missing language', () {
      expect(
        songTitlesFromPubMedia(body([
          {'title': '1. Title'},
        ]), 'B'),
        isNull,
      );
    });

    test('returns null for malformed JSON', () {
      expect(songTitlesFromPubMedia('not json', 'E'), isNull);
    });

    test('returns null when no track title matches the pattern', () {
      expect(
        songTitlesFromPubMedia(body([
          {'title': 'Introduction'},
        ]), 'E'),
        isNull,
      );
    });
  });
}
