import 'dart:io';
import 'dart:typed_data';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveBytesToFile({
  required Uint8List bytes,
  required String name,
  required String mimeType,
}) async {
  final dir = await getTemporaryDirectory();
  final safeName = name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  final file = File('${dir.path}${Platform.pathSeparator}$safeName');
  await file.writeAsBytes(bytes, flush: true);
  await OpenFilex.open(file.path, type: mimeType);
}
