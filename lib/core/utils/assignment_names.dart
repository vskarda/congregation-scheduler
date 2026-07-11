import '../models/models.dart';

/// Plain-text form of an assignment for PDFs/exports: resolved publisher
/// names plus free text, or an em dash when empty. Mirrors the rich-text
/// rendering of `AssignmentText`.
String formatAssignmentNames(Assignment a, Map<String, Publisher> byId) {
  if (a.isEmpty) return '—';
  final parts = <String>[
    for (final id in a.publisherIds) byId[id]?.fullName ?? '…',
    if (a.freeText.trim().isNotEmpty) a.freeText.trim(),
  ];
  return parts.join(', ');
}
