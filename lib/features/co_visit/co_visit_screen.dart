import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/assignment_history.dart';
import '../../core/data/co_visit_repository.dart';
import '../../core/data/congregation_repository.dart';
import '../../core/data/lmm_repository.dart';
import '../../core/data/schedule_config_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/assignment_chips.dart';
import '../../core/widgets/meeting_week_override.dart';
import '../field_service_meetings/fsm_screen.dart';
import 'co_visit_item_dialog.dart';
import 'co_visit_service.dart';

/// Visit the view is showing, or null to fall back to
/// [defaultCoVisitWeekId]. Kept outside the screen so the app-bar print
/// action knows which visit is on screen.
class SelectedCoVisitNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? weekId) => state = weekId;
}

final selectedCoVisitProvider =
    NotifierProvider<SelectedCoVisitNotifier, String?>(
        SelectedCoVisitNotifier.new);

/// The visit actually on screen: the one picked, else the next upcoming one.
final shownCoVisitProvider = Provider<String?>((ref) {
  final selected = ref.watch(selectedCoVisitProvider);
  final visits = ref.watch(coVisitsProvider).value ?? const <CoVisit>[];
  if (selected != null && visits.any((v) => v.id == selected)) return selected;
  return defaultCoVisitWeekId(visits);
});

/// Whether the circuit overseer view is offered to this user at all: its
/// admins always, everyone else once an admin has published it.
final coVisitVisibleProvider = Provider<bool>((ref) =>
    ref.watch(effectiveRolesProvider).canEditEvents() ||
    (ref.watch(coVisitConfigProvider).value ?? const CoVisitConfig())
        .visibleToPublishers);

/// Formats a visit's Tuesday-to-Sunday range.
String coVisitRangeLabel(String locale, String weekId) {
  final monday = parseDateKey(weekId);
  final fmt = DateFormat.MMMd(locale);
  final start = CoVisit.startOf(monday);
  final end = CoVisit.endOf(monday);
  return '${fmt.format(start)} – ${fmt.format(end)}, ${end.year}';
}

/// Everything arranged for a circuit overseer's visit, in one place.
///
/// Two of the six sections are not this view's to write. The meetings for
/// field service belong to `fieldServiceMeetings` and the midweek meeting day
/// to `lmmSchedule`, so an events-admin without those rights sees them, and
/// is told who edits them, rather than meeting a denied write.
class CoVisitScreen extends ConsumerWidget {
  const CoVisitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final roles = ref.watch(effectiveRolesProvider);
    final canPlan = roles.canEditEvents();

    if (!ref.watch(coVisitVisibleProvider)) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(l10n.coVisitNotPublished, textAlign: TextAlign.center),
        ),
      );
    }

    final visitsAsync = ref.watch(coVisitsProvider);
    return visitsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l10n.commonErrorDetail(e.toString()))),
      data: (visits) {
        final weekId = ref.watch(shownCoVisitProvider);
        return Column(
          children: [
            _VisitHeader(visits: visits, weekId: weekId, canPlan: canPlan),
            const Divider(height: 1),
            Expanded(
              child: weekId == null
                  ? Center(child: Text(l10n.coVisitNonePlanned))
                  : _VisitBody(weekId: weekId, canPlan: canPlan),
            ),
          ],
        );
      },
    );
  }
}

/// Visit picker plus the admin actions on the visit as a whole.
class _VisitHeader extends ConsumerWidget {
  const _VisitHeader({
    required this.visits,
    required this.weekId,
    required this.canPlan,
  });

  final List<CoVisit> visits;
  final String? weekId;
  final bool canPlan;

  Future<void> _pickWeek(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final meta = ref.read(congregationMetaProvider).value;
    final canEditLmm = ref.read(effectiveRolesProvider).canEditLmm();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 3),
      helpText: l10n.coVisitSetWeek,
    );
    if (picked == null) return;
    final newWeekId = weekIdOf(picked);
    if (visits.any((v) => v.id == newWeekId)) {
      ref.read(selectedCoVisitProvider.notifier).set(newWeekId);
      return;
    }
    final skipped = await createCoVisit(
      ref,
      newWeekId,
      meta: meta ?? const CongregationMeta(),
      canEditLmm: canEditLmm,
    );
    ref.read(selectedCoVisitProvider.notifier).set(newWeekId);
    if (skipped.contains(CoVisitSideEffect.midweekMeetingNotMoved)) {
      messenger.showSnackBar(
          SnackBar(content: Text(l10n.coMidweekNotMoved)));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.commonConfirmDeleteTitle),
        content: Text(l10n.coVisitDeleteConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel)),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.commonDelete)),
        ],
      ),
    );
    if (confirmed != true) return;
    await deleteCoVisit(
      ref,
      weekId!,
      canEditLmm: ref.read(effectiveRolesProvider).canEditLmm(),
    );
    ref.read(selectedCoVisitProvider.notifier).set(null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final config =
        ref.watch(coVisitConfigProvider).value ?? const CoVisitConfig();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: visits.isEmpty
                    ? Text(l10n.coVisitNonePlanned)
                    : DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: weekId,
                          items: [
                            for (final visit in visits)
                              DropdownMenuItem(
                                value: visit.id,
                                child: Text(
                                    coVisitRangeLabel(locale, visit.id)),
                              ),
                          ],
                          onChanged: (id) =>
                              ref.read(selectedCoVisitProvider.notifier).set(id),
                        ),
                      ),
              ),
              if (canPlan)
                IconButton(
                  tooltip: l10n.coVisitSetWeek,
                  icon: const Icon(Icons.event_available_outlined),
                  onPressed: () => _pickWeek(context, ref),
                ),
              if (canPlan && weekId != null)
                IconButton(
                  tooltip: l10n.coVisitDelete,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _delete(context, ref),
                ),
            ],
          ),
          if (canPlan)
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: config.visibleToPublishers,
              title: Text(l10n.coVisitVisibleToPublishers),
              subtitle: Text(config.visibleToPublishers
                  ? l10n.coVisitVisibleOn
                  : l10n.coVisitVisibleOff),
              onChanged: (on) => ref
                  .read(scheduleConfigRepositoryProvider)
                  .saveCoVisitConfig(CoVisitConfig(visibleToPublishers: on)),
            ),
        ],
      ),
    );
  }
}

