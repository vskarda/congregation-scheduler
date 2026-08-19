import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/firebase/firebase_providers.dart';
import '../../core/l10n/l10n.dart';
import 'auth_service.dart';
import 'login_screen.dart';

/// "Change sign-in e-mail" button shown on the profile screen. The address a
/// publisher signs in with lives in Firebase Auth, so only they can change it
/// — an admin cannot do it for them (no Cloud Functions on the Spark plan).
class ChangeEmailButton extends ConsumerWidget {
  const ChangeEmailButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return TextButton.icon(
      onPressed: () => showChangeEmailDialog(context, ref),
      icon: const Icon(Icons.alternate_email),
      label: Text(l10n.changeEmailAction),
    );
  }
}

/// Opens the change-e-mail dialog and, on success, names the address the
/// confirmation link went to (the flow stays on the profile screen, and
/// nothing visible changes until the link is opened).
Future<void> showChangeEmailDialog(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final sentTo = await showDialog<String>(
    context: context,
    builder: (_) => const _ChangeEmailDialog(),
  );
  if (sentTo != null) {
    messenger.showSnackBar(
        SnackBar(content: Text(l10n.changeEmailSent(sentTo))));
  }
}

class _ChangeEmailDialog extends ConsumerStatefulWidget {
  const _ChangeEmailDialog();

  @override
  ConsumerState<_ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends ConsumerState<_ChangeEmailDialog> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String? get _currentEmail =>
      ref.read(firebaseAuthProvider).currentUser?.email;

  bool get _sameAsCurrent =>
      _email.text.trim().toLowerCase() ==
      (_currentEmail ?? '').trim().toLowerCase();

  bool get _canSubmit =>
      !_busy &&
      _password.text.isNotEmpty &&
      _email.text.trim().contains('@') &&
      !_sameAsCurrent;

  Future<void> _submit() async {
    final target = _email.text.trim();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authServiceProvider).startEmailChange(
            password: _password.text,
            newEmail: target,
          );
      if (mounted) Navigator.of(context).pop(target);
    } catch (e) {
      if (mounted) {
        setState(() {
          // 'invalid-email' here means the *new* address is malformed;
          // authErrorMessage would render it as wrong sign-in credentials.
          _error = e is FirebaseAuthException && e.code == 'invalid-email'
              ? context.l10n.changeEmailInvalid
              : authErrorMessage(context, e);
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      icon: const Icon(Icons.alternate_email, size: 32),
      title: Text(l10n.changeEmailAction),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.changeEmailBody),
            const SizedBox(height: 16),
            TextField(
              controller: _email,
              autofocus: true,
              enabled: !_busy,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: l10n.changeEmailNewLabel,
                helperText: _currentEmail,
                helperMaxLines: 2,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              enabled: !_busy,
              autofillHints: const [AutofillHints.password],
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _canSubmit ? _submit() : null,
              decoration:
                  InputDecoration(labelText: l10n.changeEmailPasswordLabel),
            ),
            if (_email.text.trim().isNotEmpty && _sameAsCurrent) ...[
              const SizedBox(height: 12),
              Text(l10n.changeEmailSameAsCurrent,
                  style: TextStyle(color: scheme.error)),
            ],
            const SizedBox(height: 16),
            // The consequence people trip over: the change lands in another
            // mailbox and ends this session. It sits directly above the
            // confirm button — the last thing read before committing —
            // rather than at the top, where it would push the fields off a
            // phone screen, or in a snack bar, which comes too late.
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: scheme.onErrorContainer),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.changeEmailReloginWarning,
                      style: TextStyle(color: scheme.onErrorContainer),
                    ),
                  ),
                ],
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: scheme.error)),
            ],
          ],
        ),
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
              : Text(l10n.changeEmailConfirm),
        ),
      ],
    );
  }
}
