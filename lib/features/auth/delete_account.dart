import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/l10n/l10n.dart';
import 'auth_service.dart';
import 'login_screen.dart';

/// Destructive "Delete my account" button that opens the confirm + re-auth
/// dialog. Shown on the profile, awaiting-verification and complete-profile
/// screens so any signed-in user can delete their account (Apple Guideline
/// 5.1.1(v)).
class DeleteAccountButton extends ConsumerWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final error = Theme.of(context).colorScheme.error;
    return TextButton.icon(
      onPressed: () => showDeleteAccountDialog(context, ref),
      icon: Icon(Icons.delete_forever_outlined, color: error),
      label: Text(l10n.deleteAccountAction, style: TextStyle(color: error)),
    );
  }
}

/// Opens the account-deletion flow. Blocks a sole full-admin first (deleting
/// the only administrator would permanently lock the congregation out, since
/// congregation/meta can never be re-created or deleted), then shows the
/// re-authentication + confirmation dialog.
Future<void> showDeleteAccountDialog(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final me = ref.read(myPublisherProvider).value;
  if (me != null && me.roles.fullAdmin) {
    final all = ref.read(allPublishersProvider).value ?? const [];
    final anotherAdmin =
        all.any((p) => p.roles.fullAdmin && p.id != me.id);
    if (!anotherAdmin) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          icon: Icon(Icons.warning_amber_rounded,
              color: Theme.of(context).colorScheme.error, size: 32),
          title: Text(l10n.deleteAccountSoleAdminTitle),
          content: Text(l10n.deleteAccountSoleAdminBody),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.commonOk),
            ),
          ],
        ),
      );
      return;
    }
  }

  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (_) => const _DeleteAccountDialog(),
  );
}

class _DeleteAccountDialog extends ConsumerStatefulWidget {
  const _DeleteAccountDialog();

  @override
  ConsumerState<_DeleteAccountDialog> createState() =>
      _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends ConsumerState<_DeleteAccountDialog> {
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(authServiceProvider)
          .deleteAccount(password: _password.text);
      // The auth-state change redirects the underlying route to /login; just
      // close the dialog.
      if (mounted) Navigator.of(context).pop();
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
    final email = ref.read(firebaseAuthProvider).currentUser?.email ?? '';
    final needsPassword = email.isNotEmpty;
    final canDelete = !_busy && (!needsPassword || _password.text.isNotEmpty);
    final error = Theme.of(context).colorScheme.error;
    return AlertDialog(
      icon: Icon(Icons.delete_forever_outlined, color: error, size: 32),
      title: Text(l10n.deleteAccountAction),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.deleteAccountWarning),
          if (needsPassword) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _password,
              obscureText: true,
              autofocus: true,
              enabled: !_busy,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => canDelete ? _delete() : null,
              decoration:
                  InputDecoration(labelText: l10n.deleteAccountPasswordLabel),
            ),
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
          style: FilledButton.styleFrom(
            backgroundColor: error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: canDelete ? _delete : null,
          child: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.deleteAccountConfirm),
        ),
      ],
    );
  }
}
