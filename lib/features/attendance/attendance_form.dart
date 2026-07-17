import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/numeric_input.dart';
import 'attendance_auto_calc.dart';

/// Shared attendance count form: used by the quick-add card and by the
/// history edit dialog. Whenever two of the three counts are entered the
/// third is derived live via [AttendanceAutoCalc].
class AttendanceForm extends StatefulWidget {
  const AttendanceForm({
    super.key,
    required this.initial,
    required this.onSubmit,
    this.submitLabel,
  });

  /// Date and meeting type are taken from this entry; give it a fresh key
  /// (or a new [initial]) to reset the fields when the target meeting
  /// changes.
  final AttendanceEntry initial;
  final Future<void> Function(AttendanceEntry) onSubmit;
  final String? submitLabel;

  @override
  State<AttendanceForm> createState() => _AttendanceFormState();
}

class _AttendanceFormState extends State<AttendanceForm> {
  late final _inPerson =
      TextEditingController(text: widget.initial.inPerson?.toString() ?? '');
  late final _online =
      TextEditingController(text: widget.initial.online?.toString() ?? '');
  late final _total =
      TextEditingController(text: widget.initial.total?.toString() ?? '');
  final _calc = AttendanceAutoCalc();
  bool _mismatch = false;
  bool _busy = false;

  @override
  void dispose() {
    _inPerson.dispose();
    _online.dispose();
    _total.dispose();
    super.dispose();
  }

  TextEditingController _controllerFor(AttendanceField field) =>
      switch (field) {
        AttendanceField.inPerson => _inPerson,
        AttendanceField.online => _online,
        AttendanceField.total => _total,
      };

  int? _valueOf(AttendanceField field) =>
      int.tryParse(_controllerFor(field).text.trim());

  bool get _hasAnyValue =>
      AttendanceField.values.any((f) => _valueOf(f) != null);

  /// User typed in [field]; derive the third count. Programmatic controller
  /// updates don't re-trigger TextField.onChanged, so no feedback loop.
  void _onEdited(AttendanceField field) {
    if (_valueOf(field) == null) {
      _calc.clear(field);
      setState(() => _mismatch = false);
      return;
    }
    final result = _calc.edit(
      field,
      inPerson: _valueOf(AttendanceField.inPerson),
      online: _valueOf(AttendanceField.online),
      total: _valueOf(AttendanceField.total),
    );
    setState(() {
      if (result == null) {
        _mismatch = false;
      } else if (result.value < 0) {
        _mismatch = true;
        _controllerFor(result.field).clear();
      } else {
        _mismatch = false;
        _controllerFor(result.field).text = result.value.toString();
      }
    });
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    try {
      await widget.onSubmit(AttendanceEntry(
        date: widget.initial.date,
        meetingType: widget.initial.meetingType,
        inPerson: _valueOf(AttendanceField.inPerson),
        online: _valueOf(AttendanceField.online),
        total: _valueOf(AttendanceField.total),
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    Widget field(AttendanceField f, String label) => Expanded(
          child: TextField(
            controller: _controllerFor(f),
            keyboardType: numericKeyboardType,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(labelText: label),
            onChanged: (_) => _onEdited(f),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            field(AttendanceField.inPerson, l10n.attInPerson),
            const SizedBox(width: 12),
            field(AttendanceField.online, l10n.attOnline),
            const SizedBox(width: 12),
            field(AttendanceField.total, l10n.attTotal),
          ],
        ),
        if (_mismatch)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l10n.attMismatch,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _busy || _mismatch || !_hasAnyValue ? null : _submit,
          child: Text(widget.submitLabel ?? l10n.commonSave),
        ),
      ],
    );
  }
}
