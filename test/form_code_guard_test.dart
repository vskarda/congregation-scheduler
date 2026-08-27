import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Official form codes that must never reach a user.
///
/// The territory assignment record and the congregation meeting attendance
/// record are reproduced from official sheets, and the circuit overseer's view
/// takes its wording from one — but their codes stay out of the interface and
/// out of every generated PDF. `S-1` and `S-21` are deliberately not on this
/// list: those two are named in the app on purpose.
const _bannedCodes = ['13', '88', '61'];

/// `S` + an optional separator + the number, not glued to another letter or
/// digit. Written this way so `S-1`, `S-21` and a stray `S-880` do not trip it,
/// while `S-13`, `S 88` and `S–61` all do.
final _banned = RegExp(
  '(?<![A-Za-z0-9])[Ss][-–‑ ]?(${_bannedCodes.join('|')})'
  r'(?![0-9])',
);

void main() {
  test('no locale ships an official form code in a user-visible string', () {
    final arbs = Directory('lib/l10n')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.arb'))
        .toList();
    expect(arbs, isNotEmpty, reason: 'no ARB files found to check');

    final offenders = <String>[];
    for (final file in arbs) {
      final messages =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      messages.forEach((key, value) {
        // `@key` entries hold placeholder metadata, not text shown to anyone.
        if (key.startsWith('@') || value is! String) return;
        final match = _banned.firstMatch(value);
        if (match != null) {
          offenders.add('${file.path} · $key · "${match.group(0)}"');
        }
      });
    }

    expect(
      offenders,
      isEmpty,
      reason: 'These strings name an official form code:\n'
          '${offenders.join('\n')}',
    );
  });

  test('the guard actually catches what it is meant to catch', () {
    expect(_banned.hasMatch('TERRITORY ASSIGNMENT RECORD S-13-E 1/22'), isTrue);
    expect(_banned.hasMatch('S-88-TK 12/18'), isTrue);
    expect(_banned.hasMatch('Import the S 61 form'), isTrue);
    // Allowed, and in the ARB files today.
    expect(_banned.hasMatch('S-1 report'), isFalse);
    expect(_banned.hasMatch('Import S-21 records'), isFalse);
    expect(_banned.hasMatch('S-21-E 11/23'), isFalse);
    // Not a form code.
    expect(_banned.hasMatch('BS-13'), isFalse);
    expect(_banned.hasMatch('S-880'), isFalse);
  });
}
