import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moviecatalogue/ui/about/about_screen.dart';

void main() {
  void ignoreOverflowErrors(FlutterErrorDetails details) {
    if (details.exceptionAsString().contains('overflowed')) return;
    FlutterError.dumpErrorToConsole(details);
  }

  Future<void> _pumpAboutScreen(WidgetTester tester) async {
    FlutterError.onError = ignoreOverflowErrors;
    await tester.pumpWidget(MaterialApp(home: AboutScreen()));
    await tester.pumpAndSettle();
  }

  group('AboutScreen', () {
    tearDown(() {
      FlutterError.onError = FlutterError.dumpErrorToConsole;
    });

    testWidgets('displays profile information', (tester) async {
      await _pumpAboutScreen(tester);

      expect(find.text('R Rifa Fauzi Komara'), findsOneWidget);
      expect(find.text('rifafauzi6'), findsOneWidget);
    });

    testWidgets('displays portfolio section and items', (tester) async {
      await _pumpAboutScreen(tester);

      expect(find.text('My Portfolio'), findsOneWidget);
      expect(find.text('LinkedIn'), findsOneWidget);
      expect(find.text('GitHub'), findsOneWidget);
      expect(find.text('Resume'), findsOneWidget);
    });

    testWidgets('shows back button icon', (tester) async {
      await _pumpAboutScreen(tester);

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Icon &&
              (w.icon == Icons.arrow_back || w.icon == Icons.arrow_back_ios),
        ),
        findsOneWidget,
      );
    });
  });
}
