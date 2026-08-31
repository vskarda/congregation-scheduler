// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Harmonogram zboru';

  @override
  String get commonSave => 'Zapisz';

  @override
  String get commonCancel => 'Anuluj';

  @override
  String get commonDelete => 'Usuń';

  @override
  String get commonEdit => 'Edytuj';

  @override
  String get commonAdd => 'Dodaj';

  @override
  String get commonClose => 'Zamknij';

  @override
  String get commonClear => 'Wyczyść';

  @override
  String get commonBack => 'Wstecz';

  @override
  String get commonRetry => 'Ponów';

  @override
  String get commonLoading => 'Ładowanie…';

  @override
  String get commonError => 'Coś poszło nie tak';

  @override
  String commonErrorDetail(String message) {
    return 'Coś poszło nie tak: $message';
  }

  @override
  String get commonFieldRequired => 'To pole jest wymagane';

  @override
  String get commonConfirmDeleteTitle => 'Usunąć?';

  @override
  String get commonConfirmDeleteBody => 'Tej operacji nie można cofnąć.';

  @override
  String get commonToday => 'Dziś';

  @override
  String get commonAll => 'Wszyscy';

  @override
  String get commonNone => 'Brak';

  @override
  String get commonYes => 'Tak';

  @override
  String get commonNo => 'Nie';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSearch => 'Szukaj';

  @override
  String get commonExport => 'Eksportuj';

  @override
  String get exportServiceYear => 'Rok służbowy';

  @override
  String get commonNotAssigned => '—';

  @override
  String get commonLanguage => 'Język';

  @override
  String get setupTitle => 'Połącz się ze swoim zborem';

  @override
  String get setupIntro =>
      'Ta aplikacja łączy się bezpośrednio z bazą danych twojego zboru. Wklej konfigurację otrzymaną od administratora lub zeskanuj kod QR z zaproszenia.';

  @override
  String get setupConfigLabel => 'Konfiguracja Firebase (JSON)';

  @override
  String get setupConfigHint => 'apiKey, authDomain, projectId, …';

  @override
  String get setupScanQr => 'Zeskanuj kod QR';

  @override
  String get setupPickQrImage => 'Wybierz zdjęcie kodu QR';

  @override
  String get setupQrNotFoundInImage => 'Nie znaleziono kodu QR na tym obrazie.';

  @override
  String get setupConnect => 'Połącz';

  @override
  String get setupInvalidJson =>
      'To nie jest prawidłowa konfiguracja JSON. Musi zawierać co najmniej apiKey, projectId i appId.';

  @override
  String setupConnectionFailed(String message) {
    return 'Nie udało się połączyć z tą konfiguracją: $message';
  }

  @override
  String get setupModeTitle => 'Jak chcesz zacząć?';

  @override
  String get setupModeJoin => 'Dołącz do mojego zboru';

  @override
  String get setupModeJoinSubtitle =>
      'Administrator cię zaprosił. Po rejestracji zweryfikuje twoje konto.';

  @override
  String get setupModeNew => 'Skonfiguruj nowy zbór';

  @override
  String get setupModeNewSubtitle =>
      'Jesteś pierwszym administratorem świeżo utworzonego projektu Firebase.';

  @override
  String get setupCongregationExists =>
      'Ten zbór jest już skonfigurowany. Wybierz zamiast tego «Dołącz do mojego zboru».';

  @override
  String get setupDatabaseNotReady =>
      'Baza danych zboru jeszcze się uruchamia. Poczekaj chwilę i spróbuj ponownie.';

  @override
  String get setupReconfigure => 'Zmień konfigurację';

  @override
  String get setupRestartRequired =>
      'Konfiguracja zapisana. Zamknij i otwórz aplikację ponownie, aby ją zastosować.';

  @override
  String get setupGuideLinkIntro =>
      'Nie masz konfiguracji? Utwórz darmową bazę danych swojego zboru:';

  @override
  String get setupGuideLinkButton => 'Jak skonfigurować nowy zbór';

  @override
  String get setupGuideTitle => 'Skonfiguruj nowy zbór';

  @override
  String get setupGuideIntro =>
      'Ta aplikacja jest samodzielnie hostowana: dane twojego zboru znajdują się w twoim własnym darmowym projekcie Google Firebase, do którego nikt inny nie ma dostępu. Konfiguracja zajmuje około 15 minut i nie wymaga programowania — wystarczy konto Google. Wykonaj poniższe kroki na tym telefonie lub na komputerze.';

  @override
  String get setupGuideOpenConsole => 'Otwórz konsolę Firebase';

  @override
  String get setupGuideStep1Title => 'Utwórz projekt Firebase';

  @override
  String get setupGuideStep1Body1 =>
      'Otwórz console.firebase.google.com, zaloguj się kontem Google i dotknij «Get started by setting up a Firebase project».';

  @override
  String get setupGuideStep1Body2 =>
      'Nadaj projektowi nazwę, np. «zbor-mojemiasto», zaakceptuj warunki i kontynuuj. Jeśli zostanie zaproponowany Google Analytics, wyłącz go — nie jest potrzebny. Pozostań na darmowym planie Spark; aplikacja została zaprojektowana tak, aby nigdy nie wymagać płatności.';

  @override
  String get setupGuideStep2Title => 'Włącz logowanie przez e-mail';

  @override
  String get setupGuideStep2Body1 =>
      'W menu po lewej wybierz Security → Authentication.';

  @override
  String get setupGuideStep2Body2 => 'Dotknij «Get started».';

  @override
  String get setupGuideStep2Body3 =>
      'Na karcie «Sign-in method» wybierz Email/Password.';

  @override
  String get setupGuideStep2Body4 =>
      'Włącz pierwszy przełącznik (pozostaw «Email link» wyłączony) i dotknij Save.';

  @override
  String get setupGuideStep3Title => 'Utwórz bazę danych Firestore';

  @override
  String get setupGuideStep3Body1 =>
      'W menu po lewej wybierz Databases & Storage → Firestore.';

  @override
  String get setupGuideStep3Body2 => 'Dotknij «Create database».';

  @override
  String get setupGuideStep3Body3 => 'Wybierz edycję Standard.';

  @override
  String get setupGuideStep3Body4 =>
      'Wybierz lokalizację blisko siebie (np. europe-central2 dla Polski). Później nie będzie można jej zmienić.';

  @override
  String get setupGuideStep3Body5 => 'Rozpocznij w trybie produkcyjnym…';

  @override
  String get setupGuideStep3Body6 => '…i dotknij Create.';

  @override
  String get setupGuideStep4Title => 'Zainstaluj reguły zabezpieczeń';

  @override
  String get setupGuideStep4Body1 =>
      'Reguły określają, kto może odczytywać i zapisywać jakie dane (np. tylko zweryfikowani głosiciele widzą plany). W bazie danych Firestore otwórz kartę Rules i dotknij «Edit rules».';

  @override
  String get setupGuideStep4Body2 =>
      'Usuń wszystko w edytorze i wklej skopiowane reguły.';

  @override
  String get setupGuideStep4Body3 => 'Dotknij Publish.';

  @override
  String get setupGuideStep4Note =>
      'Powtarzaj ten krok za każdym razem, gdy nowa wersja aplikacji wprowadza zaktualizowane reguły.';

  @override
  String get setupGuideStep5Title => 'Pobierz konfigurację aplikacji';

  @override
  String get setupGuideStep5Body1 =>
      'Dotknij ikony koła zębatego obok «Project Overview» (u góry po lewej) i wybierz Project settings.';

  @override
  String get setupGuideStep5Body2 =>
      'Na karcie General przewiń do «Your apps» i dotknij ikony internetowej </>.';

  @override
  String get setupGuideStep5Body3 =>
      'Wpisz pseudonim, np. «congregation-app», pozostaw hosting wyłączony i dotknij «Register app».';

  @override
  String get setupGuideStep5Body4 =>
      'Pojawi się blok kodu z «const firebaseConfig = …». Zaznacz i skopiuj tylko konfigurację między nawiasami klamrowymi, włącznie z nawiasami.';

  @override
  String get setupGuideStep5Note =>
      'Ta konfiguracja nie jest tajna — identyfikuje jedynie twój projekt. Dane są chronione przez reguły zabezpieczeń z kroku 4.';

  @override
  String get setupGuideRulesTitle => 'Reguły zabezpieczeń (firestore.rules)';

  @override
  String get setupGuideRulesCopy => 'Kopiuj reguły';

  @override
  String get setupGuideRulesCopied => 'Reguły skopiowane do schowka.';

  @override
  String get setupGuideRulesView => 'Pokaż tekst reguł';

  @override
  String get setupGuideRulesLoadError => 'Nie udało się wczytać tekstu reguł.';

  @override
  String get setupGuideFinish =>
      'Gotowe! Wróć, wklej skopiowaną konfigurację i dotknij Połącz. Następnie wybierz «Skonfiguruj nowy zbór» i zarejestruj się jako pierwszy administrator.';

  @override
  String get setupGuideBackToConnect => 'Powrót do ekranu połączenia';

  @override
  String get languageSystem => 'Język systemu';

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
  String get themeSystem => 'Systemowy';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String themeTooltip(String mode) {
    return 'Motyw: $mode';
  }

  @override
  String get profileCompleteTitle => 'Uzupełnij swój profil';

  @override
  String get profileCompleteBody =>
      'Twoje konto istnieje, ale brakuje profilu. Wpisz swoje imię i nazwisko, aby dokończyć rejestrację.';

  @override
  String get authSignIn => 'Zaloguj się';

  @override
  String get authSignOut => 'Wyloguj się';

  @override
  String get authRegister => 'Utwórz konto';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Hasło';

  @override
  String get authPasswordConfirm => 'Potwierdź hasło';

  @override
  String get authPasswordsDontMatch => 'Hasła nie są zgodne';

  @override
  String get authForgotPassword => 'Nie pamiętasz hasła?';

  @override
  String get authResetSent => 'Wysłano e-mail do zresetowania hasła.';

  @override
  String get authEnterEmailForReset =>
      'Najpierw wpisz swój adres e-mail, a następnie dotknij «Nie pamiętasz hasła?», aby otrzymać link do resetowania.';

  @override
  String get authNoAccountYet => 'Nie masz jeszcze konta? Utwórz je';

  @override
  String get authHaveAccount => 'Masz już konto? Zaloguj się';

  @override
  String get authErrorInvalidCredentials => 'Nieprawidłowy e-mail lub hasło.';

  @override
  String get authErrorEmailInUse => 'Konto z tym e-mailem już istnieje.';

  @override
  String get authErrorWeakPassword =>
      'Hasło jest za słabe (co najmniej 6 znaków).';

  @override
  String authErrorGeneric(String message) {
    return 'Logowanie nie powiodło się: $message';
  }

  @override
  String get authFirstName => 'Imię';

  @override
  String get authLastName => 'Nazwisko';

  @override
  String get authCongregationName => 'Nazwa zboru';

  @override
  String get awaitingTitle => 'Oczekiwanie na weryfikację';

  @override
  String get awaitingBody =>
      'Twoje konto zostało utworzone. Teraz administrator zboru musi je zweryfikować, zanim będziesz mógł zobaczyć informacje o zborze.';

  @override
  String get awaitingMovedTitle => 'Nie jesteś już członkiem zboru';

  @override
  String get awaitingMovedBody =>
      'Według kartoteki tego zboru przeprowadziłeś się, dlatego informacje zboru nie są tu już pokazywane. Historia twoich sprawozdań pozostaje w zborze. Jeśli to pomyłka, skontaktuj się z jednym ze starszych.';

  @override
  String get deleteAccountAction => 'Usuń moje konto';

  @override
  String get deleteAccountWarning =>
      'Ta operacja trwale usuwa twoje konto i profil osobisty (imię i nazwisko, dane kontaktowe oraz dane logowania). Nie można jej cofnąć. Przesłane przez ciebie sprawozdania pozostają zapisane w zborze.';

  @override
  String get deleteAccountPasswordLabel => 'Wpisz hasło, aby potwierdzić';

  @override
  String get deleteAccountConfirm => 'Usuń konto';

  @override
  String get deleteAccountSoleAdminTitle => 'Jesteś jedynym administratorem';

  @override
  String get deleteAccountSoleAdminBody =>
      'Jesteś jedynym pełnym administratorem zboru. Najpierw nadaj uprawnienia pełnego administratora innemu członkowi; w przeciwnym razie usunięcie twojego konta pozostawiłoby zbór bez administratora i bez możliwości przywrócenia dostępu.';

  @override
  String get changePasswordAction => 'Zmień hasło';

  @override
  String get changePasswordCurrentLabel => 'Aktualne hasło';

  @override
  String get changePasswordNewLabel => 'Nowe hasło';

  @override
  String get changePasswordConfirmLabel => 'Potwierdź nowe hasło';

  @override
  String get changePasswordConfirm => 'Zaktualizuj hasło';

  @override
  String get changePasswordSuccess => 'Hasło zostało zmienione.';

  @override
  String get changeEmailAction => 'Zmień e-mail logowania';

  @override
  String get changeEmailBody =>
      'Wysyłamy link potwierdzający na nowy adres. Na stary adres nic nie jest wysyłane, więc zadziała to również wtedy, gdy nie możesz już otworzyć starej skrzynki.';

  @override
  String get changeEmailReloginWarning =>
      'Trzeba będzie zalogować się ponownie. Zmiana zadziała dopiero po otwarciu linku w nowej skrzynce — to urządzenie wyloguje cię i zalogujesz się nowym adresem oraz dotychczasowym hasłem.';

  @override
  String get changeEmailNewLabel => 'Nowy adres e-mail';

  @override
  String get changeEmailPasswordLabel => 'Podaj hasło, aby potwierdzić';

  @override
  String get changeEmailConfirm => 'Wyślij link potwierdzający';

  @override
  String changeEmailSent(String email) {
    return 'Link potwierdzający wysłany na $email. Otwórz go, aby dokończyć zmianę, a potem zaloguj się ponownie nowym adresem.';
  }

  @override
  String get changeEmailInvalid => 'To nie jest prawidłowy adres e-mail.';

  @override
  String get changeEmailSameAsCurrent => 'To już jest twój adres logowania.';

  @override
  String get navInfoBoard => 'Tablica ogłoszeń';

  @override
  String get navEvents => 'Wydarzenia';

  @override
  String get navLmm => 'Zebranie w tygodniu';

  @override
  String get navWeekend => 'Zebranie w weekend';

  @override
  String get navPublicWitnessing => 'Świadczenie publiczne';

  @override
  String get navFieldServiceMeetings => 'Zbiórki do służby';

  @override
  String get navTerritories => 'Tereny';

  @override
  String get navMinistryGroups => 'Grupy służby';

  @override
  String get navReport => 'Sprawozdanie ze służby';

  @override
  String get navAttendance => 'Obecność';

  @override
  String get navProfile => 'Mój profil';

  @override
  String get navAdmin => 'Administracja';

  @override
  String get navPublishersAdmin => 'Głosiciele';

  @override
  String get navReportsAdmin => 'Podsumowanie sprawozdań';

  @override
  String get navS1 => 'Sprawozdanie S-1';

  @override
  String get navTalks => 'Tematy wykładów publicznych';

  @override
  String get navSettings => 'Ustawienia zboru';

  @override
  String get navStatistics => 'Statystyki';

  @override
  String get navHelp => 'Pomoc';

  @override
  String get helpPublisherSection => 'Wskazówki dla głosicieli';

  @override
  String get helpAdminSection => 'Dla administratorów';

  @override
  String get helpCalendarTitle => 'Dodaj do kalendarza';

  @override
  String get helpCalendarBody =>
      'W aplikacji mobilnej wydarzenia i twoje zadania mają ikonę kalendarza. Dotknij jej, aby dodać element do kalendarza urządzenia.';

  @override
  String get helpRemindersTitle => 'Przypomnienia o zadaniach';

  @override
  String get helpRemindersBody =>
      'Na ekranie Wydarzenia dotknij ikony dzwonka obok «Moje najbliższe zadania», aby otrzymać powiadomienie przed każdym zadaniem — sam wybierasz, z jakim wyprzedzeniem. (Tylko aplikacja mobilna.)';

  @override
  String get helpHighlightTitle => 'Znajdź się jednym spojrzeniem';

  @override
  String get helpHighlightBody =>
      'W planach zebrań twoje własne imię i nazwisko jest wyróżnione, dzięki czemu szybko dostrzeżesz swoje zadania.';

  @override
  String get helpTerritoryMapTitle => 'Otwórz mapę terenu';

  @override
  String get helpTerritoryMapBody =>
      'Dotknij ikony mapy obok terenu, aby otworzyć jego mapę. Szara ikona oznacza, że do tego terenu nie dodano jeszcze linku do mapy.';

  @override
  String get helpAdminToggleTitle => 'Zobacz aplikację jak głosiciel';

  @override
  String get helpAdminToggleBody =>
      'Ikona ołówka na górnym pasku tymczasowo ukrywa wszystkie narzędzia administratora, dzięki czemu widzisz aplikację dokładnie tak jak głosiciele. Dotknij ponownie, aby je przywrócić.';

  @override
  String get helpPdfExportTitle => 'Drukuj lub udostępniaj plany';

  @override
  String get helpPdfExportBody =>
      'Na ekranach Zebranie w tygodniu i Zebranie w weekend redaktorzy planów mają ikonę PDF na górnym pasku, która eksportuje plan miesiąca do wydrukowania lub udostępnienia.';

  @override
  String get helpGoogleMyMapsTitle => 'Mapy terenów w Google My Maps';

  @override
  String get helpGoogleMyMapsBody =>
      'Utwórz mapy swoich terenów w Google My Maps i wklej link udostępniania każdego terenu do jego pola linku do mapy. Przewodnik krok po kroku jest dostępny na GitHubie.';

  @override
  String get helpOpenGuide => 'Otwórz przewodnik';

  @override
  String get helpDataDelayTitle => 'Zmiany mogą pojawić się z opóźnieniem';

  @override
  String get helpDataDelayBody =>
      'Zmiany wprowadzone w aplikacji — na przykład edycje w Głosicielach — mogą stać się widoczne dopiero po około minucie. (Czasami na przykład import S-21 nie pokazuje od razu godzin służby z bieżącego roku służbowego.)';

  @override
  String get helpPwApplyTitle => 'Zgłoś się do świadczenia publicznego';

  @override
  String get helpPwApplyBody =>
      'Otwórz Świadczenie publiczne, znajdź termin i dotknij ikony dłoni, aby się zgłosić; dotknij ponownie, aby się wycofać. Jeśli nie widzisz ikony, poproś administratora o włączenie kwalifikacji «Świadczenie publiczne» w twojej karcie.';

  @override
  String get helpChangeEmailTitle => 'Zmiana adresu e-mail do logowania';

  @override
  String get helpChangeEmailBody =>
      'Nie możesz otworzyć skrzynki, na którą się zarejestrowałeś? W Mój profil dotknij „Zmień e-mail logowania”, podaj nowy adres i swoje hasło. Link potwierdzający trafia tylko do nowej skrzynki — otwórz go, a potem zaloguj się ponownie nowym adresem. Pole e-mail wyżej w profilu to tylko adres kontaktowy; jego zmiana nie zmienia sposobu logowania.';

  @override
  String get helpPwAssignTitle =>
      'Przydziel głosicieli do świadczenia publicznego';

  @override
  String get helpPwAssignBody =>
      'Włącz kwalifikację «Świadczenie publiczne» każdego ochotnika w Głosiciele → otwórz głosiciela → Kwalifikacje. Następnie w Świadczeniu publicznym otwórz termin i dotknij «Przydzieleni»: głosiciele, którzy się zgłosili, są przypięci na górze listy z etykietą «Zgłosił się». Używaj terminów cyklicznych do cotygodniowych wózków lub stoisk.';

  @override
  String get helpS21Title => 'Importuj karty S-21';

  @override
  String get helpS21Body =>
      'Możesz zaimportować Zborowe zestawienie sprawozdań głosiciela (S-21) danego głosiciela z pliku PDF. Otwórz Głosiciele → głosiciel → S-21 i wybierz plik. Odczytywana jest tylko warstwa tekstowa PDF, więc zeskanowane lub spłaszczone formularze mogą się nie zaimportować.';

  @override
  String get helpS99Title => 'Importuj tematy wykładów publicznych (S-99)';

  @override
  String get helpS99Body =>
      'W Tematach wykładów publicznych wybierz «Zaktualizuj tematy z PDF» i wskaż oficjalny formularz S-99 w PDF. Najbliższe zebrania weekendowe odwołujące się do tych numerów wykładów zaktualizują się automatycznie.';

  @override
  String get adminToggleHide => 'Ukryj opcje administratora';

  @override
  String get adminToggleShow => 'Pokaż opcje administratora';

  @override
  String get profileEmailSelfHint =>
      'Adres kontaktowy dla zboru. Aby zmienić adres, którym się logujesz, użyj poniżej „Zmień e-mail logowania”.';

  @override
  String get profileEmailAdminHint =>
      'Adres kontaktowy. Zmiana tutaj nie zmienia adresu, którym loguje się ten głosiciel.';

  @override
  String get profilePhone => 'Numer telefonu';

  @override
  String get profileAddress => 'Adres';

  @override
  String get profileBirthDate => 'Data urodzenia';

  @override
  String get profileBaptismDate => 'Data chrztu';

  @override
  String get profileGender => 'Płeć';

  @override
  String get genderUnknown => '—';

  @override
  String get genderMale => 'Mężczyzna';

  @override
  String get genderFemale => 'Kobieta';

  @override
  String get profileHope => 'Nadzieja';

  @override
  String get hopeOtherSheep => 'Druga owca';

  @override
  String get hopeAnointed => 'Pomazaniec';

  @override
  String get profileStatus => 'Rodzaj służby';

  @override
  String get statusNone => '-';

  @override
  String get statusPublisher => 'Głosiciel';

  @override
  String get statusAuxPioneer => 'Pionier pomocniczy';

  @override
  String get statusRegPioneer => 'Pionier stały';

  @override
  String get statusSpecialPioneer => 'Pionier specjalny';

  @override
  String get statusFieldMissionary => 'Misjonarz terenowy';

  @override
  String get profileAppointment => 'Zamianowanie';

  @override
  String get appointmentMinisterialServant => 'Sługa pomocniczy';

  @override
  String get appointmentElder => 'Starszy';

  @override
  String get profileEmergency => 'Notatka na wypadek nagły';

  @override
  String get profileEmergencyHint => 'Z kim się kontaktować w nagłym wypadku';

  @override
  String get profileSaved => 'Zapisano';

  @override
  String get profileRecord => 'Karta głosiciela';

  @override
  String get profileAwayTitle => 'Okresy nieobecności';

  @override
  String get profileAwayEmpty => 'Nie dodano okresów nieobecności';

  @override
  String get profileAwayAdd => 'Dodaj okres nieobecności';

  @override
  String profileAwayRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String serviceYear(int year) {
    return 'Rok służbowy $year';
  }

  @override
  String get recordTotalHours => 'Łączna liczba godzin';

  @override
  String get recordAverageHours => 'Średnia miesięczna';

  @override
  String get reportMonth => 'Miesiąc';

  @override
  String get reportPublisher => 'Głosiciel';

  @override
  String get reportParticipated => 'Uczestniczył(a) w służbie';

  @override
  String get reportStudies => 'Kursy biblijne';

  @override
  String get reportHours => 'Godziny';

  @override
  String get reportCredit => 'Godziny zaliczone';

  @override
  String get reportComments => 'Komentarze';

  @override
  String get reportParticipatedShort => 'Służba';

  @override
  String get reportStudiesShort => 'Kursy';

  @override
  String get reportAuxShort => 'Pom.';

  @override
  String get reportCreditShort => 'Zalicz.';

  @override
  String get s21Export => 'Eksportuj S-21 (PDF)';

  @override
  String get s21ExportAll => 'Eksportuj S-21 wszystkich (PDF)';

  @override
  String get s21BatchConfirmTitle =>
      'Wyeksportować S-21 wszystkich głosicieli?';

  @override
  String s21BatchConfirmBody(int count, String years) {
    return 'Powstanie jeden plik PDF z $count kartami głosiciela, każda za $years. Plik zawiera dane osobowe — daty urodzenia i chrztu, mianowanie oraz całą historię sprawozdań. Przechowuj go bezpiecznie i udostępniaj tylko tym, którzy go potrzebują. W dużym zborze może to chwilę potrwać.';
  }

  @override
  String get s21BatchGenerating => 'Tworzenie kart S-21…';

  @override
  String get schedulePdfExport => 'Przegląd miesięczny (PDF)';

  @override
  String get pubPdfExport => 'Eksportuj listę (PDF)';

  @override
  String get pubPdfTitle => 'Profile głosicieli';

  @override
  String pubPdfGenerated(String date, int count) {
    return 'Utworzono $date · $count głosicieli';
  }

  @override
  String get pubPdfLegend => 'Legenda';

  @override
  String get pubPdfConfirmTitle => 'Wyeksportować profile głosicieli?';

  @override
  String pubPdfConfirmBody(int count) {
    return 'Plik PDF będzie zawierał dane osobowe $count głosicieli — adresy, numery telefonów, daty urodzenia i chrztu oraz kontakty alarmowe. Przechowuj plik bezpiecznie i udostępniaj go tylko tym, którzy go potrzebują.';
  }

  @override
  String get pubExportScopeTitle => 'Sprawdź, co zostanie wyeksportowane';

  @override
  String pubExportScopeListed(int count) {
    return 'Eksport obejmie $count rekordów obecnie widocznych na liście.';
  }

  @override
  String pubExportScopeMissing(int missing, int total) {
    return '$missing z $total głosicieli w zborze jest odfiltrowanych.';
  }

  @override
  String pubExportScopeExtra(int count) {
    return '$count rekordów na liście to nie są czynni głosiciele — rodzaj służby «-» lub osoby przeniesione.';
  }

  @override
  String get pubExportScopeHint =>
      'Włącz filtr «Głosiciele» i wyczyść pozostałe, aby objąć wszystkich.';

  @override
  String get lmmScheduleTitle => 'Plan zebrań w tygodniu';

  @override
  String get s21Title => 'ZBOROWE ZESTAWIENIE SPRAWOZDAŃ GŁOSICIELA';

  @override
  String get s21Name => 'Imię i nazwisko:';

  @override
  String get s21DateOfBirth => 'Data urodzenia:';

  @override
  String get s21DateOfBaptism => 'Data chrztu:';

  @override
  String get s21HoursHeader => 'Godziny (jeśli pionier lub misjonarz terenowy)';

  @override
  String get s21Remarks => 'Uwagi';

  @override
  String get s21Total => 'Ogółem';

  @override
  String get s21FormCode => 'S-21-P 11/23';

  @override
  String s21Credit(int hours) {
    return 'Kredyt: $hours';
  }

  @override
  String get s21Import => 'Importuj S-21 (PDF)';

  @override
  String get s21ImportNew => 'Importuj głosiciela z S-21';

  @override
  String get s21ImportTitle => 'Importuj S-21';

  @override
  String get s21ImportPickFile => 'Wybierz plik PDF';

  @override
  String get s21ImportHint =>
      'Wybierz kartę głosiciela S-21 (PDF). Wartości z karty zastępują pola profilu głosiciela oraz sprawozdania miesięczne.';

  @override
  String get s21ImportNoData => 'Nie znaleziono danych S-21 w tym pliku.';

  @override
  String s21ImportMonths(int count) {
    return 'Znaleziono $count sprawozdań miesięcznych';
  }

  @override
  String s21ImportNameKept(String name) {
    return 'Imię i nazwisko w aplikacji zostaje zachowane: $name';
  }

  @override
  String s21ImportCardName(String name) {
    return 'Imię i nazwisko na karcie: $name';
  }

  @override
  String s21ImportDuplicateName(String name) {
    return 'Głosiciel o imieniu i nazwisku «$name» już istnieje.';
  }

  @override
  String get s21ImportUseExisting => 'Importuj do istniejącej karty';

  @override
  String get s21ImportReplaceTitle => 'Zastąpić istniejące karty?';

  @override
  String get s21ImportReplaceBody =>
      'Pola profilu głosiciela oraz sprawozdania miesięczne z importowanych lat służbowych zostaną zastąpione wartościami z tego S-21. Tej operacji nie można cofnąć.';

  @override
  String get s21ImportSave => 'Importuj';

  @override
  String get s21ImportDone => 'Zaimportowano S-21.';

  @override
  String get s21ImportAssignYear => 'Rok służbowy tej tabeli';

  @override
  String get pubAdminInvite => 'Zaproś';

  @override
  String get pubAdminInviteTitle => 'Zaproś do zboru';

  @override
  String get pubAdminInviteBody =>
      'Nowy członek skanuje ten kod QR w aplikacji, rejestruje się, a następnie pojawia się poniżej jako niezweryfikowany. Zweryfikuj go, aby przyznać dostęp.';

  @override
  String get pubAdminAddRecord => 'Dodaj kartę głosiciela';

  @override
  String get pubAdminAddRecordHint =>
      'Karta dla członka, który nie będzie korzystać z aplikacji; sprawozdania mogą wprowadzać administratorzy.';

  @override
  String get pubAdminVerified => 'Zweryfikowany';

  @override
  String get pubAdminUnverifiedBadge => 'Oczekuje na weryfikację';

  @override
  String get pubAdminNoAccountBadge => 'Brak konta w aplikacji';

  @override
  String get pubAdminTabProfile => 'Profil';

  @override
  String get pubAdminTabRoles => 'Uprawnienia';

  @override
  String get pubAdminTabAssign => 'Przydziel';

  @override
  String get pubAdminTabRecord => 'Karta';

  @override
  String get pubAdminDeleteConfirm =>
      'Usunąć tego głosiciela i jego dane prywatne? Jego sprawozdania pozostają zapisane.';

  @override
  String get pubAdminDeleteMovedHint =>
      'Jeśli ma konto w aplikacji, usunięcie nie usuwa danych logowania i mógłby zalogować się ponownie. Aby zarchiwizować kogoś, kto się przeprowadził, użyj zamiast tego «Oznacz jako przeniesiony».';

  @override
  String get pubAdminMarkMoved => 'Oznacz jako przeniesiony';

  @override
  String get pubAdminRestoreMoved => 'Przywróć z przeniesionych';

  @override
  String get pubAdminMovedBadge => 'Przeniesiony';

  @override
  String get pubAdminShowMoved => 'Pokaż przeniesionych';

  @override
  String get pubAdminMovingDate => 'Data przeprowadzki';

  @override
  String get pubAdminChangeMovingDate => 'Zmień datę przeprowadzki';

  @override
  String pubAdminMovedOn(String date) {
    return 'Przeprowadził się $date';
  }

  @override
  String pubAdminMovingOn(String date) {
    return 'Przeprowadza się $date';
  }

  @override
  String get pubAdminMovedHint =>
      'Karta i historia sprawozdań są zachowane. Miesiące sprzed przeprowadzki nadal liczą się w statystykach i w S-1.';

  @override
  String get pubAdminMovedNoDateHint =>
      'Nie zapisano daty przeprowadzki, więc żadne z jego sprawozdań nie liczy się w statystykach ani w S-1. Podaj datę, aby odzyskać miesiące, w których jeszcze tu był.';

  @override
  String get pubAdminMovePendingHint =>
      'Do tego dnia pozostaje pełnoprawnym członkiem: plany, listy sprawozdań i dostęp do aplikacji nie zmieniają się.';

  @override
  String get pubFilterPublishers => 'Głosiciele';

  @override
  String get pubFilterPioneers => 'Pionierzy';

  @override
  String get pubFilterHasRights => 'Z uprawnieniami';

  @override
  String get pubFilterAnyGroup => 'Dowolna grupa';

  @override
  String get pubFilterClear => 'Wyczyść';

  @override
  String get pubAdminMoveConfirmTitle => 'Oznaczyć jako przeniesiony?';

  @override
  String pubAdminMoveConfirmBody(String date) {
    return 'Data przeprowadzki: $date. Karta i historia sprawozdań są zachowane — wszystko do tego dnia nadal liczy się w statystykach i w S-1. Od tego dnia głosiciel zostaje zarchiwizowany: jego dostęp jest odbierany i nie pojawia się już w planach ani na listach sprawozdań. Możesz go później przywrócić.';
  }

  @override
  String pubAdminMoveConfirmFutureBody(String date) {
    return 'Data przeprowadzki: $date. Do tego czasu nic się nie zmienia — głosiciel zachowuje dostęp do aplikacji i pozostaje w planach oraz na listach sprawozdań. Tego dnia zostanie automatycznie zarchiwizowany; jego karta i historia sprawozdań są zachowane.';
  }

  @override
  String get pubAdminSelfVerifiedWarningTitle =>
      'Wyłączyć własny status Zweryfikowany?';

  @override
  String get pubAdminSelfVerifiedWarningBody =>
      'Usuwasz status Zweryfikowany z własnego konta. Natychmiast utracisz dostęp do danych zboru i tylko inny pełny administrator będzie mógł go przywrócić. Czy na pewno chcesz kontynuować?';

  @override
  String get pubAdminSelfFullAdminWarningTitle =>
      'Usunąć własne uprawnienia pełnego administratora?';

  @override
  String get pubAdminSelfFullAdminWarningBody =>
      'Usuwasz rolę pełnego administratora z własnego konta. Jeśli jesteś jedynym administratorem, nikt — łącznie z tobą — nie będzie mógł tego cofnąć. Czy na pewno chcesz kontynuować?';

  @override
  String get pubAdminSelfWarningConfirm => 'Usuń mój dostęp';

  @override
  String get pubConnectBanner =>
      'To konto oczekuje na weryfikację. Jeśli administrator utworzył już kartę głosiciela dla tej osoby, połącz je: historia karty przechodzi na to konto, a zduplikowana karta znika.';

  @override
  String get pubConnectAction => 'Połącz z istniejącą kartą';

  @override
  String get pubConnectNeedsFullAdmin =>
      'Tylko pełny administrator może łączyć karty (migracja dotyka danych każdej sekcji).';

  @override
  String get pubConnectPickTitle => 'Połącz z istniejącą kartą';

  @override
  String pubConnectPickHint(String name) {
    return 'Wybierz kartę należącą do $name.';
  }

  @override
  String get pubConnectNoRecords =>
      'Nie ma żadnej karty głosiciela bez konta w aplikacji do połączenia.';

  @override
  String get pubConnectConfirmTitle => 'Połączyć i scalić?';

  @override
  String pubConnectConfirmBody(String record, String account) {
    return 'Cała historia «$record» — sprawozdania, tereny i przydziały w planach — zostanie przeniesiona na konto «$account». Konto staje się zweryfikowane, a zduplikowana karta jest trwale usuwana. Tej operacji nie można cofnąć.';
  }

  @override
  String get pubConnectProgressTitle => 'Łączenie karty…';

  @override
  String get pubConnectProgressBody =>
      'Nie zamykaj aplikacji podczas przenoszenia historii.';

  @override
  String pubConnectFailed(String section) {
    return 'Łączenie nie powiodło się w: $section. Ukończone kroki są zachowane — ponowna próba jest bezpieczna i kontynuuje od miejsca zatrzymania.';
  }

  @override
  String get pubConnectSuccess =>
      'Karta połączona — jej historia należy teraz do tego konta.';

  @override
  String get roleFullAdmin => 'Pełny administrator';

  @override
  String get roleRecordAttendance => 'Rejestruj obecność';

  @override
  String get weekNoSchedule => 'Brak jeszcze planu na ten tydzień.';

  @override
  String get weekCreateEmpty => 'Utwórz pusty tydzień';

  @override
  String get weekImportEpub => 'Importuj z pliku .epub';

  @override
  String get weekCheckCdn => 'Sprawdź online';

  @override
  String get weekDelete => 'Usuń ten tydzień';

  @override
  String get weekShowToPublishers => 'Pokaż głosicielom';

  @override
  String get weekShowToPublishersOn => 'Głosiciele widzą, kto ma zadanie.';

  @override
  String get weekShowToPublishersOff => 'Głosiciele widzą program bez nazwisk.';

  @override
  String get lmmSongs => 'Pieśni';

  @override
  String get sectionOpening => 'Otwarcie';

  @override
  String get sectionTreasures => 'SKARBY ZE SŁOWA BOŻEGO';

  @override
  String get sectionMinistry => 'ULEPSZAJMY SWOJĄ SŁUŻBĘ';

  @override
  String get sectionLiving => 'CHRZEŚCIJAŃSKI TRYB ŻYCIA';

  @override
  String get sectionClosing => 'Zakończenie';

  @override
  String get partChairman => 'Przewodniczący';

  @override
  String get partOpeningPrayer => 'Modlitwa początkowa';

  @override
  String get partClosingPrayer => 'Modlitwa końcowa';

  @override
  String get partGems => 'Duchowe skarby';

  @override
  String get partBibleReading => 'Czytanie Biblii';

  @override
  String get partCbs => 'Zborowe studium Biblii';

  @override
  String get partCbsReader => 'Lektor';

  @override
  String get partAssistant => 'Pomocnik';

  @override
  String partMinutes(int min) {
    return '$min min';
  }

  @override
  String get lmmClassMain => 'Sala główna';

  @override
  String lmmClassN(int index) {
    return 'Grupa $index';
  }

  @override
  String get partEdit => 'Edytuj część';

  @override
  String get partTitle => 'Tytuł';

  @override
  String get partDescription => 'Opis';

  @override
  String get partDuration => 'Czas trwania (min)';

  @override
  String get partAdd => 'Dodaj część';

  @override
  String get partDeleteConfirm => 'Usunąć tę część?';

  @override
  String get supportAttendants => 'Porządkowi';

  @override
  String get supportMicrophones => 'Mikrofony';

  @override
  String get supportAudioVideo => 'Audio-wideo';

  @override
  String get customAssignmentAdd => 'Dodaj niestandardowe zadanie';

  @override
  String get customLabel => 'Etykieta';

  @override
  String get customAssignmentPermanent => 'Stałe (co tydzień)';

  @override
  String get customAssignmentRemovePermanentTitle => 'Usuń stałe zadanie';

  @override
  String customAssignmentRemovePermanentBody(String label) {
    return 'Usunąć «$label» z każdego tygodnia?';
  }

  @override
  String get pickerQualified => 'Wykwalifikowani';

  @override
  String get pickerAll => 'Wszyscy';

  @override
  String get pickerFreeText => 'Tekst';

  @override
  String pickerLastAssigned(String date) {
    return 'Ostatnio: $date';
  }

  @override
  String get pickerNever => 'Nigdy nie przydzielono';

  @override
  String get pickerApplied => 'Zgłosił się';

  @override
  String pickerAwayWarning(String range) {
    return 'Nieobecny $range';
  }

  @override
  String get importTitle => 'Importuj Skoroszyt zebrania';

  @override
  String get importNoWeeks => 'Nie znaleziono użytecznych tygodni w tym pliku.';

  @override
  String get importWeekExists =>
      'Już istnieje — plan zostanie zaktualizowany, przydziały zachowane';

  @override
  String importSave(int count) {
    return 'Importuj $count tygodni';
  }

  @override
  String get importDone => 'Zaimportowano.';

  @override
  String get importCdnNothing =>
      'Żaden numer skoroszytu nie jest jeszcze dostępny online.';

  @override
  String get weekendTalkTitle => 'Wykład publiczny';

  @override
  String get weekendSpeaker => 'Mówca';

  @override
  String get weekendChairmanLabel => 'Przewodniczący';

  @override
  String get weekendWtReader => 'Lektor Strażnicy';

  @override
  String get customFieldAdd => 'Dodaj pole planu';

  @override
  String get pickerFromCatalog => 'Z listy';

  @override
  String get talksUpdateFromPdf => 'Zaktualizuj tematy z PDF';

  @override
  String get talksPickPdf => 'Wybierz PDF S-99';

  @override
  String get talksParseError =>
      'Nie udało się odczytać tematów wykładów z tego pliku. Użyj oficjalnego formularza S-99 w PDF.';

  @override
  String talksImportSummary(int total, int added, int changed, int removed) {
    return 'Znaleziono $total wykładów: $added nowych, $changed zmienionych, $removed usuniętych';
  }

  @override
  String get talksImportSave => 'Zapisz tematy';

  @override
  String talksImportDone(int count) {
    return 'Zapisano tematy. Zaktualizowano $count najbliższych zebrań.';
  }

  @override
  String talksLastDelivered(String date) {
    return 'Ostatnio wygłoszony $date';
  }

  @override
  String get talksNeverDelivered => 'Jeszcze nie wygłoszony';

  @override
  String get talksScheduled => 'zaplanowany';

  @override
  String get talksNew => 'Nowy';

  @override
  String get talksChanged => 'Zmieniony';

  @override
  String get talksRemoved => 'Usunięty';

  @override
  String get talksSearchHint => 'Szukaj wykładów…';

  @override
  String get talksEmpty =>
      'Brak jeszcze tematów wykładów. Zaimportuj je z pliku PDF S-99.';

  @override
  String get talksOpenCatalog => 'Zarządzaj tematami wykładów';

  @override
  String get talksEditTitle => 'Edytuj temat';

  @override
  String get songLabel => 'Pieśń';

  @override
  String get songsSearchHint => 'Szukaj pieśni…';

  @override
  String get songsEmpty =>
      'Brak jeszcze listy pieśni. Zaktualizuj ją z oficjalnej strony.';

  @override
  String get songsUpdateFromWeb =>
      'Zaktualizuj listę pieśni z oficjalnej strony';

  @override
  String songsUpdateDone(int count) {
    return 'Zaktualizowano listę pieśni: $count pieśni.';
  }

  @override
  String get songsCdnNothing =>
      'Lista pieśni nie jest jeszcze dostępna online.';

  @override
  String get songsStatusEmpty => 'Nie zaimportowano jeszcze listy pieśni.';

  @override
  String songsStatusLoaded(int count, String date) {
    return '$count pieśni · zaktualizowano $date';
  }

  @override
  String get settingsSongsSection => 'Lista pieśni';

  @override
  String get settingsSongsDescription =>
      'Pobierz tytuły pieśni na zebrania z jw.org, aby można je było wybierać w planach weekendowych i tygodniowych.';

  @override
  String get pwNoSlots => 'Brak świadczenia publicznego w tym tygodniu.';

  @override
  String get pwAddSlot => 'Dodaj termin';

  @override
  String get pwEditSlot => 'Edytuj termin';

  @override
  String get pwLocation => 'Miejsce';

  @override
  String get pwTimeFrom => 'Od';

  @override
  String get pwTimeTo => 'Do';

  @override
  String get pwRecurringRules => 'Terminy cykliczne';

  @override
  String get pwRecurringAdd => 'Dodaj termin cykliczny';

  @override
  String get pwWeekday => 'Dzień tygodnia';

  @override
  String get pwValidFrom => 'Ważne od';

  @override
  String get pwValidUntil => 'Ważne do (opcjonalnie)';

  @override
  String get pwAssignees => 'Przydzieleni';

  @override
  String get pwDate => 'Data';

  @override
  String get pwApply => 'Zgłoś się na ten termin';

  @override
  String get pwWithdraw => 'Wycofaj zgłoszenie';

  @override
  String get pwRecurringDeleteConfirm =>
      'Usunąć ten termin cykliczny? Jego przyszłe terminy również zostaną usunięte wraz ze zgłoszeniami na nie. Tej operacji nie można cofnąć.';

  @override
  String get pwRemoveAllFutureAction => 'Usuń wszystkie przyszłe terminy';

  @override
  String get pwRemoveAllFutureWarning =>
      'Usunięcie wszystkich przyszłych terminów kasuje każdy nadchodzący termin jednorazowy i cykliczny i nie można tego cofnąć.';

  @override
  String get pwRemoveAllFutureTitle => 'Usunąć wszystkie przyszłe terminy?';

  @override
  String get pwRemoveAllFutureBody =>
      'Spowoduje to usunięcie wszystkich nadchodzących terminów jednorazowych i cyklicznych, wycofanie zgłoszeń na nie oraz usunięcie wszystkich reguł terminów cyklicznych, aby nie pojawiły się ponownie. Wcześniejsze terminy zostaną zachowane. Tej operacji nie można cofnąć.';

  @override
  String get pwRemoveAllFutureConfirm => 'Usuń wszystkie';

  @override
  String get pwDeleteFromWeekTooltip => 'Usuń terminy od tego tygodnia';

  @override
  String pwDeleteFromWeekTitle(String week) {
    return 'Usunąć terminy od $week?';
  }

  @override
  String get pwDeleteFromWeekBody =>
      'Spowoduje to usunięcie wszystkich terminów jednorazowych i cyklicznych od wybranego tygodnia wzwyż, wycofanie zgłoszeń na nie oraz zakończenie terminów cyklicznych w tym miejscu, aby nie pojawiły się ponownie. Wcześniejsze terminy zostaną zachowane. Tej operacji nie można cofnąć.';

  @override
  String get pwDeleteFromWeekDone => 'Terminy zostały usunięte.';

  @override
  String pwApplicants(int count) {
    return 'zgłoszeń: $count';
  }

  @override
  String get fsmNoMeetings => 'Brak zbiórek do służby w tym tygodniu.';

  @override
  String get fsmAddMeeting => 'Dodaj zbiórkę';

  @override
  String get fsmEditMeeting => 'Edytuj zbiórkę';

  @override
  String get fsmDate => 'Data';

  @override
  String get fsmTime => 'Godzina';

  @override
  String get fsmLocation => 'Miejsce';

  @override
  String get fsmNote => 'Notatka';

  @override
  String get fsmConductor => 'Prowadzący';

  @override
  String get fsmRecurringRules => 'Zbiórki cykliczne';

  @override
  String get fsmRecurringAdd => 'Dodaj zbiórkę cykliczną';

  @override
  String get fsmWeekday => 'Dzień tygodnia';

  @override
  String get fsmValidFrom => 'Ważne od';

  @override
  String get fsmValidUntil => 'Ważne do (opcjonalnie)';

  @override
  String get fsmRecurringDeleteConfirm =>
      'Usunąć tę cykliczną zbiórkę? Jej przyszłe zbiórki również zostaną usunięte. Tej operacji nie można cofnąć.';

  @override
  String get fsmRemoveAllFutureAction => 'Usuń wszystkie przyszłe zbiórki';

  @override
  String get fsmRemoveAllFutureWarning =>
      'Usunięcie wszystkich przyszłych zbiórek kasuje każdą nadchodzącą zbiórkę jednorazową i cykliczną i nie można tego cofnąć.';

  @override
  String get fsmRemoveAllFutureTitle => 'Usunąć wszystkie przyszłe zbiórki?';

  @override
  String get fsmRemoveAllFutureBody =>
      'Ta operacja kasuje każdą nadchodzącą jednorazową i cykliczną zbiórkę do służby oraz usuwa wszystkie reguły zbiórek cyklicznych, aby żadna nie została wygenerowana ponownie. Zbiórki z przeszłości są zachowane. Tej operacji nie można cofnąć.';

  @override
  String get fsmRemoveAllFutureConfirm => 'Usuń wszystkie';

  @override
  String get fsmDeleteFromWeekTooltip => 'Usuń zbiórki od tego tygodnia';

  @override
  String fsmDeleteFromWeekTitle(String week) {
    return 'Usunąć zbiórki od $week?';
  }

  @override
  String get fsmDeleteFromWeekBody =>
      'Spowoduje to usunięcie wszystkich jednorazowych i cyklicznych zbiórek od wybranego tygodnia wzwyż oraz zakończenie zbiórek cyklicznych w tym miejscu, aby nie pojawiły się ponownie. Wcześniejsze zbiórki zostaną zachowane. Tej operacji nie można cofnąć.';

  @override
  String get fsmDeleteFromWeekDone => 'Zbiórki zostały usunięte.';

  @override
  String get eventsUpcoming => 'Nadchodzące wydarzenia';

  @override
  String get eventsNone => 'Brak nadchodzących wydarzeń.';

  @override
  String get eventAdd => 'Dodaj wydarzenie';

  @override
  String get eventEdit => 'Edytuj wydarzenie';

  @override
  String get eventTitle => 'Tytuł';

  @override
  String get eventType => 'Typ';

  @override
  String get eventTypeConvention => 'Kongres regionalny';

  @override
  String get eventTypeAssembly => 'Zgromadzenie obwodowe';

  @override
  String get eventTypeMemorial => 'Pamiątka';

  @override
  String get eventTypeCoVisit => 'Wizyta nadzorcy obwodu';

  @override
  String get meetingWeekChanged => 'Zmienione na ten tydzień';

  @override
  String get weekPickTooltip => 'Wybierz tydzień';

  @override
  String get meetingWeekEditTooltip => 'Zmień dzień i godzinę w tym tygodniu';

  @override
  String get coNotScheduledYet => 'Termin jeszcze nieustalony';

  @override
  String get meetingWeekDifferent => 'Inny dzień lub godzina w tym tygodniu';

  @override
  String meetingWeekFollows(String day, String time) {
    return 'Zwykle $day, $time';
  }

  @override
  String get meetingWeekDay => 'Dzień';

  @override
  String get meetingWeekTime => 'Godzina';

  @override
  String get coVisitNotPublished =>
      'Wizyta nadzorcy obwodu nie została jeszcze opublikowana.';

  @override
  String get coVisitNonePlanned => 'Nie zaplanowano jeszcze żadnej wizyty.';

  @override
  String get coVisitSetWeek => 'Wybierz tydzień wizyty';

  @override
  String get coVisitDelete => 'Usuń wizytę';

  @override
  String get coVisitDeleteConfirm =>
      'Usunąć tę wizytę i wszystko, co dla niej zaplanowano? Zbiórki do służby z tego tygodnia zostaną zachowane. Tej operacji nie można cofnąć.';

  @override
  String get coVisitVisibleToPublishers => 'Pokaż głosicielom';

  @override
  String get coVisitVisibleOn => 'Głosiciele widzą wizytę.';

  @override
  String get coVisitVisibleOff => 'Wizytę widzą tylko administratorzy.';

  @override
  String get coSectionMeal => 'Obiady';

  @override
  String get coSectionShepherding => 'Wizyty pasterskie';

  @override
  String get coSectionPioneers => 'Spotkanie z pionierami';

  @override
  String get coSectionElders => 'Spotkanie ze starszymi i sługami pomocniczymi';

  @override
  String get coSectionOther => 'Inne';

  @override
  String get coSectionEmpty => 'Nic jeszcze nie zaplanowano.';

  @override
  String get coSectionHidden => 'Ukryte';

  @override
  String get coSectionHide => 'Ukryj przed głosicielami';

  @override
  String get coSectionShow => 'Pokaż głosicielom';

  @override
  String get coWithCo => 'Służba z nadzorcą obwodu';

  @override
  String get coWithCoWife => 'Służba z jego żoną';

  @override
  String get coDay => 'Dzień';

  @override
  String get coTime => 'Godzina';

  @override
  String get coAddress => 'Adres';

  @override
  String get coNote => 'Uwagi';

  @override
  String get coAssigned => 'Głosiciele';

  @override
  String get coMinistryOtherAdmins =>
      'Zbiórki do służby edytują ich właśni administratorzy.';

  @override
  String get coMidweekOtherAdmins =>
      'Dzień zebrania w tygodniu ustalają administratorzy tego programu.';

  @override
  String get coMidweekNotMoved =>
      'Zebranie w tygodniu nie zostało przeniesione na wtorek – ustalają to administratorzy tego programu.';

  @override
  String get coPrintTitle => 'Wydrukuj program wizyty';

  @override
  String get coPrintIncludeHiddenBody =>
      'Niektóre sekcje są ukryte przed głosicielami. Wydrukować je również?';

  @override
  String get coPrintIncludeHidden => 'Razem z ukrytymi';

  @override
  String get coPrintVisibleOnly => 'Tylko widoczne';

  @override
  String get eventTypeOther => 'Inne';

  @override
  String get eventDateFrom => 'Od';

  @override
  String get eventDateTo => 'Do (opcjonalnie)';

  @override
  String get eventLocation => 'Miejsce';

  @override
  String get eventNotes => 'Notatki';

  @override
  String get eventAddToCalendar => 'Dodaj do kalendarza';

  @override
  String get myAssignments => 'Moje najbliższe zadania';

  @override
  String get myAssignmentsNone => 'Brak nadchodzących zadań.';

  @override
  String get remindersTitle => 'Przypomnienia o zadaniach';

  @override
  String get remindersDescription =>
      'Otrzymuj powiadomienie na tym urządzeniu przed każdym ze swoich najbliższych zadań. Zmiany wprowadzone przy zamkniętej aplikacji są pobierane przy jej następnym otwarciu.';

  @override
  String get remindersEnable => 'Włącz przypomnienia';

  @override
  String get remindersAdd => 'Dodaj przypomnienie';

  @override
  String get reminderUnitMinutes => 'minut wcześniej';

  @override
  String get reminderUnitHours => 'godzin wcześniej';

  @override
  String get reminderUnitDays => 'dni wcześniej';

  @override
  String get remindersPermissionDenied =>
      'Powiadomienia nie są dozwolone dla tej aplikacji. Włącz je w ustawieniach systemu, aby korzystać z przypomnień.';

  @override
  String get remindersChannelName => 'Przypomnienia o zadaniach';

  @override
  String get remindersChannelDescription =>
      'Powiadomienia przed twoimi zadaniami w zborze';

  @override
  String get roleAssistant => 'Pomocnik';

  @override
  String get rolePw => 'Świadczenie publiczne';

  @override
  String get roleFsm => 'Zbiórka do służby';

  @override
  String get reportSubmit => 'Wyślij sprawozdanie';

  @override
  String reportSubmittedAt(String date) {
    return 'Wysłano $date';
  }

  @override
  String get reportSaved => 'Zapisano sprawozdanie.';

  @override
  String get reportMissing => 'Nie wysłano';

  @override
  String get reportEmpty => 'Pusty raport — brak służby';

  @override
  String get reportNotCountedMoved => 'Przeprowadził się — nie liczy się';

  @override
  String get reportFormerMember => 'Były członek';

  @override
  String reportEnterFor(String name) {
    return 'Wprowadź sprawozdanie — $name';
  }

  @override
  String reportSummaryReported(int reported, int total) {
    return 'Zgłosiło: $reported / $total';
  }

  @override
  String get reportCheckTitle => 'Sprawdź sprawozdanie';

  @override
  String get reportCheckPioneerNoHours =>
      'W sprawozdaniu pioniera nie podano godzin. Wpisz 0, jeśli naprawdę nie było czasu w służbie.';

  @override
  String get reportCheckWasActiveLastMonth =>
      'Nie zaznaczono „Udział w służbie”, choć w poprzednim miesiącu służba została zgłoszona.';

  @override
  String get reportCheckQuestion => 'Zapisać sprawozdanie mimo to?';

  @override
  String get reportSaveAnyway => 'Zapisz mimo to';

  @override
  String get reportStatusThisMonth => 'Status w tym miesiącu';

  @override
  String get attAdd => 'Rejestruj obecność';

  @override
  String get attInPerson => 'Osobiście';

  @override
  String get attOnline => 'Online';

  @override
  String get attTotal => 'Razem';

  @override
  String get attMeetingLmm => 'Zebranie w tygodniu';

  @override
  String get attMeetingWeekend => 'Zebranie w weekend';

  @override
  String get attOverview => 'Średnie miesięczne';

  @override
  String get attHistory => 'Poprzednie zebrania';

  @override
  String get attNotFilled => 'Nie zarejestrowano';

  @override
  String get attMismatch => 'Liczby się nie zgadzają.';

  @override
  String attRecordedOf(int filled, int expected) {
    return 'zarejestrowano $filled/$expected';
  }

  @override
  String get attSaved => 'Zapisano obecność.';

  @override
  String get attRecordExport => 'Eksportuj zestawienie obecności (PDF)';

  @override
  String get attRecordDialogTitle => 'Eksportuj zestawienie obecności';

  @override
  String attRecordCovers(String years) {
    return 'Obejmuje $years';
  }

  @override
  String get attRecordTitle => 'ZESTAWIENIE OBECNOŚCI NA ZEBRANIACH ZBOROWYCH';

  @override
  String get attRecordColMeetings => 'Liczba zebrań';

  @override
  String get attRecordColTotal => 'Ogółem obecnych';

  @override
  String get attRecordColAvgWeek => 'Śr. obecnych w każdym tygodniu';

  @override
  String get attRecordRowAvgMonth => 'Śr. obecności w każdym miesiącu';

  @override
  String get statMembershipTitle => 'Głosiciele';

  @override
  String get statTotalMembers => 'Wszyscy głosiciele';

  @override
  String get statPioneers => 'Pionierzy';

  @override
  String get statAgeTitle => 'Rozkład wieku';

  @override
  String get statAgeAverage => 'Średni wiek';

  @override
  String statAgeKnownDetail(int known, int total) {
    return 'Na podstawie $known z $total znanych dat urodzenia';
  }

  @override
  String get statAgeUnder18 => 'Poniżej 18 lat';

  @override
  String get statAgeUnknown => 'Nieznany';

  @override
  String get statAttendanceTitle => 'Obecność na zebraniach';

  @override
  String get statAvg3Months => 'Śr. z 3 miesięcy';

  @override
  String get statAvg12Months => 'Śr. z 12 miesięcy';

  @override
  String get statFieldServiceTitle => 'Służba polowa';

  @override
  String statServiceYear(String year) {
    return 'Rok służbowy $year';
  }

  @override
  String get statReportsSubmitted => 'Wysłane sprawozdania';

  @override
  String get statParticipated => 'Uczestniczyli w służbie';

  @override
  String get statPioneerHours => 'Godziny pionierów';

  @override
  String get statPublisherHours => 'Godziny głosicieli';

  @override
  String get statTerrCompleted => 'Ukończone';

  @override
  String get statTerrAvgDays => 'Śr. dni do ukończenia';

  @override
  String get statTerrCovered => 'Opracowane w roku służbowym';

  @override
  String get statTerrNotCovered => 'Nieopracowane w roku służbowym';

  @override
  String get statTerrPerMonth => 'Ukończone w poszczególnych miesiącach';

  @override
  String get statUsageTitle => 'Korzystanie z aplikacji';

  @override
  String get statWithAccount => 'Z kontem w aplikacji';

  @override
  String get statSelfReported =>
      'Sprawozdania wysłane samodzielnie (w zeszłym miesiącu)';

  @override
  String get statAwaiting => 'Oczekujący na weryfikację';

  @override
  String get statFullAdmins => 'Pełni administratorzy';

  @override
  String get statSectionAdmins => 'Administratorzy sekcji';

  @override
  String get statNoData => 'Brak jeszcze danych';

  @override
  String get terrMine => 'Moje tereny';

  @override
  String get terrNoMine => 'Nie przydzielono ci żadnego terenu.';

  @override
  String get terrAll => 'Wszystkie tereny';

  @override
  String terrAssignedOn(String date) {
    return 'Przydzielono $date';
  }

  @override
  String get terrReturn => 'Zwróć';

  @override
  String get terrReturnTitle => 'Zwróć teren';

  @override
  String get terrReturnNotes => 'Notatki (opcjonalnie)';

  @override
  String get terrMap => 'Mapa';

  @override
  String get terrAdd => 'Dodaj teren';

  @override
  String get terrEdit => 'Edytuj teren';

  @override
  String get terrName => 'Nazwa';

  @override
  String get terrNameDuplicate => 'Teren o tej nazwie już istnieje.';

  @override
  String get terrMapUrl => 'Link do mapy (np. Google My Maps)';

  @override
  String get terrNotes => 'Notatki';

  @override
  String get terrAssignTo => 'Przydziel do…';

  @override
  String terrHolder(String name, String date) {
    return '$name — od $date';
  }

  @override
  String get terrFree => 'Nieprzydzielony';

  @override
  String get terrStats => 'Statystyki';

  @override
  String get terrStatsTotal => 'Razem';

  @override
  String get terrStatsAssigned => 'Obecnie przydzielone';

  @override
  String get terrStatsFinished => 'Ukończone w okresie';

  @override
  String get terrRemoveAssignment => 'Usuń przydział';

  @override
  String get terrImportTitle => 'Importuj tereny';

  @override
  String get terrImportPasteHint =>
      'Wklej wiersze z Excela lub Arkuszy Google. Kolumny: nazwa, link do mapy, notatki — wymagana jest tylko nazwa.';

  @override
  String get terrImportPreview => 'Podgląd';

  @override
  String get terrImportPickFile => 'Wybierz plik CSV';

  @override
  String terrImportSummary(
    int total,
    int newCount,
    int duplicates,
    int invalid,
  ) {
    return '$total wierszy: $newCount nowych, $duplicates istniejących, $invalid nieprawidłowych';
  }

  @override
  String get terrImportUpdateExisting =>
      'Aktualizuj istniejące tereny (dopasowanie po nazwie) zamiast je pomijać';

  @override
  String get terrImportBadgeNew => 'Nowy';

  @override
  String get terrImportBadgeSkip => 'Pomiń';

  @override
  String get terrImportBadgeUpdate => 'Aktualizuj';

  @override
  String get terrImportBadgeInvalid => 'Brak nazwy';

  @override
  String get terrImportBadgeDupRow => 'Zduplikowany wiersz';

  @override
  String terrImportLine(int line) {
    return 'Wiersz $line';
  }

  @override
  String terrImportSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importuj $count terenu',
      many: 'Importuj $count terenów',
      few: 'Importuj $count tereny',
      one: 'Importuj 1 teren',
    );
    return '$_temp0';
  }

  @override
  String terrImportDone(int created, int updated) {
    return 'Zaimportowano $created nowych, zaktualizowano $updated.';
  }

  @override
  String get terrImportEmpty => 'Nie znaleziono wierszy w danych wejściowych.';

  @override
  String get terrDeleteConfirm =>
      'Usunąć ten teren? Tej operacji nie można cofnąć.';

  @override
  String get terrSortByTerritory => 'Teren';

  @override
  String get terrSortByPublisher => 'Głosiciel';

  @override
  String get terrSortByDate => 'Data przydziału';

  @override
  String get terrHolderDeleted => 'Usunięty głosiciel';

  @override
  String get terrHistoryOngoing => 'Bieżący';

  @override
  String get terrHistoryEmpty => 'Brak jeszcze historii przydziałów.';

  @override
  String get terrAsgAddPast => 'Dodaj wcześniejszy przydział';

  @override
  String get terrAsgEdit => 'Edytuj przydział';

  @override
  String get terrAsgHolder => 'Głosiciel';

  @override
  String get terrAsgHolderNone => 'Wybierz głosiciela…';

  @override
  String get terrAsgPickTitle => 'Kto miał ten teren?';

  @override
  String get terrAsgDateAssigned => 'Data przydziału';

  @override
  String get terrAsgDateReturned => 'Data zwrotu';

  @override
  String get terrAsgStillOut => 'Jeszcze nie zwrócony';

  @override
  String get terrAsgErrHolderRequired =>
      'Wybierz głosiciela lub wpisz imię i nazwisko.';

  @override
  String get terrAsgErrDateRequired => 'Wybierz datę przydzielenia terenu.';

  @override
  String get terrAsgErrReturnBeforeAssigned =>
      'Data zwrotu nie może być wcześniejsza niż data przydziału.';

  @override
  String get terrAsgErrAlreadyOpen =>
      'Ten teren jest już przydzielony. Podaj datę zwrotu dla tego przydziału albo najpierw zwróć bieżący.';

  @override
  String get terrAsgDeleteConfirm =>
      'Usunąć ten przydział z historii terenu? Tej operacji nie można cofnąć.';

  @override
  String get terrRecordExport =>
      'Eksportuj zestawienie przydziałów terenów (PDF)';

  @override
  String get terrRecordDialogTitle =>
      'Eksportuj zestawienie przydziałów terenów';

  @override
  String get terrRecordTitle => 'ZESTAWIENIE PRZYDZIAŁÓW TERENÓW';

  @override
  String get terrRecordColTerritory => 'Teren';

  @override
  String get terrRecordColLastCompleted => 'Data ostatniego opracowania*';

  @override
  String get terrRecordColAssignedTo => 'Przydzielono:';

  @override
  String get terrRecordColDateAssigned => 'Data przydziału';

  @override
  String get terrRecordColDateCompleted => 'Data opracowania';

  @override
  String get terrRecordFootnote =>
      '* Rozpoczynając nowy arkusz, wpisz w tej kolumnie datę, kiedy ostatnio opracowano każdy teren.';

  @override
  String get mgEmpty => 'Brak jeszcze grup służby.';

  @override
  String get mgAdd => 'Dodaj grupę';

  @override
  String get mgEdit => 'Edytuj grupę';

  @override
  String get mgName => 'Nazwa';

  @override
  String mgMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count członka',
      many: '$count członków',
      few: '$count członków',
      one: '1 członek',
      zero: 'Brak członków',
    );
    return '$_temp0';
  }

  @override
  String get mgNoMembers => 'Brak jeszcze członków w tej grupie.';

  @override
  String get mgOverseer => 'Nadzorca grupy';

  @override
  String get mgAssistant => 'Pomocnik grupy';

  @override
  String get mgMakeOverseer => 'Ustaw jako nadzorcę grupy';

  @override
  String get mgMakeAssistant => 'Ustaw jako pomocnika';

  @override
  String get mgClearRole => 'Usuń oznaczenie nadzorcy/pomocnika';

  @override
  String get mgAddMember => 'Dodaj członka…';

  @override
  String get mgNoUnassigned => 'Wszyscy są już w jakiejś grupie.';

  @override
  String get mgRemoveMember => 'Usuń z grupy';

  @override
  String get mgDeleteConfirm =>
      'Usunąć tę grupę? Jej członkowie zostaną bez grupy.';

  @override
  String get mgGroup => 'Grupa służby';

  @override
  String get mgNoGroup => 'Brak grupy';

  @override
  String get infoEmpty => 'Obecnie brak informacji.';

  @override
  String get infoAddText => 'Dodaj tekst';

  @override
  String get infoAddFile => 'Prześlij plik (PDF/obraz)';

  @override
  String get infoTitle => 'Tytuł';

  @override
  String get infoBody => 'Tekst';

  @override
  String get infoUrl => 'Link (URL)';

  @override
  String get infoShowFrom => 'Pokaż od (opcjonalnie)';

  @override
  String get infoShowUntil => 'Pokaż do (opcjonalnie)';

  @override
  String get infoFileTooLarge =>
      'Plik jest za duży (maks. 10 MB). Udostępnij go jako link.';

  @override
  String get infoHidden => 'Obecnie ukryte (poza okresem widoczności)';

  @override
  String get infoDownloading => 'Wczytywanie pliku…';

  @override
  String get infoEditItem => 'Edytuj element';

  @override
  String get infoCleanTooltip => 'Wyczyść tablicę ogłoszeń';

  @override
  String get infoCleanConfirmTitle => 'Wyczyścić tablicę ogłoszeń?';

  @override
  String get infoCleanConfirmBody =>
      'Spowoduje to trwałe usunięcie WSZYSTKICH ogłoszeń — tekstów, plików i linków, zarówno przeszłych, bieżących, jak i przyszłych. Tej operacji nie można cofnąć.';

  @override
  String get infoCleanDone => 'Tablica ogłoszeń została wyczyszczona.';

  @override
  String get s1Active =>
      'Czynni głosiciele (którzy zgłosili służbę co najmniej raz w ciągu ostatnich 6 miesięcy)';

  @override
  String get s1AvgMid => 'Średnia liczba obecnych na zebraniach w tygodniu';

  @override
  String get s1AvgWeekend => 'Średnia liczba obecnych na zebraniach w weekendy';

  @override
  String get s1Publishers => 'Głosiciele';

  @override
  String get s1AuxPioneers => 'Pionierzy pomocniczy';

  @override
  String get s1RegPioneers => 'Pionierzy stali';

  @override
  String get s1Count => 'Liczba sprawozdań';

  @override
  String get s1Studies => 'Kursy biblijne';

  @override
  String get s1Hours => 'Godziny (razem)';

  @override
  String get s1Note =>
      'Pionierzy pomocniczy, stali i specjalni nie są liczeni w grupie Głosicieli; pionierzy specjalni nie są uwzględniani w żadnej grupie.';

  @override
  String get settingsName => 'Nazwa zboru';

  @override
  String get settingsLmmMeeting => 'Zebranie w tygodniu (dzień i godzina)';

  @override
  String get settingsLmmClassCount => 'Grupy zebrania w tygodniu';

  @override
  String get settingsWeekendMeeting => 'Zebranie w weekend (dzień i godzina)';

  @override
  String get settingsBackupSection => 'Kopia zapasowa i przywracanie';

  @override
  String get settingsBackupDescription =>
      'Pobierz pełną kopię danych swojego zboru lub przywróć je z pliku kopii zapasowej. Użyj tego, aby odzyskać dane po przypadkowym usunięciu lub błędnej edycji.';

  @override
  String get settingsExportData => 'Eksportuj wszystkie dane';

  @override
  String get settingsImportData => 'Przywróć z kopii zapasowej…';

  @override
  String backupExportSuccess(int count) {
    return 'Pobrano kopię zapasową ($count rekordów).';
  }

  @override
  String get backupImportTitle => 'Przywróć z kopii zapasowej';

  @override
  String get backupImportPick => 'Wybierz plik kopii zapasowej…';

  @override
  String get backupImportEmpty =>
      'Wybierz plik kopii zapasowej, aby podejrzeć jego zawartość.';

  @override
  String get backupImportContents => 'Zawartość';

  @override
  String backupImportFrom(String name, String date) {
    return 'Kopia zapasowa $name · $date';
  }

  @override
  String get backupImportWarning =>
      'Przywracanie nadpisuje bieżące rekordy o tym samym ID co wersje w tej kopii zapasowej. Rekordy dodane po utworzeniu kopii są zachowane. Tej operacji nie można cofnąć.';

  @override
  String get backupImportConfirm => 'Przywróć tę kopię zapasową';

  @override
  String backupImportSuccess(int count) {
    return 'Przywrócono $count rekordów.';
  }

  @override
  String backupImportPartial(int count, String collections) {
    return 'Przywrócono $count rekordów. Nie udało się przywrócić: $collections.';
  }

  @override
  String get backupInvalidFile =>
      'Ten plik nie jest prawidłową kopią zapasową zboru.';

  @override
  String get qSupportSection => 'Obsługa zebrania i inne';

  @override
  String get qChairman => 'Przewodniczący (w tygodniu)';

  @override
  String get qPrayer => 'Modlitwa';

  @override
  String get qTreasures => 'Skarby ze Słowa Bożego';

  @override
  String get qGems => 'Duchowe skarby';

  @override
  String get qBibleReading => 'Czytanie Biblii';

  @override
  String get qFieldMinistry => 'Zadania uczestnika (służba)';

  @override
  String get qLiving => 'Chrześcijański tryb życia';

  @override
  String get qCbsConductor => 'Prowadzący zborowe studium Biblii';

  @override
  String get qCbsReader => 'Lektor zborowego studium Biblii';

  @override
  String get qPublicTalk => 'Wykład publiczny';

  @override
  String get qWeekendChairman => 'Przewodniczący (weekend)';

  @override
  String get qWtReader => 'Lektor Strażnicy';

  @override
  String get qAttendant => 'Porządkowy';

  @override
  String get qMicrophone => 'Mikrofony';

  @override
  String get qAudioVideo => 'Audio-wideo';

  @override
  String get qPublicWitnessing => 'Świadczenie publiczne';

  @override
  String get qMinistryMeetingConductor => 'Prowadzący zbiórkę do służby';

  @override
  String get programKindRegular => 'Zwykły program';

  @override
  String get programKindNothingPlanned => 'Nic nie zaplanowano';

  @override
  String get programKindMemorial => 'Pamiątka';

  @override
  String get weekNothingPlannedHint => 'W tym tygodniu nie ma zebrania.';

  @override
  String get weekProgramSwitchConfirm =>
      'Obecny program zostanie zachowany i wróci po przełączeniu z powrotem.';

  @override
  String get weekRestoreProgram => 'Przywróć zwykły program';

  @override
  String get weekNoteLabel => 'Uwaga dla głosicieli';

  @override
  String get weekNoteEdit => 'Edytuj uwagę';

  @override
  String get memorialBreadPrayer => 'Modlitwa za chleb';

  @override
  String get memorialWinePrayer => 'Modlitwa za wino';

  @override
  String get memorialAttendance => 'Obecność na Pamiątce';

  @override
  String get memorialPastTitle => 'Poprzednie Pamiątki';

  @override
  String get attMeetingMemorial => 'Pamiątka';

  @override
  String get keepOnImport => 'Zachowaj przy imporcie';

  @override
  String get keepOnImportHint => 'Import ze skoroszytu tego nie nadpisze.';

  @override
  String importKeepsEdits(int parts, int songs) {
    return 'Twoje zmiany zostaną zachowane: $parts punktów, $songs pieśni';
  }

  @override
  String get helpProgramKindTitle => 'Tygodnie bez zebrania i Pamiątka';

  @override
  String get helpProgramKindBody =>
      'W widoku tygodnia menu obok tygodnia przełącza go na „Nic nie zaplanowano” (tydzień zgromadzenia albo kongresu – głosiciele widzą Twoją uwagę zamiast programu i nie oczekuje się obecności) albo na Pamiątkę, która może wypaść w każdy z tych dni. To, co opuszczasz, zostaje zachowane i wraca po przełączeniu z powrotem. Dzień i godzinę Pamiątki ustawiasz ołówkiem w nagłówku tygodnia, a jej obecność zapisuje się przy niej samej – nigdy nie wlicza się do średnich zebrań.';
}
