import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String releaseDate;
  final String releaseYear;
  final List<String> genres;
  final List<int> genreIds;
  final String genreText;
  final double rating;
  final String ratingText;
  final String ratingPercent;
  final String posterUrl;
  final String backdropUrl;
  final bool isMovie;

  const Movie({
    required this.id,
    required this.name,
    required this.overview,
    required this.releaseDate,
    required this.releaseYear,
    required this.genres,
    required this.genreIds,
    required this.genreText,
    required this.rating,
    required this.ratingText,
    required this.ratingPercent,
    required this.posterUrl,
    required this.backdropUrl,
    required this.isMovie,
  });

  @override
  List<Object> get props => [
        id,
        name,
        overview,
        releaseDate,
        releaseYear,
        genres,
        genreIds,
        genreText,
        rating,
        ratingText,
        ratingPercent,
        posterUrl,
        backdropUrl,
        isMovie,
      ];
}

