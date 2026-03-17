import 'package:core/core.dart';
import 'package:core/src/local/shared_pref_helper.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements Repository {}

class MockApiRepository extends Mock implements ApiRepository {}

class MockLocalRepository extends Mock implements LocalRepository {}

class MockSharedPrefHelper extends Mock implements SharedPrefHelper {}

final tMovie = Movies(
  1,
  'Test Movie',
  'Test Overview',
  '2026-01-01',
  [28, 12],
  7.5,
  100.0,
  '/poster.jpg',
  '/backdrop.jpg',
  '',
  '',
);

final tResult = Result([tMovie]);
final tEmptyResult = Result([]);

final tCrew = Crew('Sam Rockwell', 'Character', '/profile.jpg');
final tResultCrew = ResultCrew([tCrew]);
final tEmptyResultCrew = ResultCrew([]);

final tTrailer = Trailer('trailer1', 'youtubeKey123', 'Official Trailer');
final tResultTrailer = ResultTrailer([tTrailer]);
final tEmptyResultTrailer = ResultTrailer([]);
