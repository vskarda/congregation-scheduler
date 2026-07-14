import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import 'connect_publisher_service.dart';

/// Admin flow connecting an awaiting [account] (self-registered, unverified)
/// to an admin-created record: pick the record, confirm the irreversible
/// merge, then run the migration with progress. Full-admin only (the entry
/// point enforces it); see [ConnectPublisherService] for what actually moves.
Future<void> showConnectRecordFlow(
    BuildContext context, WidgetRef ref, Publisher account) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final all = ref.read(allPublishersProvider).value ?? const <Publisher>[];
  final records = all.where((p) => !p.hasAccount && !p.moved).toList();
  if (records.isEmpty) {
    messenger
        .showSnackBar(SnackBar(content: Text(l10n.pubConnectNoRecords)));
    return;
  }

  final record = await showDialog<Publisher>(
    context: context,
    builder: (context) =>
        _RecordPickerDialog(records: records, account: account),
  );
  if (record == null || !context.mounted) return;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.link, size: 32),
      title: Text(l10n.pubConnectConfirmTitle),
      content:
          Text(l10n.pubConnectConfirmBody(record.fullName, account.fullName)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.pubConnectAction),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;

  final done = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        _ConnectProgressDialog(record: record, account: account),
  );
  if (done == true) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.pubConnectSuccess)));
  }
}

/// Searchable list of records without an app account; pops the picked one.
class _RecordPickerDialog extends StatefulWidget {
  const _RecordPickerDialog({required this.records, required this.account});

  final List<Publisher> records;
  final Publisher account;

  @override
  State<_RecordPickerDialog> createState() => _RecordPickerDialogState();
}

class _RecordPickerDialogState extends State<_RecordPickerDialog> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final query = _filter.toLowerCase();
    final filtered = widget.records
        .where((p) => query.isEmpty || p.fullName.toLowerCase().contains(query))
        .toList();
    return AlertDialog(
      title: Text(l10n.pubConnectPickTitle),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.pubConnectPickHint(widget.account.fullName)),
            const SizedBox(height: 12),
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.commonSearch,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _filter = v),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final p = filtered[i];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(p.firstName.isEmpty
                            ? '?'
                            : p.firstName[0].toUpperCase()),
                      ),
                      title: Text(p.listName),
                      subtitle: Text(l10n.pubAdminNoAccountBadge),
                      onTap: () => Navigator.of(context).pop(p),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
      ],
    );
  }
}

/// Runs the migration; not dismissible while running. Pops `true` on
/// success. On failure it names the failed section and offers a retry —
/// every migration step is idempotent, so retrying is always safe.
class _ConnectProgressDialog extends ConsumerStatefulWidget {
  const _ConnectProgressDialog({required this.record, required this.account});

  final Publisher record;
  final Publisher account;

  @override
  ConsumerState<_ConnectProgressDialog> createState() =>
      _ConnectProgressDialogState();
}

class _ConnectProgressDialogState
    extends ConsumerState<_ConnectProgressDialog> {
  ConnectSection _section = ConnectSection.reports;
  Object? _error;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    setState(() {
      _running = true;
      _error = null;
    });
    try {
      await ref.read(connectPublisherServiceProvider).connect(
            recordId: widget.record.id,
            accountUid: widget.account.id,
            onProgress: (s) {
              if (mounted) setState(() => _section = s);
            },
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _running = false;
        });
      }
    }
  }

  String _sectionLabel(ConnectSection s) {
    final l10n = context.l10n;
    return switch (s) {
      ConnectSection.reports => l10n.navReportsAdmin,
      ConnectSection.territories => l10n.navTerritories,
      ConnectSection.groups => l10n.navMinistryGroups,
      ConnectSection.lmm => l10n.navLmm,
      ConnectSection.weekend => l10n.navWeekend,
      ConnectSection.publicWitnessing => l10n.navPublicWitnessing,
      ConnectSection.fieldServiceMeetings => l10n.navFieldServiceMeetings,
      ConnectSection.profile => l10n.pubAdminTabProfile,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: !_running,
      child: AlertDialog(
        title: Text(l10n.pubConnectProgressTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_error == null) ...[
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Text(_sectionLabel(_section))),
                ],
              ),
              const SizedBox(height: 12),
              Text(l10n.pubConnectProgressBody,
                  style: Theme.of(context).textTheme.bodySmall),
            ] else ...[
              Text(l10n.pubConnectFailed(_sectionLabel(_section))),
              const SizedBox(height: 8),
              Text(_error.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.error)),
            ],
          ],
        ),
        actions: [
          if (_error != null) ...[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonClose),
            ),
            FilledButton(
              onPressed: _run,
              child: Text(l10n.commonRetry),
            ),
          ],
        ],
      ),
    );
  }
}
