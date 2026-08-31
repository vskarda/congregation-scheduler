import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/assignment_history.dart';
import '../../core/data/congregation_repository.dart';
import '../../core/data/lmm_repository.dart';
import '../../core/data/schedule_config_repository.dart';
import '../../core/data/song_catalog_repository.dart';
import '../../core/l10n/enum_labels.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/numeric_input.dart';
import '../../core/widgets/assignment_chips.dart';
import '../../core/widgets/assignment_editor.dart';
import '../../core/widgets/meeting_week_header.dart';
import '../../core/widgets/program_kind_actions.dart';
import '../../core/widgets/show_to_publishers_switch.dart';
import '../../core/widgets/week_navigator.dart';
import '../attendance/meeting_attendance_card.dart';
import '../memorial/memorial_program_view.dart';
import '../songs/song_editor.dart';
import 'epub_import/import_actions.dart';
import 'epub_import/import_screen.dart';

class LmmScreen extends StatelessWidget {
  const LmmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WeekNavigator(
      headerBuilder: (context, weekId, goTo) => MeetingWeekHeader(
        weekId: weekId,
        kind: MeetingKind.midweek,
        goTo: goTo,
      ),
      contentBuilder: (context, weekId) => LmmWeekView(weekId: weekId),
    );
  }
}

Future<void> saveLmmWeek(WidgetRef ref, LmmWeek week) async {
  await ref.read(lmmRepositoryProvider).saveWeek(week);
  ref.invalidate(assignmentHistoryProvider);
}

/// Selected class in the schedule view (1 = main hall); kept top-level so
/// the selection survives week paging.
class LmmSelectedClassNotifier extends Notifier<int> {
  @override
  int build() => 1;

  void set(int classIndex) => state = classIndex;
}

final lmmSelectedClassProvider =
    NotifierProvider<LmmSelectedClassNotifier, int>(
      LmmSelectedClassNotifier.new,
    );

String lmmClassLabel(AppLocalizations l10n, int classIndex) =>
    classIndex == 1 ? l10n.lmmClassMain : l10n.lmmClassN(classIndex);

/// A ministry-section student part whose workbook title marks it as the
/// "Talk" assignment (EN "Talk", CS "Proslov", TR "Konuşma"). This talk is
/// delivered by a brother to the class, so it has no assistant and only male
/// publishers with the student-assignments qualification are qualified.
///
/// Detection is by title keyword because the imported workbook parts carry no
/// dedicated part type (all ministry student parts are [LmmPartType.fieldMinistry]).
/// Add languages by extending [_talkTitleKeywords].
const _talkTitleKeywords = [
  'talk',
  'proslov',
  'konuşma',
  'discurso',
  'discorso',
  'discours',
  'przemówienie',
  'ansprache',
];

bool isStudentTalk(LmmPart part) {
  if (part.section != LmmSection.ministry) return false;
  final title = part.title.toLowerCase();
  return _talkTitleKeywords.any(title.contains);
}

/// Publisher predicate for a student part's main assignment slot: a Talk needs
/// a qualified brother; any other ministry part keeps the type's default.
bool Function(Publisher) lmmStudentQualifier(LmmPart part) => isStudentTalk(part)
    ? (p) => p.qualifications.fieldMinistry && p.gender == Gender.male
    : (p) => p.qualifications.forLmmPartType(part.type);

String lmmPartDefaultLabel(AppLocalizations l10n, LmmPart part) {
  if (part.title.isNotEmpty) return part.title;
  return switch (part.type) {
    LmmPartType.chairman => l10n.partChairman,
    LmmPartType.prayer =>
      part.section == LmmSection.opening
          ? l10n.partOpeningPrayer
          : l10n.partClosingPrayer,
    LmmPartType.gems => l10n.partGems,
    LmmPartType.bibleReading => l10n.partBibleReading,
    LmmPartType.cbsConductor => l10n.partCbs,
    LmmPartType.cbsReader => l10n.partCbsReader,
    _ => part.title,
  };
}

class LmmWeekView extends ConsumerWidget {
  const LmmWeekView({super.key, required this.weekId});

  final String weekId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final weekAsync = ref.watch(lmmWeekProvider(weekId));
    final roles = ref.watch(effectiveRolesProvider);

    return weekAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l10n.commonErrorDetail(e.toString()))),
      // A week document can exist without a program: planning a circuit
      // overseer's visit writes one just to move the meeting to Tuesday. It
      // deliberately still counts as a week — it renders its meeting day and
      // the attendance card, and a later workbook import merges the program
      // into it (see mergeParsedWeek, which carries the meeting day over).
      // A Memorial week may also be edited by the weekend-schedule admins —
      // the Memorial is one program wherever it falls, so both meeting roles
      // arrange it (firestore.rules grants exactly the same).
      data: (week) => week == null
          ? _EmptyWeekView(
              weekId: weekId,
              canEdit: roles.canEditLmm(),
              canPlanMemorial: canEditProgram(
                roles,
                ScheduleKind.lmm,
                MeetingProgramKind.memorial,
              ),
            )
          : _WeekContent(
              week: week,
              canEdit: canEditProgram(
                roles,
                ScheduleKind.lmm,
                week.programKind,
              ),
              canDelete: roles.canEditLmm(),
            ),
    );
  }
}

