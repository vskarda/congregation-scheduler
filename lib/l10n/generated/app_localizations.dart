import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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
    Locale('tr'),
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

  /// No description provided for @setupDatabaseNotReady.
  ///
  /// In en, this message translates to:
  /// **'The congregation database is still starting up. Please wait a moment and try again.'**
  String get setupDatabaseNotReady;

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

  /// No description provided for @setupGuideLinkIntro.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have a configuration? Create your congregation\'s own free database:'**
  String get setupGuideLinkIntro;

  /// No description provided for @setupGuideLinkButton.
  ///
  /// In en, this message translates to:
  /// **'How to set up a new congregation'**
  String get setupGuideLinkButton;

  /// No description provided for @setupGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up a new congregation'**
  String get setupGuideTitle;

  /// No description provided for @setupGuideIntro.
  ///
  /// In en, this message translates to:
  /// **'This app is self-hosted: your congregation\'s data lives in your own free Google Firebase project that nobody else can access. Setting it up takes about 15 minutes and requires no programming — all you need is a Google account. Follow the steps below on this phone or on a computer.'**
  String get setupGuideIntro;

  /// No description provided for @setupGuideOpenConsole.
  ///
  /// In en, this message translates to:
  /// **'Open Firebase console'**
  String get setupGuideOpenConsole;

  /// No description provided for @setupGuideStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Create a Firebase project'**
  String get setupGuideStep1Title;

  /// No description provided for @setupGuideStep1Body1.
  ///
  /// In en, this message translates to:
  /// **'Open console.firebase.google.com, sign in with your Google account and tap \"Get started by setting up a Firebase project\".'**
  String get setupGuideStep1Body1;

  /// No description provided for @setupGuideStep1Body2.
  ///
  /// In en, this message translates to:
  /// **'Name the project, e.g. \"congregation-mytown\", accept the terms and continue. If Google Analytics is offered, disable it — it is not needed. Stay on the free Spark plan; the app is designed to never need billing.'**
  String get setupGuideStep1Body2;

  /// No description provided for @setupGuideStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Enable e-mail sign-in'**
  String get setupGuideStep2Title;

  /// No description provided for @setupGuideStep2Body1.
  ///
  /// In en, this message translates to:
  /// **'In the left menu choose Security → Authentication.'**
  String get setupGuideStep2Body1;

  /// No description provided for @setupGuideStep2Body2.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Get started\".'**
  String get setupGuideStep2Body2;

  /// No description provided for @setupGuideStep2Body3.
  ///
  /// In en, this message translates to:
  /// **'On the \"Sign-in method\" tab choose Email/Password.'**
  String get setupGuideStep2Body3;

  /// No description provided for @setupGuideStep2Body4.
  ///
  /// In en, this message translates to:
  /// **'Enable the first toggle (leave \"Email link\" off) and tap Save.'**
  String get setupGuideStep2Body4;

  /// No description provided for @setupGuideStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Create the Firestore database'**
  String get setupGuideStep3Title;

  /// No description provided for @setupGuideStep3Body1.
  ///
  /// In en, this message translates to:
  /// **'In the left menu choose Databases & Storage → Firestore.'**
  String get setupGuideStep3Body1;

  /// No description provided for @setupGuideStep3Body2.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Create database\".'**
  String get setupGuideStep3Body2;

  /// No description provided for @setupGuideStep3Body3.
  ///
  /// In en, this message translates to:
  /// **'Choose the Standard edition.'**
  String get setupGuideStep3Body3;

  /// No description provided for @setupGuideStep3Body4.
  ///
  /// In en, this message translates to:
  /// **'Choose a location close to you (e.g. europe-west3 for Central Europe). It cannot be changed later.'**
  String get setupGuideStep3Body4;

  /// No description provided for @setupGuideStep3Body5.
  ///
  /// In en, this message translates to:
  /// **'Start in production mode…'**
  String get setupGuideStep3Body5;

  /// No description provided for @setupGuideStep3Body6.
  ///
  /// In en, this message translates to:
  /// **'…and tap Create.'**
  String get setupGuideStep3Body6;

  /// No description provided for @setupGuideStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Install the security rules'**
  String get setupGuideStep4Title;

  /// No description provided for @setupGuideStep4Body1.
  ///
  /// In en, this message translates to:
  /// **'The rules decide who may read and write which data (e.g. only verified publishers can see schedules). In the Firestore database open the Rules tab and tap \"Edit rules\".'**
  String get setupGuideStep4Body1;

  /// No description provided for @setupGuideStep4Body2.
  ///
  /// In en, this message translates to:
  /// **'Delete everything in the editor and paste the copied rules.'**
  String get setupGuideStep4Body2;

  /// No description provided for @setupGuideStep4Body3.
  ///
  /// In en, this message translates to:
  /// **'Tap Publish.'**
  String get setupGuideStep4Body3;

  /// No description provided for @setupGuideStep4Note.
  ///
  /// In en, this message translates to:
  /// **'Repeat this step whenever a new app version ships updated rules.'**
  String get setupGuideStep4Note;

  /// No description provided for @setupGuideStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Get the app configuration'**
  String get setupGuideStep5Title;

  /// No description provided for @setupGuideStep5Body1.
  ///
  /// In en, this message translates to:
  /// **'Tap the gear icon next to \"Project Overview\" (top left) and choose Project settings.'**
  String get setupGuideStep5Body1;

  /// No description provided for @setupGuideStep5Body2.
  ///
  /// In en, this message translates to:
  /// **'On the General tab scroll down to \"Your apps\" and tap the web icon </>.'**
  String get setupGuideStep5Body2;

  /// No description provided for @setupGuideStep5Body3.
  ///
  /// In en, this message translates to:
  /// **'Enter a nickname, e.g. \"congregation-app\", leave hosting off and tap \"Register app\".'**
  String get setupGuideStep5Body3;

  /// No description provided for @setupGuideStep5Body4.
  ///
  /// In en, this message translates to:
  /// **'A code block with \"const firebaseConfig = …\" appears. Select and copy just the configuration between the curly braces — including the braces themselves.'**
  String get setupGuideStep5Body4;

  /// No description provided for @setupGuideStep5Note.
  ///
  /// In en, this message translates to:
  /// **'This configuration is not a secret — it only identifies your project. The data is protected by the security rules from step 4.'**
  String get setupGuideStep5Note;

  /// No description provided for @setupGuideRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Security rules (firestore.rules)'**
  String get setupGuideRulesTitle;

  /// No description provided for @setupGuideRulesCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy rules'**
  String get setupGuideRulesCopy;

  /// No description provided for @setupGuideRulesCopied.
  ///
  /// In en, this message translates to:
  /// **'Rules copied to clipboard.'**
  String get setupGuideRulesCopied;

  /// No description provided for @setupGuideRulesView.
  ///
  /// In en, this message translates to:
  /// **'Show rules text'**
  String get setupGuideRulesView;

  /// No description provided for @setupGuideRulesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the rules text.'**
  String get setupGuideRulesLoadError;

  /// No description provided for @setupGuideFinish.
  ///
  /// In en, this message translates to:
  /// **'Done! Go back, paste the copied configuration and tap Connect. Then choose \"Set up a new congregation\" and register as the first administrator.'**
  String get setupGuideFinish;

  /// No description provided for @setupGuideBackToConnect.
  ///
  /// In en, this message translates to:
  /// **'Back to the connection screen'**
  String get setupGuideBackToConnect;

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

  /// No description provided for @languageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Theme: {mode}'**
  String themeTooltip(String mode);

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

  /// No description provided for @authEnterEmailForReset.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address first, then tap \"Forgot password?\" to receive a reset link.'**
  String get authEnterEmailForReset;

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

  /// No description provided for @deleteAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteAccountAction;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account and personal profile (name, contact details and login). This cannot be undone. Your submitted reports remain stored with the congregation.'**
  String get deleteAccountWarning;

  /// No description provided for @deleteAccountPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to confirm'**
  String get deleteAccountPasswordLabel;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountSoleAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'You are the only administrator'**
  String get deleteAccountSoleAdminTitle;

  /// No description provided for @deleteAccountSoleAdminBody.
  ///
  /// In en, this message translates to:
  /// **'You are the congregation\'s only Full Administrator. Grant another member Full Admin rights first, otherwise deleting your account would leave the congregation with no administrator and no way to restore access.'**
  String get deleteAccountSoleAdminBody;

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
  /// **'Midweek meeting'**
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

  /// No description provided for @navFieldServiceMeetings.
  ///
  /// In en, this message translates to:
  /// **'Meetings for Field Service'**
  String get navFieldServiceMeetings;

  /// No description provided for @navTerritories.
  ///
  /// In en, this message translates to:
  /// **'Territories'**
  String get navTerritories;

  /// No description provided for @navMinistryGroups.
  ///
  /// In en, this message translates to:
  /// **'Ministry groups'**
  String get navMinistryGroups;

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

  /// No description provided for @navTalks.
  ///
  /// In en, this message translates to:
  /// **'Public talk titles'**
  String get navTalks;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Congregation settings'**
  String get navSettings;

  /// No description provided for @navStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get navStatistics;

  /// No description provided for @navHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get navHelp;

  /// No description provided for @helpPublisherSection.
  ///
  /// In en, this message translates to:
  /// **'Tips for publishers'**
  String get helpPublisherSection;

  /// No description provided for @helpAdminSection.
  ///
  /// In en, this message translates to:
  /// **'For administrators'**
  String get helpAdminSection;

  /// No description provided for @helpCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to your calendar'**
  String get helpCalendarTitle;

  /// No description provided for @helpCalendarBody.
  ///
  /// In en, this message translates to:
  /// **'In the mobile app, events and your assignments show a calendar icon. Tap it to add the item to your device\'s calendar.'**
  String get helpCalendarBody;

  /// No description provided for @helpRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Assignment reminders'**
  String get helpRemindersTitle;

  /// No description provided for @helpRemindersBody.
  ///
  /// In en, this message translates to:
  /// **'On the Events screen, tap the bell icon next to \"My upcoming assignments\" to get notified before each assignment — you choose how far in advance. (Mobile app only.)'**
  String get helpRemindersBody;

  /// No description provided for @helpHighlightTitle.
  ///
  /// In en, this message translates to:
  /// **'Find yourself at a glance'**
  String get helpHighlightTitle;

  /// No description provided for @helpHighlightBody.
  ///
  /// In en, this message translates to:
  /// **'In the meeting schedules your own name is highlighted, so you can spot your assignments quickly.'**
  String get helpHighlightBody;

  /// No description provided for @helpTerritoryMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Open a territory map'**
  String get helpTerritoryMapTitle;

  /// No description provided for @helpTerritoryMapBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the map icon next to a territory to open its map. A grey icon means no map link has been added for that territory yet.'**
  String get helpTerritoryMapBody;

  /// No description provided for @helpAdminToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'View the app as a publisher'**
  String get helpAdminToggleTitle;

  /// No description provided for @helpAdminToggleBody.
  ///
  /// In en, this message translates to:
  /// **'The pencil icon in the top bar temporarily hides all admin tools, so you see the app exactly as publishers do. Tap it again to bring the tools back.'**
  String get helpAdminToggleBody;

  /// No description provided for @helpPdfExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Print or share schedules'**
  String get helpPdfExportTitle;

  /// No description provided for @helpPdfExportBody.
  ///
  /// In en, this message translates to:
  /// **'On the Midweek meeting and Weekend meeting screens, schedule editors have a PDF icon in the top bar that exports the month\'s schedule for printing or sharing.'**
  String get helpPdfExportBody;

  /// No description provided for @helpGoogleMyMapsTitle.
  ///
  /// In en, this message translates to:
  /// **'Territory maps with Google My Maps'**
  String get helpGoogleMyMapsTitle;

  /// No description provided for @helpGoogleMyMapsBody.
  ///
  /// In en, this message translates to:
  /// **'Create your territory maps in Google My Maps and paste each territory\'s share link into its map link field. A step-by-step guide is available on GitHub.'**
  String get helpGoogleMyMapsBody;

  /// No description provided for @helpOpenGuide.
  ///
  /// In en, this message translates to:
  /// **'Open the guide'**
  String get helpOpenGuide;

  /// No description provided for @helpDataDelayTitle.
  ///
  /// In en, this message translates to:
  /// **'Changes may take a moment to appear'**
  String get helpDataDelayTitle;

  /// No description provided for @helpDataDelayBody.
  ///
  /// In en, this message translates to:
  /// **'Changes made in the app — for example edits in Publishers — may take up to a minute to become visible. (Sometimes, for instance, an S-21 import does not show the current service year\'s ministry hours right away.)'**
  String get helpDataDelayBody;

  /// No description provided for @helpPwApplyTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply for public witnessing'**
  String get helpPwApplyTitle;

  /// No description provided for @helpPwApplyBody.
  ///
  /// In en, this message translates to:
  /// **'Open Public Witnessing, find a slot, and tap the hand icon to volunteer; tap it again to withdraw. If you don\'t see the icon, ask an administrator to turn on the \"Public witnessing\" qualification on your record.'**
  String get helpPwApplyBody;

  /// No description provided for @helpPwAssignTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign publishers to public witnessing'**
  String get helpPwAssignTitle;

  /// No description provided for @helpPwAssignBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on each volunteer\'s \"Public witnessing\" qualification under Publishers → open a publisher → Qualifications. Then in Public Witnessing open a slot and tap \"Assigned\": publishers who applied are pinned to the top of the list with an \"Applied\" badge. Use recurring slots for weekly carts or stands.'**
  String get helpPwAssignBody;

  /// No description provided for @helpS21Title.
  ///
  /// In en, this message translates to:
  /// **'Import S-21 records'**
  String get helpS21Title;

  /// No description provided for @helpS21Body.
  ///
  /// In en, this message translates to:
  /// **'You can import a publisher\'s Congregation Publisher Record (S-21) from a PDF. Open Publishers → a publisher → S-21 and choose the file. Only the PDF\'s text layer is read, so scanned or flattened forms may not import.'**
  String get helpS21Body;

  /// No description provided for @helpS99Title.
  ///
  /// In en, this message translates to:
  /// **'Import public talk titles (S-99)'**
  String get helpS99Title;

  /// No description provided for @helpS99Body.
  ///
  /// In en, this message translates to:
  /// **'On Public talk titles, choose \"Update titles from PDF\" and pick an official S-99 form PDF. Upcoming weekend meetings that reference those talk numbers update automatically.'**
  String get helpS99Body;

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

  /// No description provided for @profileBaptismDate.
  ///
  /// In en, this message translates to:
  /// **'Baptism date'**
  String get profileBaptismDate;

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

  /// No description provided for @profileHope.
  ///
  /// In en, this message translates to:
  /// **'Hope'**
  String get profileHope;

  /// No description provided for @hopeOtherSheep.
  ///
  /// In en, this message translates to:
  /// **'Other sheep'**
  String get hopeOtherSheep;

  /// No description provided for @hopeAnointed.
  ///
  /// In en, this message translates to:
  /// **'Anointed'**
  String get hopeAnointed;

  /// No description provided for @profileStatus.
  ///
  /// In en, this message translates to:
  /// **'Service status'**
  String get profileStatus;

  /// No description provided for @statusNone.
  ///
  /// In en, this message translates to:
  /// **'-'**
  String get statusNone;

  /// No description provided for @statusPublisher.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get statusPublisher;

  /// No description provided for @statusAuxPioneer.
  ///
  /// In en, this message translates to:
  /// **'Auxiliary Pioneer'**
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

  /// No description provided for @statusFieldMissionary.
  ///
  /// In en, this message translates to:
  /// **'Field missionary'**
  String get statusFieldMissionary;

  /// No description provided for @profileAppointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get profileAppointment;

  /// No description provided for @appointmentMinisterialServant.
  ///
  /// In en, this message translates to:
  /// **'Ministerial servant'**
  String get appointmentMinisterialServant;

  /// No description provided for @appointmentElder.
  ///
  /// In en, this message translates to:
  /// **'Elder'**
  String get appointmentElder;

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
  /// **'Service Year {year}'**
  String serviceYear(int year);

  /// No description provided for @recordTotalHours.
  ///
  /// In en, this message translates to:
  /// **'Total hours'**
  String get recordTotalHours;

  /// No description provided for @recordAverageHours.
  ///
  /// In en, this message translates to:
  /// **'Monthly average'**
  String get recordAverageHours;

  /// No description provided for @reportMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get reportMonth;

  /// No description provided for @reportParticipated.
  ///
  /// In en, this message translates to:
  /// **'Shared in Ministry'**
  String get reportParticipated;

  /// No description provided for @reportStudies.
  ///
  /// In en, this message translates to:
  /// **'Bible Studies'**
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

  /// No description provided for @s21Export.
  ///
  /// In en, this message translates to:
  /// **'Export S-21 (PDF)'**
  String get s21Export;

  /// No description provided for @schedulePdfExport.
  ///
  /// In en, this message translates to:
  /// **'Monthly overview (PDF)'**
  String get schedulePdfExport;

  /// No description provided for @lmmScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Midweek Meeting Schedule'**
  String get lmmScheduleTitle;

  /// No description provided for @s21Title.
  ///
  /// In en, this message translates to:
  /// **'CONGREGATION’S PUBLISHER RECORD'**
  String get s21Title;

  /// No description provided for @s21Name.
  ///
  /// In en, this message translates to:
  /// **'Name:'**
  String get s21Name;

  /// No description provided for @s21DateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth:'**
  String get s21DateOfBirth;

  /// No description provided for @s21DateOfBaptism.
  ///
  /// In en, this message translates to:
  /// **'Date of baptism:'**
  String get s21DateOfBaptism;

  /// No description provided for @s21HoursHeader.
  ///
  /// In en, this message translates to:
  /// **'Hours (If pioneer or field missionary)'**
  String get s21HoursHeader;

  /// No description provided for @s21Remarks.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get s21Remarks;

  /// No description provided for @s21Total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get s21Total;

  /// No description provided for @s21FormCode.
  ///
  /// In en, this message translates to:
  /// **'S-21-E 11/23'**
  String get s21FormCode;

  /// No description provided for @s21Credit.
  ///
  /// In en, this message translates to:
  /// **'Credit: {hours}'**
  String s21Credit(int hours);

  /// No description provided for @s21Import.
  ///
  /// In en, this message translates to:
  /// **'Import S-21 (PDF)'**
  String get s21Import;

  /// No description provided for @s21ImportNew.
  ///
  /// In en, this message translates to:
  /// **'Import publisher from S-21'**
  String get s21ImportNew;

  /// No description provided for @s21ImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import S-21'**
  String get s21ImportTitle;

  /// No description provided for @s21ImportPickFile.
  ///
  /// In en, this message translates to:
  /// **'Choose PDF file'**
  String get s21ImportPickFile;

  /// No description provided for @s21ImportHint.
  ///
  /// In en, this message translates to:
  /// **'Pick an S-21 publisher record card (PDF). The values from the card replace the publisher\'s profile fields and monthly reports.'**
  String get s21ImportHint;

  /// No description provided for @s21ImportNoData.
  ///
  /// In en, this message translates to:
  /// **'No S-21 data found in this file.'**
  String get s21ImportNoData;

  /// No description provided for @s21ImportMonths.
  ///
  /// In en, this message translates to:
  /// **'{count} monthly reports found'**
  String s21ImportMonths(int count);

  /// No description provided for @s21ImportNameKept.
  ///
  /// In en, this message translates to:
  /// **'The name in the app is kept: {name}'**
  String s21ImportNameKept(String name);

  /// No description provided for @s21ImportCardName.
  ///
  /// In en, this message translates to:
  /// **'Name on the card: {name}'**
  String s21ImportCardName(String name);

  /// No description provided for @s21ImportDuplicateName.
  ///
  /// In en, this message translates to:
  /// **'A publisher named \"{name}\" already exists.'**
  String s21ImportDuplicateName(String name);

  /// No description provided for @s21ImportUseExisting.
  ///
  /// In en, this message translates to:
  /// **'Import into the existing record'**
  String get s21ImportUseExisting;

  /// No description provided for @s21ImportReplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace existing records?'**
  String get s21ImportReplaceTitle;

  /// No description provided for @s21ImportReplaceBody.
  ///
  /// In en, this message translates to:
  /// **'The publisher\'s profile fields and the monthly reports for the imported service years will be replaced with the values from this S-21. This cannot be undone.'**
  String get s21ImportReplaceBody;

  /// No description provided for @s21ImportSave.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get s21ImportSave;

  /// No description provided for @s21ImportDone.
  ///
  /// In en, this message translates to:
  /// **'S-21 imported.'**
  String get s21ImportDone;

  /// No description provided for @s21ImportAssignYear.
  ///
  /// In en, this message translates to:
  /// **'Service year for this table'**
  String get s21ImportAssignYear;

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

  /// No description provided for @pubAdminDeleteMovedHint.
  ///
  /// In en, this message translates to:
  /// **'If they have an app account, deletion does not remove their login and they could sign in again. To archive someone who left, use \"Mark as moved\" instead.'**
  String get pubAdminDeleteMovedHint;

  /// No description provided for @pubAdminMarkMoved.
  ///
  /// In en, this message translates to:
  /// **'Mark as moved'**
  String get pubAdminMarkMoved;

  /// No description provided for @pubAdminRestoreMoved.
  ///
  /// In en, this message translates to:
  /// **'Restore from moved'**
  String get pubAdminRestoreMoved;

  /// No description provided for @pubAdminMovedBadge.
  ///
  /// In en, this message translates to:
  /// **'Moved'**
  String get pubAdminMovedBadge;

  /// No description provided for @pubAdminShowMoved.
  ///
  /// In en, this message translates to:
  /// **'Show moved'**
  String get pubAdminShowMoved;

  /// No description provided for @pubFilterPioneers.
  ///
  /// In en, this message translates to:
  /// **'Pioneers'**
  String get pubFilterPioneers;

  /// No description provided for @pubFilterHasRights.
  ///
  /// In en, this message translates to:
  /// **'Has rights'**
  String get pubFilterHasRights;

  /// No description provided for @pubFilterAnyGroup.
  ///
  /// In en, this message translates to:
  /// **'Any group'**
  String get pubFilterAnyGroup;

  /// No description provided for @pubFilterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get pubFilterClear;

  /// No description provided for @pubAdminMoveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark as moved?'**
  String get pubAdminMoveConfirmTitle;

  /// No description provided for @pubAdminMoveConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The record and report history are kept, but the publisher is archived: their access is revoked and they no longer appear in schedules or report lists. You can restore them later.'**
  String get pubAdminMoveConfirmBody;

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

  /// No description provided for @pubConnectBanner.
  ///
  /// In en, this message translates to:
  /// **'This account is awaiting verification. If an admin already created a publisher record for this person, connect the two: the record\'s history moves onto this account and the duplicate record disappears.'**
  String get pubConnectBanner;

  /// No description provided for @pubConnectAction.
  ///
  /// In en, this message translates to:
  /// **'Connect to existing record'**
  String get pubConnectAction;

  /// No description provided for @pubConnectNeedsFullAdmin.
  ///
  /// In en, this message translates to:
  /// **'Only a Full Admin can connect records (the migration touches every section\'s data).'**
  String get pubConnectNeedsFullAdmin;

  /// No description provided for @pubConnectPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect to existing record'**
  String get pubConnectPickTitle;

  /// No description provided for @pubConnectPickHint.
  ///
  /// In en, this message translates to:
  /// **'Select the record that belongs to {name}.'**
  String pubConnectPickHint(String name);

  /// No description provided for @pubConnectNoRecords.
  ///
  /// In en, this message translates to:
  /// **'There is no publisher record without an app account to connect.'**
  String get pubConnectNoRecords;

  /// No description provided for @pubConnectConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect and merge?'**
  String get pubConnectConfirmTitle;

  /// No description provided for @pubConnectConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The complete history of \"{record}\" — reports, territories and schedule assignments — will be moved to the account of \"{account}\". The account becomes verified and the duplicate record is permanently deleted. This cannot be undone.'**
  String pubConnectConfirmBody(String record, String account);

  /// No description provided for @pubConnectProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Connecting record…'**
  String get pubConnectProgressTitle;

  /// No description provided for @pubConnectProgressBody.
  ///
  /// In en, this message translates to:
  /// **'Do not close the app while the history is being moved.'**
  String get pubConnectProgressBody;

  /// No description provided for @pubConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Connecting failed at: {section}. Completed steps are kept — retrying is safe and continues where it stopped.'**
  String pubConnectFailed(String section);

  /// No description provided for @pubConnectSuccess.
  ///
  /// In en, this message translates to:
  /// **'Record connected — its history now belongs to this account.'**
  String get pubConnectSuccess;

  /// No description provided for @roleFullAdmin.
  ///
  /// In en, this message translates to:
  /// **'Full administrator'**
  String get roleFullAdmin;

  /// No description provided for @roleRecordAttendance.
  ///
  /// In en, this message translates to:
  /// **'Record attendance'**
  String get roleRecordAttendance;

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
  /// **'TREASURES FROM GOD’S WORD'**
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
  /// **'Spiritual Gems'**
  String get partGems;

  /// No description provided for @partBibleReading.
  ///
  /// In en, this message translates to:
  /// **'Bible Reading'**
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

  /// No description provided for @lmmClassMain.
  ///
  /// In en, this message translates to:
  /// **'Main Hall'**
  String get lmmClassMain;

  /// No description provided for @lmmClassN.
  ///
  /// In en, this message translates to:
  /// **'Class {index}'**
  String lmmClassN(int index);

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

  /// No description provided for @customAssignmentPermanent.
  ///
  /// In en, this message translates to:
  /// **'Permanent (every week)'**
  String get customAssignmentPermanent;

  /// No description provided for @customAssignmentRemovePermanentTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove permanent assignment'**
  String get customAssignmentRemovePermanentTitle;

  /// No description provided for @customAssignmentRemovePermanentBody.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{label}\" from every week?'**
  String customAssignmentRemovePermanentBody(String label);

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

  /// No description provided for @pickerApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get pickerApplied;

  /// No description provided for @importTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Meeting Workbook'**
  String get importTitle;

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

  /// No description provided for @pickerFromCatalog.
  ///
  /// In en, this message translates to:
  /// **'From list'**
  String get pickerFromCatalog;

  /// No description provided for @talksUpdateFromPdf.
  ///
  /// In en, this message translates to:
  /// **'Update titles from PDF'**
  String get talksUpdateFromPdf;

  /// No description provided for @talksPickPdf.
  ///
  /// In en, this message translates to:
  /// **'Choose S-99 PDF'**
  String get talksPickPdf;

  /// No description provided for @talksParseError.
  ///
  /// In en, this message translates to:
  /// **'Could not read talk titles from this file. Use an official S-99 form PDF.'**
  String get talksParseError;

  /// No description provided for @talksImportSummary.
  ///
  /// In en, this message translates to:
  /// **'{total} talks found: {added} new, {changed} changed, {removed} removed'**
  String talksImportSummary(int total, int added, int changed, int removed);

  /// No description provided for @talksImportSave.
  ///
  /// In en, this message translates to:
  /// **'Save titles'**
  String get talksImportSave;

  /// No description provided for @talksImportDone.
  ///
  /// In en, this message translates to:
  /// **'Titles saved. {count} upcoming meetings updated.'**
  String talksImportDone(int count);

  /// No description provided for @talksLastDelivered.
  ///
  /// In en, this message translates to:
  /// **'Last delivered {date}'**
  String talksLastDelivered(String date);

  /// No description provided for @talksNeverDelivered.
  ///
  /// In en, this message translates to:
  /// **'Not delivered yet'**
  String get talksNeverDelivered;

  /// No description provided for @talksScheduled.
  ///
  /// In en, this message translates to:
  /// **'scheduled'**
  String get talksScheduled;

  /// No description provided for @talksNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get talksNew;

  /// No description provided for @talksChanged.
  ///
  /// In en, this message translates to:
  /// **'Changed'**
  String get talksChanged;

  /// No description provided for @talksRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get talksRemoved;

  /// No description provided for @talksSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search talks…'**
  String get talksSearchHint;

  /// No description provided for @talksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No talk titles yet. Import them from an S-99 PDF.'**
  String get talksEmpty;

  /// No description provided for @talksOpenCatalog.
  ///
  /// In en, this message translates to:
  /// **'Manage talk titles'**
  String get talksOpenCatalog;

  /// No description provided for @talksEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit title'**
  String get talksEditTitle;

  /// No description provided for @songLabel.
  ///
  /// In en, this message translates to:
  /// **'Song'**
  String get songLabel;

  /// No description provided for @songsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No song list yet. Update it from the official web.'**
  String get songsEmpty;

  /// No description provided for @songsUpdateFromWeb.
  ///
  /// In en, this message translates to:
  /// **'Update song list from official web'**
  String get songsUpdateFromWeb;

  /// No description provided for @songsUpdateDone.
  ///
  /// In en, this message translates to:
  /// **'Song list updated: {count} songs.'**
  String songsUpdateDone(int count);

  /// No description provided for @songsCdnNothing.
  ///
  /// In en, this message translates to:
  /// **'The song list is not available online yet.'**
  String get songsCdnNothing;

  /// No description provided for @songsStatusEmpty.
  ///
  /// In en, this message translates to:
  /// **'No song list imported yet.'**
  String get songsStatusEmpty;

  /// No description provided for @songsStatusLoaded.
  ///
  /// In en, this message translates to:
  /// **'{count} songs · updated {date}'**
  String songsStatusLoaded(int count, String date);

  /// No description provided for @settingsSongsSection.
  ///
  /// In en, this message translates to:
  /// **'Song list'**
  String get settingsSongsSection;

  /// No description provided for @settingsSongsDescription.
  ///
  /// In en, this message translates to:
  /// **'Download the meeting song titles from jw.org so they can be picked on the weekend and midweek schedules.'**
  String get settingsSongsDescription;

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

  /// No description provided for @pwApply.
  ///
  /// In en, this message translates to:
  /// **'Apply for this slot'**
  String get pwApply;

  /// No description provided for @pwWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw application'**
  String get pwWithdraw;

  /// No description provided for @pwApplicants.
  ///
  /// In en, this message translates to:
  /// **'{count} applied'**
  String pwApplicants(int count);

  /// No description provided for @fsmNoMeetings.
  ///
  /// In en, this message translates to:
  /// **'No meetings for field service this week.'**
  String get fsmNoMeetings;

  /// No description provided for @fsmAddMeeting.
  ///
  /// In en, this message translates to:
  /// **'Add meeting'**
  String get fsmAddMeeting;

  /// No description provided for @fsmEditMeeting.
  ///
  /// In en, this message translates to:
  /// **'Edit meeting'**
  String get fsmEditMeeting;

  /// No description provided for @fsmDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fsmDate;

  /// No description provided for @fsmTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get fsmTime;

  /// No description provided for @fsmLocation.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get fsmLocation;

  /// No description provided for @fsmNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get fsmNote;

  /// No description provided for @fsmConductor.
  ///
  /// In en, this message translates to:
  /// **'Conductor'**
  String get fsmConductor;

  /// No description provided for @fsmRecurringRules.
  ///
  /// In en, this message translates to:
  /// **'Recurring meetings'**
  String get fsmRecurringRules;

  /// No description provided for @fsmRecurringAdd.
  ///
  /// In en, this message translates to:
  /// **'Add recurring meeting'**
  String get fsmRecurringAdd;

  /// No description provided for @fsmWeekday.
  ///
  /// In en, this message translates to:
  /// **'Day of week'**
  String get fsmWeekday;

  /// No description provided for @fsmValidFrom.
  ///
  /// In en, this message translates to:
  /// **'Valid from'**
  String get fsmValidFrom;

  /// No description provided for @fsmValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until (optional)'**
  String get fsmValidUntil;

  /// No description provided for @fsmRecurringDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this recurring meeting? Its future meetings will be removed too. This can\'t be undone.'**
  String get fsmRecurringDeleteConfirm;

  /// No description provided for @fsmRemoveAllFutureAction.
  ///
  /// In en, this message translates to:
  /// **'Remove all future meetings'**
  String get fsmRemoveAllFutureAction;

  /// No description provided for @fsmRemoveAllFutureWarning.
  ///
  /// In en, this message translates to:
  /// **'Removing all future meetings deletes every upcoming one-time and recurring meeting and cannot be undone.'**
  String get fsmRemoveAllFutureWarning;

  /// No description provided for @fsmRemoveAllFutureTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove all future meetings?'**
  String get fsmRemoveAllFutureTitle;

  /// No description provided for @fsmRemoveAllFutureBody.
  ///
  /// In en, this message translates to:
  /// **'This deletes every upcoming one-time and recurring Ministry meeting, and removes all recurring meeting rules so none regenerate. Past meetings are kept. This can\'t be undone.'**
  String get fsmRemoveAllFutureBody;

  /// No description provided for @fsmRemoveAllFutureConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove all'**
  String get fsmRemoveAllFutureConfirm;

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

  /// No description provided for @eventAddToCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add to calendar'**
  String get eventAddToCalendar;

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

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Assignment reminders'**
  String get remindersTitle;

  /// No description provided for @remindersDescription.
  ///
  /// In en, this message translates to:
  /// **'Get notified on this device before each of your upcoming assignments. Changes made while the app is closed are picked up the next time you open it.'**
  String get remindersDescription;

  /// No description provided for @remindersEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable reminders'**
  String get remindersEnable;

  /// No description provided for @remindersAdd.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get remindersAdd;

  /// No description provided for @reminderUnitMinutes.
  ///
  /// In en, this message translates to:
  /// **'minutes before'**
  String get reminderUnitMinutes;

  /// No description provided for @reminderUnitHours.
  ///
  /// In en, this message translates to:
  /// **'hours before'**
  String get reminderUnitHours;

  /// No description provided for @reminderUnitDays.
  ///
  /// In en, this message translates to:
  /// **'days before'**
  String get reminderUnitDays;

  /// No description provided for @remindersPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are not allowed for this app. Enable them in system settings to use reminders.'**
  String get remindersPermissionDenied;

  /// No description provided for @remindersChannelName.
  ///
  /// In en, this message translates to:
  /// **'Assignment reminders'**
  String get remindersChannelName;

  /// No description provided for @remindersChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Notifications ahead of your congregation assignments'**
  String get remindersChannelDescription;

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

  /// No description provided for @roleFsm.
  ///
  /// In en, this message translates to:
  /// **'Meeting for field service'**
  String get roleFsm;

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
  /// **'Midweek meeting'**
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

  /// No description provided for @attHistory.
  ///
  /// In en, this message translates to:
  /// **'Past meetings'**
  String get attHistory;

  /// No description provided for @attNotFilled.
  ///
  /// In en, this message translates to:
  /// **'Not recorded'**
  String get attNotFilled;

  /// No description provided for @attMismatch.
  ///
  /// In en, this message translates to:
  /// **'The numbers don\'t add up.'**
  String get attMismatch;

  /// No description provided for @attRecordedOf.
  ///
  /// In en, this message translates to:
  /// **'{filled}/{expected} recorded'**
  String attRecordedOf(int filled, int expected);

  /// No description provided for @attSaved.
  ///
  /// In en, this message translates to:
  /// **'Attendance saved.'**
  String get attSaved;

  /// No description provided for @statMembershipTitle.
  ///
  /// In en, this message translates to:
  /// **'Publishers'**
  String get statMembershipTitle;

  /// No description provided for @statTotalMembers.
  ///
  /// In en, this message translates to:
  /// **'All publishers'**
  String get statTotalMembers;

  /// No description provided for @statPioneers.
  ///
  /// In en, this message translates to:
  /// **'Pioneers'**
  String get statPioneers;

  /// No description provided for @statAgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Age distribution'**
  String get statAgeTitle;

  /// No description provided for @statAgeAverage.
  ///
  /// In en, this message translates to:
  /// **'Average age'**
  String get statAgeAverage;

  /// No description provided for @statAgeKnownDetail.
  ///
  /// In en, this message translates to:
  /// **'Based on {known} of {total} known birth dates'**
  String statAgeKnownDetail(int known, int total);

  /// No description provided for @statAgeUnder18.
  ///
  /// In en, this message translates to:
  /// **'Under 18'**
  String get statAgeUnder18;

  /// No description provided for @statAgeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get statAgeUnknown;

  /// No description provided for @statAttendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Meeting attendance'**
  String get statAttendanceTitle;

  /// No description provided for @statAvg3Months.
  ///
  /// In en, this message translates to:
  /// **'3-month avg.'**
  String get statAvg3Months;

  /// No description provided for @statAvg12Months.
  ///
  /// In en, this message translates to:
  /// **'12-month avg.'**
  String get statAvg12Months;

  /// No description provided for @statFieldServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Field service'**
  String get statFieldServiceTitle;

  /// No description provided for @statServiceYear.
  ///
  /// In en, this message translates to:
  /// **'Service year {year}'**
  String statServiceYear(String year);

  /// No description provided for @statReportsSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Reports submitted'**
  String get statReportsSubmitted;

  /// No description provided for @statParticipated.
  ///
  /// In en, this message translates to:
  /// **'Shared in the ministry'**
  String get statParticipated;

  /// No description provided for @statPioneerHours.
  ///
  /// In en, this message translates to:
  /// **'Pioneer hours'**
  String get statPioneerHours;

  /// No description provided for @statPublisherHours.
  ///
  /// In en, this message translates to:
  /// **'Publisher hours'**
  String get statPublisherHours;

  /// No description provided for @statUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'App usage'**
  String get statUsageTitle;

  /// No description provided for @statWithAccount.
  ///
  /// In en, this message translates to:
  /// **'With app account'**
  String get statWithAccount;

  /// No description provided for @statSelfReported.
  ///
  /// In en, this message translates to:
  /// **'Self-submitted reports (last month)'**
  String get statSelfReported;

  /// No description provided for @statAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Awaiting verification'**
  String get statAwaiting;

  /// No description provided for @statFullAdmins.
  ///
  /// In en, this message translates to:
  /// **'Full admins'**
  String get statFullAdmins;

  /// No description provided for @statSectionAdmins.
  ///
  /// In en, this message translates to:
  /// **'Section admins'**
  String get statSectionAdmins;

  /// No description provided for @statNoData.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get statNoData;

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

  /// No description provided for @terrImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import territories'**
  String get terrImportTitle;

  /// No description provided for @terrImportPasteHint.
  ///
  /// In en, this message translates to:
  /// **'Paste rows from Excel or Google Sheets. Columns: name, number, map link, notes — only name is required.'**
  String get terrImportPasteHint;

  /// No description provided for @terrImportPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get terrImportPreview;

  /// No description provided for @terrImportPickFile.
  ///
  /// In en, this message translates to:
  /// **'Choose CSV file'**
  String get terrImportPickFile;

  /// No description provided for @terrImportSummary.
  ///
  /// In en, this message translates to:
  /// **'{total} rows: {newCount} new, {duplicates} existing, {invalid} invalid'**
  String terrImportSummary(
    int total,
    int newCount,
    int duplicates,
    int invalid,
  );

  /// No description provided for @terrImportUpdateExisting.
  ///
  /// In en, this message translates to:
  /// **'Update existing territories (matched by number) instead of skipping'**
  String get terrImportUpdateExisting;

  /// No description provided for @terrImportBadgeNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get terrImportBadgeNew;

  /// No description provided for @terrImportBadgeSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get terrImportBadgeSkip;

  /// No description provided for @terrImportBadgeUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get terrImportBadgeUpdate;

  /// No description provided for @terrImportBadgeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Missing name'**
  String get terrImportBadgeInvalid;

  /// No description provided for @terrImportBadgeDupRow.
  ///
  /// In en, this message translates to:
  /// **'Duplicate row'**
  String get terrImportBadgeDupRow;

  /// No description provided for @terrImportLine.
  ///
  /// In en, this message translates to:
  /// **'Line {line}'**
  String terrImportLine(int line);

  /// No description provided for @terrImportSave.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Import 1 territory} other{Import {count} territories}}'**
  String terrImportSave(int count);

  /// No description provided for @terrImportDone.
  ///
  /// In en, this message translates to:
  /// **'Imported {created} new, updated {updated}.'**
  String terrImportDone(int created, int updated);

  /// No description provided for @terrImportEmpty.
  ///
  /// In en, this message translates to:
  /// **'No rows found in the input.'**
  String get terrImportEmpty;

  /// No description provided for @terrDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this territory? This can\'t be undone.'**
  String get terrDeleteConfirm;

  /// No description provided for @terrSortByTerritory.
  ///
  /// In en, this message translates to:
  /// **'Territory'**
  String get terrSortByTerritory;

  /// No description provided for @terrSortByPublisher.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get terrSortByPublisher;

  /// No description provided for @terrSortByDate.
  ///
  /// In en, this message translates to:
  /// **'Date assigned'**
  String get terrSortByDate;

  /// No description provided for @terrHistoryOngoing.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get terrHistoryOngoing;

  /// No description provided for @terrHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No assignment history yet.'**
  String get terrHistoryEmpty;

  /// No description provided for @mgEmpty.
  ///
  /// In en, this message translates to:
  /// **'No ministry groups yet.'**
  String get mgEmpty;

  /// No description provided for @mgAdd.
  ///
  /// In en, this message translates to:
  /// **'Add group'**
  String get mgAdd;

  /// No description provided for @mgEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit group'**
  String get mgEdit;

  /// No description provided for @mgName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get mgName;

  /// No description provided for @mgMemberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No members} =1{1 member} other{{count} members}}'**
  String mgMemberCount(int count);

  /// No description provided for @mgNoMembers.
  ///
  /// In en, this message translates to:
  /// **'No members in this group yet.'**
  String get mgNoMembers;

  /// No description provided for @mgOverseer.
  ///
  /// In en, this message translates to:
  /// **'Group overseer'**
  String get mgOverseer;

  /// No description provided for @mgAssistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get mgAssistant;

  /// No description provided for @mgMakeOverseer.
  ///
  /// In en, this message translates to:
  /// **'Set as group overseer'**
  String get mgMakeOverseer;

  /// No description provided for @mgMakeAssistant.
  ///
  /// In en, this message translates to:
  /// **'Set as assistant'**
  String get mgMakeAssistant;

  /// No description provided for @mgClearRole.
  ///
  /// In en, this message translates to:
  /// **'Remove overseer/assistant designation'**
  String get mgClearRole;

  /// No description provided for @mgAddMember.
  ///
  /// In en, this message translates to:
  /// **'Add member…'**
  String get mgAddMember;

  /// No description provided for @mgNoUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Everyone is already in a group.'**
  String get mgNoUnassigned;

  /// No description provided for @mgRemoveMember.
  ///
  /// In en, this message translates to:
  /// **'Remove from group'**
  String get mgRemoveMember;

  /// No description provided for @mgDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this group? Its members will be left without a group.'**
  String get mgDeleteConfirm;

  /// No description provided for @mgGroup.
  ///
  /// In en, this message translates to:
  /// **'Ministry group'**
  String get mgGroup;

  /// No description provided for @mgNoGroup.
  ///
  /// In en, this message translates to:
  /// **'No group'**
  String get mgNoGroup;

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
  /// **'Active Publishers (reported at least once in the last 6 months)'**
  String get s1Active;

  /// No description provided for @s1AvgMid.
  ///
  /// In en, this message translates to:
  /// **'Average Midweek Meeting Attendance'**
  String get s1AvgMid;

  /// No description provided for @s1AvgWeekend.
  ///
  /// In en, this message translates to:
  /// **'Average Weekend Meeting Attendance'**
  String get s1AvgWeekend;

  /// No description provided for @s1Publishers.
  ///
  /// In en, this message translates to:
  /// **'Publishers'**
  String get s1Publishers;

  /// No description provided for @s1AuxPioneers.
  ///
  /// In en, this message translates to:
  /// **'Auxiliary Pioneers'**
  String get s1AuxPioneers;

  /// No description provided for @s1RegPioneers.
  ///
  /// In en, this message translates to:
  /// **'Regular Pioneers'**
  String get s1RegPioneers;

  /// No description provided for @s1Count.
  ///
  /// In en, this message translates to:
  /// **'Number of Reports'**
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

  /// No description provided for @settingsLmmClassCount.
  ///
  /// In en, this message translates to:
  /// **'Midweek meeting classes'**
  String get settingsLmmClassCount;

  /// No description provided for @settingsWeekendMeeting.
  ///
  /// In en, this message translates to:
  /// **'Weekend meeting (day and time)'**
  String get settingsWeekendMeeting;

  /// No description provided for @settingsBackupSection.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get settingsBackupSection;

  /// No description provided for @settingsBackupDescription.
  ///
  /// In en, this message translates to:
  /// **'Download a full copy of your congregation\'s data, or restore it from a backup file. Use this to recover from an accidental deletion or a bad edit.'**
  String get settingsBackupDescription;

  /// No description provided for @settingsExportData.
  ///
  /// In en, this message translates to:
  /// **'Export all data'**
  String get settingsExportData;

  /// No description provided for @settingsImportData.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup…'**
  String get settingsImportData;

  /// No description provided for @backupExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup downloaded ({count} records).'**
  String backupExportSuccess(int count);

  /// No description provided for @backupImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get backupImportTitle;

  /// No description provided for @backupImportPick.
  ///
  /// In en, this message translates to:
  /// **'Choose backup file…'**
  String get backupImportPick;

  /// No description provided for @backupImportEmpty.
  ///
  /// In en, this message translates to:
  /// **'Choose a backup file to preview its contents.'**
  String get backupImportEmpty;

  /// No description provided for @backupImportContents.
  ///
  /// In en, this message translates to:
  /// **'Contents'**
  String get backupImportContents;

  /// No description provided for @backupImportFrom.
  ///
  /// In en, this message translates to:
  /// **'Backup of {name} · {date}'**
  String backupImportFrom(String name, String date);

  /// No description provided for @backupImportWarning.
  ///
  /// In en, this message translates to:
  /// **'Restoring overwrites current records that share an ID with the versions in this backup. Records added since the backup are kept. This cannot be undone.'**
  String get backupImportWarning;

  /// No description provided for @backupImportConfirm.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup'**
  String get backupImportConfirm;

  /// No description provided for @backupImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Restored {count} records.'**
  String backupImportSuccess(int count);

  /// No description provided for @backupImportPartial.
  ///
  /// In en, this message translates to:
  /// **'Restored {count} records. Could not restore: {collections}.'**
  String backupImportPartial(int count, String collections);

  /// No description provided for @backupInvalidFile.
  ///
  /// In en, this message translates to:
  /// **'This file is not a valid congregation backup.'**
  String get backupInvalidFile;

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
  /// **'Treasures From God’s Word'**
  String get qTreasures;

  /// No description provided for @qGems.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Gems'**
  String get qGems;

  /// No description provided for @qBibleReading.
  ///
  /// In en, this message translates to:
  /// **'Bible Reading'**
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

  /// No description provided for @qMinistryMeetingConductor.
  ///
  /// In en, this message translates to:
  /// **'Ministry meeting conductor'**
  String get qMinistryMeetingConductor;
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
      <String>['cs', 'en', 'tr'].contains(locale.languageCode);

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
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
