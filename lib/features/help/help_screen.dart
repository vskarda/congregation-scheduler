import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/l10n/l10n.dart';

const _googleMyMapsGuideUrl =
    'https://github.com/vskarda/prepare-territories-in-google-my-maps';

class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final roles = ref.watch(effectiveRolesProvider);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionHeader(l10n.helpPublisherSection),
            _HelpTopic(
              icon: Icons.event_available_outlined,
              title: l10n.helpCalendarTitle,
              body: l10n.helpCalendarBody,
            ),
            _HelpTopic(
              icon: Icons.notifications_active_outlined,
              title: l10n.helpRemindersTitle,
              body: l10n.helpRemindersBody,
            ),
            _HelpTopic(
              icon: Icons.person_search_outlined,
              title: l10n.helpHighlightTitle,
              body: l10n.helpHighlightBody,
            ),
            _HelpTopic(
              icon: Icons.map_outlined,
              title: l10n.helpTerritoryMapTitle,
              body: l10n.helpTerritoryMapBody,
            ),
            if (roles.any) ...[
              const Divider(height: 32),
              _SectionHeader(l10n.helpAdminSection),
              _HelpTopic(
                icon: Icons.edit_off_outlined,
                title: l10n.helpAdminToggleTitle,
                body: l10n.helpAdminToggleBody,
              ),
              if (roles.canEditLmm() || roles.canEditWeekend())
                _HelpTopic(
                  icon: Icons.picture_as_pdf_outlined,
                  title: l10n.helpPdfExportTitle,
                  body: l10n.helpPdfExportBody,
                ),
              if (roles.canEditTerritories())
                _HelpTopic(
                  icon: Icons.map_outlined,
                  title: l10n.helpGoogleMyMapsTitle,
                  body:
                      '${l10n.helpGoogleMyMapsBody}\n\n'
                      '${l10n.helpGoogleMyMapsPropagationNote}',
                  action: OutlinedButton.icon(
                    onPressed: () => launchUrl(
                      Uri.parse(_googleMyMapsGuideUrl),
                      mode: LaunchMode.externalApplication,
                    ),
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: Text(l10n.helpOpenGuide),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _HelpTopic extends StatelessWidget {
  const _HelpTopic({
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title, style: theme.textTheme.titleSmall),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(body, style: theme.textTheme.bodyMedium),
            if (action != null) ...[
              const SizedBox(height: 12),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
