import 'package:core/src/network/model/genres.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movies.g.dart';

@JsonSerializable()
class Result extends Equatable {
  @JsonKey(name: 'results')
  final List<Movies> results;

  const Result([this.results = const []]);

  @override
  List<Object> get props => [results];

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class Movies extends Equatable {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title', defaultValue: '')
  final String title;

  @JsonKey(name: 'overview', defaultValue: '')
  final String overview;

  @JsonKey(name: 'release_date', defaultValue: '')
  final String releaseDate;

  @JsonKey(name: 'genre_ids')
  final List<int> genreIds;

  @JsonKey(name: 'vote_average')
  final double voteAverage;

  @JsonKey(name: 'popularity')
  final double popularity;

  @JsonKey(name: 'poster_path', defaultValue: '')
  final String posterPath;

  @JsonKey(name: 'backdrop_path', defaultValue: '')
  final String backdropPath;

  @JsonKey(name: 'original_name', defaultValue: '')
  final String tvName;

  @JsonKey(name: 'first_air_date', defaultValue: '')
  final String tvRelease;

  Movies(
    this.id,
    this.title,
    this.overview,
    this.releaseDate,
    this.genreIds,
    this.voteAverage,
    this.popularity,
    this.posterPath,
    this.backdropPath,
    this.tvName,
    this.tvRelease,
  );

  @override
  List<Object> get props => [
    id,
    title,
    overview,
    releaseDate,
    genreIds,
    voteAverage,
    popularity,
    posterPath,
    backdropPath,
    tvName,
    tvRelease,
  ];

  factory Movies.fromJson(Map<String, dynamic> json) => _$MoviesFromJson(json);

  Map<String, dynamic> toJson() => _$MoviesToJson(this);

  Movie toEntity(bool isMovie) {
    final name = isMovie ? title : tvName;
    final date = isMovie ? releaseDate : tvRelease;
    final year = date.length >= 4 ? date.substring(0, 4) : '-';
    final genreNames = genreIds
        .map((id) => Genres.genres[id] ?? '')
        .where((g) => g.isNotEmpty)
        .toList();
    const imageBase = 'https://image.tmdb.org/t/p/original';

    return Movie(
      id: id,
      name: name,
      overview: overview,
      releaseDate: date,
      releaseYear: year,
      genres: genreNames,
      genreIds: genreIds,
      genreText: genreNames.take(3).join(', '),
      rating: voteAverage,
      ratingText: voteAverage.toStringAsFixed(1),
      ratingPercent: '${(voteAverage * 10).toInt()}%',
      posterUrl: '$imageBase$posterPath',
      backdropUrl: '$imageBase$backdropPath',
      isMovie: isMovie,
    );
  }
}
