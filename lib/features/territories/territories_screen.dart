import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/data/territories_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/collation.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/assignment_editor.dart';
import 'territory_holder.dart';

class TerritoriesScreen extends ConsumerWidget {
  const TerritoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canEdit = ref.watch(effectiveRolesProvider).canEditTerritories();
    return Scaffold(
      floatingActionButton: canEdit
          ? FloatingActionButton(
              tooltip: context.l10n.terrAdd,
              onPressed: () => _showTerritoryDialog(context),
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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.terrAssignedOn(assignment.assignedDate.isEmpty
                      ? '—'
                      : dateFmt.format(parseDateKey(assignment.assignedDate)))),
                  if ((byId[assignment.territoryId]?.notes ?? '').isNotEmpty)
                    Text(byId[assignment.territoryId]!.notes,
                        style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
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
  return t.name;
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

typedef _TerritoryRow = ({
  Territory territory,
  TerritoryAssignment? current,
  /// Empty when the territory is free, or when nothing names who has it.
  String holderName,
});

enum _TerritorySort { territory, publisher, date }

class _AllTerritoriesSection extends ConsumerStatefulWidget {
  const _AllTerritoriesSection();

  @override
  ConsumerState<_AllTerritoriesSection> createState() =>
      _AllTerritoriesSectionState();
}

class _AllTerritoriesSectionState
    extends ConsumerState<_AllTerritoriesSection> {
  String _filter = '';
  _TerritorySort _sortField = _TerritorySort.territory;
  bool _sortAscending = true;
  final Set<String> _expandedIds = {};

  Future<void> _assign(
      BuildContext context, WidgetRef ref, Territory territory) async {
    final l10n = context.l10n;
    final publishers = ref.read(allPublishersProvider).value ?? const [];
    final selected = await showDialog<Publisher>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.terrAssignTo),
        children: [
          for (final p in publishers
              .where((p) => p.verified && !p.hasMovedBy(DateTime.now())))
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(p),
              child: Text(p.listName),
            ),
        ],
      ),
    );
    if (selected != null) {
      await ref.read(territoriesRepositoryProvider).saveAssignment(
            TerritoryAssignment(
              territoryId: territory.id,
              publisherId: selected.id,
              assignedDate: dateKey(DateTime.now()),
            ),
          );
    }
  }

  void _toggleSort(_TerritorySort field) {
    setState(() {
      if (_sortField == field) {
        _sortAscending = !_sortAscending;
      } else {
        _sortField = field;
        _sortAscending = true;
      }
    });
  }

  int _compareRows(_TerritoryRow a, _TerritoryRow b) {
    switch (_sortField) {
      case _TerritorySort.territory:
        final result = collate(a.territory.name, b.territory.name);
        return _sortAscending ? result : -result;
      case _TerritorySort.publisher:
        if (a.holderName.isEmpty && b.holderName.isEmpty) return 0;
        if (a.holderName.isEmpty) return 1;
        if (b.holderName.isEmpty) return -1;
        final result = collate(a.holderName, b.holderName);
        return _sortAscending ? result : -result;
      case _TerritorySort.date:
        final ad = a.current?.assignedDate ?? '';
        final bd = b.current?.assignedDate ?? '';
        if (ad.isEmpty && bd.isEmpty) return 0;
        if (ad.isEmpty) return 1;
        if (bd.isEmpty) return -1;
        final result = ad.compareTo(bd);
        return _sortAscending ? result : -result;
    }
  }

  Widget _sortChip(String label, _TerritorySort field) {
    final selected = _sortField == field;
    return ChoiceChip(
      label: Text(selected ? '$label ${_sortAscending ? '▲' : '▼'}' : label),
      selected: selected,
      onSelected: (_) => _toggleSort(field),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final territories = ref.watch(territoriesProvider).value ?? const [];
    final assignments =
        ref.watch(allTerritoryAssignmentsProvider).value ?? const [];
    final byId = ref.watch(publishersByIdProvider);
    final rosterLoaded = ref.watch(allPublishersProvider).hasValue;
    final locale = Localizations.localeOf(context).toString();
    final dateFmt = DateFormat.yMMMd(locale);

    final rows = <_TerritoryRow>[];
    for (final territory in territories) {
      final current = assignments.firstWhereOrNull(
          (a) => a.territoryId == territory.id && a.isOpen);
      rows.add((
        territory: territory,
        current: current,
        holderName:
            current == null ? '' : territoryHolderName(current, byId),
      ));
    }

    final query = _filter.trim().toLowerCase();
    final filtered = query.isEmpty
        ? rows
        : rows.where((r) {
            return r.territory.name.toLowerCase().contains(query) ||
                r.holderName.toLowerCase().contains(query);
          }).toList();
    filtered.sort(_compareRows);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(l10n.terrAll,
              style: Theme.of(context).textTheme.titleMedium),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              labelText: l10n.commonSearch,
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => _filter = v),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Wrap(
            spacing: 8,
            children: [
              _sortChip(l10n.terrSortByTerritory, _TerritorySort.territory),
              _sortChip(l10n.terrSortByPublisher, _TerritorySort.publisher),
              _sortChip(l10n.terrSortByDate, _TerritorySort.date),
            ],
          ),
        ),
        for (final row in filtered)
          Builder(builder: (context) {
            final territory = row.territory;
            final current = row.current;
            final expanded = _expandedIds.contains(territory.id);
            final history = assignments
                .where((a) => a.territoryId == territory.id)
                .toList();
            return Card(
              child: Column(
                children: [
                  ListTile(
                    onTap: () => setState(() {
                      if (expanded) {
                        _expandedIds.remove(territory.id);
                      } else {
                        _expandedIds.add(territory.id);
                      }
                    }),
                    title: Text(_territoryLabel(territory)),
                    subtitle: current == null
                        ? Text(l10n.terrFree)
                        : Text(l10n.terrHolder(
                            territoryHolderLabel(context, current, byId,
                                rosterLoaded: rosterLoaded),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PopupMenuButton<String>(
                          onSelected: (v) async {
                            final repo =
                                ref.read(territoriesRepositoryProvider);
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
                                  await _showTerritoryDialog(context,
                                      existing: territory);
                                }
                              case 'delete':
                                if (context.mounted) {
                                  await _confirmDeleteTerritory(
                                      context, ref, territory);
                                }
                            }
                          },
                          itemBuilder: (_) => [
                            if (current == null)
                              PopupMenuItem(
                                  value: 'assign',
                                  child: Text(l10n.terrAssignTo)),
                            if (current != null)
                              PopupMenuItem(
                                  value: 'return',
                                  child: Text(l10n.terrReturn)),
                            if (current != null)
                              PopupMenuItem(
                                  value: 'removeAssignment',
                                  child: Text(l10n.terrRemoveAssignment)),
                            PopupMenuItem(
                                value: 'edit', child: Text(l10n.terrEdit)),
                            PopupMenuItem(
                                value: 'delete',
                                child: Text(l10n.commonDelete)),
                          ],
                        ),
                        Icon(expanded
                            ? Icons.expand_less
                            : Icons.expand_more),
                      ],
                    ),
                  ),
                  if (expanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (territory.notes.isNotEmpty) ...[
                            Text('${l10n.terrNotes}: ${territory.notes}',
                                style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(height: 8),
                          ],
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () =>
                                  _showAssignmentDialog(context, territory),
                              icon: const Icon(Icons.history, size: 18),
                              label: Text(l10n.terrAsgAddPast),
                            ),
                          ),
                          if (history.isEmpty)
                            Text(l10n.terrHistoryEmpty,
                                style: Theme.of(context).textTheme.bodySmall)
                          else
                            Column(
                              children: [
                                const Divider(height: 1),
                                for (final a in history)
                                  ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: TerritoryHolderText(a),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${a.assignedDate.isEmpty ? '—' : dateFmt.format(parseDateKey(a.assignedDate))}'
                                          ' – '
                                          '${a.isOpen ? l10n.terrHistoryOngoing : (a.returnedDate.isEmpty ? '—' : dateFmt.format(parseDateKey(a.returnedDate)))}',
                                        ),
                                        if (a.returnNotes.isNotEmpty)
                                          Text(a.returnNotes,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall),
                                      ],
                                    ),
                                    trailing: PopupMenuButton<String>(
                                      onSelected: (v) async {
                                        switch (v) {
                                          case 'edit':
                                            await _showAssignmentDialog(
                                                context, territory,
                                                existing: a);
                                          case 'delete':
                                            await _confirmDeleteAssignment(
                                                context, ref, a);
                                        }
                                      },
                                      itemBuilder: (_) => [
                                        PopupMenuItem(
                                            value: 'edit',
                                            child: Text(l10n.commonEdit)),
                                        PopupMenuItem(
                                            value: 'delete',
                                            child: Text(l10n.commonDelete)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }),
      ],
    );
  }
}

