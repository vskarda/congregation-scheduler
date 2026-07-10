import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/events_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import 'my_assignments_provider.dart';

String eventTypeLabel(AppLocalizations l10n, EventType type) =>
    switch (type) {
      EventType.convention => l10n.eventTypeConvention,
      EventType.assembly => l10n.eventTypeAssembly,
      EventType.memorial => l10n.eventTypeMemorial,
      EventType.coVisit => l10n.eventTypeCoVisit,
      EventType.other => l10n.eventTypeOther,
    };

String assignmentRoleLabel(AppLocalizations l10n, String roleKey) =>
    switch (roleKey) {
      'chairman' => l10n.partChairman,
      'prayer' => l10n.qPrayer,
      'treasures' => l10n.qTreasures,
      'gems' => l10n.partGems,
      'bibleReading' => l10n.partBibleReading,
      'fieldMinistry' => l10n.qFieldMinistry,
      'living' => l10n.qLiving,
      'cbsConductor' => l10n.partCbs,
      'cbsReader' => l10n.partCbsReader,
      'assistant' => l10n.roleAssistant,
      'speaker' => l10n.weekendSpeaker,
      'weekendChairman' => l10n.weekendChairmanLabel,
      'wtReader' => l10n.weekendWtReader,
      'attendants' => l10n.supportAttendants,
      'microphones' => l10n.supportMicrophones,
      'audioVideo' => l10n.supportAudioVideo,
      'pw' => l10n.rolePw,
      _ => '',
    };

String assignmentTitle(AppLocalizations l10n, MyAssignmentEntry entry) => [
      assignmentRoleLabel(l10n, entry.roleKey),
      if (entry.detail.isNotEmpty) '— ${entry.detail}',
    ].join(' ');

String? assignmentTimeLabel(MyAssignmentEntry entry) => switch (entry.time) {
      null => null,
      final t when entry.endTime == null => t,
      final t => '$t–${entry.endTime}',
    };

/// Standard length of a JW meeting; per-meeting duration isn't stored.
const _meetingDuration = Duration(minutes: 105);

DateTime _combineDateAndTime(DateTime day, String hhMm) {
  final parts = hhMm.split(':');
  return DateTime(
      day.year, day.month, day.day, int.parse(parts[0]), int.parse(parts[1]));
}

Event eventCalendarEvent(AppLocalizations l10n, EventItem event) {
  final start = parseDateKey(event.dateFrom);
  final lastDay =
      event.dateTo.isNotEmpty ? parseDateKey(event.dateTo) : start;
  return Event(
    title: event.title.isEmpty ? eventTypeLabel(l10n, event.type) : event.title,
    description: event.notes,
    location: event.location,
    startDate: start,
    // All-day ranges are exclusive of the end date.
    endDate: lastDay.add(const Duration(days: 1)),
    allDay: true,
  );
}

