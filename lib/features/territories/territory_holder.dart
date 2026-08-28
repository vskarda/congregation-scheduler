import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';

/// The name of whoever held a territory: the linked publisher's when the
/// roster still has them, otherwise the free text an admin typed for somebody
/// it cannot name.
///
/// Empty when neither does — a publisher whose record has been deleted takes
/// their name with them, and only the dates of their round are left. Callers
/// that show this to a person want [territoryHolderLabel] or
/// [TerritoryHolderText] instead; this raw form is for searching, sorting and
/// the record sheet, where an invented stand-in would read as a real name.
String territoryHolderName(
  TerritoryAssignment assignment,
  Map<String, Publisher> publishersById,
) {
  final linked = publishersById[assignment.publisherId];
  if (linked != null) return linked.fullName;
  return assignment.freeText;
}

/// [territoryHolderName] with something readable in place of the two cases it
/// leaves empty: an assignment pointing at a deleted record, and one pointing
/// at nobody at all.
///
/// [rosterLoaded] is what keeps the first case honest. Until the publisher
/// stream has emitted, every id in the app looks unresolvable, and a row that
/// briefly reads "deleted" about somebody who is still very much a publisher
/// is worse than a moment of "…".
String territoryHolderLabel(
  BuildContext context,
  TerritoryAssignment assignment,
  Map<String, Publisher> publishersById, {
  required bool rosterLoaded,
}) {
  final name = territoryHolderName(assignment, publishersById);
  if (name.isNotEmpty) return name;
  if (assignment.publisherId.isEmpty) return context.l10n.commonNotAssigned;
  return rosterLoaded ? context.l10n.terrHolderDeleted : '…';
}

/// The holder of a territory assignment, rendered the way the schedules render
/// an [Assignment]: a publisher's name plainly, free text in italics, and a
/// greyed stand-in where there is neither.
class TerritoryHolderText extends ConsumerWidget {
  const TerritoryHolderText(this.assignment, {super.key, this.style});

  final TerritoryAssignment assignment;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final base = style ?? theme.textTheme.bodyMedium!;
    final roster = ref.watch(allPublishersProvider);
    final byId = ref.watch(publishersByIdProvider);

    final linked = byId[assignment.publisherId];
    if (linked != null) return Text(linked.fullName, style: base);
    if (assignment.freeText.trim().isNotEmpty) {
      return Text(assignment.freeText.trim(),
          style: base.copyWith(fontStyle: FontStyle.italic));
    }
    return Text(
      territoryHolderLabel(context, assignment, byId,
          rosterLoaded: roster.hasValue),
      style: base.copyWith(color: theme.disabledColor),
    );
  }
}
