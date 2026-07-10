import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import 'publisher_form.dart';
import 'publisher_record_view.dart';
import 'publishers_providers.dart';

/// Admin view of one publisher: profile, rights, assignable roles, record.
class PublisherDetailScreen extends ConsumerWidget {
  const PublisherDetailScreen({super.key, required this.publisherId});

  final String publisherId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final publisherAsync = ref.watch(publisherProvider(publisherId));
    final publisher = publisherAsync.value;

    if (publisher == null) {
      return Scaffold(
        appBar: AppBar(),
        body: publisherAsync.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(child: Text(l10n.commonError)),
      );
    }

    final repo = ref.read(publishersRepositoryProvider);
    final isSelf = ref.watch(currentUidProvider) == publisher.id;

    Future<void> confirmDelete() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.commonConfirmDeleteTitle),
          content: Text(l10n.pubAdminDeleteConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.commonDelete),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        await repo.delete(publisherId);
        if (context.mounted) context.go('/admin/publishers');
      }
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: l10n.commonBack,
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/admin/publishers'),
          ),
          title: Text(publisher.fullName),
          actions: [
            Row(
              children: [
                Text(l10n.pubAdminVerified),
                Switch(
                  value: publisher.verified,
                  onChanged: (v) async {
                    if (!v && isSelf) {
                      final ok = await _confirmSelfPrivilegeRemoval(
                        context,
                        title: l10n.pubAdminSelfVerifiedWarningTitle,
                        body: l10n.pubAdminSelfVerifiedWarningBody,
                      );
                      if (!ok) return;
                    }
                    repo.update(publisher.copyWith(verified: v));
                  },
                ),
              ],
            ),
            IconButton(
              tooltip: l10n.commonDelete,
              onPressed: confirmDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.pubAdminTabProfile),
              Tab(text: l10n.pubAdminTabRoles),
              Tab(text: l10n.pubAdminTabAssign),
              Tab(text: l10n.pubAdminTabRecord),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ProfileTab(publisher: publisher),
            _RolesTab(publisher: publisher, isSelf: isSelf),
            _AssignTab(publisher: publisher),
            Padding(
              padding: const EdgeInsets.all(16),
              child: PublisherRecordView(publisherId: publisherId),
            ),
          ],
        ),
      ),
    );
  }
}

/// Strict confirmation before an admin removes a privilege from their own
/// account (Verified or Full Admin) — a misclick here can lock them out.
Future<bool> _confirmSelfPrivilegeRemoval(
  BuildContext context, {
  required String title,
  required String body,
}) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(Icons.warning_amber_rounded,
          color: Theme.of(context).colorScheme.error, size: 32),
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.pubAdminSelfWarningConfirm),
        ),
      ],
    ),
  );
  return confirmed == true;
}

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab({required this.publisher});

  final Publisher publisher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final private = ref.watch(publisherPrivateProvider(publisher.id));
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: private.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
              child: Text(context.l10n.commonErrorDetail(e.toString()))),
          data: (priv) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              PublisherForm(
                key: ValueKey('${publisher.id}-admin-form'),
                publisher: publisher,
                private: priv,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RolesTab extends ConsumerWidget {
  const _RolesTab({required this.publisher, required this.isSelf});

  final Publisher publisher;
  final bool isSelf;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final repo = ref.read(publishersRepositoryProvider);
    final roles = publisher.roles;

    Future<void> save(Roles updated) =>
        repo.update(publisher.copyWith(roles: updated));

    final entries = <(String, bool, Roles Function(bool), bool)>[
      (
        l10n.roleFullAdmin,
        roles.fullAdmin,
        (v) => roles.copyWith(fullAdmin: v),
        true,
      ),
      (
        l10n.navInfoBoard,
        roles.infoBoard,
        (v) => roles.copyWith(infoBoard: v),
        false,
      ),
      (l10n.navEvents, roles.events, (v) => roles.copyWith(events: v), false),
      (
        l10n.navLmm,
        roles.lmmSchedule,
        (v) => roles.copyWith(lmmSchedule: v),
        false,
      ),
      (
        l10n.navWeekend,
        roles.weekendSchedule,
        (v) => roles.copyWith(weekendSchedule: v),
        false,
      ),
      (
        l10n.navPublicWitnessing,
        roles.publicWitnessing,
        (v) => roles.copyWith(publicWitnessing: v),
        false,
      ),
      (
        l10n.navTerritories,
        roles.territories,
        (v) => roles.copyWith(territories: v),
        false,
      ),
      (
        '${l10n.navReportsAdmin} + ${l10n.navS1}',
        roles.reports,
        (v) => roles.copyWith(reports: v),
        false,
      ),
      (
        l10n.navAttendance,
        roles.attendance,
        (v) => roles.copyWith(attendance: v),
        false,
      ),
      (
        l10n.navPublishersAdmin,
        roles.publishers,
        (v) => roles.copyWith(publishers: v),
        false,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        for (final (label, value, update, sensitive) in entries)
          SwitchListTile(
            title: Text(label),
            value: value,
            onChanged: (v) async {
              if (sensitive && !v && isSelf) {
                final ok = await _confirmSelfPrivilegeRemoval(
                  context,
                  title: l10n.pubAdminSelfFullAdminWarningTitle,
                  body: l10n.pubAdminSelfFullAdminWarningBody,
                );
                if (!ok) return;
              }
              save(update(v));
            },
          ),
      ],
    );
  }
}