class _EmptyWeekView extends ConsumerStatefulWidget {
  const _EmptyWeekView({
    required this.weekId,
    required this.canEdit,
    required this.canPlanMemorial,
  });

  final String weekId;
  final bool canEdit;

  /// The Memorial is arranged by either meeting-schedule role, so a
  /// weekend-schedule admin can start one here even without the midweek
  /// rights the other three buttons need.
  final bool canPlanMemorial;

  static LmmWeek _skeleton(String weekId) {
    const uuid = Uuid();
    LmmPart part(LmmSection s, LmmPartType t, {int? min}) =>
        LmmPart(id: uuid.v4(), section: s, type: t, durationMin: min);
    return LmmWeek(
      id: weekId,
      parts: [
        part(LmmSection.opening, LmmPartType.chairman),
        part(LmmSection.opening, LmmPartType.prayer),
        part(LmmSection.treasures, LmmPartType.treasures, min: 10),
        part(LmmSection.treasures, LmmPartType.gems, min: 10),
        part(LmmSection.treasures, LmmPartType.bibleReading, min: 4),
        part(LmmSection.living, LmmPartType.cbsConductor, min: 30),
        part(LmmSection.living, LmmPartType.cbsReader),
        part(LmmSection.closing, LmmPartType.prayer),
      ],
    );
  }

  @override
  ConsumerState<_EmptyWeekView> createState() => _EmptyWeekViewState();
}

class _EmptyWeekViewState extends ConsumerState<_EmptyWeekView> {
  bool _busy = false;
  String? _error;

  Future<void> _openWeeks(List<LmmWeek>? weeks) async {
    if (weeks == null) return; // cancelled, or nothing published online
    if (weeks.isEmpty) {
      setState(() => _error = context.l10n.importNoWeeks);
      return;
    }
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => EpubImportScreen(weeks: weeks)));
  }

  Future<void> _run(Future<List<LmmWeek>?> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await _openWeeks(await action());
    } catch (e) {
      if (mounted) {
        setState(() => _error = context.l10n.commonErrorDetail(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Imported song number->title catalog, for resolving parsed song numbers.
  Map<int, String>? get _songTitles {
    final titles = ref.read(songCatalogProvider).value?.titles;
    if (titles == null) return null;
    return {for (final e in titles.entries) int.parse(e.key): e.value};
  }

  Future<void> _pickFile() => _run(() => pickEpubWeeks(songTitles: _songTitles));

  Future<void> _checkOnline() => _run(() =>
      fetchCdnWeeks(Localizations.localeOf(context), songTitles: _songTitles));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.weekNoSchedule),
          if (widget.canEdit) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _busy ? null : _pickFile,
              icon: const Icon(Icons.file_open_outlined),
              label: Text(l10n.weekImportEpub),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _busy ? null : _checkOnline,
              icon: const Icon(Icons.cloud_download_outlined),
              label: Text(l10n.weekCheckCdn),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _busy
                  ? null
                  : () => saveLmmWeek(
                      ref,
                      _EmptyWeekView._skeleton(widget.weekId),
                    ),
              icon: const Icon(Icons.add),
              label: Text(l10n.weekCreateEmpty),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _busy
                  ? null
                  : () => saveLmmWeek(
                      ref,
                      LmmWeek(
                        id: widget.weekId,
                        programKind: MeetingProgramKind.nothingPlanned,
                      ),
                    ),
              icon: const Icon(Icons.event_busy_outlined),
              label: Text(l10n.programKindNothingPlanned),
            ),
            if (_busy) ...[
              const SizedBox(height: 16),
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
          // Outside the block above: the Memorial belongs to both meeting
          // schedules, so a weekend-schedule admin may plan one here too.
          if (widget.canPlanMemorial) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _busy
                  ? null
                  : () => saveLmmWeek(
                      ref,
                      LmmWeek(
                        id: widget.weekId,
                        programKind: MeetingProgramKind.memorial,
                        memorial: const MemorialProgram(),
                      ),
                    ),
              icon: const Icon(Icons.wine_bar_outlined),
              label: Text(l10n.programKindMemorial),
            ),
          ],
        ],
      ),
    );
  }
}

class _WeekContent extends ConsumerWidget {
  const _WeekContent({
    required this.week,
    required this.canEdit,
    required this.canDelete,
  });

  final LmmWeek week;
  final bool canEdit;

