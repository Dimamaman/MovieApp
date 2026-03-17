import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moviecatalogue/ui/booking/booking_screen.dart';
import 'package:moviecatalogue/ui/detail/detail_screen.dart';
import 'package:shared/shared.dart';

/*

Yaratilgan testlar:

#	Test	Nima tekshiradi
1	displays movie title and overview	Film nomi va tavsifi ekranda ko'rinishi
2	displays Story line, Trailer, and Crew labels	"Story line", "Trailer", "Crew" sarlavhalari
3	displays Booking Ticket button	"Booking Ticket" tugmasi borligi
4	displays back and favorite buttons	Orqaga va sevimli ikonkalari
5	shows crew error message when CrewError	Crew xato holati — xato matni chiqishi
6	shows trailer error message when TrailerError	Trailer xato holati — xato matni chiqishi
7	shows crew no data message when CrewNoData	Crew ma'lumot yo'q holati
8	shows trailer no data message when TrailerNoData	Trailer ma'lumot yo'q holati
9	shows no internet widget for crew	Crew — internet yo'q, "Reload" tugmasi ko'rinishi
10	shows no internet widget for trailer	Trailer — internet yo'q, "Reload" tugmasi ko'rinishi
11	shows crew character names when CrewHasData	Crew ma'lumot bor bo'lsa, aktyor ismi ko'rinishi

*/

class MockTrailerBloc extends MockBloc<TrailerEvent, TrailerState>
    implements TrailerBloc {}

class MockCrewBloc extends MockBloc<CrewEvent, CrewState> implements CrewBloc {}

class FakeTrailerEvent extends Fake implements TrailerEvent {}

class FakeTrailerState extends Fake implements TrailerState {}

class FakeCrewEvent extends Fake implements CrewEvent {}

class FakeCrewState extends Fake implements CrewState {}

void main() {
  late MockTrailerBloc mockTrailerBloc;
  late MockCrewBloc mockCrewBloc;

  final tMovie = Movies(
    1,
    'Test Movie Title',
    'This is a test overview for the movie.',
    '2026-01-01',
    [28, 12],
    7.5,
    100.0,
    '/poster.jpg',
    '/backdrop.jpg',
    '',
    '',
  );

  final tArguments = ScreenArguments(tMovie, true, false);

  final tCrew = Crew('Sam Rockwell', 'The Hero', '/profile.jpg');
  final tResultCrew = ResultCrew([tCrew]);

  setUpAll(() {
    registerFallbackValue(FakeTrailerEvent());
    registerFallbackValue(FakeTrailerState());
    registerFallbackValue(FakeCrewEvent());
    registerFallbackValue(FakeCrewState());
  });

  setUp(() {
    mockTrailerBloc = MockTrailerBloc();
    mockCrewBloc = MockCrewBloc();
  });

  Future<void> pumpDetailScreen(
    WidgetTester tester, {
    required TrailerState trailerState,
    required CrewState crewState,
  }) async {
    when(() => mockTrailerBloc.state).thenReturn(trailerState);
    when(() => mockCrewBloc.state).thenReturn(crewState);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<TrailerBloc>.value(value: mockTrailerBloc),
          BlocProvider<CrewBloc>.value(value: mockCrewBloc),
        ],
        child: MaterialApp(
          routes: {
            BookingScreen.routeName: (context) =>
                const Scaffold(body: Text('Booking')),
          },
          home: DetailScreen(arguments: tArguments),
        ),
      ),
    );

    // CustomButton has an AnimationController so pumpAndSettle won't work;
    // pump enough frames for the widget tree to build.
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 2));
  }

  group('DetailScreen', () {
    testWidgets('displays movie title and overview', (tester) async {
      await pumpDetailScreen(
        tester,
        trailerState: InitialTrailer(),
        crewState: InitialCrew(),
      );

      expect(find.text('Test Movie Title'), findsOneWidget);
      expect(
        find.text('This is a test overview for the movie.'),
        findsOneWidget,
      );
    });

    testWidgets('displays Story line, Trailer, and Crew labels', (
      tester,
    ) async {
      await pumpDetailScreen(
        tester,
        trailerState: InitialTrailer(),
        crewState: InitialCrew(),
      );

      expect(find.text('Story line'), findsOneWidget);
      expect(find.text('Trailer'), findsOneWidget);
      expect(find.text('Crew'), findsOneWidget);
    });

    testWidgets('displays Booking Ticket button', (tester) async {
      await pumpDetailScreen(
        tester,
        trailerState: InitialTrailer(),
        crewState: InitialCrew(),
      );

      expect(find.text('Booking Ticket'), findsOneWidget);
    });

    testWidgets('displays back and favorite buttons', (tester) async {
      await pumpDetailScreen(
        tester,
        trailerState: InitialTrailer(),
        crewState: InitialCrew(),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Icon &&
              (w.icon == Icons.arrow_back || w.icon == Icons.arrow_back_ios),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows crew error message when CrewError', (tester) async {
      await pumpDetailScreen(
        tester,
        trailerState: InitialTrailer(),
        crewState: const CrewError('Crew load failed'),
      );

      expect(find.text('Crew load failed'), findsOneWidget);
    });

    testWidgets('shows trailer error message when TrailerError', (
      tester,
    ) async {
      await pumpDetailScreen(
        tester,
        trailerState: const TrailerError('Trailer load failed'),
        crewState: InitialCrew(),
      );

      expect(find.text('Trailer load failed'), findsOneWidget);
    });

    testWidgets('shows crew no data message when CrewNoData', (tester) async {
      await pumpDetailScreen(
        tester,
        trailerState: InitialTrailer(),
        crewState: const CrewNoData('No crew found'),
      );

      expect(find.text('No crew found'), findsOneWidget);
    });

    testWidgets('shows trailer no data message when TrailerNoData', (
      tester,
    ) async {
      await pumpDetailScreen(
        tester,
        trailerState: const TrailerNoData('No trailer found'),
        crewState: InitialCrew(),
      );

      expect(find.text('No trailer found'), findsOneWidget);
    });

    testWidgets('shows no internet widget for crew', (tester) async {
      await pumpDetailScreen(
        tester,
        trailerState: InitialTrailer(),
        crewState: CrewNoInternetConnection(),
      );

      expect(
        find.text(AppConstant.noInternetConnection),
        findsAtLeastNWidgets(1),
      );
      expect(find.text('Reload'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows no internet widget for trailer', (tester) async {
      await pumpDetailScreen(
        tester,
        trailerState: TrailerNoInternetConnection(),
        crewState: InitialCrew(),
      );

      expect(
        find.text(AppConstant.noInternetConnection),
        findsAtLeastNWidgets(1),
      );
      expect(find.text('Reload'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows crew character names when CrewHasData', (tester) async {
      await pumpDetailScreen(
        tester,
        trailerState: InitialTrailer(),
        crewState: CrewHasData(tResultCrew),
      );

      expect(find.text('The Hero'), findsOneWidget);
    });
  });
}
