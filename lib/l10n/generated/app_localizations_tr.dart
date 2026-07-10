// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Cemaat Planlayıcı';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonDelete => 'Sil';

  @override
  String get commonEdit => 'Düzenle';

  @override
  String get commonAdd => 'Ekle';

  @override
  String get commonClose => 'Kapat';

  @override
  String get commonBack => 'Geri';

  @override
  String get commonRetry => 'Tekrar dene';

  @override
  String get commonLoading => 'Yükleniyor…';

  @override
  String get commonError => 'Bir şeyler ters gitti';

  @override
  String commonErrorDetail(String message) {
    return 'Bir şeyler ters gitti: $message';
  }

  @override
  String get commonFieldRequired => 'Bu alan zorunludur';

  @override
  String get commonConfirmDeleteTitle => 'Silinsin mi?';

  @override
  String get commonConfirmDeleteBody => 'Bu işlem geri alınamaz.';

  @override
  String get commonToday => 'Bugün';

  @override
  String get commonAll => 'Tümü';

  @override
  String get commonNone => 'Hiçbiri';

  @override
  String get commonYes => 'Evet';

  @override
  String get commonNo => 'Hayır';

  @override
  String get commonOk => 'Tamam';

  @override
  String get commonSearch => 'Ara';

  @override
  String get commonNotAssigned => '—';

  @override
  String get commonLanguage => 'Dil';

  @override
  String get setupTitle => 'Cemaatinize bağlanın';

  @override
  String get setupIntro =>
      'Bu uygulama doğrudan cemaatinizin kendi veritabanına bağlanır. Yöneticinizden aldığınız yapılandırmayı yapıştırın veya davet QR kodunu tarayın.';

  @override
  String get setupConfigLabel => 'Firebase yapılandırması (JSON)';

  @override
  String get setupConfigHint => 'apiKey, authDomain, projectId, …';

  @override
  String get setupScanQr => 'QR kodunu tara';

  @override
  String get setupPickQrImage => 'QR kodu fotoğrafı seç';

  @override
  String get setupQrNotFoundInImage => 'Bu resimde QR kodu bulunamadı.';

  @override
  String get setupConnect => 'Bağlan';

  @override
  String get setupInvalidJson =>
      'Bu geçerli bir yapılandırma JSON\'u değil. En az apiKey, projectId ve appId içermelidir.';

  @override
  String setupConnectionFailed(String message) {
    return 'Bu yapılandırmayla bağlantı kurulamadı: $message';
  }

  @override
  String get setupModeTitle => 'Nasıl başlamak istersiniz?';

  @override
  String get setupModeJoin => 'Cemaatime katıl';

  @override
  String get setupModeJoinSubtitle =>
      'Bir yönetici sizi davet etti. Kayıttan sonra hesabınızı doğrulayacak.';

  @override
  String get setupModeNew => 'Yeni cemaat oluştur';

  @override
  String get setupModeNewSubtitle =>
      'Yeni oluşturulmuş bir Firebase projesinin ilk yöneticisisiniz.';

  @override
  String get setupCongregationExists =>
      'Bu cemaat zaten kurulmuş. Bunun yerine \"Cemaatime katıl\" seçeneğini belirleyin.';

  @override
  String get setupDatabaseNotReady =>
      'Cemaat veritabanı hâlâ başlatılıyor. Lütfen biraz bekleyip tekrar deneyin.';

  @override
  String get setupReconfigure => 'Yapılandırmayı değiştir';

  @override
  String get setupRestartRequired =>
      'Yapılandırma kaydedildi. Uygulamak için uygulamayı kapatıp yeniden açın.';

  @override
  String get languageSystem => 'Sistem dili';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageCzech => 'Čeština';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get profileCompleteTitle => 'Profilinizi tamamlayın';

  @override
  String get profileCompleteBody =>
      'Hesabınız var ancak profil eksik. Kaydı tamamlamak için adınızı girin.';

  @override
  String get authSignIn => 'Giriş yap';

  @override
  String get authSignOut => 'Çıkış yap';

  @override
  String get authRegister => 'Hesap oluştur';

  @override
  String get authEmail => 'E-posta';

  @override
  String get authPassword => 'Parola';

  @override
  String get authPasswordConfirm => 'Parolayı onayla';

  @override
  String get authPasswordsDontMatch => 'Parolalar eşleşmiyor';

  @override
  String get authForgotPassword => 'Parolanızı mı unuttunuz?';

  @override
  String get authResetSent => 'Parola sıfırlama e-postası gönderildi.';

  @override
  String get authNoAccountYet => 'Henüz hesabınız yok mu? Oluşturun';

  @override
  String get authHaveAccount => 'Zaten hesabınız var mı? Giriş yapın';

  @override
  String get authErrorInvalidCredentials => 'Yanlış e-posta veya parola.';

  @override
  String get authErrorEmailInUse => 'Bu e-posta ile zaten bir hesap var.';

  @override
  String get authErrorWeakPassword => 'Parola çok zayıf (en az 6 karakter).';

  @override
  String authErrorGeneric(String message) {
    return 'Giriş başarısız: $message';
  }

  @override
  String get authFirstName => 'Ad';

  @override
  String get authLastName => 'Soyad';

  @override
  String get authCongregationName => 'Cemaat adı';

  @override
  String get awaitingTitle => 'Doğrulama bekleniyor';

  @override
  String get awaitingBody =>
      'Hesabınız oluşturuldu. Cemaatin bilgilerini görebilmeniz için cemaat yöneticisinin hesabınızı doğrulaması gerekiyor.';

  @override
  String get navInfoBoard => 'İlan Panosu';

  @override
  String get navEvents => 'Etkinlikler';

  @override
  String get navLmm => 'Hayatımız ve Hizmetimiz';

  @override
  String get navWeekend => 'Hafta Sonu İbadeti';

  @override
  String get navPublicWitnessing => 'Halka Açık Şahitlik';

  @override
  String get navTerritories => 'Sahalar';

  @override
  String get navReport => 'Tarla Hizmeti Raporu';

  @override
  String get navAttendance => 'Katılım';

  @override
  String get navProfile => 'Profilim';

  @override
  String get navAdmin => 'Yönetim';

  @override
  String get navPublishersAdmin => 'Müjdeciler';

  @override
  String get navReportsAdmin => 'Rapor Özeti';

  @override
  String get navS1 => 'S-1 Raporu';

  @override
  String get navTalks => 'Halka Yönelik Konuşma Başlıkları';

  @override
  String get navSettings => 'Cemaat Ayarları';

  @override
  String get adminToggleHide => 'Yönetici seçeneklerini gizle';

  @override
  String get adminToggleShow => 'Yönetici seçeneklerini göster';

  @override
  String get profilePhone => 'Telefon numarası';

  @override
  String get profileAddress => 'Adres';

  @override
  String get profileBirthDate => 'Doğum tarihi';

  @override
  String get profileBaptismDate => 'Vaftiz tarihi';

  @override
  String get profileGender => 'Cinsiyet';

  @override
  String get genderUnknown => '—';

  @override
  String get genderMale => 'Erkek';

  @override
  String get genderFemale => 'Kadın';

  @override
  String get profileHope => 'Ümit';

  @override
  String get hopeOtherSheep => 'Başka koyun';

  @override
  String get hopeAnointed => 'Meshedilmiş';

  @override
  String get profileStatus => 'Hizmet durumu';

  @override
  String get statusPublisher => 'Müjdeci';

  @override
  String get statusAuxPioneer => 'Öncü Yardımcı';

  @override
  String get statusRegPioneer => 'Daimi Öncü';

  @override
  String get statusSpecialPioneer => 'Özel Öncü';

  @override
  String get statusFieldMissionary => 'Görevli Vaiz';

  @override
  String get profileAppointment => 'Tayin';

  @override
  String get appointmentMinisterialServant => 'Hizmet Görevlisi';

  @override
  String get appointmentElder => 'İhtiyar';

  @override
  String get profileEmergency => 'Acil durum notu';

  @override
  String get profileEmergencyHint => 'Acil durumda kiminle iletişime geçilmeli';

  @override
  String get profileSaved => 'Kaydedildi';

  @override
  String get profileRecord => 'Müjdeci Kaydı';

  @override
  String serviceYear(int year) {
    return 'Hizmet Yılı $year';
  }

  @override
  String get reportMonth => 'Ay';

  @override
  String get reportParticipated => 'Hizmete katıldı';

  @override
  String get reportStudies => 'Kutsal Kitap İncelemeleri';

  @override
  String get reportHours => 'Saat';

  @override
  String get reportCredit => 'Kredi Saatleri';

  @override
  String get reportComments => 'Not';

  @override
  String get s21Export => 'S-21\'i Dışa Aktar (PDF)';

  @override
  String get s21Title => 'CEMAAT MÜJDECİ KAYDI';

  @override
  String get s21Name => 'Adı:';

  @override
  String get s21DateOfBirth => 'Doğum tarihi:';

  @override
  String get s21DateOfBaptism => 'Vaftiz tarihi:';

  @override
  String get s21HoursHeader => 'Saatler (Öncü veya Saha Misyoneriyse)';

  @override
  String get s21Remarks => 'Notlar';

  @override
  String get s21Total => 'Toplam';

  @override
  String get s21FormCode => 'S-21-T 11/23';

  @override
  String get pubAdminInvite => 'Davet et';

  @override
  String get pubAdminInviteTitle => 'Cemaate Davet Et';

  @override
  String get pubAdminInviteBody =>
      'Yeni müjdeci bu QR kodunu uygulamada tarar, kaydolur ve sonra aşağıda doğrulanmamış olarak görünür. Erişim vermek için doğrulayın.';

  @override
  String get pubAdminAddRecord => 'Müjdeci Kaydı Ekle';

  @override
  String get pubAdminAddRecordHint =>
      'Uygulamayı kullanmayacak bir müjdecinin kaydı; yöneticiler onun raporlarını girebilir.';

  @override
  String get pubAdminVerified => 'Doğrulandı';

  @override
  String get pubAdminUnverifiedBadge => 'Doğrulama bekleniyor';

  @override
  String get pubAdminNoAccountBadge => 'Uygulama hesabı yok';

  @override
  String get pubAdminTabProfile => 'Profil';

  @override
  String get pubAdminTabRoles => 'Yetkiler';

  @override
  String get pubAdminTabAssign => 'Atamalar';

  @override
  String get pubAdminTabRecord => 'Kayıt';

  @override
  String get pubAdminDeleteConfirm =>
      'Bu müjdeci ve özel verileri silinsin mi? Raporları saklanır.';

  @override
  String get pubAdminSelfVerifiedWarningTitle =>
      'Kendi Doğrulandı Durumunuzu İptal Etmek mi?';

  @override
  String get pubAdminSelfVerifiedWarningBody =>
      'Kendi hesabınızın Doğrulandı durumunu kaldırıyorsunuz. Cemaat verilerine erişiminizi hemen kaybedersiniz ve yalnızca başka bir Tam Yönetici bunu geri yükleyebilir. Devam etmek istediğinizden emin misiniz?';

  @override
  String get pubAdminSelfFullAdminWarningTitle =>
      'Kendi Tam Yönetici Yetkinizi Kaldırmak mı?';

  @override
  String get pubAdminSelfFullAdminWarningBody =>
      'Kendi Tam Yönetici yetkinizi kaldırıyorsunuz. Tek yönetici sizseniz, siz dahil hiç kimse bunu geri alamaz. Devam etmek istediğinizden emin misiniz?';

  @override
  String get pubAdminSelfWarningConfirm => 'Erişimimi kaldır';

  @override
  String get roleFullAdmin => 'Tam Yönetici';

  @override
  String get weekNoSchedule => 'Bu hafta için henüz program yok.';

  @override
  String get weekCreateEmpty => 'Boş Hafta Oluştur';

  @override
  String get weekImportEpub => '.epub Dosyasından İçe Aktar';

  @override
  String get weekCheckCdn => 'Çevrimiçi Denetle';

  @override
  String get weekDelete => 'Bu Haftayı Sil';

  @override
  String get lmmSongs => 'İlahiler';

  @override
  String get sectionOpening => 'Açılış';

  @override
  String get sectionTreasures => 'TANRI’NIN SÖZÜNDEKİ HAZİNELER';

  @override
  String get sectionMinistry => 'TARLA HİZMETİNDE KENİDİNİZİ GELİŞTİRİN';

  @override
  String get sectionLiving => 'HIRİSTİYAN OLARAK YAŞAM TARZIMIZ';

  @override
  String get sectionClosing => 'Kapanış';

  @override
  String get partChairman => 'Başkanlik eden';

  @override
  String get partOpeningPrayer => 'Açılış Duası';

  @override
  String get partClosingPrayer => 'Kapanış Duası';

  @override
  String get partGems => 'Ruhi Hazineler';

  @override
  String get partBibleReading => 'Kutsal Kitap Okuması';

  @override
  String get partCbs => 'Cemaat Kutsal Kitap İncelemesi';

  @override
  String get partCbsReader => 'Okuyucu';

  @override
  String get partAssistant => 'Yardımcı';

  @override
  String partMinutes(int min) {
    return '$min dk.';
  }

  @override
  String get partEdit => 'Kısmı Düzenle';

  @override
  String get partTitle => 'Başlık';

  @override
  String get partDescription => 'Açıklama';

  @override
  String get partDuration => 'Süre (dk.)';

  @override
  String get partAdd => 'Kısım Ekle';

  @override
  String get partDeleteConfirm => 'Bu program kısmı silinsin mi?';

  @override
  String get supportAttendants => 'Teşrifatçi';

  @override
  String get supportMicrophones => 'Mikrofon';

  @override
  String get supportAudioVideo => 'Ses ve Görüntü';

  @override
  String get customAssignmentAdd => 'Başka Görevi Ekle';

  @override
  String get customLabel => 'Etiket';

  @override
  String get pickerQualified => 'Yeterli';

  @override
  String get pickerAll => 'Tümü';

  @override
  String get pickerFreeText => 'Metin';

  @override
  String pickerLastAssigned(String date) {
    return 'Son: $date';
  }

  @override
  String get pickerNever => 'Hiç yapmadı';

  @override
  String get importTitle => 'İbadet Kitapçığını İçe Aktar';

  @override
  String get importNoWeeks => 'Bu dosyada kullanılabilir hafta bulunamadı.';

  @override
  String get importWeekExists =>
      'Zaten var — program güncellenecek, atamalar korunacak';

  @override
  String importSave(int count) {
    return '$count Haftayı İçe Aktar';
  }

  @override
  String get importDone => 'İçe aktarıldı.';

  @override
  String get importCdnNothing =>
      'Henüz çevrimiçi kullanılabilir bir kitapçık sayısı yok.';

  @override
  String get weekendTalkTitle => 'Halka Yönelik Konuşma';

  @override
  String get weekendSpeaker => 'Konuşmacı';

  @override
  String get weekendChairmanLabel => 'Başkanlik eden';

  @override
  String get weekendWtReader => 'Gözcü Kulesi Okuyucusu';

  @override
  String get customFieldAdd => 'Program Alanı Ekle';

  @override
  String get pickerFromCatalog => 'Listeden';

  @override
  String get talksUpdateFromPdf => 'Başlıkları PDF\'den Güncelle';

  @override
  String get talksPickPdf => 'S-99 PDF\'i Seç';

  @override
  String get talksParseError =>
      'Bu dosyadan konuşma başlıkları okunamadı. Resmî S-99 formu PDF\'i kullanın.';

  @override
  String talksImportSummary(int total, int added, int changed, int removed) {
    return '$total konuşma bulundu: $added yeni, $changed değiştirildi, $removed kaldırıldı';
  }

  @override
  String get talksImportSave => 'Başlıkları Kaydet';

  @override
  String talksImportDone(int count) {
    return 'Başlıklar kaydedildi. Yaklaşan $count ibadet güncellendi.';
  }

  @override
  String talksLastDelivered(String date) {
    return 'Son sunulma $date';
  }

  @override
  String get talksNeverDelivered => 'Henüz sunulmadı';

  @override
  String get talksScheduled => 'planlandı';

  @override
  String get talksNew => 'Yeni';

  @override
  String get talksChanged => 'Değiştirildi';

  @override
  String get talksRemoved => 'Kaldırıldı';

  @override
  String get talksSearchHint => 'Konuşmaları ara…';

  @override
  String get talksEmpty =>
      'Henüz konuşma başlığı yok. S-99 PDF\'sinden içe aktarın.';

  @override
  String get talksOpenCatalog => 'Halka Yönelik Konuşma Başlıklarını Yönet';

  @override
  String get talksEditTitle => 'Başlığı Düzenle';

  @override
  String get pwNoSlots => 'Bu hafta Halka Açık Yerde Şahitlik yok.';

  @override
  String get pwAddSlot => 'Zaman Aralığı Ekle';

  @override
  String get pwEditSlot => 'Zaman Aralığını Düzenle';

  @override
  String get pwLocation => 'Yer';

  @override
  String get pwTimeFrom => 'Başlangıç';

  @override
  String get pwTimeTo => 'Bitiş';

  @override
  String get pwRecurringRules => 'Tekrarlanan Zaman Aralıkları';

  @override
  String get pwRecurringAdd => 'Tekrarlanan Zaman Aralığı Ekle';

  @override
  String get pwWeekday => 'Haftanın günü';

  @override
  String get pwValidFrom => 'Geçerlilik başlangıcı';

  @override
  String get pwValidUntil => 'Geçerlilik bitişi (isteğe bağlı)';

  @override
  String get pwAssignees => 'Atananlar';

  @override
  String get pwDate => 'Tarih';

  @override
  String get eventsUpcoming => 'Yaklaşan Etkinlikler';

  @override
  String get eventsNone => 'Yaklaşan etkinlik yok.';

  @override
  String get eventAdd => 'Etkinlik Ekle';

  @override
  String get eventEdit => 'Etkinliği Düzenle';

  @override
  String get eventTitle => 'Başlık';

  @override
  String get eventType => 'Tür';

  @override
  String get eventTypeConvention => 'Bölge Kongresi';

  @override
  String get eventTypeAssembly => 'Çevre Kongresi';

  @override
  String get eventTypeMemorial => 'Anma Yemeği';

  @override
  String get eventTypeCoVisit => 'Çevre Gözetmeninin Ziyareti';

  @override
  String get eventTypeOther => 'Diğer';

  @override
  String get eventDateFrom => 'Başlangıç';

  @override
  String get eventDateTo => 'Bitiş (isteğe bağlı)';

  @override
  String get eventLocation => 'Yer';

  @override
  String get eventNotes => 'Notlar';

  @override
  String get eventAddToCalendar => 'Takvime Ekle';

  @override
  String get myAssignments => 'Yaklaşan Görevlerim';

  @override
  String get myAssignmentsNone => 'Yaklaşan görevleriniz yok.';

  @override
  String get roleAssistant => 'Yardımcı';

  @override
  String get rolePw => 'Halka Açık Yerde Şahitlik';

  @override
  String get reportSubmit => 'Rapor Ver';

  @override
  String reportSubmittedAt(String date) {
    return '$date tarihinde gönderildi';
  }

  @override
  String get reportSaved => 'Rapor kaydedildi.';

  @override
  String get reportMissing => 'Gönderilmedi';

  @override
  String reportEnterFor(String name) {
    return '$name için rapor girin';
  }

  @override
  String reportSummaryReported(int reported, int total) {
    return 'Rapor Verenler: $reported / $total';
  }

  @override
  String get attAdd => 'Katılım Kaydet';

  @override
  String get attInPerson => 'Salonda';

  @override
  String get attOnline => 'Zoomda';

  @override
  String get attTotal => 'Toplam';

  @override
  String get attMeetingLmm => 'Hafta İçi İbadeti';

  @override
  String get attMeetingWeekend => 'Hafta Sonu İbadeti';

  @override
  String get attOverview => 'Aylık Ortalamalar';

  @override
  String get attRecent => 'Son İbadetler';

  @override
  String get attSaved => 'Katılım kaydedildi.';

  @override
  String get terrMine => 'Sahalarım';

  @override
  String get terrNoMine => 'Size atanmış saha yok.';

  @override
  String get terrAll => 'Tüm Sahalar';

  @override
  String terrAssignedOn(String date) {
    return '$date tarihinde atandı';
  }

  @override
  String get terrReturn => 'İade Et';

  @override
  String get terrReturnTitle => 'Sahayı İade Et';

  @override
  String get terrReturnNotes => 'Notlar (isteğe bağlı)';

  @override
  String get terrMap => 'Harita';

  @override
  String get terrAdd => 'Saha Ekle';

  @override
  String get terrEdit => 'Sahayı Düzenle';

  @override
  String get terrName => 'Ad';

  @override
  String get terrNumber => 'Numara';

  @override
  String get terrMapUrl => 'Harita bağlantısı (ör. Google My Maps)';

  @override
  String get terrNotes => 'Notlar';

  @override
  String get terrAssignTo => 'Şuna ata…';

  @override
  String terrHolder(String name, String date) {
    return '$name — $date tarihinden beri';
  }

  @override
  String get terrFree => 'Atanmamış';

  @override
  String get terrStats => 'İstatistikler';

  @override
  String get terrStatsTotal => 'Toplam';

  @override
  String get terrStatsAssigned => 'Şu anda atanmış';

  @override
  String get terrStatsFinished => 'Dönemde tamamlanan';

  @override
  String get terrRemoveAssignment => 'Atamayı Kaldır';

  @override
  String get infoEmpty => 'Şu anda ilan bulunmuyor.';

  @override
  String get infoAddText => 'Yazılı İlan Ekle';

  @override
  String get infoAddFile => 'Dosya Yükle (PDF/Resim)';

  @override
  String get infoAddLink => 'Bağlantı Ekle';

  @override
  String get infoTitle => 'Başlık';

  @override
  String get infoBody => 'Metin';

  @override
  String get infoUrl => 'Bağlantı (URL)';

  @override
  String get infoShowFrom => 'Şu tarihten itibaren göster (isteğe bağlı)';

  @override
  String get infoShowUntil => 'Şu tarihe kadar göster (isteğe bağlı)';

  @override
  String get infoFileTooLarge =>
      'Dosya çok büyük (en fazla 10 MB). Bunun yerine bağlantı paylaşın.';

  @override
  String get infoHidden => 'Şu anda gizli (görünürlük süresinin dışında)';

  @override
  String get infoDownloading => 'Dosya yükleniyor…';

  @override
  String get infoEditItem => 'İlanı Düzenle';

  @override
  String get s1Active =>
      'Tüm etkin müjdeciler (son 6 ayda en az bir kez rapor verenler)';

  @override
  String get s1AvgMid => 'Ortalama Katılım — Hafta İçi İbadeti';

  @override
  String get s1AvgWeekend => 'Ortalama Katılım — Hafta Sonu İbadeti';

  @override
  String get s1Publishers => 'Müjdeciler';

  @override
  String get s1AuxPioneers => 'Öncü Yardımcılar';

  @override
  String get s1RegPioneers => 'Daimi Öncüler';

  @override
  String get s1Count => 'Sayı';

  @override
  String get s1Studies => 'Kutsal Kitap İncelemeleri';

  @override
  String get s1Hours => 'Saatler (toplam)';

  @override
  String get s1Note =>
      'Yardımcı, daimi ve özel öncüler Müjdeciler grubuna sayılmaz; özel öncüler hiçbir gruba dahil edilmez.';

  @override
  String get settingsName => 'Cemaat adı';

  @override
  String get settingsLmmMeeting => 'Hafta içi ibadeti (gün ve saat)';

  @override
  String get settingsWeekendMeeting => 'Hafta sonu ibadeti (gün ve saat)';

  @override
  String get qSupportSection => 'İbadet desteği ve diğer';

  @override
  String get qChairman => 'Başkanlik eden (hafta içi)';

  @override
  String get qPrayer => 'Dua';

  @override
  String get qTreasures => 'Tanrı\'nın Sözündeki Hazineler';

  @override
  String get qGems => 'Ruhi hazineler';

  @override
  String get qBibleReading => 'Kutsal Kitap okuması';

  @override
  String get qFieldMinistry => 'Öğrenci görevleri (hizmet)';

  @override
  String get qLiving => 'Hıristiyanlar Olarak Yaşam Tarzımız';

  @override
  String get qCbsConductor => 'Cemaat Kutsal Kitap İncelemesi idarecisi';

  @override
  String get qCbsReader => 'Cemaat Kutsal Kitap İncelemesi okuyucusu';

  @override
  String get qPublicTalk => 'Halka yönelik konuşma';

  @override
  String get qWeekendChairman => 'Başkanlik eden (hafta sonu)';

  @override
  String get qWtReader => 'Gözcü Kulesi okuyucusu';

  @override
  String get qAttendant => 'Teşrifatçi';

  @override
  String get qMicrophone => 'Mikrofonlar';

  @override
  String get qAudioVideo => 'Ses/video';

  @override
  String get qPublicWitnessing => 'Halka açık yerde şahitlik';
}
