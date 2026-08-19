import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/l10n/enum_labels.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';

/// Profile editor shared by "My profile" and the admin's publisher detail.
///
/// The e-mail here is contact data, not the sign-in identity — that one lives
/// in Firebase Auth and only its owner can change it ("Change sign-in e-mail"
/// on the profile screen). Both are editable, so an address nobody can reach
/// any more can be corrected; the helper text says which is which.
class PublisherForm extends ConsumerStatefulWidget {
  const PublisherForm({
    super.key,
    required this.publisher,
    required this.private,
    this.showAppointment = false,
  });

  final Publisher publisher;
  final PublisherPrivate? private;

  /// Appointment (elder/MS) is maintained by publisher-admins only; the flag
  /// therefore also marks this as the admin's copy of the form rather than
  /// somebody's own profile.
  final bool showAppointment;

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
  late String _baptismDate;
  late Hope _hope;
  late Appointment _appointment;
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
    _baptismDate = priv?.baptismDate ?? '';
    _hope = priv?.hope ?? Hope.otherSheep;
    _appointment = priv?.appointment ?? Appointment.none;
  }

  /// The document can change while the form is open: the connect-record card
  /// sits directly above it on the admin's publisher detail, and a publisher
  /// can edit their own profile from their device at the same time. The form
  /// state is created once in [initState] and the widget is keyed by
  /// publisher id — which a connect does not change — so without this the
  /// fields keep showing the pre-merge values, and a later Save would write
  /// them back over the merged profile.
  ///
  /// Only fields the user has not touched are adopted (a rebuild follows this
  /// callback, so no setState is needed); anything they edited is left alone
  /// so typing is never discarded.
  @override
  void didUpdateWidget(covariant PublisherForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    final was = oldWidget.publisher;
    final now = widget.publisher;
    _syncText(_firstName, was.firstName, now.firstName);
    _syncText(_lastName, was.lastName, now.lastName);
    _gender = _sync(_gender, was.gender, now.gender);
    _status = _sync(_status, was.status, now.status);

    // A private profile that momentarily reads as null (still loading, or not
    // readable) must not blank the fields — only sync against a real doc.
    final priv = widget.private;
    if (priv == null) return;
    final wasPriv = oldWidget.private ?? const PublisherPrivate();
    _syncText(_email, wasPriv.email, priv.email);
    _syncText(_phone, wasPriv.phone, priv.phone);
    _syncText(_address, wasPriv.address, priv.address);
    _syncText(_emergency, wasPriv.emergencyNote, priv.emergencyNote);
    _birthDate = _sync(_birthDate, wasPriv.birthDate, priv.birthDate);
    _baptismDate = _sync(_baptismDate, wasPriv.baptismDate, priv.baptismDate);
    _hope = _sync(_hope, wasPriv.hope, priv.hope);
    _appointment = _sync(_appointment, wasPriv.appointment, priv.appointment);
  }

  /// Adopts [incoming], unless the user has edited the field away from [was].
  static T _sync<T>(T current, T was, T incoming) =>
      current == was ? incoming : current;

  static void _syncText(TextEditingController c, String was, String incoming) {
    if (c.text == was) c.text = incoming;
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

  Future<void> _pickBaptismDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: tryParseDateKey(_baptismDate) ?? DateTime(now.year - 10),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _baptismDate = dateKey(picked));
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
        // Mirror the admin-set appointment onto the public doc so the roster
        // can filter/badge by it. Only the admin form edits appointment; on the
        // self profile copyWith leaves the existing public value untouched.
        appointment: widget.showAppointment ? _appointment : widget.publisher.appointment,
      ));
      await repo.setPrivate(
        widget.publisher.id,
        PublisherPrivate(
          email: _email.text.trim(),
          phone: _phone.text.trim(),
          address: _address.text.trim(),
          birthDate: _birthDate,
          baptismDate: _baptismDate,
          hope: _hope,
          // Never edited on the self profile; the unchanged value must be
          // written back or the security rules reject the save.
          appointment: _appointment,
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
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.authEmail,
              helperText: widget.showAppointment
                  ? l10n.profileEmailAdminHint
                  : l10n.profileEmailSelfHint,
              helperMaxLines: 3,
            ),
            // Records for members without a login often have no address at
            // all, so empty stays valid; anything typed must look like one.
            validator: (v) => (v == null || v.trim().isEmpty || v.contains('@'))
                ? null
                : l10n.changeEmailInvalid,
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
          InkWell(
            onTap: _pickBaptismDate,
            child: InputDecorator(
              decoration: InputDecoration(labelText: l10n.profileBaptismDate),
              child: Text(_baptismDate.isEmpty ? '—' : _baptismDate),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<Gender>(
            // FormField state is internal and only seeded from initialValue,
            // so re-key whenever the value changes underneath (see
            // didUpdateWidget) or the dropdown keeps showing the old one.
            key: ValueKey('gender-$_gender'),
            initialValue: _gender,
            decoration: InputDecoration(labelText: l10n.profileGender),
            items: [
              for (final g in Gender.values)
                DropdownMenuItem(value: g, child: Text(genderLabel(l10n, g))),
            ],
            onChanged: (g) => setState(() => _gender = g ?? Gender.unknown),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<Hope>(
            key: ValueKey('hope-$_hope'),
            initialValue: _hope,
            decoration: InputDecoration(labelText: l10n.profileHope),
            items: [
              for (final h in Hope.values)
                DropdownMenuItem(value: h, child: Text(hopeLabel(l10n, h))),
            ],
            onChanged: (h) => setState(() => _hope = h ?? Hope.otherSheep),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<PublisherStatus>(
            key: ValueKey('status-$_status'),
            initialValue: _status,
            decoration: InputDecoration(labelText: l10n.profileStatus),
            items: [
              // The "-" (not a publisher) status is admin-only, mirroring
              // Appointment. A self-edit with status already "-" must still
              // render it (as the sole, disabled item) rather than omitting
              // it and crashing the dropdown.
              for (final s in PublisherStatus.values)
                if (widget.showAppointment ||
                    (s == PublisherStatus.none) ==
                        (_status == PublisherStatus.none))
                  DropdownMenuItem(
                      value: s, child: Text(statusLabel(l10n, s))),
            ],
            onChanged: widget.showAppointment ||
                    _status != PublisherStatus.none
                ? (s) =>
                    setState(() => _status = s ?? PublisherStatus.publisher)
                : null,
          ),
          const SizedBox(height: 12),
          if (widget.showAppointment) ...[
            DropdownButtonFormField<Appointment>(
              key: ValueKey('appointment-$_appointment'),
              initialValue: _appointment,
              decoration: InputDecoration(labelText: l10n.profileAppointment),
              items: [
                for (final a in Appointment.values)
                  DropdownMenuItem(
                      value: a, child: Text(appointmentLabel(l10n, a))),
              ],
              onChanged: (a) =>
                  setState(() => _appointment = a ?? Appointment.none),
            ),
            const SizedBox(height: 12),
          ],
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
