import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;

/// Unicode fonts embedded into generated PDFs; the pdf package's built-in
/// Helvetica lacks the Latin Extended-A glyphs Czech needs.
///
/// [fallback] holds fonts consulted for glyphs the [base]/[bold] pair cannot
/// render — currently the Japanese (CJK) font, since Noto Sans covers Latin
/// scripts only. Wire it into the document via
/// `pw.ThemeData.withFont(base: base, bold: bold, fontFallback: fallback)`.
class PdfFonts {
  const PdfFonts({
    required this.base,
    required this.bold,
    this.fallback = const [],
  });

  final pw.Font base;
  final pw.Font bold;
  final List<pw.Font> fallback;
}

Future<PdfFonts> loadPdfFonts() async {
  final base =
      pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'));
  final bold =
      pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'));
  final jp =
      pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSansJP-Regular.ttf'));
  return PdfFonts(base: base, bold: bold, fallback: [jp]);
}

