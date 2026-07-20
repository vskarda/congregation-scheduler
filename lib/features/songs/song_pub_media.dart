import 'dart:convert';

/// Parses a pub-media GETPUBMEDIALINKS JSON response for the songbook (pub
/// `sjjm`) into an ordered `{songNumber: title}` map. Each track title has the
/// form "N. Song Title"; the first occurrence of a number wins, so the plain
/// track is kept over the later "(With Audio Descriptions)" duplicate. Returns
/// null when the body is not parseable or carries no tracks for [lang].
Map<int, String>? songTitlesFromPubMedia(String jsonBody, String lang) {
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
  final tracks = perLang['MP3'];
  if (tracks is! List || tracks.isEmpty) return null;

  final pattern = RegExp(r'^\s*(\d+)\.\s*(.+)$');
  final titles = <int, String>{};
  for (final track in tracks) {
    if (track is! Map) continue;
    final title = track['title'];
    if (title is! String) continue;
    final match = pattern.firstMatch(title);
    if (match == null) continue;
    final no = int.parse(match.group(1)!);
    titles.putIfAbsent(no, () => match.group(2)!.trim());
  }
  return titles.isEmpty ? null : titles;
}
