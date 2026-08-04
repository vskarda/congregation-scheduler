import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/data/s1_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import 's1_auto_freeze.dart';
import 's1_providers.dart';

class S1Screen extends ConsumerStatefulWidget {
  const S1Screen({super.key});

  @override
  ConsumerState<S1Screen> createState() => _S1ScreenState();
}

class _S1ScreenState extends ConsumerState<S1Screen> {
  late String _month = monthKey(addMonths(DateTime.now(), -1));
  bool _busy = false;

  /// Stores the month's figures as they stand — [live] is what the screen is
  /// showing, which for an unfrozen month is the current computation. From
  /// here on the screen reads them back instead of recomputing, so late
  /// reports and corrected attendance no longer rewrite what was handed in.
  Future<void> _freeze(S1Record live) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(s1RepositoryProvider).freeze(live.copyWith(
            frozenAt: DateTime.now(),
            frozenBy: ref.read(currentUidProvider) ?? '',
          ));
      ref.invalidate(frozenS1Provider);
      messenger.showSnackBar(SnackBar(content: Text(l10n.s1Frozen)));
    } catch (e) {
      messenger
          .showSnackBar(SnackBar(content: Text(l10n.commonErrorDetail('$e'))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _unfreeze() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final locale = Localizations.localeOf(context).toString();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.s1Unfreeze),
        content: Text(l10n.s1UnfreezeConfirm(
            DateFormat.yMMMM(locale).format(parseMonthKey(_month)))),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel)),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.s1Unfreeze)),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    try {
      await ref.read(s1RepositoryProvider).unfreeze(_month);
      // The live result may have been computed before the freeze; the month
      // is about to be shown from it again, so it must be re-read.
      ref.invalidate(liveS1Provider(_month));
      ref.invalidate(frozenS1Provider);
      messenger.showSnackBar(SnackBar(content: Text(l10n.s1Unfrozen)));
    } catch (e) {
      messenger
          .showSnackBar(SnackBar(content: Text(l10n.commonErrorDetail('$e'))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Freezes months that aged past the threshold unnoticed; renders nothing,
    // and a failure (e.g. rules not yet updated) stays out of the way.
    ref.watch(s1AutoFreezeProvider);
    final resultAsync = ref.watch(s1ResultProvider(_month));
    final locale = Localizations.localeOf(context).toString();
    final monthFmt = DateFormat.yMMMM(locale);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => setState(() => _month =
                      monthKey(addMonths(parseMonthKey(_month), -1))),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (resultAsync.value?.isFrozen ?? false) ...[
                        Icon(Icons.lock_outline,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 6),
                      ],
                      Flexible(
                        child: Text(
                          monthFmt.format(parseMonthKey(_month)),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => setState(() => _month =
                      monthKey(addMonths(parseMonthKey(_month), 1))),
                ),
              ],
            ),
            resultAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) =>
                  Text(l10n.commonErrorDetail(e.toString())),
              data: (result) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ValueTile(
                      label: l10n.s1Active,
                      value: result.activePublishers.toString()),
                  _ValueTile(
                      label: l10n.s1AvgMid,
                      value:
                          result.avgMidweekAttendance?.toString() ?? '—'),
                  _ValueTile(
                      label: l10n.s1AvgWeekend,
                      value:
                          result.avgWeekendAttendance?.toString() ?? '—'),
                  _GroupCard(
                    title: l10n.s1Publishers,
                    group: result.publishers,
                    showHours: false,
                  ),
                  _GroupCard(
                    title: l10n.s1AuxPioneers,
                    group: result.auxiliaryPioneers,
                    showHours: true,
                  ),
                  _GroupCard(
                    title: l10n.s1RegPioneers,
                    group: result.regularPioneers,
                    showHours: true,
                  ),
                  _FreezeCard(
                    record: result,
                    month: _month,
                    busy: _busy,
                    onFreeze: () => _freeze(result),
                    onUnfreeze: _unfreeze,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(l10n.s1Note,
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Freeze / unfreeze control below the figures, plus what freezing means for
/// the month on screen.
class _FreezeCard extends ConsumerWidget {
  const _FreezeCard({
    required this.record,
    required this.month,
    required this.busy,
    required this.onFreeze,
    required this.onUnfreeze,
  });

  final S1Record record;
  final String month;
  final bool busy;
  final VoidCallback onFreeze;
  final VoidCallback onUnfreeze;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final bodySmall = Theme.of(context).textTheme.bodySmall;

    if (record.isFrozen) {
      final who = record.auto
          ? l10n.s1FrozenAuto
          : l10n.s1FrozenBy(ref
                  .watch(publishersByIdProvider)[record.frozenBy]
                  ?.listName ??
              l10n.commonNotAssigned);
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lock_outline,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.s1FrozenOn(DateFormat.yMMMd(locale)
                            .format(record.frozenAt!))),
                        Text(who, style: bodySmall),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: busy ? null : onUnfreeze,
                      child: Text(l10n.s1Unfreeze)),
                ],
              ),
              const SizedBox(height: 8),
              Text(l10n.s1FrozenNote, style: bodySmall),
            ],
          ),
        ),
      );
    }

    // The current month is still collecting reports; there is nothing final
    // to preserve yet.
    if (!s1CanFreeze(month, DateTime.now())) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(l10n.s1FreezeOnlyPast, style: bodySmall),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton.tonalIcon(
            onPressed: busy ? null : onFreeze,
            icon: const Icon(Icons.lock_outline),
            label: Text(l10n.s1Freeze),
          ),
          const SizedBox(height: 8),
          Text(l10n.s1FreezeHint, style: bodySmall),
        ],
      ),
    );
  }
}

class _ValueTile extends StatelessWidget {
  const _ValueTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(value,
            style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard(
      {required this.title, required this.group, required this.showHours});

  final String title;
  final S1Group group;
  final bool showHours;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget stat(String label, int value) => Expanded(
          child: Column(
            children: [
              Text(value.toString(),
                  style: Theme.of(context).textTheme.headlineSmall),
              Text(label,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center),
            ],
          ),
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                stat(l10n.s1Count, group.count),
                if (showHours) stat(l10n.s1Hours, group.hours),
                stat(l10n.s1Studies, group.studies),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
