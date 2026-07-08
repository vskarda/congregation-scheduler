import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/firebase/firebase_bootstrap.dart';
import '../../core/l10n/l10n.dart';

Future<void> showInviteDialog(
    BuildContext context, String congregationName) async {
  final config = await FirebaseBootstrap.storedConfig();
  if (config == null || !context.mounted) return;
  final payload = jsonEncode({
    'firebaseConfig': jsonDecode(config),
    'congregationName': congregationName,
  });
  await showDialog<void>(
    context: context,
    builder: (context) {
      final l10n = context.l10n;
      return AlertDialog(
        title: Text(l10n.pubAdminInviteTitle),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.pubAdminInviteBody),
              const SizedBox(height: 16),
              // White backdrop keeps the QR scannable in dark mode.
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: QrImageView(data: payload, size: 260),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Clipboard.setData(ClipboardData(text: payload)),
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('JSON'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonClose),
          ),
        ],
      );
    },
  );
}
