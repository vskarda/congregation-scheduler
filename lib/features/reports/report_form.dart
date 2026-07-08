import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';

/// Shared ministry-report form: used by the publisher's own submit screen
/// and by the admin's enter-on-behalf dialog.
class ReportForm extends StatefulWidget {
  const ReportForm({
    super.key,
    required this.initial,
    required this.isPioneer,
    required this.onSubmit,
    this.submitLabel,
  });

  final MinistryReport initial;

  /// Hours/credit fields only make sense for pioneers (admins always see
  /// them so paper reports can be entered fully).
  final bool isPioneer;
  final Future<void> Function(MinistryReport) onSubmit;
  final String? submitLabel;

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  late bool _participated = widget.initial.participated;
  late final _studies = TextEditingController(
      text: widget.initial.bibleStudies?.toString() ?? '');
  late final _hours =
      TextEditingController(text: widget.initial.hours?.toString() ?? '');
  late final _credit = TextEditingController(
      text: widget.initial.creditHours?.toString() ?? '');
  late final _comments =
      TextEditingController(text: widget.initial.comments);
  bool _busy = false;

  @override
  void dispose() {
    _studies.dispose();
    _hours.dispose();
    _credit.dispose();
    _comments.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    try {
      await widget.onSubmit(widget.initial.copyWith(
        participated: _participated,
        bibleStudies: int.tryParse(_studies.text.trim()),
        hours: int.tryParse(_hours.text.trim()),
        creditHours: int.tryParse(_credit.text.trim()),
        comments: _comments.text.trim(),
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        CheckboxListTile(
          value: _participated,
          onChanged: (v) => setState(() => _participated = v ?? false),
          title: Text(l10n.reportParticipated),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _studies,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: l10n.reportStudies),
        ),
        if (widget.isPioneer) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _hours,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.reportHours),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _credit,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.reportCredit),
          ),
        ],
        const SizedBox(height: 12),
        TextField(
          controller: _comments,
          maxLines: 3,
          decoration: InputDecoration(labelText: l10n.reportComments),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _busy ? null : _submit,
          child: Text(widget.submitLabel ?? l10n.reportSubmit),
        ),
      ],
    );
  }
}
