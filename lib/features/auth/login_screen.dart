import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/l10n/language_menu_button.dart';
import 'auth_service.dart';

String authErrorMessage(BuildContext context, Object error) {
  final l10n = context.l10n;
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
      case 'invalid-email':
        return l10n.authErrorInvalidCredentials;
      case 'email-already-in-use':
        return l10n.authErrorEmailInUse;
      case 'weak-password':
        return l10n.authErrorWeakPassword;
    }
    return l10n.authErrorGeneric(error.message ?? error.code);
  }
  return l10n.authErrorGeneric(error.toString());
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(authServiceProvider)
          .signIn(_emailCtrl.text, _passwordCtrl.text);
      // Router redirects on auth state change.
    } catch (e) {
      if (mounted) setState(() => _error = authErrorMessage(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resetPassword() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    if (_emailCtrl.text.trim().isEmpty) {
      setState(() => _error = l10n.authEnterEmailForReset);
      _emailFocus.requestFocus();
      return;
    }
    try {
      await ref.read(authServiceProvider).sendPasswordReset(_emailCtrl.text);
      messenger.showSnackBar(SnackBar(content: Text(l10n.authResetSent)));
    } catch (e) {
      if (mounted) setState(() => _error = authErrorMessage(context, e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.authSignIn),
        actions: const [LanguageMenuButton()],
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
                TextFormField(
                  controller: _emailCtrl,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(labelText: l10n.authEmail),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.commonFieldRequired
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(labelText: l10n.authPassword),
                  onFieldSubmitted: (_) => _signIn(),
                  validator: (v) => (v == null || v.isEmpty)
                      ? l10n.commonFieldRequired
                      : null,
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _busy ? null : _signIn,
                  child: Text(l10n.authSignIn),
                ),
                TextButton(
                  onPressed: _busy ? null : _resetPassword,
                  child: Text(l10n.authForgotPassword),
                ),
                const Divider(),
                TextButton(
                  onPressed: () => context.go('/register?mode=join'),
                  child: Text(l10n.authNoAccountYet),
                ),
                TextButton(
                  onPressed: () => context.go('/setup'),
                  child: Text(l10n.setupReconfigure),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
