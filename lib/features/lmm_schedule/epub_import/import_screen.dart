import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../../../core/data/assignment_history.dart';
import '../../../core/data/lmm_repository.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/models/models.dart';
import 'mwb_parser.dart';

/// Meeting Workbook import: pick an .epub (or fetch it from the configured
/// CDN), preview the parsed weeks, choose which to save.
class EpubImportScreen extends ConsumerStatefulWidget {
  const EpubImportScreen({super.key});

  @override
  ConsumerState<EpubImportScreen> createState() => _EpubImportScreenState();
}

class _EpubImportScreenState extends ConsumerState<EpubImportScreen> {
  List<LmmWeek>? _weeks;
  Set<String> _selected = {};
  Set<String> _existing = {};
  bool _busy = false;
  String? _error;

  Future<void> _loadWeeks(List<LmmWeek> weeks) async {
    if (weeks.isEmpty) {
      setState(() {
        _weeks = [];
        _error = context.l10n.importNoWeeks;
      });
      return;
    }
    final repo = ref.read(lmmRepositoryProvider);
    final existing =
        await repo.getRange(weeks.first.id, weeks.last.id);
    final existingIds = existing.map((w) => w.id).toSet();
    setState(() {
      _weeks = weeks;
      _existing = existingIds;
      _selected =
          weeks.map((w) => w.id).where((id) => !existingIds.contains(id)).toSet();
      _error = null;
    });
  }

  Future<void> _pickFile() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['epub'],
        withData: true,
      );
      final bytes = result?.files.single.bytes;
      if (bytes == null) return;
      final weeks =
          MwbParser.parse(bytes, fileName: result!.files.single.name);
      await _loadWeeks(weeks);
    } catch (e) {
      if (mounted) {
        setState(() => _error = context.l10n.commonErrorDetail(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _fetchCdn() async {
    final template = AppConfig.workbookCdnUrlTemplate;
    if (template == null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final now = DateTime.now();
      // Workbook issues cover two months starting with odd months.
      final issueMonth = now.month.isOdd ? now.month : now.month - 1;
      final locale = Localizations.localeOf(context).languageCode;
      final lang = locale == 'cs' ? 'B' : 'E';
      final url = template
          .replaceAll('{lang}', lang)
          .replaceAll('{yyyyMM}',
              '${now.year}${issueMonth.toString().padLeft(2, '0')}');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }
      final weeks = MwbParser.parse(response.bodyBytes, fileName: url);
      await _loadWeeks(weeks);
    } catch (e) {
      if (mounted) {
        setState(() => _error = context.l10n.commonErrorDetail(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    final weeks = _weeks;
    if (weeks == null) return;
    setState(() => _busy = true);
    try {
      final repo = ref.read(lmmRepositoryProvider);
      for (final week in weeks) {
        if (_selected.contains(week.id)) {
          await repo.saveWeek(week);
        }
      }
      ref.invalidate(assignmentHistoryProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.importDone)));
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final weeks = _weeks;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.importTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                FilledButton.icon(
                  onPressed: _busy ? null : _pickFile,
                  icon: const Icon(Icons.file_open_outlined),
                  label: Text(l10n.importPickFile),
                ),
                const SizedBox(width: 12),
                if (AppConfig.workbookCdnUrlTemplate != null)
                  OutlinedButton.icon(
                    onPressed: _busy ? null : _fetchCdn,
                    icon: const Icon(Icons.cloud_download_outlined),
                    label: Text(l10n.weekCheckCdn),
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
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          if (weeks != null)
            Expanded(
              child: ListView(
                children: [
                  for (final week in weeks)
                    CheckboxListTile(
                      value: _selected.contains(week.id),
                      onChanged: (v) => setState(() {
                        if (v == true) {
                          _selected.add(week.id);
                        } else {
                          _selected.remove(week.id);
                        }
                      }),
                      title: Text(week.weekLabel.isEmpty
                          ? week.id
                          : week.weekLabel),
                      subtitle: Text([
                        week.id,
                        if (_existing.contains(week.id))
                          l10n.importWeekExists,
                      ].join(' — ')),
                    ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: weeks == null || _selected.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: _busy ? null : _save,
                  child: Text(l10n.importSave(_selected.length)),
                ),
              ),
            ),
    );
  }
}
