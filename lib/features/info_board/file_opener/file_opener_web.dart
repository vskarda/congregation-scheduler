import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<void> openFileBytes({
  required Uint8List bytes,
  required String name,
  required String mimeType,
}) async {
  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: mimeType),
  );
  final url = web.URL.createObjectURL(blob);
  web.window.open(url, '_blank');
  // Give the new tab a moment to take over the blob before revoking.
  Future<void>.delayed(const Duration(minutes: 1),
      () => web.URL.revokeObjectURL(url));
}
