import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../../../core/data/assignment_history.dart';
import '../../../core/data/lmm_repository.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/models/models.dart';
import '../../../core/utils/dates.dart';
import 'mwb_parser.dart';
import 'pub_media.dart';
import 'week_merge.dart';

/// Meeting Workbook import: pick an .epub (or fetch it from the pub-media
/// API), preview the parsed weeks with their parts, choose which to save.
/// Weeks that already exist are merged so assignments are kept.
class EpubImportScreen extends ConsumerStatefulWidget {
  const EpubImportScreen({super.key});

  @override
  ConsumerState<EpubImportScreen> createState() => _EpubImportScreenState();
}

class _EpubImportScreenState extends ConsumerState<EpubImportScreen> {
  List<LmmWeek>? _weeks;
  Set<String> _selected = {};
  Map<String, LmmWeek> _existing = {};
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
    final existing = await repo.getRange(weeks.first.id, weeks.last.id);
    final existingById = {for (final week in existing) week.id: week};
    setState(() {
      _weeks = weeks;
      _existing = existingById;
      _selected = weeks.map((w) => w.id).toSet();
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
    const template = AppConfig.workbookCdnUrlTemplate;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final locale = Localizations.localeOf(context).languageCode;
      final lang = switch (locale) {
        'cs' => 'B',
        'tr' => 'T',
        _ => 'E',
      };
      final now = DateTime.now();
      // Workbook issues cover two months starting with odd months; try the
      // current issue and the next one (which may not be published yet).
      final currentIssue =
          DateTime(now.year, now.month.isOdd ? now.month : now.month - 1);
      final weeksById = <String, LmmWeek>{};
      var fetchedAny = false;
      for (final issue in [currentIssue, addMonths(currentIssue, 2)]) {
        final url = template.replaceAll('{lang}', lang).replaceAll('{yyyyMM}',
            '${issue.year}${issue.month.toString().padLeft(2, '0')}');
        final api = await http.get(Uri.parse(url));
        if (api.statusCode == 404) continue; // issue not published yet
        if (api.statusCode != 200) throw Exception('HTTP ${api.statusCode}');
        final epubUrl = epubUrlFromPubMedia(api.body, lang);
        if (epubUrl == null) continue;
        final epub = await http.get(Uri.parse(epubUrl));
        if (epub.statusCode != 200) throw Exception('HTTP ${epub.statusCode}');
        fetchedAny = true;
        final weeks = MwbParser.parse(epub.bodyBytes,
            fileName: epubUrl, source: 'cdn');
        for (final week in weeks) {
          weeksById[week.id] = week;
        }
      }
      if (!fetchedAny) {
        if (mounted) {
          setState(() => _error = context.l10n.importCdnNothing);
        }
        return;
      }
      final combined = weeksById.values.toList()
        ..sort((a, b) => a.id.compareTo(b.id));
      await _loadWeeks(combined);
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
        if (!_selected.contains(week.id)) continue;
        final existing = _existing[week.id];
        await repo.saveWeek(existing == null
            ? week
            : mergeParsedWeek(existing: existing, parsed: week));
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

  static Color _sectionColor(LmmSection s) => switch (s) {
        LmmSection.treasures => const Color(0xFF2F6B77),
        LmmSection.ministry => const Color(0xFF9C6F19),
        LmmSection.living => const Color(0xFF8E2E33),
        _ => const Color(0xFF5C6BC0),
      };

  /// Preview of a parsed week: songs and the named program parts, so a bad
  /// parse is visible before anything is saved.
  List<Widget> _weekPreview(BuildContext context, LmmWeek week) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant);
    return [
      if (week.songs.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text('${l10n.lmmSongs}: ${week.songs.join(' · ')}',
              style: muted),
        ),
      for (final part in week.parts.where((p) => p.title.isNotEmpty))
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  part.durationMin == null
                      ? ''
                      : l10n.partMinutes(part.durationMin!),
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(part.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: _sectionColor(part.section))),
                    if (part.description.isNotEmpty)
                      Text(part.description, style: muted),
                  ],
                ),
              ),
            ],
          ),
        ),
    ];
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
                    ExpansionTile(
                      leading: Checkbox(
                        value: _selected.contains(week.id),
                        onChanged: (v) => setState(() {
                          if (v == true) {
                            _selected.add(week.id);
                          } else {
                            _selected.remove(week.id);
                          }
                        }),
                      ),
                      title: Text(week.weekLabel.isEmpty
                          ? week.id
                          : week.weekLabel),
                      subtitle: Text([
                        week.id,
                        if (_existing.containsKey(week.id))
                          l10n.importWeekExists,
                      ].join(' — ')),
                      childrenPadding:
                          const EdgeInsets.fromLTRB(24, 0, 16, 12),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: _weekPreview(context, week),
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
