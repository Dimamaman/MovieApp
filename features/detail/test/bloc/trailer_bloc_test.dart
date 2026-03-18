import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:feature_detail/feature_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/test_helper.dart';

void main() {
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
  });

  group('TrailerBloc - Movie', () {
    blocTest<TrailerBloc, TrailerState>(
      'emits [Loading, HasData] when movie trailer is loaded successfully',
      build: () {
        when(() => mockRepository.getMovieTrailer(any(), any(), any()))
            .thenAnswer((_) async => tResultTrailer);
        return TrailerBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadTrailer(1, true)),
      expect: () => [
        TrailerLoading(),
        TrailerHasData(tResultTrailer),
      ],
    );

    blocTest<TrailerBloc, TrailerState>(
      'emits [Loading, NoData] when movie trailer is empty',
      build: () {
        when(() => mockRepository.getMovieTrailer(any(), any(), any()))
            .thenAnswer((_) async => tEmptyResultTrailer);
        return TrailerBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadTrailer(1, true)),
      expect: () => [
        TrailerLoading(),
        isA<TrailerNoData>(),
      ],
    );

    blocTest<TrailerBloc, TrailerState>(
      'emits [Loading, NoInternetConnection] on connection timeout',
      build: () {
        when(() => mockRepository.getMovieTrailer(any(), any(), any()))
            .thenThrow(
          DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        return TrailerBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadTrailer(1, true)),
      expect: () => [
        TrailerLoading(),
        TrailerNoInternetConnection(),
      ],
    );
  });

  group('TrailerBloc - TV Show', () {
    blocTest<TrailerBloc, TrailerState>(
      'emits [Loading, HasData] when tv show trailer is loaded successfully',
      build: () {
        when(() => mockRepository.getTvShowTrailer(any(), any(), any()))
            .thenAnswer((_) async => tResultTrailer);
        return TrailerBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadTrailer(1, false)),
      expect: () => [
        TrailerLoading(),
        TrailerHasData(tResultTrailer),
      ],
    );

    blocTest<TrailerBloc, TrailerState>(
      'emits [Loading, NoData] when tv show trailer is empty',
      build: () {
        when(() => mockRepository.getTvShowTrailer(any(), any(), any()))
            .thenAnswer((_) async => tEmptyResultTrailer);
        return TrailerBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadTrailer(1, false)),
      expect: () => [
        TrailerLoading(),
        isA<TrailerNoData>(),
      ],
    );
  });
}

