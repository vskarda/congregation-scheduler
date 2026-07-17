import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/l10n.dart';
import 'backup_service.dart';

/// Restores a congregation from a backup JSON file: pick a file, preview what
/// it contains (backup date, congregation name, per-collection document
/// counts), then overwrite the current data with it. Reached from Congregation
/// Settings; the caller is already gated on `roles.fullAdmin`.
class BackupImportScreen extends ConsumerStatefulWidget {
  const BackupImportScreen({super.key});

  @override
  ConsumerState<BackupImportScreen> createState() => _BackupImportScreenState();
}

class _BackupImportScreenState extends ConsumerState<BackupImportScreen> {
  Map<String, dynamic>? _backup;
  Map<String, int>? _counts;
  BackupImportResult? _result;
  bool _busy = false;
  String? _error;

  Future<void> _pickFile() async {
    setState(() {
      _busy = true;
      _error = null;
      _result = null;
    });
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );
      final bytes = result?.files.single.bytes;
      if (bytes == null) return;
      final decoded = jsonDecode(utf8.decode(bytes));
      if (decoded is! Map<String, dynamic> ||
          decoded['format'] != backupFormat ||
          decoded['collections'] is! Map) {
        setState(() => _error = context.l10n.backupInvalidFile);
        return;
      }
      setState(() {
        _backup = decoded;
        _counts = backupDocCounts(decoded);
      });
    } catch (_) {
      if (mounted) setState(() => _error = context.l10n.backupInvalidFile);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    final backup = _backup;
    if (backup == null) return;
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await ref.read(backupServiceProvider).importAll(backup);
      if (!mounted) return;
      setState(() => _result = result);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            result.hasFailures
                ? l10n.backupImportPartial(
                    result.totalRestored,
                    result.failed.keys.join(', '),
                  )
                : l10n.backupImportSuccess(result.totalRestored),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _error = context.l10n.commonErrorDetail(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _formatDate(String? iso) {
    final parsed = iso == null ? null : DateTime.tryParse(iso);
    if (parsed == null) return '';
    return DateFormat.yMMMd(Localizations.localeOf(context).toString())
        .add_Hm()
        .format(parsed.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final backup = _backup;
    final counts = _counts;
    final result = _result;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupImportTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _busy ? null : _pickFile,
                icon: const Icon(Icons.file_open_outlined),
                label: Text(l10n.backupImportPick),
              ),
              const SizedBox(width: 12),
              if (_busy)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _error!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          if (backup == null && _error == null)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                l10n.backupImportEmpty,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          if (backup != null && counts != null) ...[
            const SizedBox(height: 24),
            Text(
              l10n.backupImportFrom(
                (backup['congregationName'] as String?) ?? '',
                _formatDate(backup['exportedAt'] as String?),
              ),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(l10n.backupImportContents, style: theme.textTheme.labelLarge),
            const SizedBox(height: 4),
            for (final entry in counts.entries)
              if (entry.value > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key, style: theme.textTheme.bodyMedium),
                      Text('${entry.value}', style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
            const SizedBox(height: 20),
            Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_outlined,
                        color: theme.colorScheme.onErrorContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.backupImportWarning,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (result != null && result.hasFailures)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  l10n.backupImportPartial(
                    result.totalRestored,
                    result.failed.keys.join(', '),
                  ),
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _busy ? null : _import,
              icon: const Icon(Icons.restore_outlined),
              label: Text(l10n.backupImportConfirm),
            ),
          ],
        ],
      ),
    );
  }
}
