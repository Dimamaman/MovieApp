import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:common/common.dart';

void main() {
  group('CustomButton', () {
    testWidgets('displays button text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(text: 'Book Now', onPressed: () {}),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 3));

      expect(find.text('Book Now'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CustomButton(
                text: 'Tap Me',
                onPressed: () => pressed = true,
              ),
            ),
          ),
        ),
      );
      // Wait for the animation to complete (800ms delay + 2000ms animation)
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pump(const Duration(milliseconds: 2000));
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.text('Tap Me'), warnIfMissed: false);
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('shows empty text when text is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CustomButton(onPressed: () {})),
        ),
      );
      await tester.pump(const Duration(seconds: 3));

      expect(find.text(''), findsOneWidget);
    });
  });
}
