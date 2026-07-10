import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/talk_catalog_repository.dart';
import '../../core/l10n/l10n.dart';

typedef TalkSelection = ({int? talkNo, String title});

/// Opens the public talk title editor: pick a title from the S-99 catalog or
/// enter free text. Returns the selection (catalog picks carry the talk
/// number, free text does not), or null when cancelled.
Future<TalkSelection?> showTalkTitleEditor(
  BuildContext context, {
  required int? talkNo,
  required String title,
}) {
  return showDialog<TalkSelection>(
    context: context,
    builder: (_) => _TalkTitleEditorDialog(talkNo: talkNo, title: title),
  );
}

enum _Mode { catalog, freeText }

class _TalkTitleEditorDialog extends ConsumerStatefulWidget {
  const _TalkTitleEditorDialog({required this.talkNo, required this.title});

  final int? talkNo;
  final String title;

  @override
  ConsumerState<_TalkTitleEditorDialog> createState() =>
      _TalkTitleEditorDialogState();
}

class _TalkTitleEditorDialogState
    extends ConsumerState<_TalkTitleEditorDialog> {
  late _Mode _mode;
  int? _selectedNo;
  late final TextEditingController _freeText;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _selectedNo = widget.talkNo;
    _freeText = TextEditingController(text: widget.title);
    _mode = widget.talkNo == null && widget.title.trim().isNotEmpty
        ? _Mode.freeText
        : _Mode.catalog;
  }

  @override
  void dispose() {
    _freeText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final catalog = ref.watch(talkCatalogProvider).value;
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
      title: Text(l10n.weekendTalkTitle),
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
                      minLines: 2,
                      maxLines: 4,
                      autofocus: true,
                      decoration:
                          InputDecoration(labelText: l10n.pickerFreeText),
                    )
                  : titles.isEmpty
                      ? Center(
                          child: Text(l10n.talksEmpty,
                              textAlign: TextAlign.center))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                labelText: l10n.talksSearchHint,
                                prefixIcon: const Icon(Icons.search),
                                isDense: true,
                              ),
                              onChanged: (v) =>
                                  setState(() => _filter = v),
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
                                    onTap: () => setState(
                                        () => _selectedNo = no),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () {
                  final router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  router.go('/admin/talks');
                },
                icon: const Icon(Icons.record_voice_over_outlined, size: 18),
                label: Text(l10n.talksOpenCatalog),
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
                  ? (talkNo: null, title: _freeText.text.trim())
                  : (
                      talkNo: _selectedNo,
                      title: (catalog?.titleFor(_selectedNo!)) ?? ''
                    )),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
