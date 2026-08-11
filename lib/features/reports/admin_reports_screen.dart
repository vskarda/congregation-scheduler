import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/data/reports_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import 'report_form.dart';

/// Admin overview of one month's reports with paper-report entry.
class AdminReportsScreen extends ConsumerStatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  ConsumerState<AdminReportsScreen> createState() =>
      _AdminReportsScreenState();
}

class _AdminReportsScreenState extends ConsumerState<AdminReportsScreen> {
  late String _month = monthKey(addMonths(DateTime.now(), -1));

  Future<void> _enterFor(Publisher publisher, MinistryReport? existing,
      {required bool sharedLastMonth}) async {
    final l10n = context.l10n;
    final adminUid = ref.read(currentUidProvider) ?? 'admin';
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.reportEnterFor(publisher.fullName)),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: ReportForm(
              initial: existing ??
                  MinistryReport(
                      publisherId: publisher.id,
                      month: _month,
                      statusAtMonth: publisher.status),
              isPioneer: true,
              // The admin gets the whole status list rather than the aux tick:
              // it covers the aux month the tick covered, and it is the only
              // place a snapshot taken under a wrong standing status can be
              // put right afterwards.
              showStatusPicker: true,
              sharedLastMonth: sharedLastMonth,
              submitLabel: l10n.commonSave,
              onSubmit: (report) async {
                // statusAtMonth (aux tick) is owned by the form.
                await ref.read(reportsRepositoryProvider).submit(
                      report.copyWith(
                        publisherId: publisher.id,
                        month: _month,
                        submittedAt: DateTime.now(),
                        enteredBy:
                            existing?.enteredBy == 'self' ? 'self' : adminUid,
                      ),
                    );
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  /// The comments column takes whatever width the figures leave over. The two
  /// halves do different jobs, and the asymmetry is the point:
  ///  - the cap bounds what the column contributes to the table's *intrinsic*
  ///    width, so a single long note cannot widen the table and push everyone
  ///    into scrolling sideways;
  ///  - the flex is passed through by MinColumnWidth (FixedColumnWidth has
  ///    none) and RenderTable's growth step does not re-apply the cap, so on a
  ///    screen with room to spare the column still grows past it.
  static const _commentsWidth =
      MinColumnWidth(IntrinsicColumnWidth(flex: 1), FixedColumnWidth(420));

  /// A column header. Every column is sized to the wider of its heading and
  /// its content, and most of these hold one digit or one icon — so the
  /// headings, not the figures, decide how much room a column takes. The four
  /// narrow columns therefore carry an abbreviated label and hand the full one
  /// to DataColumn.tooltip. The cap is what is left of that problem: a guard
  /// for a locale whose short form is still long, wrapping it rather than
  /// widening the column. softWrap is set explicitly because DataTable turns
  /// it off for heading labels, and the cap would otherwise clip mid-word.
  static Widget _head(String label, {bool numeric = false}) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 96),
        child: Text(label,
            softWrap: true,
            maxLines: 3,
            textAlign: numeric ? TextAlign.end : TextAlign.start),
      );

  /// One publisher's row for the shown month. [report] is their entry for it,
  /// null when none was filed.
  DataRow _row(Publisher p, MinistryReport? report,
      {required bool sharedLastMonth}) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final counts = p.onRosterInMonth(_month);
    // Four states: a report that counts for nobody (truck), no report at all
    // (grey ring), a report where the publisher shared in the ministry (green
    // tick), or an empty report — nothing but maybe a note/credit hours (red
    // cross). The tooltip carries the same meaning for anyone who can't read
    // the colour.
    final (icon, iconColor, iconLabel) = !counts
        ? (Icons.local_shipping_outlined, theme.disabledColor,
            l10n.reportNotCountedMoved)
        : report == null
            ? (Icons.radio_button_unchecked, theme.disabledColor,
                l10n.reportMissing)
            : report.sharedInMinistry
                ? (Icons.check_circle, Colors.green, l10n.reportParticipated)
                : (Icons.cancel, theme.colorScheme.error, l10n.reportEmpty);
    // The missing reports are what this screen is scanned for, so their rows
    // are tinted: the gaps read as bands down the table. An off-roster row is
    // not a gap — nobody owes that month — and is dimmed instead.
    final tint = counts && report == null
        ? theme.colorScheme.errorContainer.withValues(alpha: 0.25)
        : null;
    final style = counts ? null : TextStyle(color: theme.disabledColor);

