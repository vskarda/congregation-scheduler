import 'dart:convert';

/// Extracts the epub download URL (`files.{lang}.EPUB[0].file.url`) from a
/// pub-media GETPUBMEDIALINKS JSON response; null when the response does not
/// carry one, or carries one the app refuses to fetch (see below).
///
/// The URL is remote input, so the transport is pinned to https here rather
/// than at the call site: Dart's `HttpClient` — which `package:http` uses on
/// mobile — does not consult Android's cleartext-traffic policy, so an
/// `http://` value would download the workbook in the clear with nothing on
/// the platform side to stop it. Rejecting it reads as "issue not published"
/// upstream, the same as a missing URL.
///
/// Deliberately no host allowlist: jw.org serves publication media from
/// several CDN domains, and pinning them would break the import the day one
/// changes.
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
  if (url is! String || url.isEmpty) return null;
  final parsed = Uri.tryParse(url);
  return parsed != null && parsed.isScheme('https') ? url : null;
}
