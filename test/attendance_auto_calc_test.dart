import 'package:congregation_scheduler/features/attendance/attendance_auto_calc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('in person + online derive the total', () {
    final calc = AttendanceAutoCalc();
    expect(calc.edit(AttendanceField.inPerson, inPerson: 40), isNull);
    final result =
        calc.edit(AttendanceField.online, inPerson: 40, online: 10);
    expect(result, (field: AttendanceField.total, value: 50));
  });

  test('total + in person derive online', () {
    final calc = AttendanceAutoCalc();
    calc.edit(AttendanceField.total, total: 50);
    final result =
        calc.edit(AttendanceField.inPerson, inPerson: 40, total: 50);
    expect(result, (field: AttendanceField.online, value: 10));
  });

  test('total + online derive in person', () {
    final calc = AttendanceAutoCalc();
    calc.edit(AttendanceField.total, total: 50);
    final result = calc.edit(AttendanceField.online, online: 10, total: 50);
    expect(result, (field: AttendanceField.inPerson, value: 40));
  });

  test('editing the derived field re-derives the least recently typed one',
      () {
    final calc = AttendanceAutoCalc();
    calc.edit(AttendanceField.inPerson, inPerson: 40);
    calc.edit(AttendanceField.online, inPerson: 40, online: 10); // total: 50
    // Typing into the computed total keeps online (typed later than in
    // person) and recomputes in person.
    final result = calc.edit(AttendanceField.total,
        inPerson: 40, online: 10, total: 60);
    expect(result, (field: AttendanceField.inPerson, value: 50));
  });

  test('prefilled values with no typing history prefer recomputing total',
      () {
    final calc = AttendanceAutoCalc();
    // Editing a prefilled record (in person 40, online 10, total 50).
    final result = calc.edit(AttendanceField.inPerson,
        inPerson: 45, online: 10, total: 50);
    expect(result, (field: AttendanceField.total, value: 55));
  });

  test('editing total with no typing history prefers recomputing online', () {
    final calc = AttendanceAutoCalc();
    final result = calc.edit(AttendanceField.total,
        inPerson: 40, online: 10, total: 60);
    expect(result, (field: AttendanceField.online, value: 20));
  });

  test('contradictory counts yield a negative value', () {
    final calc = AttendanceAutoCalc();
    calc.edit(AttendanceField.total, total: 30);
    final result =
        calc.edit(AttendanceField.inPerson, inPerson: 40, total: 30);
    expect(result, (field: AttendanceField.online, value: -10));
  });

  test('a cleared field becomes the preferred derive target again', () {
    final calc = AttendanceAutoCalc();
    calc.edit(AttendanceField.total, total: 50);
    calc.edit(AttendanceField.online, online: 10, total: 50);
    calc.clear(AttendanceField.total);
    // Total forgotten: typing in person now derives total, not in person.
    final result =
        calc.edit(AttendanceField.inPerson, inPerson: 40, online: 10);
    expect(result, (field: AttendanceField.total, value: 50));
  });

  test('a single known count derives nothing', () {
    final calc = AttendanceAutoCalc();
    expect(calc.edit(AttendanceField.total, total: 50), isNull);
    expect(calc.edit(AttendanceField.total, total: 55), isNull);
  });
}
