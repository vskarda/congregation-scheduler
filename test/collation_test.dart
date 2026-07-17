import 'package:congregation_scheduler/core/utils/collation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<String> sorted(List<String> names) => [...names]..sort(collate);

  group('foldForSort', () {
    test('folds Czech diacritics to base letters', () {
      expect(foldForSort('Šimek'), 'simek');
      expect(foldForSort('Řehoř'), 'rehor');
      expect(foldForSort('Žižka'), 'zizka');
    });

    test('folds Turkish diacritics to base letters', () {
      expect(foldForSort('Çağrı'), 'cagri');
      expect(foldForSort('Şişman'), 'sisman');
      expect(foldForSort('Öztürk'), 'ozturk');
    });

    test('leaves plain ASCII unchanged (lowercased)', () {
      expect(foldForSort('Novak'), 'novak');
    });
  });

  group('collate', () {
    test('accented names sort among their base letter, not after z', () {
      expect(sorted(['Zeman', 'Šimek', 'Novák']),
          ['Novák', 'Šimek', 'Zeman']);
    });

    test('š orders right after plain s on an equal remainder', () {
      expect(sorted(['Šova', 'Sova']), ['Sova', 'Šova']);
      expect(sorted(['Čapek', 'Capek']), ['Capek', 'Čapek']);
    });

    test('accented word interleaves by its folded remainder', () {
      expect(sorted(['Simon', 'Skala', 'Šimek']),
          ['Šimek', 'Simon', 'Skala']);
    });

    test('is case-insensitive', () {
      expect(collate('novak', 'NOVAK'), 0);
    });

    test('preserves plain alphabetical order', () {
      expect(sorted(['Carter', 'Adams', 'Baker']),
          ['Adams', 'Baker', 'Carter']);
    });
  });
}
