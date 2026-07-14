import 'dart:convert';
import 'dart:typed_data';

import '../../core/models/models.dart';

/// One data row from the pasted/imported text, in source order.
class TerritoryImportRow {
  const TerritoryImportRow({
    required this.line,
    required this.name,
    this.number = '',
    this.mapUrl = '',
    this.notes = '',
  });

  /// 1-based line in the source text, for error display.
  final int line;
  final String name;
  final String number;
  final String mapUrl;
  final String notes;
}

enum TerritoryImportStatus { newEntry, duplicate, duplicateInFile, invalid }

class TerritoryImportEntry {
  const TerritoryImportEntry(this.row, this.status, {this.existing});

  final TerritoryImportRow row;
  final TerritoryImportStatus status;

  /// The matching territory when [status] is [TerritoryImportStatus.duplicate].
  final Territory? existing;
}

/// Windows-1250 code points for bytes 0x80–0xFF (Czech Excel's CSV encoding).
const List<int> _cp1250High = [
  0x20AC, 0x0081, 0x201A, 0x0083, 0x201E, 0x2026, 0x2020, 0x2021, //
  0x0088, 0x2030, 0x0160, 0x2039, 0x015A, 0x0164, 0x017D, 0x0179,
  0x0090, 0x2018, 0x2019, 0x201C, 0x201D, 0x2022, 0x2013, 0x2014,
  0x0098, 0x2122, 0x0161, 0x203A, 0x015B, 0x0165, 0x017E, 0x017A,
  0x00A0, 0x02C7, 0x02D8, 0x0141, 0x00A4, 0x0104, 0x00A6, 0x00A7,
  0x00A8, 0x00A9, 0x015E, 0x00AB, 0x00AC, 0x00AD, 0x00AE, 0x017B,
  0x00B0, 0x00B1, 0x02DB, 0x0142, 0x00B4, 0x00B5, 0x00B6, 0x00B7,
  0x00B8, 0x0105, 0x015F, 0x00BB, 0x013D, 0x02DD, 0x013E, 0x017C,
  0x0154, 0x00C1, 0x00C2, 0x0102, 0x00C4, 0x0139, 0x0106, 0x00C7,
  0x010C, 0x00C9, 0x0118, 0x00CB, 0x011A, 0x00CD, 0x00CE, 0x010E,
  0x0110, 0x0143, 0x0147, 0x00D3, 0x00D4, 0x0150, 0x00D6, 0x00D7,
  0x0158, 0x016E, 0x00DA, 0x0170, 0x00DC, 0x00DD, 0x0162, 0x00DF,
  0x0155, 0x00E1, 0x00E2, 0x0103, 0x00E4, 0x013A, 0x0107, 0x00E7,
  0x010D, 0x00E9, 0x0119, 0x00EB, 0x011B, 0x00ED, 0x00EE, 0x010F,
  0x0111, 0x0144, 0x0148, 0x00F3, 0x00F4, 0x0151, 0x00F6, 0x00F7,
  0x0159, 0x016F, 0x00FA, 0x0171, 0x00FC, 0x00FD, 0x0163, 0x02D9,
];

/// Decodes picked-file bytes: strips a UTF-8 BOM, tries strict UTF-8, and on
/// failure falls back to Windows-1250 (what Czech Excel writes for CSV).
String decodeImportBytes(Uint8List bytes) {
  var data = bytes;
  if (data.length >= 3 &&
      data[0] == 0xEF &&
      data[1] == 0xBB &&
      data[2] == 0xBF) {
    data = Uint8List.sublistView(data, 3);
  }
  try {
    return utf8.decode(data);
  } on FormatException {
    return String.fromCharCodes(
      data.map((b) => b < 0x80 ? b : _cp1250High[b - 0x80]),
    );
  }
}

/// Splits [text] into rows. Detects the delimiter (tab, semicolon or comma),
/// skips an optional header row and blank lines, and handles RFC-4180 quoting
/// (embedded delimiters, escaped quotes, embedded newlines).
/// Columns are fixed: name, number, map link, notes — trailing ones optional.
List<TerritoryImportRow> parseTerritoryImport(String text) {
  final records = _tokenize(text, _detectDelimiter(text));
  if (records.isNotEmpty && _isHeader(records.first.fields)) {
    records.removeAt(0);
  }
  String field(List<String> fields, int i) =>
      i < fields.length ? fields[i] : '';
  return [
    for (final r in records)
      TerritoryImportRow(
        line: r.line,
        name: field(r.fields, 0),
        number: field(r.fields, 1),
        mapUrl: field(r.fields, 2),
        notes: field(r.fields, 3),
      ),
  ];
}

