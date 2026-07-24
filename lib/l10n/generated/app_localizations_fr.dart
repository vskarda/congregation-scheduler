// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Planificateur de l\'assemblée';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonEdit => 'Modifier';

  @override
  String get commonAdd => 'Ajouter';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonLoading => 'Chargement…';

  @override
  String get commonError => 'Une erreur s\'est produite';

  @override
  String commonErrorDetail(String message) {
    return 'Une erreur s\'est produite : $message';
  }

  @override
  String get commonFieldRequired => 'Ce champ est obligatoire';

  @override
  String get commonConfirmDeleteTitle => 'Supprimer ?';

  @override
  String get commonConfirmDeleteBody => 'Cette action est irréversible.';

  @override
  String get commonToday => 'Aujourd\'hui';

  @override
  String get commonAll => 'Tous';

  @override
  String get commonNone => 'Aucun';

  @override
  String get commonYes => 'Oui';

  @override
  String get commonNo => 'Non';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSearch => 'Rechercher';

  @override
  String get commonNotAssigned => '—';

  @override
  String get commonLanguage => 'Langue';

  @override
  String get setupTitle => 'Connecte-toi à ton assemblée';

  @override
  String get setupIntro =>
      'Cette application se connecte directement à la base de données de ton assemblée. Colle la configuration que tu as reçue de ton administrateur ou scanne le code QR de l\'invitation.';

  @override
  String get setupConfigLabel => 'Configuration Firebase (JSON)';

  @override
  String get setupConfigHint => 'apiKey, authDomain, projectId, …';

  @override
  String get setupScanQr => 'Scanner le code QR';

  @override
  String get setupPickQrImage => 'Choisir une photo du code QR';

  @override
  String get setupQrNotFoundInImage => 'Aucun code QR trouvé dans cette image.';

  @override
  String get setupConnect => 'Se connecter';

  @override
  String get setupInvalidJson =>
      'Cette configuration JSON n\'est pas valide. Elle doit contenir au moins apiKey, projectId et appId.';

  @override
  String setupConnectionFailed(String message) {
    return 'Impossible de se connecter avec cette configuration : $message';
  }

  @override
  String get setupModeTitle => 'Comment veux-tu commencer ?';

  @override
  String get setupModeJoin => 'Rejoindre mon assemblée';

  @override
  String get setupModeJoinSubtitle =>
      'Un administrateur t\'a invité. Après l\'inscription, il vérifiera ton compte.';

  @override
  String get setupModeNew => 'Configurer une nouvelle assemblée';

  @override
  String get setupModeNewSubtitle =>
      'Tu es le premier administrateur d\'un projet Firebase tout juste créé.';

  @override
  String get setupCongregationExists =>
      'Cette assemblée est déjà configurée. Choisis plutôt « Rejoindre mon assemblée ».';

  @override
  String get setupDatabaseNotReady =>
      'La base de données de l\'assemblée est encore en cours de démarrage. Attends un instant et réessaie.';

  @override
  String get setupReconfigure => 'Changer la configuration';

  @override
  String get setupRestartRequired =>
      'Configuration enregistrée. Ferme et rouvre l\'application pour l\'appliquer.';

  @override
  String get setupGuideLinkIntro =>
      'Tu n\'as pas de configuration ? Crée la base de données gratuite de ton assemblée :';

  @override
  String get setupGuideLinkButton =>
      'Comment configurer une nouvelle assemblée';

  @override
  String get setupGuideTitle => 'Configurer une nouvelle assemblée';

  @override
  String get setupGuideIntro =>
      'Cette application est auto-hébergée : les données de ton assemblée résident dans ton propre projet Google Firebase gratuit, auquel personne d\'autre ne peut accéder. La configuration prend environ 15 minutes et ne demande aucune programmation : il te faut seulement un compte Google. Suis les étapes ci-dessous sur ce téléphone ou sur un ordinateur.';

  @override
  String get setupGuideOpenConsole => 'Ouvrir la console Firebase';

  @override
  String get setupGuideStep1Title => 'Créer un projet Firebase';

  @override
  String get setupGuideStep1Body1 =>
      'Ouvre console.firebase.google.com, connecte-toi avec ton compte Google et appuie sur « Get started by setting up a Firebase project ».';

  @override
  String get setupGuideStep1Body2 =>
      'Nomme le projet, par exemple « assemblee-maville », accepte les conditions et continue. Si Google Analytics est proposé, désactive-le : ce n\'est pas nécessaire. Reste sur le forfait gratuit Spark ; l\'application est conçue pour ne jamais nécessiter de facturation.';

  @override
  String get setupGuideStep2Title => 'Activer la connexion par e-mail';

  @override
  String get setupGuideStep2Body1 =>
      'Dans le menu de gauche, choisis Security → Authentication.';

  @override
  String get setupGuideStep2Body2 => 'Appuie sur « Get started ».';

  @override
  String get setupGuideStep2Body3 =>
      'Dans l\'onglet « Sign-in method », choisis Email/Password.';

  @override
  String get setupGuideStep2Body4 =>
      'Active le premier interrupteur (laisse « Email link » désactivé) et appuie sur Save.';

  @override
  String get setupGuideStep3Title => 'Créer la base de données Firestore';

  @override
  String get setupGuideStep3Body1 =>
      'Dans le menu de gauche, choisis Databases & Storage → Firestore.';

  @override
  String get setupGuideStep3Body2 => 'Appuie sur « Create database ».';

  @override
  String get setupGuideStep3Body3 => 'Choisis l\'édition Standard.';

  @override
  String get setupGuideStep3Body4 =>
      'Choisis un emplacement proche de toi (par exemple europe-west3 pour l\'Europe centrale). Il ne pourra plus être changé ensuite.';

  @override
  String get setupGuideStep3Body5 => 'Commence en mode production…';

  @override
  String get setupGuideStep3Body6 => '…et appuie sur Create.';

  @override
  String get setupGuideStep4Title => 'Installer les règles de sécurité';

  @override
  String get setupGuideStep4Body1 =>
      'Les règles déterminent qui peut lire et écrire quelles données (par exemple, seuls les proclamateurs vérifiés peuvent voir les programmes). Dans la base de données Firestore, ouvre l\'onglet Rules et appuie sur « Edit rules ».';

  @override
  String get setupGuideStep4Body2 =>
      'Supprime tout ce qui se trouve dans l\'éditeur et colle les règles copiées.';

  @override
  String get setupGuideStep4Body3 => 'Appuie sur Publish.';

  @override
  String get setupGuideStep4Note =>
      'Répète cette étape chaque fois qu\'une nouvelle version de l\'application apporte des règles mises à jour.';

  @override
  String get setupGuideStep5Title =>
      'Obtenir la configuration de l\'application';

  @override
  String get setupGuideStep5Body1 =>
      'Appuie sur l\'icône d\'engrenage à côté de « Project Overview » (en haut à gauche) et choisis Project settings.';

  @override
  String get setupGuideStep5Body2 =>
      'Dans l\'onglet General, descends jusqu\'à « Your apps » et appuie sur l\'icône web </>.';

  @override
  String get setupGuideStep5Body3 =>
      'Saisis un surnom, par exemple « congregation-app », laisse l\'hébergement désactivé et appuie sur « Register app ».';

  @override
  String get setupGuideStep5Body4 =>
      'Un bloc de code avec « const firebaseConfig = … » apparaît. Sélectionne et copie uniquement la configuration entre les accolades, accolades comprises.';

  @override
  String get setupGuideStep5Note =>
      'Cette configuration n\'est pas secrète : elle ne fait qu\'identifier ton projet. Les données sont protégées par les règles de sécurité de l\'étape 4.';

  @override
  String get setupGuideRulesTitle => 'Règles de sécurité (firestore.rules)';

  @override
  String get setupGuideRulesCopy => 'Copier les règles';

  @override
  String get setupGuideRulesCopied => 'Règles copiées dans le presse-papiers.';

  @override
  String get setupGuideRulesView => 'Afficher le texte des règles';

  @override
  String get setupGuideRulesLoadError =>
      'Impossible de charger le texte des règles.';

  @override
  String get setupGuideFinish =>
      'Terminé ! Reviens en arrière, colle la configuration copiée et appuie sur Se connecter. Choisis ensuite « Configurer une nouvelle assemblée » et inscris-toi comme premier administrateur.';

  @override
  String get setupGuideBackToConnect => 'Retour à l\'écran de connexion';

  @override
  String get languageSystem => 'Langue du système';

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
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String themeTooltip(String mode) {
    return 'Thème : $mode';
  }

  @override
  String get profileCompleteTitle => 'Complète ton profil';

  @override
  String get profileCompleteBody =>
      'Ton compte existe, mais le profil est manquant. Saisis ton nom pour terminer l\'inscription.';

  @override
  String get authSignIn => 'Se connecter';

  @override
  String get authSignOut => 'Se déconnecter';

  @override
  String get authRegister => 'Créer un compte';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authPasswordConfirm => 'Confirmer le mot de passe';

  @override
  String get authPasswordsDontMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authResetSent =>
      'Un e-mail de réinitialisation du mot de passe a été envoyé.';

  @override
  String get authEnterEmailForReset =>
      'Saisis d\'abord ton adresse e-mail, puis appuie sur « Mot de passe oublié ? » pour recevoir un lien de réinitialisation.';

  @override
  String get authNoAccountYet => 'Pas encore de compte ? Crées-en un';

  @override
  String get authHaveAccount => 'Tu as déjà un compte ? Connecte-toi';

  @override
  String get authErrorInvalidCredentials => 'E-mail ou mot de passe incorrect.';

  @override
  String get authErrorEmailInUse => 'Un compte avec cet e-mail existe déjà.';

  @override
  String get authErrorWeakPassword =>
      'Le mot de passe est trop faible (au moins 6 caractères).';

  @override
  String authErrorGeneric(String message) {
    return 'Échec de la connexion : $message';
  }

  @override
  String get authFirstName => 'Prénom';

  @override
  String get authLastName => 'Nom';

  @override
  String get authCongregationName => 'Nom de l\'assemblée';

  @override
  String get awaitingTitle => 'En attente de vérification';

  @override
  String get awaitingBody =>
      'Ton compte a été créé. Un administrateur de l\'assemblée doit maintenant le vérifier avant que tu puisses voir les informations de l\'assemblée.';

  @override
  String get deleteAccountAction => 'Supprimer mon compte';

  @override
  String get deleteAccountWarning =>
      'Cette action supprime définitivement ton compte et ton profil personnel (nom, coordonnées et identifiants). Elle est irréversible. Les rapports que tu as envoyés restent conservés par l\'assemblée.';

  @override
  String get deleteAccountPasswordLabel =>
      'Saisis ton mot de passe pour confirmer';

  @override
  String get deleteAccountConfirm => 'Supprimer le compte';

  @override
  String get deleteAccountSoleAdminTitle => 'Tu es le seul administrateur';

  @override
  String get deleteAccountSoleAdminBody =>
      'Tu es le seul administrateur complet de l\'assemblée. Accorde d\'abord les droits d\'administrateur complet à un autre membre ; sinon, la suppression de ton compte laisserait l\'assemblée sans administrateur et sans moyen de rétablir l\'accès.';

  @override
  String get changePasswordAction => 'Changer le mot de passe';

  @override
  String get changePasswordCurrentLabel => 'Mot de passe actuel';

  @override
  String get changePasswordNewLabel => 'Nouveau mot de passe';

  @override
  String get changePasswordConfirmLabel => 'Confirmer le nouveau mot de passe';

  @override
  String get changePasswordConfirm => 'Mettre à jour le mot de passe';

  @override
  String get changePasswordSuccess => 'Mot de passe mis à jour.';

  @override
  String get navInfoBoard => 'Tableau d\'affichage';

  @override
  String get navEvents => 'Événements';

  @override
  String get navLmm => 'Réunion de semaine';

  @override
  String get navWeekend => 'Réunion de week-end';

  @override
  String get navPublicWitnessing => 'Témoignage public';

  @override
  String get navFieldServiceMeetings => 'Réunions pour la prédication';

  @override
  String get navTerritories => 'Territoires';

  @override
  String get navMinistryGroups => 'Groupes de prédication';

  @override
  String get navReport => 'Rapport d\'activité';

  @override
  String get navAttendance => 'Assistance';

  @override
  String get navProfile => 'Mon profil';

  @override
  String get navAdmin => 'Administration';

  @override
  String get navPublishersAdmin => 'Proclamateurs';

  @override
  String get navReportsAdmin => 'Récapitulatif des rapports';

  @override
  String get navS1 => 'Rapport S-1';

  @override
  String get navTalks => 'Titres des discours publics';

  @override
  String get navSettings => 'Paramètres de l\'assemblée';

  @override
  String get navStatistics => 'Statistiques';

  @override
  String get navHelp => 'Aide';

  @override
  String get helpPublisherSection => 'Conseils pour les proclamateurs';

  @override
  String get helpAdminSection => 'Pour les administrateurs';

  @override
  String get helpCalendarTitle => 'Ajouter à ton agenda';

  @override
  String get helpCalendarBody =>
      'Dans l\'application mobile, les événements et tes attributions affichent une icône d\'agenda. Appuie dessus pour ajouter l\'élément à l\'agenda de ton appareil.';

  @override
  String get helpRemindersTitle => 'Rappels d\'attributions';

  @override
  String get helpRemindersBody =>
      'Dans l\'écran Événements, appuie sur l\'icône de cloche à côté de « Mes prochaines attributions » pour être notifié avant chaque attribution : tu choisis le délai. (Application mobile uniquement.)';

  @override
  String get helpHighlightTitle => 'Repère-toi d\'un coup d\'œil';

  @override
  String get helpHighlightBody =>
      'Dans les programmes des réunions, ton propre nom est mis en évidence pour que tu repères rapidement tes attributions.';

  @override
  String get helpTerritoryMapTitle => 'Ouvrir la carte d\'un territoire';

  @override
  String get helpTerritoryMapBody =>
      'Appuie sur l\'icône de carte à côté d\'un territoire pour ouvrir sa carte. Une icône grise indique qu\'aucun lien de carte n\'a encore été ajouté pour ce territoire.';

  @override
  String get helpAdminToggleTitle =>
      'Voir l\'application comme un proclamateur';

  @override
  String get helpAdminToggleBody =>
      'L\'icône en forme de crayon dans la barre supérieure masque temporairement tous les outils d\'administration, pour que tu voies l\'application exactement comme les proclamateurs. Appuie de nouveau pour les rétablir.';

  @override
  String get helpPdfExportTitle => 'Imprimer ou partager les programmes';

  @override
  String get helpPdfExportBody =>
      'Dans les écrans Réunion de semaine et Réunion de week-end, les éditeurs des programmes disposent d\'une icône PDF dans la barre supérieure qui exporte le programme du mois pour l\'imprimer ou le partager.';

  @override
  String get helpGoogleMyMapsTitle =>
      'Cartes des territoires avec Google My Maps';

  @override
  String get helpGoogleMyMapsBody =>
      'Crée les cartes de tes territoires dans Google My Maps et colle le lien de partage de chaque territoire dans son champ de lien de carte. Un guide pas à pas est disponible sur GitHub.';

  @override
  String get helpOpenGuide => 'Ouvrir le guide';

  @override
  String get helpDataDelayTitle =>
      'Les changements peuvent mettre un instant à apparaître';

  @override
  String get helpDataDelayBody =>
      'Les changements faits dans l\'application — par exemple les modifications dans Proclamateurs — peuvent mettre jusqu\'à une minute à devenir visibles. (Parfois, par exemple, une importation S-21 n\'affiche pas immédiatement les heures de prédication de l\'année de service en cours.)';

  @override
  String get helpPwApplyTitle =>
      'Te porter volontaire pour le témoignage public';

  @override
  String get helpPwApplyBody =>
      'Ouvre Témoignage public, trouve un créneau et appuie sur l\'icône de main pour te porter volontaire ; appuie de nouveau pour te retirer. Si tu ne vois pas l\'icône, demande à un administrateur d\'activer l\'aptitude « Témoignage public » sur ta fiche.';

  @override
  String get helpPwAssignTitle =>
      'Attribuer des proclamateurs au témoignage public';

  @override
  String get helpPwAssignBody =>
      'Active l\'aptitude « Témoignage public » de chaque volontaire dans Proclamateurs → ouvre un proclamateur → Aptitudes. Ensuite, dans Témoignage public, ouvre un créneau et appuie sur « Attribués » : les proclamateurs qui se sont portés volontaires sont épinglés en haut de la liste avec l\'étiquette « Volontaire ». Utilise des créneaux récurrents pour les présentoirs ou tables hebdomadaires.';

  @override
  String get helpS21Title => 'Importer des fiches S-21';

  @override
  String get helpS21Body =>
      'Tu peux importer la fiche d\'activité du proclamateur (S-21) d\'un proclamateur à partir d\'un PDF. Ouvre Proclamateurs → un proclamateur → S-21 et choisis le fichier. Seule la couche de texte du PDF est lue, donc les formulaires scannés ou aplatis peuvent ne pas s\'importer.';

  @override
  String get helpS99Title => 'Importer les titres des discours publics (S-99)';

  @override
  String get helpS99Body =>
      'Dans Titres des discours publics, choisis « Mettre à jour les titres depuis un PDF » et sélectionne un formulaire S-99 officiel en PDF. Les prochaines réunions de week-end qui font référence à ces numéros de discours se mettent à jour automatiquement.';

  @override
  String get adminToggleHide => 'Masquer les options d\'administration';

  @override
  String get adminToggleShow => 'Afficher les options d\'administration';

  @override
  String get profilePhone => 'Numéro de téléphone';

  @override
  String get profileAddress => 'Adresse';

  @override
  String get profileBirthDate => 'Date de naissance';

  @override
  String get profileBaptismDate => 'Date de baptême';

  @override
  String get profileGender => 'Sexe';

  @override
  String get genderUnknown => '—';

  @override
  String get genderMale => 'Homme';

  @override
  String get genderFemale => 'Femme';

  @override
  String get profileHope => 'Espérance';

  @override
  String get hopeOtherSheep => 'Autre brebis';

  @override
  String get hopeAnointed => 'Oint';

  @override
  String get profileStatus => 'Situation de service';

  @override
  String get statusNone => '-';

  @override
  String get statusPublisher => 'Proclamateur';

  @override
  String get statusAuxPioneer => 'Pionnier auxiliaire';

  @override
  String get statusRegPioneer => 'Pionnier permanent';

  @override
  String get statusSpecialPioneer => 'Pionnier spécial';

  @override
  String get statusFieldMissionary => 'Missionnaire affecté dans le territoire';

  @override
  String get profileAppointment => 'Nomination';

  @override
  String get appointmentMinisterialServant => 'Assistant';

  @override
  String get appointmentElder => 'Ancien';

  @override
  String get profileEmergency => 'Note d\'urgence';

  @override
  String get profileEmergencyHint => 'Qui contacter en cas d\'urgence';

  @override
  String get profileSaved => 'Enregistré';

  @override
  String get profileRecord => 'Fiche d\'activité du proclamateur';

  @override
  String get profileAwayTitle => 'Périodes d\'absence';

  @override
  String get profileAwayEmpty => 'Aucune période d\'absence ajoutée';

  @override
  String get profileAwayAdd => 'Ajouter une période d\'absence';

  @override
  String profileAwayRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String serviceYear(int year) {
    return 'Année de service $year';
  }

  @override
  String get recordTotalHours => 'Total des heures';

  @override
  String get recordAverageHours => 'Moyenne mensuelle';

  @override
  String get reportMonth => 'Mois';

  @override
  String get reportParticipated => 'A participé à la prédication';

  @override
  String get reportStudies => 'Cours bibliques';

  @override
  String get reportHours => 'Heures';

  @override
  String get reportCredit => 'Heures de crédit';

  @override
  String get reportComments => 'Commentaires';

  @override
  String get s21Export => 'Exporter la S-21 (PDF)';

  @override
  String get schedulePdfExport => 'Récapitulatif mensuel (PDF)';

  @override
  String get lmmScheduleTitle => 'Programme de la réunion de semaine';

  @override
  String get s21Title => 'ACTIVITÉ DU PROCLAMATEUR (DOSSIER DE L\'ASSEMBLÉE)';

  @override
  String get s21Name => 'Nom :';

  @override
  String get s21DateOfBirth => 'Date de naissance :';

  @override
  String get s21DateOfBaptism => 'Date de baptême :';

  @override
  String get s21HoursHeader => 'Heures (si pionnier ou missionnaire)';

  @override
  String get s21Remarks => 'Observations';

  @override
  String get s21Total => 'Total';

  @override
  String get s21FormCode => 'S-21-F 11/23';

  @override
  String s21Credit(int hours) {
    return 'Crédit : $hours';
  }

  @override
  String get s21Import => 'Importer une S-21 (PDF)';

  @override
  String get s21ImportNew => 'Importer un proclamateur depuis une S-21';

  @override
  String get s21ImportTitle => 'Importer une S-21';

  @override
  String get s21ImportPickFile => 'Choisir un fichier PDF';

  @override
  String get s21ImportHint =>
      'Choisis une fiche d\'activité du proclamateur S-21 (PDF). Les valeurs de la fiche remplacent les champs du profil du proclamateur et les rapports mensuels.';

  @override
  String get s21ImportNoData => 'Aucune donnée S-21 trouvée dans ce fichier.';

  @override
  String s21ImportMonths(int count) {
    return '$count rapports mensuels trouvés';
  }

  @override
  String s21ImportNameKept(String name) {
    return 'Le nom dans l\'application est conservé : $name';
  }

  @override
  String s21ImportCardName(String name) {
    return 'Nom sur la fiche : $name';
  }

  @override
  String s21ImportDuplicateName(String name) {
    return 'Un proclamateur nommé « $name » existe déjà.';
  }

  @override
  String get s21ImportUseExisting => 'Importer dans la fiche existante';

  @override
  String get s21ImportReplaceTitle => 'Remplacer les fiches existantes ?';

  @override
  String get s21ImportReplaceBody =>
      'Les champs du profil du proclamateur et les rapports mensuels des années de service importées seront remplacés par les valeurs de cette S-21. Cette action est irréversible.';

  @override
  String get s21ImportSave => 'Importer';

  @override
  String get s21ImportDone => 'S-21 importée.';

  @override
  String get s21ImportAssignYear => 'Année de service de ce tableau';

  @override
  String get pubAdminInvite => 'Inviter';

  @override
  String get pubAdminInviteTitle => 'Inviter dans l\'assemblée';

  @override
  String get pubAdminInviteBody =>
      'Le nouveau membre scanne ce code QR dans l\'application, s\'inscrit, puis apparaît ci-dessous comme non vérifié. Vérifie-le pour lui accorder l\'accès.';

  @override
  String get pubAdminAddRecord => 'Ajouter une fiche de proclamateur';

  @override
  String get pubAdminAddRecordHint =>
      'Une fiche pour un membre qui n\'utilisera pas l\'application ; les rapports peuvent être saisis par les administrateurs.';

  @override
  String get pubAdminVerified => 'Vérifié';

  @override
  String get pubAdminUnverifiedBadge => 'En attente de vérification';

  @override
  String get pubAdminNoAccountBadge => 'Aucun compte d\'application';

  @override
  String get pubAdminTabProfile => 'Profil';

  @override
  String get pubAdminTabRoles => 'Droits';

  @override
  String get pubAdminTabAssign => 'Attribuer';

  @override
  String get pubAdminTabRecord => 'Fiche';

  @override
  String get pubAdminDeleteConfirm =>
      'Supprimer ce proclamateur et ses données privées ? Ses rapports restent conservés.';

  @override
  String get pubAdminDeleteMovedHint =>
      'S\'il a un compte d\'application, la suppression n\'enlève pas ses identifiants et il pourrait se reconnecter. Pour archiver quelqu\'un qui a déménagé, utilise plutôt « Marquer comme déménagé ».';

  @override
  String get pubAdminMarkMoved => 'Marquer comme déménagé';

  @override
  String get pubAdminRestoreMoved => 'Restaurer depuis les déménagés';

  @override
  String get pubAdminMovedBadge => 'Déménagé';

  @override
  String get pubAdminShowMoved => 'Afficher les déménagés';

  @override
  String get pubFilterPioneers => 'Pionniers';

  @override
  String get pubFilterHasRights => 'Avec des droits';

  @override
  String get pubFilterAnyGroup => 'N\'importe quel groupe';

  @override
  String get pubFilterClear => 'Effacer';

  @override
  String get pubAdminMoveConfirmTitle => 'Marquer comme déménagé ?';

  @override
  String get pubAdminMoveConfirmBody =>
      'La fiche et l\'historique des rapports sont conservés, mais le proclamateur est archivé : son accès est révoqué et il n\'apparaît plus dans les programmes ni dans les listes de rapports. Tu peux le restaurer plus tard.';

  @override
  String get pubAdminSelfVerifiedWarningTitle =>
      'Désactiver ton propre statut Vérifié ?';

  @override
  String get pubAdminSelfVerifiedWarningBody =>
      'Tu retires le statut Vérifié de ton propre compte. Tu perdras immédiatement l\'accès aux données de l\'assemblée, et seul un autre administrateur complet pourra le rétablir. Veux-tu vraiment continuer ?';

  @override
  String get pubAdminSelfFullAdminWarningTitle =>
      'Retirer tes propres droits d\'administrateur complet ?';

  @override
  String get pubAdminSelfFullAdminWarningBody =>
      'Tu retires le rôle d\'administrateur complet de ton propre compte. Si tu es le seul administrateur, personne — pas même toi — ne pourra annuler cette action. Veux-tu vraiment continuer ?';

  @override
  String get pubAdminSelfWarningConfirm => 'Retirer mon accès';

  @override
  String get pubConnectBanner =>
      'Ce compte est en attente de vérification. Si un administrateur a déjà créé une fiche de proclamateur pour cette personne, relie-les : l\'historique de la fiche passe sur ce compte et la fiche en double disparaît.';

  @override
  String get pubConnectAction => 'Relier à une fiche existante';

  @override
  String get pubConnectNeedsFullAdmin =>
      'Seul un administrateur complet peut relier des fiches (la migration touche les données de chaque section).';

  @override
  String get pubConnectPickTitle => 'Relier à une fiche existante';

  @override
  String pubConnectPickHint(String name) {
    return 'Sélectionne la fiche qui appartient à $name.';
  }

  @override
  String get pubConnectNoRecords =>
      'Il n\'y a aucune fiche de proclamateur sans compte d\'application à relier.';

  @override
  String get pubConnectConfirmTitle => 'Relier et fusionner ?';

  @override
  String pubConnectConfirmBody(String record, String account) {
    return 'Tout l\'historique de « $record » — rapports, territoires et attributions des programmes — sera transféré vers le compte de « $account ». Le compte devient vérifié et la fiche en double est définitivement supprimée. Cette action est irréversible.';
  }

  @override
  String get pubConnectProgressTitle => 'Liaison de la fiche…';

  @override
  String get pubConnectProgressBody =>
      'Ne ferme pas l\'application pendant le transfert de l\'historique.';

  @override
  String pubConnectFailed(String section) {
    return 'La liaison a échoué à : $section. Les étapes terminées sont conservées ; réessayer est sans risque et reprend là où ça s\'est arrêté.';
  }

  @override
  String get pubConnectSuccess =>
      'Fiche reliée : son historique appartient désormais à ce compte.';

  @override
  String get roleFullAdmin => 'Administrateur complet';

  @override
  String get roleRecordAttendance => 'Enregistrer l\'assistance';

  @override
  String get weekNoSchedule =>
      'Aucun programme pour cette semaine pour l\'instant.';

  @override
  String get weekCreateEmpty => 'Créer une semaine vide';

  @override
  String get weekImportEpub => 'Importer depuis un .epub';

  @override
  String get weekCheckCdn => 'Vérifier en ligne';

  @override
  String get weekDelete => 'Supprimer cette semaine';

  @override
  String get lmmSongs => 'Cantiques';

  @override
  String get sectionOpening => 'Ouverture';

  @override
  String get sectionTreasures => 'JOYAUX DE LA PAROLE DE DIEU';

  @override
  String get sectionMinistry => 'APPLIQUE-TOI AU MINISTÈRE';

  @override
  String get sectionLiving => 'VIE CHRÉTIENNE';

  @override
  String get sectionClosing => 'Conclusion';

  @override
  String get partChairman => 'Président';

  @override
  String get partOpeningPrayer => 'Prière d\'ouverture';

  @override
  String get partClosingPrayer => 'Prière de conclusion';

  @override
  String get partGems => 'Perles spirituelles';

  @override
  String get partBibleReading => 'Lecture de la Bible';

  @override
  String get partCbs => 'Étude biblique de l\'assemblée';

  @override
  String get partCbsReader => 'Lecteur';

  @override
  String get partAssistant => 'Interlocuteur';

  @override
  String partMinutes(int min) {
    return '$min min';
  }

  @override
  String get lmmClassMain => 'Salle principale';

  @override
  String lmmClassN(int index) {
    return 'Salle $index';
  }

  @override
  String get partEdit => 'Modifier la partie';

  @override
  String get partTitle => 'Titre';

  @override
  String get partDescription => 'Description';

  @override
  String get partDuration => 'Durée (min)';

  @override
  String get partAdd => 'Ajouter une partie';

  @override
  String get partDeleteConfirm => 'Supprimer cette partie ?';

  @override
  String get supportAttendants => 'Préposés à l\'accueil';

  @override
  String get supportMicrophones => 'Microphones';

  @override
  String get supportAudioVideo => 'Audio-vidéo';

  @override
  String get customAssignmentAdd => 'Ajouter une attribution personnalisée';

  @override
  String get customLabel => 'Libellé';

  @override
  String get customAssignmentPermanent => 'Permanente (chaque semaine)';

  @override
  String get customAssignmentRemovePermanentTitle =>
      'Retirer l\'attribution permanente';

  @override
  String customAssignmentRemovePermanentBody(String label) {
    return 'Retirer « $label » de chaque semaine ?';
  }

  @override
  String get pickerQualified => 'Aptes';

  @override
  String get pickerAll => 'Tous';

  @override
  String get pickerFreeText => 'Texte';

  @override
  String pickerLastAssigned(String date) {
    return 'Dernière fois : $date';
  }

  @override
  String get pickerNever => 'Jamais attribué';

  @override
  String get pickerApplied => 'Volontaire';

  @override
  String pickerAwayWarning(String range) {
    return 'Absent $range';
  }

  @override
  String get importTitle => 'Importer le Cahier de la réunion';

  @override
  String get importNoWeeks =>
      'Aucune semaine utilisable trouvée dans ce fichier.';

  @override
  String get importWeekExists =>
      'Existe déjà — le programme sera mis à jour, les attributions conservées';

  @override
  String importSave(int count) {
    return 'Importer $count semaines';
  }

  @override
  String get importDone => 'Importé.';

  @override
  String get importCdnNothing =>
      'Aucun numéro du Cahier de la réunion n\'est encore disponible en ligne.';

  @override
  String get weekendTalkTitle => 'Discours public';

  @override
  String get weekendSpeaker => 'Orateur';

  @override
  String get weekendChairmanLabel => 'Président';

  @override
  String get weekendWtReader => 'Lecteur de La Tour de Garde';

  @override
  String get customFieldAdd => 'Ajouter un champ au programme';

  @override
  String get pickerFromCatalog => 'Depuis la liste';

  @override
  String get talksUpdateFromPdf => 'Mettre à jour les titres depuis un PDF';

  @override
  String get talksPickPdf => 'Choisir un PDF S-99';

  @override
  String get talksParseError =>
      'Impossible de lire les titres des discours dans ce fichier. Utilise un formulaire S-99 officiel en PDF.';

  @override
  String talksImportSummary(int total, int added, int changed, int removed) {
    return '$total discours trouvés : $added nouveaux, $changed modifiés, $removed supprimés';
  }

  @override
  String get talksImportSave => 'Enregistrer les titres';

  @override
  String talksImportDone(int count) {
    return 'Titres enregistrés. $count réunions à venir mises à jour.';
  }

  @override
  String talksLastDelivered(String date) {
    return 'Prononcé pour la dernière fois le $date';
  }

  @override
  String get talksNeverDelivered => 'Pas encore prononcé';

  @override
  String get talksScheduled => 'programmé';

  @override
  String get talksNew => 'Nouveau';

  @override
  String get talksChanged => 'Modifié';

  @override
  String get talksRemoved => 'Supprimé';

  @override
  String get talksSearchHint => 'Rechercher des discours…';

  @override
  String get talksEmpty =>
      'Aucun titre de discours pour l\'instant. Importe-les depuis un PDF S-99.';

  @override
  String get talksOpenCatalog => 'Gérer les titres des discours';

  @override
  String get talksEditTitle => 'Modifier le titre';

  @override
  String get songLabel => 'Cantique';

  @override
  String get songsSearchHint => 'Rechercher des cantiques…';

  @override
  String get songsEmpty =>
      'Aucune liste de cantiques pour l\'instant. Mets-la à jour depuis le site officiel.';

  @override
  String get songsUpdateFromWeb =>
      'Mettre à jour la liste des cantiques depuis le site officiel';

  @override
  String songsUpdateDone(int count) {
    return 'Liste des cantiques mise à jour : $count cantiques.';
  }

  @override
  String get songsCdnNothing =>
      'La liste des cantiques n\'est pas encore disponible en ligne.';

  @override
  String get songsStatusEmpty =>
      'Aucune liste de cantiques importée pour l\'instant.';

  @override
  String songsStatusLoaded(int count, String date) {
    return '$count cantiques · mise à jour $date';
  }

  @override
  String get settingsSongsSection => 'Liste des cantiques';

  @override
  String get settingsSongsDescription =>
      'Télécharge les titres des cantiques des réunions depuis jw.org pour pouvoir les choisir dans les programmes de week-end et de semaine.';

  @override
  String get pwNoSlots => 'Aucun témoignage public cette semaine.';

  @override
  String get pwAddSlot => 'Ajouter un créneau';

  @override
  String get pwEditSlot => 'Modifier le créneau';

  @override
  String get pwLocation => 'Lieu';

  @override
  String get pwTimeFrom => 'De';

  @override
  String get pwTimeTo => 'À';

  @override
  String get pwRecurringRules => 'Créneaux récurrents';

  @override
  String get pwRecurringAdd => 'Ajouter un créneau récurrent';

  @override
  String get pwWeekday => 'Jour de la semaine';

  @override
  String get pwValidFrom => 'Valable à partir du';

  @override
  String get pwValidUntil => 'Valable jusqu\'au (facultatif)';

  @override
  String get pwAssignees => 'Attribués';

  @override
  String get pwDate => 'Date';

  @override
  String get pwApply => 'Me porter volontaire pour ce créneau';

  @override
  String get pwWithdraw => 'Retirer ma candidature';

  @override
  String pwApplicants(int count) {
    return '$count volontaires';
  }

  @override
  String get fsmNoMeetings =>
      'Aucune réunion pour la prédication cette semaine.';

  @override
  String get fsmAddMeeting => 'Ajouter une réunion';

  @override
  String get fsmEditMeeting => 'Modifier la réunion';

  @override
  String get fsmDate => 'Date';

  @override
  String get fsmTime => 'Heure';

  @override
  String get fsmLocation => 'Lieu';

  @override
  String get fsmNote => 'Note';

  @override
  String get fsmConductor => 'Conducteur';

  @override
  String get fsmRecurringRules => 'Réunions récurrentes';

  @override
  String get fsmRecurringAdd => 'Ajouter une réunion récurrente';

  @override
  String get fsmWeekday => 'Jour de la semaine';

  @override
  String get fsmValidFrom => 'Valable à partir du';

  @override
  String get fsmValidUntil => 'Valable jusqu\'au (facultatif)';

  @override
  String get fsmRecurringDeleteConfirm =>
      'Supprimer cette réunion récurrente ? Ses réunions futures seront également supprimées. Cette action est irréversible.';

  @override
  String get fsmRemoveAllFutureAction =>
      'Supprimer toutes les réunions futures';

  @override
  String get fsmRemoveAllFutureWarning =>
      'Supprimer toutes les réunions futures efface chaque réunion à venir, ponctuelle ou récurrente, et est irréversible.';

  @override
  String get fsmRemoveAllFutureTitle =>
      'Supprimer toutes les réunions futures ?';

  @override
  String get fsmRemoveAllFutureBody =>
      'Cette action efface chaque réunion pour la prédication à venir, ponctuelle ou récurrente, et supprime toutes les règles de réunions récurrentes pour qu\'aucune ne se régénère. Les réunions passées sont conservées. Cette action est irréversible.';

  @override
  String get fsmRemoveAllFutureConfirm => 'Tout supprimer';

  @override
  String get eventsUpcoming => 'Événements à venir';

  @override
  String get eventsNone => 'Aucun événement à venir.';

  @override
  String get eventAdd => 'Ajouter un événement';

  @override
  String get eventEdit => 'Modifier l\'événement';

  @override
  String get eventTitle => 'Titre';

  @override
  String get eventType => 'Type';

  @override
  String get eventTypeConvention => 'Assemblée régionale';

  @override
  String get eventTypeAssembly => 'Assemblée de circonscription';

  @override
  String get eventTypeMemorial => 'Commémoration';

  @override
  String get eventTypeCoVisit => 'Visite du responsable de circonscription';

  @override
  String get eventTypeOther => 'Autre';

  @override
  String get eventDateFrom => 'Du';

  @override
  String get eventDateTo => 'Au (facultatif)';

  @override
  String get eventLocation => 'Lieu';

  @override
  String get eventNotes => 'Notes';

  @override
  String get eventAddToCalendar => 'Ajouter à l\'agenda';

  @override
  String get myAssignments => 'Mes prochaines attributions';

  @override
  String get myAssignmentsNone => 'Aucune attribution à venir.';

  @override
  String get remindersTitle => 'Rappels d\'attributions';

  @override
  String get remindersDescription =>
      'Reçois une notification sur cet appareil avant chacune de tes prochaines attributions. Les changements faits pendant que l\'application est fermée sont pris en compte à sa prochaine ouverture.';

  @override
  String get remindersEnable => 'Activer les rappels';

  @override
  String get remindersAdd => 'Ajouter un rappel';

  @override
  String get reminderUnitMinutes => 'minutes avant';

  @override
  String get reminderUnitHours => 'heures avant';

  @override
  String get reminderUnitDays => 'jours avant';

  @override
  String get remindersPermissionDenied =>
      'Les notifications ne sont pas autorisées pour cette application. Active-les dans les paramètres du système pour utiliser les rappels.';

  @override
  String get remindersChannelName => 'Rappels d\'attributions';

  @override
  String get remindersChannelDescription =>
      'Notifications avant tes attributions dans l\'assemblée';

  @override
  String get roleAssistant => 'Interlocuteur';

  @override
  String get rolePw => 'Témoignage public';

  @override
  String get roleFsm => 'Réunion pour la prédication';

  @override
  String get reportSubmit => 'Envoyer le rapport';

  @override
  String reportSubmittedAt(String date) {
    return 'Envoyé le $date';
  }

  @override
  String get reportSaved => 'Rapport enregistré.';

  @override
  String get reportMissing => 'Non envoyé';

  @override
  String reportEnterFor(String name) {
    return 'Saisir le rapport — $name';
  }

  @override
  String reportSummaryReported(int reported, int total) {
    return 'Ont remis leur rapport : $reported / $total';
  }

  @override
  String get attAdd => 'Enregistrer l\'assistance';

  @override
  String get attInPerson => 'En présentiel';

  @override
  String get attOnline => 'En ligne';

  @override
  String get attTotal => 'Total';

  @override
  String get attMeetingLmm => 'Réunion de semaine';

  @override
  String get attMeetingWeekend => 'Réunion de week-end';

  @override
  String get attOverview => 'Moyennes mensuelles';

  @override
  String get attHistory => 'Réunions passées';

  @override
  String get attNotFilled => 'Non enregistré';

  @override
  String get attMismatch => 'Les chiffres ne concordent pas.';

  @override
  String attRecordedOf(int filled, int expected) {
    return '$filled/$expected enregistrés';
  }

  @override
  String get attSaved => 'Assistance enregistrée.';

  @override
  String get statMembershipTitle => 'Proclamateurs';

  @override
  String get statTotalMembers => 'Tous les proclamateurs';

  @override
  String get statPioneers => 'Pionniers';

  @override
  String get statAgeTitle => 'Répartition par âge';

  @override
  String get statAgeAverage => 'Âge moyen';

  @override
  String statAgeKnownDetail(int known, int total) {
    return 'Basé sur $known dates de naissance connues sur $total';
  }

  @override
  String get statAgeUnder18 => 'Moins de 18 ans';

  @override
  String get statAgeUnknown => 'Inconnu';

  @override
  String get statAttendanceTitle => 'Assistance aux réunions';

  @override
  String get statAvg3Months => 'Moy. 3 mois';

  @override
  String get statAvg12Months => 'Moy. 12 mois';

  @override
  String get statFieldServiceTitle => 'Prédication';

  @override
  String statServiceYear(String year) {
    return 'Année de service $year';
  }

  @override
  String get statReportsSubmitted => 'Rapports envoyés';

  @override
  String get statParticipated => 'Ont participé à la prédication';

  @override
  String get statPioneerHours => 'Heures des pionniers';

  @override
  String get statPublisherHours => 'Heures des proclamateurs';

  @override
  String get statUsageTitle => 'Utilisation de l\'application';

  @override
  String get statWithAccount => 'Avec un compte d\'application';

  @override
  String get statSelfReported =>
      'Rapports envoyés par les proclamateurs eux-mêmes (le mois dernier)';

  @override
  String get statAwaiting => 'En attente de vérification';

  @override
  String get statFullAdmins => 'Administrateurs complets';

  @override
  String get statSectionAdmins => 'Administrateurs de section';

  @override
  String get statNoData => 'Aucune donnée pour l\'instant';

  @override
  String get terrMine => 'Mes territoires';

  @override
  String get terrNoMine => 'Aucun territoire ne t\'est attribué.';

  @override
  String get terrAll => 'Tous les territoires';

  @override
  String terrAssignedOn(String date) {
    return 'Attribué le $date';
  }

  @override
  String get terrReturn => 'Rendre';

  @override
  String get terrReturnTitle => 'Rendre le territoire';

  @override
  String get terrReturnNotes => 'Notes (facultatif)';

  @override
  String get terrMap => 'Carte';

  @override
  String get terrAdd => 'Ajouter un territoire';

  @override
  String get terrEdit => 'Modifier le territoire';

  @override
  String get terrName => 'Nom';

  @override
  String get terrNameDuplicate => 'Un territoire portant ce nom existe déjà.';

  @override
  String get terrMapUrl => 'Lien de carte (par exemple Google My Maps)';

  @override
  String get terrNotes => 'Notes';

  @override
  String get terrAssignTo => 'Attribuer à…';

  @override
  String terrHolder(String name, String date) {
    return '$name — depuis le $date';
  }

  @override
  String get terrFree => 'Non attribué';

  @override
  String get terrStats => 'Statistiques';

  @override
  String get terrStatsTotal => 'Total';

  @override
  String get terrStatsAssigned => 'Actuellement attribués';

  @override
  String get terrStatsFinished => 'Terminés sur la période';

  @override
  String get terrRemoveAssignment => 'Retirer l\'attribution';

  @override
  String get terrImportTitle => 'Importer des territoires';

  @override
  String get terrImportPasteHint =>
      'Colle des lignes depuis Excel ou Google Sheets. Colonnes : nom, lien de carte, notes ; seul le nom est obligatoire.';

  @override
  String get terrImportPreview => 'Aperçu';

  @override
  String get terrImportPickFile => 'Choisir un fichier CSV';

  @override
  String terrImportSummary(
    int total,
    int newCount,
    int duplicates,
    int invalid,
  ) {
    return '$total lignes : $newCount nouvelles, $duplicates existantes, $invalid non valides';
  }

  @override
  String get terrImportUpdateExisting =>
      'Mettre à jour les territoires existants (correspondance par nom) au lieu de les ignorer';

  @override
  String get terrImportBadgeNew => 'Nouveau';

  @override
  String get terrImportBadgeSkip => 'Ignorer';

  @override
  String get terrImportBadgeUpdate => 'Mettre à jour';

  @override
  String get terrImportBadgeInvalid => 'Nom manquant';

  @override
  String get terrImportBadgeDupRow => 'Ligne en double';

  @override
  String terrImportLine(int line) {
    return 'Ligne $line';
  }

  @override
  String terrImportSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importer $count territoires',
      one: 'Importer 1 territoire',
    );
    return '$_temp0';
  }

  @override
  String terrImportDone(int created, int updated) {
    return '$created nouveaux importés, $updated mis à jour.';
  }

  @override
  String get terrImportEmpty => 'Aucune ligne trouvée dans la saisie.';

  @override
  String get terrDeleteConfirm =>
      'Supprimer ce territoire ? Cette action est irréversible.';

  @override
  String get terrSortByTerritory => 'Territoire';

  @override
  String get terrSortByPublisher => 'Proclamateur';

  @override
  String get terrSortByDate => 'Date d\'attribution';

  @override
  String get terrHistoryOngoing => 'En cours';

  @override
  String get terrHistoryEmpty =>
      'Aucun historique d\'attribution pour l\'instant.';

  @override
  String get mgEmpty => 'Aucun groupe de prédication pour l\'instant.';

  @override
  String get mgAdd => 'Ajouter un groupe';

  @override
  String get mgEdit => 'Modifier le groupe';

  @override
  String get mgName => 'Nom';

  @override
  String mgMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membres',
      one: '1 membre',
      zero: 'Aucun membre',
    );
    return '$_temp0';
  }

  @override
  String get mgNoMembers => 'Aucun membre dans ce groupe pour l\'instant.';

  @override
  String get mgOverseer => 'Responsable de groupe';

  @override
  String get mgAssistant => 'Assistant de groupe';

  @override
  String get mgMakeOverseer => 'Définir comme responsable de groupe';

  @override
  String get mgMakeAssistant => 'Définir comme assistant';

  @override
  String get mgClearRole => 'Retirer la désignation de responsable/assistant';

  @override
  String get mgAddMember => 'Ajouter un membre…';

  @override
  String get mgNoUnassigned => 'Tout le monde est déjà dans un groupe.';

  @override
  String get mgRemoveMember => 'Retirer du groupe';

  @override
  String get mgDeleteConfirm =>
      'Supprimer ce groupe ? Ses membres se retrouveront sans groupe.';

  @override
  String get mgGroup => 'Groupe de prédication';

  @override
  String get mgNoGroup => 'Aucun groupe';

  @override
  String get infoEmpty => 'Aucune information pour le moment.';

  @override
  String get infoAddText => 'Ajouter du texte';

  @override
  String get infoAddFile => 'Téléverser un fichier (PDF/image)';

  @override
  String get infoTitle => 'Titre';

  @override
  String get infoBody => 'Texte';

  @override
  String get infoUrl => 'Lien (URL)';

  @override
  String get infoShowFrom => 'Afficher à partir du (facultatif)';

  @override
  String get infoShowUntil => 'Afficher jusqu\'au (facultatif)';

  @override
  String get infoFileTooLarge =>
      'Le fichier est trop volumineux (max 10 Mo). Partage-le plutôt sous forme de lien.';

  @override
  String get infoHidden =>
      'Actuellement masqué (en dehors de sa période de visibilité)';

  @override
  String get infoDownloading => 'Chargement du fichier…';

  @override
  String get infoEditItem => 'Modifier l\'élément';

  @override
  String get infoCleanTooltip => 'Vider le tableau d\'affichage';

  @override
  String get infoCleanConfirmTitle => 'Vider le tableau d\'affichage ?';

  @override
  String get infoCleanConfirmBody =>
      'Cette action supprime définitivement TOUTES les annonces — textes, fichiers et liens, qu\'elles soient passées, actuelles ou futures. Cette action est irréversible.';

  @override
  String get infoCleanDone => 'Tableau d\'affichage vidé.';

  @override
  String get s1Active =>
      'Proclamateurs actifs (qui ont remis un rapport au moins une fois au cours des 6 derniers mois)';

  @override
  String get s1AvgMid => 'Assistance moyenne à la réunion de semaine';

  @override
  String get s1AvgWeekend => 'Assistance moyenne à la réunion de week-end';

  @override
  String get s1Publishers => 'Proclamateurs';

  @override
  String get s1AuxPioneers => 'Pionniers auxiliaires';

  @override
  String get s1RegPioneers => 'Pionniers permanents';

  @override
  String get s1Count => 'Nombre de fiches d\'activité';

  @override
  String get s1Studies => 'Cours bibliques';

  @override
  String get s1Hours => 'Heures (total)';

  @override
  String get s1Note =>
      'Les pionniers auxiliaires, permanents et spéciaux ne sont pas comptés dans le groupe des Proclamateurs ; les pionniers spéciaux ne sont inclus dans aucun groupe.';

  @override
  String get settingsName => 'Nom de l\'assemblée';

  @override
  String get settingsLmmMeeting => 'Réunion de semaine (jour et heure)';

  @override
  String get settingsLmmClassCount => 'Salles de la réunion de semaine';

  @override
  String get settingsWeekendMeeting => 'Réunion de week-end (jour et heure)';

  @override
  String get settingsBackupSection => 'Sauvegarde et restauration';

  @override
  String get settingsBackupDescription =>
      'Télécharge une copie complète des données de ton assemblée, ou restaure-les à partir d\'un fichier de sauvegarde. Utilise cela pour récupérer après une suppression accidentelle ou une mauvaise modification.';

  @override
  String get settingsExportData => 'Exporter toutes les données';

  @override
  String get settingsImportData => 'Restaurer depuis une sauvegarde…';

  @override
  String backupExportSuccess(int count) {
    return 'Sauvegarde téléchargée ($count enregistrements).';
  }

  @override
  String get backupImportTitle => 'Restaurer depuis une sauvegarde';

  @override
  String get backupImportPick => 'Choisir un fichier de sauvegarde…';

  @override
  String get backupImportEmpty =>
      'Choisis un fichier de sauvegarde pour prévisualiser son contenu.';

  @override
  String get backupImportContents => 'Contenu';

  @override
  String backupImportFrom(String name, String date) {
    return 'Sauvegarde de $name · $date';
  }

  @override
  String get backupImportWarning =>
      'La restauration écrase les enregistrements actuels qui partagent un ID avec les versions de cette sauvegarde. Les enregistrements ajoutés après la sauvegarde sont conservés. Cette action est irréversible.';

  @override
  String get backupImportConfirm => 'Restaurer cette sauvegarde';

  @override
  String backupImportSuccess(int count) {
    return '$count enregistrements restaurés.';
  }

  @override
  String backupImportPartial(int count, String collections) {
    return '$count enregistrements restaurés. Impossible de restaurer : $collections.';
  }

  @override
  String get backupInvalidFile =>
      'Ce fichier n\'est pas une sauvegarde d\'assemblée valide.';

  @override
  String get qSupportSection => 'Soutien à la réunion et autres';

  @override
  String get qChairman => 'Président (réunion de semaine)';

  @override
  String get qPrayer => 'Prière';

  @override
  String get qTreasures => 'Joyaux de la Parole de Dieu';

  @override
  String get qGems => 'Perles spirituelles';

  @override
  String get qBibleReading => 'Lecture de la Bible';

  @override
  String get qFieldMinistry => 'Assignations d\'élève (prédication)';

  @override
  String get qLiving => 'Vie chrétienne';

  @override
  String get qCbsConductor => 'Conducteur de l\'étude biblique de l\'assemblée';

  @override
  String get qCbsReader => 'Lecteur de l\'étude biblique de l\'assemblée';

  @override
  String get qPublicTalk => 'Discours public';

  @override
  String get qWeekendChairman => 'Président (week-end)';

  @override
  String get qWtReader => 'Lecteur de La Tour de Garde';

  @override
  String get qAttendant => 'Préposé à l\'accueil';

  @override
  String get qMicrophone => 'Microphones';

  @override
  String get qAudioVideo => 'Audio-vidéo';

  @override
  String get qPublicWitnessing => 'Témoignage public';

  @override
  String get qMinistryMeetingConductor =>
      'Conducteur de la réunion pour la prédication';
}
