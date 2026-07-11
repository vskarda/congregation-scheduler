// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Sborový plánovač';

  @override
  String get commonSave => 'Uložit';

  @override
  String get commonCancel => 'Zrušit';

  @override
  String get commonDelete => 'Smazat';

  @override
  String get commonEdit => 'Upravit';

  @override
  String get commonAdd => 'Přidat';

  @override
  String get commonClose => 'Zavřít';

  @override
  String get commonBack => 'Zpět';

  @override
  String get commonRetry => 'Zkusit znovu';

  @override
  String get commonLoading => 'Načítání…';

  @override
  String get commonError => 'Něco se pokazilo';

  @override
  String commonErrorDetail(String message) {
    return 'Něco se pokazilo: $message';
  }

  @override
  String get commonFieldRequired => 'Toto pole je povinné';

  @override
  String get commonConfirmDeleteTitle => 'Smazat?';

  @override
  String get commonConfirmDeleteBody => 'Tuto akci nelze vrátit zpět.';

  @override
  String get commonToday => 'Dnes';

  @override
  String get commonAll => 'Vše';

  @override
  String get commonNone => 'Žádné';

  @override
  String get commonYes => 'Ano';

  @override
  String get commonNo => 'Ne';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSearch => 'Hledat';

  @override
  String get commonNotAssigned => '—';

  @override
  String get commonLanguage => 'Jazyk';

  @override
  String get setupTitle => 'Připojení ke sboru';

  @override
  String get setupIntro =>
      'Aplikace se připojuje přímo k databázi vašeho sboru. Vložte konfiguraci, kterou jste dostali od administrátora, nebo naskenujte zvací QR kód.';

  @override
  String get setupConfigLabel => 'Konfigurace Firebase (JSON)';

  @override
  String get setupConfigHint => 'apiKey, authDomain, projectId, …';

  @override
  String get setupScanQr => 'Naskenovat QR kód';

  @override
  String get setupPickQrImage => 'Vybrat fotku QR kódu';

  @override
  String get setupQrNotFoundInImage =>
      'V tomto obrázku nebyl nalezen žádný QR kód.';

  @override
  String get setupConnect => 'Připojit';

  @override
  String get setupInvalidJson =>
      'Toto není platná konfigurace ve formátu JSON. Musí obsahovat alespoň apiKey, projectId a appId.';

  @override
  String setupConnectionFailed(String message) {
    return 'S touto konfigurací se nepodařilo připojit: $message';
  }

  @override
  String get setupModeTitle => 'Jak chcete začít?';

  @override
  String get setupModeJoin => 'Připojit se ke sboru';

  @override
  String get setupModeJoinSubtitle =>
      'Administrátor vás pozval. Po registraci váš účet ověří.';

  @override
  String get setupModeNew => 'Založit nový sbor';

  @override
  String get setupModeNewSubtitle =>
      'Jste první administrátor nově vytvořeného projektu Firebase.';

  @override
  String get setupCongregationExists =>
      'Tento sbor už je založený. Zvolte místo toho „Připojit se ke sboru“.';

  @override
  String get setupDatabaseNotReady =>
      'Databáze sboru se stále spouští. Chvíli počkejte a zkuste to znovu.';

  @override
  String get setupReconfigure => 'Změnit konfiguraci';

  @override
  String get setupRestartRequired =>
      'Konfigurace byla uložena. Zavřete a znovu otevřete aplikaci, aby se projevila.';

  @override
  String get languageSystem => 'Jazyk systému';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageCzech => 'Čeština';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get profileCompleteTitle => 'Dokončení profilu';

  @override
  String get profileCompleteBody =>
      'Váš účet existuje, ale chybí profil. Zadejte své jméno pro dokončení registrace.';

  @override
  String get authSignIn => 'Přihlásit se';

  @override
  String get authSignOut => 'Odhlásit se';

  @override
  String get authRegister => 'Vytvořit účet';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Heslo';

  @override
  String get authPasswordConfirm => 'Potvrzení hesla';

  @override
  String get authPasswordsDontMatch => 'Hesla se neshodují';

  @override
  String get authForgotPassword => 'Zapomenuté heslo?';

  @override
  String get authResetSent => 'E-mail pro obnovení hesla byl odeslán.';

  @override
  String get authNoAccountYet => 'Ještě nemáte účet? Vytvořte si ho';

  @override
  String get authHaveAccount => 'Už máte účet? Přihlaste se';

  @override
  String get authErrorInvalidCredentials => 'Nesprávný e-mail nebo heslo.';

  @override
  String get authErrorEmailInUse => 'Účet s tímto e-mailem už existuje.';

  @override
  String get authErrorWeakPassword =>
      'Heslo je příliš slabé (alespoň 6 znaků).';

  @override
  String authErrorGeneric(String message) {
    return 'Přihlášení se nezdařilo: $message';
  }

  @override
  String get authFirstName => 'Jméno';

  @override
  String get authLastName => 'Příjmení';

  @override
  String get authCongregationName => 'Název sboru';

  @override
  String get awaitingTitle => 'Čeká se na ověření';

  @override
  String get awaitingBody =>
      'Váš účet byl vytvořen. Administrátor sboru ho nyní musí ověřit, teprve potom uvidíte sborové informace.';

  @override
  String get navInfoBoard => 'Informační deska';

  @override
  String get navEvents => 'Události';

  @override
  String get navLmm => 'Život a služba';

  @override
  String get navWeekend => 'Víkendové shromáždění';

  @override
  String get navPublicWitnessing => 'Veřejné svědectví';

  @override
  String get navFieldServiceMeetings => 'Schůzky před službou';

  @override
  String get navTerritories => 'Obvody';

  @override
  String get navReport => 'Zpráva o službě';

  @override
  String get navAttendance => 'Návštěvnost';

  @override
  String get navProfile => 'Můj profil';

  @override
  String get navAdmin => 'Správa';

  @override
  String get navPublishersAdmin => 'Zvěstovatelé';

  @override
  String get navReportsAdmin => 'Přehled zpráv';

  @override
  String get navS1 => 'Zpráva S-1';

  @override
  String get navTalks => 'Náměty veřejných přednášek';

  @override
  String get navSettings => 'Nastavení sboru';

  @override
  String get adminToggleHide => 'Skrýt možnosti správce';

  @override
  String get adminToggleShow => 'Zobrazit možnosti správce';

  @override
  String get profilePhone => 'Telefonní číslo';

  @override
  String get profileAddress => 'Adresa';

  @override
  String get profileBirthDate => 'Datum narození';

  @override
  String get profileBaptismDate => 'Datum křtu';

  @override
  String get profileGender => 'Pohlaví';

  @override
  String get genderUnknown => '—';

  @override
  String get genderMale => 'Muž';

  @override
  String get genderFemale => 'Žena';

  @override
  String get profileHope => 'Naděje';

  @override
  String get hopeOtherSheep => 'Jiné ovce';

  @override
  String get hopeAnointed => 'Pomazaný';

  @override
  String get profileStatus => 'Služební postavení';

  @override
  String get statusPublisher => 'Zvěstovatel';

  @override
  String get statusAuxPioneer => 'Pomocný průkopník';

  @override
  String get statusRegPioneer => 'Stálý průkopník';

  @override
  String get statusSpecialPioneer => 'Zvláštní průkopník';

  @override
  String get statusFieldMissionary => 'Misionář';

  @override
  String get profileAppointment => 'Jmenování';

  @override
  String get appointmentMinisterialServant => 'Služební pomocník';

  @override
  String get appointmentElder => 'Starší';

  @override
  String get profileEmergency => 'Poznámka pro případ nouze';

  @override
  String get profileEmergencyHint => 'Koho kontaktovat v případě nouze';

  @override
  String get profileSaved => 'Uloženo';

  @override
  String get profileRecord => 'Záznam zvěstovatele';

  @override
  String serviceYear(int year) {
    return 'Služební rok $year';
  }

  @override
  String get reportMonth => 'Měsíc';

  @override
  String get reportParticipated => 'Podílel(a) se na službě';

  @override
  String get reportStudies => 'Biblická studia';

  @override
  String get reportHours => 'Hodiny';

  @override
  String get reportCredit => 'Započtené hodiny';

  @override
  String get reportComments => 'Poznámky';

  @override
  String get s21Export => 'Exportovat S-21 (PDF)';

  @override
  String get s21Title => 'SBOROVÝ ZÁZNAM ZVĚSTOVATELE';

  @override
  String get s21Name => 'Jméno:';

  @override
  String get s21DateOfBirth => 'Datum narození:';

  @override
  String get s21DateOfBaptism => 'Datum křtu:';

  @override
  String get s21HoursHeader => 'Hodiny (u průkopníků a misionářů)';

  @override
  String get s21Remarks => 'Poznámky';

  @override
  String get s21Total => 'Celkem';

  @override
  String get s21FormCode => 'S-21-B 11/23';

  @override
  String get pubAdminInvite => 'Pozvat';

  @override
  String get pubAdminInviteTitle => 'Pozvání do sboru';

  @override
  String get pubAdminInviteBody =>
      'Nový člen naskenuje tento QR kód v aplikaci, zaregistruje se a poté se zde objeví jako neověřený. Ověřením mu udělíte přístup.';

  @override
  String get pubAdminAddRecord => 'Přidat záznam zvěstovatele';

  @override
  String get pubAdminAddRecordHint =>
      'Záznam pro člena, který nebude používat aplikaci; zprávy za něj mohou zadávat administrátoři.';

  @override
  String get pubAdminVerified => 'Ověřen(a)';

  @override
  String get pubAdminUnverifiedBadge => 'Čeká na ověření';

  @override
  String get pubAdminNoAccountBadge => 'Bez účtu v aplikaci';

  @override
  String get pubAdminTabProfile => 'Profil';

  @override
  String get pubAdminTabRoles => 'Práva';

  @override
  String get pubAdminTabAssign => 'Úkoly';

  @override
  String get pubAdminTabRecord => 'Záznam';

  @override
  String get pubAdminDeleteConfirm =>
      'Smazat tohoto zvěstovatele a jeho osobní údaje? Jeho zprávy zůstanou uloženy.';

  @override
  String get pubAdminSelfVerifiedWarningTitle => 'Vypnout vlastní ověření?';

  @override
  String get pubAdminSelfVerifiedWarningBody =>
      'Chystáte se odebrat sami sobě stav Ověřen(a). Okamžitě ztratíte přístup k datům sboru a obnovit ho bude moci jen jiný hlavní administrátor. Opravdu chcete pokračovat?';

  @override
  String get pubAdminSelfFullAdminWarningTitle =>
      'Odebrat si práva hlavního administrátora?';

  @override
  String get pubAdminSelfFullAdminWarningBody =>
      'Chystáte se odebrat sami sobě práva hlavního administrátora. Pokud jste jediný administrátor, nebude to moci vrátit zpět nikdo, ani vy. Opravdu chcete pokračovat?';

  @override
  String get pubAdminSelfWarningConfirm => 'Odebrat si přístup';

  @override
  String get roleFullAdmin => 'Hlavní administrátor';

  @override
  String get weekNoSchedule => 'Pro tento týden zatím není žádný program.';

  @override
  String get weekCreateEmpty => 'Vytvořit prázdný týden';

  @override
  String get weekImportEpub => 'Importovat z .epub';

  @override
  String get weekCheckCdn => 'Zkontrolovat online';

  @override
  String get weekDelete => 'Smazat tento týden';

  @override
  String get lmmSongs => 'Písně';

  @override
  String get sectionOpening => 'Úvod';

  @override
  String get sectionTreasures => 'POKLADY Z BOŽÍHO SLOVA';

  @override
  String get sectionMinistry => 'ROZVÍJEJME SE VE SLUŽBĚ';

  @override
  String get sectionLiving => 'KŘESŤANSKÝ ŽIVOT';

  @override
  String get sectionClosing => 'Závěr';

  @override
  String get partChairman => 'Předsedající';

  @override
  String get partOpeningPrayer => 'Úvodní modlitba';

  @override
  String get partClosingPrayer => 'Závěrečná modlitba';

  @override
  String get partGems => 'Duchovní perly';

  @override
  String get partBibleReading => 'Čtení Bible';

  @override
  String get partCbs => 'Sborové studium Bible';

  @override
  String get partCbsReader => 'Čtenář';

  @override
  String get partAssistant => 'Pomocník';

  @override
  String partMinutes(int min) {
    return '$min min';
  }

  @override
  String get lmmClassMain => 'Hlavní sál';

  @override
  String lmmClassN(int index) {
    return 'Třída $index';
  }

  @override
  String get partEdit => 'Upravit bod';

  @override
  String get partTitle => 'Název';

  @override
  String get partDescription => 'Popis';

  @override
  String get partDuration => 'Délka (min)';

  @override
  String get partAdd => 'Přidat bod';

  @override
  String get partDeleteConfirm => 'Smazat tento bod programu?';

  @override
  String get supportAttendants => 'Pořadatelé';

  @override
  String get supportMicrophones => 'Mikrofony';

  @override
  String get supportAudioVideo => 'Audio/video';

  @override
  String get customAssignmentAdd => 'Přidat vlastní úkol';

  @override
  String get customLabel => 'Popisek';

  @override
  String get pickerQualified => 'Schválení';

  @override
  String get pickerAll => 'Všichni';

  @override
  String get pickerFreeText => 'Text';

  @override
  String pickerLastAssigned(String date) {
    return 'Naposledy: $date';
  }

  @override
  String get pickerNever => 'Zatím bez úkolu';

  @override
  String get importTitle => 'Import pracovního sešitu';

  @override
  String get importNoWeeks =>
      'V souboru nebyly nalezeny žádné použitelné týdny.';

  @override
  String get importWeekExists =>
      'Už existuje — program se aktualizuje, úkoly zůstanou';

  @override
  String importSave(int count) {
    return 'Importovat týdny: $count';
  }

  @override
  String get importDone => 'Importováno.';

  @override
  String get importCdnNothing =>
      'Žádné číslo sešitu zatím není online k dispozici.';

  @override
  String get weekendTalkTitle => 'Veřejná přednáška';

  @override
  String get weekendSpeaker => 'Řečník';

  @override
  String get weekendChairmanLabel => 'Předsedající';

  @override
  String get weekendWtReader => 'Čtenář Strážné věže';

  @override
  String get customFieldAdd => 'Přidat pole programu';

  @override
  String get pickerFromCatalog => 'Ze seznamu';

  @override
  String get talksUpdateFromPdf => 'Aktualizovat náměty z PDF';

  @override
  String get talksPickPdf => 'Vybrat PDF S-99';

  @override
  String get talksParseError =>
      'Z tohoto souboru se nepodařilo načíst náměty přednášek. Použijte oficiální PDF formuláře S-99.';

  @override
  String talksImportSummary(int total, int added, int changed, int removed) {
    return 'Nalezeno námětů: $total — nové: $added, změněné: $changed, odstraněné: $removed';
  }

  @override
  String get talksImportSave => 'Uložit náměty';

  @override
  String talksImportDone(int count) {
    return 'Náměty uloženy. Aktualizovaná nadcházející shromáždění: $count.';
  }

  @override
  String talksLastDelivered(String date) {
    return 'Naposledy předneseno $date';
  }

  @override
  String get talksNeverDelivered => 'Zatím nepředneseno';

  @override
  String get talksScheduled => 'naplánováno';

  @override
  String get talksNew => 'Nový';

  @override
  String get talksChanged => 'Změněný';

  @override
  String get talksRemoved => 'Odstraněný';

  @override
  String get talksSearchHint => 'Hledat přednášku…';

  @override
  String get talksEmpty =>
      'Zatím žádné náměty přednášek. Importujte je z PDF formuláře S-99.';

  @override
  String get talksOpenCatalog => 'Spravovat náměty přednášek';

  @override
  String get talksEditTitle => 'Upravit námět';

  @override
  String get pwNoSlots => 'Tento týden není žádné veřejné svědectví.';

  @override
  String get pwAddSlot => 'Přidat termín';

  @override
  String get pwEditSlot => 'Upravit termín';

  @override
  String get pwLocation => 'Místo';

  @override
  String get pwTimeFrom => 'Od';

  @override
  String get pwTimeTo => 'Do';

  @override
  String get pwRecurringRules => 'Opakované termíny';

  @override
  String get pwRecurringAdd => 'Přidat opakovaný termín';

  @override
  String get pwWeekday => 'Den v týdnu';

  @override
  String get pwValidFrom => 'Platí od';

  @override
  String get pwValidUntil => 'Platí do (nepovinné)';

  @override
  String get pwAssignees => 'Přiděleno';

  @override
  String get pwDate => 'Datum';

  @override
  String get fsmNoMeetings => 'Tento týden nejsou žádné schůzky před službou.';

  @override
  String get fsmAddMeeting => 'Přidat schůzku';

  @override
  String get fsmEditMeeting => 'Upravit schůzku';

  @override
  String get fsmDate => 'Datum';

  @override
  String get fsmTime => 'Čas';

  @override
  String get fsmLocation => 'Místo';

  @override
  String get fsmConductor => 'Vede';

  @override
  String get fsmRecurringRules => 'Opakované schůzky';

  @override
  String get fsmRecurringAdd => 'Přidat opakovanou schůzku';

  @override
  String get fsmWeekday => 'Den v týdnu';

  @override
  String get fsmValidFrom => 'Platí od';

  @override
  String get fsmValidUntil => 'Platí do (nepovinné)';

  @override
  String get eventsUpcoming => 'Nadcházející události';

  @override
  String get eventsNone => 'Žádné nadcházející události.';

  @override
  String get eventAdd => 'Přidat událost';

  @override
  String get eventEdit => 'Upravit událost';

  @override
  String get eventTitle => 'Název';

  @override
  String get eventType => 'Typ';

  @override
  String get eventTypeConvention => 'Regionální sjezd';

  @override
  String get eventTypeAssembly => 'Krajský sjezd';

  @override
  String get eventTypeMemorial => 'Slavnost';

  @override
  String get eventTypeCoVisit => 'Návštěva krajského dozorce';

  @override
  String get eventTypeOther => 'Jiné';

  @override
  String get eventDateFrom => 'Od';

  @override
  String get eventDateTo => 'Do (nepovinné)';

  @override
  String get eventLocation => 'Místo';

  @override
  String get eventNotes => 'Poznámky';

  @override
  String get eventAddToCalendar => 'Přidat do kalendáře';

  @override
  String get myAssignments => 'Moje nadcházející úkoly';

  @override
  String get myAssignmentsNone => 'Žádné nadcházející úkoly.';

  @override
  String get roleAssistant => 'Pomocník';

  @override
  String get rolePw => 'Veřejné svědectví';

  @override
  String get roleFsm => 'Schůzka před službou';

  @override
  String get reportSubmit => 'Odeslat zprávu';

  @override
  String reportSubmittedAt(String date) {
    return 'Odesláno $date';
  }

  @override
  String get reportSaved => 'Zpráva uložena.';

  @override
  String get reportMissing => 'Neodevzdáno';

  @override
  String reportEnterFor(String name) {
    return 'Zadat zprávu — $name';
  }

  @override
  String reportSummaryReported(int reported, int total) {
    return 'Odevzdáno: $reported / $total';
  }

  @override
  String get attAdd => 'Zapsat návštěvnost';

  @override
  String get attInPerson => 'Osobně';

  @override
  String get attOnline => 'Online';

  @override
  String get attTotal => 'Celkem';

  @override
  String get attMeetingLmm => 'Život a služba';

  @override
  String get attMeetingWeekend => 'Víkendové shromáždění';

  @override
  String get attOverview => 'Měsíční průměry';

  @override
  String get attRecent => 'Poslední shromáždění';

  @override
  String get attSaved => 'Návštěvnost uložena.';

  @override
  String get terrMine => 'Moje obvody';

  @override
  String get terrNoMine => 'Nemáte přidělené žádné obvody.';

  @override
  String get terrAll => 'Všechny obvody';

  @override
  String terrAssignedOn(String date) {
    return 'Přiděleno $date';
  }

  @override
  String get terrReturn => 'Vrátit';

  @override
  String get terrReturnTitle => 'Vrácení obvodu';

  @override
  String get terrReturnNotes => 'Poznámka (nepovinná)';

  @override
  String get terrMap => 'Mapa';

  @override
  String get terrAdd => 'Přidat obvod';

  @override
  String get terrEdit => 'Upravit obvod';

  @override
  String get terrName => 'Název';

  @override
  String get terrNumber => 'Číslo';

  @override
  String get terrMapUrl => 'Odkaz na mapu (např. Google My Maps)';

  @override
  String get terrNotes => 'Poznámky';

  @override
  String get terrAssignTo => 'Přidělit…';

  @override
  String terrHolder(String name, String date) {
    return '$name — od $date';
  }

  @override
  String get terrFree => 'Nepřiděleno';

  @override
  String get terrStats => 'Statistika';

  @override
  String get terrStatsTotal => 'Celkem';

  @override
  String get terrStatsAssigned => 'Aktuálně přiděleno';

  @override
  String get terrStatsFinished => 'Dokončeno v období';

  @override
  String get terrRemoveAssignment => 'Odebrat přidělení';

  @override
  String get infoEmpty => 'Momentálně žádné informace.';

  @override
  String get infoAddText => 'Přidat text';

  @override
  String get infoAddFile => 'Nahrát soubor (PDF/obrázek)';

  @override
  String get infoAddLink => 'Přidat odkaz';

  @override
  String get infoTitle => 'Nadpis';

  @override
  String get infoBody => 'Text';

  @override
  String get infoUrl => 'Odkaz (URL)';

  @override
  String get infoShowFrom => 'Zobrazit od (nepovinné)';

  @override
  String get infoShowUntil => 'Zobrazit do (nepovinné)';

  @override
  String get infoFileTooLarge =>
      'Soubor je příliš velký (max 10 MB). Sdílejte ho raději jako odkaz.';

  @override
  String get infoHidden => 'Momentálně skryto (mimo období zobrazení)';

  @override
  String get infoDownloading => 'Načítám soubor…';

  @override
  String get infoEditItem => 'Upravit položku';

  @override
  String get s1Active =>
      'Všichni aktivní zvěstovatelé (podali zprávu alespoň jednou za posledních 6 měsíců)';

  @override
  String get s1AvgMid => 'Průměrná návštěvnost — shromáždění v týdnu';

  @override
  String get s1AvgWeekend => 'Průměrná návštěvnost — víkendové shromáždění';

  @override
  String get s1Publishers => 'Zvěstovatelé';

  @override
  String get s1AuxPioneers => 'Pomocní průkopníci';

  @override
  String get s1RegPioneers => 'Stálí průkopníci';

  @override
  String get s1Count => 'Počet';

  @override
  String get s1Studies => 'Biblická studia';

  @override
  String get s1Hours => 'Hodiny (celkem)';

  @override
  String get s1Note =>
      'Pomocní, stálí a zvláštní průkopníci se nepočítají do skupiny Zvěstovatelé; zvláštní průkopníci nejsou zahrnuti v žádné skupině.';

  @override
  String get settingsName => 'Název sboru';

  @override
  String get settingsLmmMeeting => 'Shromáždění v týdnu (den a čas)';

  @override
  String get settingsLmmClassCount => 'Počet tříd (shromáždění v týdnu)';

  @override
  String get settingsWeekendMeeting => 'Víkendové shromáždění (den a čas)';

  @override
  String get qSupportSection => 'Podpora shromáždění a další';

  @override
  String get qChairman => 'Předsedající (Život a služba)';

  @override
  String get qPrayer => 'Modlitba';

  @override
  String get qTreasures => 'Poklady z Božího slova';

  @override
  String get qGems => 'Duchovní perly';

  @override
  String get qBibleReading => 'Čtení Bible';

  @override
  String get qFieldMinistry => 'Studentské úkoly (služba)';

  @override
  String get qLiving => 'Křesťanský život';

  @override
  String get qCbsConductor => 'Vedoucí sborového studia Bible';

  @override
  String get qCbsReader => 'Čtenář sborového studia';

  @override
  String get qPublicTalk => 'Veřejná přednáška';

  @override
  String get qWeekendChairman => 'Předsedající (víkend)';

  @override
  String get qWtReader => 'Čtenář Strážné věže';

  @override
  String get qAttendant => 'Pořadatel';

  @override
  String get qMicrophone => 'Mikrofony';

  @override
  String get qAudioVideo => 'Audio/video';

  @override
  String get qPublicWitnessing => 'Veřejné svědectví';

  @override
  String get qMinistryMeetingConductor => 'Vedoucí schůzky před službou';
}
