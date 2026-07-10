import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_providers.dart';
import '../models/models.dart';
import 'publishers_repository.dart';

const _prefsKey = 'hide_admin_ui';

/// true = admin/edit UI hidden ("view as publisher"). Persisted per device;
/// absent pref = false = admin UI shown.
class HideAdminUiNotifier extends Notifier<bool> {
  @override
  bool build() =>
      ref.watch(sharedPreferencesProvider).getBool(_prefsKey) ?? false;

  Future<void> set(bool hide) async {
    state = hide;
    await ref.read(sharedPreferencesProvider).setBool(_prefsKey, hide);
  }
}

final hideAdminUiProvider =
    NotifierProvider<HideAdminUiNotifier, bool>(HideAdminUiNotifier.new);

/// Roles the UI renders with — empty while admin UI is hidden.
/// Use [myRolesProvider] for real permissions (data access, PW
/// materialization, the toggle button's own visibility).
final effectiveRolesProvider = Provider<Roles>((ref) =>
    ref.watch(hideAdminUiProvider)
        ? const Roles()
        : ref.watch(myRolesProvider));
