import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../l10n/l10n.dart';
import '../utils/dates.dart';

/// Monday of the week currently shown by the active [WeekNavigator]; lets
/// widgets outside the pager (e.g. the app-bar PDF export) know the viewed
/// week.
class ViewedWeekNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => mondayOf(DateTime.now());

  void set(DateTime monday) => state = monday;
}

final viewedWeekProvider = NotifierProvider<ViewedWeekNotifier, DateTime>(
  ViewedWeekNotifier.new,
);

/// How far the week picker reaches, in weeks around today.
const kWeekPickerWeeksBack = 4;
const kWeekPickerWeeksAhead = 20;

/// Mondays the week picker offers: [kWeekPickerWeeksBack] back and
/// [kWeekPickerWeeksAhead] forward from [now], plus the week of [include] when
/// the pager has been swiped outside that span — the week on screen must
/// always be in the list, or the picker could not show which one it is.
///
/// Weeks are stepped by calendar days, so a DST change cannot move a Monday
/// midnight onto the Sunday before it.
List<DateTime> weekPickerMondays({DateTime? now, DateTime? include}) {
  final base = mondayOf(now ?? DateTime.now());
  final mondays = [
    for (var i = -kWeekPickerWeeksBack; i <= kWeekPickerWeeksAhead; i++)
      DateTime(base.year, base.month, base.day + 7 * i),
  ];
  if (include != null) {
    final monday = mondayOf(include);
    if (!mondays.contains(monday)) {
      mondays
        ..add(monday)
        ..sort();
    }
  }
  return mondays;
}

/// "6 – 12 Jul 2026" for the week starting at [monday].
String weekRangeLabel(String locale, DateTime monday) {
  final sunday = DateTime(monday.year, monday.month, monday.day + 6);
  final fmt = DateFormat.MMMd(locale);
  final year = monday.year == sunday.year
      ? '${monday.year}'
      : '${monday.year}/${sunday.year}';
  return '${fmt.format(monday)} – ${fmt.format(sunday)}, $year';
}

/// One line of the week picker menu.
typedef WeekPickerEntry = ({String weekId, String label});

/// The tappable middle of a week header: a title (plus optional second line)
/// that opens a menu of weeks to jump to.
///
/// A menu rather than a `DropdownButton`, which asserts when its value is not
/// among its items — that would fire the moment the pager is swiped past the
/// end of the offered span.
class WeekPickerButton extends StatelessWidget {
  const WeekPickerButton({
    super.key,
    required this.title,
    this.subtitle,
    required this.entries,
    required this.selectedWeekId,
    required this.onSelected,
  });

  final String title;
  final Widget? subtitle;
  final List<WeekPickerEntry> entries;
  final String selectedWeekId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
      tooltip: context.l10n.weekPickTooltip,
      // Scrolls the menu to the week on screen instead of opening at the top.
      initialValue: selectedWeekId,
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final entry in entries)
          PopupMenuItem(
            value: entry.weekId,
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: entry.weekId == selectedWeekId
                      ? Icon(Icons.check,
                          size: 16, color: theme.colorScheme.primary)
                      : null,
                ),
                Expanded(
                  child: Text(entry.label, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // One line each, so the header keeps its height whatever
                  // the locale's day and month names cost.
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall),
                  ?subtitle,
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Week-by-week pager shared by all schedules: swipe left/right, arrows, and a
/// header that picks the week from a menu.
///
/// The default header names the week itself; the meeting schedules pass a
/// [headerBuilder] that names the meeting held in it and can move it.
class WeekNavigator extends ConsumerStatefulWidget {
  const WeekNavigator({
    super.key,
    required this.contentBuilder,
    this.headerBuilder,
  });

  /// Builds the content for one week, identified by its Monday key.
  final Widget Function(BuildContext context, String weekId) contentBuilder;

  /// Builds the middle of the header row. `goTo` jumps the pager to the week
  /// containing the given day.
  final Widget Function(
    BuildContext context,
    String weekId,
    void Function(DateTime day) goTo,
  )? headerBuilder;

  @override
  ConsumerState<WeekNavigator> createState() => _WeekNavigatorState();
}

class _WeekNavigatorState extends ConsumerState<WeekNavigator> {
  static const _center = 5000;

  final _controller = PageController(initialPage: _center);
  late final DateTime _baseMonday = mondayOf(DateTime.now());
  int _page = _center;

  DateTime _mondayFor(int page) =>
      _baseMonday.add(Duration(days: 7 * (page - _center)));

  @override
  void initState() {
    super.initState();
    // The pager always mounts at the current week; sync the provider so it
    // never carries a stale week over from a previously shown schedule.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(viewedWeekProvider.notifier).set(_baseMonday);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Jumps to the week containing [day]. The offset is counted in calendar
  /// days — an elapsed-time difference is 6 days 23 h across a DST change and
  /// would land a week short.
  void _goTo(DateTime day) {
    final target = mondayOf(day);
    final from = DateTime.utc(
        _baseMonday.year, _baseMonday.month, _baseMonday.day);
    final to = DateTime.utc(target.year, target.month, target.day);
    _controller.jumpToPage(_center + to.difference(from).inDays ~/ 7);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final monday = _mondayFor(_page);

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _controller.previousPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut),
            ),
            Expanded(
              child: widget.headerBuilder?.call(
                    context,
                    dateKey(monday),
                    _goTo,
                  ) ??
                  WeekPickerButton(
                    title: weekRangeLabel(locale, monday),
                    selectedWeekId: dateKey(monday),
                    entries: [
                      for (final m
                          in weekPickerMondays(include: monday))
                        (weekId: dateKey(m), label: weekRangeLabel(locale, m)),
                    ],
                    onSelected: (weekId) => _goTo(parseDateKey(weekId)),
                  ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _controller.nextPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut),
            ),
          ],
        ),
        Expanded(
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (page) {
              setState(() => _page = page);
              ref.read(viewedWeekProvider.notifier).set(_mondayFor(page));
            },
            itemBuilder: (context, page) =>
                widget.contentBuilder(context, dateKey(_mondayFor(page))),
          ),
        ),
      ],
    );
  }
}
