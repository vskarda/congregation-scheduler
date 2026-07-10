import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/data/admin_mode_provider.dart';
import '../../../core/data/talk_catalog_repository.dart';
import '../../../core/data/weekend_repository.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/models/models.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/assignment_chips.dart';
import 's99_import_screen.dart';

/// Weekend weeks that reference a talk number, grouped by number and sorted
/// newest first — the S-99 form's "dates delivered" columns.
final talkDeliveriesProvider =
    FutureProvider<Map<int, List<WeekendWeek>>>((ref) async {
  final weeks = await ref.watch(weekendRepositoryProvider).getAll();
  final byNo = <int, List<WeekendWeek>>{};
  for (final week in weeks) {
    final no = week.talkNo;
    if (no != null) (byNo[no] ??= []).add(week);
  }
  for (final list in byNo.values) {
    list.sort((a, b) => b.id.compareTo(a.id));
  }
  return byNo;
});

/// Admin view of the public talk title catalog (S-99): numbered titles with
/// the congregation's delivery history, updated from an S-99 PDF.
class TalkCatalogScreen extends ConsumerStatefulWidget {
  const TalkCatalogScreen({super.key});

  @override
  ConsumerState<TalkCatalogScreen> createState() => _TalkCatalogScreenState();
}

class _TalkCatalogScreenState extends ConsumerState<TalkCatalogScreen> {
  String _filter = '';

  Future<void> _openImport() async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const S99ImportScreen()));
    ref.invalidate(talkDeliveriesProvider);
  }

  Future<void> _editTitle(TalkCatalog catalog, int no) async {
    final l10n = context.l10n;
    final ctrl = TextEditingController(text: catalog.titleFor(no));
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$no. — ${l10n.talksEditTitle}'),
        content: TextField(controller: ctrl, autofocus: true, maxLines: 2),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel)),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.commonSave)),
        ],
      ),
    );
    final title = ctrl.text.trim();
    ctrl.dispose();
    if (saved != true || title.isEmpty || title == catalog.titleFor(no)) {
      return;
    }
    await ref.read(talkCatalogRepositoryProvider).saveCatalog(catalog.copyWith(
          titles: {...catalog.titles, '$no': title},
          updatedAt: dateKey(DateTime.now()),
        ));
    // Manual edits propagate to upcoming weeks the same way imports do.
    await ref
        .read(weekendRepositoryProvider)
        .updateTalkTitles({no: title}, fromWeekId: weekIdOf(DateTime.now()));
    ref.invalidate(talkDeliveriesProvider);
  }

  List<Widget> _deliveryRows(BuildContext context, List<WeekendWeek> weeks,
      String currentWeekId, DateFormat dateFmt) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall
        ?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    return [
      for (final week in weeks)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(dateFmt.format(parseDateKey(week.id)),
                    style: theme.textTheme.bodySmall),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: AssignmentText(week.speaker,
                      style: theme.textTheme.bodySmall)),
              if (week.id.compareTo(currentWeekId) >= 0)
                Text(context.l10n.talksScheduled, style: muted),
            ],
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final dateFmt = DateFormat.yMMMd(locale);
    final currentWeekId = weekIdOf(DateTime.now());
    final catalogAsync = ref.watch(talkCatalogProvider);
    final deliveries =
        ref.watch(talkDeliveriesProvider).value ?? const {};
    final canEdit = ref.watch(effectiveRolesProvider).canEditWeekend();

    return Scaffold(
      body: catalogAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l10n.commonErrorDetail(e.toString()))),
        data: (catalog) {
          if (catalog == null || catalog.titles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(l10n.talksEmpty, textAlign: TextAlign.center),
                  ),
                  if (canEdit) ...[
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _openImport,
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      label: Text(l10n.talksUpdateFromPdf),
                    ),
                  ],
                ],
              ),
            );
          }
          final numbers = catalog.numbers
              .where((no) => _filter.isEmpty
                  ? true
                  : '$no. ${catalog.titleFor(no)}'
                      .toLowerCase()
                      .contains(_filter.toLowerCase()))
              .toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: l10n.talksSearchHint,
                          prefixIcon: const Icon(Icons.search),
                        ),
                        onChanged: (v) => setState(() => _filter = v),
                      ),
                    ),
                    if (canEdit) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: l10n.talksUpdateFromPdf,
                        onPressed: _openImport,
                        icon: const Icon(Icons.picture_as_pdf_outlined),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: numbers.length,
                  itemBuilder: (context, i) {
                    final no = numbers[i];
                    final talkWeeks = deliveries[no] ?? const <WeekendWeek>[];
                    final lastDelivered = talkWeeks
                        .where((w) => w.id.compareTo(currentWeekId) < 0)
                        .firstOrNull;
                    return ExpansionTile(
                      leading: SizedBox(
                        width: 36,
                        child: Text('$no',
                            textAlign: TextAlign.right,
                            style: theme.textTheme.titleMedium),
                      ),
                      title: Text(catalog.titleFor(no)!),
                      subtitle: Text(
                        lastDelivered != null
                            ? l10n.talksLastDelivered(dateFmt
                                .format(parseDateKey(lastDelivered.id)))
                            : l10n.talksNeverDelivered,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                      childrenPadding:
                          const EdgeInsets.fromLTRB(68, 0, 16, 12),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._deliveryRows(
                            context, talkWeeks, currentWeekId, dateFmt),
                        if (canEdit)
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: TextButton.icon(
                              onPressed: () => _editTitle(catalog, no),
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              label: Text(l10n.talksEditTitle),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
