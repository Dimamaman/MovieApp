import 'package:flutter_test/flutter_test.dart';
import 'package:shared/common.dart';

void main() {
  group('StringExtension.imageOriginal', () {
    test('prepends TMDB original image URL', () {
      const path = '/poster.jpg';
      expect(
        path.imageOriginal,
        'https://image.tmdb.org/t/p/original/poster.jpg',
      );
    });

    test('works with empty string', () {
      const path = '';
      expect(path.imageOriginal, 'https://image.tmdb.org/t/p/original');
    });

    test('works with backdrop path', () {
      const path = '/backdrop123.jpg';
      expect(
        path.imageOriginal,
        'https://image.tmdb.org/t/p/original/backdrop123.jpg',
      );
    });
  });
}