  /// Deleting the week takes the midweek program with it, so it stays with
  /// the midweek role even when a weekend admin is here for the Memorial.
  final bool canDelete;

  static Color _sectionColor(LmmSection s) => switch (s) {
    LmmSection.treasures => const Color(0xFF2F6B77),
    LmmSection.ministry => const Color(0xFF9C6F19),
    LmmSection.living => const Color(0xFF8E2E33),
    _ => const Color(0xFF5C6BC0),
  };

  String _sectionLabel(AppLocalizations l10n, LmmSection s) =>
      lmmSectionLabel(l10n, s);

  Future<void> _editSong(
    BuildContext context,
    WidgetRef ref, {
    required int? songNo,
    required String songTitle,
    required LmmWeek Function(SongSelection) apply,
  }) async {
    final result = await showSongEditor(context,
        dialogTitle: context.l10n.songLabel,
        songNo: songNo,
        songTitle: songTitle);
    if (result != null) await saveLmmWeek(ref, apply(result));
  }

  /// Switches the week to another program. Nothing is deleted: the parts,
  /// songs and assignments of the program being left stay in the document and
  /// come back with it.
  Future<void> _switchProgram(
    BuildContext context,
    WidgetRef ref,
    MeetingProgramKind kind,
  ) async {
    if (kind != MeetingProgramKind.regular &&
        !await confirmProgramSwitch(context, kind)) {
      return;
    }
    await saveLmmWeek(
      ref,
      week.copyWith(
        programKind: kind,
        // A Memorial switched on for the first time needs its (empty)
        // program; one switched on again keeps what was arranged before.
        memorial: kind == MeetingProgramKind.memorial
            ? week.memorialOrEmpty
            : week.memorial,
      ),
    );
  }

  Future<void> _editNote(BuildContext context, WidgetRef ref) async {
    final note = await showProgramNoteDialog(context, initial: week.programNote);
    if (note != null) await saveLmmWeek(ref, week.copyWith(programNote: note));
  }

  Future<void> _onMenu(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    WeekMenuAction action,
  ) async {
    switch (action) {
      case WeekMenuAction.nothingPlanned:
        await _switchProgram(context, ref, MeetingProgramKind.nothingPlanned);
      case WeekMenuAction.memorial:
        await _switchProgram(context, ref, MeetingProgramKind.memorial);
      case WeekMenuAction.restoreProgram:
        await _switchProgram(context, ref, MeetingProgramKind.regular);
      case WeekMenuAction.editNote:
        await _editNote(context, ref);
      case WeekMenuAction.delete:
        await _confirmDeleteWeek(context, ref, l10n);
    }
  }

