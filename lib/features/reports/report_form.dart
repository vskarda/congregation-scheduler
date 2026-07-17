import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/numeric_input.dart';

/// Shared ministry-report form: used by the publisher's own submit screen
/// and by the admin's enter-on-behalf dialog.
class ReportForm extends StatefulWidget {
  const ReportForm({
    super.key,
    required this.initial,
    required this.isPioneer,
    required this.onSubmit,
    this.submitLabel,
    this.showAuxiliaryPioneer = false,
  });

  final MinistryReport initial;

  /// Hours/credit fields only make sense for pioneers (admins always see
  /// them so paper reports can be entered fully).
  final bool isPioneer;
  final Future<void> Function(MinistryReport) onSubmit;
  final String? submitLabel;

  /// Whether to offer the per-month "auxiliary pioneer" tick. Only shown when
  /// the publisher's standing status is Publisher or Auxiliary pioneer — a
  /// regular publisher may auxiliary-pioneer for a single month. It is hidden
  /// for permanent pioneers (regular/special/field missionary), whose status
  /// is fixed. The tick is stored as [MinistryReport.statusAtMonth]
  /// (auxiliaryPioneer vs. publisher), the app-wide source of truth for the
  /// S-1 group breakdown and the S-21 aux column.
  final bool showAuxiliaryPioneer;

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  late bool _participated = widget.initial.participated;
  late bool _aux =
      widget.initial.statusAtMonth == PublisherStatus.auxiliaryPioneer;
  late final _studies = TextEditingController(
      text: widget.initial.bibleStudies?.toString() ?? '');
  late final _hours =
      TextEditingController(text: widget.initial.hours?.toString() ?? '');
  late final _credit = TextEditingController(
      text: widget.initial.creditHours?.toString() ?? '');
  late final _comments =
      TextEditingController(text: widget.initial.comments);
  bool _busy = false;

  /// Hours/credit apply to standing pioneers and to a publisher who ticks
  /// auxiliary pioneer for this month. Drives both field visibility and
  /// whether those values are persisted.
  bool get _effectivePioneer =>
      widget.isPioneer || (widget.showAuxiliaryPioneer && _aux);

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
      final studies = int.tryParse(_studies.text.trim());
      final hours =
          _effectivePioneer ? int.tryParse(_hours.text.trim()) : null;
      // If hours or Bible studies are reported, the publisher clearly shared
      // in the ministry — tick it automatically even if they forgot to.
      // (Credit hours alone don't count; see MinistryReport.sharedInMinistry.)
      final participated =
          _participated || (studies ?? 0) > 0 || (hours ?? 0) > 0;
      await widget.onSubmit(widget.initial.copyWith(
        participated: participated,
        bibleStudies: studies,
        hours: hours,
        creditHours:
            _effectivePioneer ? int.tryParse(_credit.text.trim()) : null,
        comments: _comments.text.trim(),
        // The aux tick owns the publisher/auxiliaryPioneer distinction; for
        // permanent pioneers (tick hidden) the snapshot is left untouched.
        statusAtMonth: widget.showAuxiliaryPioneer
            ? (_aux
                ? PublisherStatus.auxiliaryPioneer
                : PublisherStatus.publisher)
            : widget.initial.statusAtMonth,
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
        if (widget.showAuxiliaryPioneer)
          CheckboxListTile(
            value: _aux,
            onChanged: (v) => setState(() => _aux = v ?? false),
            title: Text(l10n.statusAuxPioneer),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        const SizedBox(height: 8),
        TextField(
          controller: _studies,
          keyboardType: numericKeyboardType,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(labelText: l10n.reportStudies),
        ),
        if (_effectivePioneer) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _hours,
            keyboardType: numericKeyboardType,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(labelText: l10n.reportHours),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _credit,
            keyboardType: numericKeyboardType,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
