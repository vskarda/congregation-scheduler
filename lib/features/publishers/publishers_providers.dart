import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/data/reports_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';

final publisherProvider = StreamProvider.family<Publisher?, String>(
    (ref, id) => ref.watch(publishersRepositoryProvider).watchOne(id));

/// Whether this viewer may read [id]'s private profile: themselves, or a
/// publishers-admin. Shared by the two providers below so the streaming and
/// the one-shot form can never drift apart; `/admin/publishers/:id` carries no
/// route guard, so this is what keeps a denied read from being attempted.
bool _mayReadPrivate(Ref ref, String id) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return false;
  return uid == id || ref.watch(myRolesProvider).canEditPublishers();
}

/// Private profile; only requested when the viewer is the publisher
/// themselves or a publishers-admin (rules would deny anyone else).
final publisherPrivateProvider =
    StreamProvider.family<PublisherPrivate?, String>((ref, id) {
  if (!_mayReadPrivate(ref, id)) return Stream.value(null);
  return ref.watch(publishersRepositoryProvider).watchPrivate(id);
});

/// One-shot twin of [publisherPrivateProvider], for callbacks that need the
/// profile once (the S-21 export on the record tab).
///
/// A StreamProvider's `.future` only completes while something is listening to
/// it — an unlistened provider is disposed before the first snapshot arrives,
/// and the await then never returns. The record tab listens to no private
/// profile, so it must not await the streaming one. Same permission guard, one
/// document read instead of a subscription.
final publisherPrivateOnceProvider =
    FutureProvider.family<PublisherPrivate?, String>((ref, id) async {
  if (!_mayReadPrivate(ref, id)) return null;
  return ref.watch(publishersRepositoryProvider).getPrivate(id);
});

/// Reports of one publisher across a service year (month key -> report).
final serviceYearReportsProvider = FutureProvider.family<
    Map<String, MinistryReport?>,
    ({String publisherId, int year})>((ref, args) {
  return ref
      .watch(reportsRepositoryProvider)
      .getMineForMonths(args.publisherId, serviceYearMonths(args.year));
});
