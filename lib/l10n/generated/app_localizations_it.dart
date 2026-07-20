// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Pianificatore della congregazione';

  @override
  String get commonSave => 'Salva';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonDelete => 'Elimina';

  @override
  String get commonEdit => 'Modifica';

  @override
  String get commonAdd => 'Aggiungi';

  @override
  String get commonClose => 'Chiudi';

  @override
  String get commonBack => 'Indietro';

  @override
  String get commonRetry => 'Riprova';

  @override
  String get commonLoading => 'Caricamento…';

  @override
  String get commonError => 'Qualcosa è andato storto';

  @override
  String commonErrorDetail(String message) {
    return 'Qualcosa è andato storto: $message';
  }

  @override
  String get commonFieldRequired => 'Questo campo è obbligatorio';

  @override
  String get commonConfirmDeleteTitle => 'Eliminare?';

  @override
  String get commonConfirmDeleteBody =>
      'Questa azione non può essere annullata.';

  @override
  String get commonToday => 'Oggi';

  @override
  String get commonAll => 'Tutti';

  @override
  String get commonNone => 'Nessuno';

  @override
  String get commonYes => 'Sì';

  @override
  String get commonNo => 'No';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSearch => 'Cerca';

  @override
  String get commonNotAssigned => '—';

  @override
  String get commonLanguage => 'Lingua';

  @override
  String get setupTitle => 'Connettiti alla tua congregazione';

  @override
  String get setupIntro =>
      'Questa app si connette direttamente al database della tua congregazione. Incolla la configurazione che hai ricevuto dal tuo amministratore oppure scansiona il codice QR dell\'invito.';

  @override
  String get setupConfigLabel => 'Configurazione Firebase (JSON)';

  @override
  String get setupConfigHint => 'apiKey, authDomain, projectId, …';

  @override
  String get setupScanQr => 'Scansiona codice QR';

  @override
  String get setupPickQrImage => 'Scegli foto del codice QR';

  @override
  String get setupQrNotFoundInImage =>
      'Nessun codice QR trovato in quell\'immagine.';

  @override
  String get setupConnect => 'Connetti';

  @override
  String get setupInvalidJson =>
      'Questa configurazione JSON non è valida. Deve contenere almeno apiKey, projectId e appId.';

  @override
  String setupConnectionFailed(String message) {
    return 'Impossibile connettersi con questa configurazione: $message';
  }

  @override
  String get setupModeTitle => 'Come vuoi iniziare?';

  @override
  String get setupModeJoin => 'Unisciti alla mia congregazione';

  @override
  String get setupModeJoinSubtitle =>
      'Un amministratore ti ha invitato. Dopo la registrazione verificherà il tuo account.';

  @override
  String get setupModeNew => 'Configura una nuova congregazione';

  @override
  String get setupModeNewSubtitle =>
      'Sei il primo amministratore di un progetto Firebase appena creato.';

  @override
  String get setupCongregationExists =>
      'Questa congregazione è già configurata. Scegli invece «Unisciti alla mia congregazione».';

  @override
  String get setupDatabaseNotReady =>
      'Il database della congregazione si sta ancora avviando. Attendi un momento e riprova.';

  @override
  String get setupReconfigure => 'Cambia configurazione';

  @override
  String get setupRestartRequired =>
      'Configurazione salvata. Chiudi e riapri l\'app per applicarla.';

  @override
  String get setupGuideLinkIntro =>
      'Non hai una configurazione? Crea il database gratuito della tua congregazione:';

  @override
  String get setupGuideLinkButton => 'Come configurare una nuova congregazione';

  @override
  String get setupGuideTitle => 'Configura una nuova congregazione';

  @override
  String get setupGuideIntro =>
      'Questa app è self-hosted: i dati della tua congregazione risiedono nel tuo progetto gratuito Google Firebase, a cui nessun altro può accedere. La configurazione richiede circa 15 minuti e non serve saper programmare: basta un account Google. Segui i passaggi qui sotto su questo telefono o su un computer.';

  @override
  String get setupGuideOpenConsole => 'Apri la console Firebase';

  @override
  String get setupGuideStep1Title => 'Crea un progetto Firebase';

  @override
  String get setupGuideStep1Body1 =>
      'Apri console.firebase.google.com, accedi con il tuo account Google e tocca «Get started by setting up a Firebase project».';

  @override
  String get setupGuideStep1Body2 =>
      'Dai un nome al progetto, ad esempio «congregazione-miacitta», accetta i termini e continua. Se viene proposto Google Analytics, disattivalo: non è necessario. Rimani sul piano gratuito Spark; l\'app è progettata per non richiedere mai la fatturazione.';

  @override
  String get setupGuideStep2Title => 'Attiva l\'accesso tramite e-mail';

  @override
  String get setupGuideStep2Body1 =>
      'Nel menu a sinistra scegli Security → Authentication.';

  @override
  String get setupGuideStep2Body2 => 'Tocca «Get started».';

  @override
  String get setupGuideStep2Body3 =>
      'Nella scheda «Sign-in method» scegli Email/Password.';

  @override
  String get setupGuideStep2Body4 =>
      'Attiva il primo interruttore (lascia «Email link» disattivato) e tocca Save.';

  @override
  String get setupGuideStep3Title => 'Crea il database Firestore';

  @override
  String get setupGuideStep3Body1 =>
      'Nel menu a sinistra scegli Databases & Storage → Firestore.';

  @override
  String get setupGuideStep3Body2 => 'Tocca «Create database».';

  @override
  String get setupGuideStep3Body3 => 'Scegli l\'edizione Standard.';

  @override
  String get setupGuideStep3Body4 =>
      'Scegli una posizione vicina a te (ad esempio europe-west3 per l\'Europa centrale). Non potrà essere cambiata in seguito.';

  @override
  String get setupGuideStep3Body5 => 'Inizia in modalità di produzione…';

  @override
  String get setupGuideStep3Body6 => '…e tocca Create.';

  @override
  String get setupGuideStep4Title => 'Installa le regole di sicurezza';

  @override
  String get setupGuideStep4Body1 =>
      'Le regole stabiliscono chi può leggere e scrivere quali dati (ad esempio, solo i proclamatori verificati possono vedere i programmi). Nel database Firestore apri la scheda Rules e tocca «Edit rules».';

  @override
  String get setupGuideStep4Body2 =>
      'Elimina tutto ciò che c\'è nell\'editor e incolla le regole copiate.';

  @override
  String get setupGuideStep4Body3 => 'Tocca Publish.';

  @override
  String get setupGuideStep4Note =>
      'Ripeti questo passaggio ogni volta che una nuova versione dell\'app introduce regole aggiornate.';

  @override
  String get setupGuideStep5Title => 'Ottieni la configurazione dell\'app';

  @override
  String get setupGuideStep5Body1 =>
      'Tocca l\'icona a forma di ingranaggio accanto a «Project Overview» (in alto a sinistra) e scegli Project settings.';

  @override
  String get setupGuideStep5Body2 =>
      'Nella scheda General scorri fino a «Your apps» e tocca l\'icona web </>.';

  @override
  String get setupGuideStep5Body3 =>
      'Inserisci un soprannome, ad esempio «congregation-app», lascia l\'hosting disattivato e tocca «Register app».';

  @override
  String get setupGuideStep5Body4 =>
      'Comparirà un blocco di codice con «const firebaseConfig = …». Seleziona e copia solo la configurazione tra le parentesi graffe, incluse le parentesi.';

  @override
  String get setupGuideStep5Note =>
      'Questa configurazione non è segreta: identifica soltanto il tuo progetto. I dati sono protetti dalle regole di sicurezza del passaggio 4.';

  @override
  String get setupGuideRulesTitle => 'Regole di sicurezza (firestore.rules)';

  @override
  String get setupGuideRulesCopy => 'Copia le regole';

  @override
  String get setupGuideRulesCopied => 'Regole copiate negli appunti.';

  @override
  String get setupGuideRulesView => 'Mostra il testo delle regole';

  @override
  String get setupGuideRulesLoadError =>
      'Impossibile caricare il testo delle regole.';

  @override
  String get setupGuideFinish =>
      'Fatto! Torna indietro, incolla la configurazione copiata e tocca Connetti. Poi scegli «Configura una nuova congregazione» e registrati come primo amministratore.';

  @override
  String get setupGuideBackToConnect => 'Torna alla schermata di connessione';

  @override
  String get languageSystem => 'Lingua del sistema';

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
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String themeTooltip(String mode) {
    return 'Tema: $mode';
  }

  @override
  String get profileCompleteTitle => 'Completa il tuo profilo';

  @override
  String get profileCompleteBody =>
      'Il tuo account esiste, ma manca il profilo. Inserisci il tuo nome per completare la registrazione.';

  @override
  String get authSignIn => 'Accedi';

  @override
  String get authSignOut => 'Esci';

  @override
  String get authRegister => 'Crea account';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordConfirm => 'Conferma password';

  @override
  String get authPasswordsDontMatch => 'Le password non coincidono';

  @override
  String get authForgotPassword => 'Password dimenticata?';

  @override
  String get authResetSent =>
      'È stata inviata un\'e-mail per reimpostare la password.';

  @override
  String get authEnterEmailForReset =>
      'Inserisci prima il tuo indirizzo e-mail, poi tocca «Password dimenticata?» per ricevere un link di reimpostazione.';

  @override
  String get authNoAccountYet => 'Non hai ancora un account? Creane uno';

  @override
  String get authHaveAccount => 'Hai già un account? Accedi';

  @override
  String get authErrorInvalidCredentials => 'E-mail o password errate.';

  @override
  String get authErrorEmailInUse => 'Esiste già un account con questa e-mail.';

  @override
  String get authErrorWeakPassword =>
      'La password è troppo debole (almeno 6 caratteri).';

  @override
  String authErrorGeneric(String message) {
    return 'Accesso non riuscito: $message';
  }

  @override
  String get authFirstName => 'Nome';

  @override
  String get authLastName => 'Cognome';

  @override
  String get authCongregationName => 'Nome della congregazione';

  @override
  String get awaitingTitle => 'In attesa di verifica';

  @override
  String get awaitingBody =>
      'Il tuo account è stato creato. Ora un amministratore della congregazione deve verificarlo prima che tu possa vedere le informazioni della congregazione.';

  @override
  String get deleteAccountAction => 'Elimina il mio account';

  @override
  String get deleteAccountWarning =>
      'Questa operazione elimina definitivamente il tuo account e il tuo profilo personale (nome, recapiti e accesso). Non può essere annullata. I rapporti che hai inviato restano archiviati presso la congregazione.';

  @override
  String get deleteAccountPasswordLabel =>
      'Inserisci la password per confermare';

  @override
  String get deleteAccountConfirm => 'Elimina account';

  @override
  String get deleteAccountSoleAdminTitle => 'Sei l\'unico amministratore';

  @override
  String get deleteAccountSoleAdminBody =>
      'Sei l\'unico amministratore completo della congregazione. Concedi prima i diritti di amministratore completo a un altro membro; altrimenti l\'eliminazione del tuo account lascerebbe la congregazione senza amministratore e senza modo di ripristinare l\'accesso.';

  @override
  String get changePasswordAction => 'Cambia password';

  @override
  String get changePasswordCurrentLabel => 'Password attuale';

  @override
  String get changePasswordNewLabel => 'Nuova password';

  @override
  String get changePasswordConfirmLabel => 'Conferma nuova password';

  @override
  String get changePasswordConfirm => 'Aggiorna password';

  @override
  String get changePasswordSuccess => 'Password aggiornata.';

  @override
  String get navInfoBoard => 'Bacheca';

  @override
  String get navEvents => 'Eventi';

  @override
  String get navLmm => 'Adunanza infrasettimanale';

  @override
  String get navWeekend => 'Adunanza del fine settimana';

  @override
  String get navPublicWitnessing => 'Testimonianza pubblica';

  @override
  String get navFieldServiceMeetings => 'Adunanze per il servizio di campo';

  @override
  String get navTerritories => 'Territori';

  @override
  String get navMinistryGroups => 'Gruppi di servizio';

  @override
  String get navReport => 'Rapporto del servizio';

  @override
  String get navAttendance => 'Presenze';

  @override
  String get navProfile => 'Il mio profilo';

  @override
  String get navAdmin => 'Amministrazione';

  @override
  String get navPublishersAdmin => 'Proclamatori';

  @override
  String get navReportsAdmin => 'Riepilogo rapporti';

  @override
  String get navS1 => 'Rapporto S-1';

  @override
  String get navTalks => 'Titoli dei discorsi pubblici';

  @override
  String get navSettings => 'Impostazioni della congregazione';

  @override
  String get navStatistics => 'Statistiche';

  @override
  String get navHelp => 'Aiuto';

  @override
  String get helpPublisherSection => 'Consigli per i proclamatori';

  @override
  String get helpAdminSection => 'Per gli amministratori';

  @override
  String get helpCalendarTitle => 'Aggiungi al calendario';

  @override
  String get helpCalendarBody =>
      'Nell\'app per cellulare, gli eventi e le tue assegnazioni mostrano un\'icona di calendario. Toccala per aggiungere l\'elemento al calendario del tuo dispositivo.';

  @override
  String get helpRemindersTitle => 'Promemoria delle assegnazioni';

  @override
  String get helpRemindersBody =>
      'Nella schermata Eventi, tocca l\'icona della campanella accanto a «Le mie prossime assegnazioni» per ricevere un avviso prima di ogni assegnazione: scegli tu con quanto anticipo. (Solo app per cellulare.)';

  @override
  String get helpHighlightTitle => 'Trovati a colpo d\'occhio';

  @override
  String get helpHighlightBody =>
      'Nei programmi delle adunanze il tuo nome è evidenziato, così individui rapidamente le tue assegnazioni.';

  @override
  String get helpTerritoryMapTitle => 'Apri la mappa di un territorio';

  @override
  String get helpTerritoryMapBody =>
      'Tocca l\'icona della mappa accanto a un territorio per aprirne la mappa. Un\'icona grigia indica che per quel territorio non è ancora stato aggiunto un link alla mappa.';

  @override
  String get helpAdminToggleTitle => 'Vedi l\'app come proclamatore';

  @override
  String get helpAdminToggleBody =>
      'L\'icona a forma di matita nella barra in alto nasconde temporaneamente tutti gli strumenti di amministrazione, così vedi l\'app esattamente come la vedono i proclamatori. Toccala di nuovo per riportarli.';

  @override
  String get helpPdfExportTitle => 'Stampa o condividi i programmi';

  @override
  String get helpPdfExportBody =>
      'Nelle schermate Adunanza infrasettimanale e Adunanza del fine settimana, gli editor dei programmi hanno un\'icona PDF nella barra in alto che esporta il programma del mese per stamparlo o condividerlo.';

  @override
  String get helpGoogleMyMapsTitle => 'Mappe dei territori con Google My Maps';

  @override
  String get helpGoogleMyMapsBody =>
      'Crea le mappe dei tuoi territori in Google My Maps e incolla il link di condivisione di ogni territorio nel suo campo del link alla mappa. Sono disponibili istruzioni passo passo su GitHub.';

  @override
  String get helpOpenGuide => 'Apri la guida';

  @override
  String get helpDataDelayTitle =>
      'Le modifiche potrebbero richiedere un momento per apparire';

  @override
  String get helpDataDelayBody =>
      'Le modifiche fatte nell\'app — ad esempio quelle in Proclamatori — possono richiedere fino a un minuto per diventare visibili. (A volte, per esempio, un\'importazione S-21 non mostra subito le ore di servizio dell\'anno di servizio in corso.)';

  @override
  String get helpPwApplyTitle => 'Offriti per la testimonianza pubblica';

  @override
  String get helpPwApplyBody =>
      'Apri Testimonianza pubblica, trova un turno e tocca l\'icona della mano per offrirti; toccala di nuovo per ritirarti. Se non vedi l\'icona, chiedi a un amministratore di attivare l\'abilitazione «Testimonianza pubblica» sul tuo profilo.';

  @override
  String get helpPwAssignTitle =>
      'Assegna i proclamatori alla testimonianza pubblica';

  @override
  String get helpPwAssignBody =>
      'Attiva l\'abilitazione «Testimonianza pubblica» di ogni volontario in Proclamatori → apri un proclamatore → Abilitazioni. Poi, in Testimonianza pubblica, apri un turno e tocca «Assegnati»: i proclamatori che si sono offerti sono fissati in cima all\'elenco con l\'etichetta «Offerto». Usa i turni ricorrenti per carrelli o espositori settimanali.';

  @override
  String get helpS21Title => 'Importa registrazioni S-21';

  @override
  String get helpS21Body =>
      'Puoi importare la Registrazione del proclamatore di congregazione (S-21) di un proclamatore da un PDF. Apri Proclamatori → un proclamatore → S-21 e scegli il file. Viene letto solo il livello di testo del PDF, quindi i moduli scansionati o appiattiti potrebbero non essere importati.';

  @override
  String get helpS99Title => 'Importa i titoli dei discorsi pubblici (S-99)';

  @override
  String get helpS99Body =>
      'In Titoli dei discorsi pubblici, scegli «Aggiorna i titoli da PDF» e seleziona un modulo S-99 ufficiale in PDF. Le prossime adunanze del fine settimana che fanno riferimento a quei numeri di discorso si aggiornano automaticamente.';

  @override
  String get adminToggleHide => 'Nascondi opzioni di amministrazione';

  @override
  String get adminToggleShow => 'Mostra opzioni di amministrazione';

  @override
  String get profilePhone => 'Numero di telefono';

  @override
  String get profileAddress => 'Indirizzo';

  @override
  String get profileBirthDate => 'Data di nascita';

  @override
  String get profileBaptismDate => 'Data del battesimo';

  @override
  String get profileGender => 'Sesso';

  @override
  String get genderUnknown => '—';

  @override
  String get genderMale => 'Maschio';

  @override
  String get genderFemale => 'Femmina';

  @override
  String get profileHope => 'Speranza';

  @override
  String get hopeOtherSheep => 'Altre pecore';

  @override
  String get hopeAnointed => 'Unto';

  @override
  String get profileStatus => 'Condizione di servizio';

  @override
  String get statusNone => '-';

  @override
  String get statusPublisher => 'Proclamatore';

  @override
  String get statusAuxPioneer => 'Pioniere ausiliario';

  @override
  String get statusRegPioneer => 'Pioniere regolare';

  @override
  String get statusSpecialPioneer => 'Pioniere speciale';

  @override
  String get statusFieldMissionary => 'Missionario sul campo';

  @override
  String get profileAppointment => 'Nomina';

  @override
  String get appointmentMinisterialServant => 'Servitore di ministero';

  @override
  String get appointmentElder => 'Anziano';

  @override
  String get profileEmergency => 'Nota di emergenza';

  @override
  String get profileEmergencyHint => 'Chi contattare in caso di emergenza';

  @override
  String get profileSaved => 'Salvato';

  @override
  String get profileRecord => 'Registrazione del proclamatore';

  @override
  String serviceYear(int year) {
    return 'Anno di servizio $year';
  }

  @override
  String get recordTotalHours => 'Totale ore';

  @override
  String get recordAverageHours => 'Media mensile';

  @override
  String get reportMonth => 'Mese';

  @override
  String get reportParticipated => 'Ha partecipato al ministero';

  @override
  String get reportStudies => 'Studi biblici';

  @override
  String get reportHours => 'Ore';

  @override
  String get reportCredit => 'Ore di credito';

  @override
  String get reportComments => 'Commenti';

  @override
  String get s21Export => 'Esporta S-21 (PDF)';

  @override
  String get schedulePdfExport => 'Riepilogo mensile (PDF)';

  @override
  String get lmmScheduleTitle => 'Programma dell’adunanza infrasettimanale';

  @override
  String get s21Title => 'REGISTRAZIONE DEL PROCLAMATORE DI CONGREGAZIONE';

  @override
  String get s21Name => 'Nome e cognome:';

  @override
  String get s21DateOfBirth => 'Data di nascita:';

  @override
  String get s21DateOfBaptism => 'Data del battesimo:';

  @override
  String get s21HoursHeader => 'Ore (Se pioniere o missionario sul campo)';

  @override
  String get s21Remarks => 'Osservazioni';

  @override
  String get s21Total => 'Totale';

  @override
  String get s21FormCode => 'S-21-I 11/23';

  @override
  String s21Credit(int hours) {
    return 'Credito: $hours';
  }

  @override
  String get s21Import => 'Importa S-21 (PDF)';

  @override
  String get s21ImportNew => 'Importa proclamatore da S-21';

  @override
  String get s21ImportTitle => 'Importa S-21';

  @override
  String get s21ImportPickFile => 'Scegli file PDF';

  @override
  String get s21ImportHint =>
      'Scegli una scheda di registrazione del proclamatore S-21 (PDF). I valori della scheda sostituiscono i campi del profilo del proclamatore e i rapporti mensili.';

  @override
  String get s21ImportNoData => 'Nessun dato S-21 trovato in questo file.';

  @override
  String s21ImportMonths(int count) {
    return '$count rapporti mensili trovati';
  }

  @override
  String s21ImportNameKept(String name) {
    return 'Il nome nell\'app viene mantenuto: $name';
  }

  @override
  String s21ImportCardName(String name) {
    return 'Nome sulla scheda: $name';
  }

  @override
  String s21ImportDuplicateName(String name) {
    return 'Esiste già un proclamatore di nome «$name».';
  }

  @override
  String get s21ImportUseExisting => 'Importa nella registrazione esistente';

  @override
  String get s21ImportReplaceTitle => 'Sostituire le registrazioni esistenti?';

  @override
  String get s21ImportReplaceBody =>
      'I campi del profilo del proclamatore e i rapporti mensili degli anni di servizio importati verranno sostituiti con i valori di questo S-21. Questa azione non può essere annullata.';

  @override
  String get s21ImportSave => 'Importa';

  @override
  String get s21ImportDone => 'S-21 importato.';

  @override
  String get s21ImportAssignYear => 'Anno di servizio di questa tabella';

  @override
  String get pubAdminInvite => 'Invita';

  @override
  String get pubAdminInviteTitle => 'Invita nella congregazione';

  @override
  String get pubAdminInviteBody =>
      'Il nuovo membro scansiona questo codice QR nell\'app, si registra e poi compare qui sotto come non verificato. Verificalo per concedere l\'accesso.';

  @override
  String get pubAdminAddRecord => 'Aggiungi registrazione del proclamatore';

  @override
  String get pubAdminAddRecordHint =>
      'Una registrazione per un membro che non userà l\'app; i rapporti possono essere inseriti dagli amministratori.';

  @override
  String get pubAdminVerified => 'Verificato';

  @override
  String get pubAdminUnverifiedBadge => 'In attesa di verifica';

  @override
  String get pubAdminNoAccountBadge => 'Nessun account app';

  @override
  String get pubAdminTabProfile => 'Profilo';

  @override
  String get pubAdminTabRoles => 'Diritti';

  @override
  String get pubAdminTabAssign => 'Assegna';

  @override
  String get pubAdminTabRecord => 'Registrazione';

  @override
  String get pubAdminDeleteConfirm =>
      'Eliminare questo proclamatore e i suoi dati privati? I suoi rapporti restano archiviati.';

  @override
  String get pubAdminDeleteMovedHint =>
      'Se ha un account app, l\'eliminazione non rimuove il suo accesso e potrebbe accedere di nuovo. Per archiviare chi si è trasferito, usa invece «Segna come trasferito».';

  @override
  String get pubAdminMarkMoved => 'Segna come trasferito';

  @override
  String get pubAdminRestoreMoved => 'Ripristina dai trasferiti';

  @override
  String get pubAdminMovedBadge => 'Trasferito';

  @override
  String get pubAdminShowMoved => 'Mostra i trasferiti';

  @override
  String get pubFilterPioneers => 'Pionieri';

  @override
  String get pubFilterHasRights => 'Con diritti';

  @override
  String get pubFilterAnyGroup => 'Qualsiasi gruppo';

  @override
  String get pubFilterClear => 'Cancella';

  @override
  String get pubAdminMoveConfirmTitle => 'Segnare come trasferito?';

  @override
  String get pubAdminMoveConfirmBody =>
      'La registrazione e lo storico dei rapporti vengono mantenuti, ma il proclamatore viene archiviato: il suo accesso è revocato e non compare più nei programmi né negli elenchi dei rapporti. Puoi ripristinarlo in seguito.';

  @override
  String get pubAdminSelfVerifiedWarningTitle =>
      'Disattivare il tuo stato di Verificato?';

  @override
  String get pubAdminSelfVerifiedWarningBody =>
      'Stai rimuovendo lo stato Verificato dal tuo account. Perderai immediatamente l\'accesso ai dati della congregazione e solo un altro amministratore completo potrà ripristinarlo. Vuoi davvero continuare?';

  @override
  String get pubAdminSelfFullAdminWarningTitle =>
      'Rimuovere i tuoi diritti di amministratore completo?';

  @override
  String get pubAdminSelfFullAdminWarningBody =>
      'Stai rimuovendo il ruolo di amministratore completo dal tuo account. Se sei l\'unico amministratore, nessuno — nemmeno tu — potrà annullare questa operazione. Vuoi davvero continuare?';

  @override
  String get pubAdminSelfWarningConfirm => 'Rimuovi il mio accesso';

  @override
  String get pubConnectBanner =>
      'Questo account è in attesa di verifica. Se un amministratore ha già creato una registrazione del proclamatore per questa persona, collegale: lo storico della registrazione passa a questo account e la registrazione duplicata scompare.';

  @override
  String get pubConnectAction => 'Collega a una registrazione esistente';

  @override
  String get pubConnectNeedsFullAdmin =>
      'Solo un amministratore completo può collegare le registrazioni (la migrazione tocca i dati di ogni sezione).';

  @override
  String get pubConnectPickTitle => 'Collega a una registrazione esistente';

  @override
  String pubConnectPickHint(String name) {
    return 'Seleziona la registrazione che appartiene a $name.';
  }

  @override
  String get pubConnectNoRecords =>
      'Non c\'è nessuna registrazione del proclamatore senza account app da collegare.';

  @override
  String get pubConnectConfirmTitle => 'Collegare e unire?';

  @override
  String pubConnectConfirmBody(String record, String account) {
    return 'L\'intero storico di «$record» — rapporti, territori e assegnazioni dei programmi — verrà spostato sull\'account di «$account». L\'account diventa verificato e la registrazione duplicata viene eliminata definitivamente. Questa azione non può essere annullata.';
  }

  @override
  String get pubConnectProgressTitle => 'Collegamento della registrazione…';

  @override
  String get pubConnectProgressBody =>
      'Non chiudere l\'app mentre lo storico viene spostato.';

  @override
  String pubConnectFailed(String section) {
    return 'Il collegamento non è riuscito in: $section. I passaggi completati vengono mantenuti; riprovare è sicuro e continua da dove si era interrotto.';
  }

  @override
  String get pubConnectSuccess =>
      'Registrazione collegata: il suo storico ora appartiene a questo account.';

  @override
  String get roleFullAdmin => 'Amministratore completo';

  @override
  String get roleRecordAttendance => 'Registra le presenze';

  @override
  String get weekNoSchedule => 'Ancora nessun programma per questa settimana.';

  @override
  String get weekCreateEmpty => 'Crea settimana vuota';

  @override
  String get weekImportEpub => 'Importa da .epub';

  @override
  String get weekCheckCdn => 'Controlla online';

  @override
  String get weekDelete => 'Elimina questa settimana';

  @override
  String get lmmSongs => 'Cantici';

  @override
  String get sectionOpening => 'Apertura';

  @override
  String get sectionTreasures => 'TESORI DELLA PAROLA DI DIO';

  @override
  String get sectionMinistry => 'EFFICACI NEL MINISTERO';

  @override
  String get sectionLiving => 'VITA CRISTIANA';

  @override
  String get sectionClosing => 'Conclusione';

  @override
  String get partChairman => 'Presidente';

  @override
  String get partOpeningPrayer => 'Preghiera di apertura';

  @override
  String get partClosingPrayer => 'Preghiera di conclusione';

  @override
  String get partGems => 'Gemme spirituali';

  @override
  String get partBibleReading => 'Lettura biblica';

  @override
  String get partCbs => 'Studio biblico di congregazione';

  @override
  String get partCbsReader => 'Lettore';

  @override
  String get partAssistant => 'Assistente';

  @override
  String partMinutes(int min) {
    return '$min min';
  }

  @override
  String get lmmClassMain => 'Sala principale';

  @override
  String lmmClassN(int index) {
    return 'Classe $index';
  }

  @override
  String get partEdit => 'Modifica parte';

  @override
  String get partTitle => 'Titolo';

  @override
  String get partDescription => 'Descrizione';

  @override
  String get partDuration => 'Durata (min)';

  @override
  String get partAdd => 'Aggiungi parte';

  @override
  String get partDeleteConfirm => 'Eliminare questa parte?';

  @override
  String get supportAttendants => 'Uscieri';

  @override
  String get supportMicrophones => 'Microfoni';

  @override
  String get supportAudioVideo => 'Audio e video';

  @override
  String get customAssignmentAdd => 'Aggiungi assegnazione personalizzata';

  @override
  String get customLabel => 'Etichetta';

  @override
  String get customAssignmentPermanent => 'Permanente (ogni settimana)';

  @override
  String get customAssignmentRemovePermanentTitle =>
      'Rimuovi assegnazione permanente';

  @override
  String customAssignmentRemovePermanentBody(String label) {
    return 'Rimuovere «$label» da ogni settimana?';
  }

  @override
  String get pickerQualified => 'Abilitati';

  @override
  String get pickerAll => 'Tutti';

  @override
  String get pickerFreeText => 'Testo';

  @override
  String pickerLastAssigned(String date) {
    return 'Ultima volta: $date';
  }

  @override
  String get pickerNever => 'Mai assegnato';

  @override
  String get pickerApplied => 'Offerto';

  @override
  String get importTitle => 'Importa la Guida per l\'adunanza';

  @override
  String get importNoWeeks =>
      'Nessuna settimana utilizzabile trovata in questo file.';

  @override
  String get importWeekExists =>
      'Esiste già: il programma verrà aggiornato, le assegnazioni mantenute';

  @override
  String importSave(int count) {
    return 'Importa $count settimane';
  }

  @override
  String get importDone => 'Importato.';

  @override
  String get importCdnNothing =>
      'Nessun numero della Guida per l\'adunanza è ancora disponibile online.';

  @override
  String get weekendTalkTitle => 'Discorso pubblico';

  @override
  String get weekendSpeaker => 'Oratore';

  @override
  String get weekendChairmanLabel => 'Presidente';

  @override
  String get weekendWtReader => 'Lettore della Torre di Guardia';

  @override
  String get customFieldAdd => 'Aggiungi campo del programma';

  @override
  String get pickerFromCatalog => 'Dall\'elenco';

  @override
  String get talksUpdateFromPdf => 'Aggiorna i titoli da PDF';

  @override
  String get talksPickPdf => 'Scegli PDF S-99';

  @override
  String get talksParseError =>
      'Impossibile leggere i titoli dei discorsi da questo file. Usa un modulo S-99 ufficiale in PDF.';

  @override
  String talksImportSummary(int total, int added, int changed, int removed) {
    return '$total discorsi trovati: $added nuovi, $changed modificati, $removed rimossi';
  }

  @override
  String get talksImportSave => 'Salva i titoli';

  @override
  String talksImportDone(int count) {
    return 'Titoli salvati. Aggiornate $count adunanze imminenti.';
  }

  @override
  String talksLastDelivered(String date) {
    return 'Pronunciato l\'ultima volta il $date';
  }

  @override
  String get talksNeverDelivered => 'Non ancora pronunciato';

  @override
  String get talksScheduled => 'in programma';

  @override
  String get talksNew => 'Nuovo';

  @override
  String get talksChanged => 'Modificato';

  @override
  String get talksRemoved => 'Rimosso';

  @override
  String get talksSearchHint => 'Cerca discorsi…';

  @override
  String get talksEmpty =>
      'Ancora nessun titolo di discorso. Importali da un PDF S-99.';

  @override
  String get talksOpenCatalog => 'Gestisci i titoli dei discorsi';

  @override
  String get talksEditTitle => 'Modifica titolo';

  @override
  String get songLabel => 'Cantico';

  @override
  String get songsSearchHint => 'Cerca cantici…';

  @override
  String get songsEmpty =>
      'Ancora nessun elenco di cantici. Aggiornalo dal sito ufficiale.';

  @override
  String get songsUpdateFromWeb =>
      'Aggiorna l\'elenco dei cantici dal sito ufficiale';

  @override
  String songsUpdateDone(int count) {
    return 'Elenco dei cantici aggiornato: $count cantici.';
  }

  @override
  String get songsCdnNothing =>
      'L\'elenco dei cantici non è ancora disponibile online.';

  @override
  String get songsStatusEmpty => 'Ancora nessun elenco di cantici importato.';

  @override
  String songsStatusLoaded(int count, String date) {
    return '$count cantici · aggiornato $date';
  }

  @override
  String get settingsSongsSection => 'Elenco dei cantici';

  @override
  String get settingsSongsDescription =>
      'Scarica i titoli dei cantici delle adunanze da jw.org così da poterli scegliere nei programmi del fine settimana e infrasettimanali.';

  @override
  String get pwNoSlots => 'Nessuna testimonianza pubblica questa settimana.';

  @override
  String get pwAddSlot => 'Aggiungi turno';

  @override
  String get pwEditSlot => 'Modifica turno';

  @override
  String get pwLocation => 'Luogo';

  @override
  String get pwTimeFrom => 'Dalle';

  @override
  String get pwTimeTo => 'Alle';

  @override
  String get pwRecurringRules => 'Turni ricorrenti';

  @override
  String get pwRecurringAdd => 'Aggiungi turno ricorrente';

  @override
  String get pwWeekday => 'Giorno della settimana';

  @override
  String get pwValidFrom => 'Valido dal';

  @override
  String get pwValidUntil => 'Valido fino al (facoltativo)';

  @override
  String get pwAssignees => 'Assegnati';

  @override
  String get pwDate => 'Data';

  @override
  String get pwApply => 'Offriti per questo turno';

  @override
  String get pwWithdraw => 'Ritira la tua offerta';

  @override
  String pwApplicants(int count) {
    return '$count si sono offerti';
  }

  @override
  String get fsmNoMeetings =>
      'Nessuna adunanza per il servizio di campo questa settimana.';

  @override
  String get fsmAddMeeting => 'Aggiungi adunanza';

  @override
  String get fsmEditMeeting => 'Modifica adunanza';

  @override
  String get fsmDate => 'Data';

  @override
  String get fsmTime => 'Ora';

  @override
  String get fsmLocation => 'Luogo';

  @override
  String get fsmNote => 'Nota';

  @override
  String get fsmConductor => 'Conduttore';

  @override
  String get fsmRecurringRules => 'Adunanze ricorrenti';

  @override
  String get fsmRecurringAdd => 'Aggiungi adunanza ricorrente';

  @override
  String get fsmWeekday => 'Giorno della settimana';

  @override
  String get fsmValidFrom => 'Valido dal';

  @override
  String get fsmValidUntil => 'Valido fino al (facoltativo)';

  @override
  String get fsmRecurringDeleteConfirm =>
      'Eliminare questa adunanza ricorrente? Verranno rimosse anche le sue adunanze future. Questa azione non può essere annullata.';

  @override
  String get fsmRemoveAllFutureAction => 'Rimuovi tutte le adunanze future';

  @override
  String get fsmRemoveAllFutureWarning =>
      'Rimuovere tutte le adunanze future elimina ogni adunanza imminente, singola o ricorrente, e non può essere annullato.';

  @override
  String get fsmRemoveAllFutureTitle => 'Rimuovere tutte le adunanze future?';

  @override
  String get fsmRemoveAllFutureBody =>
      'Questa operazione elimina ogni adunanza per il servizio imminente, singola o ricorrente, e rimuove tutte le regole delle adunanze ricorrenti così che nessuna venga rigenerata. Le adunanze passate vengono mantenute. Questa azione non può essere annullata.';

  @override
  String get fsmRemoveAllFutureConfirm => 'Rimuovi tutte';

  @override
  String get eventsUpcoming => 'Prossimi eventi';

  @override
  String get eventsNone => 'Nessun evento imminente.';

  @override
  String get eventAdd => 'Aggiungi evento';

  @override
  String get eventEdit => 'Modifica evento';

  @override
  String get eventTitle => 'Titolo';

  @override
  String get eventType => 'Tipo';

  @override
  String get eventTypeConvention => 'Assemblea regionale';

  @override
  String get eventTypeAssembly => 'Assemblea di circoscrizione';

  @override
  String get eventTypeMemorial => 'Commemorazione';

  @override
  String get eventTypeCoVisit => 'Visita del sorvegliante di circoscrizione';

  @override
  String get eventTypeOther => 'Altro';

  @override
  String get eventDateFrom => 'Dal';

  @override
  String get eventDateTo => 'Al (facoltativo)';

  @override
  String get eventLocation => 'Luogo';

  @override
  String get eventNotes => 'Note';

  @override
  String get eventAddToCalendar => 'Aggiungi al calendario';

  @override
  String get myAssignments => 'Le mie prossime assegnazioni';

  @override
  String get myAssignmentsNone => 'Nessuna assegnazione imminente.';

  @override
  String get remindersTitle => 'Promemoria delle assegnazioni';

  @override
  String get remindersDescription =>
      'Ricevi un avviso su questo dispositivo prima di ognuna delle tue prossime assegnazioni. Le modifiche fatte mentre l\'app è chiusa vengono recepite alla successiva apertura.';

  @override
  String get remindersEnable => 'Attiva i promemoria';

  @override
  String get remindersAdd => 'Aggiungi promemoria';

  @override
  String get reminderUnitMinutes => 'minuti prima';

  @override
  String get reminderUnitHours => 'ore prima';

  @override
  String get reminderUnitDays => 'giorni prima';

  @override
  String get remindersPermissionDenied =>
      'Le notifiche non sono consentite per questa app. Attivale nelle impostazioni di sistema per usare i promemoria.';

  @override
  String get remindersChannelName => 'Promemoria delle assegnazioni';

  @override
  String get remindersChannelDescription =>
      'Avvisi prima delle tue assegnazioni di congregazione';

  @override
  String get roleAssistant => 'Assistente';

  @override
  String get rolePw => 'Testimonianza pubblica';

  @override
  String get roleFsm => 'Adunanza per il servizio di campo';

  @override
  String get reportSubmit => 'Invia rapporto';

  @override
  String reportSubmittedAt(String date) {
    return 'Inviato il $date';
  }

  @override
  String get reportSaved => 'Rapporto salvato.';

  @override
  String get reportMissing => 'Non inviato';

  @override
  String reportEnterFor(String name) {
    return 'Inserisci rapporto — $name';
  }

  @override
  String reportSummaryReported(int reported, int total) {
    return 'Hanno riferito: $reported / $total';
  }

  @override
  String get attAdd => 'Registra le presenze';

  @override
  String get attInPerson => 'Di persona';

  @override
  String get attOnline => 'Online';

  @override
  String get attTotal => 'Totale';

  @override
  String get attMeetingLmm => 'Adunanza infrasettimanale';

  @override
  String get attMeetingWeekend => 'Adunanza del fine settimana';

  @override
  String get attOverview => 'Medie mensili';

  @override
  String get attHistory => 'Adunanze passate';

  @override
  String get attNotFilled => 'Non registrato';

  @override
  String get attMismatch => 'I numeri non tornano.';

  @override
  String attRecordedOf(int filled, int expected) {
    return '$filled/$expected registrati';
  }

  @override
  String get attSaved => 'Presenze salvate.';

  @override
  String get statMembershipTitle => 'Proclamatori';

  @override
  String get statTotalMembers => 'Tutti i proclamatori';

  @override
  String get statPioneers => 'Pionieri';

  @override
  String get statAgeTitle => 'Distribuzione per età';

  @override
  String get statAgeAverage => 'Età media';

  @override
  String statAgeKnownDetail(int known, int total) {
    return 'Basato su $known date di nascita note su $total';
  }

  @override
  String get statAgeUnder18 => 'Sotto i 18 anni';

  @override
  String get statAgeUnknown => 'Sconosciuta';

  @override
  String get statAttendanceTitle => 'Presenze alle adunanze';

  @override
  String get statAvg3Months => 'Media 3 mesi';

  @override
  String get statAvg12Months => 'Media 12 mesi';

  @override
  String get statFieldServiceTitle => 'Servizio di campo';

  @override
  String statServiceYear(String year) {
    return 'Anno di servizio $year';
  }

  @override
  String get statReportsSubmitted => 'Rapporti inviati';

  @override
  String get statParticipated => 'Hanno partecipato al ministero';

  @override
  String get statPioneerHours => 'Ore dei pionieri';

  @override
  String get statPublisherHours => 'Ore dei proclamatori';

  @override
  String get statUsageTitle => 'Utilizzo dell\'app';

  @override
  String get statWithAccount => 'Con account app';

  @override
  String get statSelfReported => 'Rapporti inviati in autonomia (mese scorso)';

  @override
  String get statAwaiting => 'In attesa di verifica';

  @override
  String get statFullAdmins => 'Amministratori completi';

  @override
  String get statSectionAdmins => 'Amministratori di sezione';

  @override
  String get statNoData => 'Ancora nessun dato';

  @override
  String get terrMine => 'I miei territori';

  @override
  String get terrNoMine => 'Nessun territorio assegnato a te.';

  @override
  String get terrAll => 'Tutti i territori';

  @override
  String terrAssignedOn(String date) {
    return 'Assegnato il $date';
  }

  @override
  String get terrReturn => 'Restituisci';

  @override
  String get terrReturnTitle => 'Restituisci territorio';

  @override
  String get terrReturnNotes => 'Note (facoltativo)';

  @override
  String get terrMap => 'Mappa';

  @override
  String get terrAdd => 'Aggiungi territorio';

  @override
  String get terrEdit => 'Modifica territorio';

  @override
  String get terrName => 'Nome';

  @override
  String get terrNumber => 'Numero';

  @override
  String get terrMapUrl => 'Link alla mappa (ad esempio Google My Maps)';

  @override
  String get terrNotes => 'Note';

  @override
  String get terrAssignTo => 'Assegna a…';

  @override
  String terrHolder(String name, String date) {
    return '$name — dal $date';
  }

  @override
  String get terrFree => 'Non assegnato';

  @override
  String get terrStats => 'Statistiche';

  @override
  String get terrStatsTotal => 'Totale';

  @override
  String get terrStatsAssigned => 'Attualmente assegnati';

  @override
  String get terrStatsFinished => 'Completati nel periodo';

  @override
  String get terrRemoveAssignment => 'Rimuovi assegnazione';

  @override
  String get terrImportTitle => 'Importa territori';

  @override
  String get terrImportPasteHint =>
      'Incolla righe da Excel o Google Fogli. Colonne: nome, numero, link alla mappa, note; solo il nome è obbligatorio.';

  @override
  String get terrImportPreview => 'Anteprima';

  @override
  String get terrImportPickFile => 'Scegli file CSV';

  @override
  String terrImportSummary(
    int total,
    int newCount,
    int duplicates,
    int invalid,
  ) {
    return '$total righe: $newCount nuove, $duplicates esistenti, $invalid non valide';
  }

  @override
  String get terrImportUpdateExisting =>
      'Aggiorna i territori esistenti (corrispondenza per numero) invece di ignorarli';

  @override
  String get terrImportBadgeNew => 'Nuovo';

  @override
  String get terrImportBadgeSkip => 'Ignora';

  @override
  String get terrImportBadgeUpdate => 'Aggiorna';

  @override
  String get terrImportBadgeInvalid => 'Nome mancante';

  @override
  String get terrImportBadgeDupRow => 'Riga duplicata';

  @override
  String terrImportLine(int line) {
    return 'Riga $line';
  }

  @override
  String terrImportSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importa $count territori',
      one: 'Importa 1 territorio',
    );
    return '$_temp0';
  }

  @override
  String terrImportDone(int created, int updated) {
    return 'Importati $created nuovi, aggiornati $updated.';
  }

  @override
  String get terrImportEmpty => 'Nessuna riga trovata nell\'input.';

  @override
  String get terrDeleteConfirm =>
      'Eliminare questo territorio? Questa azione non può essere annullata.';

  @override
  String get terrSortByTerritory => 'Territorio';

  @override
  String get terrSortByPublisher => 'Proclamatore';

  @override
  String get terrSortByDate => 'Data di assegnazione';

  @override
  String get terrHistoryOngoing => 'In corso';

  @override
  String get terrHistoryEmpty => 'Ancora nessuno storico delle assegnazioni.';

  @override
  String get mgEmpty => 'Ancora nessun gruppo di servizio.';

  @override
  String get mgAdd => 'Aggiungi gruppo';

  @override
  String get mgEdit => 'Modifica gruppo';

  @override
  String get mgName => 'Nome';

  @override
  String mgMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membri',
      one: '1 membro',
      zero: 'Nessun membro',
    );
    return '$_temp0';
  }

  @override
  String get mgNoMembers => 'Ancora nessun membro in questo gruppo.';

  @override
  String get mgOverseer => 'Sorvegliante di gruppo';

  @override
  String get mgAssistant => 'Assistente di gruppo';

  @override
  String get mgMakeOverseer => 'Imposta come sorvegliante di gruppo';

  @override
  String get mgMakeAssistant => 'Imposta come assistente';

  @override
  String get mgClearRole =>
      'Rimuovi la designazione di sorvegliante/assistente';

  @override
  String get mgAddMember => 'Aggiungi membro…';

  @override
  String get mgNoUnassigned => 'Sono già tutti in un gruppo.';

  @override
  String get mgRemoveMember => 'Rimuovi dal gruppo';

  @override
  String get mgDeleteConfirm =>
      'Eliminare questo gruppo? I suoi membri resteranno senza gruppo.';

  @override
  String get mgGroup => 'Gruppo di servizio';

  @override
  String get mgNoGroup => 'Nessun gruppo';

  @override
  String get infoEmpty => 'Nessuna informazione al momento.';

  @override
  String get infoAddText => 'Aggiungi testo';

  @override
  String get infoAddFile => 'Carica file (PDF/immagine)';

  @override
  String get infoAddLink => 'Aggiungi link';

  @override
  String get infoTitle => 'Titolo';

  @override
  String get infoBody => 'Testo';

  @override
  String get infoUrl => 'Link (URL)';

  @override
  String get infoShowFrom => 'Mostra dal (facoltativo)';

  @override
  String get infoShowUntil => 'Mostra fino al (facoltativo)';

  @override
  String get infoFileTooLarge =>
      'Il file è troppo grande (max 10 MB). Condividilo come link.';

  @override
  String get infoHidden =>
      'Attualmente nascosto (fuori dal suo periodo di visibilità)';

  @override
  String get infoDownloading => 'Caricamento del file…';

  @override
  String get infoEditItem => 'Modifica elemento';

  @override
  String get s1Active =>
      'Proclamatori attivi (che hanno riferito almeno una volta negli ultimi 6 mesi)';

  @override
  String get s1AvgMid => 'Media dei presenti all\'adunanza infrasettimanale';

  @override
  String get s1AvgWeekend =>
      'Media dei presenti all\'adunanza del fine settimana';

  @override
  String get s1Publishers => 'Proclamatori';

  @override
  String get s1AuxPioneers => 'Pionieri ausiliari';

  @override
  String get s1RegPioneers => 'Pionieri regolari';

  @override
  String get s1Count => 'Totale dei rapporti';

  @override
  String get s1Studies => 'Studi biblici';

  @override
  String get s1Hours => 'Ore (totale)';

  @override
  String get s1Note =>
      'I pionieri ausiliari, regolari e speciali non sono conteggiati nel gruppo dei Proclamatori; i pionieri speciali non sono inclusi in nessun gruppo.';

  @override
  String get settingsName => 'Nome della congregazione';

  @override
  String get settingsLmmMeeting => 'Adunanza infrasettimanale (giorno e ora)';

  @override
  String get settingsLmmClassCount => 'Classi dell\'adunanza infrasettimanale';

  @override
  String get settingsWeekendMeeting =>
      'Adunanza del fine settimana (giorno e ora)';

  @override
  String get settingsBackupSection => 'Backup e ripristino';

  @override
  String get settingsBackupDescription =>
      'Scarica una copia completa dei dati della tua congregazione oppure ripristinali da un file di backup. Usalo per recuperare da un\'eliminazione accidentale o da una modifica errata.';

  @override
  String get settingsExportData => 'Esporta tutti i dati';

  @override
  String get settingsImportData => 'Ripristina da backup…';

  @override
  String backupExportSuccess(int count) {
    return 'Backup scaricato ($count record).';
  }

  @override
  String get backupImportTitle => 'Ripristina da backup';

  @override
  String get backupImportPick => 'Scegli file di backup…';

  @override
  String get backupImportEmpty =>
      'Scegli un file di backup per vederne il contenuto in anteprima.';

  @override
  String get backupImportContents => 'Contenuto';

  @override
  String backupImportFrom(String name, String date) {
    return 'Backup di $name · $date';
  }

  @override
  String get backupImportWarning =>
      'Il ripristino sovrascrive i record attuali che condividono un ID con le versioni presenti in questo backup. I record aggiunti dopo il backup vengono mantenuti. Questa azione non può essere annullata.';

  @override
  String get backupImportConfirm => 'Ripristina questo backup';

  @override
  String backupImportSuccess(int count) {
    return 'Ripristinati $count record.';
  }

  @override
  String backupImportPartial(int count, String collections) {
    return 'Ripristinati $count record. Impossibile ripristinare: $collections.';
  }

  @override
  String get backupInvalidFile =>
      'Questo file non è un backup valido della congregazione.';

  @override
  String get qSupportSection => 'Supporto all\'adunanza e altro';

  @override
  String get qChairman => 'Presidente (infrasettimanale)';

  @override
  String get qPrayer => 'Preghiera';

  @override
  String get qTreasures => 'Tesori della Parola di Dio';

  @override
  String get qGems => 'Gemme spirituali';

  @override
  String get qBibleReading => 'Lettura biblica';

  @override
  String get qFieldMinistry => 'Assegnazioni dello studente (ministero)';

  @override
  String get qLiving => 'Vita cristiana';

  @override
  String get qCbsConductor =>
      'Conduttore dello Studio biblico di congregazione';

  @override
  String get qCbsReader => 'Lettore dello Studio biblico di congregazione';

  @override
  String get qPublicTalk => 'Discorso pubblico';

  @override
  String get qWeekendChairman => 'Presidente (fine settimana)';

  @override
  String get qWtReader => 'Lettore della Torre di Guardia';

  @override
  String get qAttendant => 'Usciere';

  @override
  String get qMicrophone => 'Microfoni';

  @override
  String get qAudioVideo => 'Audio e video';

  @override
  String get qPublicWitnessing => 'Testimonianza pubblica';

  @override
  String get qMinistryMeetingConductor =>
      'Conduttore dell\'adunanza per il servizio';
}
