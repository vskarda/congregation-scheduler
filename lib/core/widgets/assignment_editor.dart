import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/assignment_history.dart';
import '../data/publishers_repository.dart';
import '../l10n/l10n.dart';
import '../models/models.dart';
import '../utils/dates.dart';

/// Opens the assignment editor dialog. Returns the new [Assignment], or null
/// when cancelled.
///
/// [qualifies] filters the default "qualified" view; [historyKey] selects
/// which history feeds the least-recently-assigned ordering. Admins can
/// always switch to "all publishers" or free text.
Future<Assignment?> showAssignmentEditor(
  BuildContext context, {
  required String title,
  required Assignment initial,
  required String historyKey,
  required bool Function(Publisher) qualifies,
  bool multi = true,
}) {
  return showDialog<Assignment>(
    context: context,
    builder: (_) => _AssignmentEditorDialog(
      title: title,
      initial: initial,
      historyKey: historyKey,
      qualifies: qualifies,
      multi: multi,
    ),
  );
}

enum _Mode { qualified, all, freeText }

class _AssignmentEditorDialog extends ConsumerStatefulWidget {
  const _AssignmentEditorDialog({
    required this.title,
    required this.initial,
    required this.historyKey,
    required this.qualifies,
    required this.multi,
  });

  final String title;
  final Assignment initial;
  final String historyKey;
  final bool Function(Publisher) qualifies;
  final bool multi;

  @override
  ConsumerState<_AssignmentEditorDialog> createState() =>
      _AssignmentEditorDialogState();
}

class _AssignmentEditorDialogState
    extends ConsumerState<_AssignmentEditorDialog> {
  late _Mode _mode;
  late Set<String> _selected;
  late final TextEditingController _freeText;

  @override
  void initState() {
    super.initState();
    _selected = {...widget.initial.publisherIds};
    _freeText = TextEditingController(text: widget.initial.freeText);
    _mode = widget.initial.freeText.trim().isNotEmpty && _selected.isEmpty
        ? _Mode.freeText
        : _Mode.qualified;
  }

  @override
  void dispose() {
    _freeText.dispose();
    super.dispose();
  }

  void _toggle(String id, bool? checked) {
    setState(() {
      if (widget.multi) {
        if (checked == true) {
          _selected.add(id);
        } else {
          _selected.remove(id);
        }
      } else {
        _selected = checked == true ? {id} : {};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final publishers = ref.watch(allPublishersProvider).value ?? const [];
    final history =
        ref.watch(assignmentHistoryProvider).value?[widget.historyKey] ??
            const <String, String>{};
    final locale = Localizations.localeOf(context).toString();
    final dateFmt = DateFormat.yMMMd(locale);

    List<Publisher> visible;
    switch (_mode) {
      case _Mode.qualified:
        visible = publishers
            .where((p) => p.verified && widget.qualifies(p))
            .toList()
          // Least recently assigned first; never-assigned to the very top.
          ..sort((a, b) {
            final da = history[a.id] ?? '';
            final db = history[b.id] ?? '';
            final byDate = da.compareTo(db);
            if (byDate != 0) return byDate;
            return a.listName
                .toLowerCase()
                .compareTo(b.listName.toLowerCase());
          });
      case _Mode.all:
        visible = publishers.where((p) => p.verified).toList();
      case _Mode.freeText:
        visible = const [];
    }
    // Keep already-selected people visible even if unqualified/unverified.
    final visibleIds = visible.map((p) => p.id).toSet();
    final missing = publishers
        .where((p) => _selected.contains(p.id) && !visibleIds.contains(p.id))
        .toList();
    visible = [...missing, ...visible];

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 420,
        height: 460,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<_Mode>(
              segments: [
                ButtonSegment(
                    value: _Mode.qualified,
                    label: Text(l10n.pickerQualified)),
                ButtonSegment(value: _Mode.all, label: Text(l10n.pickerAll)),
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
                      decoration: InputDecoration(
                          labelText: l10n.pickerFreeText),
                    )
                  : ListView.builder(
                      itemCount: visible.length,
                      itemBuilder: (context, i) {
                        final p = visible[i];
                        final last = history[p.id];
                        return CheckboxListTile(
                          dense: true,
                          value: _selected.contains(p.id),
                          onChanged: (v) => _toggle(p.id, v),
                          title: Text(p.fullName),
                          subtitle: _mode == _Mode.qualified
                              ? Text(last == null
                                  ? l10n.pickerNever
                                  : l10n.pickerLastAssigned(dateFmt
                                      .format(parseDateKey(last))))
                              : null,
                          controlAffinity:
                              ListTileControlAffinity.leading,
                        );
                      },
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
          onPressed: () => Navigator.of(context).pop(Assignment(
            publisherIds: _selected.toList(),
            freeText: _freeText.text.trim(),
          )),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
