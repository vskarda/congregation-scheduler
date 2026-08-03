import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/assignment_history.dart';
import '../../core/data/fsm_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/week_navigator.dart';

/// App-bar action for field-service-meeting admins: deletes every meeting
/// from the week currently shown by the [WeekNavigator] onwards, after a
/// Yes/No warning. Recurring rules are stopped at the same point, so the
/// meetings they produce do not come straight back; earlier weeks are kept.
class FsmDeleteFromWeekButton extends ConsumerStatefulWidget {
  const FsmDeleteFromWeekButton({super.key});

  @override
  ConsumerState<FsmDeleteFromWeekButton> createState() =>
      _FsmDeleteFromWeekButtonState();
}

class _FsmDeleteFromWeekButtonState
    extends ConsumerState<FsmDeleteFromWeekButton> {
  bool _busy = false;

  /// "Jul 6 – Jul 12, 2026", matching the week navigator's own label.
  String _weekLabel(DateTime monday) {
    final locale = Localizations.localeOf(context).toString();
    final sunday = monday.add(const Duration(days: 6));
    final fmt = DateFormat.MMMd(locale);
    return '${fmt.format(monday)} – ${fmt.format(sunday)}, ${sunday.year}';
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final monday = ref.read(viewedWeekProvider);
    final label = _weekLabel(monday);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.warning_amber_rounded,
            color: Theme.of(context).colorScheme.error, size: 32),
        title: Text(l10n.fsmDeleteFromWeekTitle(label)),
        content: Text(l10n.fsmDeleteFromWeekBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonNo)),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonYes),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      await ref.read(fsmRepositoryProvider).deleteFromWeek(dateKey(monday));
      ref.invalidate(assignmentHistoryProvider);
      messenger
          .showSnackBar(SnackBar(content: Text(l10n.fsmDeleteFromWeekDone)));
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(l10n.commonErrorDetail(e.toString()))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.fsmDeleteFromWeekTooltip,
      onPressed: _busy ? null : _delete,
      icon: _busy
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.event_busy_outlined),
    );
  }
}
