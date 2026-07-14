import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/publishers_repository.dart';
import '../../../core/data/reports_repository.dart';
import '../../../core/models/models.dart';
import 's21_import_parser.dart';

/// Applies a parsed S-21 to Firestore: profile fields and monthly reports
/// are replaced with the imported values ("S-21 wins"); header values the
/// parser could not find keep the app's current value. Requires the
/// publishers role (profile writes) and the reports role (report writes).
class S21ImportService {
  S21ImportService(this._publishers, this._reports);

  final PublishersRepository _publishers;
  final ReportsRepository _reports;

  /// Imports [data] into [existing], or creates a new record when it is
  /// null. [firstName]/[lastName] are resolved by the caller — the app's
  /// name for an existing publisher, the (possibly corrected) S-21 name for
  /// a new one. [blockYears] resolves each parsed year block to a service
  /// year (nulls in the file are filled in by the admin on the preview).
  /// Returns the publisher id.
  Future<String> import({
    required S21Import data,
    Publisher? existing,
    PublisherPrivate? existingPrivate,
    required String firstName,
    required String lastName,
    required List<int> blockYears,
    required String enteredBy,
  }) async {
    assert(blockYears.length == data.years.length);

    var publisher =
        (existing ?? const Publisher(verified: true, hasAccount: false))
            .copyWith(firstName: firstName, lastName: lastName);
    if (data.gender != null) {
      publisher = publisher.copyWith(gender: data.gender!);
    }
    if (data.status != null) {
      publisher = publisher.copyWith(status: data.status!);
    }

    final String id;
    if (existing == null) {
      id = await _publishers.create(publisher);
    } else {
      id = existing.id;
      await _publishers.update(publisher);
    }

    final priv = existingPrivate ?? const PublisherPrivate();
    await _publishers.setPrivate(
      id,
      priv.copyWith(
        birthDate: data.birthDate ?? priv.birthDate,
        baptismDate: data.baptismDate ?? priv.baptismDate,
        hope: data.hope ?? priv.hope,
        appointment: data.appointment ?? priv.appointment,
      ),
    );

    final status = data.status ?? existing?.status ?? PublisherStatus.publisher;
    final now = DateTime.now();
    final reports = <MinistryReport>[
      for (var b = 0; b < data.years.length; b++)
        for (final row in data.years[b].rows)
          MinistryReport(
            publisherId: id,
            month: s21MonthKey(blockYears[b], row.month),
            participated: row.participated,
            bibleStudies: row.bibleStudies,
            hours: row.hours,
            creditHours: row.creditHours,
            comments: row.comments,
            statusAtMonth: row.auxPioneer
                ? PublisherStatus.auxiliaryPioneer
                : status,
            submittedAt: now,
            enteredBy: enteredBy,
          ),
    ];
    await _reports.submitMany(reports);
    return id;
  }
}

final s21ImportServiceProvider = Provider<S21ImportService>(
  (ref) => S21ImportService(
    ref.watch(publishersRepositoryProvider),
    ref.watch(reportsRepositoryProvider),
  ),
);
