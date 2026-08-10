import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/l10n/enum_labels.dart';
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
    this.showStatusPicker = false,
    this.sharedLastMonth = false,
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

  /// Whether to offer the full month-status dropdown instead of the aux tick.
  /// Admin-only. The snapshot is otherwise written once, when the row is
  /// created, and for a permanent pioneer nothing may rewrite it afterwards —
  /// which leaves a snapshot taken while the standing status was still wrong
  /// stuck at that value, mis-grouping the month on the S-1 and the S-21 with
  /// no way back. This is that way back: it starts on the stored value, so
  /// saving without touching it changes nothing.
  final bool showStatusPicker;

  /// Whether the publisher shared in the ministry the month before this one.
  /// Only used to question a report that says they did nothing this month —
  /// somebody who was out last month and is suddenly inactive is more often a
  /// forgotten tick than a real change. False when the previous month is
  /// unknown (still loading, or never entered), which simply asks nothing.
  final bool sharedLastMonth;

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  late bool _participated = widget.initial.participated;
  late bool _aux =
      widget.initial.statusAtMonth == PublisherStatus.auxiliaryPioneer;
  // `none` is not offered by the picker, so a row carrying it (nothing writes
  // one today) opens on Publisher rather than tripping the dropdown.
  late PublisherStatus _status =
      widget.initial.statusAtMonth == PublisherStatus.none
          ? PublisherStatus.publisher
          : widget.initial.statusAtMonth;
  late final _studies = TextEditingController(
      text: widget.initial.bibleStudies?.toString() ?? '');
  late final _hours =
      TextEditingController(text: widget.initial.hours?.toString() ?? '');
  late final _credit = TextEditingController(
      text: widget.initial.creditHours?.toString() ?? '');
  late final _comments =
      TextEditingController(text: widget.initial.comments);
  bool _busy = false;

  /// Hours/credit apply to standing pioneers, to a publisher who ticks
  /// auxiliary pioneer for this month, and to whatever the admin's picker
  /// says the month was. Drives both field visibility and whether those
  /// values are persisted.
  bool get _effectivePioneer =>
      widget.isPioneer ||
      (widget.showAuxiliaryPioneer && _aux) ||
      (widget.showStatusPicker && _isPioneerStatus(_status));

  static bool _isPioneerStatus(PublisherStatus status) =>
      status != PublisherStatus.publisher && status != PublisherStatus.none;

  /// The month's status as the form has it: whatever the picker holds, else
  /// the aux tick's verdict, else the stored snapshot untouched.
  PublisherStatus get _statusAtMonth => widget.showStatusPicker
      ? _status
      : widget.showAuxiliaryPioneer
          ? (_aux
              ? PublisherStatus.auxiliaryPioneer
              : PublisherStatus.publisher)
          : widget.initial.statusAtMonth;

  @override
  void dispose() {
    _studies.dispose();
    _hours.dispose();
    _credit.dispose();
    _comments.dispose();
    super.dispose();
  }

  /// Puts the two questionable-looking reports to the person filing them.
  /// Both are legitimate answers, so neither blocks the save — the form only
  /// asks, and taking "Save anyway" files exactly what was typed.
  Future<bool> _confirmWarnings(List<String> warnings) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.reportCheckTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final warning in warnings)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(warning),
              ),
            Text(l10n.reportCheckQuestion),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel)),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.reportSaveAnyway)),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final studies = int.tryParse(_studies.text.trim());
    final hours = _effectivePioneer ? int.tryParse(_hours.text.trim()) : null;
    // If hours or Bible studies are reported, the publisher clearly shared
    // in the ministry — tick it automatically even if they forgot to.
    // (Credit hours alone don't count; see MinistryReport.sharedInMinistry.)
    final participated =
        _participated || (studies ?? 0) > 0 || (hours ?? 0) > 0;

    // Two slips this form can spot but must not decide on its own. Blank
    // hours on a pioneer report are the costly one: the field is the whole
    // point of the report, and the S-1 quietly loses the time. A pioneer who
    // truly did nothing types 0, so blank means forgotten far more often than
    // it means zero. The question follows the month as filed, not who can see
    // the field: an admin is shown hours on every report so that a paper one
    // can be entered in full, and a publisher's month has no hours to forget.
    final warnings = [
      if (_isPioneerStatus(_statusAtMonth) && hours == null)
        l10n.reportCheckPioneerNoHours,
      if (!participated && widget.sharedLastMonth)
        l10n.reportCheckWasActiveLastMonth,
    ];
    if (warnings.isNotEmpty && !await _confirmWarnings(warnings)) return;
    if (!mounted) return;

    setState(() => _busy = true);
    try {
      await widget.onSubmit(widget.initial.copyWith(
        participated: participated,
        bibleStudies: studies,
        hours: hours,
        creditHours:
            _effectivePioneer ? int.tryParse(_credit.text.trim()) : null,
        comments: _comments.text.trim(),
        statusAtMonth: _statusAtMonth,
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
        if (widget.showStatusPicker) ...[
          const SizedBox(height: 8),
          DropdownButtonFormField<PublisherStatus>(
            initialValue: _status,
            decoration:
                InputDecoration(labelText: l10n.reportStatusThisMonth),
            // `none` is not a way to report a month — a publisher who did
            // nothing files an empty report, they do not stop being one.
            items: [
              for (final status in PublisherStatus.values)
                if (status != PublisherStatus.none)
                  DropdownMenuItem(
                      value: status, child: Text(statusLabel(l10n, status))),
            ],
            onChanged: (v) =>
                setState(() => _status = v ?? _status),
          ),
        ],
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