  Future<void> _confirmDeleteWeek(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.commonConfirmDeleteTitle),
        content: Text(l10n.commonConfirmDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(lmmRepositoryProvider).deleteWeek(week.id);
      ref.invalidate(assignmentHistoryProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final meta = ref.watch(congregationMetaProvider).value;
    final classCount = (meta?.lmmClassCount ?? 1).clamp(1, 3);
    final classIndex = classCount >= 2
        ? ref.watch(lmmSelectedClassProvider).clamp(1, classCount)
        : 1;
    // Off for this week, a publisher gets the program without the names on
    // it. Always true for the schedule's admins, so it doubles as "this user
    // is a publisher" at the places that drop a name.
    final showNames = ref.watch(
      weekAssigneesVisibleProvider((
        kind: ScheduleKind.lmm,
        weekId: week.id,
      )),
    );

    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (week.weekLabel.isNotEmpty)
                    Text(week.weekLabel, style: theme.textTheme.titleMedium),
                ],
              ),
            ),
            if (canEdit)
              PopupMenuButton<WeekMenuAction>(
                onSelected: (v) => _onMenu(context, ref, l10n, v),
                itemBuilder: (_) => weekMenuItems(l10n, week.programKind,
                    canDelete: canDelete),
              ),
          ],
        ),
      ),
      // Nothing to show or hide on a week with no program and no names.
      if (week.programKind != MeetingProgramKind.nothingPlanned)
        ShowToPublishersSwitch(kind: ScheduleKind.lmm, weekId: week.id),
    ];

    // A week that runs something other than the regular program renders that
    // instead — the parts below stay in the document, dormant, and come back
    // when the week is switched back.
    if (week.programKind == MeetingProgramKind.nothingPlanned) {
      children.add(
        NothingPlannedCard(
          note: week.programNote,
          canEdit: canEdit,
          onEditNote: () => _editNote(context, ref),
        ),
      );
      children.add(const SizedBox(height: 24));
      return ListView(children: children);
    }

    if (week.programKind == MeetingProgramKind.memorial) {
      final memorialDate = meta == null
          ? null
          : meetingDateOf(week.id, week.weekdayOr(meta.lmmWeekday));
      children.add(
        MemorialProgramView(
          program: week.memorialOrEmpty,
          canEdit: canEdit,
          showNames: showNames,
          date: memorialDate,
          onChanged: (m) => saveLmmWeek(ref, week.copyWith(memorial: m)),
        ),
      );
      if (showNames) {
        children.add(
          _SupportCard(week: week, canEdit: canEdit, withMicrophones: false),
        );
      }
      if (memorialDate != null) {
        children.add(
          MeetingAttendanceCard(
            date: memorialDate,
            meetingType: MeetingType.memorial,
          ),
        );
        children.add(
          MemorialAttendanceHistory(excludeDate: dateKey(memorialDate)),
        );
      }
      children.add(const SizedBox(height: 24));
      return ListView(children: children);
    }

    if (classCount >= 2) {
      children.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Center(
            child: SegmentedButton<int>(
              segments: [
                for (var c = 1; c <= classCount; c++)
                  ButtonSegment(value: c, label: Text(lmmClassLabel(l10n, c))),
              ],
              selected: {classIndex},
              onSelectionChanged: (s) =>
                  ref.read(lmmSelectedClassProvider.notifier).set(s.first),
            ),
          ),
        ),
      );
    }

    // A meeting-song row at one of its three fixed positions. Hidden for
    // non-admins when neither number nor title is set.
    //
    // Picking a song by hand pins the slot ([manual]): the next workbook
    // import leaves it alone. The pin is a toggle, so an admin who wants the
    // workbook to take the slot over again can hand it back.
    Widget? songRow({
      required int? songNo,
      required String songTitle,
      required bool manual,
      required LmmWeek Function(SongSelection) apply,
      required LmmWeek Function(bool) setManual,
    }) {
      if (songNo == null && songTitle.isEmpty && !canEdit) return null;
      return ListTile(
        dense: true,
        title: Text(l10n.songLabel),
        subtitle: Text(songDisplayText(songNo, songTitle)),
        onTap: canEdit
            ? () => _editSong(context, ref,
                songNo: songNo, songTitle: songTitle, apply: apply)
            : null,
        trailing: !canEdit
            ? null
            : IconButton(
                tooltip: l10n.keepOnImport,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  manual ? Icons.push_pin : Icons.push_pin_outlined,
                  size: 18,
                  color: manual
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                ),
                onPressed: () => saveLmmWeek(ref, setManual(!manual)),
              ),
      );
    }

    for (final section in LmmSection.values) {
      // Opening song sits above the TREASURES heading (the example S-140 form
      // places it between the opening prayer and the first section), shown
      // even when Treasures itself is otherwise empty.
      if (section == LmmSection.treasures) {
        final row = songRow(
          songNo: week.openingSongNo,
          songTitle: week.openingSongTitle,
          manual: week.openingSongManual,
          apply: (s) => week.copyWith(
            openingSongNo: s.songNo,
            openingSongTitle: s.title,
            openingSongManual: true,
          ),
          setManual: (m) => week.copyWith(openingSongManual: m),
        );
        if (row != null) children.add(row);
      }

      final parts = week.parts.where((p) => p.section == section).toList();
      // Non-admins don't need empty sections; admins get them with an
      // add-part button.
      if (parts.isEmpty && !canEdit) continue;
      children.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _sectionLabel(l10n, section),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: _sectionColor(section),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (canEdit)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: l10n.partAdd,
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: () => _addPart(context, ref, section),
                ),
            ],
          ),
        ),
      );
      // The Living song sits right below the LIVING AS CHRISTIANS heading, the
      // closing song right below the Conclusion heading.
      if (section == LmmSection.living) {
        final row = songRow(
          songNo: week.livingSongNo,
          songTitle: week.livingSongTitle,
          manual: week.livingSongManual,
          apply: (s) => week.copyWith(
            livingSongNo: s.songNo,
            livingSongTitle: s.title,
            livingSongManual: true,
          ),
          setManual: (m) => week.copyWith(livingSongManual: m),
        );
        if (row != null) children.add(row);
      } else if (section == LmmSection.closing) {
        final row = songRow(
          songNo: week.closingSongNo,
          songTitle: week.closingSongTitle,
          manual: week.closingSongManual,
          apply: (s) => week.copyWith(
            closingSongNo: s.songNo,
            closingSongTitle: s.title,
            closingSongManual: true,
          ),
          setManual: (m) => week.copyWith(closingSongManual: m),
        );
        if (row != null) children.add(row);
      }
      for (final part in parts) {
        children.add(
          _PartTile(
            week: week,
            part: part,
            canEdit: canEdit,
            classIndex: classIndex,
            showNames: showNames,
          ),
        );
      }
    }

    // Nothing but names: it has no program of its own to show a publisher.
    if (showNames) children.add(_SupportCard(week: week, canEdit: canEdit));

    // Attendance is recorded against the meeting date this week's schedule is
    // for. Without meta the weekday is unknown, and guessing it would write
    // the count under the wrong document id.
    final meetingDate = meta == null
        ? null
        : meetingDateOf(week.id, week.weekdayOr(meta.lmmWeekday));
    if (meetingDate != null) {
      children.add(
        MeetingAttendanceCard(
          date: meetingDate,
          meetingType: MeetingType.lmm,
        ),
      );
    }

    children.add(const SizedBox(height: 24));

    return ListView(children: children);
  }

  Future<void> _addPart(
    BuildContext context,
    WidgetRef ref,
    LmmSection section,
  ) async {
    final part = await showLmmPartDialog(context, section: section);
    if (part == null) return;
    // Insert after the last existing part of the same section.
    final parts = [...week.parts];
    var insertAt = parts.length;
    for (var i = parts.length - 1; i >= 0; i--) {
      if (parts[i].section == section) {
        insertAt = i + 1;
        break;
      }
    }
    if (insertAt == parts.length && parts.every((p) => p.section != section)) {
      // No part of this section yet: keep global section order.
      final order = LmmSection.values.indexOf(section);
      insertAt = parts.indexWhere(
        (p) => LmmSection.values.indexOf(p.section) > order,
      );
      if (insertAt < 0) insertAt = parts.length;
    }
    parts.insert(insertAt, part);
    await saveLmmWeek(ref, week.copyWith(parts: parts));
  }
}

