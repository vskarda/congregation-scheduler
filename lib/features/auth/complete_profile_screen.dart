import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/firebase/firebase_providers.dart';
import '../../core/l10n/l10n.dart';
import 'auth_service.dart';
import 'login_screen.dart';

/// Shown when an auth account exists without a publisher document
/// (registration was interrupted before the Firestore writes finished).
class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState
    extends ConsumerState<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authServiceProvider).completeProfile(
            firstName: _firstNameCtrl.text,
            lastName: _lastNameCtrl.text,
          );
    } catch (e) {
      if (mounted) setState(() => _error = authErrorMessage(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileCompleteTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              shrinkWrap: true,
              children: [
                Text(l10n.profileCompleteBody),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _firstNameCtrl,
                  decoration: InputDecoration(labelText: l10n.authFirstName),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.commonFieldRequired
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _lastNameCtrl,
                  decoration: InputDecoration(labelText: l10n.authLastName),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_error!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error)),
                  ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _busy ? null : _save,
                  child: Text(l10n.commonSave),
                ),
                TextButton(
                  onPressed: () => ref.read(firebaseAuthProvider).signOut(),
                  child: Text(l10n.authSignOut),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
