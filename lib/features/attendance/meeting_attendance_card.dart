import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/attendance_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import 'attendance_form.dart';

/// Record-attendance card at the bottom of the midweek and weekend meeting
/// week views. Date and meeting type come from the schedule being shown, so
/// the form carries counts only — there is nothing to pick.
///
/// Hidden entirely for meetings whose week has not started yet, and for
/// anyone without the record right.
class MeetingAttendanceCard extends ConsumerWidget {
  const MeetingAttendanceCard({
    super.key,
    required this.date,
    required this.meetingType,
  });

  /// Calendar date of the meeting this week's schedule is for, derived from
  /// the congregation's configured meeting weekday.
  final DateTime date;
  final MeetingType meetingType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The role check must come before watching the entry: firestore.rules
    // grants attendance reads to the two attendance roles only, so listening
    // unconditionally would fail for every other publisher opening a
    // schedule.
    if (!ref.watch(effectiveRolesProvider).canRecordAttendance()) {
      return const SizedBox.shrink();
    }
    // A meeting moved to an earlier day of its week must still be recordable,
    // so the card opens with the week rather than on the meeting day itself.
    // The counts stay filed under the configured weekday either way.
    if (mondayOf(date).isAfter(mondayOf(DateTime.now()))) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final day = dateKey(date);
    final docId = AttendanceEntry.docId(day, meetingType);

    return ref.watch(attendanceEntryProvider(docId)).when(
          // Nothing until the stored counts are known: AttendanceForm seeds
          // its controllers once from `initial`, so building it early would
          // leave the fields blank for good.
          loading: () => const SizedBox.shrink(),
          error: (e, _) => Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(l10n.commonErrorDetail(e.toString())),
            ),
          ),
          data: (entry) => Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.attAdd,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    DateFormat.yMMMEd(locale).format(date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  AttendanceForm(
                    // Paging to another week rebuilds the fields; a remote
                    // update to the same meeting deliberately does not, so
                    // it can't clobber counts being typed.
                    key: ValueKey(docId),
                    initial: entry ??
                        AttendanceEntry(date: day, meetingType: meetingType),
                    onSubmit: (updated) async {
                      await ref
                          .read(attendanceRepositoryProvider)
                          .upsert(updated);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.attSaved)));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