Future<void> _confirmDeleteTerritory(
    BuildContext context, WidgetRef ref, Territory territory) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.commonConfirmDeleteTitle),
      content: Text(l10n.terrDeleteConfirm),
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
    await ref.read(territoriesRepositoryProvider).deleteTerritory(territory.id);
  }
}

Future<void> _showTerritoryDialog(BuildContext context, {Territory? existing}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _TerritoryDialog(existing: existing),
  );
}

/// Add/edit a territory. Owns its text controllers (disposed with the route, so
/// the dialog's exit animation never touches a disposed controller). Name is the
/// sole identifier, so Save blocks a name that duplicates another territory
/// (matched trimmed + case-insensitively) with an inline error.
class _TerritoryDialog extends ConsumerStatefulWidget {
  const _TerritoryDialog({this.existing});

  final Territory? existing;

  @override
  ConsumerState<_TerritoryDialog> createState() => _TerritoryDialogState();
}

class _TerritoryDialogState extends ConsumerState<_TerritoryDialog> {
  late final _nameCtrl =
      TextEditingController(text: widget.existing?.name ?? '');
  late final _mapCtrl =
      TextEditingController(text: widget.existing?.mapUrl ?? '');
  late final _notesCtrl =
      TextEditingController(text: widget.existing?.notes ?? '');
  String? _nameError;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mapCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  bool _nameTaken(String name) {
    final key = name.trim().toLowerCase();
    final territories = ref.read(territoriesProvider).value ?? const [];
    return territories.any((t) =>
        t.id != widget.existing?.id && t.name.trim().toLowerCase() == key);
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    if (_nameTaken(name)) {
      setState(() => _nameError = context.l10n.terrNameDuplicate);
      return;
    }
    await ref.read(territoriesRepositoryProvider).saveTerritory(
          (widget.existing ?? const Territory()).copyWith(
            name: name,
            mapUrl: _mapCtrl.text.trim(),
            notes: _notesCtrl.text.trim(),
          ),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(widget.existing == null ? l10n.terrAdd : l10n.terrEdit),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameCtrl,
                autofocus: widget.existing == null,
                onChanged: (_) {
                  if (_nameError != null) setState(() => _nameError = null);
                },
                decoration: InputDecoration(
                  labelText: l10n.terrName,
                  errorText: _nameError,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _mapCtrl,
                decoration: InputDecoration(labelText: l10n.terrMapUrl),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesCtrl,
                maxLines: 2,
                decoration: InputDecoration(labelText: l10n.terrNotes),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonCancel)),
        FilledButton(onPressed: _save, child: Text(l10n.commonSave)),
      ],
    );
  }
}

