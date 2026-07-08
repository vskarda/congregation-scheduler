import 'dart:typed_data';

import 'file_opener_io.dart' if (dart.library.js_interop) 'file_opener_web.dart'
    as impl;

/// Opens downloaded file bytes with the platform's viewer: a temp file +
/// system app on Android/iOS, a blob URL in a new tab on the web.
Future<void> openFileBytes({
  required Uint8List bytes,
  required String name,
  required String mimeType,
}) =>
    impl.openFileBytes(bytes: bytes, name: name, mimeType: mimeType);