class _VisitBody extends ConsumerWidget {
  const _VisitBody({required this.weekId, required this.canPlan});

  final String weekId;
  final bool canPlan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visit = ref.watch(coVisitProvider(weekId)).value ?? CoVisit(id: weekId);
    final roles = ref.watch(effectiveRolesProvider);
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        _MidweekMeetingCard(weekId: weekId, canPlan: canPlan),
        for (final section in CoVisitSection.values)
          if (canPlan || !visit.isHidden(section))
            _SectionCard(
              visit: visit,
              section: section,
              canPlan: canPlan,
              canEditMinistry: roles.canEditFieldServiceMeetings(),
            ),
      ],
    );
  }
}

/// The week's midweek meeting day — moved to Tuesday when the visit was
/// planned. Editable only by midweek-schedule admins, who may be different
/// people from the ones planning the visit.
class _MidweekMeetingCard extends ConsumerWidget {
  const _MidweekMeetingCard({required this.weekId, required this.canPlan});

  final String weekId;
  final bool canPlan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final meta = ref.watch(congregationMetaProvider).value;
    if (meta == null) return const SizedBox.shrink();
    final week = ref.watch(lmmWeekProvider(weekId)).value;
    final canEditLmm = ref.watch(effectiveRolesProvider).canEditLmm();

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(l10n.settingsLmmMeeting,
                style: Theme.of(context).textTheme.labelLarge),
          ),
          MeetingWeekTile(
            weekday: week?.weekdayOr(meta.lmmWeekday) ?? meta.lmmWeekday,
            time: week?.timeOr(meta.lmmTime) ?? meta.lmmTime,
            isOverridden: week?.hasMeetingOverride ?? false,
            canEdit: canEditLmm,
            onTap: () => _edit(context, ref, meta, week),
          ),
          if (canPlan && !canEditLmm)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(l10n.coMidweekOtherAdmins,
                  style: Theme.of(context).textTheme.bodySmall),
            ),
        ],
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    CongregationMeta meta,
    LmmWeek? week,
  ) async {
    final result = await showMeetingWeekOverrideDialog(
      context,
      title: context.l10n.settingsLmmMeeting,
      current: (weekday: week?.meetingWeekday, time: week?.meetingTime),
      defaultWeekday: meta.lmmWeekday,
      defaultTime: meta.lmmTime,
    );
    if (result == null) return;
    await ref.read(lmmRepositoryProvider).saveWeek(
          (week ?? LmmWeek(id: weekId))
              .copyWith(meetingWeekday: result.weekday, meetingTime: result.time),
        );
  }
}

/// One section of the visit: its rows plus, for admins, an add button and the
/// eye that hides it from publishers.
class _SectionCard extends ConsumerWidget {
  const _SectionCard({
    required this.visit,
    required this.section,
    required this.canPlan,
    required this.canEditMinistry,
  });

  final CoVisit visit;
  final CoVisitSection section;
  final bool canPlan;
  final bool canEditMinistry;

  /// Meetings for field service are edited under their own role; everything
  /// else in the visit under `events`.
  bool get _canEdit =>
      section == CoVisitSection.ministry ? canEditMinistry : canPlan;

