import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/admin_mode_provider.dart';
import '../data/congregation_repository.dart';
import '../data/lmm_repository.dart';
import '../data/schedule_config_repository.dart';
import '../data/weekend_repository.dart';
import '../l10n/enum_labels.dart';
import '../l10n/l10n.dart';
import '../models/models.dart';
import '../utils/dates.dart';
import 'meeting_week_override.dart';
import 'week_navigator.dart';

/// Which meeting a [MeetingWeekHeader] is for.
enum MeetingKind { midweek, weekend }

/// Weeks in `[from, to]` whose meeting was moved off the congregation's
/// regular day, as `weekId -> weekday`. Only the handful that deviate carry
/// the key, so this is one small query for the whole picker.
final _weekdayOverridesProvider = FutureProvider.family<Map<String, int>,
    ({MeetingKind kind, String from, String to})>((ref, args) {
  return args.kind == MeetingKind.midweek
      ? ref.watch(lmmRepositoryProvider).getWeekdayOverrides(args.from, args.to)
      : ref
          .watch(weekendRepositoryProvider)
          .getWeekdayOverrides(args.from, args.to);
});

/// Header of the midweek and weekend schedules: the day and date of the
/// meeting held in the week on screen.
///
/// Tapping it picks another week by its meeting date; the pencil next to it
/// moves *this* week's meeting to another day or time. Both replace what used
/// to be a plain week-range label plus a row inside the schedule itself.
class MeetingWeekHeader extends ConsumerWidget {
  const MeetingWeekHeader({
    super.key,
    required this.weekId,
    required this.kind,
    required this.goTo,
  });

  final String weekId;
  final MeetingKind kind;
  final void Function(DateTime day) goTo;

  /// This week's stored day/time, or nulls when it follows the congregation,
  /// plus the program it runs (regular unless an admin switched it).
  ({int? weekday, String? time, MeetingProgramKind programKind}) _override(
      WidgetRef ref) {
    if (kind == MeetingKind.midweek) {
      final week = ref.watch(lmmWeekProvider(weekId)).value;
      return (
        weekday: week?.meetingWeekday,
        time: week?.meetingTime,
        programKind: week?.programKind ?? MeetingProgramKind.regular,
      );
    }
    final week = ref.watch(weekendWeekProvider(weekId)).value;
    return (
      weekday: week?.meetingWeekday,
      time: week?.meetingTime,
      programKind: week?.programKind ?? MeetingProgramKind.regular,
    );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    CongregationMeta meta,
    ({int? weekday, String? time, MeetingProgramKind programKind}) current,
  ) async {
    final l10n = context.l10n;
    final midweek = kind == MeetingKind.midweek;
    final result = await showMeetingWeekOverrideDialog(
      context,
      title: midweek ? l10n.settingsLmmMeeting : l10n.settingsWeekendMeeting,
      current: (weekday: current.weekday, time: current.time),
      defaultWeekday: midweek ? meta.lmmWeekday : meta.weekendWeekday,
      defaultTime: midweek ? meta.lmmTime : meta.weekendTime,
    );
    if (result == null) return;
    // A week with no document yet gets one: it carries nothing but the moved
    // meeting, which both schedules render and a later import merges into.
    if (midweek) {
      final week = ref.read(lmmWeekProvider(weekId)).value ?? LmmWeek(id: weekId);
      await ref.read(lmmRepositoryProvider).saveWeek(
          week.copyWith(meetingWeekday: result.weekday, meetingTime: result.time));
    } else {
      final week =
          ref.read(weekendWeekProvider(weekId)).value ?? WeekendWeek(id: weekId);
      await ref.read(weekendRepositoryProvider).saveWeek(
          week.copyWith(meetingWeekday: result.weekday, meetingTime: result.time));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final meta =
        ref.watch(congregationMetaProvider).value ?? const CongregationMeta();
    final midweek = kind == MeetingKind.midweek;
    final defaultWeekday = midweek ? meta.lmmWeekday : meta.weekendWeekday;
    final current = _override(ref);
    // Moving the meeting is part of arranging the program it runs, so a
    // Memorial week is movable by either meeting-schedule role — the day and
    // time of the Memorial are exactly what they need to set.
    final canEdit = canEditProgram(
      ref.watch(effectiveRolesProvider),
      midweek ? ScheduleKind.lmm : ScheduleKind.weekend,
      current.programKind,
    );
    final monday = parseDateKey(weekId);
    final meetingDate =
        meetingDateOf(weekId, current.weekday ?? defaultWeekday)!;

    final mondays = weekPickerMondays(include: monday);
    final overrides = ref
            .watch(_weekdayOverridesProvider((
              kind: kind,
              from: dateKey(mondays.first),
              to: dateKey(mondays.last),
            )))
            .value ??
        const <String, int>{};

    return Row(
      children: [
        Expanded(
          child: WeekPickerButton(
            // The year is left off for the current one — on a phone the day
            // name plus the date is already most of the width.
            title: '${DateFormat.EEEE(locale).format(meetingDate)}, '
                '${meetingDate.year == DateTime.now().year ? DateFormat.MMMd(locale).format(meetingDate) : DateFormat.yMMMd(locale).format(meetingDate)}',
            subtitle: Text(
              [
                // A week with nothing planned has no time to announce; one
                // running the Memorial names it instead of a bare clock time.
                if (current.programKind != MeetingProgramKind.nothingPlanned)
                  current.time ?? (midweek ? meta.lmmTime : meta.weekendTime),
                if (current.programKind != MeetingProgramKind.regular)
                  programKindLabel(l10n, current.programKind)
                else if (current.weekday != null || current.time != null)
                  l10n.meetingWeekChanged,
              ].join('  ·  '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            selectedWeekId: weekId,
            // Each week is offered by the date its meeting is actually held
            // on, which is the whole point of the header.
            entries: [
              for (final m in mondays)
                (
                  weekId: dateKey(m),
                  label: DateFormat.yMMMEd(locale).format(
                      meetingDateOf(dateKey(m),
                          overrides[dateKey(m)] ?? defaultWeekday)!),
                ),
            ],
            onSelected: (id) => goTo(parseDateKey(id)),
          ),
        ),
        if (canEdit)
          IconButton(
            tooltip: l10n.meetingWeekEditTooltip,
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: () => _edit(context, ref, meta, current),
          ),
      ],
    );
  }
}
