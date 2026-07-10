import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/app_config.dart';
import '../../core/data/admin_mode_provider.dart';
import '../../core/data/infoboard_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';
import 'file_opener/file_opener.dart';

class InfoBoardScreen extends ConsumerWidget {
  const InfoBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final canEdit = ref.watch(effectiveRolesProvider).canEditInfoBoard();
    final itemsAsync = ref.watch(infoboardItemsProvider);
    final today = dateKey(DateTime.now());

    return Scaffold(
      floatingActionButton: canEdit
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                final type = await showModalBottomSheet<InfoItemType>(
                  context: context,
                  builder: (context) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.notes),
                          title: Text(l10n.infoAddText),
                          onTap: () => Navigator.of(context)
                              .pop(InfoItemType.text),
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.picture_as_pdf_outlined),
                          title: Text(l10n.infoAddFile),
                          onTap: () => Navigator.of(context)
                              .pop(InfoItemType.file),
                        ),
                        ListTile(
                          leading: const Icon(Icons.link),
                          title: Text(l10n.infoAddLink),
                          onTap: () => Navigator.of(context)
                              .pop(InfoItemType.link),
                        ),
                      ],
                    ),
                  ),
                );
                if (type != null && context.mounted) {
                  await _showItemDialog(context, ref, type: type);
                }
              },
            )
          : null,
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l10n.commonErrorDetail(e.toString()))),
        data: (all) {
          // Admins see everything (with a "hidden" badge); others only what
          // falls inside its visibility window.
          final items =
              canEdit ? all : all.where((i) => i.visibleOn(today)).toList();
          if (items.isEmpty) {
            return Center(child: Text(l10n.infoEmpty));
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 88),
            children: [
              for (final item in items)
                _InfoCard(item: item, canEdit: canEdit, today: today),
            ],
          );
        },
      ),
    );
  }
}

class _InfoCard extends ConsumerStatefulWidget {
  const _InfoCard(
      {required this.item, required this.canEdit, required this.today});

  final InfoboardItem item;
  final bool canEdit;
  final String today;

  @override
  ConsumerState<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends ConsumerState<_InfoCard> {
  bool _downloading = false;

  Future<void> _open() async {
    final item = widget.item;
    switch (item.type) {
      case InfoItemType.text:
        break;
      case InfoItemType.link:
        if (item.url.isNotEmpty) {
          await launchUrl(Uri.parse(item.url),
              mode: LaunchMode.externalApplication);
        }
      case InfoItemType.file:
        if (item.fileId.isEmpty || _downloading) return;
        setState(() => _downloading = true);
        try {
          final repo = ref.read(infoboardRepositoryProvider);
          final meta = await repo.getFileMeta(item.fileId);
          final bytes = await repo.downloadFile(item.fileId);
          final mime = meta?.mimeType ?? 'application/octet-stream';
          if (mime.startsWith('image/') && mounted) {
            await showDialog<void>(
              context: context,
              builder: (_) => Dialog(
                child: InteractiveViewer(
                  maxScale: 6,
                  child: Image.memory(bytes),
                ),
              ),
            );
          } else {
            await openFileBytes(
                bytes: bytes,
                name: meta?.name ?? 'document.pdf',
                mimeType: mime);
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text(context.l10n.commonErrorDetail(e.toString()))));
          }
        } finally {
          if (mounted) setState(() => _downloading = false);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final item = widget.item;
    final hidden = !item.visibleOn(widget.today);
    final theme = Theme.of(context);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(switch (item.type) {
              InfoItemType.text => Icons.notes,
              InfoItemType.file => Icons.picture_as_pdf_outlined,
              InfoItemType.link => Icons.link,
            }),
            title: Text(item.title,
                style: theme.textTheme.titleMedium),
            subtitle: hidden
                ? Text(l10n.infoHidden,
                    style: TextStyle(color: theme.colorScheme.error))
                : null,
            trailing: widget.canEdit
                ? IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    onPressed: () => _showItemDialog(context, ref,
                        type: item.type, existing: item),
                  )
                : null,
            onTap: item.type == InfoItemType.text ? null : _open,
          ),
          if (item.type == InfoItemType.text && item.body.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SelectableText(item.body),
            ),
          if (_downloading)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                  const SizedBox(width: 8),
                  Text(l10n.infoDownloading),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> _showItemDialog(
  BuildContext context,
  WidgetRef ref, {
  required InfoItemType type,
  InfoboardItem? existing,
}) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final uid = ref.read(currentUidProvider) ?? '';
  final repo = ref.read(infoboardRepositoryProvider);

