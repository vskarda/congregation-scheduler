import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/congregation_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';

/// Full-admin congregation settings: name + regular meeting days/times.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metaAsync = ref.watch(congregationMetaProvider);
    return metaAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(context.l10n.commonErrorDetail(e.toString()))),
      data: (meta) => _SettingsForm(meta: meta ?? const CongregationMeta()),
    );
  }
}

class _SettingsForm extends ConsumerStatefulWidget {
  const _SettingsForm({required this.meta});

  final CongregationMeta meta;

  @override
  ConsumerState<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends ConsumerState<_SettingsForm> {
  late final _name = TextEditingController(text: widget.meta.name);
  late var _meta = widget.meta;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickTime(bool lmm) async {
    final current = lmm ? _meta.lmmTime : _meta.weekendTime;
    final parts = current.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 18,
        minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
      ),
    );
    if (picked != null) {
      final value =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(
        () => _meta = lmm
            ? _meta.copyWith(lmmTime: value)
            : _meta.copyWith(weekendTime: value),
      );
    }
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final uid = ref.read(currentUidProvider);
    setState(() => _busy = true);
    try {
      var meta = _meta.copyWith(name: _name.text.trim());
      // congregation/meta may be absent (e.g. Firestore data reset); a
      // set(merge:true) then becomes a *create*, which the rules only allow
      // when founderUid == the caller's uid. Preserve an existing founderUid.
      if (meta.founderUid.isEmpty && uid != null) {
        meta = meta.copyWith(founderUid: uid);
      }
      await ref.read(congregationRepositoryProvider).updateMeta(meta);
      messenger.showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.commonErrorDetail(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    String weekdayName(int weekday) =>
        DateFormat.EEEE(locale).format(DateTime(2026, 6, weekday));

    Widget meetingRow(String label, bool lmm) {
      final weekday = lmm ? _meta.lmmWeekday : _meta.weekendWeekday;
      final time = lmm ? _meta.lmmTime : _meta.weekendTime;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 4),
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: weekday,
                  items: [
                    for (var d = DateTime.monday; d <= DateTime.sunday; d++)
                      DropdownMenuItem(value: d, child: Text(weekdayName(d))),
                  ],
                  onChanged: (d) => setState(
                    () => _meta = lmm
                        ? _meta.copyWith(lmmWeekday: d ?? weekday)
                        : _meta.copyWith(weekendWeekday: d ?? weekday),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _pickTime(lmm),
                icon: const Icon(Icons.schedule, size: 18),
                label: Text(time),
              ),
            ],
          ),
        ],
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _name,
              decoration: InputDecoration(labelText: l10n.settingsName),
            ),
            meetingRow(l10n.settingsLmmMeeting, true),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: DropdownButtonFormField<int>(
                initialValue: _meta.lmmClassCount.clamp(1, 3),
                decoration: InputDecoration(
                  labelText: l10n.settingsLmmClassCount,
                ),
                items: [
                  for (var c = 1; c <= 3; c++)
                    DropdownMenuItem(value: c, child: Text('$c')),
                ],
                onChanged: (c) => setState(
                  () => _meta = _meta.copyWith(
                    lmmClassCount: c ?? _meta.lmmClassCount,
                  ),
                ),
              ),
            ),
            meetingRow(l10n.settingsWeekendMeeting, false),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _busy ? null : _save,
              child: Text(l10n.commonSave),
            ),
          ],
        ),
      ),
    );
  }
}
