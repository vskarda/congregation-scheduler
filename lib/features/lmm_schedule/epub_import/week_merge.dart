import '../../../core/models/models.dart';

/// Merges a freshly parsed workbook program into an already saved week so a
/// re-import never destroys scheduling work: program content (label, songs,
/// titles, durations, descriptions) comes from [parsed] while part ids,
/// assignments and the support roles are carried over from [existing].
///
/// Parts are matched within their (section, type) group in order, so e.g.
/// the second field-ministry demo keeps the assignment of the previous
/// second field-ministry demo. Manually added custom parts survive at the
/// end of their section. [LmmWeek.allAssigneeIds] is recomputed on save.
LmmWeek mergeParsedWeek(
    {required LmmWeek existing, required LmmWeek parsed}) {
  String groupKey(LmmPart p) => '${p.section.name}/${p.type.name}';

  final existingByGroup = <String, List<LmmPart>>{};
  for (final part in existing.parts) {
    existingByGroup.putIfAbsent(groupKey(part), () => []).add(part);
  }

  final matchedIds = <String>{};
  final groupCounters = <String, int>{};
  final parts = <LmmPart>[];
  for (final part in parsed.parts) {
    final key = groupKey(part);
    final index = groupCounters[key] ?? 0;
    groupCounters[key] = index + 1;
    final candidates = existingByGroup[key];
    if (candidates != null && index < candidates.length) {
      final match = candidates[index];
      matchedIds.add(match.id);
      parts.add(part.copyWith(
        id: match.id,
        assignment: match.assignment,
        assistant: match.assistant,
      ));
    } else {
      parts.add(part);
    }
  }

  for (final custom in existing.parts.where((p) =>
      p.type == LmmPartType.custom && !matchedIds.contains(p.id))) {
    // Insert after the last merged part of the same section, or in global
    // section order when the section is otherwise empty.
    var insertAt = -1;
    for (var i = parts.length - 1; i >= 0; i--) {
      if (parts[i].section == custom.section) {
        insertAt = i + 1;
        break;
      }
    }
    if (insertAt < 0) {
      final order = LmmSection.values.indexOf(custom.section);
      insertAt = parts.indexWhere(
          (p) => LmmSection.values.indexOf(p.section) > order);
      if (insertAt < 0) insertAt = parts.length;
    }
    parts.insert(insertAt, custom);
  }

  return parsed.copyWith(
    parts: parts,
    attendants: existing.attendants,
    microphones: existing.microphones,
    audioVideo: existing.audioVideo,
    customAssignments: existing.customAssignments,
  );
}
