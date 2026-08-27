import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/congregation_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/pdf/pdf_fonts.dart';
import '../../core/utils/dates.dart';
import '../info_board/file_opener/file_opener.dart';
import 'publishers_pdf.dart';
import 'roster_export_scope.dart';

/// Private profiles fetched per round; see
/// [PublishersRepository.getPrivatesBatched] for why they are batched.
const _privateFetchBatch = 10;

/// Roster action for publisher-admins: exports the publishers currently listed
/// (search and filters included) as a PDF table of their profile details.
class PublishersPdfButton extends ConsumerStatefulWidget {
  const PublishersPdfButton(
      {super.key, required this.publishers, required this.scope});

  /// The list the screen is showing, already filtered and sorted. Passed in
  /// rather than re-read from a provider so the export matches what the admin
  /// sees — and because reading a provider's future inside a callback has no
  /// live listener to keep it alive.
  final List<Publisher> publishers;

  /// How [publishers] relates to the whole roster, so the confirmation can
  /// warn when the file will not simply hold every publisher.
  final RosterExportScope scope;

  @override
  ConsumerState<PublishersPdfButton> createState() =>
      _PublishersPdfButtonState();
}

class _PublishersPdfButtonState extends ConsumerState<PublishersPdfButton> {
  bool _busy = false;

  Future<bool> _confirm(AppLocalizations l10n) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(l10n.pubPdfConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.scope.isEveryPublisher)
              RosterExportScopeWarning(scope: widget.scope),
            Text(l10n.pubPdfConfirmBody(widget.publishers.length)),
          ],
        ),
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

  Future<void> _export() async {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final messenger = ScaffoldMessenger.of(context);
    final congregationName =
        ref.read(congregationMetaProvider).value?.name ?? '';
    if (!await _confirm(l10n)) return;
    setState(() => _busy = true);
    try {
      final repo = ref.read(publishersRepositoryProvider);
      final publishers = widget.publishers;
      final privates = await repo.getPrivatesBatched(
        [for (final p in publishers) p.id],
        batch: _privateFetchBatch,
      );
      final rows = [
        // A record created before its private profile existed simply
        // exports with empty personal columns.
        for (var i = 0; i < publishers.length; i++)
          PublisherProfileRow(publisher: publishers[i], private: privates[i]),
      ];
      final bytes = await buildPublishersPdf(
        rows: rows,
        congregationName: congregationName,
        l10n: l10n,
        locale: locale,
        fonts: await loadPdfFonts(),
      );
      final fileName = [
        'Publishers',
        if (congregationName.isNotEmpty) congregationName,
        dateKey(DateTime.now()),
      ].join('_').replaceAll(' ', '_');
      await openFileBytes(
        bytes: bytes,
        name: '$fileName.pdf',
        mimeType: 'application/pdf',
      );
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
      tooltip: context.l10n.pubPdfExport,
      onPressed: _busy || widget.publishers.isEmpty ? null : _export,
      icon: _busy
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.picture_as_pdf_outlined),
    );
  }
}
