import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:common/common.dart';

void main() {
  group('RatingInformation', () {
    testWidgets('displays rating value and labels', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: RatingInformation(rating: 7.5))),
      );

      expect(find.text('7.5'), findsOneWidget);
      expect(find.text('Ratings'), findsOneWidget);
      expect(find.text('Grade now'), findsOneWidget);
    });

    testWidgets('displays 5 star icons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: RatingInformation(rating: 7.5))),
      );

      expect(find.byIcon(Icons.star), findsNWidgets(5));
    });

    testWidgets('displays 0.0 when rating is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: RatingInformation())),
      );

      expect(find.text('0.0'), findsOneWidget);
    });
  });

  group('CircleProgress', () {
    testWidgets('displays percentage from vote', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CircleProgress(vote: '7.5')),
        ),
      );

      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('displays 0% when vote is 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CircleProgress(vote: '0')),
        ),
      );

      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('displays 0% when vote is null (defaults to "0")', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CircleProgress())),
      );

      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('displays 100% for vote 10', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CircleProgress(vote: '10')),
        ),
      );

      expect(find.text('100%'), findsOneWidget);
    });
  });
}
