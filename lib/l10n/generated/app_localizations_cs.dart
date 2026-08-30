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
  String get commonClear => 'Vymazat';

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
  String get commonExport => 'Exportovat';

  @override
  String get exportServiceYear => 'Služební rok';

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
  String get setupGuideLinkIntro =>
      'Nemáte konfiguraci? Vytvořte sboru vlastní bezplatnou databázi:';

  @override
  String get setupGuideLinkButton => 'Jak založit nový sbor';

  @override
  String get setupGuideTitle => 'Založení nového sboru';

  @override
  String get setupGuideIntro =>
      'Aplikace je „self-hosted“: data vašeho sboru jsou uložena ve vašem vlastním bezplatném projektu Google Firebase, ke kterému nemá nikdo jiný přístup. Nastavení zabere asi 15 minut a nevyžaduje žádné programování — stačí vám účet Google. Postupujte podle kroků níže na tomto telefonu nebo na počítači.';

  @override
  String get setupGuideOpenConsole => 'Otevřít konzoli Firebase';

  @override
  String get setupGuideStep1Title => 'Vytvořte projekt Firebase';

  @override
  String get setupGuideStep1Body1 =>
      'Otevřete console.firebase.google.com, přihlaste se účtem Google a klepněte na „Get started by setting up a Firebase project“.';

  @override
  String get setupGuideStep1Body2 =>
      'Pojmenujte projekt, např. „sbor-mestecko“, potvrďte podmínky a pokračujte. Pokud konzole nabídne Google Analytics, vypněte je — nejsou potřeba. Zůstaňte na bezplatném tarifu Spark; aplikace je navržena tak, aby nikdy nepotřebovala placený tarif.';

  @override
  String get setupGuideStep2Title => 'Zapněte přihlašování e-mailem';

  @override
  String get setupGuideStep2Body1 =>
      'V levém menu zvolte Security → Authentication.';

  @override
  String get setupGuideStep2Body2 => 'Klepněte na „Get started“.';

  @override
  String get setupGuideStep2Body3 =>
      'Na kartě „Sign-in method“ zvolte Email/Password.';

  @override
  String get setupGuideStep2Body4 =>
      'Zapněte první přepínač („Email link“ nechte vypnutý) a klepněte na Save.';

  @override
  String get setupGuideStep3Title => 'Vytvořte databázi Firestore';

  @override
  String get setupGuideStep3Body1 =>
      'V levém menu zvolte Databases & Storage → Firestore.';

  @override
  String get setupGuideStep3Body2 => 'Klepněte na „Create database“.';

  @override
  String get setupGuideStep3Body3 => 'Zvolte edici Standard.';

  @override
  String get setupGuideStep3Body4 =>
      'Vyberte umístění blízko vás (např. europe-west3 pro střední Evropu). Později už ho nelze změnit.';

  @override
  String get setupGuideStep3Body5 =>
      'Začněte v produkčním režimu („Start in production mode“)…';

  @override
  String get setupGuideStep3Body6 => '…a klepněte na Create.';

  @override
  String get setupGuideStep4Title => 'Nahrajte bezpečnostní pravidla';

  @override
  String get setupGuideStep4Body1 =>
      'Pravidla určují, kdo smí která data číst a zapisovat (např. rozpisy vidí jen ověření zvěstovatelé). V databázi Firestore otevřete kartu Rules a klepněte na „Edit rules“.';

  @override
  String get setupGuideStep4Body2 =>
      'Smažte celý obsah editoru a vložte zkopírovaná pravidla.';

  @override
  String get setupGuideStep4Body3 => 'Klepněte na Publish.';

  @override
  String get setupGuideStep4Note =>
      'Tento krok zopakujte vždy, když nová verze aplikace přinese aktualizovaná pravidla.';

  @override
  String get setupGuideStep5Title => 'Získejte konfiguraci aplikace';

  @override
  String get setupGuideStep5Body1 =>
      'Klepněte na ikonu ozubeného kola vedle „Project Overview“ (vlevo nahoře) a zvolte Project settings.';

  @override
  String get setupGuideStep5Body2 =>
      'Na kartě General sjeďte dolů k „Your apps“ a klepněte na webovou ikonu </>.';

  @override
  String get setupGuideStep5Body3 =>
      'Zadejte přezdívku, např. „congregation-app“, hosting nechte vypnutý a klepněte na „Register app“.';

  @override
  String get setupGuideStep5Body4 =>
      'Zobrazí se blok kódu s „const firebaseConfig = …“. Označte a zkopírujte jen část mezi složenými závorkami — včetně závorek.';

  @override
  String get setupGuideStep5Note =>
      'Tato konfigurace není tajná — pouze identifikuje váš projekt. Data chrání bezpečnostní pravidla z kroku 4.';

  @override
  String get setupGuideRulesTitle => 'Bezpečnostní pravidla (firestore.rules)';

  @override
  String get setupGuideRulesCopy => 'Zkopírovat pravidla';

  @override
  String get setupGuideRulesCopied => 'Pravidla zkopírována do schránky.';

  @override
  String get setupGuideRulesView => 'Zobrazit text pravidel';

  @override
  String get setupGuideRulesLoadError => 'Text pravidel se nepodařilo načíst.';

  @override
  String get setupGuideFinish =>
      'Hotovo! Vraťte se zpět, vložte zkopírovanou konfiguraci a klepněte na Připojit. Poté zvolte „Založit nový sbor“ a zaregistrujte se jako první administrátor.';

  @override
  String get setupGuideBackToConnect => 'Zpět na připojení';

  @override
  String get languageSystem => 'Jazyk systému';

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
  String get themeSystem => 'Systém';

  @override
  String get themeLight => 'Světlý';

  @override
  String get themeDark => 'Tmavý';

  @override
  String themeTooltip(String mode) {
    return 'Motiv: $mode';
  }

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
  String get authEnterEmailForReset =>
      'Nejprve zadejte svou e-mailovou adresu, poté klepněte na „Zapomenuté heslo?“ pro zaslání odkazu k obnovení.';

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
  String get awaitingMovedTitle => 'Už nejste členem sboru';

  @override
  String get awaitingMovedBody =>
      'Podle záznamů tohoto sboru jste se přestěhoval(a), a proto se vám zde sborové informace už nezobrazují. Historie vašich zpráv zůstává uložena u sboru. Pokud jde o omyl, obraťte se prosím na někoho ze starších.';

  @override
  String get deleteAccountAction => 'Smazat můj účet';

  @override
  String get deleteAccountWarning =>
      'Tímto trvale smažete svůj účet a osobní profil (jméno, kontaktní údaje a přihlášení). Tuto akci nelze vrátit zpět. Vaše odevzdané zprávy zůstanou uloženy u sboru.';

  @override
  String get deleteAccountPasswordLabel => 'Pro potvrzení zadejte heslo';

  @override
  String get deleteAccountConfirm => 'Smazat účet';

  @override
  String get deleteAccountSoleAdminTitle => 'Jste jediný administrátor';

  @override
  String get deleteAccountSoleAdminBody =>
      'Jste jediný úplný administrátor sboru. Nejprve udělte práva úplného administrátora jinému členovi, jinak by smazáním vašeho účtu zůstal sbor bez administrátora a bez možnosti obnovit přístup.';

  @override
  String get changePasswordAction => 'Změnit heslo';

  @override
  String get changePasswordCurrentLabel => 'Aktuální heslo';

  @override
  String get changePasswordNewLabel => 'Nové heslo';

  @override
  String get changePasswordConfirmLabel => 'Potvrďte nové heslo';

  @override
  String get changePasswordConfirm => 'Aktualizovat heslo';

  @override
  String get changePasswordSuccess => 'Heslo bylo aktualizováno.';

  @override
  String get changeEmailAction => 'Změnit přihlašovací e-mail';

  @override
  String get changeEmailBody =>
      'Na novou adresu pošleme potvrzovací odkaz. Na starou adresu se nic neposílá, takže to funguje, i když se do své staré schránky už nedostanete.';

  @override
  String get changeEmailReloginWarning =>
      'Budete se muset znovu přihlásit. Změna se projeví, až otevřete odkaz v nové schránce — toto zařízení vás pak odhlásí a přihlásíte se novou adresou a svým dosavadním heslem.';

  @override
  String get changeEmailNewLabel => 'Nová e-mailová adresa';

  @override
  String get changeEmailPasswordLabel => 'Pro potvrzení zadejte své heslo';

  @override
  String get changeEmailConfirm => 'Odeslat potvrzovací odkaz';

  @override
  String changeEmailSent(String email) {
    return 'Potvrzovací odkaz byl odeslán na $email. Otevřete jej a dokončete změnu, pak se znovu přihlaste novou adresou.';
  }

  @override
  String get changeEmailInvalid => 'Toto není platná e-mailová adresa.';

  @override
  String get changeEmailSameAsCurrent => 'Toto už je vaše přihlašovací adresa.';

  @override
  String get navInfoBoard => 'Informační deska';

  @override
  String get navEvents => 'Události';

  @override
  String get navLmm => 'Shromáždění v týdnu';

  @override
  String get navWeekend => 'Víkendové shromáždění';

  @override
  String get navPublicWitnessing => 'Veřejné svědectví';

  @override
  String get navFieldServiceMeetings => 'Schůzky před službou';

  @override
  String get navTerritories => 'Obvody';

  @override
  String get navMinistryGroups => 'Skupiny služby';

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
  String get navStatistics => 'Statistiky';

  @override
  String get navHelp => 'Nápověda';

  @override
  String get helpPublisherSection => 'Tipy pro zvěstovatele';

  @override
  String get helpAdminSection => 'Pro správce';

  @override
  String get helpCalendarTitle => 'Přidání do kalendáře';

  @override
  String get helpCalendarBody =>
      'V mobilní aplikaci mají události a vaše úkoly ikonu kalendáře. Klepnutím na ni přidáte položku do kalendáře v telefonu.';

  @override
  String get helpRemindersTitle => 'Připomenutí úkolů';

  @override
  String get helpRemindersBody =>
      'Na obrazovce Události klepněte na ikonu zvonku u sekce „Moje nadcházející úkoly“ a nastavte si, jak dlouho předem chcete být na úkoly upozorněni. (Pouze v mobilní aplikaci.)';

  @override
  String get helpHighlightTitle => 'Rychle se najdete';

  @override
  String get helpHighlightBody =>
      'V rozpisech shromáždění je vaše jméno zvýrazněno, takže své úkoly snadno najdete.';

  @override
  String get helpTerritoryMapTitle => 'Otevření mapy obvodu';

  @override
  String get helpTerritoryMapBody =>
      'Klepnutím na ikonu mapy u obvodu otevřete jeho mapu. Šedá ikona znamená, že obvod zatím nemá přidaný odkaz na mapu.';

  @override
  String get helpAdminToggleTitle => 'Zobrazení aplikace jako zvěstovatel';

  @override
  String get helpAdminToggleBody =>
      'Ikona tužky v horní liště dočasně skryje všechny nástroje správce, takže uvidíte aplikaci přesně tak, jak ji vidí zvěstovatelé. Dalším klepnutím je zase zobrazíte.';

  @override
  String get helpPdfExportTitle => 'Tisk a sdílení rozpisů';

  @override
  String get helpPdfExportBody =>
      'Na obrazovkách Shromáždění v týdnu a Víkendové shromáždění mají editoři rozpisů v horní liště ikonu PDF, která vyexportuje měsíční rozpis k tisku nebo sdílení.';

  @override
  String get helpGoogleMyMapsTitle => 'Mapy obvodů v Google My Maps';

  @override
  String get helpGoogleMyMapsBody =>
      'Mapy obvodů vytvořte v Google My Maps a odkaz na sdílení každého obvodu vložte do jeho pole s odkazem na mapu. Podrobný návod najdete na GitHubu.';

  @override
  String get helpOpenGuide => 'Otevřít návod';

  @override
  String get helpDataDelayTitle => 'Změny se mohou projevit se zpožděním';

  @override
  String get helpDataDelayBody =>
      'Změny provedené v aplikaci – například úpravy ve Zvěstovatelích – se mohou zobrazit až po minutě. (Někdy se třeba po importu S-21 nezobrazí hodiny služby za aktuální služební rok hned.)';

  @override
  String get helpPwApplyTitle => 'Přihlášení na veřejné svědectví';

  @override
  String get helpPwApplyBody =>
      'Otevři Veřejné svědectví, najdi termín a klepni na ikonu ruky, čímž se přihlásíš; dalším klepnutím se odhlásíš. Pokud ikonu nevidíš, požádej administrátora, aby ti ve tvém záznamu zapnul kvalifikaci „Veřejné svědectví“.';

  @override
  String get helpChangeEmailTitle => 'Změna e-mailu, kterým se přihlašujete';

  @override
  String get helpChangeEmailBody =>
      'Nedostanete se do schránky, se kterou jste se registrovali? V Můj profil klepněte na „Změnit přihlašovací e-mail“, zadejte novou adresu a své heslo. Potvrzovací odkaz přijde jen do nové schránky — otevřete jej a pak se znovu přihlaste novou adresou. Pole s e-mailem výše v profilu je jen kontaktní adresa; jeho změna nemění, čím se přihlašujete.';

  @override
  String get helpPwAssignTitle => 'Přidělení zvěstovatelů na veřejné svědectví';

  @override
  String get helpPwAssignBody =>
      'U každého zájemce zapni kvalifikaci „Veřejné svědectví“ v části Zvěstovatelé → otevři zvěstovatele → Kvalifikace. Poté ve Veřejném svědectví otevři termín a klepni na „Přiděleno“: zvěstovatelé, kteří se přihlásili, jsou nahoře v seznamu se štítkem „Přihlášen“. Pro pravidelné stánky použij opakující se termíny.';

  @override
  String get helpS21Title => 'Import záznamů S-21';

  @override
  String get helpS21Body =>
      'Záznam zvěstovatele o službě (S-21) můžeš importovat z PDF. Otevři Zvěstovatelé → zvěstovatel → S-21 a vyber soubor. Načítá se pouze textová vrstva PDF, takže naskenované nebo sloučené formuláře se nemusí naimportovat.';

  @override
  String get helpS99Title => 'Import názvů veřejných proslovů (S-99)';

  @override
  String get helpS99Body =>
      'V Názvech veřejných proslovů zvol „Aktualizovat názvy z PDF“ a vyber oficiální formulář S-99 v PDF. Nadcházející víkendová shromáždění, která odkazují na tato čísla proslovů, se automaticky aktualizují.';

  @override
  String get adminToggleHide => 'Skrýt možnosti správce';

  @override
  String get adminToggleShow => 'Zobrazit možnosti správce';

  @override
  String get profileEmailSelfHint =>
      'Kontaktní adresa pro sbor. Chcete-li změnit adresu, kterou se přihlašujete, použijte níže „Změnit přihlašovací e-mail“.';

  @override
  String get profileEmailAdminHint =>
      'Kontaktní adresa. Její změna zde nemění adresu, kterou se tento zvěstovatel přihlašuje.';

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
  String get hopeOtherSheep => 'Jiná ovce';

  @override
  String get hopeAnointed => 'Pomazaný';

  @override
  String get profileStatus => 'Služební postavení';

  @override
  String get statusNone => '-';

  @override
  String get statusPublisher => 'Zvěstovatel';

  @override
  String get statusAuxPioneer => 'Pomocný průkopník';

  @override
  String get statusRegPioneer => 'Pravidelný průkopník';

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
  String get profileAwayTitle => 'Nepřítomnost';

  @override
  String get profileAwayEmpty => 'Žádná nepřítomnost';

  @override
  String get profileAwayAdd => 'Přidat nepřítomnost';

  @override
  String profileAwayRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String serviceYear(int year) {
    return 'Služební rok $year';
  }

  @override
  String get recordTotalHours => 'Hodiny celkem';

  @override
  String get recordAverageHours => 'Měsíční průměr';

  @override
  String get reportMonth => 'Měsíc';

  @override
  String get reportPublisher => 'Zvěstovatel';

  @override
  String get reportParticipated => 'Byl/a ve službě';

  @override
  String get reportStudies => 'Biblická studia';

  @override
  String get reportHours => 'Hodiny';

  @override
  String get reportCredit => 'Započtené hodiny';

  @override
  String get reportComments => 'Poznámky';

  @override
  String get reportParticipatedShort => 'Ve službě';

  @override
  String get reportStudiesShort => 'Studia';

  @override
  String get reportAuxShort => 'Pomocný';

  @override
  String get reportCreditShort => 'Započtené';

  @override
  String get s21Export => 'Exportovat S-21 (PDF)';

  @override
  String get s21ExportAll => 'Exportovat S-21 všech (PDF)';

  @override
  String get s21BatchConfirmTitle => 'Exportovat S-21 všech zvěstovatelů?';

  @override
  String s21BatchConfirmBody(int count, String years) {
    return 'Vytvoří se jedno PDF s $count kartami zvěstovatelů, každá za $years. Soubor obsahuje osobní údaje — data narození a křtu, jmenování a celou historii hlášení. Uložte ho bezpečně a sdílejte jen s těmi, kdo ho potřebují. Ve velkém sboru to může chvíli trvat.';
  }

  @override
  String get s21BatchGenerating => 'Vytvářejí se karty S-21…';

  @override
  String get schedulePdfExport => 'Měsíční přehled (PDF)';

  @override
  String get pubPdfExport => 'Exportovat seznam (PDF)';

  @override
  String get pubPdfTitle => 'Profily zvěstovatelů';

  @override
  String pubPdfGenerated(String date, int count) {
    return 'Vytvořeno $date · $count zvěstovatelů';
  }

  @override
  String get pubPdfLegend => 'Vysvětlivky';

  @override
  String get pubPdfConfirmTitle => 'Exportovat profily zvěstovatelů?';

  @override
  String pubPdfConfirmBody(int count) {
    return 'PDF bude obsahovat osobní údaje $count zvěstovatelů — adresy, telefonní čísla, data narození a křtu a nouzové kontakty. Uložte soubor bezpečně a sdílejte ho jen s těmi, kdo ho potřebují.';
  }

  @override
  String get pubExportScopeTitle => 'Zkontrolujte, co se vyexportuje';

  @override
  String pubExportScopeListed(int count) {
    return 'Export zahrne $count záznamů, které jsou právě v seznamu.';
  }

  @override
  String pubExportScopeMissing(int missing, int total) {
    return '$missing z $total zvěstovatelů ve sboru je odfiltrováno.';
  }

  @override
  String pubExportScopeExtra(int count) {
    return '$count záznamů v seznamu nejsou aktivní zvěstovatelé — služební postavení „-“ nebo se přestěhovali.';
  }

  @override
  String get pubExportScopeHint =>
      'Zapněte filtr „Zvěstovatelé“ a ostatní zrušte, aby export zahrnul všechny.';

  @override
  String get lmmScheduleTitle => 'Program shromáždění v týdnu';

  @override
  String get s21Title => 'KARTA SBOROVÉHO ZVĚSTOVATELE';

  @override
  String get s21Name => 'Jméno:';

  @override
  String get s21DateOfBirth => 'Datum narození:';

  @override
  String get s21DateOfBaptism => 'Datum křtu:';

  @override
  String get s21HoursHeader => 'Hodiny (pokud je průkopník nebo misionář)';

  @override
  String get s21Remarks => 'Poznámky';

  @override
  String get s21Total => 'Celkem';

  @override
  String get s21FormCode => 'S-21-B 11/23';

  @override
  String s21Credit(int hours) {
    return 'Kredit: $hours';
  }

  @override
  String get s21Import => 'Importovat S-21 (PDF)';

  @override
  String get s21ImportNew => 'Importovat zvěstovatele z S-21';

  @override
  String get s21ImportTitle => 'Import S-21';

  @override
  String get s21ImportPickFile => 'Vybrat soubor PDF';

  @override
  String get s21ImportHint =>
      'Vyberte kartu sborového záznamu zvěstovatele (S-21, PDF). Hodnoty z karty nahradí údaje v profilu zvěstovatele a jeho měsíční zprávy.';

  @override
  String get s21ImportNoData => 'V souboru nebyla nalezena žádná data S-21.';

  @override
  String s21ImportMonths(int count) {
    return 'Nalezeno $count měsíčních zpráv';
  }

  @override
  String s21ImportNameKept(String name) {
    return 'Jméno v aplikaci zůstane zachováno: $name';
  }

  @override
  String s21ImportCardName(String name) {
    return 'Jméno na kartě: $name';
  }

  @override
  String s21ImportDuplicateName(String name) {
    return 'Zvěstovatel se jménem „$name“ již existuje.';
  }

  @override
  String get s21ImportUseExisting => 'Importovat do stávajícího záznamu';

  @override
  String get s21ImportReplaceTitle => 'Nahradit stávající záznamy?';

  @override
  String get s21ImportReplaceBody =>
      'Údaje v profilu zvěstovatele a měsíční zprávy za importované služební roky budou nahrazeny hodnotami z tohoto S-21. Tuto akci nelze vrátit zpět.';

  @override
  String get s21ImportSave => 'Importovat';

  @override
  String get s21ImportDone => 'S-21 importováno.';

  @override
  String get s21ImportAssignYear => 'Služební rok této tabulky';

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
  String get pubAdminDeleteMovedHint =>
      'Pokud má účet v aplikaci, smazání neodstraní jeho přihlášení a mohl by se znovu přihlásit. Pro archivaci někoho, kdo odešel, použijte místo toho „Označit jako přestěhovaného“.';

  @override
  String get pubAdminMarkMoved => 'Označit jako přestěhovaného';

  @override
  String get pubAdminRestoreMoved => 'Obnovit z přestěhovaných';

  @override
  String get pubAdminMovedBadge => 'Přestěhoval se';

  @override
  String get pubAdminShowMoved => 'Zobrazit přestěhované';

  @override
  String get pubAdminMovingDate => 'Datum přestěhování';

  @override
  String get pubAdminChangeMovingDate => 'Změnit datum přestěhování';

  @override
  String pubAdminMovedOn(String date) {
    return 'Přestěhoval se $date';
  }

  @override
  String pubAdminMovingOn(String date) {
    return 'Stěhuje se $date';
  }

  @override
  String get pubAdminMovedHint =>
      'Záznam i historie zpráv zůstávají zachovány. Měsíce před přestěhováním se dál počítají do statistik i do S-1.';

  @override
  String get pubAdminMovedNoDateHint =>
      'Není zadáno datum přestěhování, a proto se žádná jeho zpráva nepočítá do statistik ani do S-1. Zadáním data vrátíte měsíce, kdy tu ještě byl.';

  @override
  String get pubAdminMovePendingHint =>
      'Do toho dne zůstává plnohodnotným členem: programy, seznamy zpráv i přístup do aplikace se nemění.';

  @override
  String get pubFilterPublishers => 'Zvěstovatelé';

  @override
  String get pubFilterPioneers => 'Průkopníci';

  @override
  String get pubFilterHasRights => 'Má práva';

  @override
  String get pubFilterAnyGroup => 'Všechny skupiny';

  @override
  String get pubFilterClear => 'Vymazat';

  @override
  String get pubAdminMoveConfirmTitle => 'Označit jako přestěhovaného?';

  @override
  String pubAdminMoveConfirmBody(String date) {
    return 'Datum přestěhování: $date. Záznam a historie zpráv zůstanou zachovány — vše do toho dne se dál počítá do statistik i do S-1. Od toho dne bude zvěstovatel archivován: jeho přístup bude odebrán a nebude se objevovat v programech ani v seznamech zpráv. Později ho můžete obnovit.';
  }

  @override
  String pubAdminMoveConfirmFutureBody(String date) {
    return 'Datum přestěhování: $date. Do té doby se nic nemění — zvěstovatel má dál přístup do aplikace a zůstává v programech i v seznamech zpráv. V ten den bude automaticky archivován; jeho záznam a historie zpráv zůstanou zachovány.';
  }

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
  String get pubConnectBanner =>
      'Tento účet čeká na ověření. Pokud už administrátor pro tuto osobu vytvořil záznam zvěstovatele, propojte je: historie záznamu se přesune na tento účet a duplicitní záznam zmizí.';

  @override
  String get pubConnectAction => 'Propojit se stávajícím záznamem';

  @override
  String get pubConnectNeedsFullAdmin =>
      'Záznamy může propojit pouze hlavní administrátor (migrace zasahuje do dat všech sekcí).';

  @override
  String get pubConnectPickTitle => 'Propojit se stávajícím záznamem';

  @override
  String pubConnectPickHint(String name) {
    return 'Vyberte záznam, který patří osobě $name.';
  }

  @override
  String get pubConnectNoRecords =>
      'Není žádný záznam zvěstovatele bez účtu v aplikaci, který by šlo propojit.';

  @override
  String get pubConnectConfirmTitle => 'Propojit a sloučit?';

  @override
  String pubConnectConfirmBody(String record, String account) {
    return 'Kompletní historie záznamu „$record“ — zprávy, obvody a úkoly v programech — se přesune na účet „$account“. Účet bude ověřen a duplicitní záznam trvale smazán. Tuto akci nelze vrátit zpět.';
  }

  @override
  String get pubConnectProgressTitle => 'Propojování záznamu…';

  @override
  String get pubConnectProgressBody =>
      'Během přesunu historie nezavírejte aplikaci.';

  @override
  String pubConnectFailed(String section) {
    return 'Propojování selhalo v části: $section. Dokončené kroky zůstávají — opakování je bezpečné a naváže tam, kde skončilo.';
  }

  @override
  String get pubConnectSuccess =>
      'Záznam propojen — jeho historie nyní patří k tomuto účtu.';

  @override
  String get roleFullAdmin => 'Hlavní administrátor';

  @override
  String get roleRecordAttendance => 'Zapsat návštěvnost';

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
  String get weekShowToPublishers => 'Zobrazit zvěstovatelům';

  @override
  String get weekShowToPublishersOn => 'Zvěstovatelé vidí, kdo je přidělen.';

  @override
  String get weekShowToPublishersOff => 'Zvěstovatelé vidí program bez jmen.';

  @override
  String get lmmSongs => 'Písně';

  @override
  String get sectionOpening => 'Úvod';

  @override
  String get sectionTreasures => 'POKLADY Z BOŽÍHO SLOVA';

  @override
  String get sectionMinistry => 'ZLEPŠUJ SE VE SLUŽBĚ';

  @override
  String get sectionLiving => 'ŽIVOT KŘESŤANA';

  @override
  String get sectionClosing => 'Závěr';

  @override
  String get partChairman => 'Předsedající';

  @override
  String get partOpeningPrayer => 'Úvodní modlitba';

  @override
  String get partClosingPrayer => 'Závěrečná modlitba';

  @override
  String get partGems => 'Hledání duchovních drahokamů';

  @override
  String get partBibleReading => 'Čtení Bible';

  @override
  String get partCbs => 'Sborové studium Bible';

  @override
  String get partCbsReader => 'Čtenář';

  @override
  String get partAssistant => 'Partner';

  @override
  String partMinutes(int min) {
    return '$min min';
  }

  @override
  String get lmmClassMain => 'Hlavní sál';

  @override
  String lmmClassN(int index) {
    return '$index. sál';
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
  String get customAssignmentPermanent => 'Trvalý (každý týden)';

  @override
  String get customAssignmentRemovePermanentTitle => 'Odebrat trvalý úkol';

  @override
  String customAssignmentRemovePermanentBody(String label) {
    return 'Odebrat „$label“ z každého týdne?';
  }

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
  String get pickerApplied => 'Přihlášen(a)';

  @override
  String pickerAwayWarning(String range) {
    return 'Nepřítomen $range';
  }

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
  String get songLabel => 'Píseň';

  @override
  String get songsSearchHint => 'Hledat píseň…';

  @override
  String get songsEmpty =>
      'Zatím žádný seznam písní. Aktualizujte jej z oficiálního webu.';

  @override
  String get songsUpdateFromWeb =>
      'Aktualizovat seznam písní z oficiálního webu';

  @override
  String songsUpdateDone(int count) {
    return 'Seznam písní aktualizován: $count písní.';
  }

  @override
  String get songsCdnNothing => 'Seznam písní zatím není online k dispozici.';

  @override
  String get songsStatusEmpty => 'Seznam písní zatím nebyl importován.';

  @override
  String songsStatusLoaded(int count, String date) {
    return '$count písní · aktualizováno $date';
  }

  @override
  String get settingsSongsSection => 'Seznam písní';

  @override
  String get settingsSongsDescription =>
      'Stáhněte si názvy písní ze jw.org, aby je bylo možné vybírat v programu víkendového a všedního shromáždění.';

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
  String get pwApply => 'Přihlásit se na tento termín';

  @override
  String get pwWithdraw => 'Zrušit přihlášku';

  @override
  String get pwRecurringDeleteConfirm =>
      'Odstranit tento opakovaný termín? Jeho budoucí termíny budou odstraněny také, včetně přihlášek na ně. Tuto akci nelze vrátit zpět.';

  @override
  String get pwRemoveAllFutureAction => 'Odstranit všechny budoucí termíny';

  @override
  String get pwRemoveAllFutureWarning =>
      'Odstranění všech budoucích termínů smaže každý nadcházející jednorázový i opakovaný termín a nelze je vrátit zpět.';

  @override
  String get pwRemoveAllFutureTitle => 'Odstranit všechny budoucí termíny?';

  @override
  String get pwRemoveAllFutureBody =>
      'Odstraní každý nadcházející jednorázový i opakovaný termín, zruší přihlášky na ně a odstraní všechna pravidla opakovaných termínů, aby se znovu nevytvářely. Minulé termíny zůstanou zachovány. Tuto akci nelze vrátit zpět.';

  @override
  String get pwRemoveAllFutureConfirm => 'Odstranit vše';

  @override
  String get pwDeleteFromWeekTooltip => 'Odstranit termíny od tohoto týdne dál';

  @override
  String pwDeleteFromWeekTitle(String week) {
    return 'Odstranit termíny od $week dál?';
  }

  @override
  String get pwDeleteFromWeekBody =>
      'Odstraní každý jednorázový i opakovaný termín od vybraného týdne dál, zruší přihlášky na ně a ukončí opakované termíny, aby se znovu nevytvářely. Dřívější termíny zůstanou zachovány. Tuto akci nelze vrátit zpět.';

  @override
  String get pwDeleteFromWeekDone => 'Termíny byly odstraněny.';

  @override
  String pwApplicants(int count) {
    return 'Přihlášeni: $count';
  }

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
  String get fsmNote => 'Poznámka';

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
  String get fsmRecurringDeleteConfirm =>
      'Smazat tuto opakovanou schůzku? Budou odstraněny i všechny její budoucí schůzky. Tuto akci nelze vrátit zpět.';

  @override
  String get fsmRemoveAllFutureAction => 'Odstranit všechny budoucí schůzky';

  @override
  String get fsmRemoveAllFutureWarning =>
      'Odstranění všech budoucích schůzek smaže každou nadcházející jednorázovou i opakovanou schůzku a nelze to vrátit zpět.';

  @override
  String get fsmRemoveAllFutureTitle => 'Odstranit všechny budoucí schůzky?';

  @override
  String get fsmRemoveAllFutureBody =>
      'Tímto se smažou všechny nadcházející jednorázové i opakované schůzky pro službu a odstraní se všechna pravidla opakovaných schůzek, aby se znovu neobnovily. Minulé schůzky zůstanou zachovány. Tuto akci nelze vrátit zpět.';

  @override
  String get fsmRemoveAllFutureConfirm => 'Odstranit vše';

  @override
  String get fsmDeleteFromWeekTooltip =>
      'Odstranit schůzky od tohoto týdne dál';

  @override
  String fsmDeleteFromWeekTitle(String week) {
    return 'Odstranit schůzky od $week dál?';
  }

  @override
  String get fsmDeleteFromWeekBody =>
      'Odstraní každou jednorázovou i opakovanou schůzku od vybraného týdne dál a ukončí opakované schůzky, aby se znovu nevytvářely. Dřívější schůzky zůstanou zachovány. Tuto akci nelze vrátit zpět.';

  @override
  String get fsmDeleteFromWeekDone => 'Schůzky byly odstraněny.';

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
  String get eventTypeCoVisit => 'Návštěva krajského staršího';

  @override
  String get meetingWeekChanged => 'Změněno pro tento týden';

  @override
  String get weekPickTooltip => 'Vybrat týden';

  @override
  String get meetingWeekEditTooltip => 'Změnit den a čas v tomto týdnu';

  @override
  String get coNotScheduledYet => 'Zatím bez termínu';

  @override
  String get meetingWeekDifferent => 'Jiný den nebo čas v tomto týdnu';

  @override
  String meetingWeekFollows(String day, String time) {
    return 'Obvykle $day, $time';
  }

  @override
  String get meetingWeekDay => 'Den';

  @override
  String get meetingWeekTime => 'Čas';

  @override
  String get coVisitNotPublished =>
      'Návštěva krajského staršího zatím není zveřejněná.';

  @override
  String get coVisitNonePlanned => 'Zatím není naplánovaná žádná návštěva.';

  @override
  String get coVisitSetWeek => 'Vyber týden návštěvy';

  @override
  String get coVisitDelete => 'Smazat návštěvu';

  @override
  String get coVisitDeleteConfirm =>
      'Smazat tuto návštěvu i všechno, co je pro ni naplánované? Schůzky před službou v tomto týdnu zůstanou. Tuto akci nelze vrátit.';

  @override
  String get coVisitVisibleToPublishers => 'Zobrazit zvěstovatelům';

  @override
  String get coVisitVisibleOn => 'Zvěstovatelé návštěvu vidí.';

  @override
  String get coVisitVisibleOff => 'Návštěvu vidí jen správci.';

  @override
  String get coSectionMeal => 'Jídlo na poledne';

  @override
  String get coSectionShepherding => 'Pastýřské návštěvy';

  @override
  String get coSectionPioneers => 'Schůzka s průkopníky';

  @override
  String get coSectionElders => 'Schůzka se staršími a služebními pomocníky';

  @override
  String get coSectionOther => 'Ostatní';

  @override
  String get coSectionEmpty => 'Zatím nic naplánovaného.';

  @override
  String get coSectionHidden => 'Skryto';

  @override
  String get coSectionHide => 'Skrýt zvěstovatelům';

  @override
  String get coSectionShow => 'Zobrazit zvěstovatelům';

  @override
  String get coWithCo => 'V kazatelské službě s krajským starším';

  @override
  String get coWithCoWife => 'V kazatelské službě s jeho manželkou';

  @override
  String get coDay => 'Den';

  @override
  String get coTime => 'Čas';

  @override
  String get coAddress => 'Adresa';

  @override
  String get coNote => 'Poznámka';

  @override
  String get coAssigned => 'Zvěstovatelé';

  @override
  String get coMinistryOtherAdmins =>
      'Schůzky před službou upravují jejich vlastní správci.';

  @override
  String get coMidweekOtherAdmins =>
      'Den shromáždění v týdnu nastavují správci programu shromáždění v týdnu.';

  @override
  String get coMidweekNotMoved =>
      'Shromáždění v týdnu nebylo přesunuto na úterý – to nastavují správci programu shromáždění v týdnu.';

  @override
  String get coPrintTitle => 'Vytisknout program návštěvy';

  @override
  String get coPrintIncludeHiddenBody =>
      'Některé části jsou skryté zvěstovatelům. Vytisknout je také?';

  @override
  String get coPrintIncludeHidden => 'Včetně skrytých';

  @override
  String get coPrintVisibleOnly => 'Jen viditelné';

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
  String get remindersTitle => 'Připomenutí úkolů';

  @override
  String get remindersDescription =>
      'Získejte na tomto zařízení upozornění před každým nadcházejícím úkolem. Změny provedené během zavřené aplikace se projeví, až ji příště otevřete.';

  @override
  String get remindersEnable => 'Zapnout připomenutí';

  @override
  String get remindersAdd => 'Přidat připomenutí';

  @override
  String get reminderUnitMinutes => 'minut předem';

  @override
  String get reminderUnitHours => 'hodin předem';

  @override
  String get reminderUnitDays => 'dní předem';

  @override
  String get remindersPermissionDenied =>
      'Oznámení pro tuto aplikaci nejsou povolena. Povolte je v nastavení systému, abyste mohli používat připomenutí.';

  @override
  String get remindersChannelName => 'Připomenutí úkolů';

  @override
  String get remindersChannelDescription =>
      'Oznámení před vašimi sborovými úkoly';

  @override
  String get roleAssistant => 'Partner';

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
  String get reportEmpty => 'Prázdná zpráva — žádná služba';

  @override
  String get reportNotCountedMoved => 'Přestěhoval se — nepočítá se';

  @override
  String get reportFormerMember => 'Bývalý člen';

  @override
  String reportEnterFor(String name) {
    return 'Zadat zprávu — $name';
  }

  @override
  String reportSummaryReported(int reported, int total) {
    return 'Odevzdáno: $reported / $total';
  }

  @override
  String get reportCheckTitle => 'Zkontrolujte zprávu';

  @override
  String get reportCheckPioneerNoHours =>
      'U zprávy průkopníka nejsou vyplněné hodiny. Pokud opravdu nebyl žádný čas ve službě, zadejte 0.';

  @override
  String get reportCheckWasActiveLastMonth =>
      'Není zaškrtnuto „Účast ve službě“, ale minulý měsíc byla služba nahlášena.';

  @override
  String get reportCheckQuestion => 'Uložit zprávu i tak?';

  @override
  String get reportSaveAnyway => 'Přesto uložit';

  @override
  String get reportStatusThisMonth => 'Stav v tomto měsíci';

  @override
  String get attAdd => 'Zapsat návštěvnost';

  @override
  String get attInPerson => 'Osobně';

  @override
  String get attOnline => 'Online';

  @override
  String get attTotal => 'Celkem';

  @override
  String get attMeetingLmm => 'Shromáždění v týdnu';

  @override
  String get attMeetingWeekend => 'Víkendové shromáždění';

  @override
  String get attOverview => 'Měsíční průměry';

  @override
  String get attHistory => 'Minulá shromáždění';

  @override
  String get attNotFilled => 'Nezaznamenáno';

  @override
  String get attMismatch => 'Počty nesouhlasí.';

  @override
  String attRecordedOf(int filled, int expected) {
    return '$filled/$expected zaznamenáno';
  }

  @override
  String get attSaved => 'Návštěvnost uložena.';

  @override
  String get attRecordExport => 'Exportovat zprávu o návštěvnosti (PDF)';

  @override
  String get attRecordDialogTitle => 'Exportovat zprávu o návštěvnosti';

  @override
  String attRecordCovers(String years) {
    return 'Obsahuje $years';
  }

  @override
  String get attRecordTitle => 'ZPRÁVA O NÁVŠTĚVNOSTI SHROMÁŽDĚNÍ';

  @override
  String get attRecordColMeetings => 'Počet shromáždění';

  @override
  String get attRecordColTotal => 'Celková účast';

  @override
  String get attRecordColAvgWeek => 'Průměrná týdenní účast';

  @override
  String get attRecordRowAvgMonth => 'Průměrná týdenní účast za rok';

  @override
  String get statMembershipTitle => 'Zvěstovatelé';

  @override
  String get statTotalMembers => 'Všichni zvěstovatelé';

  @override
  String get statPioneers => 'Průkopníků';

  @override
  String get statAgeTitle => 'Věkové rozložení';

  @override
  String get statAgeAverage => 'Průměrný věk';

  @override
  String statAgeKnownDetail(int known, int total) {
    return 'Vychází z $known z $total známých dat narození';
  }

  @override
  String get statAgeUnder18 => 'Do 18 let';

  @override
  String get statAgeUnknown => 'Neznámý';

  @override
  String get statAttendanceTitle => 'Návštěvnost shromáždění';

  @override
  String get statAvg3Months => 'průměr za 3 měs.';

  @override
  String get statAvg12Months => 'průměr za 12 měs.';

  @override
  String get statFieldServiceTitle => 'Kazatelská služba';

  @override
  String statServiceYear(String year) {
    return 'Služební rok $year';
  }

  @override
  String get statReportsSubmitted => 'Odevzdaných zpráv';

  @override
  String get statParticipated => 'Podíleli se na službě';

  @override
  String get statPioneerHours => 'Hodiny průkopníků';

  @override
  String get statPublisherHours => 'Hodiny zvěstovatelů';

  @override
  String get statTerrCompleted => 'Dokončeno';

  @override
  String get statTerrAvgDays => 'Prům. dnů do dokončení';

  @override
  String get statTerrCovered => 'Zpracováno ve služebním roce';

  @override
  String get statTerrNotCovered => 'Nezpracováno ve služebním roce';

  @override
  String get statTerrPerMonth => 'Dokončeno podle měsíců';

  @override
  String get statUsageTitle => 'Používání aplikace';

  @override
  String get statWithAccount => 'S účtem v aplikaci';

  @override
  String get statSelfReported => 'Samostatně odeslané zprávy (minulý měsíc)';

  @override
  String get statAwaiting => 'Čeká na ověření';

  @override
  String get statFullAdmins => 'Plných správců';

  @override
  String get statSectionAdmins => 'Správců sekcí';

  @override
  String get statNoData => 'Zatím žádná data';

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
  String get terrNameDuplicate => 'Obvod s tímto názvem již existuje.';

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
  String get terrImportTitle => 'Import obvodů';

  @override
  String get terrImportPasteHint =>
      'Vložte řádky z Excelu nebo Tabulek Google. Sloupce: název, odkaz na mapu, poznámky — povinný je jen název.';

  @override
  String get terrImportPreview => 'Náhled';

  @override
  String get terrImportPickFile => 'Vybrat soubor CSV';

  @override
  String terrImportSummary(
    int total,
    int newCount,
    int duplicates,
    int invalid,
  ) {
    return '$total řádků: $newCount nových, $duplicates existujících, $invalid neplatných';
  }

  @override
  String get terrImportUpdateExisting =>
      'Aktualizovat existující obvody (podle názvu) místo přeskočení';

  @override
  String get terrImportBadgeNew => 'Nový';

  @override
  String get terrImportBadgeSkip => 'Přeskočí se';

  @override
  String get terrImportBadgeUpdate => 'Aktualizuje se';

  @override
  String get terrImportBadgeInvalid => 'Chybí název';

  @override
  String get terrImportBadgeDupRow => 'Duplicitní řádek';

  @override
  String terrImportLine(int line) {
    return 'Řádek $line';
  }

  @override
  String terrImportSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importovat $count obvodů',
      few: 'Importovat $count obvody',
      one: 'Importovat 1 obvod',
    );
    return '$_temp0';
  }

  @override
  String terrImportDone(int created, int updated) {
    return 'Importováno: $created nových, $updated aktualizováno.';
  }

  @override
  String get terrImportEmpty => 'Ve vstupu nebyly nalezeny žádné řádky.';

  @override
  String get terrDeleteConfirm =>
      'Smazat tento obvod? Tuto akci nelze vrátit zpět.';

  @override
  String get terrSortByTerritory => 'Obvod';

  @override
  String get terrSortByPublisher => 'Zvěstovatel';

  @override
  String get terrSortByDate => 'Datum přidělení';

  @override
  String get terrHolderDeleted => 'Smazaný zvěstovatel';

  @override
  String get terrHistoryOngoing => 'Aktuální';

  @override
  String get terrHistoryEmpty => 'Zatím žádná historie přidělení.';

  @override
  String get terrAsgAddPast => 'Přidat dřívější přidělení';

  @override
  String get terrAsgEdit => 'Upravit přidělení';

  @override
  String get terrAsgHolder => 'Zvěstovatel';

  @override
  String get terrAsgHolderNone => 'Vybrat zvěstovatele…';

  @override
  String get terrAsgPickTitle => 'Kdo měl obvod přidělený?';

  @override
  String get terrAsgDateAssigned => 'Datum přidělení';

  @override
  String get terrAsgDateReturned => 'Datum vrácení';

  @override
  String get terrAsgStillOut => 'Dosud nevrácen';

  @override
  String get terrAsgErrHolderRequired =>
      'Vyberte zvěstovatele nebo zadejte jméno.';

  @override
  String get terrAsgErrDateRequired => 'Vyberte datum, kdy byl obvod přidělen.';

  @override
  String get terrAsgErrReturnBeforeAssigned =>
      'Datum vrácení nemůže být dřívější než datum přidělení.';

  @override
  String get terrAsgErrAlreadyOpen =>
      'Tento obvod je právě přidělený. Zadejte u tohoto přidělení datum vrácení, nebo nejprve vraťte to současné.';

  @override
  String get terrAsgDeleteConfirm =>
      'Smazat toto přidělení z historie obvodu? Tuto akci nelze vrátit zpět.';

  @override
  String get terrRecordExport => 'Exportovat záznam o přidělení obvodu (PDF)';

  @override
  String get terrRecordDialogTitle => 'Exportovat záznam o přidělení obvodu';

  @override
  String get terrRecordTitle => 'ZÁZNAM O PŘIDĚLENÍ OBVODU';

  @override
  String get terrRecordColTerritory => 'Obvod';

  @override
  String get terrRecordColLastCompleted => 'Datum posledního propracování*';

  @override
  String get terrRecordColAssignedTo => 'Jméno zvěstovatele';

  @override
  String get terrRecordColDateAssigned => 'Datum přidělení';

  @override
  String get terrRecordColDateCompleted => 'Datum dokončení';

  @override
  String get terrRecordFootnote =>
      '*Když začínáte novou stránku, do tohoto sloupce uveďte datum, kdy byl obvod naposledy propracován.';

  @override
  String get mgEmpty => 'Zatím žádné skupiny služby.';

  @override
  String get mgAdd => 'Přidat skupinu';

  @override
  String get mgEdit => 'Upravit skupinu';

  @override
  String get mgName => 'Název';

  @override
  String mgMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count členů',
      few: '$count členové',
      one: '1 člen',
      zero: 'Žádní členové',
    );
    return '$_temp0';
  }

  @override
  String get mgNoMembers => 'V této skupině zatím nejsou žádní členové.';

  @override
  String get mgOverseer => 'Dozorce skupiny';

  @override
  String get mgAssistant => 'Pomocník';

  @override
  String get mgMakeOverseer => 'Nastavit jako dozorce skupiny';

  @override
  String get mgMakeAssistant => 'Nastavit jako pomocníka';

  @override
  String get mgClearRole => 'Odebrat označení dozorce/pomocníka';

  @override
  String get mgAddMember => 'Přidat člena…';

  @override
  String get mgNoUnassigned => 'Všichni už jsou v nějaké skupině.';

  @override
  String get mgRemoveMember => 'Odebrat ze skupiny';

  @override
  String get mgDeleteConfirm =>
      'Smazat tuto skupinu? Její členové zůstanou bez skupiny.';

  @override
  String get mgGroup => 'Skupina služby';

  @override
  String get mgNoGroup => 'Bez skupiny';

  @override
  String get infoEmpty => 'Momentálně žádné informace.';

  @override
  String get infoAddText => 'Přidat text';

  @override
  String get infoAddFile => 'Nahrát soubor (PDF/obrázek)';

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
  String get infoCleanTooltip => 'Vyčistit informační desku';

  @override
  String get infoCleanConfirmTitle => 'Vyčistit informační desku?';

  @override
  String get infoCleanConfirmBody =>
      'Tímto trvale odstraníte VŠECHNA oznámení — texty, soubory i odkazy, ať už minulá, aktuální nebo budoucí. Akci nelze vrátit zpět.';

  @override
  String get infoCleanDone => 'Informační deska byla vyčištěna.';

  @override
  String get s1Active =>
      'Činní zvěstovatelé (podali zprávu alespoň jednou za posledních 6 měsíců)';

  @override
  String get s1AvgMid => 'Průměrná návštěvnost shromáždění v týdnu';

  @override
  String get s1AvgWeekend => 'Průměrná návštěvnost shromáždění o víkendu';

  @override
  String get s1Publishers => 'Zvěstovatelé';

  @override
  String get s1AuxPioneers => 'Pomocní průkopníci';

  @override
  String get s1RegPioneers => 'Pravidelní průkopníci';

  @override
  String get s1Count => 'Počet těch, kdo podali zprávu';

  @override
  String get s1Studies => 'Biblická studia';

  @override
  String get s1Hours => 'Hodiny (celkem)';

  @override
  String get s1Note =>
      'Pomocní, pravidelní a zvláštní průkopníci se nepočítají do skupiny Zvěstovatelé; zvláštní průkopníci nejsou zahrnuti v žádné skupině.';

  @override
  String get settingsName => 'Název sboru';

  @override
  String get settingsLmmMeeting => 'Shromáždění v týdnu (den a čas)';

  @override
  String get settingsLmmClassCount => 'Počet sálů (shromáždění v týdnu)';

  @override
  String get settingsWeekendMeeting => 'Víkendové shromáždění (den a čas)';

  @override
  String get settingsBackupSection => 'Záloha a obnovení';

  @override
  String get settingsBackupDescription =>
      'Stáhněte si úplnou kopii dat sboru nebo je obnovte ze záložního souboru. Použijte k obnově po nechtěném smazání nebo chybné úpravě.';

  @override
  String get settingsExportData => 'Exportovat všechna data';

  @override
  String get settingsImportData => 'Obnovit ze zálohy…';

  @override
  String backupExportSuccess(int count) {
    return 'Záloha stažena ($count záznamů).';
  }

  @override
  String get backupImportTitle => 'Obnovení ze zálohy';

  @override
  String get backupImportPick => 'Vybrat soubor zálohy…';

  @override
  String get backupImportEmpty =>
      'Vyberte soubor zálohy pro zobrazení jeho obsahu.';

  @override
  String get backupImportContents => 'Obsah';

  @override
  String backupImportFrom(String name, String date) {
    return 'Záloha sboru $name · $date';
  }

  @override
  String get backupImportWarning =>
      'Obnovení přepíše stávající záznamy se stejným ID verzemi z této zálohy. Záznamy přidané po vytvoření zálohy zůstanou zachovány. Tuto akci nelze vrátit zpět.';

  @override
  String get backupImportConfirm => 'Obnovit tuto zálohu';

  @override
  String backupImportSuccess(int count) {
    return 'Obnoveno $count záznamů.';
  }

  @override
  String backupImportPartial(int count, String collections) {
    return 'Obnoveno $count záznamů. Nepodařilo se obnovit: $collections.';
  }

  @override
  String get backupInvalidFile => 'Tento soubor není platná záloha sboru.';

  @override
  String get qSupportSection => 'Podpora shromáždění a další';

  @override
  String get qChairman => 'Předsedající (shromáždění v týdnu)';

  @override
  String get qPrayer => 'Modlitba';

  @override
  String get qTreasures => 'Poklady z Božího slova';

  @override
  String get qGems => 'Hledání duchovních drahokamů';

  @override
  String get qBibleReading => 'Čtení Bible';

  @override
  String get qFieldMinistry => 'Studentské úkoly (služba)';

  @override
  String get qLiving => 'Život křesťana';

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

  @override
  String get programKindRegular => 'Běžný program';

  @override
  String get programKindNothingPlanned => 'Nic neplánováno';

  @override
  String get programKindMemorial => 'Památná slavnost';

  @override
  String get weekNothingPlannedHint => 'Tento týden se shromáždění nekoná.';

  @override
  String get weekProgramSwitchConfirm =>
      'Stávající program zůstane uložený a vrátí se, až ho přepnete zpět.';

  @override
  String get weekRestoreProgram => 'Obnovit běžný program';

  @override
  String get weekNoteLabel => 'Poznámka pro zvěstovatele';

  @override
  String get weekNoteEdit => 'Upravit poznámku';

  @override
  String get memorialBreadPrayer => 'Modlitba u chleba';

  @override
  String get memorialWinePrayer => 'Modlitba u vína';

  @override
  String get memorialAttendance => 'Návštěvnost Památné slavnosti';

  @override
  String get memorialPastTitle => 'Minulé Památné slavnosti';

  @override
  String get attMeetingMemorial => 'Památná slavnost';

  @override
  String get keepOnImport => 'Zachovat při importu';

  @override
  String get keepOnImportHint => 'Import z pracovního sešitu tohle nepřepíše.';

  @override
  String importKeepsEdits(int parts, int songs) {
    return 'Vaše úpravy zůstanou: $parts bodů, $songs písní';
  }

  @override
  String get helpProgramKindTitle => 'Týdny bez shromáždění a Památná slavnost';

  @override
  String get helpProgramKindBody =>
      'V přehledu týdne (uprostřed týdne i o víkendu) je vedle týdne nabídka, kterou ho přepnete na „Nic neplánováno“ (týden se sjezdem nebo shromážděním – zvěstovatelé uvidí místo programu vaši poznámku a nečeká se návštěvnost) nebo na Památnou slavnost, která může připadnout na kterýkoli z obou dnů. Program, ze kterého přepnete, zůstane uložený a vrátí se, až přepnete zpět. Den a čas Památné slavnosti nastavíte tužkou v záhlaví týdne a její návštěvnost se zapisuje přímo u ní – do průměrů shromáždění se nikdy nepočítá.';
}
