import 'package:equatable/equatable.dart';

class Crew extends Equatable {
  final String name;
  final String character;
  final String profileUrl;

  const Crew({
    required this.name,
    required this.character,
    required this.profileUrl,
  });

  @override
  List<Object> get props => [name, character, profileUrl];
}

