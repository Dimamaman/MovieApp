import 'package:core/core.dart';
import 'package:feature_movie/feature_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';

void main() {
  late MoviesUI tMovieUI;
  late ScreenArguments tArguments;

  setUp(() {
    final tMovie = Movies(
      1,
      'Test Booking Movie',
      'Overview',
      '2026-01-01',
      const [28],
      8.0,
      120.0,
      '/poster.jpg',
      '/backdrop.jpg',
      '',
      '',
    );

    tMovieUI = tMovie.toUI(true);
    tArguments = ScreenArguments(tMovieUI, true, false);
  });

  Future<void> pumpBookingScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BookingScreen(arguments: tArguments),
      ),
    );

    await tester.pump(const Duration(seconds: 1));
  }

  void ignoreOverflowErrors(FlutterErrorDetails details) {
    if (details.exceptionAsString().contains('overflowed')) return;
    FlutterError.dumpErrorToConsole(details);
  }

  group('BookingScreen', () {
    test('has correct route constant', () {
      expect(MovieRoutes.booking, '/booking');
    });

    testWidgets('displays app bar with movie title', (tester) async {
      await pumpBookingScreen(tester);

      expect(find.text('Test Booking Movie'), findsOneWidget);
    });

    testWidgets('shows DateWidget, TimeWidget, CinemaWidget', (tester) async {
      await pumpBookingScreen(tester);

      expect(find.byType(DateWidget), findsOneWidget);
      expect(find.byType(TimeWidget), findsOneWidget);
      expect(find.byType(CinemaWidget), findsOneWidget);
    });

    testWidgets('shows Pay button', (tester) async {
      await pumpBookingScreen(tester);

      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.text('Pay'), findsOneWidget);
    });

    testWidgets('tapping Pay shows SmoothDialog', (tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = ignoreOverflowErrors;
      addTearDown(() => FlutterError.onError = originalOnError);

      await pumpBookingScreen(tester);

      final button =
          tester.widget<CustomButton>(find.byType(CustomButton));
      button.onPressed?.call();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Payment Successful!'), findsOneWidget);
      expect(
        find.text('Thanks for your movie ticket order'),
        findsOneWidget,
      );
    });

    testWidgets('dialog shows Done and Cancel buttons', (tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = ignoreOverflowErrors;
      addTearDown(() => FlutterError.onError = originalOnError);

      await pumpBookingScreen(tester);

      final button =
          tester.widget<CustomButton>(find.byType(CustomButton));
      button.onPressed?.call();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('tapping Cancel closes the dialog', (tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = ignoreOverflowErrors;
      addTearDown(() => FlutterError.onError = originalOnError);

      await pumpBookingScreen(tester);

      final button =
          tester.widget<CustomButton>(find.byType(CustomButton));
      button.onPressed?.call();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Payment Successful!'), findsOneWidget);

      final cancelInkWell = find.ancestor(
        of: find.text('Cancel'),
        matching: find.byType(InkWell),
      );
      expect(cancelInkWell, findsOneWidget);
      final inkWellWidget = tester.widget<InkWell>(cancelInkWell.first);
      inkWellWidget.onTap?.call();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Payment Successful!'), findsNothing);
    });
  });
}