Future<void> _confirmDeleteAssignment(
    BuildContext context, WidgetRef ref, TerritoryAssignment assignment) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.commonConfirmDeleteTitle),
      content: Text(l10n.terrAsgDeleteConfirm),
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
    await ref.read(territoriesRepositoryProvider).deleteAssignment(
          assignment.id,
        );
  }
}

Future<void> _showAssignmentDialog(BuildContext context, Territory territory,
    {TerritoryAssignment? existing}) {
  return showDialog<void>(
    context: context,
    builder: (_) =>
        _AssignmentDialog(territory: territory, existing: existing),
  );
}

/// Add or edit one round of a territory going out: who held it, when it was
/// given out and when it came back.
///
/// The same dialog writes history and the assignment that is still open —
/// "current" is only an assignment with no return date — so a mistyped date or
/// the wrong holder can be corrected wherever it sits. An assignment left with
/// no return date while another one on the same territory is already open is
/// refused: the list picks the current holder with `firstWhereOrNull`, and the
/// second open row would quietly disappear.
class _AssignmentDialog extends ConsumerStatefulWidget {
  const _AssignmentDialog({required this.territory, this.existing});

  final Territory territory;
  final TerritoryAssignment? existing;

  @override
  ConsumerState<_AssignmentDialog> createState() => _AssignmentDialogState();
}

