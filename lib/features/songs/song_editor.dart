import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/song_catalog_repository.dart';
import '../../core/l10n/l10n.dart';
import 'song_cdn.dart';

typedef SongSelection = ({int? songNo, String title});

/// Renders a song for display: "N. Title", or the bare title / number when one
/// side is missing (a parsed number without an imported catalog shows "N").
String songDisplayText(int? no, String title) {
  if (title.isEmpty) return no == null ? '—' : '$no';
  return no == null ? title : '$no. $title';
}

/// Opens the song picker: pick a numbered title from the imported song catalog
/// or enter free text. Returns the selection (catalog picks carry the song
/// number, free text does not), or null when cancelled.
Future<SongSelection?> showSongEditor(
  BuildContext context, {
  required String dialogTitle,
  required int? songNo,
  required String songTitle,
}) {
  return showDialog<SongSelection>(
    context: context,
    builder: (_) => _SongEditorDialog(
      dialogTitle: dialogTitle,
      songNo: songNo,
      songTitle: songTitle,
    ),
  );
}

enum _Mode { catalog, freeText }

class _SongEditorDialog extends ConsumerStatefulWidget {
  const _SongEditorDialog({
    required this.dialogTitle,
    required this.songNo,
    required this.songTitle,
  });

  final String dialogTitle;
  final int? songNo;
  final String songTitle;

  @override
  ConsumerState<_SongEditorDialog> createState() => _SongEditorDialogState();
}

class _SongEditorDialogState extends ConsumerState<_SongEditorDialog> {
  late _Mode _mode;
  int? _selectedNo;
  late final TextEditingController _freeText;
  String _filter = '';
  bool _fetching = false;
  String? _fetchError;

  @override
  void initState() {
    super.initState();
    _selectedNo = widget.songNo;
    _freeText = TextEditingController(text: widget.songTitle);
    _mode = widget.songNo == null && widget.songTitle.trim().isNotEmpty
        ? _Mode.freeText
        : _Mode.catalog;
  }

  @override
  void dispose() {
    _freeText.dispose();
    super.dispose();
  }

  Future<void> _updateFromWeb() async {
    setState(() {
      _fetching = true;
      _fetchError = null;
    });
    try {
      final catalog =
          await fetchSongCatalogFromCdn(Localizations.localeOf(context));
      if (catalog == null) {
        if (mounted) setState(() => _fetchError = context.l10n.songsCdnNothing);
        return;
      }
      await ref.read(songCatalogRepositoryProvider).saveCatalog(catalog);
    } catch (e) {
      if (mounted) {
        setState(() => _fetchError = context.l10n.commonErrorDetail(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _fetching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final catalog = ref.watch(songCatalogProvider).value;
    final titles = catalog?.titles ?? const <String, String>{};
    final numbers = (catalog?.numbers ?? const <int>[])
        .where((no) => _filter.isEmpty
            ? true
            : '$no. ${titles['$no']}'
                .toLowerCase()
                .contains(_filter.toLowerCase()))
        .toList();

    final canSave = _mode == _Mode.freeText || _selectedNo != null;

    return AlertDialog(
      title: Text(widget.dialogTitle),
      content: SizedBox(
        width: 420,
        height: 460,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<_Mode>(
              segments: [
                ButtonSegment(
                    value: _Mode.catalog,
                    label: Text(l10n.pickerFromCatalog)),
                ButtonSegment(
                    value: _Mode.freeText, label: Text(l10n.pickerFreeText)),
              ],
              selected: {_mode},
              onSelectionChanged: (s) => setState(() => _mode = s.first),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _mode == _Mode.freeText
                  ? TextField(
                      controller: _freeText,
                      autofocus: true,
                      decoration:
                          InputDecoration(labelText: l10n.pickerFreeText),
                    )
                  : titles.isEmpty
                      ? _EmptyCatalog(
                          fetching: _fetching,
                          error: _fetchError,
                          onUpdate: _fetching ? null : _updateFromWeb,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                labelText: l10n.songsSearchHint,
                                prefixIcon: const Icon(Icons.search),
                                isDense: true,
                              ),
                              onChanged: (v) => setState(() => _filter = v),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: ListView.builder(
                                itemCount: numbers.length,
                                itemBuilder: (context, i) {
                                  final no = numbers[i];
                                  final selected = no == _selectedNo;
                                  return ListTile(
                                    dense: true,
                                    selected: selected,
                                    title: Text('$no. ${titles['$no']}'),
                                    trailing: selected
                                        ? const Icon(Icons.check)
                                        : null,
                                    onTap: () =>
                                        setState(() => _selectedNo = no),
                                  );
                                },
                              ),
                            ),
                          ],
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
        FilledButton(
          onPressed: !canSave
              ? null
              : () => Navigator.of(context).pop(_mode == _Mode.freeText
                  ? (songNo: null, title: _freeText.text.trim())
                  : (
                      songNo: _selectedNo,
                      title: catalog?.titleFor(_selectedNo!) ?? '',
                    )),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}

/// Empty-catalog state: prompt to fetch the song list from the official web.
class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog({
    required this.fetching,
    required this.error,
    required this.onUpdate,
  });

  final bool fetching;
  final String? error;
  final VoidCallback? onUpdate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(l10n.songsEmpty, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onUpdate,
            icon: const Icon(Icons.cloud_download_outlined),
            label: Text(l10n.songsUpdateFromWeb),
          ),
          if (fetching) ...[
            const SizedBox(height: 16),
            const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2)),
          ],
          if (error != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.error)),
            ),
          ],
        ],
      ),
    );
  }
}
