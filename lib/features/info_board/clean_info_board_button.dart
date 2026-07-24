import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/infoboard_repository.dart';
import '../../core/l10n/l10n.dart';

/// App-bar action for info-board admins: wipes every announcement (text, file
/// and any legacy link items, past/current/future) after a Yes/No warning.
class CleanInfoBoardButton extends ConsumerStatefulWidget {
  const CleanInfoBoardButton({super.key});

  @override
  ConsumerState<CleanInfoBoardButton> createState() =>
      _CleanInfoBoardButtonState();
}

class _CleanInfoBoardButtonState extends ConsumerState<CleanInfoBoardButton> {
  bool _busy = false;

  Future<void> _clean() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.infoCleanConfirmTitle),
        content: Text(l10n.infoCleanConfirmBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonNo)),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
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
      await ref.read(infoboardRepositoryProvider).deleteAllItems();
      messenger.showSnackBar(SnackBar(content: Text(l10n.infoCleanDone)));
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
      tooltip: context.l10n.infoCleanTooltip,
      onPressed: _busy ? null : _clean,
      icon: _busy
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.delete_sweep_outlined),
    );
  }
}