  var item = existing ??
      InfoboardItem(type: type, createdAt: DateTime.now(), createdBy: uid);
  final titleCtrl = TextEditingController(text: item.title);
  final bodyCtrl = TextEditingController(text: item.body);
  final urlCtrl = TextEditingController(text: item.url);

  // For new file items: pick the file up front.
  PlatformFile? pickedFile;
  if (type == InfoItemType.file && existing == null) {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'webp', 'gif'],
      withData: true,
    );
    pickedFile = result?.files.single;
    if (pickedFile == null || pickedFile.bytes == null) return;
    if (pickedFile.bytes!.length > AppConfig.maxFileSizeBytes) {
      messenger
          .showSnackBar(SnackBar(content: Text(l10n.infoFileTooLarge)));
      return;
    }
    titleCtrl.text = pickedFile.name;
  }
  if (!context.mounted) return;

  final action = await showDialog<String>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        Future<void> pickDate(bool from) async {
          final current = from ? item.showFrom : item.showUntil;
          final picked = await showDatePicker(
            context: context,
            initialDate: tryParseDateKey(current) ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            setState(() => item = from
                ? item.copyWith(showFrom: dateKey(picked))
                : item.copyWith(showUntil: dateKey(picked)));
          }
        }

        Widget dateRow(String label, String value, bool from) => Row(
              children: [
                Expanded(
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(label),
                    subtitle: Text(value.isEmpty ? '—' : value),
                    onTap: () => pickDate(from),
                  ),
                ),
                if (value.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => setState(() => item = from
                        ? item.copyWith(showFrom: '')
                        : item.copyWith(showUntil: '')),
                  ),
              ],
            );

        return AlertDialog(
          title: Text(existing == null
              ? switch (type) {
                  InfoItemType.text => l10n.infoAddText,
                  InfoItemType.file => l10n.infoAddFile,
                  InfoItemType.link => l10n.infoAddLink,
                }
              : l10n.infoEditItem),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(labelText: l10n.infoTitle),
                  ),
                  if (type == InfoItemType.text) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: bodyCtrl,
                      minLines: 4,
                      maxLines: 12,
                      decoration:
                          InputDecoration(labelText: l10n.infoBody),
                    ),
                  ],
                  if (type == InfoItemType.link) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: urlCtrl,
                      decoration: InputDecoration(labelText: l10n.infoUrl),
                    ),
                  ],
                  const SizedBox(height: 8),
                  dateRow(l10n.infoShowFrom, item.showFrom, true),
                  dateRow(l10n.infoShowUntil, item.showUntil, false),
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

  try {
    if (action == 'save') {
      var toSave = item.copyWith(
        title: titleCtrl.text.trim(),
        body: bodyCtrl.text.trim(),
        url: urlCtrl.text.trim(),
      );
      if (pickedFile != null) {
        final name = pickedFile.name;
        final ext = name.contains('.')
            ? name.substring(name.lastIndexOf('.') + 1).toLowerCase()
            : '';
        final mime = switch (ext) {
          'pdf' => 'application/pdf',
          'png' => 'image/png',
          'jpg' || 'jpeg' => 'image/jpeg',
          'webp' => 'image/webp',
          'gif' => 'image/gif',
          _ => 'application/octet-stream',
        };
        final fileId = await repo.uploadFile(
            bytes: pickedFile.bytes!, name: name, mimeType: mime);
        toSave = toSave.copyWith(fileId: fileId);
      }
      await repo.saveItem(toSave);
    } else if (action == 'delete' && existing != null) {
      await repo.deleteItem(existing);
    }
  } catch (e) {
    messenger.showSnackBar(
        SnackBar(content: Text(l10n.commonErrorDetail(e.toString()))));
  }
  titleCtrl.dispose();
  bodyCtrl.dispose();
  urlCtrl.dispose();
}
