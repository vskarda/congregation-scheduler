import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n.dart';
import 'theme_mode_provider.dart';

/// Cycles the app theme system → light → dark → system, sitting next to the
/// language button. The icon reflects the current mode: an auto/half circle
/// for "system", a filled circle for dark, an outline circle for light.
class ThemeModeButton extends ConsumerWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final mode = ref.watch(themeModeProvider);

    final (icon, label, next) = switch (mode) {
      ThemeMode.system => (
          Icons.brightness_auto_outlined,
          l10n.themeSystem,
          ThemeMode.light,
        ),
      ThemeMode.light => (
          Icons.light_mode_outlined,
          l10n.themeLight,
          ThemeMode.dark,
        ),
      ThemeMode.dark => (
          Icons.dark_mode,
          l10n.themeDark,
          ThemeMode.system,
        ),
    };

    return IconButton(
      icon: Icon(icon),
      tooltip: l10n.themeTooltip(label),
      onPressed: () => ref.read(themeModeProvider.notifier).set(next),
    );
  }
}
