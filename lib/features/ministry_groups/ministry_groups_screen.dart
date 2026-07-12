import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/ministry_groups_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';

class MinistryGroupsScreen extends ConsumerWidget {
  const MinistryGroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final canEdit = ref.watch(effectiveRolesProvider).canEditPublishers();
    final groups = ref.watch(ministryGroupsProvider).value ?? const [];
    final publishers = ref.watch(allPublishersProvider).value ?? const [];
    final membersByGroup = groupBy(
        publishers.where((p) => p.groupId != null),
        (Publisher p) => p.groupId!);

    return Scaffold(
      floatingActionButton: canEdit
          ? FloatingActionButton(
              tooltip: l10n.mgAdd,
              onPressed: () => _showGroupDialog(context, ref),
              child: const Icon(Icons.add),
            )
          : null,
      body: groups.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(l10n.mgEmpty, textAlign: TextAlign.center),
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 88),
              children: [
                for (final group in groups)
                  _GroupTile(
                    group: group,
                    members: membersByGroup[group.id] ?? const [],
                    canEdit: canEdit,
                  ),
              ],
            ),
    );
  }
}

class _GroupTile extends ConsumerWidget {
  const _GroupTile(
      {required this.group, required this.members, required this.canEdit});

  final MinistryGroup group;
  final List<Publisher> members;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final overseer = ref.watch(publishersByIdProvider)[group.overseerId];

    int rank(Publisher p) => p.id == group.overseerId
        ? 0
        : p.id == group.assistantId
            ? 1
            : 2;
    final sorted = members.sorted((a, b) {
      final byRank = rank(a).compareTo(rank(b));
      if (byRank != 0) return byRank;
      return a.listName.toLowerCase().compareTo(b.listName.toLowerCase());
    });

    String? badge(Publisher p) => p.id == group.overseerId
        ? l10n.mgOverseer
        : p.id == group.assistantId
            ? l10n.mgAssistant
            : null;

    return ExpansionTile(
      leading: const Icon(Icons.group_work_outlined),
      title: Text(group.name),
      subtitle: Text([
        l10n.mgMemberCount(members.length),
        if (overseer != null) overseer.fullName,
      ].join(' · ')),
      children: [
        if (sorted.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.mgNoMembers),
            ),
          ),
        for (final p in sorted)
          ListTile(
            dense: true,
            leading: const Icon(Icons.person_outline),
            title: Text(p.listName),
            subtitle: badge(p) == null ? null : Text(badge(p)!),
            trailing: canEdit
                ? PopupMenuButton<String>(
                    onSelected: (v) async {
                      final repo = ref.read(ministryGroupsRepositoryProvider);
                      switch (v) {
                        case 'overseer':
                          await repo.saveGroup(group.copyWith(
                            overseerId: p.id,
                            assistantId: group.assistantId == p.id
                                ? ''
                                : group.assistantId,
                          ));
                        case 'assistant':
                          await repo.saveGroup(group.copyWith(
                            assistantId: p.id,
                            overseerId: group.overseerId == p.id
                                ? ''
                                : group.overseerId,
                          ));
                        case 'clearRole':
                          await repo.saveGroup(group.copyWith(
                            overseerId: group.overseerId == p.id
                                ? ''
                                : group.overseerId,
                            assistantId: group.assistantId == p.id
                                ? ''
                                : group.assistantId,
                          ));
                        case 'remove':
                          await repo.setPublisherGroup(p, null, group);
                      }
                    },
                    itemBuilder: (_) => [
                      if (p.id != group.overseerId)
                        PopupMenuItem(
                            value: 'overseer',
                            child: Text(l10n.mgMakeOverseer)),
                      if (p.id != group.assistantId)
                        PopupMenuItem(
                            value: 'assistant',
                            child: Text(l10n.mgMakeAssistant)),
                      if (p.id == group.overseerId ||
                          p.id == group.assistantId)
                        PopupMenuItem(
                            value: 'clearRole', child: Text(l10n.mgClearRole)),
                      PopupMenuItem(
                          value: 'remove', child: Text(l10n.mgRemoveMember)),
                    ],
                  )
                : null,
          ),
        if (canEdit)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Wrap(
              spacing: 8,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.person_add_outlined),
                  label: Text(l10n.mgAddMember),
                  onPressed: () => _addMember(context, ref, group),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l10n.mgEdit),
                  onPressed: () =>
                      _showGroupDialog(context, ref, existing: group),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l10n.commonDelete),
                  onPressed: () =>
                      _confirmDeleteGroup(context, ref, group, sorted),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

Future<void> _showGroupDialog(BuildContext context, WidgetRef ref,
    {MinistryGroup? existing}) async {
  final l10n = context.l10n;
  final nameCtrl = TextEditingController(text: existing?.name ?? '');

  final saved = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(existing == null ? l10n.mgAdd : l10n.mgEdit),
      content: TextField(
        controller: nameCtrl,
        autofocus: true,
        decoration: InputDecoration(labelText: l10n.mgName),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel)),
        FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonSave)),
      ],
    ),
  );
  if (saved == true && nameCtrl.text.trim().isNotEmpty) {
    await ref.read(ministryGroupsRepositoryProvider).saveGroup(
        (existing ?? const MinistryGroup())
            .copyWith(name: nameCtrl.text.trim()));
  }
  nameCtrl.dispose();
}

Future<void> _addMember(
    BuildContext context, WidgetRef ref, MinistryGroup group) async {
  final l10n = context.l10n;
  final publishers = ref.read(allPublishersProvider).value ?? const [];
  final candidates = publishers
      .where((p) => p.verified && !p.moved && p.groupId == null)
      .toList();

  final selected = await showDialog<Publisher>(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(l10n.mgAddMember),
      children: [
        if (candidates.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(l10n.mgNoUnassigned),
          ),
        for (final p in candidates)
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(p),
            child: Text(p.listName),
          ),
      ],
    ),
  );
  if (selected != null) {
    await ref
        .read(ministryGroupsRepositoryProvider)
        .setPublisherGroup(selected, group.id, null);
  }
}

Future<void> _confirmDeleteGroup(BuildContext context, WidgetRef ref,
    MinistryGroup group, List<Publisher> members) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.commonConfirmDeleteTitle),
      content: Text(l10n.mgDeleteConfirm),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel)),
        FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonDelete)),
      ],
    ),
  );
  if (confirmed == true) {
    await ref
        .read(ministryGroupsRepositoryProvider)
        .deleteGroup(group.id, members.map((m) => m.id).toList());
  }
}
