import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/publishers/s21/s21_import_parser.dart';
import 'package:flutter_test/flutter_test.dart';

/// Exact pdfrx text of a real generated Turkish S-21 (two service years on
/// one page, dingbat checkboxes decoding to þ/¨).
const _turkishFlat = '''
S-21 11/23
S-21 Cemaat Müjdeci Kayıt Kartı
İsim: Buse Skarda
Doğum Tarihi: 1997/11/17 ¨ Erkek þ Kadın
Vaftiz Tarihi: 2014/07/05 þ Başka Koyun ¨ Meshedilmiş
¨ İhtiyar ¨ Hizmet Görevlisi ¨ Daimi Öncü þ Özel Öncü ¨ Görevli Vaiz
Hizmet Yılı
2025 Hizmete Katıldı Kutsal Kitap
Tetkikleri Öncü Yardımcısı
Saatler
(Öncü veya
Görevli vaiz ise)
Notlar
Eylül þ 3 ¨ 96
Ekim þ 3 ¨ 96
Kasım þ 4 ¨ 56 tatil
Aralık þ 4 ¨ 67
Ocak þ 4 ¨ 96
Şubat þ 3 ¨ 96
Mart þ 3 ¨ 75
Nisan þ 3 ¨ 72
Mayıs þ 3 ¨ 88 Kredi: 12
Haziran þ 3 ¨ 100
Temmuz þ 4 ¨ 100
Ağustos þ 3 ¨ 84
Toplam 1026
Hizmet Yılı
2026 Hizmete Katıldı Kutsal Kitap
Tetkikleri Öncü Yardımcısı
Saatler
(Öncü veya
Görevli vaiz ise)
Notlar
Eylül þ 2 ¨ 58 8.5 gün tatil,2 gün hasta
Ekim þ 2 ¨ 94
Kasım þ 1 ¨ 94
Aralık þ 1 ¨ 60 hasta
Ocak þ 1 ¨ 62
Şubat þ 3 ¨ 52
Mart þ 3 ¨ 78
Nisan þ 2 ¨ 100
Mayıs þ 3 ¨ 87
Haziran ¨ ¨
Temmuz ¨ ¨
Ağustos ¨ ¨
Toplam 685
''';

/// Exact pdfrx text of the official blank English S-21-E — an AcroForm whose
/// values never reach the text layer, so it must parse as "no data".
const _officialBlankEnglish = '''
CONGREGATION’S PUBLISHER RECORD
Name:
Date of birth:  Male  Female
Date of baptism:  Other sheep  Anointed
 Elder  Ministerial servant  Regular pioneer  Special pioneer Field missionary
Service Year Shared in
Ministry
Bible
Studies
Auxiliary
Pioneer
Hours
(If pioneer
or field
missionary)
Remarks
September
October
November
December
January
February
March
April
May
June
July
August
Total
S-21-E 11/23
''';

/// A synthetic Czech card in the app's own S-21 export layout: values follow
/// the labels, only checked boxes print an X, dates in d. M. yyyy.
const _czechAppExport = '''
KARTA SBOROVÉHO ZVĚSTOVATELE
Jméno: Jan Novák
Datum narození: 5. 3. 1980 X Muž  Žena
Datum křtu: 12. 6. 1995 X Jiná ovce  Pomazaný
X Starší  Služební pomocník X Pravidelný průkopník  Zvláštní průkopník  Misionář
Služební rok 2024 Byl ve službě Biblická studia Pomocný průkopník Hodiny Poznámky
Září X 2 70
Říjen X 2 X 68
Listopad
Prosinec X 1 55 Kredit: 10
Celkem 193
''';

