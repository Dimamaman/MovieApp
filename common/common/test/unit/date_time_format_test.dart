import 'package:flutter_test/flutter_test.dart';
import 'package:common/common.dart';

void main() {
  group('DateTimeFormat.day', () {
    test('returns MO for Monday (1)', () {
      expect(DateTimeFormat.day(1), 'MO');
    });

    test('returns TU for Tuesday (2)', () {
      expect(DateTimeFormat.day(2), 'TU');
    });

    test('returns WE for Wednesday (3)', () {
      expect(DateTimeFormat.day(3), 'WE');
    });

    test('returns TH for Thursday (4)', () {
      expect(DateTimeFormat.day(4), 'TH');
    });

    test('returns FR for Friday (5)', () {
      expect(DateTimeFormat.day(5), 'FR');
    });

    test('returns SA for Saturday (6)', () {
      expect(DateTimeFormat.day(6), 'SA');
    });

    test('returns SU for Sunday (7)', () {
      expect(DateTimeFormat.day(7), 'SU');
    });

    test('returns MO for invalid day (0)', () {
      expect(DateTimeFormat.day(0), 'MO');
    });

    test('returns MO for invalid day (8)', () {
      expect(DateTimeFormat.day(8), 'MO');
    });
  });
}