/// Dialog for creating/editing a part (title, duration, type for new parts).
///
/// Typing into the title or the description switches "keep on import" on: the
/// text is now the admin's, and a workbook re-import must not overwrite it
/// (see [LmmPart.manual] and `mergeParsedWeek`). The switch stays visible and
/// reversible, so a part can be handed back to the workbook.
Future<LmmPart?> showLmmPartDialog(
  BuildContext context, {
  LmmPart? existing,
  LmmSection? section,
}) =>
    showDialog<LmmPart>(
      context: context,
      builder: (_) => _LmmPartDialog(existing: existing, section: section),
    );

/// A widget rather than a `StatefulBuilder` inside `showDialog` so its three
/// text controllers are disposed with it. `showDialog`'s future completes the
/// moment the route is popped, while the dialog is still animating out — so
/// disposing them after the await leaves the fading dialog holding
/// controllers that are already gone.
class _LmmPartDialog extends StatefulWidget {
  const _LmmPartDialog({this.existing, this.section});

  final LmmPart? existing;
  final LmmSection? section;

  @override
  State<_LmmPartDialog> createState() => _LmmPartDialogState();
}

class _LmmPartDialogState extends State<_LmmPartDialog> {
  late final _titleCtrl = TextEditingController(
    text: widget.existing?.title ?? '',
  );
  late final _descriptionCtrl = TextEditingController(
    text: widget.existing?.description ?? '',
  );
  late final _durationCtrl = TextEditingController(
    text: widget.existing?.durationMin?.toString() ?? '',
  );

  /// A part added by hand is the admin's from the start.
  late bool _manual = widget.existing?.manual ?? true;

  late LmmPartType _type =
      widget.existing?.type ??
      switch (widget.section) {
        LmmSection.ministry => LmmPartType.fieldMinistry,
        LmmSection.living => LmmPartType.living,
        LmmSection.treasures => LmmPartType.treasures,
        _ => LmmPartType.custom,
      };

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  /// The admin has made the text their own; protect it from the next import.
  void _markManual() {
    if (!_manual) setState(() => _manual = true);
  }

  void _save() {
    final base =
        widget.existing ??
        LmmPart(
          id: const Uuid().v4(),
          section: widget.section ?? LmmSection.living,
          type: _type,
        );
    Navigator.of(context).pop(
      base.copyWith(
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        durationMin: int.tryParse(_durationCtrl.text.trim()),
        manual: _manual,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(widget.existing == null ? l10n.partAdd : l10n.partEdit),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.existing == null)
              DropdownButtonFormField<LmmPartType>(
                initialValue: _type,
                decoration: InputDecoration(labelText: l10n.partEdit),
                items: [
                  for (final t in LmmPartType.values)
                    DropdownMenuItem(value: t, child: Text(t.name)),
                ],
                onChanged: (t) =>
                    setState(() => _type = t ?? LmmPartType.custom),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleCtrl,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.partTitle),
              onChanged: (_) => _markManual(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionCtrl,
              decoration: InputDecoration(labelText: l10n.partDescription),
              onChanged: (_) => _markManual(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _durationCtrl,
              keyboardType: numericKeyboardType,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(labelText: l10n.partDuration),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _manual,
              onChanged: (v) => setState(() => _manual = v),
              title: Text(l10n.keepOnImport),
              subtitle: Text(l10n.keepOnImportHint),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(onPressed: _save, child: Text(l10n.commonSave)),
      ],
    );
  }
}

class _PartTile extends ConsumerWidget {
  const _PartTile({
    required this.week,
    required this.part,
    required this.canEdit,
    required this.classIndex,
    required this.showNames,
  });

