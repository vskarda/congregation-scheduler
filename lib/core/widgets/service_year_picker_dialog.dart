import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../utils/dates.dart';

/// Oldest service year offerable. Congregations import history, but nothing
/// in the app predates this by a useful margin.
const _firstServiceYear = 2000;

/// Asks which service year a record sheet should cover.
///
/// Returns the picked service year — the calendar year it *ends* in, the same
/// numbering [serviceYearOf] uses — or null when the export was cancelled.
/// [subtitle] renders a line under the stepper; the attendance sheet uses it
/// to name both of the years it prints.
Future<int?> showServiceYearPicker(
  BuildContext context, {
  required String title,
  required int initialYear,
  String Function(int year)? subtitle,
}) =>
    showDialog<int>(
      context: context,
      builder: (_) => _ServiceYearPickerDialog(
        title: title,
        initialYear: initialYear,
        subtitle: subtitle,
      ),
    );

class _ServiceYearPickerDialog extends StatefulWidget {
  const _ServiceYearPickerDialog({
    required this.title,
    required this.initialYear,
    this.subtitle,
  });

  final String title;
  final int initialYear;
  final String Function(int year)? subtitle;

  @override
  State<_ServiceYearPickerDialog> createState() =>
      _ServiceYearPickerDialogState();
}

class _ServiceYearPickerDialogState extends State<_ServiceYearPickerDialog> {
  late int _year = widget.initialYear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // A record sheet reports on time that has passed, so the running service
    // year is as far ahead as the picker goes.
    final lastYear = serviceYearOf(DateTime.now());

    return AlertDialog(
      title: Text(widget.title),
      // Scrollable like the app's other dialogs: on a short viewport — a phone
      // held sideways, or a small window — the stepper and its subtitle are
      // taller than the room a dialog is given.
      content: SizedBox(
        width: 340,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.exportServiceYear,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _year > _firstServiceYear
                        ? () => setState(() => _year--)
                        : null,
                  ),
                  Expanded(
                    child: Text(
                      l10n.serviceYear(_year),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed:
                        _year < lastYear ? () => setState(() => _year++) : null,
                  ),
                ],
              ),
              if (widget.subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    widget.subtitle!(_year),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_year),
          child: Text(l10n.commonExport),
        ),
      ],
    );
  }
}
