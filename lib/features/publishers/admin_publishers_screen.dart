import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/congregation_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import 'invite_dialog.dart';

class AdminPublishersScreen extends ConsumerStatefulWidget {
  const AdminPublishersScreen({super.key});

  @override
  ConsumerState<AdminPublishersScreen> createState() =>
      _AdminPublishersScreenState();
}

class _AdminPublishersScreenState
    extends ConsumerState<AdminPublishersScreen> {
  String _filter = '';
  bool _showMoved = false;

  Future<void> _addRecord() async {
    final l10n = context.l10n;
    final firstName = TextEditingController();
    final lastName = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.pubAdminAddRecord),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.pubAdminAddRecordHint),
            const SizedBox(height: 12),
            TextField(
              controller: firstName,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.authFirstName),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lastName,
              decoration: InputDecoration(labelText: l10n.authLastName),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonAdd),
          ),
        ],
      ),
    );
    if (saved == true && firstName.text.trim().isNotEmpty) {
      final repo = ref.read(publishersRepositoryProvider);
      final id = await repo.create(Publisher(
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        verified: true,
        hasAccount: false,
      ));
      await repo.setPrivate(id, const PublisherPrivate());
    }
    firstName.dispose();
    lastName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final publishers = ref.watch(allPublishersProvider);
    final metaName =
        ref.watch(congregationMetaProvider).value?.name ?? '';

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showInviteDialog(context, metaName),
        icon: const Icon(Icons.qr_code),
        label: Text(l10n.pubAdminInvite),
      ),
      body: publishers.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l10n.commonErrorDetail(e.toString()))),
        data: (all) {
          final query = _filter.toLowerCase();
          final hasMoved = all.any((p) => p.moved);
          final matched = all.where((p) {
            if (p.moved && !_showMoved) return false;
            if (query.isEmpty) return true;
            return p.fullName.toLowerCase().contains(query);
          });
          // Active first, moved (dimmed) last; alphabetical order is preserved
          // within each group by the repository's sort.
          final filtered = [
            ...matched.where((p) => !p.moved),
            ...matched.where((p) => p.moved),
          ];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: l10n.commonSearch,
                          prefixIcon: const Icon(Icons.search),
                        ),
                        onChanged: (v) => setState(() => _filter = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: l10n.pubAdminAddRecord,
                      onPressed: _addRecord,
                      icon: const Icon(Icons.person_add_alt),
                    ),
                  ],
                ),
              ),
              if (hasMoved)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                    child: FilterChip(
                      label: Text(l10n.pubAdminShowMoved),
                      selected: _showMoved,
                      onSelected: (v) => setState(() => _showMoved = v),
                    ),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 88),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final p = filtered[i];
                    // Moved is checked first: a moved publisher is also
                    // unverified, but should read as "moved", not "awaiting".
                    final tile = ListTile(
                      leading: CircleAvatar(
                        child: Text(p.firstName.isEmpty
                            ? '?'
                            : p.firstName[0].toUpperCase()),
                      ),
                      title: Text(p.listName),
                      subtitle: p.moved
                          ? Text(l10n.pubAdminMovedBadge)
                          : !p.verified
                              ? Text(l10n.pubAdminUnverifiedBadge,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .error))
                              : !p.hasAccount
                                  ? Text(l10n.pubAdminNoAccountBadge)
                                  : null,
                      trailing: p.moved
                          ? const Icon(Icons.local_shipping_outlined)
                          : !p.verified
                              ? const Icon(Icons.hourglass_top)
                              : p.roles.any
                                  ? const Icon(Icons.shield_outlined)
                                  : null,
                      onTap: () =>
                          context.go('/admin/publishers/${p.id}'),
                    );
                    return p.moved
                        ? Opacity(opacity: 0.5, child: tile)
                        : tile;
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
