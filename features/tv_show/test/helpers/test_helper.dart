import 'package:core/core.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements Repository {}

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
