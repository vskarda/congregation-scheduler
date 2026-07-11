import '../models/enums.dart';
import 'l10n.dart';

String statusLabel(AppLocalizations l10n, PublisherStatus status) =>
    switch (status) {
      PublisherStatus.publisher => l10n.statusPublisher,
      PublisherStatus.auxiliaryPioneer => l10n.statusAuxPioneer,
      PublisherStatus.regularPioneer => l10n.statusRegPioneer,
      PublisherStatus.specialPioneer => l10n.statusSpecialPioneer,
      PublisherStatus.fieldMissionary => l10n.statusFieldMissionary,
    };

String hopeLabel(AppLocalizations l10n, Hope hope) => switch (hope) {
      Hope.otherSheep => l10n.hopeOtherSheep,
      Hope.anointed => l10n.hopeAnointed,
    };

String appointmentLabel(AppLocalizations l10n, Appointment appointment) =>
    switch (appointment) {
      Appointment.none => l10n.commonNone,
      Appointment.ministerialServant => l10n.appointmentMinisterialServant,
      Appointment.elder => l10n.appointmentElder,
    };

String genderLabel(AppLocalizations l10n, Gender gender) => switch (gender) {
      Gender.unknown => l10n.genderUnknown,
      Gender.male => l10n.genderMale,
      Gender.female => l10n.genderFemale,
    };

String lmmSectionLabel(AppLocalizations l10n, LmmSection s) => switch (s) {
      LmmSection.opening => l10n.sectionOpening,
      LmmSection.treasures => l10n.sectionTreasures,
      LmmSection.ministry => l10n.sectionMinistry,
      LmmSection.living => l10n.sectionLiving,
      LmmSection.closing => l10n.sectionClosing,
    };