class _AssignTab extends ConsumerWidget {
  const _AssignTab({required this.publisher});

  final Publisher publisher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final repo = ref.read(publishersRepositoryProvider);
    final q = publisher.qualifications;

    Future<void> save(Qualifications updated) =>
        repo.update(publisher.copyWith(qualifications: updated));

    final lmm = <(String, bool, Qualifications Function(bool))>[
      (l10n.qChairman, q.chairman, (v) => q.copyWith(chairman: v)),
      (l10n.qPrayer, q.prayer, (v) => q.copyWith(prayer: v)),
      (l10n.qTreasures, q.treasures, (v) => q.copyWith(treasures: v)),
      (l10n.qGems, q.gems, (v) => q.copyWith(gems: v)),
      (l10n.qBibleReading, q.bibleReading, (v) => q.copyWith(bibleReading: v)),
      (
        l10n.qFieldMinistry,
        q.fieldMinistry,
        (v) => q.copyWith(fieldMinistry: v)
      ),
      (l10n.qLiving, q.livingParts, (v) => q.copyWith(livingParts: v)),
      (l10n.qCbsConductor, q.cbsConductor, (v) => q.copyWith(cbsConductor: v)),
      (l10n.qCbsReader, q.cbsReader, (v) => q.copyWith(cbsReader: v)),
    ];
    final weekend = <(String, bool, Qualifications Function(bool))>[
      (l10n.qPublicTalk, q.publicTalk, (v) => q.copyWith(publicTalk: v)),
      (
        l10n.qWeekendChairman,
        q.weekendChairman,
        (v) => q.copyWith(weekendChairman: v)
      ),
      (l10n.qWtReader, q.wtReader, (v) => q.copyWith(wtReader: v)),
    ];
    final support = <(String, bool, Qualifications Function(bool))>[
      (l10n.qAttendant, q.attendant, (v) => q.copyWith(attendant: v)),
      (l10n.qMicrophone, q.microphone, (v) => q.copyWith(microphone: v)),
      (l10n.qAudioVideo, q.audioVideo, (v) => q.copyWith(audioVideo: v)),
      (
        l10n.qPublicWitnessing,
        q.publicWitnessing,
        (v) => q.copyWith(publicWitnessing: v)
      ),
    ];

    Widget section(String title,
            List<(String, bool, Qualifications Function(bool))> items) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(title,
                  style: Theme.of(context).textTheme.labelLarge),
            ),
            for (final (label, value, update) in items)
              SwitchListTile(
                title: Text(label),
                value: value,
                dense: true,
                onChanged: (v) => save(update(v)),
              ),
          ],
        );

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        section(l10n.navLmm, lmm),
        section(l10n.navWeekend, weekend),
        section(l10n.qSupportSection, support),
      ],
    );
  }
}
