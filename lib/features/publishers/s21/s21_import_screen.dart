import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/data/publishers_repository.dart';
import '../../../core/firebase/firebase_providers.dart';
import '../../../core/l10n/enum_labels.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/models/models.dart';
import '../../../core/pdf/pdf_text.dart';
import '../../../core/utils/dates.dart';
import '../publishers_providers.dart';
import 's21_import_parser.dart';
import 's21_import_service.dart';

/// Imports an S-21 publisher record card (PDF): pick a file, preview the
/// parsed profile fields and month tables, then write them to Firestore.
///
/// With [publisherId] the card is imported into that publisher — the name in
/// the app is kept, everything else on the card wins (profile fields are
/// overwritten and each imported month replaces any existing report). With
/// no [publisherId] a brand-new publisher record is created, named from the
/// card (editable before saving).
class S21ImportScreen extends ConsumerStatefulWidget {
  const S21ImportScreen({super.key, this.publisherId});

  final String? publisherId;

  @override
  ConsumerState<S21ImportScreen> createState() => _S21ImportScreenState();
}

class _S21ImportScreenState extends ConsumerState<S21ImportScreen> {
  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  S21Import? _parsed;

  /// Resolved service year per parsed block; null when the card left the
  /// year blank and the admin has not picked one yet.
  List<int?> _blockYears = const [];

  /// Import target; starts as [S21ImportScreen.publisherId] and can be set
  /// by the duplicate-name hint in new-publisher mode.
  String? _targetId;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _targetId = widget.publisherId;
    // Keep the import button's enabled state in sync with the name fields.
    _firstCtrl.addListener(_onNameChanged);
    _lastCtrl.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );
      final bytes = result?.files.single.bytes;
      if (bytes == null) return;
      final parsed = parseS21Import(
        (await extractPdfPageTexts(bytes)).join('\n'),
      );
      if (!mounted) return;
      final name = splitS21Name(parsed.name);
      _firstCtrl.text = name.first;
      _lastCtrl.text = name.last;
      setState(() {
        _parsed = parsed;
        _blockYears = [for (final y in parsed.years) y.serviceYear];
        _error = parsed.isEmpty ? context.l10n.s21ImportNoData : null;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _error = context.l10n.commonErrorDetail(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  bool get _canImport {
    final parsed = _parsed;
    if (parsed == null || parsed.isEmpty || _busy) return false;
    if (_blockYears.contains(null)) return false;
    if (_targetId == null && _firstCtrl.text.trim().isEmpty) return false;
    return true;
  }

  Future<void> _import() async {
    final parsed = _parsed;
    final targetId = _targetId;
    if (parsed == null) return;
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);

    Publisher? existing;
    PublisherPrivate? existingPrivate;
    if (targetId != null) {
      // Importing over an existing record replaces data — make that
      // unmissable before writing anything.
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          icon: Icon(Icons.warning_amber_rounded,
              color: Theme.of(context).colorScheme.error, size: 32),
          title: Text(l10n.s21ImportReplaceTitle),
          content: Text(l10n.s21ImportReplaceBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.s21ImportSave),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    setState(() => _busy = true);
    try {
      if (targetId != null) {
        final repo = ref.read(publishersRepositoryProvider);
        existing = await repo.getOne(targetId);
        if (existing == null) throw StateError('publisher not found');
        existingPrivate = await repo.getPrivate(targetId);
      }
      await ref.read(s21ImportServiceProvider).import(
            data: parsed,
            existing: existing,
            existingPrivate: existingPrivate,
            firstName:
                existing?.firstName ?? _firstCtrl.text.trim(),
            lastName: existing?.lastName ?? _lastCtrl.text.trim(),
            blockYears: _blockYears.cast<int>(),
            enteredBy: ref.read(currentUidProvider) ?? 'admin',
          );
      if (mounted) {
        messenger.showSnackBar(
            SnackBar(content: Text(context.l10n.s21ImportDone)));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = context.l10n.commonErrorDetail(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final parsed = _parsed;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.s21ImportTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l10n.s21ImportHint),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: _busy ? null : _pickFile,
                    icon: const Icon(Icons.file_open_outlined),
                    label: Text(l10n.s21ImportPickFile),
                  ),
                  if (_busy)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(_error!,
                      style: TextStyle(color: theme.colorScheme.error)),
                ),
              if (parsed != null && !parsed.isEmpty) ...[
                const SizedBox(height: 16),
                _NameSection(
                  parsed: parsed,
                  targetId: _targetId,
                  firstCtrl: _firstCtrl,
                  lastCtrl: _lastCtrl,
                  onUseExisting: (id) => setState(() => _targetId = id),
                ),
                const SizedBox(height: 12),
                _ProfilePreview(parsed: parsed),
                for (var i = 0; i < parsed.years.length; i++) ...[
                  const SizedBox(height: 12),
                  _YearTable(
                    block: parsed.years[i],
                    year: _blockYears.length > i ? _blockYears[i] : null,
                    onYearChanged: (y) =>
                        setState(() => _blockYears[i] = y),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  l10n.s21ImportMonths(parsed.monthCount),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: parsed == null || parsed.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: _canImport ? _import : null,
                  child: Text(l10n.s21ImportSave),
                ),
              ),
            ),
    );
  }
}

/// New mode: editable name (prefilled from the card) plus a duplicate-name
/// hint offering to import into the matching record instead. Existing mode:
/// a reminder that the app's name is kept.
class _NameSection extends ConsumerWidget {
  const _NameSection({
    required this.parsed,
    required this.targetId,
    required this.firstCtrl,
    required this.lastCtrl,
    required this.onUseExisting,
  });

  final S21Import parsed;
  final String? targetId;
  final TextEditingController firstCtrl;
  final TextEditingController lastCtrl;
  final ValueChanged<String> onUseExisting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    if (targetId != null) {
      final publisher = ref.watch(publisherProvider(targetId!)).value;
      final appName = publisher?.fullName ?? '';
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.s21ImportNameKept(appName),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              if (parsed.name.isNotEmpty && parsed.name != appName)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(l10n.s21ImportCardName(parsed.name),
                      style: theme.textTheme.bodySmall),
                ),
            ],
          ),
        ),
      );
    }

    final duplicate = parsed.name.isEmpty
        ? null
        : ref
            .watch(allPublishersProvider)
            .value
            ?.firstWhereOrNull((p) =>
                p.fullName.toLowerCase() == parsed.name.toLowerCase());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: firstCtrl,
                decoration: InputDecoration(labelText: l10n.authFirstName),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: lastCtrl,
                decoration: InputDecoration(labelText: l10n.authLastName),
              ),
            ),
          ],
        ),
        if (duplicate != null)
          Card(
            margin: const EdgeInsets.only(top: 12),
            color: theme.colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.s21ImportDuplicateName(duplicate.fullName),
                      style: TextStyle(
                          color: theme.colorScheme.onErrorContainer)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => onUseExisting(duplicate.id),
                      child: Text(l10n.s21ImportUseExisting),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// The header fields recovered from the card; unrecognized ones are omitted
/// (the app's current values stay untouched for those).
class _ProfilePreview extends StatelessWidget {
  const _ProfilePreview({required this.parsed});

  final S21Import parsed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final dateFmt = DateFormat.yMd(locale);

    String date(String key) {
      final d = tryParseDateKey(key);
      return d == null ? key : dateFmt.format(d);
    }

    final entries = <(String, String)>[
      if (parsed.birthDate != null)
        (l10n.profileBirthDate, date(parsed.birthDate!)),
      if (parsed.baptismDate != null)
        (l10n.profileBaptismDate, date(parsed.baptismDate!)),
      if (parsed.gender != null)
        (l10n.profileGender, genderLabel(l10n, parsed.gender!)),
      if (parsed.hope != null)
        (l10n.profileHope, hopeLabel(l10n, parsed.hope!)),
      if (parsed.appointment != null)
        (l10n.profileAppointment, appointmentLabel(l10n, parsed.appointment!)),
      if (parsed.status != null)
        (l10n.profileStatus, statusLabel(l10n, parsed.status!)),
    ];
    if (entries.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final (label, value) in entries)
          Chip(label: Text('$label: $value')),
      ],
    );
  }
}

