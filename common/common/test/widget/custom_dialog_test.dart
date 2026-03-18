import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:common/common.dart';

void main() {
  group('CustomDialog', () {
    testWidgets('displays Switch Theme title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDialog(
              isDark: false,
              groupValue: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Switch Theme'), findsOneWidget);
    });

    testWidgets('displays Dark and Light options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDialog(
              isDark: false,
              groupValue: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Dark'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
    });

    testWidgets('has two Radio buttons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDialog(
              isDark: false,
              groupValue: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(Radio<bool>), findsNWidgets(2));
    });

    testWidgets('calls onChanged when Dark radio is tapped', (tester) async {
      bool? selectedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomDialog(
              isDark: false,
              groupValue: false,
              onChanged: (val) => selectedValue = val,
            ),
          ),
        ),
      );

      await tester.tap(
        find.byWidgetPredicate((w) => w is Radio<bool> && w.value == true),
      );
      await tester.pump();

      expect(selectedValue, isTrue);
    });
  });
}
