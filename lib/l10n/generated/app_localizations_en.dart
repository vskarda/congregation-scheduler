// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Congregation Scheduler';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonClose => 'Close';

  @override
  String get commonBack => 'Back';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonError => 'Something went wrong';

  @override
  String commonErrorDetail(String message) {
    return 'Something went wrong: $message';
  }

  @override
  String get commonFieldRequired => 'This field is required';

  @override
  String get commonConfirmDeleteTitle => 'Delete?';

  @override
  String get commonConfirmDeleteBody => 'This cannot be undone.';

  @override
  String get commonToday => 'Today';

  @override
  String get commonAll => 'All';

  @override
  String get commonNone => 'None';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonNotAssigned => '—';

  @override
  String get commonLanguage => 'Language';

  @override
  String get setupTitle => 'Connect to your congregation';

  @override
  String get setupIntro =>
      'This app connects directly to your congregation\'s own database. Paste the configuration you received from your administrator, or scan the invitation QR code.';

  @override
  String get setupConfigLabel => 'Firebase configuration (JSON)';

  @override
  String get setupConfigHint => 'apiKey, authDomain, projectId, …';

  @override
  String get setupScanQr => 'Scan QR code';

  @override
  String get setupPickQrImage => 'Choose QR code photo';

  @override
  String get setupQrNotFoundInImage => 'No QR code was found in that image.';

  @override
  String get setupConnect => 'Connect';

  @override
  String get setupInvalidJson =>
      'This is not valid configuration JSON. It must contain at least apiKey, projectId and appId.';

  @override
  String setupConnectionFailed(String message) {
    return 'Could not connect with this configuration: $message';
  }

  @override
  String get setupModeTitle => 'How do you want to start?';

  @override
  String get setupModeJoin => 'Join my congregation';

  @override
  String get setupModeJoinSubtitle =>
      'An administrator invited you. After registration they will verify your account.';

  @override
  String get setupModeNew => 'Set up a new congregation';

  @override
  String get setupModeNewSubtitle =>
      'You are the first administrator of a freshly created Firebase project.';

  @override
  String get setupCongregationExists =>
      'This congregation is already set up. Choose \"Join my congregation\" instead.';

  @override
  String get setupDatabaseNotReady =>
      'The congregation database is still starting up. Please wait a moment and try again.';

  @override
  String get setupReconfigure => 'Change configuration';

  @override
  String get setupRestartRequired =>
      'Configuration saved. Close and reopen the app to apply it.';

  @override
  String get languageSystem => 'System language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageCzech => 'Čeština';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get profileCompleteTitle => 'Complete your profile';

  @override
  String get profileCompleteBody =>
      'Your account exists but the profile is missing. Enter your name to finish registration.';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authSignOut => 'Sign out';

  @override
  String get authRegister => 'Create account';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordConfirm => 'Confirm password';

  @override
  String get authPasswordsDontMatch => 'Passwords do not match';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authResetSent => 'A password reset e-mail has been sent.';

  @override
  String get authNoAccountYet => 'No account yet? Create one';

  @override
  String get authHaveAccount => 'Already have an account? Sign in';

  @override
  String get authErrorInvalidCredentials => 'Wrong e-mail or password.';

  @override
  String get authErrorEmailInUse =>
      'An account with this e-mail already exists.';

  @override
  String get authErrorWeakPassword =>
      'The password is too weak (at least 6 characters).';

  @override
  String authErrorGeneric(String message) {
    return 'Sign-in failed: $message';
  }

  @override
  String get authFirstName => 'Name';

  @override
  String get authLastName => 'Surname';

  @override
  String get authCongregationName => 'Congregation name';

  @override
  String get awaitingTitle => 'Awaiting verification';

  @override
  String get awaitingBody =>
      'Your account was created. An administrator of the congregation now needs to verify it before you can see any congregation information.';

  @override
  String get navInfoBoard => 'Information board';

  @override
  String get navEvents => 'Events';

  @override
  String get navLmm => 'Life and Ministry';

  @override
  String get navWeekend => 'Weekend meeting';

  @override
  String get navPublicWitnessing => 'Public witnessing';

  @override
  String get navFieldServiceMeetings => 'Meetings for Field Service';

  @override
  String get navTerritories => 'Territories';

  @override
  String get navReport => 'Ministry report';

  @override
  String get navAttendance => 'Attendance';

  @override
  String get navProfile => 'My profile';

  @override
  String get navAdmin => 'Administration';

  @override
  String get navPublishersAdmin => 'Publishers';

  @override
  String get navReportsAdmin => 'Reports overview';

  @override
  String get navS1 => 'S-1 report';

  @override
  String get navTalks => 'Public talk titles';

  @override
  String get navSettings => 'Congregation settings';

  @override
  String get adminToggleHide => 'Hide admin options';

  @override
  String get adminToggleShow => 'Show admin options';

  @override
  String get profilePhone => 'Phone number';

  @override
  String get profileAddress => 'Address';

  @override
  String get profileBirthDate => 'Birth date';

  @override
  String get profileBaptismDate => 'Baptism date';

  @override
  String get profileGender => 'Gender';

  @override
  String get genderUnknown => '—';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get profileHope => 'Hope';

  @override
  String get hopeOtherSheep => 'Other sheep';

  @override
  String get hopeAnointed => 'Anointed';

  @override
  String get profileStatus => 'Service status';

  @override
  String get statusPublisher => 'Publisher';

  @override
  String get statusAuxPioneer => 'Auxiliary pioneer';

  @override
  String get statusRegPioneer => 'Regular pioneer';

  @override
  String get statusSpecialPioneer => 'Special pioneer';

  @override
  String get statusFieldMissionary => 'Field missionary';

  @override
  String get profileAppointment => 'Appointment';

  @override
  String get appointmentMinisterialServant => 'Ministerial servant';

  @override
  String get appointmentElder => 'Elder';

  @override
  String get profileEmergency => 'Emergency note';

  @override
  String get profileEmergencyHint => 'Whom to contact in an emergency';

  @override
  String get profileSaved => 'Saved';

  @override
  String get profileRecord => 'Publisher record';

  @override
  String serviceYear(int year) {
    return 'Service year $year';
  }

  @override
  String get reportMonth => 'Month';

  @override
  String get reportParticipated => 'Shared in the ministry';

  @override
  String get reportStudies => 'Bible studies';

  @override
  String get reportHours => 'Hours';

  @override
  String get reportCredit => 'Credit hours';

  @override
  String get reportComments => 'Comments';

  @override
  String get s21Export => 'Export S-21 (PDF)';

  @override
  String get s21Title => 'CONGREGATION\'S PUBLISHER RECORD';

  @override
  String get s21Name => 'Name:';

  @override
  String get s21DateOfBirth => 'Date of birth:';

  @override
  String get s21DateOfBaptism => 'Date of baptism:';

  @override
  String get s21HoursHeader => 'Hours (If pioneer or field missionary)';

  @override
  String get s21Remarks => 'Remarks';

  @override
  String get s21Total => 'Total';

  @override
  String get s21FormCode => 'S-21-E 11/23';

  @override
  String get pubAdminInvite => 'Invite';

  @override
  String get pubAdminInviteTitle => 'Invite to the congregation';

  @override
  String get pubAdminInviteBody =>
      'The new member scans this QR code in the app, registers, and then appears below as unverified. Verify them to grant access.';

  @override
  String get pubAdminAddRecord => 'Add publisher record';

  @override
  String get pubAdminAddRecordHint =>
      'A record for a member who will not use the app; reports can be entered by admins.';

  @override
  String get pubAdminVerified => 'Verified';

  @override
  String get pubAdminUnverifiedBadge => 'Awaiting verification';

  @override
  String get pubAdminNoAccountBadge => 'No app account';

  @override
  String get pubAdminTabProfile => 'Profile';

  @override
  String get pubAdminTabRoles => 'Rights';

  @override
  String get pubAdminTabAssign => 'Assign';

  @override
  String get pubAdminTabRecord => 'Record';

  @override
  String get pubAdminDeleteConfirm =>
      'Delete this publisher and their private data? Their reports stay stored.';

  @override
  String get pubAdminSelfVerifiedWarningTitle =>
      'Turn off your own Verified status?';

  @override
  String get pubAdminSelfVerifiedWarningBody =>
      'You are removing Verified from your own account. You will immediately lose access to the congregation\'s data, and only another Full Admin will be able to restore it. Are you sure you want to continue?';

  @override
  String get pubAdminSelfFullAdminWarningTitle =>
      'Remove your own Full Admin rights?';

  @override
  String get pubAdminSelfFullAdminWarningBody =>
      'You are removing Full Admin from your own account. If you are the only administrator, no one — including you — will be able to undo this. Are you sure you want to continue?';

  @override
  String get pubAdminSelfWarningConfirm => 'Remove my access';

  @override
  String get roleFullAdmin => 'Full administrator';

  @override
  String get weekNoSchedule => 'No schedule for this week yet.';

  @override
  String get weekCreateEmpty => 'Create empty week';

  @override
  String get weekImportEpub => 'Import from .epub';

  @override
  String get weekCheckCdn => 'Check online';

  @override
  String get weekDelete => 'Delete this week';

  @override
  String get lmmSongs => 'Songs';

  @override
  String get sectionOpening => 'Opening';

  @override
  String get sectionTreasures => 'TREASURES FROM GOD\'S WORD';

  @override
  String get sectionMinistry => 'APPLY YOURSELF TO THE FIELD MINISTRY';

  @override
  String get sectionLiving => 'LIVING AS CHRISTIANS';

  @override
  String get sectionClosing => 'Conclusion';

  @override
  String get partChairman => 'Chairman';

  @override
  String get partOpeningPrayer => 'Opening prayer';

  @override
  String get partClosingPrayer => 'Closing prayer';

  @override
  String get partGems => 'Spiritual gems';

  @override
  String get partBibleReading => 'Bible reading';

  @override
  String get partCbs => 'Congregation Bible Study';

  @override
  String get partCbsReader => 'Reader';

  @override
  String get partAssistant => 'Assistant';

  @override
  String partMinutes(int min) {
    return '$min min';
  }

  @override
  String get lmmClassMain => 'Main hall';

  @override
  String lmmClassN(int index) {
    return 'Class $index';
  }

  @override
  String get partEdit => 'Edit part';

  @override
  String get partTitle => 'Title';

  @override
  String get partDescription => 'Description';

  @override
  String get partDuration => 'Duration (min)';

  @override
  String get partAdd => 'Add part';

  @override
  String get partDeleteConfirm => 'Delete this part?';

  @override
  String get supportAttendants => 'Attendants';

  @override
  String get supportMicrophones => 'Microphones';

  @override
  String get supportAudioVideo => 'Audio/video';

  @override
  String get customAssignmentAdd => 'Add custom assignment';

  @override
  String get customLabel => 'Label';

  @override
  String get pickerQualified => 'Qualified';

  @override
  String get pickerAll => 'All';

  @override
  String get pickerFreeText => 'Text';

  @override
  String pickerLastAssigned(String date) {
    return 'Last: $date';
  }

  @override
  String get pickerNever => 'Never assigned';

  @override
  String get importTitle => 'Import Meeting Workbook';

  @override
  String get importNoWeeks => 'No usable weeks were found in this file.';

  @override
  String get importWeekExists =>
      'Already exists — program will be updated, assignments kept';

  @override
  String importSave(int count) {
    return 'Import $count weeks';
  }

  @override
  String get importDone => 'Imported.';

  @override
  String get importCdnNothing => 'No workbook issue is available online yet.';

  @override
  String get weekendTalkTitle => 'Public talk';

  @override
  String get weekendSpeaker => 'Speaker';

  @override
  String get weekendChairmanLabel => 'Chairman';

  @override
  String get weekendWtReader => 'Watchtower reader';

  @override
  String get customFieldAdd => 'Add program field';

  @override
  String get pickerFromCatalog => 'From list';

  @override
  String get talksUpdateFromPdf => 'Update titles from PDF';

  @override
  String get talksPickPdf => 'Choose S-99 PDF';

  @override
  String get talksParseError =>
      'Could not read talk titles from this file. Use an official S-99 form PDF.';

  @override
  String talksImportSummary(int total, int added, int changed, int removed) {
    return '$total talks found: $added new, $changed changed, $removed removed';
  }

  @override
  String get talksImportSave => 'Save titles';

  @override
  String talksImportDone(int count) {
    return 'Titles saved. $count upcoming meetings updated.';
  }

  @override
  String talksLastDelivered(String date) {
    return 'Last delivered $date';
  }

  @override
  String get talksNeverDelivered => 'Not delivered yet';

  @override
  String get talksScheduled => 'scheduled';

  @override
  String get talksNew => 'New';

  @override
  String get talksChanged => 'Changed';

  @override
  String get talksRemoved => 'Removed';

  @override
  String get talksSearchHint => 'Search talks…';

  @override
  String get talksEmpty => 'No talk titles yet. Import them from an S-99 PDF.';

  @override
  String get talksOpenCatalog => 'Manage talk titles';

  @override
  String get talksEditTitle => 'Edit title';

  @override
  String get pwNoSlots => 'No public witnessing this week.';

  @override
  String get pwAddSlot => 'Add time slot';

  @override
  String get pwEditSlot => 'Edit time slot';

  @override
  String get pwLocation => 'Location';

  @override
  String get pwTimeFrom => 'From';

  @override
  String get pwTimeTo => 'To';

  @override
  String get pwRecurringRules => 'Recurring slots';

  @override
  String get pwRecurringAdd => 'Add recurring slot';

  @override
  String get pwWeekday => 'Day of week';

  @override
  String get pwValidFrom => 'Valid from';

  @override
  String get pwValidUntil => 'Valid until (optional)';

  @override
  String get pwAssignees => 'Assigned';

  @override
  String get pwDate => 'Date';

  @override
  String get fsmNoMeetings => 'No meetings for field service this week.';

  @override
  String get fsmAddMeeting => 'Add meeting';

  @override
  String get fsmEditMeeting => 'Edit meeting';

  @override
  String get fsmDate => 'Date';

  @override
  String get fsmTime => 'Time';

  @override
  String get fsmLocation => 'Place';

  @override
  String get fsmConductor => 'Conductor';

  @override
  String get fsmRecurringRules => 'Recurring meetings';

  @override
  String get fsmRecurringAdd => 'Add recurring meeting';

  @override
  String get fsmWeekday => 'Day of week';

  @override
  String get fsmValidFrom => 'Valid from';

  @override
  String get fsmValidUntil => 'Valid until (optional)';

  @override
  String get eventsUpcoming => 'Upcoming events';

  @override
  String get eventsNone => 'No upcoming events.';

  @override
  String get eventAdd => 'Add event';

  @override
  String get eventEdit => 'Edit event';

  @override
  String get eventTitle => 'Title';

  @override
  String get eventType => 'Type';

  @override
  String get eventTypeConvention => 'Regional convention';

  @override
  String get eventTypeAssembly => 'Circuit assembly';

  @override
  String get eventTypeMemorial => 'Memorial';

  @override
  String get eventTypeCoVisit => 'Circuit overseer\'s visit';

  @override
  String get eventTypeOther => 'Other';

  @override
  String get eventDateFrom => 'From';

  @override
  String get eventDateTo => 'To (optional)';

  @override
  String get eventLocation => 'Location';

  @override
  String get eventNotes => 'Notes';

  @override
  String get eventAddToCalendar => 'Add to calendar';

  @override
  String get myAssignments => 'My upcoming assignments';

  @override
  String get myAssignmentsNone => 'No upcoming assignments.';

  @override
  String get roleAssistant => 'Assistant';

  @override
  String get rolePw => 'Public witnessing';

  @override
  String get roleFsm => 'Meeting for field service';

  @override
  String get reportSubmit => 'Submit report';

  @override
  String reportSubmittedAt(String date) {
    return 'Submitted $date';
  }

  @override
  String get reportSaved => 'Report saved.';

  @override
  String get reportMissing => 'Not submitted';

  @override
  String reportEnterFor(String name) {
    return 'Enter report — $name';
  }

  @override
  String reportSummaryReported(int reported, int total) {
    return 'Reported: $reported / $total';
  }

  @override
  String get attAdd => 'Record attendance';

  @override
  String get attInPerson => 'In person';

  @override
  String get attOnline => 'Online';

  @override
  String get attTotal => 'Total';

  @override
  String get attMeetingLmm => 'Life and Ministry';

  @override
  String get attMeetingWeekend => 'Weekend meeting';

  @override
  String get attOverview => 'Monthly averages';

  @override
  String get attRecent => 'Recent meetings';

  @override
  String get attSaved => 'Attendance saved.';

  @override
  String get terrMine => 'My territories';

  @override
  String get terrNoMine => 'No territories assigned to you.';

  @override
  String get terrAll => 'All territories';

  @override
  String terrAssignedOn(String date) {
    return 'Assigned $date';
  }

  @override
  String get terrReturn => 'Return';

  @override
  String get terrReturnTitle => 'Return territory';

  @override
  String get terrReturnNotes => 'Notes (optional)';

  @override
  String get terrMap => 'Map';

  @override
  String get terrAdd => 'Add territory';

  @override
  String get terrEdit => 'Edit territory';

  @override
  String get terrName => 'Name';

  @override
  String get terrNumber => 'Number';

  @override
  String get terrMapUrl => 'Map link (e.g. Google My Maps)';

  @override
  String get terrNotes => 'Notes';

  @override
  String get terrAssignTo => 'Assign to…';

  @override
  String terrHolder(String name, String date) {
    return '$name — since $date';
  }

  @override
  String get terrFree => 'Not assigned';

  @override
  String get terrStats => 'Statistics';

  @override
  String get terrStatsTotal => 'Total';

  @override
  String get terrStatsAssigned => 'Currently assigned';

  @override
  String get terrStatsFinished => 'Finished in period';

  @override
  String get terrRemoveAssignment => 'Remove assignment';

  @override
  String get infoEmpty => 'No information right now.';

  @override
  String get infoAddText => 'Add text';

  @override
  String get infoAddFile => 'Upload file (PDF/image)';

  @override
  String get infoAddLink => 'Add link';

  @override
  String get infoTitle => 'Title';

  @override
  String get infoBody => 'Text';

  @override
  String get infoUrl => 'Link (URL)';

  @override
  String get infoShowFrom => 'Show from (optional)';

  @override
  String get infoShowUntil => 'Show until (optional)';

  @override
  String get infoFileTooLarge =>
      'The file is too large (max 10 MB). Share it as a link instead.';

  @override
  String get infoHidden => 'Currently hidden (outside its visibility window)';

  @override
  String get infoDownloading => 'Loading file…';

  @override
  String get infoEditItem => 'Edit item';

  @override
  String get s1Active =>
      'All active publishers (reported at least once in the last 6 months)';

  @override
  String get s1AvgMid => 'Average attendance — midweek meeting';

  @override
  String get s1AvgWeekend => 'Average attendance — weekend meeting';

  @override
  String get s1Publishers => 'Publishers';

  @override
  String get s1AuxPioneers => 'Auxiliary pioneers';

  @override
  String get s1RegPioneers => 'Regular pioneers';

  @override
  String get s1Count => 'Number of';

  @override
  String get s1Studies => 'Bible studies';

  @override
  String get s1Hours => 'Hours (total)';

  @override
  String get s1Note =>
      'Auxiliary, regular and special pioneers are not counted in the Publishers group; special pioneers are not included in any group.';

  @override
  String get settingsName => 'Congregation name';

  @override
  String get settingsLmmMeeting => 'Midweek meeting (day and time)';

  @override
  String get settingsLmmClassCount => 'Midweek meeting classes';

  @override
  String get settingsWeekendMeeting => 'Weekend meeting (day and time)';

  @override
  String get qSupportSection => 'Meeting support and other';

  @override
  String get qChairman => 'Chairman (midweek)';

  @override
  String get qPrayer => 'Prayer';

  @override
  String get qTreasures => 'Treasures from God\'s Word';

  @override
  String get qGems => 'Spiritual gems';

  @override
  String get qBibleReading => 'Bible reading';

  @override
  String get qFieldMinistry => 'Student assignments (ministry)';

  @override
  String get qLiving => 'Living as Christians parts';

  @override
  String get qCbsConductor => 'Congregation Bible Study conductor';

  @override
  String get qCbsReader => 'CBS reader';

  @override
  String get qPublicTalk => 'Public talk';

  @override
  String get qWeekendChairman => 'Chairman (weekend)';

  @override
  String get qWtReader => 'Watchtower reader';

  @override
  String get qAttendant => 'Attendant';

  @override
  String get qMicrophone => 'Microphones';

  @override
  String get qAudioVideo => 'Audio/video';

  @override
  String get qPublicWitnessing => 'Public witnessing';

  @override
  String get qMinistryMeetingConductor => 'Ministry meeting conductor';
}
