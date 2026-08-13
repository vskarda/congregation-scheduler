import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/data/assignment_history.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/assignment_chips.dart';
import '../../core/widgets/assignment_editor.dart';

/// Label of one section of the visit. The terminology comes from the
/// S-61 form (see docs/ADDING-A-LANGUAGE.md); [CoVisitSection.ministry]
/// borrows the name the meetings for field service already carry.
String coSectionLabel(AppLocalizations l10n, CoVisitSection section) =>
    switch (section) {
      CoVisitSection.ministry => l10n.navFieldServiceMeetings,
      CoVisitSection.meal => l10n.coSectionMeal,
      CoVisitSection.shepherding => l10n.coSectionShepherding,
      CoVisitSection.pioneers => l10n.coSectionPioneers,
      CoVisitSection.elders => l10n.coSectionElders,
      CoVisitSection.other => l10n.coSectionOther,
    };

/// Whether a section names publishers. A meeting with the elders or with the
/// pioneers is attended by all of them, so it carries no assignment.
bool coSectionAssigns(CoVisitSection section) =>
    section == CoVisitSection.meal ||
    section == CoVisitSection.shepherding ||
    section == CoVisitSection.other;

/// What [showCoVisitItemDialog] was asked to do with the item.
enum CoVisitItemAction { save, delete }

typedef CoVisitItemResult = ({CoVisitItemAction action, CoVisitItem item});

/// Creates or edits one arrangement of the visit. Nothing is required, so the
/// dialog always saves; an item left completely blank is dropped by the
/// caller ([CoVisitItem.isBlank]).
///
/// The day is picked from the six days of the visit rather than a calendar:
/// a visit runs Tuesday to Sunday, and no other day can be right.
Future<CoVisitItemResult?> showCoVisitItemDialog(
  BuildContext context,
  WidgetRef ref, {
  required String weekId,
  required CoVisitSection section,
  CoVisitItem? existing,
}) async {
  final l10n = context.l10n;
  final monday = parseDateKey(weekId);
  final days = CoVisit.daysOf(monday);
  var item = existing ??
      CoVisitItem(id: const Uuid().v4(), section: section);
  final addressCtrl = TextEditingController(text: item.address);
  final noteCtrl = TextEditingController(text: item.note);

  final action = await showDialog<CoVisitItemAction>(
    context: context,
    builder: (context) {
      final locale = Localizations.localeOf(context).toString();
      final dayFmt = DateFormat.E(locale);
      final dateFmt = DateFormat.MMMd(locale);
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickTime() async {
            final parts = item.time.split(':');
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(
                hour: int.tryParse(parts.isEmpty ? '' : parts[0]) ?? 12,
                minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
              ),
            );
            if (picked == null) return;
            setState(() => item = item.copyWith(
                time: '${picked.hour.toString().padLeft(2, '0')}'
                    ':${picked.minute.toString().padLeft(2, '0')}'));
          }

          Future<void> pickPublishers() async {
            final result = await showAssignmentEditor(
              context,
              title: coSectionLabel(l10n, section),
              initial: item.assignment,
              historyKey: HistoryKeys.coSection(section),
              // Anyone may host a meal or come along on a visit.
              qualifies: (_) => true,
              date: tryParseDateKey(item.date),
            );
            if (result != null) {
              setState(() => item = item.copyWith(assignment: result));
            }
          }

          return AlertDialog(
            title: Text(coSectionLabel(l10n, section)),
            content: SizedBox(
              width: 380,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.coDay,
                        style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      children: [
                        for (final day in days)
                          ChoiceChip(
                            label: Text(
                                '${dayFmt.format(day)}\n${dateFmt.format(day)}',
                                textAlign: TextAlign.center),
                            selected: item.date == dateKey(day),
                            // Tapping the selected day clears it again: a day
                            // is not required.
                            onSelected: (on) => setState(() => item =
                                item.copyWith(date: on ? dateKey(day) : '')),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: Text(l10n.coTime)),
                        if (item.time.isNotEmpty)
                          IconButton(
                            tooltip: l10n.commonClear,
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () =>
                                setState(() => item = item.copyWith(time: '')),
                          ),
                        OutlinedButton.icon(
                          onPressed: pickTime,
                          icon: const Icon(Icons.schedule, size: 18),
                          label: Text(item.time.isEmpty ? '—' : item.time),
                        ),
                      ],
                    ),
                    if (coSectionAssigns(section))
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(l10n.coAssigned),
                        subtitle: AssignmentText(item.assignment),
                        onTap: pickPublishers,
                      ),
                    TextField(
                      controller: addressCtrl,
                      decoration: InputDecoration(labelText: l10n.coAddress),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: noteCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(labelText: l10n.coNote),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              if (existing != null)
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(CoVisitItemAction.delete),
                  child: Text(l10n.commonDelete),
                ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.commonCancel),
              ),
              FilledButton(
                onPressed: () =>
                    Navigator.of(context).pop(CoVisitItemAction.save),
                child: Text(l10n.commonSave),
              ),
            ],
          );
        },
      );
    },
  );

  final result = action == null
      ? null
      : (
          action: action,
          item: item.copyWith(
            address: addressCtrl.text.trim(),
            note: noteCtrl.text.trim(),
          ),
        );
  addressCtrl.dispose();
  noteCtrl.dispose();
  return result;
}
