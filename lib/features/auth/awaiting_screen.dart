import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/congregation_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/l10n/l10n.dart';
import 'delete_account.dart';

class AwaitingScreen extends ConsumerWidget {
  const AwaitingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final meta = ref.watch(congregationMetaProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.awaitingTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.hourglass_top, size: 64),
                const SizedBox(height: 16),
                if (meta != null && meta.name.isNotEmpty)
                  Text(meta.name,
                      style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Text(l10n.awaitingBody, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                TextButton.icon(
                  onPressed: () => ref.read(firebaseAuthProvider).signOut(),
                  icon: const Icon(Icons.logout),
                  label: Text(l10n.authSignOut),
                ),
                const DeleteAccountButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
