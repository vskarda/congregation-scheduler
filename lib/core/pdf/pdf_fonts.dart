import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;

/// Unicode fonts embedded into generated PDFs; the pdf package's built-in
/// Helvetica lacks the Latin Extended-A glyphs Czech needs.
class PdfFonts {
  const PdfFonts({required this.base, required this.bold});

  final pw.Font base;
  final pw.Font bold;
}

Future<PdfFonts> loadPdfFonts() async => PdfFonts(
      base: pw.Font.ttf(
          await rootBundle.load('assets/fonts/NotoSans-Regular.ttf')),
      bold:
          pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Bold.ttf')),
    );
