import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/l10n.dart';

const _consoleUrl = 'https://console.firebase.google.com';

/// Step-by-step walkthrough of docs/SETUP-ADMIN.md for the first admin:
/// creating the congregation's own Firebase project, publishing the
/// security rules and obtaining the configuration JSON.
class SetupGuideScreen extends StatelessWidget {
  const SetupGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final noteStyle = theme.textTheme.bodySmall
        ?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.setupGuideTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(l10n.setupGuideIntro),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _openUrl(_consoleUrl),
                icon: const Icon(Icons.open_in_new),
                label: Text(l10n.setupGuideOpenConsole),
              ),
              _GuideStep(1, l10n.setupGuideStep1Title),
              ..._instruction(l10n.setupGuideStep1Body1,
                  'step1_01_console_welcome'),
              ..._instruction(l10n.setupGuideStep1Body2,
                  'step1_02_create_project'),
              _GuideStep(2, l10n.setupGuideStep2Title),
              ..._instruction(l10n.setupGuideStep2Body1,
                  'step2_01_menu_authentication', wide: true),
              ..._instruction(l10n.setupGuideStep2Body2,
                  'step2_02_auth_get_started'),
              ..._instruction(l10n.setupGuideStep2Body3,
                  'step2_03_signin_providers'),
              ..._instruction(l10n.setupGuideStep2Body4,
                  'step2_04_email_password_save'),
              _GuideStep(3, l10n.setupGuideStep3Title),
              ..._instruction(l10n.setupGuideStep3Body1,
                  'step3_01_menu_firestore', wide: true),
              ..._instruction(l10n.setupGuideStep3Body2,
                  'step3_02_create_database'),
              ..._instruction(l10n.setupGuideStep3Body3,
                  'step3_03_edition_standard'),
              ..._instruction(l10n.setupGuideStep3Body4, 'step3_04_location'),
              ..._instruction(l10n.setupGuideStep3Body5,
                  'step3_05_production_mode'),
              ..._instruction(l10n.setupGuideStep3Body6,
                  'step3_06_create_confirm'),
              _GuideStep(4, l10n.setupGuideStep4Title),
              ..._instruction(l10n.setupGuideStep4Body1, 'step4_01_rules_tab'),
              const _RulesCard(),
              const SizedBox(height: 16),
              ..._instruction(l10n.setupGuideStep4Body2,
                  'step4_02_editor_after_paste'),
              ..._instruction(l10n.setupGuideStep4Body3,
                  'step4_03_publish_changes'),
              Text(l10n.setupGuideStep4Note, style: noteStyle),
              _GuideStep(5, l10n.setupGuideStep5Title),
              ..._instruction(l10n.setupGuideStep5Body1,
                  'step5_01_project_settings'),
              ..._instruction(l10n.setupGuideStep5Body2,
                  'step5_02_your_apps_web'),
              ..._instruction(l10n.setupGuideStep5Body3,
                  'step5_03_register_web_app'),
              ..._instruction(l10n.setupGuideStep5Body4,
                  'step5_04_copy_firebase_config'),
              Text(l10n.setupGuideStep5Note, style: noteStyle),
              const SizedBox(height: 24),
              Text(l10n.setupGuideFinish),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                label: Text(l10n.setupGuideBackToConnect),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One instruction: a sentence followed by its console screenshot.
List<Widget> _instruction(String text, String asset, {bool wide = false}) => [
      Text(text),
      const SizedBox(height: 8),
      _GuideImage(asset, wide: wide),
      const SizedBox(height: 16),
    ];

Future<void> _openUrl(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

class _GuideStep extends StatelessWidget {
  const _GuideStep(this.number, this.title);

  final int number;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            child: Text('$number'),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
        ],
      ),
    );
  }
}

class _GuideImage extends StatelessWidget {
  const _GuideImage(this.asset, {this.wide = false});

  final String asset;

  /// Landscape menu crops are stored at 1080px width, portrait shots at 720px.
  final bool wide;

  String get _path => 'assets/setup_guide/$asset.jpg';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: GestureDetector(
        onTap: () => _showZoom(context),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 420),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              _path,
              cacheWidth: wide ? 1080 : 720,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Padding(
                padding: EdgeInsets.all(24),
                child: Icon(Icons.broken_image_outlined),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showZoom(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            InteractiveViewer(
              maxScale: 4,
              child: Image.asset(_path),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton.filledTonal(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The bundled firestore.rules with a copy button that works without
/// expanding the (long) rules text.
class _RulesCard extends StatefulWidget {
  const _RulesCard();

  @override
  State<_RulesCard> createState() => _RulesCardState();
}

class _RulesCardState extends State<_RulesCard> {
  late final Future<String> _rules;

  @override
  void initState() {
    super.initState();
    _rules = rootBundle.loadString('firestore.rules');
  }

  Future<void> _copy(String rules) async {
    await Clipboard.setData(ClipboardData(text: rules));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.setupGuideRulesCopied)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: FutureBuilder<String>(
        future: _rules,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.setupGuideRulesLoadError,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            );
          }
          final rules = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    Icon(Icons.shield_outlined,
                        color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(l10n.setupGuideRulesTitle,
                          style: theme.textTheme.titleMedium),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: FilledButton.icon(
                  onPressed: rules == null ? null : () => _copy(rules),
                  icon: const Icon(Icons.copy),
                  label: Text(l10n.setupGuideRulesCopy),
                ),
              ),
              if (rules == null)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: LinearProgressIndicator(),
                )
              else
                ExpansionTile(
                  title: Text(l10n.setupGuideRulesView),
                  shape: const Border(),
                  collapsedShape: const Border(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: SelectableText(
                        rules,
                        style: const TextStyle(
                            fontFamily: 'monospace', fontSize: 12),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
