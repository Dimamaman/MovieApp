import 'package:core/core.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements Repository {}

final tCrew = Crew('Sam Rockwell', 'Character', '/profile.jpg');
final tResultCrew = ResultCrew([tCrew]);
final tEmptyResultCrew = ResultCrew([]);

final tTrailer = Trailer('trailer1', 'youtubeKey123', 'Official Trailer');
final tResultTrailer = ResultTrailer([tTrailer]);
final tEmptyResultTrailer = ResultTrailer([]);

