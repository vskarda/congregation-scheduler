import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/dates.dart';

/// Week-by-week pager shared by all schedules: swipe left/right, arrows, and
/// a tappable date label that opens a date picker.
class WeekNavigator extends StatefulWidget {
  const WeekNavigator({super.key, required this.contentBuilder});

  /// Builds the content for one week, identified by its Monday key.
  final Widget Function(BuildContext context, String weekId) contentBuilder;

  @override
  State<WeekNavigator> createState() => _WeekNavigatorState();
}

class _WeekNavigatorState extends State<WeekNavigator> {
  static const _center = 5000;

  final _controller = PageController(initialPage: _center);
  late final DateTime _baseMonday = mondayOf(DateTime.now());
  int _page = _center;

  DateTime _mondayFor(int page) =>
      _baseMonday.add(Duration(days: 7 * (page - _center)));

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
            onPageChanged: (page) => setState(() => _page = page),
            itemBuilder: (context, page) =>
                widget.contentBuilder(context, dateKey(_mondayFor(page))),
          ),
        ),
      ],
    );
  }
}
