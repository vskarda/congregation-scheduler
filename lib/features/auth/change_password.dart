import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import 'auth_service.dart';
import 'login_screen.dart';

/// "Change password" button shown on the profile screen. Opens the
/// re-authentication + new-password dialog so any signed-in user can change
/// their own sign-in password without leaving the app.
class ChangePasswordButton extends ConsumerWidget {
  const ChangePasswordButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return TextButton.icon(
      onPressed: () => showChangePasswordDialog(context, ref),
      icon: const Icon(Icons.lock_reset),
      label: Text(l10n.changePasswordAction),
    );
  }
}

/// Opens the change-password dialog and, on success, confirms with a SnackBar
/// (the flow stays on the profile screen, so nothing else signals completion).
Future<void> showChangePasswordDialog(
    BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final changed = await showDialog<bool>(
    context: context,
    builder: (_) => const _ChangePasswordDialog(),
  );
  if (changed == true) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.changePasswordSuccess)));
  }
}

class _ChangePasswordDialog extends ConsumerStatefulWidget {
  const _ChangePasswordDialog();

  @override
  ConsumerState<_ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<_ChangePasswordDialog> {
  final _current = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _current.dispose();
    _newPassword.dispose();
    _confirm.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      !_busy &&
      _current.text.isNotEmpty &&
      _newPassword.text.length >= 6 &&
      _newPassword.text == _confirm.text;

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authServiceProvider).updatePassword(
            currentPassword: _current.text,
            newPassword: _newPassword.text,
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = authErrorMessage(context, e);
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final error = Theme.of(context).colorScheme.error;
    return AlertDialog(
      icon: const Icon(Icons.lock_reset, size: 32),
      title: Text(l10n.changePasswordAction),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _current,
            obscureText: true,
            autofocus: true,
            enabled: !_busy,
            autofillHints: const [AutofillHints.password],
            onChanged: (_) => setState(() {}),
            decoration:
                InputDecoration(labelText: l10n.changePasswordCurrentLabel),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _newPassword,
            obscureText: true,
            enabled: !_busy,
            autofillHints: const [AutofillHints.newPassword],
            onChanged: (_) => setState(() {}),
            decoration:
                InputDecoration(labelText: l10n.changePasswordNewLabel),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirm,
            obscureText: true,
            enabled: !_busy,
            autofillHints: const [AutofillHints.newPassword],
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _canSubmit ? _submit() : null,
            decoration:
                InputDecoration(labelText: l10n.changePasswordConfirmLabel),
          ),
          if (_newPassword.text.isNotEmpty && _newPassword.text.length < 6) ...[
            const SizedBox(height: 12),
            Text(l10n.authErrorWeakPassword, style: TextStyle(color: error)),
          ] else if (_confirm.text.isNotEmpty &&
              _newPassword.text != _confirm.text) ...[
            const SizedBox(height: 12),
            Text(l10n.authPasswordsDontMatch, style: TextStyle(color: error)),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: error)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _canSubmit ? _submit : null,
          child: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.changePasswordConfirm),
        ),
      ],
    );
  }
}
