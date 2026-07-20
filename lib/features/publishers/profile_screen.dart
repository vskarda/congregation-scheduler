import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../auth/change_password.dart';
import '../auth/delete_account.dart';
import 'publisher_form.dart';
import 'publisher_record_view.dart';
import 'publishers_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final me = ref.watch(myPublisherProvider).value;
    if (me == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final private = ref.watch(publisherPrivateProvider(me.id));

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: private.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) =>
              Center(child: Text(l10n.commonErrorDetail(e.toString()))),
          data: (priv) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              PublisherForm(
                // Key ensures the form state resets when the doc changes id.
                key: ValueKey('${me.id}-form'),
                publisher: me,
                private: priv,
              ),
              if (me.status != PublisherStatus.none) ...[
                const SizedBox(height: 24),
                PublisherRecordView(publisherId: me.id),
              ],
              const SizedBox(height: 24),
              const Divider(),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ChangePasswordButton(),
                    DeleteAccountButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
