import 'dart:typed_data';

import 'package:pdfrx/pdfrx.dart';

bool _initialized = false;

/// Extracts the plain text of every page of a PDF.
Future<List<String>> extractPdfPageTexts(Uint8List bytes) async {
  if (!_initialized) {
    await pdfrxFlutterInitialize();
    _initialized = true;
  }
  final doc = await PdfDocument.openData(bytes);
  try {
    return [
      for (final page in doc.pages) (await page.loadText())?.fullText ?? '',
    ];
  } finally {
    await doc.dispose();
  }
}
