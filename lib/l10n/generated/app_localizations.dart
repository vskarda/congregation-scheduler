import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Congregation Scheduler'**
  String get appTitle;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonError;

  /// No description provided for @commonErrorDetail.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {message}'**
  String commonErrorDetail(String message);

  /// No description provided for @commonFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get commonFieldRequired;

  /// No description provided for @commonConfirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get commonConfirmDeleteTitle;

  /// No description provided for @commonConfirmDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get commonConfirmDeleteBody;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get commonNone;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonNotAssigned.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get commonNotAssigned;

  /// No description provided for @commonLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get commonLanguage;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect to your congregation'**
  String get setupTitle;

  /// No description provided for @setupIntro.
  ///
  /// In en, this message translates to:
  /// **'This app connects directly to your congregation\'s own database. Paste the configuration you received from your administrator, or scan the invitation QR code.'**
  String get setupIntro;

  /// No description provided for @setupConfigLabel.
  ///
  /// In en, this message translates to:
  /// **'Firebase configuration (JSON)'**
  String get setupConfigLabel;

  /// No description provided for @setupConfigHint.
  ///
  /// In en, this message translates to:
  /// **'apiKey, authDomain, projectId, …'**
  String get setupConfigHint;

  /// No description provided for @setupScanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get setupScanQr;

  /// No description provided for @setupPickQrImage.
  ///
  /// In en, this message translates to:
  /// **'Choose QR code photo'**
  String get setupPickQrImage;

  /// No description provided for @setupQrNotFoundInImage.
  ///
  /// In en, this message translates to:
  /// **'No QR code was found in that image.'**
  String get setupQrNotFoundInImage;

  /// No description provided for @setupConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get setupConnect;

  /// No description provided for @setupInvalidJson.
  ///
  /// In en, this message translates to:
  /// **'This is not valid configuration JSON. It must contain at least apiKey, projectId and appId.'**
  String get setupInvalidJson;

  /// No description provided for @setupConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not connect with this configuration: {message}'**
  String setupConnectionFailed(String message);

  /// No description provided for @setupModeTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you want to start?'**
  String get setupModeTitle;

  /// No description provided for @setupModeJoin.
  ///
  /// In en, this message translates to:
  /// **'Join my congregation'**
  String get setupModeJoin;

  /// No description provided for @setupModeJoinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'An administrator invited you. After registration they will verify your account.'**
  String get setupModeJoinSubtitle;

  /// No description provided for @setupModeNew.
  ///
  /// In en, this message translates to:
  /// **'Set up a new congregation'**
  String get setupModeNew;

  /// No description provided for @setupModeNewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You are the first administrator of a freshly created Firebase project.'**
  String get setupModeNewSubtitle;

  /// No description provided for @setupCongregationExists.
  ///
  /// In en, this message translates to:
  /// **'This congregation is already set up. Choose \"Join my congregation\" instead.'**
  String get setupCongregationExists;

  /// No description provided for @setupReconfigure.
  ///
  /// In en, this message translates to:
  /// **'Change configuration'**
  String get setupReconfigure;

  /// No description provided for @setupRestartRequired.
  ///
  /// In en, this message translates to:
  /// **'Configuration saved. Close and reopen the app to apply it.'**
  String get setupRestartRequired;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageCzech.
  ///
  /// In en, this message translates to:
  /// **'Čeština'**
  String get languageCzech;

  /// No description provided for @profileCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get profileCompleteTitle;

  /// No description provided for @profileCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'Your account exists but the profile is missing. Enter your name to finish registration.'**
  String get profileCompleteBody;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get authSignOut;

  /// No description provided for @authRegister.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authRegister;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authPasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authPasswordConfirm;

  /// No description provided for @authPasswordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordsDontMatch;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authResetSent.
  ///
  /// In en, this message translates to:
  /// **'A password reset e-mail has been sent.'**
  String get authResetSent;

  /// No description provided for @authNoAccountYet.
  ///
  /// In en, this message translates to:
  /// **'No account yet? Create one'**
  String get authNoAccountYet;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get authHaveAccount;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong e-mail or password.'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account with this e-mail already exists.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak (at least 6 characters).'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed: {message}'**
  String authErrorGeneric(String message);

  /// No description provided for @authFirstName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get authFirstName;

  /// No description provided for @authLastName.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get authLastName;

  /// No description provided for @authCongregationName.
  ///
  /// In en, this message translates to:
  /// **'Congregation name'**
  String get authCongregationName;

  /// No description provided for @awaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'Awaiting verification'**
  String get awaitingTitle;

  /// No description provided for @awaitingBody.
  ///
  /// In en, this message translates to:
  /// **'Your account was created. An administrator of the congregation now needs to verify it before you can see any congregation information.'**
  String get awaitingBody;

  /// No description provided for @navInfoBoard.
  ///
  /// In en, this message translates to:
  /// **'Information board'**
  String get navInfoBoard;

  /// No description provided for @navEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get navEvents;

  /// No description provided for @navLmm.
  ///
  /// In en, this message translates to:
  /// **'Life and Ministry'**
  String get navLmm;

  /// No description provided for @navWeekend.
  ///
  /// In en, this message translates to:
  /// **'Weekend meeting'**
  String get navWeekend;

  /// No description provided for @navPublicWitnessing.
  ///
  /// In en, this message translates to:
  /// **'Public witnessing'**
  String get navPublicWitnessing;

  /// No description provided for @navTerritories.
  ///
  /// In en, this message translates to:
  /// **'Territories'**
  String get navTerritories;

  /// No description provided for @navReport.
  ///
  /// In en, this message translates to:
  /// **'Ministry report'**
  String get navReport;

  /// No description provided for @navAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get navAttendance;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get navProfile;

  /// No description provided for @navAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get navAdmin;

  /// No description provided for @navPublishersAdmin.
  ///
  /// In en, this message translates to:
  /// **'Publishers'**
  String get navPublishersAdmin;

  /// No description provided for @navReportsAdmin.
  ///
  /// In en, this message translates to:
  /// **'Reports overview'**
  String get navReportsAdmin;

  /// No description provided for @navS1.
  ///
  /// In en, this message translates to:
  /// **'S-1 report'**
  String get navS1;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Congregation settings'**
  String get navSettings;

  /// No description provided for @adminToggleHide.
  ///
  /// In en, this message translates to:
  /// **'Hide admin options'**
  String get adminToggleHide;

  /// No description provided for @adminToggleShow.
  ///
  /// In en, this message translates to:
  /// **'Show admin options'**
  String get adminToggleShow;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get profilePhone;

  /// No description provided for @profileAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profileAddress;

  /// No description provided for @profileBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth date'**
  String get profileBirthDate;

  /// No description provided for @profileGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileGender;

  /// No description provided for @genderUnknown.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get genderUnknown;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @profileStatus.
  ///
  /// In en, this message translates to:
  /// **'Service status'**
  String get profileStatus;

  /// No description provided for @statusPublisher.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get statusPublisher;

  /// No description provided for @statusAuxPioneer.
  ///
  /// In en, this message translates to:
  /// **'Auxiliary pioneer'**
  String get statusAuxPioneer;

  /// No description provided for @statusRegPioneer.
  ///
  /// In en, this message translates to:
  /// **'Regular pioneer'**
  String get statusRegPioneer;

  /// No description provided for @statusSpecialPioneer.
  ///
  /// In en, this message translates to:
  /// **'Special pioneer'**
  String get statusSpecialPioneer;

  /// No description provided for @profileEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency note'**
  String get profileEmergency;

  /// No description provided for @profileEmergencyHint.
  ///
  /// In en, this message translates to:
  /// **'Whom to contact in an emergency'**
  String get profileEmergencyHint;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get profileSaved;

  /// No description provided for @profileRecord.
  ///
  /// In en, this message translates to:
  /// **'Publisher record'**
  String get profileRecord;

  /// No description provided for @serviceYear.
  ///
  /// In en, this message translates to:
  /// **'Service year {year}'**
  String serviceYear(int year);

  /// No description provided for @reportMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get reportMonth;

  /// No description provided for @reportParticipated.
  ///
  /// In en, this message translates to:
  /// **'Shared in the ministry'**
  String get reportParticipated;

  /// No description provided for @reportStudies.
  ///
  /// In en, this message translates to:
  /// **'Bible studies'**
  String get reportStudies;

  /// No description provided for @reportHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get reportHours;

  /// No description provided for @reportCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit hours'**
  String get reportCredit;

  /// No description provided for @reportComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get reportComments;

  /// No description provided for @pubAdminInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get pubAdminInvite;

  /// No description provided for @pubAdminInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite to the congregation'**
  String get pubAdminInviteTitle;

  /// No description provided for @pubAdminInviteBody.
  ///
  /// In en, this message translates to:
  /// **'The new member scans this QR code in the app, registers, and then appears below as unverified. Verify them to grant access.'**
  String get pubAdminInviteBody;

  /// No description provided for @pubAdminAddRecord.
  ///
  /// In en, this message translates to:
  /// **'Add publisher record'**
  String get pubAdminAddRecord;

  /// No description provided for @pubAdminAddRecordHint.
  ///
  /// In en, this message translates to:
  /// **'A record for a member who will not use the app; reports can be entered by admins.'**
  String get pubAdminAddRecordHint;

  /// No description provided for @pubAdminVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get pubAdminVerified;

  /// No description provided for @pubAdminUnverifiedBadge.
  ///
  /// In en, this message translates to:
  /// **'Awaiting verification'**
  String get pubAdminUnverifiedBadge;

  /// No description provided for @pubAdminNoAccountBadge.
  ///
  /// In en, this message translates to:
  /// **'No app account'**
  String get pubAdminNoAccountBadge;

  /// No description provided for @pubAdminTabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get pubAdminTabProfile;

  /// No description provided for @pubAdminTabRoles.
  ///
  /// In en, this message translates to:
  /// **'Rights'**
  String get pubAdminTabRoles;

  /// No description provided for @pubAdminTabAssign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get pubAdminTabAssign;

  /// No description provided for @pubAdminTabRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get pubAdminTabRecord;

  /// No description provided for @pubAdminDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this publisher and their private data? Their reports stay stored.'**
  String get pubAdminDeleteConfirm;

  /// No description provided for @pubAdminSelfVerifiedWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off your own Verified status?'**
  String get pubAdminSelfVerifiedWarningTitle;

  /// No description provided for @pubAdminSelfVerifiedWarningBody.
  ///
  /// In en, this message translates to:
  /// **'You are removing Verified from your own account. You will immediately lose access to the congregation\'s data, and only another Full Admin will be able to restore it. Are you sure you want to continue?'**
  String get pubAdminSelfVerifiedWarningBody;

  /// No description provided for @pubAdminSelfFullAdminWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove your own Full Admin rights?'**
  String get pubAdminSelfFullAdminWarningTitle;

  /// No description provided for @pubAdminSelfFullAdminWarningBody.
  ///
  /// In en, this message translates to:
  /// **'You are removing Full Admin from your own account. If you are the only administrator, no one — including you — will be able to undo this. Are you sure you want to continue?'**
  String get pubAdminSelfFullAdminWarningBody;

  /// No description provided for @pubAdminSelfWarningConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove my access'**
  String get pubAdminSelfWarningConfirm;

  /// No description provided for @roleFullAdmin.
  ///
  /// In en, this message translates to:
  /// **'Full administrator'**
  String get roleFullAdmin;

  /// No description provided for @weekNoSchedule.
  ///
  /// In en, this message translates to:
  /// **'No schedule for this week yet.'**
  String get weekNoSchedule;

  /// No description provided for @weekCreateEmpty.
  ///
  /// In en, this message translates to:
  /// **'Create empty week'**
  String get weekCreateEmpty;

  /// No description provided for @weekImportEpub.
  ///
  /// In en, this message translates to:
  /// **'Import from .epub'**
  String get weekImportEpub;

  /// No description provided for @weekCheckCdn.
  ///
  /// In en, this message translates to:
  /// **'Check online'**
  String get weekCheckCdn;

  /// No description provided for @weekDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete this week'**
  String get weekDelete;

  /// No description provided for @lmmSongs.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get lmmSongs;

  /// No description provided for @sectionOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening'**
  String get sectionOpening;

  /// No description provided for @sectionTreasures.
  ///
  /// In en, this message translates to:
  /// **'TREASURES FROM GOD\'S WORD'**
  String get sectionTreasures;

  /// No description provided for @sectionMinistry.
  ///
  /// In en, this message translates to:
  /// **'APPLY YOURSELF TO THE FIELD MINISTRY'**
  String get sectionMinistry;

  /// No description provided for @sectionLiving.
  ///
  /// In en, this message translates to:
  /// **'LIVING AS CHRISTIANS'**
  String get sectionLiving;

  /// No description provided for @sectionClosing.
  ///
  /// In en, this message translates to:
  /// **'Conclusion'**
  String get sectionClosing;

  /// No description provided for @partChairman.
  ///
  /// In en, this message translates to:
  /// **'Chairman'**
  String get partChairman;

  /// No description provided for @partOpeningPrayer.
  ///
  /// In en, this message translates to:
  /// **'Opening prayer'**
  String get partOpeningPrayer;

  /// No description provided for @partClosingPrayer.
  ///
  /// In en, this message translates to:
  /// **'Closing prayer'**
  String get partClosingPrayer;

  /// No description provided for @partGems.
  ///
  /// In en, this message translates to:
  /// **'Spiritual gems'**
  String get partGems;

  /// No description provided for @partBibleReading.
  ///
  /// In en, this message translates to:
  /// **'Bible reading'**
  String get partBibleReading;

  /// No description provided for @partCbs.
  ///
  /// In en, this message translates to:
  /// **'Congregation Bible Study'**
  String get partCbs;

  /// No description provided for @partCbsReader.
  ///
  /// In en, this message translates to:
  /// **'Reader'**
  String get partCbsReader;

  /// No description provided for @partAssistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get partAssistant;

  /// No description provided for @partMinutes.
  ///
  /// In en, this message translates to:
  /// **'{min} min'**
  String partMinutes(int min);

  /// No description provided for @partEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit part'**
  String get partEdit;

  /// No description provided for @partTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get partTitle;

  /// No description provided for @partDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get partDescription;

  /// No description provided for @partDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration (min)'**
  String get partDuration;

  /// No description provided for @partAdd.
  ///
  /// In en, this message translates to:
  /// **'Add part'**
  String get partAdd;

  /// No description provided for @partDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this part?'**
  String get partDeleteConfirm;

  /// No description provided for @supportAttendants.
  ///
  /// In en, this message translates to:
  /// **'Attendants'**
  String get supportAttendants;

  /// No description provided for @supportMicrophones.
  ///
  /// In en, this message translates to:
  /// **'Microphones'**
  String get supportMicrophones;

  /// No description provided for @supportAudioVideo.
  ///
  /// In en, this message translates to:
  /// **'Audio/video'**
  String get supportAudioVideo;

  /// No description provided for @customAssignmentAdd.
  ///
  /// In en, this message translates to:
  /// **'Add custom assignment'**
  String get customAssignmentAdd;

  /// No description provided for @customLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get customLabel;

  /// No description provided for @pickerQualified.
  ///
  /// In en, this message translates to:
  /// **'Qualified'**
  String get pickerQualified;

  /// No description provided for @pickerAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get pickerAll;

  /// No description provided for @pickerFreeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get pickerFreeText;

  /// No description provided for @pickerLastAssigned.
  ///
  /// In en, this message translates to:
  /// **'Last: {date}'**
  String pickerLastAssigned(String date);

  /// No description provided for @pickerNever.
  ///
  /// In en, this message translates to:
  /// **'Never assigned'**
  String get pickerNever;

  /// No description provided for @importTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Meeting Workbook'**
  String get importTitle;

  /// No description provided for @importPickFile.
  ///
  /// In en, this message translates to:
  /// **'Choose .epub file'**
  String get importPickFile;

  /// No description provided for @importNoWeeks.
  ///
  /// In en, this message translates to:
  /// **'No usable weeks were found in this file.'**
  String get importNoWeeks;

  /// No description provided for @importWeekExists.
  ///
  /// In en, this message translates to:
  /// **'Already exists — program will be updated, assignments kept'**
  String get importWeekExists;

  /// No description provided for @importSave.
  ///
  /// In en, this message translates to:
  /// **'Import {count} weeks'**
  String importSave(int count);

  /// No description provided for @importDone.
  ///
  /// In en, this message translates to:
  /// **'Imported.'**
  String get importDone;

  /// No description provided for @importCdnNothing.
  ///
  /// In en, this message translates to:
  /// **'No workbook issue is available online yet.'**
  String get importCdnNothing;

  /// No description provided for @weekendTalkTitle.
  ///
  /// In en, this message translates to:
  /// **'Public talk'**
  String get weekendTalkTitle;

  /// No description provided for @weekendSpeaker.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get weekendSpeaker;

  /// No description provided for @weekendChairmanLabel.
  ///
  /// In en, this message translates to:
  /// **'Chairman'**
  String get weekendChairmanLabel;

  /// No description provided for @weekendWtReader.
  ///
  /// In en, this message translates to:
  /// **'Watchtower reader'**
  String get weekendWtReader;

  /// No description provided for @customFieldAdd.
  ///
  /// In en, this message translates to:
  /// **'Add program field'**
  String get customFieldAdd;

  /// No description provided for @pwNoSlots.
  ///
  /// In en, this message translates to:
  /// **'No public witnessing this week.'**
  String get pwNoSlots;

  /// No description provided for @pwAddSlot.
  ///
  /// In en, this message translates to:
  /// **'Add time slot'**
  String get pwAddSlot;

  /// No description provided for @pwEditSlot.
  ///
  /// In en, this message translates to:
  /// **'Edit time slot'**
  String get pwEditSlot;

  /// No description provided for @pwLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get pwLocation;

  /// No description provided for @pwTimeFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get pwTimeFrom;

  /// No description provided for @pwTimeTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get pwTimeTo;

  /// No description provided for @pwRecurringRules.
  ///
  /// In en, this message translates to:
  /// **'Recurring slots'**
  String get pwRecurringRules;

  /// No description provided for @pwRecurringAdd.
  ///
  /// In en, this message translates to:
  /// **'Add recurring slot'**
  String get pwRecurringAdd;

  /// No description provided for @pwWeekday.
  ///
  /// In en, this message translates to:
  /// **'Day of week'**
  String get pwWeekday;

  /// No description provided for @pwValidFrom.
  ///
  /// In en, this message translates to:
  /// **'Valid from'**
  String get pwValidFrom;

  /// No description provided for @pwValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until (optional)'**
  String get pwValidUntil;

  /// No description provided for @pwAssignees.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get pwAssignees;

  /// No description provided for @pwDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get pwDate;

  /// No description provided for @eventsUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming events'**
  String get eventsUpcoming;

  /// No description provided for @eventsNone.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events.'**
  String get eventsNone;

  /// No description provided for @eventAdd.
  ///
  /// In en, this message translates to:
  /// **'Add event'**
  String get eventAdd;

  /// No description provided for @eventEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get eventEdit;

  /// No description provided for @eventTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get eventTitle;

  /// No description provided for @eventType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get eventType;

  /// No description provided for @eventTypeConvention.
  ///
  /// In en, this message translates to:
  /// **'Regional convention'**
  String get eventTypeConvention;

  /// No description provided for @eventTypeAssembly.
  ///
  /// In en, this message translates to:
  /// **'Circuit assembly'**
  String get eventTypeAssembly;

  /// No description provided for @eventTypeMemorial.
  ///
  /// In en, this message translates to:
  /// **'Memorial'**
  String get eventTypeMemorial;

  /// No description provided for @eventTypeCoVisit.
  ///
  /// In en, this message translates to:
  /// **'Circuit overseer\'s visit'**
  String get eventTypeCoVisit;

  /// No description provided for @eventTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get eventTypeOther;

  /// No description provided for @eventDateFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get eventDateFrom;

  /// No description provided for @eventDateTo.
  ///
  /// In en, this message translates to:
  /// **'To (optional)'**
  String get eventDateTo;

  /// No description provided for @eventLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get eventLocation;

  /// No description provided for @eventNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get eventNotes;

  /// No description provided for @myAssignments.
  ///
  /// In en, this message translates to:
  /// **'My upcoming assignments'**
  String get myAssignments;

  /// No description provided for @myAssignmentsNone.
  ///
  /// In en, this message translates to:
  /// **'No upcoming assignments.'**
  String get myAssignmentsNone;

  /// No description provided for @roleAssistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get roleAssistant;

  /// No description provided for @rolePw.
  ///
  /// In en, this message translates to:
  /// **'Public witnessing'**
  String get rolePw;

  /// No description provided for @reportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit report'**
  String get reportSubmit;

  /// No description provided for @reportSubmittedAt.
  ///
  /// In en, this message translates to:
  /// **'Submitted {date}'**
  String reportSubmittedAt(String date);

  /// No description provided for @reportSaved.
  ///
  /// In en, this message translates to:
  /// **'Report saved.'**
  String get reportSaved;

  /// No description provided for @reportMissing.
  ///
  /// In en, this message translates to:
  /// **'Not submitted'**
  String get reportMissing;

  /// No description provided for @reportEnterFor.
  ///
  /// In en, this message translates to:
  /// **'Enter report — {name}'**
  String reportEnterFor(String name);

  /// No description provided for @reportSummaryReported.
  ///
  /// In en, this message translates to:
  /// **'Reported: {reported} / {total}'**
  String reportSummaryReported(int reported, int total);

  /// No description provided for @attAdd.
  ///
  /// In en, this message translates to:
  /// **'Record attendance'**
  String get attAdd;

  /// No description provided for @attInPerson.
  ///
  /// In en, this message translates to:
  /// **'In person'**
  String get attInPerson;

  /// No description provided for @attOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get attOnline;

  /// No description provided for @attTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get attTotal;

  /// No description provided for @attMeetingLmm.
  ///
  /// In en, this message translates to:
  /// **'Life and Ministry'**
  String get attMeetingLmm;

  /// No description provided for @attMeetingWeekend.
  ///
  /// In en, this message translates to:
  /// **'Weekend meeting'**
  String get attMeetingWeekend;

  /// No description provided for @attOverview.
  ///
  /// In en, this message translates to:
  /// **'Monthly averages'**
  String get attOverview;

  /// No description provided for @attRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent meetings'**
  String get attRecent;

  /// No description provided for @attSaved.
  ///
  /// In en, this message translates to:
  /// **'Attendance saved.'**
  String get attSaved;

  /// No description provided for @terrMine.
  ///
  /// In en, this message translates to:
  /// **'My territories'**
  String get terrMine;

  /// No description provided for @terrNoMine.
  ///
  /// In en, this message translates to:
  /// **'No territories assigned to you.'**
  String get terrNoMine;

  /// No description provided for @terrAll.
  ///
  /// In en, this message translates to:
  /// **'All territories'**
  String get terrAll;

  /// No description provided for @terrAssignedOn.
  ///
  /// In en, this message translates to:
  /// **'Assigned {date}'**
  String terrAssignedOn(String date);

  /// No description provided for @terrReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get terrReturn;

  /// No description provided for @terrReturnTitle.
  ///
  /// In en, this message translates to:
  /// **'Return territory'**
  String get terrReturnTitle;

  /// No description provided for @terrReturnNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get terrReturnNotes;

  /// No description provided for @terrMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get terrMap;

  /// No description provided for @terrAdd.
  ///
  /// In en, this message translates to:
  /// **'Add territory'**
  String get terrAdd;

  /// No description provided for @terrEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit territory'**
  String get terrEdit;

  /// No description provided for @terrName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get terrName;

  /// No description provided for @terrNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get terrNumber;

  /// No description provided for @terrMapUrl.
  ///
  /// In en, this message translates to:
  /// **'Map link (e.g. Google My Maps)'**
  String get terrMapUrl;

  /// No description provided for @terrNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get terrNotes;

  /// No description provided for @terrAssignTo.
  ///
  /// In en, this message translates to:
  /// **'Assign to…'**
  String get terrAssignTo;

  /// No description provided for @terrHolder.
  ///
  /// In en, this message translates to:
  /// **'{name} — since {date}'**
  String terrHolder(String name, String date);

  /// No description provided for @terrFree.
  ///
  /// In en, this message translates to:
  /// **'Not assigned'**
  String get terrFree;

  /// No description provided for @terrStats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get terrStats;

  /// No description provided for @terrStatsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get terrStatsTotal;

  /// No description provided for @terrStatsAssigned.
  ///
  /// In en, this message translates to:
  /// **'Currently assigned'**
  String get terrStatsAssigned;

  /// No description provided for @terrStatsFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished in period'**
  String get terrStatsFinished;

  /// No description provided for @terrRemoveAssignment.
  ///
  /// In en, this message translates to:
  /// **'Remove assignment'**
  String get terrRemoveAssignment;

  /// No description provided for @infoEmpty.
  ///
  /// In en, this message translates to:
  /// **'No information right now.'**
  String get infoEmpty;

  /// No description provided for @infoAddText.
  ///
  /// In en, this message translates to:
  /// **'Add text'**
  String get infoAddText;

  /// No description provided for @infoAddFile.
  ///
  /// In en, this message translates to:
  /// **'Upload file (PDF/image)'**
  String get infoAddFile;

  /// No description provided for @infoAddLink.
  ///
  /// In en, this message translates to:
  /// **'Add link'**
  String get infoAddLink;

  /// No description provided for @infoTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get infoTitle;

  /// No description provided for @infoBody.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get infoBody;

  /// No description provided for @infoUrl.
  ///
  /// In en, this message translates to:
  /// **'Link (URL)'**
  String get infoUrl;

  /// No description provided for @infoShowFrom.
  ///
  /// In en, this message translates to:
  /// **'Show from (optional)'**
  String get infoShowFrom;

  /// No description provided for @infoShowUntil.
  ///
  /// In en, this message translates to:
  /// **'Show until (optional)'**
  String get infoShowUntil;

  /// No description provided for @infoFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The file is too large (max 10 MB). Share it as a link instead.'**
  String get infoFileTooLarge;

  /// No description provided for @infoHidden.
  ///
  /// In en, this message translates to:
  /// **'Currently hidden (outside its visibility window)'**
  String get infoHidden;

  /// No description provided for @infoDownloading.
  ///
  /// In en, this message translates to:
  /// **'Loading file…'**
  String get infoDownloading;

  /// No description provided for @infoEditItem.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get infoEditItem;

  /// No description provided for @s1Active.
  ///
  /// In en, this message translates to:
  /// **'All active publishers (reported at least once in the last 6 months)'**
  String get s1Active;

  /// No description provided for @s1AvgMid.
  ///
  /// In en, this message translates to:
  /// **'Average attendance — midweek meeting'**
  String get s1AvgMid;

  /// No description provided for @s1AvgWeekend.
  ///
  /// In en, this message translates to:
  /// **'Average attendance — weekend meeting'**
  String get s1AvgWeekend;

  /// No description provided for @s1Publishers.
  ///
  /// In en, this message translates to:
  /// **'Publishers'**
  String get s1Publishers;

  /// No description provided for @s1AuxPioneers.
  ///
  /// In en, this message translates to:
  /// **'Auxiliary pioneers'**
  String get s1AuxPioneers;

  /// No description provided for @s1RegPioneers.
  ///
  /// In en, this message translates to:
  /// **'Regular pioneers'**
  String get s1RegPioneers;

  /// No description provided for @s1Count.
  ///
  /// In en, this message translates to:
  /// **'Number of'**
  String get s1Count;

  /// No description provided for @s1Studies.
  ///
  /// In en, this message translates to:
  /// **'Bible studies'**
  String get s1Studies;

  /// No description provided for @s1Hours.
  ///
  /// In en, this message translates to:
  /// **'Hours (total)'**
  String get s1Hours;

  /// No description provided for @s1Note.
  ///
  /// In en, this message translates to:
  /// **'Auxiliary, regular and special pioneers are not counted in the Publishers group; special pioneers are not included in any group.'**
  String get s1Note;

  /// No description provided for @settingsName.
  ///
  /// In en, this message translates to:
  /// **'Congregation name'**
  String get settingsName;

  /// No description provided for @settingsLmmMeeting.
  ///
  /// In en, this message translates to:
  /// **'Midweek meeting (day and time)'**
  String get settingsLmmMeeting;

  /// No description provided for @settingsWeekendMeeting.
  ///
  /// In en, this message translates to:
  /// **'Weekend meeting (day and time)'**
  String get settingsWeekendMeeting;

  /// No description provided for @qSupportSection.
  ///
  /// In en, this message translates to:
  /// **'Meeting support and other'**
  String get qSupportSection;

  /// No description provided for @qChairman.
  ///
  /// In en, this message translates to:
  /// **'Chairman (midweek)'**
  String get qChairman;

  /// No description provided for @qPrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get qPrayer;

  /// No description provided for @qTreasures.
  ///
  /// In en, this message translates to:
  /// **'Treasures from God\'s Word'**
  String get qTreasures;

  /// No description provided for @qGems.
  ///
  /// In en, this message translates to:
  /// **'Spiritual gems'**
  String get qGems;

  /// No description provided for @qBibleReading.
  ///
  /// In en, this message translates to:
  /// **'Bible reading'**
  String get qBibleReading;

  /// No description provided for @qFieldMinistry.
  ///
  /// In en, this message translates to:
  /// **'Student assignments (ministry)'**
  String get qFieldMinistry;

  /// No description provided for @qLiving.
  ///
  /// In en, this message translates to:
  /// **'Living as Christians parts'**
  String get qLiving;

  /// No description provided for @qCbsConductor.
  ///
  /// In en, this message translates to:
  /// **'Congregation Bible Study conductor'**
  String get qCbsConductor;

  /// No description provided for @qCbsReader.
  ///
  /// In en, this message translates to:
  /// **'CBS reader'**
  String get qCbsReader;

  /// No description provided for @qPublicTalk.
  ///
  /// In en, this message translates to:
  /// **'Public talk'**
  String get qPublicTalk;

  /// No description provided for @qWeekendChairman.
  ///
  /// In en, this message translates to:
  /// **'Chairman (weekend)'**
  String get qWeekendChairman;

  /// No description provided for @qWtReader.
  ///
  /// In en, this message translates to:
  /// **'Watchtower reader'**
  String get qWtReader;

  /// No description provided for @qAttendant.
  ///
  /// In en, this message translates to:
  /// **'Attendant'**
  String get qAttendant;

  /// No description provided for @qMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Microphones'**
  String get qMicrophone;

  /// No description provided for @qAudioVideo.
  ///
  /// In en, this message translates to:
  /// **'Audio/video'**
  String get qAudioVideo;

  /// No description provided for @qPublicWitnessing.
  ///
  /// In en, this message translates to:
  /// **'Public witnessing'**
  String get qPublicWitnessing;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
