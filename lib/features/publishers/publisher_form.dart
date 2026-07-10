import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/l10n/enum_labels.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';

/// Profile editor shared by "My profile" and the admin's publisher detail.
/// The e-mail is locked whenever the publisher has an app account.
class PublisherForm extends ConsumerStatefulWidget {
  const PublisherForm({
    super.key,
    required this.publisher,
    required this.private,
  });

  final Publisher publisher;
  final PublisherPrivate? private;

  @override
  ConsumerState<PublisherForm> createState() => _PublisherFormState();
}

class _PublisherFormState extends ConsumerState<PublisherForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _emergency;
  late Gender _gender;
  late PublisherStatus _status;
  late String _birthDate;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final p = widget.publisher;
    final priv = widget.private;
    _firstName = TextEditingController(text: p.firstName);
    _lastName = TextEditingController(text: p.lastName);
    _email = TextEditingController(text: priv?.email ?? '');
    _phone = TextEditingController(text: priv?.phone ?? '');
    _address = TextEditingController(text: priv?.address ?? '');
    _emergency = TextEditingController(text: priv?.emergencyNote ?? '');
    _gender = p.gender;
    _status = p.status;
    _birthDate = priv?.birthDate ?? '';
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    _emergency.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: tryParseDateKey(_birthDate) ?? DateTime(now.year - 30),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthDate = dateKey(picked));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final repo = ref.read(publishersRepositoryProvider);
      await repo.update(widget.publisher.copyWith(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        gender: _gender,
        status: _status,
      ));
      await repo.setPrivate(
        widget.publisher.id,
        PublisherPrivate(
          email: _email.text.trim(),
          phone: _phone.text.trim(),
          address: _address.text.trim(),
          birthDate: _birthDate,
          emergencyNote: _emergency.text.trim(),
        ),
      );
      messenger.showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(l10n.commonErrorDetail(e.toString()))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final emailLocked = widget.publisher.hasAccount;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _firstName,
            decoration: InputDecoration(labelText: l10n.authFirstName),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l10n.commonFieldRequired
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _lastName,
            decoration: InputDecoration(labelText: l10n.authLastName),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _email,
            enabled: !emailLocked,
            decoration: InputDecoration(
              labelText: l10n.authEmail,
              helperText: emailLocked ? null : null,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: l10n.profilePhone),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _address,
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(labelText: l10n.profileAddress),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _pickBirthDate,
            child: InputDecorator(
              decoration: InputDecoration(labelText: l10n.profileBirthDate),
              child: Text(_birthDate.isEmpty ? '—' : _birthDate),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<Gender>(
            initialValue: _gender,
            decoration: InputDecoration(labelText: l10n.profileGender),
            items: [
              for (final g in Gender.values)
                DropdownMenuItem(value: g, child: Text(genderLabel(l10n, g))),
            ],
            onChanged: (g) => setState(() => _gender = g ?? Gender.unknown),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<PublisherStatus>(
            initialValue: _status,
            decoration: InputDecoration(labelText: l10n.profileStatus),
            items: [
              for (final s in PublisherStatus.values)
                DropdownMenuItem(value: s, child: Text(statusLabel(l10n, s))),
            ],
            onChanged: (s) =>
                setState(() => _status = s ?? PublisherStatus.publisher),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emergency,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: l10n.profileEmergency,
              helperText: l10n.profileEmergencyHint,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _save,
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
  }
}
