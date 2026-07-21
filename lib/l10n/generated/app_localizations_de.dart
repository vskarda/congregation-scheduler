// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Versammlungsplaner';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonEdit => 'Bearbeiten';

  @override
  String get commonAdd => 'Hinzufügen';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonLoading => 'Wird geladen…';

  @override
  String get commonError => 'Etwas ist schiefgelaufen';

  @override
  String commonErrorDetail(String message) {
    return 'Etwas ist schiefgelaufen: $message';
  }

  @override
  String get commonFieldRequired => 'Dieses Feld ist erforderlich';

  @override
  String get commonConfirmDeleteTitle => 'Löschen?';

  @override
  String get commonConfirmDeleteBody =>
      'Das kann nicht rückgängig gemacht werden.';

  @override
  String get commonToday => 'Heute';

  @override
  String get commonAll => 'Alle';

  @override
  String get commonNone => 'Keine';

  @override
  String get commonYes => 'Ja';

  @override
  String get commonNo => 'Nein';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSearch => 'Suchen';

  @override
  String get commonNotAssigned => '—';

  @override
  String get commonLanguage => 'Sprache';

  @override
  String get setupTitle => 'Mit deiner Versammlung verbinden';

  @override
  String get setupIntro =>
      'Diese App verbindet sich direkt mit der Datenbank deiner Versammlung. Füge die Konfiguration ein, die du von deinem Administrator erhalten hast, oder scanne den Einladungs-QR-Code.';

  @override
  String get setupConfigLabel => 'Firebase-Konfiguration (JSON)';

  @override
  String get setupConfigHint => 'apiKey, authDomain, projectId, …';

  @override
  String get setupScanQr => 'QR-Code scannen';

  @override
  String get setupPickQrImage => 'QR-Code-Foto auswählen';

  @override
  String get setupQrNotFoundInImage =>
      'In diesem Bild wurde kein QR-Code gefunden.';

  @override
  String get setupConnect => 'Verbinden';

  @override
  String get setupInvalidJson =>
      'Das ist keine gültige Konfigurations-JSON. Sie muss mindestens apiKey, projectId und appId enthalten.';

  @override
  String setupConnectionFailed(String message) {
    return 'Verbindung mit dieser Konfiguration nicht möglich: $message';
  }

  @override
  String get setupModeTitle => 'Wie möchtest du anfangen?';

  @override
  String get setupModeJoin => 'Meiner Versammlung beitreten';

  @override
  String get setupModeJoinSubtitle =>
      'Ein Administrator hat dich eingeladen. Nach der Registrierung wird er dein Konto bestätigen.';

  @override
  String get setupModeNew => 'Eine neue Versammlung einrichten';

  @override
  String get setupModeNewSubtitle =>
      'Du bist der erste Administrator eines frisch erstellten Firebase-Projekts.';

  @override
  String get setupCongregationExists =>
      'Diese Versammlung ist bereits eingerichtet. Wähle stattdessen «Meiner Versammlung beitreten».';

  @override
  String get setupDatabaseNotReady =>
      'Die Datenbank der Versammlung startet noch. Bitte warte einen Moment und versuche es erneut.';

  @override
  String get setupReconfigure => 'Konfiguration ändern';

  @override
  String get setupRestartRequired =>
      'Konfiguration gespeichert. Schließe die App und öffne sie erneut, um sie anzuwenden.';

  @override
  String get setupGuideLinkIntro =>
      'Keine Konfiguration? Erstelle die eigene kostenlose Datenbank deiner Versammlung:';

  @override
  String get setupGuideLinkButton => 'So richtest du eine neue Versammlung ein';

  @override
  String get setupGuideTitle => 'Eine neue Versammlung einrichten';

  @override
  String get setupGuideIntro =>
      'Diese App wird selbst gehostet: Die Daten deiner Versammlung liegen in eurem eigenen kostenlosen Google-Firebase-Projekt, auf das niemand sonst zugreifen kann. Die Einrichtung dauert etwa 15 Minuten und erfordert keine Programmierung – du brauchst nur ein Google-Konto. Folge den Schritten unten auf diesem Telefon oder an einem Computer.';

  @override
  String get setupGuideOpenConsole => 'Firebase-Konsole öffnen';

  @override
  String get setupGuideStep1Title => 'Ein Firebase-Projekt erstellen';

  @override
  String get setupGuideStep1Body1 =>
      'Öffne console.firebase.google.com, melde dich mit deinem Google-Konto an und tippe auf «Get started by setting up a Firebase project».';

  @override
  String get setupGuideStep1Body2 =>
      'Benenne das Projekt, z. B. «versammlung-meinstadt», akzeptiere die Bedingungen und fahre fort. Wenn Google Analytics angeboten wird, deaktiviere es – es wird nicht benötigt. Bleib beim kostenlosen Spark-Tarif; die App ist so ausgelegt, dass nie eine Abrechnung nötig ist.';

  @override
  String get setupGuideStep2Title => 'E-Mail-Anmeldung aktivieren';

  @override
  String get setupGuideStep2Body1 =>
      'Wähle im linken Menü Security → Authentication.';

  @override
  String get setupGuideStep2Body2 => 'Tippe auf «Get started».';

  @override
  String get setupGuideStep2Body3 =>
      'Wähle auf der Registerkarte «Sign-in method» Email/Password.';

  @override
  String get setupGuideStep2Body4 =>
      'Aktiviere den ersten Schalter (lass «Email link» aus) und tippe auf Save.';

  @override
  String get setupGuideStep3Title => 'Die Firestore-Datenbank erstellen';

  @override
  String get setupGuideStep3Body1 =>
      'Wähle im linken Menü Databases & Storage → Firestore.';

  @override
  String get setupGuideStep3Body2 => 'Tippe auf «Create database».';

  @override
  String get setupGuideStep3Body3 => 'Wähle die Standard-Edition.';

  @override
  String get setupGuideStep3Body4 =>
      'Wähle einen Standort in deiner Nähe (z. B. europe-west3 für Mitteleuropa). Er kann später nicht mehr geändert werden.';

  @override
  String get setupGuideStep3Body5 => 'Beginne im Produktionsmodus …';

  @override
  String get setupGuideStep3Body6 => '… und tippe auf Create.';

  @override
  String get setupGuideStep4Title => 'Die Sicherheitsregeln installieren';

  @override
  String get setupGuideStep4Body1 =>
      'Die Regeln legen fest, wer welche Daten lesen und schreiben darf (z. B. sehen nur bestätigte Verkündiger die Pläne). Öffne in der Firestore-Datenbank die Registerkarte Rules und tippe auf «Edit rules».';

  @override
  String get setupGuideStep4Body2 =>
      'Lösche alles im Editor und füge die kopierten Regeln ein.';

  @override
  String get setupGuideStep4Body3 => 'Tippe auf Publish.';

  @override
  String get setupGuideStep4Note =>
      'Wiederhole diesen Schritt, wenn eine neue App-Version aktualisierte Regeln mitbringt.';

  @override
  String get setupGuideStep5Title => 'Die App-Konfiguration abrufen';

  @override
  String get setupGuideStep5Body1 =>
      'Tippe auf das Zahnrad-Symbol neben «Project Overview» (oben links) und wähle Project settings.';

  @override
  String get setupGuideStep5Body2 =>
      'Scrolle auf der Registerkarte General zu «Your apps» und tippe auf das Web-Symbol </>.';

  @override
  String get setupGuideStep5Body3 =>
      'Gib einen Spitznamen ein, z. B. «congregation-app», lass das Hosting deaktiviert und tippe auf «Register app».';

  @override
  String get setupGuideStep5Body4 =>
      'Ein Codeblock mit «const firebaseConfig = …» erscheint. Markiere und kopiere nur die Konfiguration zwischen den geschweiften Klammern – die Klammern eingeschlossen.';

  @override
  String get setupGuideStep5Note =>
      'Diese Konfiguration ist nicht geheim – sie identifiziert nur dein Projekt. Die Daten sind durch die Sicherheitsregeln aus Schritt 4 geschützt.';

  @override
  String get setupGuideRulesTitle => 'Sicherheitsregeln (firestore.rules)';

  @override
  String get setupGuideRulesCopy => 'Regeln kopieren';

  @override
  String get setupGuideRulesCopied => 'Regeln in die Zwischenablage kopiert.';

  @override
  String get setupGuideRulesView => 'Regeltext anzeigen';

  @override
  String get setupGuideRulesLoadError =>
      'Der Regeltext konnte nicht geladen werden.';

  @override
  String get setupGuideFinish =>
      'Fertig! Geh zurück, füge die kopierte Konfiguration ein und tippe auf Verbinden. Wähle dann «Eine neue Versammlung einrichten» und registriere dich als erster Administrator.';

  @override
  String get setupGuideBackToConnect => 'Zurück zum Verbindungsbildschirm';

  @override
  String get languageSystem => 'Systemsprache';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageCzech => 'Čeština';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languageFrench => 'Français';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languagePolish => 'Polski';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageJapanese => '日本語';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String themeTooltip(String mode) {
    return 'Design: $mode';
  }

  @override
  String get profileCompleteTitle => 'Vervollständige dein Profil';

  @override
  String get profileCompleteBody =>
      'Dein Konto existiert, aber das Profil fehlt. Gib deinen Namen ein, um die Registrierung abzuschließen.';

  @override
  String get authSignIn => 'Anmelden';

  @override
  String get authSignOut => 'Abmelden';

  @override
  String get authRegister => 'Konto erstellen';

  @override
  String get authEmail => 'E-Mail';

  @override
  String get authPassword => 'Passwort';

  @override
  String get authPasswordConfirm => 'Passwort bestätigen';

  @override
  String get authPasswordsDontMatch => 'Die Passwörter stimmen nicht überein';

  @override
  String get authForgotPassword => 'Passwort vergessen?';

  @override
  String get authResetSent =>
      'Eine E-Mail zum Zurücksetzen des Passworts wurde gesendet.';

  @override
  String get authEnterEmailForReset =>
      'Gib zuerst deine E-Mail-Adresse ein und tippe dann auf «Passwort vergessen?», um einen Link zum Zurücksetzen zu erhalten.';

  @override
  String get authNoAccountYet => 'Noch kein Konto? Erstelle eins';

  @override
  String get authHaveAccount => 'Hast du schon ein Konto? Melde dich an';

  @override
  String get authErrorInvalidCredentials =>
      'Falsche E-Mail oder falsches Passwort.';

  @override
  String get authErrorEmailInUse =>
      'Ein Konto mit dieser E-Mail existiert bereits.';

  @override
  String get authErrorWeakPassword =>
      'Das Passwort ist zu schwach (mindestens 6 Zeichen).';

  @override
  String authErrorGeneric(String message) {
    return 'Anmeldung fehlgeschlagen: $message';
  }

  @override
  String get authFirstName => 'Vorname';

  @override
  String get authLastName => 'Nachname';

  @override
  String get authCongregationName => 'Name der Versammlung';

  @override
  String get awaitingTitle => 'Warten auf Bestätigung';

  @override
  String get awaitingBody =>
      'Dein Konto wurde erstellt. Ein Administrator der Versammlung muss es nun bestätigen, bevor du Versammlungsinformationen sehen kannst.';

  @override
  String get deleteAccountAction => 'Mein Konto löschen';

  @override
  String get deleteAccountWarning =>
      'Dadurch werden dein Konto und dein persönliches Profil (Name, Kontaktdaten und Anmeldung) endgültig gelöscht. Das kann nicht rückgängig gemacht werden. Die von dir eingereichten Berichte bleiben bei der Versammlung gespeichert.';

  @override
  String get deleteAccountPasswordLabel =>
      'Gib zur Bestätigung dein Passwort ein';

  @override
  String get deleteAccountConfirm => 'Konto löschen';

  @override
  String get deleteAccountSoleAdminTitle => 'Du bist der einzige Administrator';

  @override
  String get deleteAccountSoleAdminBody =>
      'Du bist der einzige Volladministrator der Versammlung. Erteile zuerst einem anderen Mitglied Volladministratorrechte; andernfalls würde das Löschen deines Kontos die Versammlung ohne Administrator und ohne Möglichkeit zur Wiederherstellung des Zugriffs zurücklassen.';

  @override
  String get changePasswordAction => 'Passwort ändern';

  @override
  String get changePasswordCurrentLabel => 'Aktuelles Passwort';

  @override
  String get changePasswordNewLabel => 'Neues Passwort';

  @override
  String get changePasswordConfirmLabel => 'Neues Passwort bestätigen';

  @override
  String get changePasswordConfirm => 'Passwort aktualisieren';

  @override
  String get changePasswordSuccess => 'Passwort aktualisiert.';

  @override
  String get navInfoBoard => 'Anschlagbrett';

  @override
  String get navEvents => 'Veranstaltungen';

  @override
  String get navLmm => 'Zusammenkunft unter der Woche';

  @override
  String get navWeekend => 'Zusammenkunft am Wochenende';

  @override
  String get navPublicWitnessing => 'Öffentliches Zeugnisgeben';

  @override
  String get navFieldServiceMeetings => 'Zusammenkünfte für den Predigtdienst';

  @override
  String get navTerritories => 'Gebiete';

  @override
  String get navMinistryGroups => 'Dienstgruppen';

  @override
  String get navReport => 'Predigtdienstbericht';

  @override
  String get navAttendance => 'Anwesenheit';

  @override
  String get navProfile => 'Mein Profil';

  @override
  String get navAdmin => 'Verwaltung';

  @override
  String get navPublishersAdmin => 'Verkündiger';

  @override
  String get navReportsAdmin => 'Berichtsübersicht';

  @override
  String get navS1 => 'S-1-Bericht';

  @override
  String get navTalks => 'Themen öffentlicher Vorträge';

  @override
  String get navSettings => 'Versammlungseinstellungen';

  @override
  String get navStatistics => 'Statistik';

  @override
  String get navHelp => 'Hilfe';

  @override
  String get helpPublisherSection => 'Tipps für Verkündiger';

  @override
  String get helpAdminSection => 'Für Administratoren';

  @override
  String get helpCalendarTitle => 'Zum Kalender hinzufügen';

  @override
  String get helpCalendarBody =>
      'In der Handy-App zeigen Veranstaltungen und deine Aufgaben ein Kalendersymbol. Tippe darauf, um den Eintrag zum Kalender deines Geräts hinzuzufügen.';

  @override
  String get helpRemindersTitle => 'Erinnerungen an Aufgaben';

  @override
  String get helpRemindersBody =>
      'Tippe im Bildschirm Veranstaltungen auf das Glockensymbol neben «Meine nächsten Aufgaben», um vor jeder Aufgabe benachrichtigt zu werden – du wählst, wie lange im Voraus. (Nur Handy-App.)';

  @override
  String get helpHighlightTitle => 'Finde dich auf einen Blick';

  @override
  String get helpHighlightBody =>
      'In den Zusammenkunftsplänen ist dein eigener Name hervorgehoben, damit du deine Aufgaben schnell erkennst.';

  @override
  String get helpTerritoryMapTitle => 'Eine Gebietskarte öffnen';

  @override
  String get helpTerritoryMapBody =>
      'Tippe auf das Kartensymbol neben einem Gebiet, um seine Karte zu öffnen. Ein graues Symbol bedeutet, dass für dieses Gebiet noch kein Kartenlink hinzugefügt wurde.';

  @override
  String get helpAdminToggleTitle => 'Die App als Verkündiger sehen';

  @override
  String get helpAdminToggleBody =>
      'Das Stiftsymbol in der oberen Leiste blendet vorübergehend alle Verwaltungswerkzeuge aus, sodass du die App genauso siehst wie die Verkündiger. Tippe erneut, um sie zurückzuholen.';

  @override
  String get helpPdfExportTitle => 'Pläne drucken oder teilen';

  @override
  String get helpPdfExportBody =>
      'In den Bildschirmen Zusammenkunft unter der Woche und Zusammenkunft am Wochenende haben Planbearbeiter ein PDF-Symbol in der oberen Leiste, das den Plan des Monats zum Drucken oder Teilen exportiert.';

  @override
  String get helpGoogleMyMapsTitle => 'Gebietskarten mit Google My Maps';

  @override
  String get helpGoogleMyMapsBody =>
      'Erstelle deine Gebietskarten in Google My Maps und füge den Freigabelink jedes Gebiets in sein Kartenlink-Feld ein. Eine Schritt-für-Schritt-Anleitung ist auf GitHub verfügbar.';

  @override
  String get helpOpenGuide => 'Anleitung öffnen';

  @override
  String get helpDataDelayTitle =>
      'Änderungen können einen Moment brauchen, bis sie erscheinen';

  @override
  String get helpDataDelayBody =>
      'Änderungen in der App – zum Beispiel Bearbeitungen unter Verkündiger – können bis zu einer Minute brauchen, bis sie sichtbar werden. (Manchmal zeigt zum Beispiel ein S-21-Import die Dienststunden des laufenden Dienstjahres nicht sofort an.)';

  @override
  String get helpPwApplyTitle => 'Für das öffentliche Zeugnisgeben melden';

  @override
  String get helpPwApplyBody =>
      'Öffne Öffentliches Zeugnisgeben, suche einen Termin und tippe auf das Hand-Symbol, um dich zu melden; tippe erneut, um dich zurückzuziehen. Wenn du das Symbol nicht siehst, bitte einen Administrator, die Befähigung «Öffentliches Zeugnisgeben» in deinem Datensatz zu aktivieren.';

  @override
  String get helpPwAssignTitle =>
      'Verkündiger zum öffentlichen Zeugnisgeben einteilen';

  @override
  String get helpPwAssignBody =>
      'Aktiviere die Befähigung «Öffentliches Zeugnisgeben» jedes Freiwilligen unter Verkündiger → einen Verkündiger öffnen → Befähigungen. Öffne dann unter Öffentliches Zeugnisgeben einen Termin und tippe auf «Eingeteilt»: Verkündiger, die sich gemeldet haben, stehen oben in der Liste mit dem Abzeichen «Gemeldet». Verwende wiederkehrende Termine für wöchentliche Wagen oder Stände.';

  @override
  String get helpS21Title => 'S-21-Datensätze importieren';

  @override
  String get helpS21Body =>
      'Du kannst die Verkündigerberichtskarte (S-21) eines Verkündigers aus einer PDF importieren. Öffne Verkündiger → einen Verkündiger → S-21 und wähle die Datei. Es wird nur die Textebene der PDF gelesen, daher lassen sich gescannte oder reduzierte Formulare möglicherweise nicht importieren.';

  @override
  String get helpS99Title => 'Themen öffentlicher Vorträge importieren (S-99)';

  @override
  String get helpS99Body =>
      'Wähle unter Themen öffentlicher Vorträge «Themen aus PDF aktualisieren» und wähle ein offizielles S-99-Formular als PDF. Kommende Wochenendzusammenkünfte, die sich auf diese Vortragsnummern beziehen, werden automatisch aktualisiert.';

  @override
  String get adminToggleHide => 'Verwaltungsoptionen ausblenden';

  @override
  String get adminToggleShow => 'Verwaltungsoptionen anzeigen';

  @override
  String get profilePhone => 'Telefonnummer';

  @override
  String get profileAddress => 'Adresse';

  @override
  String get profileBirthDate => 'Geburtsdatum';

  @override
  String get profileBaptismDate => 'Taufdatum';

  @override
  String get profileGender => 'Geschlecht';

  @override
  String get genderUnknown => '—';

  @override
  String get genderMale => 'Männlich';

  @override
  String get genderFemale => 'Weiblich';

  @override
  String get profileHope => 'Hoffnung';

  @override
  String get hopeOtherSheep => 'Anderes Schaf';

  @override
  String get hopeAnointed => 'Gesalbter';

  @override
  String get profileStatus => 'Dienststatus';

  @override
  String get statusNone => '-';

  @override
  String get statusPublisher => 'Verkündiger';

  @override
  String get statusAuxPioneer => 'Hilfspionier';

  @override
  String get statusRegPioneer => 'Allgemeiner Pionier';

  @override
  String get statusSpecialPioneer => 'Sonderpionier';

  @override
  String get statusFieldMissionary => 'Missionar';

  @override
  String get profileAppointment => 'Ernennung';

  @override
  String get appointmentMinisterialServant => 'Dienstamtgehilfe';

  @override
  String get appointmentElder => 'Ältester';

  @override
  String get profileEmergency => 'Notfallnotiz';

  @override
  String get profileEmergencyHint => 'Wen im Notfall kontaktieren';

  @override
  String get profileSaved => 'Gespeichert';

  @override
  String get profileRecord => 'Verkündigerkarte';

  @override
  String serviceYear(int year) {
    return 'Dienstjahr $year';
  }

  @override
  String get recordTotalHours => 'Gesamtstunden';

  @override
  String get recordAverageHours => 'Monatsdurchschnitt';

  @override
  String get reportMonth => 'Monat';

  @override
  String get reportParticipated => 'Hat sich am Predigtdienst beteiligt';

  @override
  String get reportStudies => 'Bibelstudien';

  @override
  String get reportHours => 'Stunden';

  @override
  String get reportCredit => 'Anrechenbare Stunden';

  @override
  String get reportComments => 'Kommentare';

  @override
  String get s21Export => 'S-21 exportieren (PDF)';

  @override
  String get schedulePdfExport => 'Monatsübersicht (PDF)';

  @override
  String get lmmScheduleTitle => 'Zusammenkunft unter der Woche';

  @override
  String get s21Title => 'VERKÜNDIGERBERICHTSKARTE DER VERSAMMLUNG';

  @override
  String get s21Name => 'Name:';

  @override
  String get s21DateOfBirth => 'Geburtsdatum:';

  @override
  String get s21DateOfBaptism => 'Taufdatum:';

  @override
  String get s21HoursHeader => 'Stunden (Falls Pionier oder Missionar)';

  @override
  String get s21Remarks => 'Bemerkungen';

  @override
  String get s21Total => 'Insgesamt';

  @override
  String get s21FormCode => 'S-21-X 11/23';

  @override
  String s21Credit(int hours) {
    return 'Gutschrift: $hours';
  }

  @override
  String get s21Import => 'S-21 importieren (PDF)';

  @override
  String get s21ImportNew => 'Verkündiger aus S-21 importieren';

  @override
  String get s21ImportTitle => 'S-21 importieren';

  @override
  String get s21ImportPickFile => 'PDF-Datei auswählen';

  @override
  String get s21ImportHint =>
      'Wähle eine S-21-Verkündigerberichtskarte (PDF). Die Werte der Karte ersetzen die Profilfelder des Verkündigers und die Monatsberichte.';

  @override
  String get s21ImportNoData =>
      'In dieser Datei wurden keine S-21-Daten gefunden.';

  @override
  String s21ImportMonths(int count) {
    return '$count Monatsberichte gefunden';
  }

  @override
  String s21ImportNameKept(String name) {
    return 'Der Name in der App wird beibehalten: $name';
  }

  @override
  String s21ImportCardName(String name) {
    return 'Name auf der Karte: $name';
  }

  @override
  String s21ImportDuplicateName(String name) {
    return 'Ein Verkündiger mit dem Namen «$name» existiert bereits.';
  }

  @override
  String get s21ImportUseExisting => 'In den bestehenden Datensatz importieren';

  @override
  String get s21ImportReplaceTitle => 'Bestehende Datensätze ersetzen?';

  @override
  String get s21ImportReplaceBody =>
      'Die Profilfelder des Verkündigers und die Monatsberichte der importierten Dienstjahre werden durch die Werte dieser S-21 ersetzt. Das kann nicht rückgängig gemacht werden.';

  @override
  String get s21ImportSave => 'Importieren';

  @override
  String get s21ImportDone => 'S-21 importiert.';

  @override
  String get s21ImportAssignYear => 'Dienstjahr dieser Tabelle';

  @override
  String get pubAdminInvite => 'Einladen';

  @override
  String get pubAdminInviteTitle => 'Zur Versammlung einladen';

  @override
  String get pubAdminInviteBody =>
      'Das neue Mitglied scannt diesen QR-Code in der App, registriert sich und erscheint dann unten als nicht bestätigt. Bestätige es, um Zugriff zu gewähren.';

  @override
  String get pubAdminAddRecord => 'Verkündigerkarte hinzufügen';

  @override
  String get pubAdminAddRecordHint =>
      'Ein Datensatz für ein Mitglied, das die App nicht nutzt; die Berichte können von Administratoren eingegeben werden.';

  @override
  String get pubAdminVerified => 'Bestätigt';

  @override
  String get pubAdminUnverifiedBadge => 'Warten auf Bestätigung';

  @override
  String get pubAdminNoAccountBadge => 'Kein App-Konto';

  @override
  String get pubAdminTabProfile => 'Profil';

  @override
  String get pubAdminTabRoles => 'Rechte';

  @override
  String get pubAdminTabAssign => 'Einteilen';

  @override
  String get pubAdminTabRecord => 'Karte';

  @override
  String get pubAdminDeleteConfirm =>
      'Diesen Verkündiger und seine privaten Daten löschen? Seine Berichte bleiben gespeichert.';

  @override
  String get pubAdminDeleteMovedHint =>
      'Wenn er ein App-Konto hat, entfernt das Löschen seine Anmeldung nicht und er könnte sich erneut anmelden. Um jemanden zu archivieren, der weggezogen ist, verwende stattdessen «Als weggezogen markieren».';

  @override
  String get pubAdminMarkMoved => 'Als weggezogen markieren';

  @override
  String get pubAdminRestoreMoved => 'Aus Weggezogenen wiederherstellen';

  @override
  String get pubAdminMovedBadge => 'Weggezogen';

  @override
  String get pubAdminShowMoved => 'Weggezogene anzeigen';

  @override
  String get pubFilterPioneers => 'Pioniere';

  @override
  String get pubFilterHasRights => 'Mit Rechten';

  @override
  String get pubFilterAnyGroup => 'Beliebige Gruppe';

  @override
  String get pubFilterClear => 'Löschen';

  @override
  String get pubAdminMoveConfirmTitle => 'Als weggezogen markieren?';

  @override
  String get pubAdminMoveConfirmBody =>
      'Der Datensatz und der Berichtsverlauf bleiben erhalten, aber der Verkündiger wird archiviert: Sein Zugriff wird entzogen und er erscheint nicht mehr in Plänen oder Berichtslisten. Du kannst ihn später wiederherstellen.';

  @override
  String get pubAdminSelfVerifiedWarningTitle =>
      'Deinen eigenen Bestätigt-Status deaktivieren?';

  @override
  String get pubAdminSelfVerifiedWarningBody =>
      'Du entfernst den Status Bestätigt von deinem eigenen Konto. Du verlierst sofort den Zugriff auf die Daten der Versammlung, und nur ein anderer Volladministrator kann ihn wiederherstellen. Möchtest du wirklich fortfahren?';

  @override
  String get pubAdminSelfFullAdminWarningTitle =>
      'Deine eigenen Volladministratorrechte entfernen?';

  @override
  String get pubAdminSelfFullAdminWarningBody =>
      'Du entfernst die Rolle des Volladministrators von deinem eigenen Konto. Wenn du der einzige Administrator bist, kann das niemand – auch du nicht – rückgängig machen. Möchtest du wirklich fortfahren?';

  @override
  String get pubAdminSelfWarningConfirm => 'Meinen Zugriff entfernen';

  @override
  String get pubConnectBanner =>
      'Dieses Konto wartet auf Bestätigung. Wenn ein Administrator bereits eine Verkündigerkarte für diese Person erstellt hat, verbinde die beiden: Der Verlauf der Karte geht auf dieses Konto über und der doppelte Datensatz verschwindet.';

  @override
  String get pubConnectAction => 'Mit bestehendem Datensatz verbinden';

  @override
  String get pubConnectNeedsFullAdmin =>
      'Nur ein Volladministrator kann Datensätze verbinden (die Migration berührt die Daten jedes Bereichs).';

  @override
  String get pubConnectPickTitle => 'Mit bestehendem Datensatz verbinden';

  @override
  String pubConnectPickHint(String name) {
    return 'Wähle den Datensatz, der zu $name gehört.';
  }

  @override
  String get pubConnectNoRecords =>
      'Es gibt keine Verkündigerkarte ohne App-Konto zum Verbinden.';

  @override
  String get pubConnectConfirmTitle => 'Verbinden und zusammenführen?';

  @override
  String pubConnectConfirmBody(String record, String account) {
    return 'Der gesamte Verlauf von «$record» – Berichte, Gebiete und Planeinteilungen – wird auf das Konto von «$account» übertragen. Das Konto wird bestätigt und der doppelte Datensatz wird endgültig gelöscht. Das kann nicht rückgängig gemacht werden.';
  }

  @override
  String get pubConnectProgressTitle => 'Datensatz wird verbunden …';

  @override
  String get pubConnectProgressBody =>
      'Schließe die App nicht, während der Verlauf übertragen wird.';

  @override
  String pubConnectFailed(String section) {
    return 'Das Verbinden ist fehlgeschlagen bei: $section. Abgeschlossene Schritte bleiben erhalten – ein erneuter Versuch ist sicher und setzt dort fort, wo es aufgehört hat.';
  }

  @override
  String get pubConnectSuccess =>
      'Datensatz verbunden – sein Verlauf gehört jetzt zu diesem Konto.';

  @override
  String get roleFullAdmin => 'Volladministrator';

  @override
  String get roleRecordAttendance => 'Anwesenheit erfassen';

  @override
  String get weekNoSchedule => 'Noch kein Plan für diese Woche.';

  @override
  String get weekCreateEmpty => 'Leere Woche erstellen';

  @override
  String get weekImportEpub => 'Aus .epub importieren';

  @override
  String get weekCheckCdn => 'Online prüfen';

  @override
  String get weekDelete => 'Diese Woche löschen';

  @override
  String get lmmSongs => 'Lieder';

  @override
  String get sectionOpening => 'Eröffnung';

  @override
  String get sectionTreasures => 'SCHÄTZE AUS GOTTES WORT';

  @override
  String get sectionMinistry => 'UNS IM DIENST VERBESSERN';

  @override
  String get sectionLiving => 'UNSER LEBEN ALS CHRIST';

  @override
  String get sectionClosing => 'Abschluss';

  @override
  String get partChairman => 'Vorsitzender';

  @override
  String get partOpeningPrayer => 'Anfangsgebet';

  @override
  String get partClosingPrayer => 'Schlussgebet';

  @override
  String get partGems => 'Nach geistigen Schätzen graben';

  @override
  String get partBibleReading => 'Bibellesung';

  @override
  String get partCbs => 'Versammlungsbibelstudium';

  @override
  String get partCbsReader => 'Leser';

  @override
  String get partAssistant => 'Partner';

  @override
  String partMinutes(int min) {
    return '$min Min.';
  }

  @override
  String get lmmClassMain => 'Hauptsaal';

  @override
  String lmmClassN(int index) {
    return 'Klasse $index';
  }

  @override
  String get partEdit => 'Programmpunkt bearbeiten';

  @override
  String get partTitle => 'Titel';

  @override
  String get partDescription => 'Beschreibung';

  @override
  String get partDuration => 'Dauer (Min.)';

  @override
  String get partAdd => 'Programmpunkt hinzufügen';

  @override
  String get partDeleteConfirm => 'Diesen Programmpunkt löschen?';

  @override
  String get supportAttendants => 'Ordner';

  @override
  String get supportMicrophones => 'Mikrofone';

  @override
  String get supportAudioVideo => 'Ton und Video';

  @override
  String get customAssignmentAdd => 'Benutzerdefinierte Aufgabe hinzufügen';

  @override
  String get customLabel => 'Bezeichnung';

  @override
  String get customAssignmentPermanent => 'Dauerhaft (jede Woche)';

  @override
  String get customAssignmentRemovePermanentTitle =>
      'Dauerhafte Aufgabe entfernen';

  @override
  String customAssignmentRemovePermanentBody(String label) {
    return '«$label» aus jeder Woche entfernen?';
  }

  @override
  String get pickerQualified => 'Befähigt';

  @override
  String get pickerAll => 'Alle';

  @override
  String get pickerFreeText => 'Text';

  @override
  String pickerLastAssigned(String date) {
    return 'Zuletzt: $date';
  }

  @override
  String get pickerNever => 'Nie eingeteilt';

  @override
  String get pickerApplied => 'Gemeldet';

  @override
  String get importTitle => 'Arbeitsheft für die Zusammenkunft importieren';

  @override
  String get importNoWeeks =>
      'In dieser Datei wurden keine nutzbaren Wochen gefunden.';

  @override
  String get importWeekExists =>
      'Existiert bereits – der Plan wird aktualisiert, die Einteilungen bleiben erhalten';

  @override
  String importSave(int count) {
    return '$count Wochen importieren';
  }

  @override
  String get importDone => 'Importiert.';

  @override
  String get importCdnNothing =>
      'Noch keine Ausgabe des Arbeitshefts online verfügbar.';

  @override
  String get weekendTalkTitle => 'Öffentlicher Vortrag';

  @override
  String get weekendSpeaker => 'Redner';

  @override
  String get weekendChairmanLabel => 'Vorsitzender';

  @override
  String get weekendWtReader => 'Leser des Wachtturms';

  @override
  String get customFieldAdd => 'Programmfeld hinzufügen';

  @override
  String get pickerFromCatalog => 'Aus der Liste';

  @override
  String get talksUpdateFromPdf => 'Themen aus PDF aktualisieren';

  @override
  String get talksPickPdf => 'S-99-PDF auswählen';

  @override
  String get talksParseError =>
      'Aus dieser Datei konnten keine Vortragsthemen gelesen werden. Verwende ein offizielles S-99-Formular als PDF.';

  @override
  String talksImportSummary(int total, int added, int changed, int removed) {
    return '$total Vorträge gefunden: $added neu, $changed geändert, $removed entfernt';
  }

  @override
  String get talksImportSave => 'Themen speichern';

  @override
  String talksImportDone(int count) {
    return 'Themen gespeichert. $count kommende Zusammenkünfte aktualisiert.';
  }

  @override
  String talksLastDelivered(String date) {
    return 'Zuletzt gehalten am $date';
  }

  @override
  String get talksNeverDelivered => 'Noch nicht gehalten';

  @override
  String get talksScheduled => 'eingeplant';

  @override
  String get talksNew => 'Neu';

  @override
  String get talksChanged => 'Geändert';

  @override
  String get talksRemoved => 'Entfernt';

  @override
  String get talksSearchHint => 'Vorträge suchen…';

  @override
  String get talksEmpty =>
      'Noch keine Vortragsthemen. Importiere sie aus einer S-99-PDF.';

  @override
  String get talksOpenCatalog => 'Vortragsthemen verwalten';

  @override
  String get talksEditTitle => 'Thema bearbeiten';

  @override
  String get songLabel => 'Lied';

  @override
  String get songsSearchHint => 'Lieder suchen…';

  @override
  String get songsEmpty =>
      'Noch keine Liederliste. Aktualisiere sie von der offiziellen Website.';

  @override
  String get songsUpdateFromWeb =>
      'Liederliste von der offiziellen Website aktualisieren';

  @override
  String songsUpdateDone(int count) {
    return 'Liederliste aktualisiert: $count Lieder.';
  }

  @override
  String get songsCdnNothing =>
      'Die Liederliste ist noch nicht online verfügbar.';

  @override
  String get songsStatusEmpty => 'Noch keine Liederliste importiert.';

  @override
  String songsStatusLoaded(int count, String date) {
    return '$count Lieder · aktualisiert $date';
  }

  @override
  String get settingsSongsSection => 'Liederliste';

  @override
  String get settingsSongsDescription =>
      'Lade die Titel der Zusammenkunftslieder von jw.org herunter, damit sie in den Plänen für das Wochenende und unter der Woche ausgewählt werden können.';

  @override
  String get pwNoSlots => 'Diese Woche kein öffentliches Zeugnisgeben.';

  @override
  String get pwAddSlot => 'Termin hinzufügen';

  @override
  String get pwEditSlot => 'Termin bearbeiten';

  @override
  String get pwLocation => 'Ort';

  @override
  String get pwTimeFrom => 'Von';

  @override
  String get pwTimeTo => 'Bis';

  @override
  String get pwRecurringRules => 'Wiederkehrende Termine';

  @override
  String get pwRecurringAdd => 'Wiederkehrenden Termin hinzufügen';

  @override
  String get pwWeekday => 'Wochentag';

  @override
  String get pwValidFrom => 'Gültig ab';

  @override
  String get pwValidUntil => 'Gültig bis (optional)';

  @override
  String get pwAssignees => 'Eingeteilt';

  @override
  String get pwDate => 'Datum';

  @override
  String get pwApply => 'Für diesen Termin melden';

  @override
  String get pwWithdraw => 'Meldung zurückziehen';

  @override
  String pwApplicants(int count) {
    return '$count gemeldet';
  }

  @override
  String get fsmNoMeetings =>
      'Diese Woche keine Zusammenkunft für den Predigtdienst.';

  @override
  String get fsmAddMeeting => 'Zusammenkunft hinzufügen';

  @override
  String get fsmEditMeeting => 'Zusammenkunft bearbeiten';

  @override
  String get fsmDate => 'Datum';

  @override
  String get fsmTime => 'Uhrzeit';

  @override
  String get fsmLocation => 'Ort';

  @override
  String get fsmNote => 'Notiz';

  @override
  String get fsmConductor => 'Leiter';

  @override
  String get fsmRecurringRules => 'Wiederkehrende Zusammenkünfte';

  @override
  String get fsmRecurringAdd => 'Wiederkehrende Zusammenkunft hinzufügen';

  @override
  String get fsmWeekday => 'Wochentag';

  @override
  String get fsmValidFrom => 'Gültig ab';

  @override
  String get fsmValidUntil => 'Gültig bis (optional)';

  @override
  String get fsmRecurringDeleteConfirm =>
      'Diese wiederkehrende Zusammenkunft löschen? Ihre zukünftigen Zusammenkünfte werden ebenfalls entfernt. Das kann nicht rückgängig gemacht werden.';

  @override
  String get fsmRemoveAllFutureAction =>
      'Alle zukünftigen Zusammenkünfte entfernen';

  @override
  String get fsmRemoveAllFutureWarning =>
      'Das Entfernen aller zukünftigen Zusammenkünfte löscht jede kommende einmalige und wiederkehrende Zusammenkunft und kann nicht rückgängig gemacht werden.';

  @override
  String get fsmRemoveAllFutureTitle =>
      'Alle zukünftigen Zusammenkünfte entfernen?';

  @override
  String get fsmRemoveAllFutureBody =>
      'Das löscht jede kommende einmalige und wiederkehrende Zusammenkunft für den Predigtdienst und entfernt alle Regeln für wiederkehrende Zusammenkünfte, sodass keine erneut erzeugt wird. Vergangene Zusammenkünfte bleiben erhalten. Das kann nicht rückgängig gemacht werden.';

  @override
  String get fsmRemoveAllFutureConfirm => 'Alle entfernen';

  @override
  String get eventsUpcoming => 'Kommende Veranstaltungen';

  @override
  String get eventsNone => 'Keine kommenden Veranstaltungen.';

  @override
  String get eventAdd => 'Veranstaltung hinzufügen';

  @override
  String get eventEdit => 'Veranstaltung bearbeiten';

  @override
  String get eventTitle => 'Titel';

  @override
  String get eventType => 'Art';

  @override
  String get eventTypeConvention => 'Regionaler Kongress';

  @override
  String get eventTypeAssembly => 'Kreiskongress';

  @override
  String get eventTypeMemorial => 'Gedächtnismahl';

  @override
  String get eventTypeCoVisit => 'Besuch des Kreisaufsehers';

  @override
  String get eventTypeOther => 'Sonstiges';

  @override
  String get eventDateFrom => 'Von';

  @override
  String get eventDateTo => 'Bis (optional)';

  @override
  String get eventLocation => 'Ort';

  @override
  String get eventNotes => 'Notizen';

  @override
  String get eventAddToCalendar => 'Zum Kalender hinzufügen';

  @override
  String get myAssignments => 'Meine nächsten Aufgaben';

  @override
  String get myAssignmentsNone => 'Keine anstehenden Aufgaben.';

  @override
  String get remindersTitle => 'Erinnerungen an Aufgaben';

  @override
  String get remindersDescription =>
      'Erhalte auf diesem Gerät eine Benachrichtigung vor jeder deiner nächsten Aufgaben. Änderungen, die bei geschlossener App gemacht werden, werden beim nächsten Öffnen übernommen.';

  @override
  String get remindersEnable => 'Erinnerungen aktivieren';

  @override
  String get remindersAdd => 'Erinnerung hinzufügen';

  @override
  String get reminderUnitMinutes => 'Minuten vorher';

  @override
  String get reminderUnitHours => 'Stunden vorher';

  @override
  String get reminderUnitDays => 'Tage vorher';

  @override
  String get remindersPermissionDenied =>
      'Benachrichtigungen sind für diese App nicht erlaubt. Aktiviere sie in den Systemeinstellungen, um Erinnerungen zu nutzen.';

  @override
  String get remindersChannelName => 'Erinnerungen an Aufgaben';

  @override
  String get remindersChannelDescription =>
      'Benachrichtigungen vor deinen Aufgaben in der Versammlung';

  @override
  String get roleAssistant => 'Partner';

  @override
  String get rolePw => 'Öffentliches Zeugnisgeben';

  @override
  String get roleFsm => 'Zusammenkunft für den Predigtdienst';

  @override
  String get reportSubmit => 'Bericht senden';

  @override
  String reportSubmittedAt(String date) {
    return 'Gesendet am $date';
  }

  @override
  String get reportSaved => 'Bericht gespeichert.';

  @override
  String get reportMissing => 'Nicht gesendet';

  @override
  String reportEnterFor(String name) {
    return 'Bericht eingeben – $name';
  }

  @override
  String reportSummaryReported(int reported, int total) {
    return 'Berichtet: $reported / $total';
  }

  @override
  String get attAdd => 'Anwesenheit erfassen';

  @override
  String get attInPerson => 'Persönlich';

  @override
  String get attOnline => 'Online';

  @override
  String get attTotal => 'Gesamt';

  @override
  String get attMeetingLmm => 'Zusammenkunft unter der Woche';

  @override
  String get attMeetingWeekend => 'Zusammenkunft am Wochenende';

  @override
  String get attOverview => 'Monatsdurchschnitte';

  @override
  String get attHistory => 'Vergangene Zusammenkünfte';

  @override
  String get attNotFilled => 'Nicht erfasst';

  @override
  String get attMismatch => 'Die Zahlen stimmen nicht überein.';

  @override
  String attRecordedOf(int filled, int expected) {
    return '$filled/$expected erfasst';
  }

  @override
  String get attSaved => 'Anwesenheit gespeichert.';

  @override
  String get statMembershipTitle => 'Verkündiger';

  @override
  String get statTotalMembers => 'Alle Verkündiger';

  @override
  String get statPioneers => 'Pioniere';

  @override
  String get statAgeTitle => 'Altersverteilung';

  @override
  String get statAgeAverage => 'Durchschnittsalter';

  @override
  String statAgeKnownDetail(int known, int total) {
    return 'Basierend auf $known von $total bekannten Geburtsdaten';
  }

  @override
  String get statAgeUnder18 => 'Unter 18';

  @override
  String get statAgeUnknown => 'Unbekannt';

  @override
  String get statAttendanceTitle => 'Zusammenkunftsbesuch';

  @override
  String get statAvg3Months => 'Ø 3 Monate';

  @override
  String get statAvg12Months => 'Ø 12 Monate';

  @override
  String get statFieldServiceTitle => 'Predigtdienst';

  @override
  String statServiceYear(String year) {
    return 'Dienstjahr $year';
  }

  @override
  String get statReportsSubmitted => 'Gesendete Berichte';

  @override
  String get statParticipated => 'Haben sich am Predigtdienst beteiligt';

  @override
  String get statPioneerHours => 'Pionierstunden';

  @override
  String get statPublisherHours => 'Verkündigerstunden';

  @override
  String get statUsageTitle => 'App-Nutzung';

  @override
  String get statWithAccount => 'Mit App-Konto';

  @override
  String get statSelfReported => 'Selbst gesendete Berichte (letzter Monat)';

  @override
  String get statAwaiting => 'Warten auf Bestätigung';

  @override
  String get statFullAdmins => 'Volladministratoren';

  @override
  String get statSectionAdmins => 'Bereichsadministratoren';

  @override
  String get statNoData => 'Noch keine Daten';

  @override
  String get terrMine => 'Meine Gebiete';

  @override
  String get terrNoMine => 'Dir ist kein Gebiet zugewiesen.';

  @override
  String get terrAll => 'Alle Gebiete';

  @override
  String terrAssignedOn(String date) {
    return 'Zugewiesen am $date';
  }

  @override
  String get terrReturn => 'Zurückgeben';

  @override
  String get terrReturnTitle => 'Gebiet zurückgeben';

  @override
  String get terrReturnNotes => 'Notizen (optional)';

  @override
  String get terrMap => 'Karte';

  @override
  String get terrAdd => 'Gebiet hinzufügen';

  @override
  String get terrEdit => 'Gebiet bearbeiten';

  @override
  String get terrName => 'Name';

  @override
  String get terrNameDuplicate =>
      'Ein Gebiet mit diesem Namen existiert bereits.';

  @override
  String get terrMapUrl => 'Kartenlink (z. B. Google My Maps)';

  @override
  String get terrNotes => 'Notizen';

  @override
  String get terrAssignTo => 'Zuweisen an…';

  @override
  String terrHolder(String name, String date) {
    return '$name — seit $date';
  }

  @override
  String get terrFree => 'Nicht zugewiesen';

  @override
  String get terrStats => 'Statistik';

  @override
  String get terrStatsTotal => 'Gesamt';

  @override
  String get terrStatsAssigned => 'Derzeit zugewiesen';

  @override
  String get terrStatsFinished => 'Im Zeitraum abgeschlossen';

  @override
  String get terrRemoveAssignment => 'Zuweisung entfernen';

  @override
  String get terrImportTitle => 'Gebiete importieren';

  @override
  String get terrImportPasteHint =>
      'Füge Zeilen aus Excel oder Google Tabellen ein. Spalten: Name, Kartenlink, Notizen — nur der Name ist erforderlich.';

  @override
  String get terrImportPreview => 'Vorschau';

  @override
  String get terrImportPickFile => 'CSV-Datei auswählen';

  @override
  String terrImportSummary(
    int total,
    int newCount,
    int duplicates,
    int invalid,
  ) {
    return '$total Zeilen: $newCount neu, $duplicates vorhanden, $invalid ungültig';
  }

  @override
  String get terrImportUpdateExisting =>
      'Vorhandene Gebiete aktualisieren (Abgleich per Name), statt sie zu überspringen';

  @override
  String get terrImportBadgeNew => 'Neu';

  @override
  String get terrImportBadgeSkip => 'Überspringen';

  @override
  String get terrImportBadgeUpdate => 'Aktualisieren';

  @override
  String get terrImportBadgeInvalid => 'Name fehlt';

  @override
  String get terrImportBadgeDupRow => 'Doppelte Zeile';

  @override
  String terrImportLine(int line) {
    return 'Zeile $line';
  }

  @override
  String terrImportSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gebiete importieren',
      one: '1 Gebiet importieren',
    );
    return '$_temp0';
  }

  @override
  String terrImportDone(int created, int updated) {
    return '$created neu importiert, $updated aktualisiert.';
  }

  @override
  String get terrImportEmpty => 'Keine Zeilen in der Eingabe gefunden.';

  @override
  String get terrDeleteConfirm =>
      'Dieses Gebiet löschen? Das kann nicht rückgängig gemacht werden.';

  @override
  String get terrSortByTerritory => 'Gebiet';

  @override
  String get terrSortByPublisher => 'Verkündiger';

  @override
  String get terrSortByDate => 'Zuweisungsdatum';

  @override
  String get terrHistoryOngoing => 'Aktuell';

  @override
  String get terrHistoryEmpty => 'Noch kein Zuweisungsverlauf.';

  @override
  String get mgEmpty => 'Noch keine Dienstgruppen.';

  @override
  String get mgAdd => 'Gruppe hinzufügen';

  @override
  String get mgEdit => 'Gruppe bearbeiten';

  @override
  String get mgName => 'Name';

  @override
  String mgMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitglieder',
      one: '1 Mitglied',
      zero: 'Keine Mitglieder',
    );
    return '$_temp0';
  }

  @override
  String get mgNoMembers => 'Noch keine Mitglieder in dieser Gruppe.';

  @override
  String get mgOverseer => 'Gruppenaufseher';

  @override
  String get mgAssistant => 'Gruppenassistent';

  @override
  String get mgMakeOverseer => 'Als Gruppenaufseher festlegen';

  @override
  String get mgMakeAssistant => 'Als Assistent festlegen';

  @override
  String get mgClearRole => 'Bezeichnung Aufseher/Assistent entfernen';

  @override
  String get mgAddMember => 'Mitglied hinzufügen…';

  @override
  String get mgNoUnassigned => 'Alle sind bereits in einer Gruppe.';

  @override
  String get mgRemoveMember => 'Aus Gruppe entfernen';

  @override
  String get mgDeleteConfirm =>
      'Diese Gruppe löschen? Ihre Mitglieder bleiben ohne Gruppe.';

  @override
  String get mgGroup => 'Dienstgruppe';

  @override
  String get mgNoGroup => 'Keine Gruppe';

  @override
  String get infoEmpty => 'Zurzeit keine Informationen.';

  @override
  String get infoAddText => 'Text hinzufügen';

  @override
  String get infoAddFile => 'Datei hochladen (PDF/Bild)';

  @override
  String get infoAddLink => 'Link hinzufügen';

  @override
  String get infoTitle => 'Titel';

  @override
  String get infoBody => 'Text';

  @override
  String get infoUrl => 'Link (URL)';

  @override
  String get infoShowFrom => 'Anzeigen ab (optional)';

  @override
  String get infoShowUntil => 'Anzeigen bis (optional)';

  @override
  String get infoFileTooLarge =>
      'Die Datei ist zu groß (max. 10 MB). Teile sie stattdessen als Link.';

  @override
  String get infoHidden =>
      'Derzeit ausgeblendet (außerhalb des Sichtbarkeitszeitraums)';

  @override
  String get infoDownloading => 'Datei wird geladen…';

  @override
  String get infoEditItem => 'Eintrag bearbeiten';

  @override
  String get s1Active =>
      'Tätige Verkündiger (die in den letzten 6 Monaten mindestens einmal berichtet haben)';

  @override
  String get s1AvgMid =>
      'Durchschnittliche Anwesendenzahl der Zusammenkunft unter der Woche';

  @override
  String get s1AvgWeekend =>
      'Durchschnittliche Anwesendenzahl der Zusammenkunft am Wochenende';

  @override
  String get s1Publishers => 'Verkündiger';

  @override
  String get s1AuxPioneers => 'Hilfspioniere';

  @override
  String get s1RegPioneers => 'Allgemeine Pioniere';

  @override
  String get s1Count => 'Anzahl der Berichte';

  @override
  String get s1Studies => 'Bibelstudien';

  @override
  String get s1Hours => 'Stunden (gesamt)';

  @override
  String get s1Note =>
      'Hilfspioniere, allgemeine Pioniere und Sonderpioniere werden nicht zur Gruppe der Verkündiger gezählt; Sonderpioniere werden in keiner Gruppe berücksichtigt.';

  @override
  String get settingsName => 'Name der Versammlung';

  @override
  String get settingsLmmMeeting =>
      'Zusammenkunft unter der Woche (Tag und Uhrzeit)';

  @override
  String get settingsLmmClassCount =>
      'Klassen der Zusammenkunft unter der Woche';

  @override
  String get settingsWeekendMeeting =>
      'Zusammenkunft am Wochenende (Tag und Uhrzeit)';

  @override
  String get settingsBackupSection => 'Sicherung und Wiederherstellung';

  @override
  String get settingsBackupDescription =>
      'Lade eine vollständige Kopie der Daten deiner Versammlung herunter oder stelle sie aus einer Sicherungsdatei wieder her. Verwende das, um nach einem versehentlichen Löschen oder einer fehlerhaften Bearbeitung Daten wiederherzustellen.';

  @override
  String get settingsExportData => 'Alle Daten exportieren';

  @override
  String get settingsImportData => 'Aus Sicherung wiederherstellen…';

  @override
  String backupExportSuccess(int count) {
    return 'Sicherung heruntergeladen ($count Datensätze).';
  }

  @override
  String get backupImportTitle => 'Aus Sicherung wiederherstellen';

  @override
  String get backupImportPick => 'Sicherungsdatei auswählen…';

  @override
  String get backupImportEmpty =>
      'Wähle eine Sicherungsdatei, um ihren Inhalt in der Vorschau zu sehen.';

  @override
  String get backupImportContents => 'Inhalt';

  @override
  String backupImportFrom(String name, String date) {
    return 'Sicherung von $name · $date';
  }

  @override
  String get backupImportWarning =>
      'Die Wiederherstellung überschreibt aktuelle Datensätze, die eine ID mit den Versionen in dieser Sicherung teilen. Nach der Sicherung hinzugefügte Datensätze bleiben erhalten. Das kann nicht rückgängig gemacht werden.';

  @override
  String get backupImportConfirm => 'Diese Sicherung wiederherstellen';

  @override
  String backupImportSuccess(int count) {
    return '$count Datensätze wiederhergestellt.';
  }

  @override
  String backupImportPartial(int count, String collections) {
    return '$count Datensätze wiederhergestellt. Nicht wiederhergestellt werden konnten: $collections.';
  }

  @override
  String get backupInvalidFile =>
      'Diese Datei ist keine gültige Versammlungssicherung.';

  @override
  String get qSupportSection => 'Zusammenkunftsunterstützung und Sonstiges';

  @override
  String get qChairman => 'Vorsitzender (unter der Woche)';

  @override
  String get qPrayer => 'Gebet';

  @override
  String get qTreasures => 'Schätze aus Gottes Wort';

  @override
  String get qGems => 'Nach geistigen Schätzen graben';

  @override
  String get qBibleReading => 'Bibellesung';

  @override
  String get qFieldMinistry => 'Schüleraufgaben (Dienst)';

  @override
  String get qLiving => 'Unser Leben als Christ';

  @override
  String get qCbsConductor => 'Leiter des Versammlungsbibelstudiums';

  @override
  String get qCbsReader => 'Leser des Versammlungsbibelstudiums';

  @override
  String get qPublicTalk => 'Öffentlicher Vortrag';

  @override
  String get qWeekendChairman => 'Vorsitzender (Wochenende)';

  @override
  String get qWtReader => 'Leser des Wachtturms';

  @override
  String get qAttendant => 'Ordner';

  @override
  String get qMicrophone => 'Mikrofone';

  @override
  String get qAudioVideo => 'Ton und Video';

  @override
  String get qPublicWitnessing => 'Öffentliches Zeugnisgeben';

  @override
  String get qMinistryMeetingConductor =>
      'Leiter der Zusammenkunft für den Predigtdienst';
}
