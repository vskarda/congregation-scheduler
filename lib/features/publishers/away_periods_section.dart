import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';

/// Self-managed vacation / unavailability list. Each add/remove writes
/// immediately (no section-level Save button), matching the other
/// standalone actions on the profile screen. Shared by "My profile" and the
/// admin's publisher-detail screen — [publisherId] selects whose periods to
/// edit; firestore.rules allows self + publishers-admins to write.
class AwayPeriodsSection extends ConsumerWidget {
  const AwayPeriodsSection({super.key, required this.publisherId});

  final String publisherId;

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (range == null) return;
    final current =
        ref.read(publisherAwayProvider(publisherId)).value ?? const PublisherAway();
    final updated = PublisherAway(periods: [
      ...current.periods,
      AwayPeriod(startDate: dateKey(range.start), endDate: dateKey(range.end)),
    ]);
    await ref.read(publishersRepositoryProvider).setAway(publisherId, updated);
  }

  Future<void> _remove(WidgetRef ref, int index) async {
    final current =
        ref.read(publisherAwayProvider(publisherId)).value ?? const PublisherAway();
    final periods = [...current.periods]..removeAt(index);
    await ref
        .read(publishersRepositoryProvider)
        .setAway(publisherId, PublisherAway(periods: periods));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final dateFmt = DateFormat.yMMMd(locale);
    final away = ref.watch(publisherAwayProvider(publisherId));

    // Sort a copy by start date without mutating the provider's list; keep the
    // original index so a delete targets the right stored entry.
    final entries = [
      for (var i = 0; i < (away.value?.periods.length ?? 0); i++)
        (i, away.value!.periods[i]),
    ]..sort((a, b) => a.$2.startDate.compareTo(b.$2.startDate));

    String label(AwayPeriod p) {
      final s = tryParseDateKey(p.startDate);
      final e = tryParseDateKey(p.endDate);
      if (s == null || e == null) return '${p.startDate} – ${p.endDate}';
      return l10n.profileAwayRange(dateFmt.format(s), dateFmt.format(e));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(l10n.profileAwayTitle,
              style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: 4),
        away.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text(l10n.commonErrorDetail(e.toString())),
          ),
          data: (_) => entries.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(l10n.profileAwayEmpty,
                      style: Theme.of(context).textTheme.bodyMedium),
                )
              : Column(
                  children: [
                    for (final (index, period) in entries)
                      ListTile(
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 4),
                        leading: const Icon(Icons.flight_takeoff),
                        title: Text(label(period)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: l10n.commonDelete,
                          onPressed: () => _remove(ref, index),
                        ),
                      ),
                  ],
                ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => _add(context, ref),
            icon: const Icon(Icons.add),
            label: Text(l10n.profileAwayAdd),
          ),
        ),
      ],
    );
  }
}
