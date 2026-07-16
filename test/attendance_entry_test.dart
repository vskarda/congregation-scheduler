import 'package:congregation_scheduler/core/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('legacy doc without total falls back to inPerson + online', () {
    final entry = AttendanceEntry.fromJson(const {
      'date': '2026-06-02',
      'meetingType': 'lmm',
      'inPerson': 40,
      'online': 10,
    });
    expect(entry.total, isNull);
    expect(entry.resolvedTotal, 50);
    expect(entry.hasData, isTrue);
  });

  test('a stored total wins over the split', () {
    const entry = AttendanceEntry(
        date: '2026-06-02', inPerson: 40, online: 10, total: 55);
    expect(entry.resolvedTotal, 55);
  });

  test('total-only record resolves and counts as data', () {
    const entry = AttendanceEntry(date: '2026-06-02', total: 50);
    expect(entry.resolvedTotal, 50);
    expect(entry.hasData, isTrue);
    expect(entry.inPerson, isNull);
    expect(entry.online, isNull);
  });

  test('empty entry has no data and null counts are not serialized', () {
    const entry = AttendanceEntry(date: '2026-06-02');
    expect(entry.hasData, isFalse);
    expect(entry.resolvedTotal, 0);
    final json = entry.toJson();
    expect(json.containsKey('inPerson'), isFalse);
    expect(json.containsKey('online'), isFalse);
    expect(json.containsKey('total'), isFalse);
  });
}
