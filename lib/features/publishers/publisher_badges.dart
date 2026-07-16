import 'package:flutter/material.dart';

import '../../core/l10n/enum_labels.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';

/// Compact role badges shown in the publisher roster trailing area: elder/MS
/// appointment, pioneer type, and admin rights. Language-neutral icons with
/// tooltips (reusing the enum-label helpers) so no per-role short strings are
/// needed. Returns an empty-width row when the publisher has none.
class PublisherBadges extends StatelessWidget {
  const PublisherBadges({super.key, required this.publisher});

  final Publisher publisher;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    const pioneerColor = Color(0xFF2E9E6B);
    final badges = <Widget>[];

    switch (publisher.appointment) {
      case Appointment.elder:
        badges.add(_Badge(
          icon: Icons.stars,
          color: scheme.primary,
          tooltip: appointmentLabel(l10n, Appointment.elder),
        ));
      case Appointment.ministerialServant:
        badges.add(_Badge(
          icon: Icons.star_border,
          color: scheme.primary,
          tooltip: appointmentLabel(l10n, Appointment.ministerialServant),
        ));
      case Appointment.none:
        break;
    }

    if (publisher.isPioneer) {
      badges.add(_Badge(
        icon: _pioneerIcon(publisher.status),
        color: pioneerColor,
        tooltip: statusLabel(l10n, publisher.status),
      ));
    }

    if (publisher.roles.fullAdmin) {
      badges.add(_Badge(
        icon: Icons.shield,
        color: scheme.error,
        tooltip: l10n.roleFullAdmin,
      ));
    } else if (publisher.roles.any) {
      badges.add(_Badge(
        icon: Icons.shield_outlined,
        color: scheme.onSurfaceVariant,
        tooltip: l10n.pubFilterHasRights,
      ));
    }

    if (badges.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final b in badges) ...[const SizedBox(width: 4), b],
      ],
    );
  }

  static IconData _pioneerIcon(PublisherStatus status) => switch (status) {
        PublisherStatus.auxiliaryPioneer => Icons.outlined_flag,
        PublisherStatus.regularPioneer => Icons.flag,
        PublisherStatus.specialPioneer => Icons.emoji_flags,
        PublisherStatus.fieldMissionary => Icons.public,
        PublisherStatus.publisher || PublisherStatus.none => Icons.flag,
      };
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.color, required this.tooltip});

  final IconData icon;
  final Color color;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Icon(icon, size: 18, color: color),
    );
  }
}