void main() {
  group('parseS21Import', () {
    test('parses a generated Turkish card with two service years', () {
      final r = parseS21Import(_turkishFlat);

      expect(r.name, 'Buse Skarda');
      expect(r.birthDate, '1997-11-17');
      expect(r.baptismDate, '2014-07-05');
      expect(r.gender, Gender.female);
      expect(r.hope, Hope.otherSheep);
      expect(r.appointment, Appointment.none);
      expect(r.status, PublisherStatus.specialPioneer);

      expect(r.years, hasLength(2));
      final y25 = r.years[0];
      expect(y25.serviceYear, 2025);
      expect(y25.rows, hasLength(12));

      final sep = y25.rows.first;
      expect(sep.month, 9);
      expect(sep.participated, isTrue);
      expect(sep.bibleStudies, 3);
      expect(sep.auxPioneer, isFalse);
      expect(sep.hours, 96);
      expect(sep.comments, isEmpty);

      final nov = y25.rows[2];
      expect(nov.month, 11);
      expect(nov.hours, 56);
      expect(nov.comments, 'tatil');

      final may = y25.rows[8];
      expect(may.month, 5);
      expect(may.hours, 88);
      expect(may.creditHours, 12);
      expect(may.comments, 'Kredi: 12');

      final y26 = r.years[1];
      expect(y26.serviceYear, 2026);
      // Jun–Aug are fully empty and must be dropped, not imported as blanks.
      expect(y26.rows, hasLength(9));

      final sep26 = y26.rows.first;
      expect(sep26.hours, 58);
      expect(sep26.bibleStudies, 2);
      expect(sep26.comments, '8.5 gün tatil,2 gün hasta');
    });

    test('official blank AcroForm parses as empty', () {
      final r = parseS21Import(_officialBlankEnglish);
      expect(r.name, isEmpty);
      expect(r.years, isEmpty);
      expect(r.isEmpty, isTrue);
    });

    test('parses a Czech card in the app export layout (X = checked)', () {
      final r = parseS21Import(_czechAppExport);

      expect(r.name, 'Jan Novák');
      expect(r.birthDate, '1980-03-05');
      expect(r.baptismDate, '1995-06-12');
      expect(r.gender, Gender.male);
      expect(r.hope, Hope.otherSheep);
      expect(r.appointment, Appointment.elder);
      expect(r.status, PublisherStatus.regularPioneer);

      expect(r.years, hasLength(1));
      expect(r.years.single.serviceYear, 2024);
      // Listopad is empty and dropped.
      expect(r.years.single.rows, hasLength(3));

      final sep = r.years.single.rows[0];
      expect(sep.participated, isTrue);
      expect(sep.bibleStudies, 2);
      expect(sep.auxPioneer, isFalse);
      expect(sep.hours, 70);

      final oct = r.years.single.rows[1];
      expect(oct.auxPioneer, isTrue);
      expect(oct.bibleStudies, 2);
      expect(oct.hours, 68);

      final dec = r.years.single.rows[2];
      expect(dec.creditHours, 10);
      expect(dec.comments, 'Kredit: 10');
    });

    test('app export splits hours and credit back apart on re-import', () {
      // The app's export puts only field-service hours in the Hours column
      // and leads Remarks with a "Credit: n" note; re-importing such a card
      // must not fold the credit back into hours.
      final r = parseS21Import('''
CONGREGATION’S PUBLISHER RECORD
Name: Ann Smith
Service Year 2026 Shared in Ministry Bible Studies Auxiliary Pioneer Hours Remarks
September X 2 X 50 Credit: 5 — Memorial campaign
Total 50
''');
      final sep = r.years.single.rows.single;
      expect(sep.participated, isTrue);
      expect(sep.bibleStudies, 2);
      expect(sep.auxPioneer, isTrue);
      expect(sep.hours, 50); // not 55 — credit stays out of the Hours column
      expect(sep.creditHours, 5);
      expect(sep.comments, 'Credit: 5 — Memorial campaign');
    });

    test('decomposed official Turkish labels still match', () {
      // The official S-21-TK text layer splits diacritics into stray marks.
      final r = parseS21Import('''
˙
Isim: Ayşe Yılmaz
Do ˘
gum tarihi: 1990/01/02  Erkek  Kadın
Vaftiz tarihi: 2005/06/07
''');
      expect(r.name, 'Ayşe Yılmaz');
      expect(r.birthDate, '1990-01-02');
      expect(r.baptismDate, '2005-06-07');
    });
  });

  group('s21MonthKey', () {
    test('maps Sep-first service year to calendar months', () {
      expect(s21MonthKey(2026, 9), '2025-09');
      expect(s21MonthKey(2026, 12), '2025-12');
      expect(s21MonthKey(2026, 1), '2026-01');
      expect(s21MonthKey(2026, 8), '2026-08');
    });
  });

  group('splitS21Name', () {
    test('splits first/last name', () {
      expect(splitS21Name('Buse Skarda'), (first: 'Buse', last: 'Skarda'));
      expect(
        splitS21Name('Anna Maria Novak'),
        (first: 'Anna Maria', last: 'Novak'),
      );
      expect(splitS21Name('Cher'), (first: 'Cher', last: ''));
      expect(splitS21Name('  '), (first: '', last: ''));
    });
  });
}