  final LmmWeek week;
  final LmmPart part;
  final bool canEdit;

  /// False for a publisher on a week switched off: the part still renders,
  /// its assignee and assistant lines do not.
  final bool showNames;

  /// Class selected in the schedule view; only student parts store separate
  /// assignments per class (see [_effectiveClass]).
  final int classIndex;

  int get _effectiveClass => part.isStudentPart ? classIndex : 1;

  Future<void> _assign(
    BuildContext context,
    WidgetRef ref, {
    required bool assistant,
  }) async {
    final l10n = context.l10n;
    final classIndex = _effectiveClass;
    var label = lmmPartDefaultLabel(l10n, part);
    if (assistant) label = '${l10n.partAssistant} — $label';
    if (classIndex > 1) label = '$label — ${lmmClassLabel(l10n, classIndex)}';
    final meta = ref.read(congregationMetaProvider).value;
    final result = await showAssignmentEditor(
      context,
      title: label,
      initial: assistant
          ? part.assistantFor(classIndex)
          : part.assignmentFor(classIndex),
      historyKey: assistant
          ? HistoryKeys.lmmAssistant
          : HistoryKeys.lmmPart(part.type),
      qualifies: assistant
          ? (p) => p.qualifications.fieldMinistry
          : lmmStudentQualifier(part),
      date: meta == null
          ? null
          : meetingDateOf(week.id, week.weekdayOr(meta.lmmWeekday)),
    );
    if (result == null) return;
    final updated = assistant
        ? part.withAssistantFor(classIndex, result)
        : part.withAssignmentFor(classIndex, result);
    await _saveVariant(ref, updated);
  }

