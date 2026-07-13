import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/firebase/firebase_bootstrap.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/language_menu_button.dart';
import 'qr_scan_screen.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _configCtrl = TextEditingController();
  bool _busy = false;
  String? _message;

  @override
  void dispose() {
    _configCtrl.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    final l10n = context.l10n;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final initialized =
          await FirebaseBootstrap.initializeAndStore(_configCtrl.text);
      if (!mounted) return;
      if (!initialized) {
        setState(() => _message = l10n.setupRestartRequired);
        return;
      }
      ref.read(firebaseReadyProvider.notifier).markReady();
      context.go('/setup/mode');
    } on FormatException {
      setState(() => _message = l10n.setupInvalidJson);
    } catch (e) {
      setState(() => _message = l10n.setupConnectionFailed(e.toString()));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _scan() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const QrScanScreen()),
    );
    if (result == null || result.isEmpty || !mounted) return;
    _configCtrl.text = result;
    await _connect();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setupTitle),
        actions: const [LanguageMenuButton()],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              Text(l10n.setupIntro),
              const SizedBox(height: 24),
              TextField(
                controller: _configCtrl,
                minLines: 6,
                maxLines: 12,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                decoration: InputDecoration(
                  labelText: l10n.setupConfigLabel,
                  hintText: l10n.setupConfigHint,
                  alignLabelWithHint: true,
                ),
              ),
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _message!,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error),
                  ),
                ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _busy ? null : _connect,
                icon: _busy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.cloud_done_outlined),
                label: Text(l10n.setupConnect),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _busy ? null : _scan,
                icon: const Icon(Icons.qr_code_scanner),
                label: Text(l10n.setupScanQr),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.setupGuideLinkIntro,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => context.push('/setup/help'),
                icon: const Icon(Icons.help_outline),
                label: Text(l10n.setupGuideLinkButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
