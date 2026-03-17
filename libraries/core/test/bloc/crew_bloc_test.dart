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

  group('CrewBloc - Movie', () {
    blocTest<CrewBloc, CrewState>(
      'emits [Loading, HasData] when movie crew is loaded successfully',
      build: () {
        when(() => mockRepository.getMovieCrew(any(), any(), any()))
            .thenAnswer((_) async => tResultCrew);
        return CrewBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadCrew(1, true)),
      expect: () => [
        CrewLoading(),
        CrewHasData(tResultCrew),
      ],
    );

    blocTest<CrewBloc, CrewState>(
      'emits [Loading, NoData] when movie crew is empty',
      build: () {
        when(() => mockRepository.getMovieCrew(any(), any(), any()))
            .thenAnswer((_) async => tEmptyResultCrew);
        return CrewBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadCrew(1, true)),
      expect: () => [
        CrewLoading(),
        isA<CrewNoData>(),
      ],
    );

    blocTest<CrewBloc, CrewState>(
      'emits [Loading, NoInternetConnection] on connection timeout',
      build: () {
        when(() => mockRepository.getMovieCrew(any(), any(), any())).thenThrow(
          DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        return CrewBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadCrew(1, true)),
      expect: () => [
        CrewLoading(),
        CrewNoInternetConnection(),
      ],
    );
  });

  group('CrewBloc - TV Show', () {
    blocTest<CrewBloc, CrewState>(
      'emits [Loading, HasData] when tv show crew is loaded successfully',
      build: () {
        when(() => mockRepository.getTvShowCrew(any(), any(), any()))
            .thenAnswer((_) async => tResultCrew);
        return CrewBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadCrew(1, false)),
      expect: () => [
        CrewLoading(),
        CrewHasData(tResultCrew),
      ],
    );

    blocTest<CrewBloc, CrewState>(
      'emits [Loading, NoData] when tv show crew is empty',
      build: () {
        when(() => mockRepository.getTvShowCrew(any(), any(), any()))
            .thenAnswer((_) async => tEmptyResultCrew);
        return CrewBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadCrew(1, false)),
      expect: () => [
        CrewLoading(),
        isA<CrewNoData>(),
      ],
    );
  });
}
