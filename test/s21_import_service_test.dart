import 'package:congregation_scheduler/core/data/publishers_repository.dart';
import 'package:congregation_scheduler/core/data/reports_repository.dart';
import 'package:congregation_scheduler/core/models/models.dart';
import 'package:congregation_scheduler/features/publishers/s21/s21_import_parser.dart';
import 'package:congregation_scheduler/features/publishers/s21/s21_import_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

const _card = '''
S-21 Cemaat Müjdeci Kayıt Kartı
İsim: Buse Skarda
Doğum Tarihi: 1997/11/17 ¨ Erkek þ Kadın
Vaftiz Tarihi: 2014/07/05 þ Başka Koyun ¨ Meshedilmiş
¨ İhtiyar ¨ Hizmet Görevlisi ¨ Daimi Öncü þ Özel Öncü ¨ Görevli Vaiz
Hizmet Yılı
2025 Hizmete Katıldı
Eylül þ 3 ¨ 96
Ekim þ 3 þ 96 Kredi: 4
Kasım ¨ ¨
Toplam 192
''';

void main() {
  late FakeFirebaseFirestore db;
  late S21ImportService service;

  setUp(() {
    db = FakeFirebaseFirestore();
    service = S21ImportService(
      PublishersRepository(db),
      ReportsRepository(db),
    );
  });

  test('imports into an existing publisher: name kept, records replaced',
      () async {
    await db.collection('publishers').doc('p1').set({
      'firstName': 'Busika',
      'lastName': 'Skardová',
      'gender': 'unknown',
      'status': 'publisher',
      'verified': true,
      'hasAccount': true,
    });
    await db
        .collection('publishers')
        .doc('p1')
        .collection('private')
        .doc('profile')
        .set({'email': 'b@example.com', 'birthDate': '', 'hope': 'anointed'});
    // An existing report for Sep 2024 that the S-21 must overwrite.
    await db
        .collection('reports')
        .doc('2024-09')
        .collection('entries')
        .doc('p1')
        .set({'month': '2024-09', 'participated': false, 'hours': 5});

    final data = parseS21Import(_card);
    expect(data.years.single.serviceYear, 2025);

    final id = await service.import(
      data: data,
      existing: const Publisher(
        id: 'p1',
        firstName: 'Busika',
        lastName: 'Skardová',
        verified: true,
        hasAccount: true,
      ),
      existingPrivate:
          const PublisherPrivate(email: 'b@example.com', hope: Hope.anointed),
      firstName: 'Busika',
      lastName: 'Skardová',
      blockYears: const [2025],
      enteredBy: 'admin-uid',
    );
    expect(id, 'p1');

    final pub = (await db.collection('publishers').doc('p1').get()).data()!;
    // Name in the app wins; the card's other fields overwrite.
    expect(pub['firstName'], 'Busika');
    expect(pub['lastName'], 'Skardová');
    expect(pub['gender'], 'female');
    expect(pub['status'], 'specialPioneer');
    expect(pub['hasAccount'], true);

    final priv = (await db
            .collection('publishers')
            .doc('p1')
            .collection('private')
            .doc('profile')
            .get())
        .data()!;
    expect(priv['birthDate'], '1997-11-17');
    expect(priv['baptismDate'], '2014-07-05');
    expect(priv['hope'], 'otherSheep');
    expect(priv['appointment'], 'none');
    // Fields the card doesn't carry stay untouched.
    expect(priv['email'], 'b@example.com');

    final sep = (await db
            .collection('reports')
            .doc('2024-09')
            .collection('entries')
            .doc('p1')
            .get())
        .data()!;
    expect(sep['participated'], true);
    expect(sep['hours'], 96);
    expect(sep['bibleStudies'], 3);
    expect(sep['statusAtMonth'], 'specialPioneer');
    expect(sep['enteredBy'], 'admin-uid');

    final oct = (await db
            .collection('reports')
            .doc('2024-10')
            .collection('entries')
            .doc('p1')
            .get())
        .data()!;
    // Aux-pioneer box checked in October → status snapshot flips.
    expect(oct['statusAtMonth'], 'auxPioneer');
    expect(oct['creditHours'], 4);
    expect(oct['comments'], 'Kredi: 4');

    // Empty November row was dropped — no report written.
    final nov = await db
        .collection('reports')
        .doc('2024-11')
        .collection('entries')
        .doc('p1')
        .get();
    expect(nov.data(), isNull);
  });

  test('creates a new publisher from the card', () async {
    final data = parseS21Import(_card);
    final id = await service.import(
      data: data,
      firstName: 'Buse',
      lastName: 'Skarda',
      blockYears: const [2025],
      enteredBy: 'admin-uid',
    );

    final pub = (await db.collection('publishers').doc(id).get()).data()!;
    expect(pub['firstName'], 'Buse');
    expect(pub['lastName'], 'Skarda');
    expect(pub['verified'], true);
    expect(pub['hasAccount'], false);
    expect(pub['gender'], 'female');
    expect(pub['status'], 'specialPioneer');

    final priv = (await db
            .collection('publishers')
            .doc(id)
            .collection('private')
            .doc('profile')
            .get())
        .data()!;
    expect(priv['birthDate'], '1997-11-17');

    final reports = await db
        .collection('reports')
        .doc('2024-09')
        .collection('entries')
        .doc(id)
        .get();
    expect(reports.data()?['hours'], 96);
  });
}
