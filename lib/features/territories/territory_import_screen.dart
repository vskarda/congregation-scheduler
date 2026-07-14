import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/territories_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import 'territory_import_parser.dart';

/// Bulk import: paste rows from a spreadsheet (or pick a CSV file), preview
/// what will be created/updated/skipped, then batch-save. Rows are matched
/// against existing territories by number; matches are skipped unless the
/// "update existing" switch is on.
class TerritoryImportScreen extends ConsumerStatefulWidget {
  const TerritoryImportScreen({super.key});

  @override
  ConsumerState<TerritoryImportScreen> createState() =>
      _TerritoryImportScreenState();
}

class _TerritoryImportScreenState extends ConsumerState<TerritoryImportScreen> {
  final _pasteCtrl = TextEditingController();
  List<TerritoryImportEntry>? _entries;
  bool _updateExisting = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _pasteCtrl.dispose();
    super.dispose();
  }

  Future<void> _parse(String text) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      // One-shot read; territoriesProvider.future would hang if nothing else
      // is listening to it (unlistened providers are paused).
      final existing =
          await ref.read(territoriesRepositoryProvider).watchAll().first;
      final rows = parseTerritoryImport(text);
      if (!mounted) return;
      setState(() {
        _entries = analyzeTerritoryImport(rows, existing);
        _error = rows.isEmpty ? context.l10n.terrImportEmpty : null;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _error = context.l10n.commonErrorDetail(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickFile() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'txt', 'tsv'],
        withData: true,
      );
      final bytes = result?.files.single.bytes;
      if (bytes == null) return;
      final text = decodeImportBytes(bytes);
      _pasteCtrl.text = text;
      if (mounted) await _parse(text);
    } catch (e) {
      if (mounted) {
        setState(() => _error = context.l10n.commonErrorDetail(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  bool _willImport(TerritoryImportEntry e) =>
      e.status == TerritoryImportStatus.newEntry ||
      (e.status == TerritoryImportStatus.duplicate && _updateExisting);

  Future<void> _save() async {
    final entries = _entries;
    if (entries == null) return;
    final toSave = <Territory>[];
    var created = 0;
    var updated = 0;
    for (final e in entries) {
      if (e.status == TerritoryImportStatus.newEntry) {
        toSave.add(
          Territory(
            name: e.row.name,
            number: e.row.number,
            mapUrl: e.row.mapUrl,
            notes: e.row.notes,
          ),
        );
        created++;
      } else if (e.status == TerritoryImportStatus.duplicate &&
          _updateExisting) {
        toSave.add(
          e.existing!.copyWith(
            name: e.row.name,
            number: e.row.number,
            mapUrl: e.row.mapUrl,
            notes: e.row.notes,
          ),
        );
        updated++;
      }
    }
    if (toSave.isEmpty) return;
    setState(() => _busy = true);
    try {
      await ref.read(territoriesRepositoryProvider).saveTerritories(toSave);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.terrImportDone(created, updated)),
          ),
        );
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _badge(String label, Color color) => Text(
    label,
    style: Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
  );

  Widget _entryTile(TerritoryImportEntry e) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final row = e.row;
    final (String label, Color color) = switch (e.status) {
      TerritoryImportStatus.newEntry => (
        l10n.terrImportBadgeNew,
        theme.colorScheme.primary,
      ),
      TerritoryImportStatus.duplicate =>
        _updateExisting
            ? (l10n.terrImportBadgeUpdate, theme.colorScheme.tertiary)
            : (l10n.terrImportBadgeSkip, theme.colorScheme.outline),
      TerritoryImportStatus.duplicateInFile => (
        l10n.terrImportBadgeDupRow,
        theme.colorScheme.error,
      ),
      TerritoryImportStatus.invalid => (
        l10n.terrImportBadgeInvalid,
        theme.colorScheme.error,
      ),
    };
    // For a matched row whose name changed, show the current name struck out.
    final oldName =
        e.status == TerritoryImportStatus.duplicate &&
            e.existing!.name != row.name
        ? e.existing!.name
        : null;
    final details = [
      if (row.mapUrl.isNotEmpty) row.mapUrl,
      if (row.notes.isNotEmpty) row.notes,
    ].join(' · ');
    return ListTile(
      dense: true,
      leading: SizedBox(
        width: 48,
        child: Text(
          row.number,
          textAlign: TextAlign.right,
          style: theme.textTheme.bodyMedium,
        ),
      ),
      title: Text(
        row.name.isEmpty ? l10n.terrImportLine(row.line) : row.name,
        style: e.status == TerritoryImportStatus.invalid
            ? TextStyle(color: theme.colorScheme.error)
            : null,
      ),
      subtitle: oldName != null
          ? Text(
              oldName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                decoration: TextDecoration.lineThrough,
              ),
            )
          : details.isEmpty
          ? null
          : Text(details, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: _badge(label, color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final entries = _entries;
    final importCount = entries?.where(_willImport).length ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.terrImportTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              controller: _pasteCtrl,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: l10n.terrImportPasteHint,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: _busy ? null : () => _parse(_pasteCtrl.text),
                  icon: const Icon(Icons.preview_outlined),
                  label: Text(l10n.terrImportPreview),
                ),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _pickFile,
                  icon: const Icon(Icons.file_open_outlined),
                  label: Text(l10n.terrImportPickFile),
                ),
                if (_busy)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _error!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          if (entries != null && entries.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.terrImportSummary(
                  entries.length,
                  entries
                      .where((e) => e.status == TerritoryImportStatus.newEntry)
                      .length,
                  entries
                      .where((e) => e.status == TerritoryImportStatus.duplicate)
                      .length,
                  entries
                      .where(
                        (e) =>
                            e.status == TerritoryImportStatus.invalid ||
                            e.status == TerritoryImportStatus.duplicateInFile,
                      )
                      .length,
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),
            if (entries.any((e) => e.status == TerritoryImportStatus.duplicate))
              SwitchListTile(
                dense: true,
                title: Text(l10n.terrImportUpdateExisting),
                value: _updateExisting,
                onChanged: (v) => setState(() => _updateExisting = v),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, i) => _entryTile(entries[i]),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: entries == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: _busy || importCount == 0 ? null : _save,
                  child: Text(l10n.terrImportSave(importCount)),
                ),
              ),
            ),
    );
  }
}
