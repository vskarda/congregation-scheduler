import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/pub_lang.dart';
import 'song_pub_media.dart';

/// Fetches the meeting songbook titles from the pub-media CDN for [locale] and
/// builds a [SongCatalog]. Returns null when the songbook is not published for
/// that language (404 or empty). Web builds may be blocked by CORS.
Future<SongCatalog?> fetchSongCatalogFromCdn(Locale locale) async {
  final lang = pubLangFor(locale);
  final url =
      AppConfig.songCatalogCdnUrlTemplate.replaceAll('{lang}', lang);
  final res = await http.get(Uri.parse(url));
  if (res.statusCode == 404) return null;
  if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
  final titles = songTitlesFromPubMedia(res.body, lang);
  if (titles == null) return null;
  return SongCatalog(
    titles: {for (final e in titles.entries) '${e.key}': e.value},
    updatedAt: dateKey(DateTime.now()),
    lang: lang,
  );
}
