import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';

class SetupModeScreen extends StatelessWidget {
  const SetupModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.setupModeTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.group_add_outlined, size: 36),
                  title: Text(l10n.setupModeJoin),
                  subtitle: Text(l10n.setupModeJoinSubtitle),
                  onTap: () => context.go('/register?mode=join'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.add_home_work_outlined, size: 36),
                  title: Text(l10n.setupModeNew),
                  subtitle: Text(l10n.setupModeNewSubtitle),
                  onTap: () => context.go('/register?mode=new'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(l10n.authHaveAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