  Future<void> _saveVariant(WidgetRef ref, LmmPart updated) async {
    final parts = week.parts
        .map((p) => p.id == updated.id ? updated : p)
        .toList();
    await saveLmmWeek(ref, week.copyWith(parts: parts));
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.commonConfirmDeleteTitle),
        content: Text(l10n.partDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await saveLmmWeek(
        ref,
        week.copyWith(parts: week.parts.where((p) => p.id != part.id).toList()),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isMinistryPart = part.type == LmmPartType.fieldMinistry;
    // Talks are given by a single brother to the class, so they take no
    // assistant (student demonstrations do).
    final hasAssistant = isMinistryPart && !isStudentTalk(part);
    final assignment = part.assignmentFor(_effectiveClass);
    final assistantAssignment = part.assistantFor(_effectiveClass);
    final showAssistant = showNames &&
        hasAssistant &&
        (canEdit || assistantAssignment.isNotEmpty);

    return ListTile(
      dense: true,
      title: Row(
        children: [
          Flexible(child: Text(lmmPartDefaultLabel(l10n, part))),
          // Pinned: the workbook import will not overwrite this part's text.
          if (part.manual && canEdit) ...[
            const SizedBox(width: 6),
            Tooltip(
              message: l10n.keepOnImport,
              child: Icon(Icons.push_pin,
                  size: 13, color: theme.colorScheme.outline),
            ),
          ],
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (part.description.isNotEmpty)
            Text(
              part.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          if (showNames) AssignmentText(assignment),
          if (showAssistant)
            // Tapping the assistant line assigns the assistant directly, so
            // admins don't have to open the overflow menu first.
            InkWell(
              onTap: canEdit
                  ? () => _assign(context, ref, assistant: true)
                  : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${l10n.partAssistant}: ',
                    style: theme.textTheme.bodySmall,
                  ),
                  Flexible(
                    child: AssignmentText(
                      assistantAssignment,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      leading: SizedBox(
        width: 48,
        child: Text(
          part.durationMin == null ? '' : l10n.partMinutes(part.durationMin!),
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.right,
        ),
      ),
      trailing: canEdit
          ? PopupMenuButton<String>(
              onSelected: (v) async {
                switch (v) {
                  case 'assign':
                    await _assign(context, ref, assistant: false);
                  case 'assistant':
                    await _assign(context, ref, assistant: true);
                  case 'edit':
                    final edited = await showLmmPartDialog(
                      context,
                      existing: part,
                    );
                    if (edited != null) await _saveVariant(ref, edited);
                  case 'delete':
                    await _delete(context, ref);
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'assign', child: Text(l10n.commonEdit)),
                if (hasAssistant)
                  PopupMenuItem(
                    value: 'assistant',
                    child: Text(l10n.partAssistant),
                  ),
                PopupMenuItem(value: 'edit', child: Text(l10n.partEdit)),
                PopupMenuItem(value: 'delete', child: Text(l10n.commonDelete)),
              ],
            )
          : null,
      onTap: canEdit ? () => _assign(context, ref, assistant: false) : null,
    );
  }
}

/// Attendants / microphones / audio-video / custom assignments; shared by
/// design with the weekend meeting via [SupportAssignmentsCard].
class _SupportCard extends ConsumerWidget {
  const _SupportCard({
    required this.week,
    required this.canEdit,
    this.withMicrophones = true,
  });

  final LmmWeek week;
  final bool canEdit;

  /// The Memorial arranges attendants and audio/video and nothing else.
  final bool withMicrophones;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permanent =
        ref.watch(lmmPermanentAssignmentsProvider).value ?? const [];
    final configRepo = ref.read(scheduleConfigRepositoryProvider);
    final meta = ref.watch(congregationMetaProvider).value;
    return SupportAssignmentsCard(
      canEdit: canEdit,
      date: meta == null
          ? null
          : meetingDateOf(week.id, week.weekdayOr(meta.lmmWeekday)),
      attendants: week.attendants,
      microphones: withMicrophones ? week.microphones : null,
      audioVideo: week.audioVideo,
      customAssignments: week.customAssignments,
      permanentAssignments: permanent,
      onAddPermanent: (template) => configRepo.saveConfig(
        ScheduleConfigDoc.lmm,
        ScheduleConfig(permanentAssignments: [...permanent, template]),
      ),
      onRemovePermanent: (id) => configRepo.saveConfig(
        ScheduleConfigDoc.lmm,
        ScheduleConfig(
          permanentAssignments:
              permanent.where((c) => c.id != id).toList(),
        ),
      ),
      onChanged: ({attendants, microphones, audioVideo, customAssignments}) =>
          saveLmmWeek(
            ref,
            week.copyWith(
              attendants: attendants ?? week.attendants,
              microphones: microphones ?? week.microphones,
              audioVideo: audioVideo ?? week.audioVideo,
              customAssignments: customAssignments ?? week.customAssignments,
            ),
          ),
    );
  }
}

/// Reusable support-assignments block (also used by the weekend schedule).
class SupportAssignmentsCard extends ConsumerWidget {
  const SupportAssignmentsCard({
    super.key,
    required this.canEdit,
    required this.attendants,
    this.microphones,
    required this.audioVideo,
    required this.customAssignments,
    required this.onChanged,
    this.permanentAssignments = const [],
    this.onAddPermanent,
    this.onRemovePermanent,
    this.date,
  });

  /// Meeting date these support slots are for; forwarded to the picker so it
  /// can flag away publishers. Null when unknown (no warning shown).
  final DateTime? date;

  final bool canEdit;
  final Assignment attendants;

  /// Null hides the row: the Memorial arranges attendants and audio/video
  /// only.
  final Assignment? microphones;
  final Assignment audioVideo;
  final List<CustomAssignment> customAssignments;
  final Future<void> Function({
    Assignment? attendants,
    Assignment? microphones,
    Assignment? audioVideo,
    List<CustomAssignment>? customAssignments,
  })
  onChanged;

  /// Congregation-level custom assignments that recur on every week (id +
  /// label only; the assignee is stored per-week in [customAssignments],
  /// matched by [CustomAssignment.id]).
  final List<CustomAssignment> permanentAssignments;

  /// Adds a permanent definition (congregation-level). Required to offer the
  /// "Permanent" option in the add dialog.
  final Future<void> Function(CustomAssignment template)? onAddPermanent;

  /// Removes a permanent definition (congregation-level) by id.
  final Future<void> Function(String id)? onRemovePermanent;

  Future<void> _edit(
    BuildContext context, {
    required String title,
    required Assignment initial,
    required String historyKey,
    required bool Function(Publisher) qualifies,
    required Future<void> Function(Assignment) save,
  }) async {
    final result = await showAssignmentEditor(
      context,
      title: title,
      initial: initial,
      historyKey: historyKey,
      qualifies: qualifies,
      date: date,
    );
    if (result != null) await save(result);
  }

  /// Stores/updates this week's assignee for a permanent slot, matched by id.
  Future<void> _savePermanentAssignee(
    CustomAssignment template,
    Assignment a,
  ) {
    final updated = [...customAssignments];
    final idx = updated.indexWhere((c) => c.id == template.id);
    final entry = CustomAssignment(
      id: template.id,
      label: template.label,
      assignment: a,
    );
    if (idx >= 0) {
      updated[idx] = entry;
    } else {
      updated.add(entry);
    }
    return onChanged(customAssignments: updated);
  }

  Future<void> _confirmRemovePermanent(
    BuildContext context,
    CustomAssignment template,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.customAssignmentRemovePermanentTitle),
        content: Text(l10n.customAssignmentRemovePermanentBody(template.label)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) await onRemovePermanent?.call(template.id);
  }

  Future<void> _addCustom(BuildContext context) async {
    final l10n = context.l10n;
    final ctrl = TextEditingController();
    final canMakePermanent = onAddPermanent != null;
    var permanent = false;
    final result = await showDialog<({String label, bool permanent})>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.customAssignmentAdd),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl,
                autofocus: true,
                decoration: InputDecoration(labelText: l10n.customLabel),
              ),
              if (canMakePermanent)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: permanent,
                  onChanged: (v) => setState(() => permanent = v),
                  title: Text(l10n.customAssignmentPermanent),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(
                context,
              ).pop((label: ctrl.text.trim(), permanent: permanent)),
              child: Text(l10n.commonAdd),
            ),
          ],
        ),
      ),
    );
    ctrl.dispose();
    if (result == null || result.label.isEmpty) return;
    if (result.permanent) {
      await onAddPermanent?.call(
        CustomAssignment(id: const Uuid().v4(), label: result.label),
      );
    } else {
      await onChanged(
        customAssignments: [
          ...customAssignments,
          CustomAssignment(label: result.label),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    Widget row({
      required String label,
      required Assignment assignment,
      required VoidCallback? onTap,
      VoidCallback? onDelete,
      bool permanent = false,
    }) => ListTile(
      dense: true,
      title: Row(
        children: [
          if (permanent) ...[
            Icon(
              Icons.push_pin_outlined,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
          ],
          Flexible(child: Text(label)),
        ],
      ),
      subtitle: AssignmentText(assignment),
      onTap: onTap,
      trailing: onDelete != null
          ? IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              onPressed: onDelete,
            )
          : null,
    );

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row(
            label: l10n.supportAttendants,
            assignment: attendants,
            onTap: !canEdit
                ? null
                : () => _edit(
                    context,
                    title: l10n.supportAttendants,
                    initial: attendants,
                    historyKey: HistoryKeys.attendant,
                    qualifies: (p) => p.qualifications.attendant,
                    save: (a) => onChanged(attendants: a),
                  ),
          ),
          if (microphones != null)
            row(
              label: l10n.supportMicrophones,
              assignment: microphones!,
              onTap: !canEdit
                  ? null
                  : () => _edit(
                      context,
                      title: l10n.supportMicrophones,
                      initial: microphones!,
                      historyKey: HistoryKeys.microphone,
                      qualifies: (p) => p.qualifications.microphone,
                      save: (a) => onChanged(microphones: a),
                    ),
            ),
          row(
            label: l10n.supportAudioVideo,
            assignment: audioVideo,
            onTap: !canEdit
                ? null
                : () => _edit(
                    context,
                    title: l10n.supportAudioVideo,
                    initial: audioVideo,
                    historyKey: HistoryKeys.audioVideo,
                    qualifies: (p) => p.qualifications.audioVideo,
                    save: (a) => onChanged(audioVideo: a),
                  ),
          ),
          // Permanent (every-week) custom assignments: label from the
          // congregation config, assignee merged in from this week by id.
          for (final template in permanentAssignments)
            () {
              final assignment = customAssignments
                  .firstWhere(
                    (c) => c.id == template.id,
                    orElse: () => CustomAssignment(id: template.id),
                  )
                  .assignment;
              return row(
                label: template.label,
                assignment: assignment,
                permanent: true,
                onTap: !canEdit
                    ? null
                    : () => _edit(
                        context,
                        title: template.label,
                        initial: assignment,
                        historyKey: HistoryKeys.custom,
                        qualifies: (_) => true,
                        save: (a) => _savePermanentAssignee(template, a),
                      ),
                onDelete: !canEdit || onRemovePermanent == null
                    ? null
                    : () => _confirmRemovePermanent(context, template),
              );
            }(),
          // One-off custom assignments (this week only): id is empty.
          for (var i = 0; i < customAssignments.length; i++)
            if (customAssignments[i].id.isEmpty)
              row(
                label: customAssignments[i].label,
                assignment: customAssignments[i].assignment,
                onTap: !canEdit
                    ? null
                    : () => _edit(
                        context,
                        title: customAssignments[i].label,
                        initial: customAssignments[i].assignment,
                        historyKey: HistoryKeys.custom,
                        qualifies: (_) => true,
                        save: (a) {
                          final updated = [...customAssignments];
                          updated[i] = updated[i].copyWith(assignment: a);
                          return onChanged(customAssignments: updated);
                        },
                      ),
                onDelete: !canEdit
                    ? null
                    : () {
                        final updated = [...customAssignments]..removeAt(i);
                        onChanged(customAssignments: updated);
                      },
              ),
          if (canEdit)
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton.icon(
                onPressed: () => _addCustom(context),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.customAssignmentAdd),
              ),
            ),
        ],
      ),
    );
  }
}
