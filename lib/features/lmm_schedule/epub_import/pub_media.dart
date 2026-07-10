import 'dart:convert';

/// Extracts the epub download URL (`files.{lang}.EPUB[0].file.url`) from a
/// pub-media GETPUBMEDIALINKS JSON response; null when the response does not
/// carry one.
String? epubUrlFromPubMedia(String jsonBody, String lang) {
  final Object? decoded;
  try {
    decoded = jsonDecode(jsonBody);
  } on FormatException {
    return null;
  }
  if (decoded is! Map) return null;
  final files = decoded['files'];
  if (files is! Map) return null;
  final perLang = files[lang];
  if (perLang is! Map) return null;
  final epubs = perLang['EPUB'];
  if (epubs is! List || epubs.isEmpty) return null;
  final entry = epubs.first;
  if (entry is! Map) return null;
  final file = entry['file'];
  if (file is! Map) return null;
  final url = file['url'];
  return url is String && url.isNotEmpty ? url : null;
}
