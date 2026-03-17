import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/test_helper.dart';

void main() {
  late MockApiRepository mockApiRepository;
  late MockLocalRepository mockLocalRepository;
  late MovieRepository repository;

  setUpAll(() {
    registerFallbackValue(tResult);
  });

  setUp(() {
    mockApiRepository = MockApiRepository();
    mockLocalRepository = MockLocalRepository();
    repository = MovieRepository(
      apiRepository: mockApiRepository,
      localRepository: mockLocalRepository,
    );
  });

  group('getMovieNowPlaying', () {
    test('returns local data when cache is available', () async {
      when(() => mockLocalRepository.getMovieNowPlaying(any(), any()))
          .thenAnswer((_) async => tResult);

      final result = await repository.getMovieNowPlaying();

      expect(result, tResult);
      verifyNever(() => mockApiRepository.getMovieNowPlaying(any(), any()));
    });

    test('returns API data and saves when cache is null', () async {
      when(() => mockLocalRepository.getMovieNowPlaying(any(), any()))
          .thenAnswer((_) async => null);
      when(() => mockApiRepository.getMovieNowPlaying(any(), any()))
          .thenAnswer((_) async => tResult);
      when(() => mockLocalRepository.saveMovieNowPlaying(any()))
          .thenAnswer((_) async => true);

      final result = await repository.getMovieNowPlaying();

      expect(result, tResult);
      verify(() => mockApiRepository.getMovieNowPlaying(any(), any()))
          .called(1);
      verify(() => mockLocalRepository.saveMovieNowPlaying(tResult)).called(1);
    });
  });

  group('getMoviePopular', () {
    test('returns local data when cache is available', () async {
      when(() => mockLocalRepository.getMoviePopular(any(), any()))
          .thenAnswer((_) async => tResult);

      final result = await repository.getMoviePopular();

      expect(result, tResult);
      verifyNever(() => mockApiRepository.getMoviePopular(any(), any()));
    });

    test('returns API data and saves when cache is null', () async {
      when(() => mockLocalRepository.getMoviePopular(any(), any()))
          .thenAnswer((_) async => null);
      when(() => mockApiRepository.getMoviePopular(any(), any()))
          .thenAnswer((_) async => tResult);
      when(() => mockLocalRepository.saveMoviePopular(any()))
          .thenAnswer((_) async => true);

      final result = await repository.getMoviePopular();

      expect(result, tResult);
      verify(() => mockApiRepository.getMoviePopular(any(), any())).called(1);
      verify(() => mockLocalRepository.saveMoviePopular(tResult)).called(1);
    });
  });

  group('getMovieUpComing', () {
    test('returns local data when cache is available', () async {
      when(() => mockLocalRepository.getMovieUpComing(any(), any()))
          .thenAnswer((_) async => tResult);

      final result = await repository.getMovieUpComing();

      expect(result, tResult);
      verifyNever(() => mockApiRepository.getMovieUpComing(any(), any()));
    });

    test('returns API data and saves when cache is null', () async {
      when(() => mockLocalRepository.getMovieUpComing(any(), any()))
          .thenAnswer((_) async => null);
      when(() => mockApiRepository.getMovieUpComing(any(), any()))
          .thenAnswer((_) async => tResult);
      when(() => mockLocalRepository.saveMovieUpComing(any()))
          .thenAnswer((_) async => true);

      final result = await repository.getMovieUpComing();

      expect(result, tResult);
      verify(() => mockApiRepository.getMovieUpComing(any(), any())).called(1);
      verify(() => mockLocalRepository.saveMovieUpComing(tResult)).called(1);
    });
  });

  group('getDiscoverMovie', () {
    test('returns local data when cache is available', () async {
      when(() => mockLocalRepository.getDiscoverMovie(any(), any()))
          .thenAnswer((_) async => tResult);

      final result = await repository.getDiscoverMovie();

      expect(result, tResult);
      verifyNever(() => mockApiRepository.getDiscoverMovie(any(), any()));
    });

    test('returns API data and saves when cache is null', () async {
      when(() => mockLocalRepository.getDiscoverMovie(any(), any()))
          .thenAnswer((_) async => null);
      when(() => mockApiRepository.getDiscoverMovie(any(), any()))
          .thenAnswer((_) async => tResult);
      when(() => mockLocalRepository.saveDiscoverMovie(any()))
          .thenAnswer((_) async => true);

      final result = await repository.getDiscoverMovie();

      expect(result, tResult);
      verify(() => mockApiRepository.getDiscoverMovie(any(), any())).called(1);
      verify(() => mockLocalRepository.saveDiscoverMovie(tResult)).called(1);
    });
  });

  group('getMovieCrew', () {
    test('returns crew data from API', () async {
      when(() => mockApiRepository.getMovieCrew(any(), any(), any()))
          .thenAnswer((_) async => tResultCrew);

      final result = await repository.getMovieCrew(1);

      expect(result, tResultCrew);
    });
  });

  group('getMovieTrailer', () {
    test('returns trailer data from API', () async {
      when(() => mockApiRepository.getMovieTrailer(any(), any(), any()))
          .thenAnswer((_) async => tResultTrailer);

      final result = await repository.getMovieTrailer(1);

      expect(result, tResultTrailer);
    });
  });

  group('getTvShowCrew', () {
    test('returns crew data from API', () async {
      when(() => mockApiRepository.getTvShowCrew(any(), any(), any()))
          .thenAnswer((_) async => tResultCrew);

      final result = await repository.getTvShowCrew(1);

      expect(result, tResultCrew);
    });
  });

  group('getTvShowTrailer', () {
    test('returns trailer data from API', () async {
      when(() => mockApiRepository.getTvShowTrailer(any(), any(), any()))
          .thenAnswer((_) async => tResultTrailer);

      final result = await repository.getTvShowTrailer(1);

      expect(result, tResultTrailer);
    });
  });
}
