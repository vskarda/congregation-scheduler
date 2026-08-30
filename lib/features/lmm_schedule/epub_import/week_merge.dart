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
///
/// Hand-written content is never overwritten: a part flagged [LmmPart.manual]
/// keeps its own title, description and duration (and survives even when the
/// parsed program has no counterpart for it at all), and a song slot flagged
/// manual on [existing] keeps its number and title. Everything an admin has
/// not touched still refreshes from the workbook.
LmmWeek mergeParsedWeek({required LmmWeek existing, required LmmWeek parsed}) {
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
      final merged = part.copyWith(
        id: match.id,
        assignment: match.assignment,
        assistant: match.assistant,
        assignment2: match.assignment2,
        assistant2: match.assistant2,
        assignment3: match.assignment3,
        assistant3: match.assistant3,
        manual: match.manual,
      );
      parts.add(
        match.manual
            // The admin wrote this part's text themselves; the workbook only
            // gets to say who the slot is for, not what it says.
            ? merged.copyWith(
                title: match.title,
                description: match.description,
                durationMin: match.durationMin,
              )
            : merged,
      );
    } else {
      parts.add(part);
    }
  }

  // Parts the parse has no counterpart for: the ones an admin added or wrote
  // themselves. Custom parts qualify whether or not they carry the flag —
  // they predate it, and a custom part is hand-added by definition.
  for (final custom in existing.parts.where(
    (p) =>
        (p.type == LmmPartType.custom || p.manual) &&
        !matchedIds.contains(p.id),
  )) {
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
        (p) => LmmSection.values.indexOf(p.section) > order,
      );
      if (insertAt < 0) insertAt = parts.length;
    }
    parts.insert(insertAt, custom);
  }

  final merged = parsed.copyWith(
    parts: parts,
    attendants: existing.attendants,
    microphones: existing.microphones,
    audioVideo: existing.audioVideo,
    customAssignments: existing.customAssignments,
    // A rescheduled week (circuit overseer's visit, assembly) keeps its day
    // and time: the workbook says nothing about when the meeting is held.
    meetingWeekday: existing.meetingWeekday,
    meetingTime: existing.meetingTime,
    // Nor does it say which program the week runs: a week switched to the
    // Memorial or to "nothing planned" keeps that, and keeps what belongs to
    // it, while the imported program lands underneath and waits.
    programKind: existing.programKind,
    programNote: existing.programNote,
    memorial: existing.memorial,
  );

  return merged.copyWith(
    openingSongNo: existing.openingSongManual
        ? existing.openingSongNo
        : merged.openingSongNo,
    openingSongTitle: existing.openingSongManual
        ? existing.openingSongTitle
        : merged.openingSongTitle,
    openingSongManual: existing.openingSongManual,
    livingSongNo:
        existing.livingSongManual ? existing.livingSongNo : merged.livingSongNo,
    livingSongTitle: existing.livingSongManual
        ? existing.livingSongTitle
        : merged.livingSongTitle,
    livingSongManual: existing.livingSongManual,
    closingSongNo: existing.closingSongManual
        ? existing.closingSongNo
        : merged.closingSongNo,
    closingSongTitle: existing.closingSongManual
        ? existing.closingSongTitle
        : merged.closingSongTitle,
    closingSongManual: existing.closingSongManual,
  );
}

/// How much of [existing] a re-import of [parsed] would leave untouched:
/// the number of hand-written parts and hand-picked song slots it keeps.
/// Shown in the import preview so nothing about the merge is a surprise.
({int parts, int songs}) protectedByMerge({
  required LmmWeek existing,
  required LmmWeek parsed,
}) {
  final merged = mergeParsedWeek(existing: existing, parsed: parsed);
  return (
    parts: merged.parts.where((p) => p.manual).length,
    songs: [
      existing.openingSongManual,
      existing.livingSongManual,
      existing.closingSongManual,
    ].where((m) => m).length,
  );
}
