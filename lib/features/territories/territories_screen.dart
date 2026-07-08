import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/data/territories_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';

class TerritoriesScreen extends ConsumerWidget {
  const TerritoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canEdit = ref.watch(myRolesProvider).canEditTerritories();
    return Scaffold(
      floatingActionButton: canEdit
          ? FloatingActionButton(
              tooltip: context.l10n.terrAdd,
              onPressed: () => _showTerritoryDialog(context, ref),
              child: const Icon(Icons.add),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 88),
        children: [
          const _MyTerritoriesSection(),
          if (canEdit) ...[
            const _StatsSection(),
            const _AllTerritoriesSection(),
          ],
        ],
      ),
    );
  }
}

Future<void> _openMap(String url) async {
  if (url.isEmpty) return;
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

class _MyTerritoriesSection extends ConsumerWidget {
  const _MyTerritoriesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final mine = ref.watch(myTerritoryAssignmentsProvider).value ?? const [];
    final territories = ref.watch(territoriesProvider).value ?? const [];
    final byId = {for (final t in territories) t.id: t};
    final open = mine.where((a) => a.isOpen).toList();
    final locale = Localizations.localeOf(context).toString();
    final dateFmt = DateFormat.yMMMd(locale);

    Future<void> returnTerritory(TerritoryAssignment assignment) async {
      final notesCtrl = TextEditingController();
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.terrReturnTitle),
          content: TextField(
            controller: notesCtrl,
            maxLines: 3,
            decoration: InputDecoration(labelText: l10n.terrReturnNotes),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.commonCancel)),
            FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.terrReturn)),
          ],
        ),
      );
      if (confirmed == true) {
        await ref.read(territoriesRepositoryProvider).returnTerritory(
            assignment.id, dateKey(DateTime.now()), notesCtrl.text.trim());
      }
      notesCtrl.dispose();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(l10n.terrMine,
              style: Theme.of(context).textTheme.titleMedium),
        ),
        if (open.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(l10n.terrNoMine),
          ),
        for (final assignment in open)
          Card(
            child: ListTile(
              title: Text(_territoryLabel(byId[assignment.territoryId])),
              subtitle: Text(l10n.terrAssignedOn(assignment
                      .assignedDate.isEmpty
                  ? '—'
                  : dateFmt.format(parseDateKey(assignment.assignedDate)))),
              leading: (byId[assignment.territoryId]?.mapUrl ?? '')
                      .isNotEmpty
                  ? IconButton(
                      tooltip: l10n.terrMap,
                      icon: const Icon(Icons.map_outlined),
                      onPressed: () =>
                          _openMap(byId[assignment.territoryId]!.mapUrl),
                    )
                  : const Icon(Icons.map_outlined, color: Colors.grey),
              trailing: TextButton(
                onPressed: () => returnTerritory(assignment),
                child: Text(l10n.terrReturn),
              ),
            ),
          ),
      ],
    );
  }
}

String _territoryLabel(Territory? t) {
  if (t == null) return '…';
  return [if (t.number.isNotEmpty) t.number, t.name].join(' — ');
}

class _StatsSection extends ConsumerStatefulWidget {
  const _StatsSection();

