import '../models/enums.dart';
import 'l10n.dart';

String statusLabel(AppLocalizations l10n, PublisherStatus status) =>
    switch (status) {
      PublisherStatus.publisher => l10n.statusPublisher,
      PublisherStatus.auxiliaryPioneer => l10n.statusAuxPioneer,
      PublisherStatus.regularPioneer => l10n.statusRegPioneer,
      PublisherStatus.specialPioneer => l10n.statusSpecialPioneer,
    };

String genderLabel(AppLocalizations l10n, Gender gender) => switch (gender) {
      Gender.unknown => l10n.genderUnknown,
      Gender.male => l10n.genderMale,
      Gender.female => l10n.genderFemale,
    };
