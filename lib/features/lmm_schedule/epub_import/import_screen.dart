import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/assignment_history.dart';
import '../../../core/data/lmm_repository.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/models/models.dart';
import 'week_merge.dart';

/// Preview of Meeting Workbook weeks already parsed (from a picked .epub or
/// a CDN fetch — see `import_actions.dart`): choose which to save. Weeks
/// that already exist are merged so assignments are kept.
class EpubImportScreen extends ConsumerStatefulWidget {
  const EpubImportScreen({super.key, required this.weeks});

  final List<LmmWeek> weeks;

  @override
  ConsumerState<EpubImportScreen> createState() => _EpubImportScreenState();
}

class _EpubImportScreenState extends ConsumerState<EpubImportScreen> {
  Map<String, LmmWeek> _existing = {};
  final Set<String> _selected = {};
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.weeks.map((w) => w.id));
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final repo = ref.read(lmmRepositoryProvider);
    final existing =
        await repo.getRange(widget.weeks.first.id, widget.weeks.last.id);
    if (!mounted) return;
    setState(() {
      _existing = {for (final week in existing) week.id: week};
    });
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      final repo = ref.read(lmmRepositoryProvider);
      for (final week in widget.weeks) {
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.importTitle)),
      body: ListView(
        children: [
          for (final week in widget.weeks)
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
              title:
                  Text(week.weekLabel.isEmpty ? week.id : week.weekLabel),
              subtitle: Text([
                week.id,
                if (_existing.containsKey(week.id)) l10n.importWeekExists,
              ].join(' — ')),
              childrenPadding: const EdgeInsets.fromLTRB(24, 0, 16, 12),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: _weekPreview(context, week),
            ),
        ],
      ),
      bottomNavigationBar: _selected.isEmpty
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
