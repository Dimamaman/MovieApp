import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';

void main() {
  group('ColorPalettes.getColorCircleProgress', () {
    test('returns red for rating <= 4.5', () {
      expect(ColorPalettes.getColorCircleProgress(0), ColorPalettes.red);
      expect(ColorPalettes.getColorCircleProgress(2.0), ColorPalettes.red);
      expect(ColorPalettes.getColorCircleProgress(4.5), ColorPalettes.red);
    });

    test('returns yellow for rating > 4.5 and < 7', () {
      expect(ColorPalettes.getColorCircleProgress(5.0), ColorPalettes.yellow);
      expect(ColorPalettes.getColorCircleProgress(6.0), ColorPalettes.yellow);
      expect(ColorPalettes.getColorCircleProgress(6.9), ColorPalettes.yellow);
    });

    test('returns green for rating >= 7', () {
      expect(ColorPalettes.getColorCircleProgress(7.0), ColorPalettes.green);
      expect(ColorPalettes.getColorCircleProgress(8.5), ColorPalettes.green);
      expect(ColorPalettes.getColorCircleProgress(10.0), ColorPalettes.green);
    });
  });

  group('ColorPalettes static colors', () {
    test('white is 0xffffffff', () {
      expect(ColorPalettes.white, const Color(0xffffffff));
    });

    test('black is 0xFF000000', () {
      expect(ColorPalettes.black, const Color(0xFF000000));
    });

    test('transparent is 0x00000000', () {
      expect(ColorPalettes.transparent, const Color(0x00000000));
    });
  });
}
