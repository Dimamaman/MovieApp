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

  group('MoviePopularBloc', () {
    test('initial state is InitialMoviePopular', () {
      final bloc = MoviePopularBloc(repository: mockRepository);
      expect(bloc.state, isA<InitialMoviePopular>());
    });

    blocTest<MoviePopularBloc, MoviePopularState>(
      'emits [Loading, HasData] when data is loaded successfully',
      build: () {
        when(() => mockRepository.getMoviePopular(any(), any()))
            .thenAnswer((_) async => tResult);
        return MoviePopularBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadMoviePopular()),
      expect: () => [
        MoviePopularLoading(),
        MoviePopularHasData(tResult),
      ],
    );

    blocTest<MoviePopularBloc, MoviePopularState>(
      'emits [Loading, NoData] when result is empty',
      build: () {
        when(() => mockRepository.getMoviePopular(any(), any()))
            .thenAnswer((_) async => tEmptyResult);
        return MoviePopularBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadMoviePopular()),
      expect: () => [
        MoviePopularLoading(),
        isA<MoviePopularNoData>(),
      ],
    );

    blocTest<MoviePopularBloc, MoviePopularState>(
      'emits [Loading, NoInternetConnection] on connection timeout',
      build: () {
        when(() => mockRepository.getMoviePopular(any(), any())).thenThrow(
          DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        return MoviePopularBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadMoviePopular()),
      expect: () => [
        MoviePopularLoading(),
        MoviePopularNoInternetConnection(),
      ],
    );

    blocTest<MoviePopularBloc, MoviePopularState>(
      'emits [Loading, Error] on other DioException',
      build: () {
        when(() => mockRepository.getMoviePopular(any(), any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        return MoviePopularBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadMoviePopular()),
      expect: () => [
        MoviePopularLoading(),
        isA<MoviePopularError>(),
      ],
    );
  });
}
