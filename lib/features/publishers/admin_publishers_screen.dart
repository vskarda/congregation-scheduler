import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/congregation_repository.dart';
import '../../core/data/ministry_groups_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/l10n/enum_labels.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import 'gender_style.dart';
import 'invite_dialog.dart';
import 'publisher_badges.dart';
import 's21/s21_import_screen.dart';

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

  // Overview filters (null / false = "any").
  bool _pioneerOnly = false;
  Gender? _genderFilter;
  Appointment? _appointmentFilter;
  bool _rightsOnly = false;
  // '' is the "no group" sentinel; null means "any group".
  String? _groupFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _backfillAppointmentsIfNeeded();
    });
  }

  /// One-time migration: copy each publisher's elder/MS appointment from the
  /// private profile onto the public doc so the roster can filter/badge by it.
  /// Full-admin only, guarded by a congregation/meta flag so it runs once ever.
  /// Best-effort — failures are swallowed and simply retried on a later load.
  Future<void> _backfillAppointmentsIfNeeded() async {
    if (!ref.read(myRolesProvider).fullAdmin) return;
    final meta = ref.read(congregationMetaProvider).value;
    if (meta == null || meta.appointmentBackfilled) return;
    try {
      final repo = ref.read(publishersRepositoryProvider);
      final all = await ref.read(allPublishersProvider.future);
      for (final p in all) {
        final priv = await repo.getPrivate(p.id);
        final appointment = priv?.appointment ?? Appointment.none;
        if (appointment != p.appointment) {
          await repo.update(p.copyWith(appointment: appointment));
        }
      }
      await ref
          .read(congregationRepositoryProvider)
          .updateMeta(meta.copyWith(appointmentBackfilled: true));
    } catch (_) {
      // Ignore; the next full-admin load will retry.
    }
  }

  bool get _anyFilterActive =>
      _pioneerOnly ||
      _genderFilter != null ||
      _appointmentFilter != null ||
      _rightsOnly ||
      _groupFilter != null ||
      _showMoved;

  void _clearFilters() => setState(() {
        _pioneerOnly = false;
        _genderFilter = null;
        _appointmentFilter = null;
        _rightsOnly = false;
        _groupFilter = null;
        _showMoved = false;
      });

  /// Group filter presented as a chip that opens a group picker menu. '' picks
  /// "no group"; null clears the group filter.
  Widget _groupFilterChip(AppLocalizations l10n, List<MinistryGroup> groups) {
    final active = _groupFilter != null;
    String label = l10n.mgGroup;
    if (_groupFilter != null) {
      if (_groupFilter!.isEmpty) {
        label = l10n.mgNoGroup;
      } else {
        for (final g in groups) {
          if (g.id == _groupFilter) {
            label = g.name;
            break;
          }
        }
      }
    }
    return PopupMenuButton<String?>(
      tooltip: l10n.mgGroup,
      initialValue: _groupFilter,
      onSelected: (v) => setState(() => _groupFilter = v),
      itemBuilder: (_) => [
        PopupMenuItem<String?>(
            value: null, child: Text(l10n.pubFilterAnyGroup)),
        PopupMenuItem<String?>(value: '', child: Text(l10n.mgNoGroup)),
        for (final g in groups)
          PopupMenuItem<String?>(value: g.id, child: Text(g.name)),
      ],
      child: Chip(
        avatar: const Icon(Icons.groups_outlined, size: 18),
        label: Text(label),
        backgroundColor: active
            ? Theme.of(context).colorScheme.secondaryContainer
            : null,
      ),
    );
  }

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
    final groups = ref.watch(ministryGroupsProvider).value ?? const [];
    final metaName =
        ref.watch(congregationMetaProvider).value?.name ?? '';
    // S-21 import writes profile fields and reports, so both roles apply.
    final roles = ref.watch(myRolesProvider);
    final canImportS21 =
        roles.canEditPublishers() && roles.canEditReports();

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
            if (_pioneerOnly && !p.isPioneer) return false;
            if (_genderFilter != null && p.gender != _genderFilter) {
              return false;
            }
            if (_appointmentFilter != null &&
                p.appointment != _appointmentFilter) {
              return false;
            }
            if (_rightsOnly && !p.roles.any) return false;
            if (_groupFilter != null) {
              final noGroup = p.groupId == null || p.groupId!.isEmpty;
              // '' sentinel filters to publishers with no group.
              if (_groupFilter!.isEmpty ? !noGroup : p.groupId != _groupFilter) {
                return false;
              }
            }
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
                    if (canImportS21)
                      IconButton(
                        tooltip: l10n.s21ImportNew,
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const S21ImportScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.upload_file_outlined),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _groupFilterChip(l10n, groups),
                    FilterChip(
                      label: Text(l10n.pubFilterPioneers),
                      selected: _pioneerOnly,
                      onSelected: (v) => setState(() => _pioneerOnly = v),
                    ),
                    FilterChip(
                      label: Text(appointmentLabel(l10n, Appointment.elder)),
                      selected: _appointmentFilter == Appointment.elder,
                      onSelected: (v) => setState(() =>
                          _appointmentFilter = v ? Appointment.elder : null),
                    ),
                    FilterChip(
                      label: Text(appointmentLabel(
                          l10n, Appointment.ministerialServant)),
                      selected:
                          _appointmentFilter == Appointment.ministerialServant,
                      onSelected: (v) => setState(() => _appointmentFilter =
                          v ? Appointment.ministerialServant : null),
                    ),
                    FilterChip(
                      label: Text(genderLabel(l10n, Gender.male)),
                      selected: _genderFilter == Gender.male,
                      onSelected: (v) => setState(
                          () => _genderFilter = v ? Gender.male : null),
                    ),
                    FilterChip(
                      label: Text(genderLabel(l10n, Gender.female)),
                      selected: _genderFilter == Gender.female,
                      onSelected: (v) => setState(
                          () => _genderFilter = v ? Gender.female : null),
                    ),
                    FilterChip(
                      label: Text(l10n.pubFilterHasRights),
                      selected: _rightsOnly,
                      onSelected: (v) => setState(() => _rightsOnly = v),
                    ),
                    if (hasMoved)
                      FilterChip(
                        label: Text(l10n.pubAdminShowMoved),
                        selected: _showMoved,
                        onSelected: (v) => setState(() => _showMoved = v),
                      ),
                    if (_anyFilterActive)
                      ActionChip(
                        avatar: const Icon(Icons.clear, size: 18),
                        label: Text(l10n.pubFilterClear),
                        onPressed: _clearFilters,
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 88),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final p = filtered[i];
                    final genderColors = genderAvatarColors(context, p.gender);
                    // Moved is checked first: a moved publisher is also
                    // unverified, but should read as "moved", not "awaiting".
                    final tile = ListTile(
                      leading: CircleAvatar(
                        backgroundColor: genderColors?.background,
                        foregroundColor: genderColors?.foreground,
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
                              : PublisherBadges(publisher: p),
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