Event assignmentCalendarEvent(AppLocalizations l10n, MyAssignmentEntry entry) {
  final day = parseDateKey(entry.date);
  final start = _combineDateAndTime(day, entry.time!);
  final end = entry.endTime != null
      ? _combineDateAndTime(day, entry.endTime!)
      : start.add(_meetingDuration);
  return Event(
    title: assignmentTitle(l10n, entry),
    location: entry.source == AssignmentSource.pw ? entry.detail : '',
    startDate: start,
    endDate: end,
  );
}

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final canEdit = ref.watch(effectiveRolesProvider).canEditEvents();
    final eventsAsync = ref.watch(eventsProvider);
    final mineAsync = ref.watch(myUpcomingAssignmentsProvider);
    final locale = Localizations.localeOf(context).toString();
    final dateFmt = DateFormat.yMMMEd(locale);
    final today = dateKey(DateTime.now());

    return Scaffold(
      floatingActionButton: canEdit
          ? FloatingActionButton(
              tooltip: l10n.eventAdd,
              onPressed: () => _showEventDialog(context, ref),
              child: const Icon(Icons.add),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 88),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(l10n.eventsUpcoming,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          eventsAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.commonErrorDetail(e.toString())),
            ),
            data: (events) {
              final upcoming = events
                  .where((e) =>
                      (e.dateTo.isNotEmpty ? e.dateTo : e.dateFrom)
                          .compareTo(today) >=
                      0)
                  .toList();
              if (upcoming.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.eventsNone),
                );
              }
              return Column(
                children: [
                  for (final event in upcoming)
                    Card(
                      child: ListTile(
                        leading: Icon(switch (event.type) {
                          EventType.convention => Icons.stadium_outlined,
                          EventType.assembly => Icons.groups_2_outlined,
                          EventType.memorial => Icons.wine_bar_outlined,
                          EventType.coVisit =>
                            Icons.co_present_outlined,
                          EventType.other => Icons.event_outlined,
                        }),
                        title: Text(event.title.isEmpty
                            ? eventTypeLabel(l10n, event.type)
                            : event.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text([
                              dateFmt.format(parseDateKey(event.dateFrom)),
                              if (event.dateTo.isNotEmpty &&
                                  event.dateTo != event.dateFrom)
                                '– ${dateFmt.format(parseDateKey(event.dateTo))}',
                            ].join(' ')),
                            if (event.location.isNotEmpty)
                              Text(event.location),
                            if (event.notes.isNotEmpty)
                              Text(event.notes,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall),
                          ],
                        ),
                        trailing: kIsWeb
                            ? null
                            : IconButton(
                                icon: const Icon(
                                    Icons.event_available_outlined),
                                tooltip: l10n.eventAddToCalendar,
                                onPressed: () => Add2Calendar.addEvent2Cal(
                                    eventCalendarEvent(l10n, event)),
                              ),
                        onTap: canEdit
                            ? () => _showEventDialog(context, ref,
                                existing: event)
                            : null,
                      ),
                    ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Text(l10n.myAssignments,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          mineAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.commonErrorDetail(e.toString())),
            ),
            data: (mine) {
              if (mine.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.myAssignmentsNone),
                );
              }
              return Column(
                children: [
                  for (final entry in mine)
                    ListTile(
                      dense: true,
                      leading: Icon(
                        switch (entry.source) {
                          AssignmentSource.lmm =>
                            Icons.menu_book_outlined,
                          AssignmentSource.weekend =>
                            Icons.groups_outlined,
                          AssignmentSource.pw =>
                            Icons.storefront_outlined,
                        },
                        size: 20,
                      ),
                      title: Text(assignmentTitle(l10n, entry)),
                      subtitle: Text([
                        dateFmt.format(parseDateKey(entry.date)),
                        if (assignmentTimeLabel(entry) != null)
                          assignmentTimeLabel(entry)!,
                      ].join('  ')),
                      trailing: kIsWeb
                          ? null
                          : IconButton(
                              icon: const Icon(
                                  Icons.event_available_outlined,
                                  size: 20),
                              tooltip: l10n.eventAddToCalendar,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              visualDensity: VisualDensity.compact,
                              onPressed: () => Add2Calendar.addEvent2Cal(
                                  assignmentCalendarEvent(l10n, entry)),
                            ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showEventDialog(BuildContext context, WidgetRef ref,
      {EventItem? existing}) async {
    final l10n = context.l10n;
    var event = existing ?? EventItem(dateFrom: dateKey(DateTime.now()));
    final titleCtrl = TextEditingController(text: event.title);
    final locationCtrl = TextEditingController(text: event.location);
    final notesCtrl = TextEditingController(text: event.notes);

    final action = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickDate(bool from) async {
            final current = from ? event.dateFrom : event.dateTo;
            final picked = await showDatePicker(
              context: context,
              initialDate: tryParseDateKey(current) ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() => event = from
                  ? event.copyWith(dateFrom: dateKey(picked))
                  : event.copyWith(dateTo: dateKey(picked)));
            }
          }

          return AlertDialog(
            title:
                Text(existing == null ? l10n.eventAdd : l10n.eventEdit),
            content: SizedBox(
              width: 380,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      autofocus: existing == null,
                      decoration:
                          InputDecoration(labelText: l10n.eventTitle),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<EventType>(
                      initialValue: event.type,
                      decoration:
                          InputDecoration(labelText: l10n.eventType),
                      items: [
                        for (final t in EventType.values)
                          DropdownMenuItem(
                              value: t,
                              child: Text(eventTypeLabel(l10n, t))),
                      ],
                      onChanged: (t) => setState(() =>
                          event = event.copyWith(type: t ?? event.type)),
                    ),
                    ListTile(
                      dense: true,
                      title: Text(l10n.eventDateFrom),
                      subtitle: Text(event.dateFrom),
                      onTap: () => pickDate(true),
                    ),
                    ListTile(
                      dense: true,
                      title: Text(l10n.eventDateTo),
                      subtitle:
                          Text(event.dateTo.isEmpty ? '—' : event.dateTo),
                      onTap: () => pickDate(false),
                    ),
                    TextField(
                      controller: locationCtrl,
                      decoration:
                          InputDecoration(labelText: l10n.eventLocation),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesCtrl,
                      maxLines: 3,
                      decoration:
                          InputDecoration(labelText: l10n.eventNotes),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              if (existing != null)
                TextButton(
                  onPressed: () => Navigator.of(context).pop('delete'),
                  child: Text(l10n.commonDelete),
                ),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.commonCancel)),
              FilledButton(
                  onPressed: () => Navigator.of(context).pop('save'),
                  child: Text(l10n.commonSave)),
            ],
          );
        },
      ),
    );

    final repo = ref.read(eventsRepositoryProvider);
    if (action == 'save') {
      await repo.save(event.copyWith(
        title: titleCtrl.text.trim(),
        location: locationCtrl.text.trim(),
        notes: notesCtrl.text.trim(),
      ));
    } else if (action == 'delete' && existing != null) {
      await repo.delete(existing.id);
    }
    titleCtrl.dispose();
    locationCtrl.dispose();
    notesCtrl.dispose();
  }
}
