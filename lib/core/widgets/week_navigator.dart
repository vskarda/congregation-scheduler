import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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

/// Week-by-week pager shared by all schedules: swipe left/right, arrows, and
/// a tappable date label that opens a date picker.
class WeekNavigator extends ConsumerStatefulWidget {
  const WeekNavigator({super.key, required this.contentBuilder});

  /// Builds the content for one week, identified by its Monday key.
  final Widget Function(BuildContext context, String weekId) contentBuilder;

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

  Future<void> _pickDate() async {
    final current = _mondayFor(_page);
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(current.year - 3),
      lastDate: DateTime(current.year + 3),
    );
    if (picked == null) return;
    final offset = mondayOf(picked).difference(_baseMonday).inDays ~/ 7;
    _controller.jumpToPage(_center + offset);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final monday = _mondayFor(_page);
    final sunday = monday.add(const Duration(days: 6));
    final fmt = DateFormat.MMMd(locale);
    final label = '${fmt.format(monday)} – ${fmt.format(sunday)}, '
        '${monday.year == sunday.year ? monday.year : '${monday.year}/${sunday.year}'}';

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
              child: TextButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_month, size: 18),
                label: Text(label),
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
