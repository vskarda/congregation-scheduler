import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../../../core/models/models.dart';
import '../../../core/utils/dates.dart';
import 'mwb_parser.dart';
import 'pub_media.dart';

/// Opens the native file picker for a .epub and parses it.
/// Returns null if the user cancels the picker.
Future<List<LmmWeek>?> pickEpubWeeks() async {
  final result = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['epub'],
    withData: true,
  );
  final bytes = result?.files.single.bytes;
  if (bytes == null) return null;
  return MwbParser.parse(bytes, fileName: result!.files.single.name);
}

/// Fetches the current + next Meeting Workbook issue from the CDN for
/// [locale]. Returns null if neither issue is published yet.
Future<List<LmmWeek>?> fetchCdnWeeks(Locale locale) async {
  const template = AppConfig.workbookCdnUrlTemplate;
  final lang = switch (locale.languageCode) {
    'cs' => 'B',
    'tr' => 'TK',
    _ => 'E',
  };
  final now = DateTime.now();
  // Workbook issues cover two months starting with odd months; try the
  // current issue and the next one (which may not be published yet).
  final currentIssue =
      DateTime(now.year, now.month.isOdd ? now.month : now.month - 1);
  final weeksById = <String, LmmWeek>{};
  var fetchedAny = false;
  for (final issue in [currentIssue, addMonths(currentIssue, 2)]) {
    final url = template.replaceAll('{lang}', lang).replaceAll(
        '{yyyyMM}', '${issue.year}${issue.month.toString().padLeft(2, '0')}');
    final api = await http.get(Uri.parse(url));
    if (api.statusCode == 404) continue; // issue not published yet
    if (api.statusCode != 200) throw Exception('HTTP ${api.statusCode}');
    final epubUrl = epubUrlFromPubMedia(api.body, lang);
    if (epubUrl == null) continue;
    final epub = await http.get(Uri.parse(epubUrl));
    if (epub.statusCode != 200) throw Exception('HTTP ${epub.statusCode}');
    fetchedAny = true;
    final weeks =
        MwbParser.parse(epub.bodyBytes, fileName: epubUrl, source: 'cdn');
    for (final week in weeks) {
      weeksById[week.id] = week;
    }
  }
  if (!fetchedAny) return null;
  return weeksById.values.toList()..sort((a, b) => a.id.compareTo(b.id));
}
