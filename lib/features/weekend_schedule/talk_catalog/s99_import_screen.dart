import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/talk_catalog_repository.dart';
import '../../../core/data/weekend_repository.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/models/models.dart';
import '../../../core/pdf/pdf_text.dart';
import '../../../core/utils/dates.dart';
import 's99_parser.dart';

/// "Update Talk Titles from PDF": pick an S-99 form PDF (any language),
/// preview the parsed titles against the current catalog, then replace the
/// catalog. Snapshots on current and future weekend weeks are updated;
/// past weeks keep the wording that was delivered.
class S99ImportScreen extends ConsumerStatefulWidget {
  const S99ImportScreen({super.key});

  @override
  ConsumerState<S99ImportScreen> createState() => _S99ImportScreenState();
}

class _S99ImportScreenState extends ConsumerState<S99ImportScreen> {
  Map<int, String>? _parsed;
  Map<int, String> _old = {};
  CatalogDiff? _diff;
  String _fileName = '';
  bool _busy = false;
  String? _error;

  Future<void> _pickFile() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );
      final bytes = result?.files.single.bytes;
      if (bytes == null) return;
      final parsed = S99Parser.parse(await extractPdfPageTexts(bytes));
      final catalog = await ref.read(talkCatalogProvider.future);
      final old = {
        for (final e in (catalog ?? const TalkCatalog()).titles.entries)
          int.parse(e.key): e.value
      };
      setState(() {
        _parsed = parsed;
        _old = old;
        _diff = diffCatalog(old, parsed);
        _fileName = result!.files.single.name;
      });
    } on FormatException {
      if (mounted) setState(() => _error = context.l10n.talksParseError);
    } catch (e) {
      if (mounted) {
        setState(() => _error = context.l10n.commonErrorDetail(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    final parsed = _parsed;
    final diff = _diff;
    if (parsed == null || diff == null) return;
    setState(() => _busy = true);
    try {
      await ref.read(talkCatalogRepositoryProvider).saveCatalog(TalkCatalog(
            titles: {for (final e in parsed.entries) '${e.key}': e.value},
            updatedAt: dateKey(DateTime.now()),
            source: _fileName,
          ));
      final changed = {for (final no in diff.changed) no: parsed[no]!};
      final updated = await ref
          .read(weekendRepositoryProvider)
          .updateTalkTitles(changed, fromWeekId: weekIdOf(DateTime.now()));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.talksImportDone(updated))));
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _badge(String label, Color color) => Text(label,
      style: Theme.of(context)
          .textTheme
          .labelSmall
          ?.copyWith(color: color, fontWeight: FontWeight.bold));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final parsed = _parsed;
    final diff = _diff;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.talksUpdateFromPdf)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                FilledButton.icon(
                  onPressed: _busy ? null : _pickFile,
                  icon: const Icon(Icons.file_open_outlined),
                  label: Text(l10n.talksPickPdf),
                ),
                if (_busy) ...[
                  const SizedBox(width: 16),
                  const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                ],
              ],
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(_error!,
                  style: TextStyle(color: theme.colorScheme.error)),
            ),
          if (parsed != null && diff != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.talksImportSummary(parsed.length, diff.added.length,
                    diff.changed.length, diff.removed.length),
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  for (final no in parsed.keys.toList()..sort())
                    ListTile(
                      dense: true,
                      leading: SizedBox(
                        width: 32,
                        child: Text('$no',
                            textAlign: TextAlign.right,
                            style: theme.textTheme.bodyMedium),
                      ),
                      title: Text(parsed[no]!),
                      subtitle: diff.changed.contains(no)
                          ? Text(_old[no]!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  decoration: TextDecoration.lineThrough))
                          : null,
                      trailing: diff.added.contains(no)
                          ? _badge(l10n.talksNew, theme.colorScheme.primary)
                          : diff.changed.contains(no)
                              ? _badge(l10n.talksChanged,
                                  theme.colorScheme.tertiary)
                              : null,
                    ),
                  for (final no in diff.removed)
                    ListTile(
                      dense: true,
                      leading: SizedBox(
                        width: 32,
                        child: Text('$no',
                            textAlign: TextAlign.right,
                            style: theme.textTheme.bodyMedium),
                      ),
                      title: Text(_old[no]!,
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough)),
                      trailing:
                          _badge(l10n.talksRemoved, theme.colorScheme.error),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: parsed == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: _busy ? null : _save,
                  child: Text(l10n.talksImportSave),
                ),
              ),
            ),
    );
  }
}