    return DataRow(
      key: ValueKey(p.id),
      color: tint == null ? null : WidgetStatePropertyAll(tint),
      onSelectChanged: (_) =>
          _enterFor(p, report, sharedLastMonth: sharedLastMonth),
      cells: [
        DataCell(Tooltip(
          message: iconLabel,
          child: Icon(icon, color: iconColor, size: 20),
        )),
        DataCell(Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p.listName, style: style),
            // Spelled out under the name rather than left to the truck icon:
            // a report filed for a month its publisher had already left is
            // surprising enough to say in words.
            if (!counts)
              Text(l10n.reportNotCountedMoved,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.disabledColor)),
          ],
        )),
        DataCell(Text(report?.bibleStudies?.toString() ?? '', style: style)),
        DataCell(report?.statusAtMonth == PublisherStatus.auxiliaryPioneer
            ? Icon(Icons.check, size: 18, color: style?.color)
            : const SizedBox()),
        DataCell(Text(report?.hours?.toString() ?? '', style: style)),
        DataCell(Text(report?.creditHours?.toString() ?? '', style: style)),
        // Comments are free text. The width is the column's business (see
        // _commentsWidth) — capping the cell too would wrap the note early
        // and leave dead space beside it. Longer notes are cut off here and
        // read in full one tap away, in the entry dialog.
        DataCell(Text(report?.comments ?? '',
            maxLines: 3, overflow: TextOverflow.ellipsis, style: style)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final all = ref.watch(allPublishersProvider).value ?? const <Publisher>[];
    final roster =
        all.where((p) => p.status != PublisherStatus.none).toList();
    final former =
        ref.watch(formerPublishersProvider).value ?? const <FormerPublisher>[];
    final reportsAsync = ref.watch(monthReportsProvider(_month));
    // Who was out in the ministry the month before — the form questions a
    // report that files one of them as having done nothing this month.
    final sharedLastMonth = {
      for (final r in ref
              .watch(monthReportsProvider(
                  monthKey(addMonths(parseMonthKey(_month), -1))))
              .value ??
          const <MinistryReport>[])
        if (r.sharedInMinistry) r.publisherId,
    };
    final locale = Localizations.localeOf(context).toString();
    final monthFmt = DateFormat.yMMMM(locale);

    return reportsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l10n.commonErrorDetail(e.toString()))),
      data: (reports) {
        final byId = {for (final r in reports) r.publisherId: r};
        // A publisher who moved away belongs to the months before the move
        // and to no later one — so past months stay complete and enterable
        // while they stop being missing from every month after.
        final expected =
            roster.where((p) => p.onRosterInMonth(_month)).toList();
        // An entry filed for a month they had already left still shows (it
        // happened, and a mistake must stay correctable), marked as counting
        // for nobody — otherwise this list and the S-1 would disagree.
        // Entries whose publisher record is gone altogether. They go on
        // counting on the S-1 unless a recorded departure says otherwise, so
        // they belong on this list too — nameless, out of the "reported" tally
        // (nobody is waiting for them), and still openable, because a wrong
        // figure has to stay correctable after the person has left.
        final knownIds = {for (final p in all) p.id};
        final formerById = {for (final f in former) f.id: f};
        final orphans = [
          for (final r in reports)
            if (!knownIds.contains(r.publisherId))
              Publisher(
                id: r.publisherId,
                firstName: l10n.reportFormerMember,
                moved: formerById.containsKey(r.publisherId),
                movedDate: formerById[r.publisherId]?.movedDate,
              ),
        ];
        final publishers = [
          ...expected,
          ...roster.where(
              (p) => !p.onRosterInMonth(_month) && byId.containsKey(p.id)),
          ...orphans,
        ];
        final reported =
            expected.where((p) => byId.containsKey(p.id)).length;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => setState(() =>
                        _month = monthKey(
                            addMonths(parseMonthKey(_month), -1))),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(monthFmt.format(parseMonthKey(_month)),
                            style:
                                Theme.of(context).textTheme.titleMedium),
                        Text(
                          l10n.reportSummaryReported(
                              reported, expected.length),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => setState(() =>
                        _month = monthKey(
                            addMonths(parseMonthKey(_month), 1))),
                  ),
                ],
              ),
            ),
            Expanded(
              // Vertical scroll on the outside, horizontal on the inside: the
              // roster is the long axis, and the columns only need to be
              // reachable sideways on a narrow screen.
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      // A flex column grows to the *minWidth* when maxWidth is
                      // unbounded, which it is inside a horizontal scroll
                      // view. This floor is therefore what lets the comments
                      // claim the width the other columns don't need; without
                      // it the table stays intrinsically sized and leaves the
                      // right-hand side of a wide screen empty.
                      constraints:
                          BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        // Tall enough for a wrapped two-line header; see
                        // _head.
                        headingRowHeight: 56,
                        // A finite max is not a ceiling: DataTable aligns its
                        // cell contents, so every row would take the whole of
                        // it and the roster would stretch out for nothing.
                        // Unbounded makes the cells shrink-wrap instead, so
                        // only the rows that need the room — a three-line
                        // note, a moved publisher's second line — take it.
                        // The floor is the minimum touch target: every row
                        // opens the entry dialog when tapped.
                        dataRowMinHeight: kMinInteractiveDimension,
                        dataRowMaxHeight: double.infinity,
                        // Rows are made tappable via onSelectChanged;
                        // suppress the leading selection-checkbox column.
                        showCheckboxColumn: false,
                        columns: [
                          DataColumn(
                              label: _head(l10n.reportParticipatedShort),
                              tooltip: l10n.reportParticipated),
                          DataColumn(label: _head(l10n.reportPublisher)),
                          DataColumn(
                              label: _head(l10n.reportStudiesShort,
                                  numeric: true),
                              tooltip: l10n.reportStudies,
                              numeric: true),
                          DataColumn(
                              label: _head(l10n.reportAuxShort),
                              tooltip: l10n.statusAuxPioneer),
                          DataColumn(
                              label: _head(l10n.reportHours, numeric: true),
                              numeric: true),
                          DataColumn(
                              label: _head(l10n.reportCreditShort,
                                  numeric: true),
                              tooltip: l10n.reportCredit,
                              numeric: true),
                          DataColumn(
                              label: _head(l10n.reportComments),
                              columnWidth: _commentsWidth),
                        ],
                        rows: [
                          for (final p in publishers)
                            _row(p, byId[p.id],
                                sharedLastMonth:
                                    sharedLastMonth.contains(p.id)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