  Future<void> _addOrEdit(
    BuildContext context,
    WidgetRef ref, {
    CoVisitItem? existing,
  }) async {
    final result = await showCoVisitItemDialog(
      context,
      ref,
      weekId: visit.id,
      section: section,
      existing: existing,
    );
    if (result == null) return;
    final updated = result.action == CoVisitItemAction.delete ||
            result.item.isBlank
        ? visit.withoutItem(result.item.id)
        : visit.withItem(result.item);
    await ref.read(coVisitRepositoryProvider).save(updated);
    ref.invalidate(assignmentHistoryProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final hidden = visit.isHidden(section);

    return Opacity(
      // Hidden sections only ever render for admins, greyed so it is obvious
      // that publishers are not seeing them.
      opacity: hidden ? 0.55 : 1,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 4, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(coSectionLabel(l10n, section),
                        style: theme.textTheme.labelLarge),
                  ),
                  if (hidden)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(l10n.coSectionHidden,
                          style: theme.textTheme.labelSmall),
                    ),
                  if (canPlan)
                    IconButton(
                      tooltip: hidden ? l10n.coSectionShow : l10n.coSectionHide,
                      icon: Icon(
                          hidden
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20),
                      onPressed: () => ref
                          .read(coVisitRepositoryProvider)
                          .save(visit.withSectionHidden(section, !hidden)),
                    ),
                  if (_canEdit)
                    IconButton(
                      tooltip: l10n.commonAdd,
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: section == CoVisitSection.ministry
                          ? () => showFsmMeetingDialog(context, ref,
                              initialDate:
                                  dateKey(CoVisit.startOf(parseDateKey(visit.id))))
                          : () => _addOrEdit(context, ref),
                    ),
                ],
              ),
            ),
            if (section == CoVisitSection.ministry)
              _MinistryRows(weekId: visit.id, canEdit: canEditMinistry)
            else
              ..._itemRows(context, ref),
            // Said only to the people planning the visit: a publisher has no
            // use for who may edit what.
            if (canPlan && section == CoVisitSection.ministry && !canEditMinistry)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(l10n.coMinistryOtherAdmins,
                    style: theme.textTheme.bodySmall),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _itemRows(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final items = visit.itemsOf(section);
    if (items.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Text(l10n.coSectionEmpty,
              style: Theme.of(context).textTheme.bodySmall),
        ),
      ];
    }
    return [
      for (final item in items)
        _ItemTile(
          item: item,
          showAssignment: coSectionAssigns(section),
          onTap: _canEdit
              ? () => _addOrEdit(context, ref, existing: item)
              : null,
        ),
    ];
  }
}

/// One arrangement: day and time on the left, what and who on the right.
class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.item,
    required this.showAssignment,
    required this.onTap,
  });

  final CoVisitItem item;
  final bool showAssignment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final day = tryParseDateKey(item.date);
    // Time joins the address on the title line; the leading block stays two
    // lines, which is all a dense tile has room for.
    final title = [
      if (item.time.isNotEmpty) item.time,
      if (item.address.isNotEmpty) item.address,
    ].join('  ·  ');

    return ListTile(
      dense: true,
      leading: _DayBlock(day: day, locale: locale),
      title: title.isEmpty ? null : Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAssignment && item.assignment.isNotEmpty)
            AssignmentText(item.assignment),
          if (item.note.isNotEmpty)
            Text(item.note, style: theme.textTheme.bodySmall),
        ],
      ),
      onTap: onTap,
    );
  }
}

/// Weekday over date, or a dash while no day has been settled on.
class _DayBlock extends StatelessWidget {
  const _DayBlock({required this.day, required this.locale});

  final DateTime? day;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = day;
    return SizedBox(
      width: 64,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(on == null ? '—' : DateFormat.E(locale).format(on),
              style: theme.textTheme.labelSmall),
          if (on != null)
            Text(DateFormat.MMMd(locale).format(on),
                style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// The week's meetings for field service, rendered from `fsm_meetings` — the
/// very documents the meetings-for-field-service view edits. Monday is left
/// out: the visit starts on Tuesday.
class _MinistryRows extends ConsumerWidget {
  const _MinistryRows({required this.weekId, required this.canEdit});

  final String weekId;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final meetings = ref.watch(fsmWeekMeetingsProvider(weekId));
    final firstDay = dateKey(CoVisit.startOf(parseDateKey(weekId)));

    return meetings.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(l10n.commonErrorDetail(e.toString())),
      ),
      data: (all) {
        final list =
            all.where((m) => m.date.compareTo(firstDay) >= 0).toList();
        if (list.isEmpty) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Text(l10n.coSectionEmpty, style: theme.textTheme.bodySmall),
          );
        }
        return Column(
          children: [
            for (final meeting in list)
              ListTile(
                dense: true,
                leading: _DayBlock(
                    day: parseDateKey(meeting.date), locale: locale),
                title: Text([
                  meeting.time,
                  if (meeting.location.isNotEmpty) meeting.location,
                ].join('  ·  ')),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (meeting.assignment.isNotEmpty)
                      LabelledAssignment(
                          label: l10n.fsmConductor,
                          assignment: meeting.assignment),
                    if (meeting.withCo.isNotEmpty)
                      LabelledAssignment(
                          label: l10n.coWithCo, assignment: meeting.withCo),
                    if (meeting.withCoWife.isNotEmpty)
                      LabelledAssignment(
                          label: l10n.coWithCoWife,
                          assignment: meeting.withCoWife),
                    if (meeting.note.isNotEmpty)
                      Text(meeting.note, style: theme.textTheme.bodySmall),
                  ],
                ),
                onTap: canEdit
                    ? () => showFsmMeetingDialog(context, ref,
                        existing: meeting)
                    : null,
              ),
          ],
        );
      },
    );
  }
}
