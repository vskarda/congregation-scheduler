import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/congregation_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/firebase/local_cache.dart';
import '../../core/l10n/l10n.dart';
import 'delete_account.dart';

/// Shown to anyone the congregation data is closed to: a newly registered
/// account not verified yet, and a publisher whose recorded moving date has
/// arrived. The two read very differently to the person, so the copy and the
/// icon follow which one it is.
class AwaitingScreen extends ConsumerWidget {
  const AwaitingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final meta = ref.watch(congregationMetaProvider).value;
    final hasMoved =
        ref.watch(myPublisherProvider).value?.hasMovedBy(DateTime.now()) ??
            false;
    return Scaffold(
      appBar: AppBar(
          title: Text(hasMoved ? l10n.awaitingMovedTitle : l10n.awaitingTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    hasMoved
                        ? Icons.local_shipping_outlined
                        : Icons.hourglass_top,
                    size: 64),
                const SizedBox(height: 16),
                if (meta != null && meta.name.isNotEmpty)
                  Text(meta.name,
                      style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Text(hasMoved ? l10n.awaitingMovedBody : l10n.awaitingBody,
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                TextButton.icon(
                  onPressed: () => signOutAndClearLocalCache(ref),
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