  @override
  ConsumerState<_StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends ConsumerState<_StatsSection> {
  late String _from = dateKey(addMonths(DateTime.now(), -12));
  late String _to = dateKey(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final territories = ref.watch(territoriesProvider).value ?? const [];
    final assignments =
        ref.watch(allTerritoryAssignmentsProvider).value ?? const [];

    final assigned = assignments.where((a) => a.isOpen).length;
    final finished = assignments
        .where((a) =>
            !a.isOpen &&
            a.returnedDate.compareTo(_from) >= 0 &&
            a.returnedDate.compareTo(_to) <= 0)
        .length;

    Future<void> pick(bool from) async {
      final picked = await showDatePicker(
        context: context,
        initialDate: parseDateKey(from ? _from : _to),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() {
          if (from) {
            _from = dateKey(picked);
          } else {
            _to = dateKey(picked);
          }
        });
      }
    }

    Widget stat(String label, String value) => Expanded(
          child: Column(
            children: [
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              Text(label,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center),
            ],
          ),
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.terrStats,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                stat(l10n.terrStatsTotal, territories.length.toString()),
                stat(l10n.terrStatsAssigned, assigned.toString()),
                stat(l10n.terrStatsFinished, finished.toString()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () => pick(true), child: Text(_from)),
                const Text('–'),
                TextButton(onPressed: () => pick(false), child: Text(_to)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AllTerritoriesSection extends ConsumerWidget {
  const _AllTerritoriesSection();

  Future<void> _assign(
      BuildContext context, WidgetRef ref, Territory territory) async {
    final l10n = context.l10n;
    final publishers = ref.read(allPublishersProvider).value ?? const [];
    final selected = await showDialog<Publisher>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.terrAssignTo),
        children: [
          for (final p in publishers.where((p) => p.verified))
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(p),
              child: Text(p.listName),
            ),
        ],
      ),
    );
    if (selected != null) {
      await ref.read(territoriesRepositoryProvider).assign(
            TerritoryAssignment(
              territoryId: territory.id,
              publisherId: selected.id,
              assignedDate: dateKey(DateTime.now()),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final territories = ref.watch(territoriesProvider).value ?? const [];
    final assignments =
        ref.watch(allTerritoryAssignmentsProvider).value ?? const [];
    final byId = ref.watch(publishersByIdProvider);
    final locale = Localizations.localeOf(context).toString();
    final dateFmt = DateFormat.yMMMd(locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(l10n.terrAll,
              style: Theme.of(context).textTheme.titleMedium),
        ),
        for (final territory in territories)
          Builder(builder: (context) {
            final current = assignments
                .firstWhereOrNull(
                    (a) => a.territoryId == territory.id && a.isOpen);
            final holder =
                current == null ? null : byId[current.publisherId];
            return Card(
              child: ListTile(
                title: Text(_territoryLabel(territory)),
                subtitle: current == null
                    ? Text(l10n.terrFree)
                    : Text(l10n.terrHolder(
                        holder?.fullName ?? '…',
                        current.assignedDate.isEmpty
                            ? '—'
                            : dateFmt.format(
                                parseDateKey(current.assignedDate)))),
                leading: territory.mapUrl.isNotEmpty
                    ? IconButton(
                        tooltip: l10n.terrMap,
                        icon: const Icon(Icons.map_outlined),
                        onPressed: () => _openMap(territory.mapUrl),
                      )
                    : const Icon(Icons.map_outlined, color: Colors.grey),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    final repo = ref.read(territoriesRepositoryProvider);
                    switch (v) {
                      case 'assign':
                        await _assign(context, ref, territory);
                      case 'return':
                        if (current != null) {
                          await repo.returnTerritory(
                              current.id, dateKey(DateTime.now()), '');
                        }
                      case 'removeAssignment':
                        if (current != null) {
                          await repo.deleteAssignment(current.id);
                        }
                      case 'edit':
                        if (context.mounted) {
                          await _showTerritoryDialog(context, ref,
                              existing: territory);
                        }
                      case 'delete':
                        await repo.deleteTerritory(territory.id);
                    }
                  },
                  itemBuilder: (_) => [
                    if (current == null)
                      PopupMenuItem(
                          value: 'assign',
                          child: Text(l10n.terrAssignTo)),
                    if (current != null)
                      PopupMenuItem(
                          value: 'return', child: Text(l10n.terrReturn)),
                    if (current != null)
                      PopupMenuItem(
                          value: 'removeAssignment',
                          child: Text(l10n.terrRemoveAssignment)),
                    PopupMenuItem(
                        value: 'edit', child: Text(l10n.terrEdit)),
                    PopupMenuItem(
                        value: 'delete', child: Text(l10n.commonDelete)),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}

Future<void> _showTerritoryDialog(BuildContext context, WidgetRef ref,
    {Territory? existing}) async {
  final l10n = context.l10n;
  final nameCtrl = TextEditingController(text: existing?.name ?? '');
  final numberCtrl = TextEditingController(text: existing?.number ?? '');
  final mapCtrl = TextEditingController(text: existing?.mapUrl ?? '');
  final notesCtrl = TextEditingController(text: existing?.notes ?? '');

  final saved = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(existing == null ? l10n.terrAdd : l10n.terrEdit),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                autofocus: existing == null,
                decoration: InputDecoration(labelText: l10n.terrName),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: numberCtrl,
                decoration: InputDecoration(labelText: l10n.terrNumber),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: mapCtrl,
                decoration: InputDecoration(labelText: l10n.terrMapUrl),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesCtrl,
                maxLines: 2,
                decoration: InputDecoration(labelText: l10n.terrNotes),
              ),
            ],
          ),
        ),
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
    await ref.read(territoriesRepositoryProvider).saveTerritory(
          (existing ?? const Territory()).copyWith(
            name: nameCtrl.text.trim(),
            number: numberCtrl.text.trim(),
            mapUrl: mapCtrl.text.trim(),
            notes: notesCtrl.text.trim(),
          ),
        );
  }
  nameCtrl.dispose();
  numberCtrl.dispose();
  mapCtrl.dispose();
  notesCtrl.dispose();
}
