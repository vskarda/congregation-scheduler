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
        PopupMenuItem(value: 'es', child: Text(l10n.languageSpanish)),
        PopupMenuItem(value: 'it', child: Text(l10n.languageItalian)),
        PopupMenuItem(value: 'fr', child: Text(l10n.languageFrench)),
        PopupMenuItem(value: 'pt', child: Text(l10n.languagePortuguese)),
        PopupMenuItem(value: 'pl', child: Text(l10n.languagePolish)),
        PopupMenuItem(value: 'de', child: Text(l10n.languageGerman)),
        PopupMenuItem(value: 'ja', child: Text(l10n.languageJapanese)),
        PopupMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
      ],
    );
  }
}
