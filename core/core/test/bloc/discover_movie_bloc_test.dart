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

  group('DiscoverMovieBloc', () {
    test('initial state is InitialDiscoverMovie', () {
      final bloc = DiscoverMovieBloc(repository: mockRepository);
      expect(bloc.state, isA<InitialDiscoverMovie>());
    });

    blocTest<DiscoverMovieBloc, DiscoverMovieState>(
      'emits [Loading, HasData] when data is loaded successfully',
      build: () {
        when(() => mockRepository.getDiscoverMovie(any(), any()))
            .thenAnswer((_) async => tResult);
        return DiscoverMovieBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadDiscoverMovie()),
      expect: () => [
        DiscoverMovieLoading(),
        DiscoverMovieHasData(tResult),
      ],
    );

    blocTest<DiscoverMovieBloc, DiscoverMovieState>(
      'emits [Loading, NoData] when result is empty',
      build: () {
        when(() => mockRepository.getDiscoverMovie(any(), any()))
            .thenAnswer((_) async => tEmptyResult);
        return DiscoverMovieBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadDiscoverMovie()),
      expect: () => [
        DiscoverMovieLoading(),
        isA<DiscoverMovieNoData>(),
      ],
    );

    blocTest<DiscoverMovieBloc, DiscoverMovieState>(
      'emits [Loading, NoInternetConnection] on connection timeout',
      build: () {
        when(() => mockRepository.getDiscoverMovie(any(), any())).thenThrow(
          DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        return DiscoverMovieBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadDiscoverMovie()),
      expect: () => [
        DiscoverMovieLoading(),
        DiscoverMovieNoInternetConnection(),
      ],
    );

    blocTest<DiscoverMovieBloc, DiscoverMovieState>(
      'emits [Loading, NoInternetConnection] on unknown DioException',
      build: () {
        when(() => mockRepository.getDiscoverMovie(any(), any())).thenThrow(
          DioException(
            type: DioExceptionType.unknown,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        return DiscoverMovieBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadDiscoverMovie()),
      expect: () => [
        DiscoverMovieLoading(),
        DiscoverMovieNoInternetConnection(),
      ],
    );

    blocTest<DiscoverMovieBloc, DiscoverMovieState>(
      'emits [Loading, Error] on other DioException',
      build: () {
        when(() => mockRepository.getDiscoverMovie(any(), any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        return DiscoverMovieBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadDiscoverMovie()),
      expect: () => [
        DiscoverMovieLoading(),
        isA<DiscoverMovieError>(),
      ],
    );
  });
}
