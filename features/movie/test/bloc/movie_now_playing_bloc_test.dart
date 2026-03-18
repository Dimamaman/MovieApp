import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:feature_movie/feature_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/test_helper.dart';

void main() {
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
  });

  group('MovieNowPlayingBloc', () {
    test('initial state is InitialMovieNowPlaying', () {
      final bloc = MovieNowPlayingBloc(repository: mockRepository);
      expect(bloc.state, isA<InitialMovieNowPlaying>());
    });

    blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
      'emits [Loading, HasData] when data is loaded successfully',
      build: () {
        when(() => mockRepository.getMovieNowPlaying(any(), any()))
            .thenAnswer((_) async => tResult);
        return MovieNowPlayingBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadMovieNowPlaying()),
      expect: () => [
        MovieNowPlayingLoading(),
        MovieNowPlayingHasData(tResult),
      ],
    );

    blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
      'emits [Loading, NoData] when result is empty',
      build: () {
        when(() => mockRepository.getMovieNowPlaying(any(), any()))
            .thenAnswer((_) async => tEmptyResult);
        return MovieNowPlayingBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadMovieNowPlaying()),
      expect: () => [
        MovieNowPlayingLoading(),
        isA<MovieNowPlayingNoData>(),
      ],
    );

    blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
      'emits [Loading, NoInternetConnection] on connection timeout',
      build: () {
        when(() => mockRepository.getMovieNowPlaying(any(), any())).thenThrow(
          DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        return MovieNowPlayingBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadMovieNowPlaying()),
      expect: () => [
        MovieNowPlayingLoading(),
        MovieNowPlayingNoInternetConnection(),
      ],
    );

    blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
      'emits [Loading, Error] on other DioException',
      build: () {
        when(() => mockRepository.getMovieNowPlaying(any(), any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        return MovieNowPlayingBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadMovieNowPlaying()),
      expect: () => [
        MovieNowPlayingLoading(),
        isA<MovieNowPlayingError>(),
      ],
    );
  });
}
