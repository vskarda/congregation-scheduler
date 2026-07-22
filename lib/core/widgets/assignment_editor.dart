import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/assignment_history.dart';
import '../data/publishers_repository.dart';
import '../l10n/l10n.dart';
import '../models/models.dart';
import '../utils/collation.dart';
import '../utils/dates.dart';

/// Opens the assignment editor dialog. Returns the new [Assignment], or null
/// when cancelled.
///
/// [qualifies] filters the default "qualified" view; [historyKey] selects
/// which history feeds the least-recently-assigned ordering. Admins can
/// always switch to "all publishers" or free text. [applicantIds] (in
/// application order) marks publishers who applied for this assignment;
/// they are pinned to the top of the qualified list with a badge.
///
/// [date] is the calendar date this assignment is for; when given, candidates
/// who declared an away period covering it are flagged with a warning (they
/// stay selectable). Pass null for template/recurring editors that have no
/// single date.
Future<Assignment?> showAssignmentEditor(
  BuildContext context, {
  required String title,
  required Assignment initial,
  required String historyKey,
  required bool Function(Publisher) qualifies,
  bool multi = true,
  List<String> applicantIds = const [],
  DateTime? date,
}) {
  return showDialog<Assignment>(
    context: context,
    builder: (_) => _AssignmentEditorDialog(
      title: title,
      initial: initial,
      historyKey: historyKey,
      qualifies: qualifies,
      multi: multi,
      applicantIds: applicantIds,
      date: date,
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
    required this.applicantIds,
    required this.date,
  });

  final String title;
  final Assignment initial;
  final String historyKey;
  final bool Function(Publisher) qualifies;
  final bool multi;
  final List<String> applicantIds;
  final DateTime? date;

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

    final applicantOrder = {
      for (var i = 0; i < widget.applicantIds.length; i++)
        widget.applicantIds[i]: i,
    };

    List<Publisher> visible;
    switch (_mode) {
      case _Mode.qualified:
        visible = publishers
            .where((p) => p.verified && widget.qualifies(p))
            .toList()
          // Applicants first (in application order), then least recently
          // assigned; never-assigned to the very top.
          ..sort((a, b) {
            final aa = applicantOrder[a.id];
            final ab = applicantOrder[b.id];
            if (aa != null || ab != null) {
              if (aa == null) return 1;
              if (ab == null) return -1;
              return aa.compareTo(ab);
            }
            final da = history[a.id] ?? '';
            final db = history[b.id] ?? '';
            final byDate = da.compareTo(db);
            if (byDate != 0) return byDate;
            return collate(a.listName, b.listName);
          });
      case _Mode.all:
        visible = publishers.where((p) => p.verified).toList();
      case _Mode.freeText:
        visible = const [];
    }
    // Keep already-selected people and applicants visible even if
    // unqualified/unverified.
    final visibleIds = visible.map((p) => p.id).toSet();
    final missing = publishers
        .where((p) =>
            (_selected.contains(p.id) || applicantOrder.containsKey(p.id)) &&
            !visibleIds.contains(p.id))
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
                        final lastLine = _mode == _Mode.qualified
                            ? (last == null
                                ? l10n.pickerNever
                                : l10n.pickerLastAssigned(
                                    dateFmt.format(parseDateKey(last))))
                            : null;
                        return CheckboxListTile(
                          dense: true,
                          value: _selected.contains(p.id),
                          onChanged: (v) => _toggle(p.id, v),
                          title: Text(p.fullName),
                          subtitle: _AwaySubtitle(
                            publisherId: p.id,
                            date: widget.date,
                            dateFmt: dateFmt,
                            lastLine: lastLine,
                          ),
                          secondary: applicantOrder.containsKey(p.id)
                              ? Chip(
                                  label: Text(l10n.pickerApplied),
                                  visualDensity: VisualDensity.compact,
                                )
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

/// Row subtitle showing the "last assigned" line and, when [date] falls inside
/// one of the publisher's declared away periods, a warning line. Kept as its
/// own consumer so each row watches only its own publisher's away doc.
class _AwaySubtitle extends ConsumerWidget {
  const _AwaySubtitle({
    required this.publisherId,
    required this.date,
    required this.dateFmt,
    required this.lastLine,
  });

  final String publisherId;
  final DateTime? date;
  final DateFormat dateFmt;
  final String? lastLine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    AwayPeriod? awayHit;
    if (date != null) {
      final periods =
          ref.watch(publisherAwayProvider(publisherId)).value?.periods ??
              const <AwayPeriod>[];
      for (final p in periods) {
        if (p.includes(date!)) {
          awayHit = p;
          break;
        }
      }
    }

    if (awayHit == null && lastLine == null) return const SizedBox.shrink();

    final error = Theme.of(context).colorScheme.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (lastLine != null) Text(lastLine!),
        if (awayHit != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, size: 14, color: error),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  l10n.pickerAwayWarning(l10n.profileAwayRange(
                    dateFmt.format(parseDateKey(awayHit.startDate)),
                    dateFmt.format(parseDateKey(awayHit.endDate)),
                  )),
                  style: TextStyle(color: error),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
