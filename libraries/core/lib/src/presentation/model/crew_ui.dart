import 'package:equatable/equatable.dart';

class CrewUI extends Equatable {
  final String name;
  final String character;
  final String profileUrl;

  const CrewUI({
    required this.name,
    required this.character,
    required this.profileUrl,
  });

  @override
  List<Object> get props => [name, character, profileUrl];
}
