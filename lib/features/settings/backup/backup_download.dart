import 'dart:typed_data';

import 'backup_download_io.dart'
    if (dart.library.js_interop) 'backup_download_web.dart' as impl;

/// Saves [bytes] to a user-visible file: a real "Save As" download on the web
/// (an `<a download>` click), a temp file opened with the system app on
/// Android/iOS (so it can be shared to Files/Drive).
Future<void> saveBytesToFile({
  required Uint8List bytes,
  required String name,
  required String mimeType,
}) =>
    impl.saveBytesToFile(bytes: bytes, name: name, mimeType: mimeType);