class _YearTable extends StatelessWidget {
  const _YearTable({
    required this.block,
    required this.year,
    required this.onYearChanged,
  });

  final S21YearImport block;
  final int? year;
  final ValueChanged<int> onYearChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final monthFmt = DateFormat('LLLL', locale);
    final currentYear = serviceYearOf(DateTime.now());

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: block.serviceYear != null
                ? Text(l10n.serviceYear(block.serviceYear!),
                    style: theme.textTheme.titleMedium)
                // The card left the year blank — the admin must pick one.
                : DropdownButtonFormField<int>(
                    initialValue: year,
                    decoration:
                        InputDecoration(labelText: l10n.s21ImportAssignYear),
                    items: [
                      for (var y = currentYear + 1; y > currentYear - 10; y--)
                        DropdownMenuItem(
                            value: y, child: Text(l10n.serviceYear(y))),
                    ],
                    onChanged: (y) {
                      if (y != null) onYearChanged(y);
                    },
                  ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              columns: [
                DataColumn(label: Text(l10n.reportMonth)),
                DataColumn(label: Text(l10n.reportParticipated)),
                DataColumn(label: Text(l10n.reportStudies)),
                DataColumn(label: Text(l10n.statusAuxPioneer)),
                DataColumn(label: Text(l10n.reportHours)),
                DataColumn(label: Text(l10n.reportCredit)),
                DataColumn(label: Text(l10n.reportComments)),
              ],
              rows: [
                for (final row in block.rows)
                  DataRow(cells: [
                    DataCell(Text(monthFmt.format(DateTime(2000, row.month)))),
                    DataCell(Icon(
                        row.participated ? Icons.check : Icons.close,
                        size: 18)),
                    DataCell(Text(row.bibleStudies?.toString() ?? '')),
                    DataCell(row.auxPioneer
                        ? const Icon(Icons.check, size: 18)
                        : const Text('')),
                    DataCell(Text(row.hours?.toString() ?? '')),
                    DataCell(Text(row.creditHours?.toString() ?? '')),
                    DataCell(Text(row.comments)),
                  ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
