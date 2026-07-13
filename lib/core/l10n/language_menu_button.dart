import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n.dart';
import 'locale_provider.dart';

class LanguageMenuButton extends ConsumerWidget {
  const LanguageMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      tooltip: l10n.commonLanguage,
      onSelected: (v) => ref
          .read(localeProvider.notifier)
          .set(v == 'system' ? null : Locale(v)),
      itemBuilder: (_) => [
        PopupMenuItem(value: 'system', child: Text(l10n.languageSystem)),
        PopupMenuItem(value: 'cs', child: Text(l10n.languageCzech)),
        PopupMenuItem(value: 'tr', child: Text(l10n.languageTurkish)),
        PopupMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
      ],
    );
  }
}
