import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/admin_mode_provider.dart';
import '../../core/data/congregation_repository.dart';
import '../../core/data/publishers_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/language_menu_button.dart';
import 'schedule_pdf_button.dart';

class _Destination {
  const _Destination(this.route, this.icon, this.label);

  final String route;
  final IconData icon;
  final String label;
}

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final roles = ref.watch(effectiveRolesProvider);
    final realRoles = ref.watch(myRolesProvider);
    final hideAdmin = ref.watch(hideAdminUiProvider);

    final main = <_Destination>[
      _Destination('/', Icons.campaign_outlined, l10n.navInfoBoard),
      _Destination('/events', Icons.event_outlined, l10n.navEvents),
      _Destination('/lmm', Icons.menu_book_outlined, l10n.navLmm),
      _Destination('/weekend', Icons.groups_outlined, l10n.navWeekend),
      _Destination('/pw', Icons.storefront_outlined, l10n.navPublicWitnessing),
      _Destination('/fsm', Icons.diversity_3_outlined,
          l10n.navFieldServiceMeetings),
      _Destination('/territories', Icons.map_outlined, l10n.navTerritories),
      _Destination('/ministry-groups', Icons.group_work_outlined,
          l10n.navMinistryGroups),
      _Destination('/report', Icons.assignment_turned_in_outlined,
          l10n.navReport),
      _Destination('/profile', Icons.person_outline, l10n.navProfile),
    ];
    final admin = <_Destination>[
      if (roles.canEditPublishers())
        _Destination('/admin/publishers', Icons.manage_accounts_outlined,
            l10n.navPublishersAdmin),
      if (roles.canEditReports())
        _Destination('/admin/reports', Icons.fact_check_outlined,
            l10n.navReportsAdmin),
      if (roles.canEditReports())
        _Destination('/admin/s1', Icons.summarize_outlined, l10n.navS1),
      if (roles.canEditAttendance())
        _Destination(
            '/admin/attendance', Icons.tag_outlined, l10n.navAttendance),
      if (roles.canEditWeekend())
        _Destination('/admin/talks', Icons.record_voice_over_outlined,
            l10n.navTalks),
      if (roles.fullAdmin)
        _Destination(
            '/admin/settings', Icons.settings_outlined, l10n.navSettings),
    ];

    final current = [...main, ...admin].where((d) => d.route == location);
    final title = current.isEmpty ? l10n.appTitle : current.first.label;

    final wide = MediaQuery.sizeOf(context).width >= 1000;
    final panel = _NavPanel(
      main: main,
      admin: admin,
      location: location,
      closeDrawerOnTap: !wide,
    );

    final appBar = AppBar(
      title: Text(title),
      actions: [
        if (location == '/lmm' && roles.canEditLmm())
          const SchedulePdfButton(kind: SchedulePdfKind.lmm),
        if (location == '/weekend' && roles.canEditWeekend())
          const SchedulePdfButton(kind: SchedulePdfKind.weekend),
        if (realRoles.any)
          IconButton(
            // Icon shows the action: pencil = enable editing, slash = hide it.
            icon: Icon(hideAdmin ? Icons.edit_outlined : Icons.edit_off_outlined),
            tooltip: hideAdmin ? l10n.adminToggleShow : l10n.adminToggleHide,
            onPressed: () {
              final hide = !hideAdmin;
              ref.read(hideAdminUiProvider.notifier).set(hide);
              if (hide && location.startsWith('/admin')) context.go('/');
            },
          ),
      ],
    );

    if (wide) {
      return Scaffold(
        appBar: appBar,
        body: Row(
          children: [
            SizedBox(width: 280, child: panel),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: appBar,
      drawer: Drawer(child: panel),
      body: child,
    );
  }
}

class _NavPanel extends ConsumerWidget {
  const _NavPanel({
    required this.main,
    required this.admin,
    required this.location,
    required this.closeDrawerOnTap,
  });

  final List<_Destination> main;
  final List<_Destination> admin;
  final String location;
  final bool closeDrawerOnTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final meta = ref.watch(congregationMetaProvider).value;
    final me = ref.watch(myPublisherProvider).value;

    void go(String route) {
      if (closeDrawerOnTap) Navigator.of(context).pop();
      context.go(route);
    }

    Widget tile(_Destination d) => ListTile(
          leading: Icon(d.icon),
          title: Text(d.label),
          selected: location == d.route,
          onTap: () => go(d.route),
          dense: true,
        );

    return SafeArea(
      child: Column(
        children: [
          ListTile(
            title: Text(
              meta?.name.isNotEmpty == true ? meta!.name : l10n.appTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: me == null ? null : Text(me.fullName),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: [
                ...main.map(tile),
                if (admin.isNotEmpty) ...[
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: Text(l10n.navAdmin,
                        style: Theme.of(context).textTheme.labelSmall),
                  ),
                  ...admin.map(tile),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Row(
            children: [
              const LanguageMenuButton(),
              const Spacer(),
              TextButton.icon(
                onPressed: () => ref.read(firebaseAuthProvider).signOut(),
                icon: const Icon(Icons.logout),
                label: Text(l10n.authSignOut),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
