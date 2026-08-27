import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';

/// How a roster listing relates to "every publisher in the congregation" —
/// the set an admin assumes a bulk export covers.
///
/// Derived by comparing the listed records against the whole roster rather
/// than by inspecting which filter chips are on, so it stays right whatever
/// narrowed the list: a chip, the group picker or the search box.
class RosterExportScope {
  const RosterExportScope({
    required this.listed,
    required this.publishers,
    required this.missing,
    required this.extra,
  });

  /// Records that will be exported (the list exactly as shown).
  final int listed;

  /// Publishers in the congregation right now: present (not yet moved) and
  /// carrying a service status.
  final int publishers;

  /// How many of those [publishers] the listing leaves out.
  final int missing;

  /// Listed records that are not one of those [publishers]: service status
  /// "-", or already moved away.
  final int extra;

  /// Whether an admin who saw "all publishers" would be right: nothing
  /// filtered away, and nothing but publishers on the list.
  bool get isEveryPublisher => missing == 0 && extra == 0;

  /// Compares [listed] against the whole roster [all]. A departure dated in
  /// the future leaves the publisher present, exactly as everywhere else.
  factory RosterExportScope.of({
    required List<Publisher> all,
    required List<Publisher> listed,
    required DateTime today,
  }) {
    bool present(Publisher p) =>
        !p.hasMovedBy(today) && p.status != PublisherStatus.none;
    final listedIds = {for (final p in listed) p.id};
    var publishers = 0;
    var missing = 0;
    for (final p in all) {
      if (!present(p)) continue;
      publishers++;
      if (!listedIds.contains(p.id)) missing++;
    }
    return RosterExportScope(
      listed: listed.length,
      publishers: publishers,
      missing: missing,
      extra: listed.where((p) => !present(p)).length,
    );
  }
}

/// The warning both bulk exports show when the list they were started from is
/// not simply "every publisher" — it says what the file will actually hold.
///
/// Shared so the two dialogs can never drift apart. Render it only when
/// [RosterExportScope.isEveryPublisher] is false.
class RosterExportScopeWarning extends StatelessWidget {
  const RosterExportScopeWarning({super.key, required this.scope});

  final RosterExportScope scope;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    // Small type: the card carries four sentences, and at a phone width the
    // dialog's own body has to stay in view behind it.
    final onContainer = (theme.textTheme.bodySmall ?? const TextStyle())
        .copyWith(color: scheme.onErrorContainer);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: scheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning_amber_rounded,
                color: scheme.onErrorContainer, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.pubExportScopeTitle,
                      style: onContainer.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(l10n.pubExportScopeListed(scope.listed),
                      style: onContainer),
                  if (scope.missing > 0)
                    Text(
                        l10n.pubExportScopeMissing(
                            scope.missing, scope.publishers),
                        style: onContainer),
                  if (scope.extra > 0)
                    Text(l10n.pubExportScopeExtra(scope.extra),
                        style: onContainer),
                  const SizedBox(height: 2),
                  Text(l10n.pubExportScopeHint, style: onContainer),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
