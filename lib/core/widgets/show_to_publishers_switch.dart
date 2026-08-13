import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/admin_mode_provider.dart';
import '../data/schedule_config_repository.dart';
import '../l10n/l10n.dart';
import '../models/models.dart';

/// "Show to publishers" for one week of one schedule.
///
/// Off, publishers still see the whole program — titles, songs, times,
/// locations, notes — but every assigned name is left out of it, and the
/// week's assignments drop out of their Events list too. The schedule's
/// admins keep seeing the names either way, which is why the switch reads the
/// *stored* flag rather than [weekAssigneesVisibleProvider] (always true for
/// the admin looking at it).
///
/// Renders nothing for anyone who may not edit the schedule.
class ShowToPublishersSwitch extends ConsumerWidget {
  const ShowToPublishersSwitch({
    super.key,
    required this.kind,
    required this.weekId,
  });

  final ScheduleKind kind;
  final String weekId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    if (!canEditSchedule(ref.watch(effectiveRolesProvider), kind)) {
      return const SizedBox.shrink();
    }
    final config =
        ref.watch(scheduleConfigProvider(kind)).value ?? const ScheduleConfig();
    final shown = config.showsAssignees(weekId);

    return SwitchListTile(
      dense: true,
      value: shown,
      title: Text(l10n.weekShowToPublishers),
      subtitle: Text(shown
          ? l10n.weekShowToPublishersOn
          : l10n.weekShowToPublishersOff),
      onChanged: (on) => ref
          .read(scheduleConfigRepositoryProvider)
          .setWeekAssigneesVisible(ScheduleConfigDoc.of(kind), weekId, on),
    );
  }
}
