import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import 'auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key, required this.isNewCongregation});

  final bool isNewCongregation;

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _congregationCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _congregationCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = context.l10n;
    setState(() {
      _busy = true;
      _error = null;
    });
    // Keep the router from redirecting to complete-profile during the brief
    // window where the founder is signed in without a publisher doc yet.
    if (widget.isNewCongregation) {
      ref.read(registrationInProgressProvider.notifier).set(true);
    }
    try {
      final auth = ref.read(authServiceProvider);
      if (widget.isNewCongregation) {
        await auth.registerNewCongregation(
          congregationName: _congregationCtrl.text,
          email: _emailCtrl.text,
          password: _passwordCtrl.text,
          firstName: _firstNameCtrl.text,
          lastName: _lastNameCtrl.text,
        );
      } else {
        await auth.registerJoin(
          email: _emailCtrl.text,
          password: _passwordCtrl.text,
          firstName: _firstNameCtrl.text,
          lastName: _lastNameCtrl.text,
        );
      }
      // Router redirects (home for the founder, awaiting for joiners).
    } on CongregationExistsException {
      if (mounted) setState(() => _error = l10n.setupCongregationExists);
    } on DatabaseNotReadyException {
      if (mounted) setState(() => _error = l10n.setupDatabaseNotReady);
    } catch (e) {
      if (mounted) setState(() => _error = authErrorMessage(context, e));
    } finally {
      if (widget.isNewCongregation) {
        ref.read(registrationInProgressProvider.notifier).set(false);
      }
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isNewCongregation ? l10n.setupModeNew : l10n.authRegister),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              shrinkWrap: true,
              children: [
                if (widget.isNewCongregation) ...[
                  TextFormField(
                    controller: _congregationCtrl,
                    decoration:
                        InputDecoration(labelText: l10n.authCongregationName),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.commonFieldRequired
                        : null,
                  ),
                  const SizedBox(height: 12),
                ],
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
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(labelText: l10n.authEmail),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? l10n.commonFieldRequired
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  autofillHints: const [AutofillHints.newPassword],
                  decoration: InputDecoration(labelText: l10n.authPassword),
                  validator: (v) => (v == null || v.length < 6)
                      ? l10n.authErrorWeakPassword
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: true,
                  decoration:
                      InputDecoration(labelText: l10n.authPasswordConfirm),
                  validator: (v) => v != _passwordCtrl.text
                      ? l10n.authPasswordsDontMatch
                      : null,
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
                  onPressed: _busy ? null : _register,
                  child: _busy
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l10n.authRegister),
                ),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(l10n.authHaveAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
