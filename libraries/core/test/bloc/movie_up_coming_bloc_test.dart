import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/test_helper.dart';

void main() {
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
  });

  group('MovieUpComingBloc', () {
    test('initial state is InitialMovieUpComing', () {
      final bloc = MovieUpComingBloc(repository: mockRepository);
      expect(bloc.state, isA<InitialMovieUpComing>());
    });

    blocTest<MovieUpComingBloc, MovieUpComingState>(
      'emits [Loading, HasData] when data is loaded successfully',
      build: () {
        when(() => mockRepository.getMovieUpComing(any(), any()))
            .thenAnswer((_) async => tResult);
        return MovieUpComingBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadMovieUpComing()),
      expect: () => [
        MovieUpComingLoading(),
        MovieUpComingHasData(tResult),
      ],
    );

    blocTest<MovieUpComingBloc, MovieUpComingState>(
      'emits [Loading, NoData] when result is empty',
      build: () {
        when(() => mockRepository.getMovieUpComing(any(), any()))
            .thenAnswer((_) async => tEmptyResult);
        return MovieUpComingBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadMovieUpComing()),
      expect: () => [
        MovieUpComingLoading(),
        isA<MovieUpComingNoData>(),
      ],
    );

    blocTest<MovieUpComingBloc, MovieUpComingState>(
      'emits [Loading, NoInternetConnection] on connection timeout',
      build: () {
        when(() => mockRepository.getMovieUpComing(any(), any())).thenThrow(
          DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        return MovieUpComingBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadMovieUpComing()),
      expect: () => [
        MovieUpComingLoading(),
        MovieUpComingNoInternetConnection(),
      ],
    );

    blocTest<MovieUpComingBloc, MovieUpComingState>(
      'emits [Loading, Error] on other DioException',
      build: () {
        when(() => mockRepository.getMovieUpComing(any(), any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        return MovieUpComingBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadMovieUpComing()),
      expect: () => [
        MovieUpComingLoading(),
        isA<MovieUpComingError>(),
      ],
    );
  });
}
