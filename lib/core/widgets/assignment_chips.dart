import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/publishers_repository.dart';
import '../firebase/firebase_providers.dart';
import '../models/models.dart';

/// Renders an [Assignment] as names (+ free text), with the current user's
/// own name highlighted on their device.
class AssignmentText extends ConsumerWidget {
  const AssignmentText(this.assignment, {super.key, this.style});

  final Assignment assignment;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final base = style ?? theme.textTheme.bodyMedium!;
    if (assignment.isEmpty) {
      return Text('—',
          style: base.copyWith(color: theme.disabledColor));
    }
    final byId = ref.watch(publishersByIdProvider);
    final myUid = ref.watch(currentUidProvider);

    final spans = <InlineSpan>[];
    for (final id in assignment.publisherIds) {
      if (spans.isNotEmpty) spans.add(TextSpan(text: ', ', style: base));
      final name = byId[id]?.fullName ?? '…';
      final isMe = id == myUid;
      spans.add(TextSpan(
        text: name,
        style: isMe
            ? base.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                backgroundColor:
                    theme.colorScheme.primary.withValues(alpha: 0.12),
              )
            : base,
      ));
    }
    if (assignment.freeText.trim().isNotEmpty) {
      if (spans.isNotEmpty) spans.add(TextSpan(text: ', ', style: base));
      spans.add(TextSpan(
        text: assignment.freeText.trim(),
        style: base.copyWith(fontStyle: FontStyle.italic),
      ));
    }
    return Text.rich(TextSpan(children: spans));
  }
}
