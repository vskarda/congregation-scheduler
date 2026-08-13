import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/congregation_repository.dart';
import '../../../core/data/publishers_repository.dart';
import '../../../core/data/reports_repository.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/models/models.dart';
import '../../../core/pdf/pdf_fonts.dart';
import '../../../core/utils/dates.dart';
import '../../info_board/file_opener/file_opener.dart';
import 's21_batch_export.dart';
import 's21_pdf.dart';

/// Roster action for S-21 admins: exports one S-21 record card per publisher
/// currently listed (search and filters included) into a single PDF, one page
/// each. The card set covers the running service year and the one before it,
/// matching the two-year card the single-publisher export produces.
class S21BatchPdfButton extends ConsumerStatefulWidget {
  const S21BatchPdfButton({super.key, required this.publishers});

  /// The list the screen is showing, already filtered and sorted. Passed in
  /// rather than re-read from a provider so the export matches what the admin
  /// sees — and because reading a provider's future inside a callback has no
  /// live listener to keep it alive.
  final List<Publisher> publishers;

  @override
  ConsumerState<S21BatchPdfButton> createState() => _S21BatchPdfButtonState();
}

class _S21BatchPdfButtonState extends ConsumerState<S21BatchPdfButton> {
  bool _busy = false;
  final _progress = ValueNotifier<({int done, int total})>((done: 0, total: 1));

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  List<int> get _years {
    final current = serviceYearOf(DateTime.now());
    return [current, current - 1];
  }

  /// Warning shown before anything is read: the file carries every listed
  /// publisher's personal data, and on a large roster it takes a while.
  Future<bool> _confirm(AppLocalizations l10n) async {
    final years = _years.map(l10n.serviceYear).join(' · ');
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.s21BatchConfirmTitle),
        content: Text(
            l10n.s21BatchConfirmBody(widget.publishers.length, years)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonExport),
          ),
        ],
      ),
    );
    return ok == true;
  }

  /// Modal progress while the reports and profiles are fetched. Not
  /// dismissible: the export owns the dialog and pops it itself.
  void _showProgressDialog(AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: ValueListenableBuilder<({int done, int total})>(
          valueListenable: _progress,
          builder: (context, value, _) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.s21BatchGenerating),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: value.total == 0 ? null : value.done / value.total,
              ),
              const SizedBox(height: 8),
              Text('${value.done} / ${value.total}',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _export() async {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final congregationName =
        ref.read(congregationMetaProvider).value?.name ?? '';
    if (!await _confirm(l10n)) return;
    final years = _years;
    setState(() => _busy = true);
    _progress.value = (done: 0, total: 1);
    _showProgressDialog(l10n);
    var dialogOpen = true;
    try {
      final cards = await loadS21Cards(
        publishers: widget.publishers,
        publishersRepo: ref.read(publishersRepositoryProvider),
        reportsRepo: ref.read(reportsRepositoryProvider),
        years: years,
        // The notifier is disposed with the widget; a load still running
        // after the roster is left simply stops reporting.
        onProgress: (done, total) {
          if (mounted) _progress.value = (done: done, total: total);
        },
      );
      // The document is built on this isolate; yielding first lets the
      // progress dialog paint its finished state before the UI blocks.
      await Future<void>.delayed(Duration.zero);
      final bytes = await buildS21BatchPdf(
        cards: cards,
        l10n: l10n,
        locale: locale,
        fonts: await loadPdfFonts(),
      );
      navigator.pop();
      dialogOpen = false;
      final fileName = [
        'S-21',
        if (congregationName.isNotEmpty) congregationName,
        '${years.last - 1}-${years.first}',
      ].join('_').replaceAll(' ', '_');
      await openFileBytes(
        bytes: bytes,
        name: '$fileName.pdf',
        mimeType: 'application/pdf',
      );
    } catch (e) {
      if (dialogOpen) {
        navigator.pop();
        dialogOpen = false;
      }
      messenger.showSnackBar(
          SnackBar(content: Text(l10n.commonErrorDetail(e.toString()))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.s21ExportAll,
      onPressed: _busy || widget.publishers.isEmpty ? null : _export,
      icon: _busy
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.contact_page_outlined),
    );
  }
}
