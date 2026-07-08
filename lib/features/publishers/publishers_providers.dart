import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/publishers_repository.dart';
import '../../core/data/reports_repository.dart';
import '../../core/firebase/firebase_providers.dart';
import '../../core/models/models.dart';
import '../../core/utils/dates.dart';

final publisherProvider = StreamProvider.family<Publisher?, String>(
    (ref, id) => ref.watch(publishersRepositoryProvider).watchOne(id));

/// Private profile; only requested when the viewer is the publisher
/// themselves or a publishers-admin (rules would deny anyone else).
final publisherPrivateProvider =
    StreamProvider.family<PublisherPrivate?, String>((ref, id) {
  final uid = ref.watch(currentUidProvider);
  final canAdmin = ref.watch(myRolesProvider).canEditPublishers();
  if (uid == null || (uid != id && !canAdmin)) {
    return Stream.value(null);
  }
  return ref.watch(publishersRepositoryProvider).watchPrivate(id);
});

/// Reports of one publisher across a service year (month key -> report).
final serviceYearReportsProvider = FutureProvider.family<
    Map<String, MinistryReport?>,
    ({String publisherId, int year})>((ref, args) {
  return ref
      .watch(reportsRepositoryProvider)
      .getMineForMonths(args.publisherId, serviceYearMonths(args.year));
});