class _AssignmentDialogState extends ConsumerState<_AssignmentDialog> {
  late String _publisherId = widget.existing?.publisherId ?? '';
  late String _freeText = widget.existing?.freeText ?? '';
  late final _notesCtrl =
      TextEditingController(text: widget.existing?.returnNotes ?? '');
  late String _assignedDate =
      widget.existing?.assignedDate ?? dateKey(DateTime.now());
  late String _returnedDate = widget.existing?.returnedDate ?? '';
  String? _error;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  /// A date picker seeded inside its own range: a stored date can sit outside
  /// it (imported history, a record from before the app), and an initialDate
  /// out of bounds throws rather than opening.
  Future<String?> _pickDate(
      String current, DateTime first, DateTime last) async {
    final seed = tryParseDateKey(current) ?? DateTime.now();
    final initial = seed.isBefore(first)
        ? first
        : (seed.isAfter(last) ? last : seed);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );
    return picked == null ? null : dateKey(picked);
  }

  Future<void> _pickAssigned() async {
    final picked =
        await _pickDate(_assignedDate, DateTime(2000), DateTime.now());
    if (picked != null) {
      setState(() {
        _assignedDate = picked;
        _error = null;
      });
    }
  }

  Future<void> _pickReturned() async {
    final first = tryParseDateKey(_assignedDate) ?? DateTime(2000);
    final picked = await _pickDate(_returnedDate, first, DateTime.now());
    if (picked != null) {
      setState(() {
        _returnedDate = picked;
        _error = null;
      });
    }
  }

  /// The app's own assignment editor, so a territory is handed out the same
  /// way a meeting part is — publishers, or the "Text" field for whoever the
  /// roster cannot name.
  ///
  /// Territories carry no qualification and no rotation history, so both are
  /// left out and the dialog opens on all publishers. The date is this
  /// assignment's own: availability is judged as of the day the territory
  /// went out, which is what lets a past round name somebody who has moved
  /// away since.
  Future<void> _pickHolder() async {
    final result = await showAssignmentEditor(
      context,
      title: context.l10n.terrAsgPickTitle,
      initial: Assignment(
        publisherIds: [if (_publisherId.isNotEmpty) _publisherId],
        freeText: _freeText,
      ),
      multi: false,
      date: tryParseDateKey(_assignedDate),
    );
    if (result == null || !mounted) return;
    setState(() {
      _publisherId = result.publisherIds.firstOrNull ?? '';
      _freeText = result.freeText;
      _error = null;
    });
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final freeText = _freeText.trim();
    if (_publisherId.isEmpty && freeText.isEmpty) {
      setState(() => _error = l10n.terrAsgErrHolderRequired);
      return;
    }
    if (_assignedDate.isEmpty) {
      setState(() => _error = l10n.terrAsgErrDateRequired);
      return;
    }
    if (_returnedDate.isNotEmpty &&
        _returnedDate.compareTo(_assignedDate) < 0) {
      setState(() => _error = l10n.terrAsgErrReturnBeforeAssigned);
      return;
    }
    if (_returnedDate.isEmpty) {
      final assignments =
          ref.read(allTerritoryAssignmentsProvider).value ?? const [];
      final otherOpen = assignments.any((a) =>
          a.territoryId == widget.territory.id &&
          a.isOpen &&
          a.id != widget.existing?.id);
      if (otherOpen) {
        setState(() => _error = l10n.terrAsgErrAlreadyOpen);
        return;
      }
    }
    await ref.read(territoriesRepositoryProvider).saveAssignment(
          (widget.existing ?? const TerritoryAssignment()).copyWith(
            territoryId: widget.territory.id,
            publisherId: _publisherId,
            freeText: freeText,
            assignedDate: _assignedDate,
            returnedDate: _returnedDate,
            returnNotes: _notesCtrl.text.trim(),
          ),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final dateFmt = DateFormat.yMMMd(locale);
    final chosen = TerritoryAssignment(
      publisherId: _publisherId,
      freeText: _freeText,
    );
    return AlertDialog(
      title: Text(
          widget.existing == null ? l10n.terrAsgAddPast : l10n.terrAsgEdit),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.territory.name,
                  style: Theme.of(context).textTheme.titleSmall),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.terrAsgHolder),
                subtitle: _publisherId.isEmpty && _freeText.trim().isEmpty
                    ? Text(l10n.terrAsgHolderNone)
                    : TerritoryHolderText(chosen),
                trailing: const Icon(Icons.person_search_outlined),
                onTap: _pickHolder,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.terrAsgDateAssigned),
                subtitle: Text(_assignedDate.isEmpty
                    ? '—'
                    : dateFmt.format(parseDateKey(_assignedDate))),
                trailing: const Icon(Icons.event_outlined),
                onTap: _pickAssigned,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.terrAsgDateReturned),
                subtitle: Text(_returnedDate.isEmpty
                    ? l10n.terrAsgStillOut
                    : dateFmt.format(parseDateKey(_returnedDate))),
                trailing: _returnedDate.isEmpty
                    ? const Icon(Icons.event_outlined)
                    : IconButton(
                        tooltip: l10n.commonClear,
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() {
                          _returnedDate = '';
                          _error = null;
                        }),
                      ),
                onTap: _pickReturned,
              ),
              TextField(
                controller: _notesCtrl,
                maxLines: 2,
                decoration: InputDecoration(labelText: l10n.terrReturnNotes),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonCancel)),
        FilledButton(onPressed: _save, child: Text(l10n.commonSave)),
      ],
    );
  }
}
