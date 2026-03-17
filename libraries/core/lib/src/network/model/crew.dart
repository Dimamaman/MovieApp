import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'crew.g.dart';

@JsonSerializable()
class ResultCrew extends Equatable {
  @JsonKey(name: 'cast')
  final List<Crew> crew;

  const ResultCrew([this.crew = const []]);

  @override
  List<Object> get props => [crew];

  factory ResultCrew.fromJson(Map<String, dynamic> json) =>
      _$ResultCrewFromJson(json);

  Map<String, dynamic> toJson() => _$ResultCrewToJson(this);
}

@JsonSerializable()
class Crew extends Equatable {
  @JsonKey(name: 'name', defaultValue: '')
  final String realName;

  @JsonKey(name: 'character', defaultValue: '')
  final String characterName;

  @JsonKey(name: 'profile_path', defaultValue: '')
  final String profile;

  Crew(this.realName, this.characterName, this.profile);

  @override
  List<Object> get props => [realName, characterName, profile];

  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);

  Map<String, dynamic> toJson() => _$CrewToJson(this);
}