/// Classifies parsed rows against the [existing] territories. Numbers are
/// compared numerically when possible ("01" matches "1"); rows without a
/// number can never be duplicates.
List<TerritoryImportEntry> analyzeTerritoryImport(
  List<TerritoryImportRow> rows,
  List<Territory> existing,
) {
  final byNumber = <String, Territory>{};
  for (final t in existing) {
    final key = _numberKey(t.number);
    if (key.isNotEmpty) byNumber.putIfAbsent(key, () => t);
  }
  final seenKeys = <String>{};
  final result = <TerritoryImportEntry>[];
  for (final row in rows) {
    if (row.name.isEmpty) {
      result.add(TerritoryImportEntry(row, TerritoryImportStatus.invalid));
      continue;
    }
    final key = _numberKey(row.number);
    if (key.isNotEmpty && !seenKeys.add(key)) {
      result.add(
        TerritoryImportEntry(row, TerritoryImportStatus.duplicateInFile),
      );
      continue;
    }
    final match = key.isEmpty ? null : byNumber[key];
    result.add(
      match != null
          ? TerritoryImportEntry(
              row,
              TerritoryImportStatus.duplicate,
              existing: match,
            )
          : TerritoryImportEntry(row, TerritoryImportStatus.newEntry),
    );
  }
  return result;
}

String _numberKey(String number) {
  final trimmed = number.trim();
  return int.tryParse(trimmed)?.toString() ?? trimmed.toLowerCase();
}

/// Tab on the first non-blank line wins (spreadsheet paste is always TSV);
/// otherwise the more frequent of ";" vs "," outside quotes; null means
/// single-column input (names only).
String? _detectDelimiter(String text) {
  for (final line in const LineSplitter().convert(text)) {
    if (line.trim().isEmpty) continue;
    if (line.contains('\t')) return '\t';
    break;
  }
  var semicolons = 0;
  var commas = 0;
  var inQuotes = false;
  for (var i = 0; i < text.length; i++) {
    final c = text[i];
    if (c == '"') {
      inQuotes = !inQuotes;
    } else if (!inQuotes) {
      if (c == ';') semicolons++;
      if (c == ',') commas++;
    }
  }
  if (semicolons == 0 && commas == 0) return null;
  return semicolons >= commas ? ';' : ',';
}

const _headerWords = {
  // en
  'name', 'number', 'no', 'link', 'url', 'map', 'maplink', 'notes', 'note',
  // cs
  'název', 'nazev', 'jméno', 'jmeno', 'číslo', 'cislo', 'odkaz', 'mapa',
  'poznámka', 'poznamka', 'poznámky', 'poznamky',
  // tr
  'ad', 'numara', 'bağlantı', 'baglanti', 'harita', 'not', 'notlar',
};

bool _isHeader(List<String> fields) =>
    fields.any((f) => _headerWords.contains(f.toLowerCase()));

class _Record {
  _Record(this.line, this.fields);

  final int line;
  final List<String> fields;
}

List<_Record> _tokenize(String text, String? delimiter) {
  final records = <_Record>[];
  var fields = <String>[];
  final field = StringBuffer();
  var inQuotes = false;
  var atFieldStart = true; // a quote only opens a field at its first char
  var line = 1;
  var recordLine = 1;

  void endField() {
    fields.add(field.toString().trim());
    field.clear();
    atFieldStart = true;
  }

  void endRecord() {
    endField();
    if (fields.any((f) => f.isNotEmpty)) {
      records.add(_Record(recordLine, fields));
    }
    fields = <String>[];
    recordLine = line;
  }

  for (var i = 0; i < text.length; i++) {
    final c = text[i];
    if (inQuotes) {
      if (c == '"') {
        if (i + 1 < text.length && text[i + 1] == '"') {
          field.write('"');
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        if (c == '\n') line++;
        field.write(c);
      }
    } else if (c == '"' && atFieldStart) {
      inQuotes = true;
      atFieldStart = false;
    } else if (c == delimiter) {
      endField();
    } else if (c == '\n') {
      line++;
      endRecord();
    } else if (c != '\r') {
      field.write(c);
      atFieldStart = false;
    }
  }
  endRecord();
  return records;
}
