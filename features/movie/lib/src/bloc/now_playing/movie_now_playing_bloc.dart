import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:common/common.dart';

import 'movie_now_playing_event.dart';
import 'movie_now_playing_state.dart';

class MovieNowPlayingBloc
    extends Bloc<MovieNowPlayingEvent, MovieNowPlayingState> {
  final Repository repository;

  MovieNowPlayingBloc({required this.repository})
    : super(InitialMovieNowPlaying()) {
    on<LoadMovieNowPlaying>((event, emit) async {
      await _loadNowPlaying(emit);
    });
  }

  Future<void> _loadNowPlaying(Emitter<MovieNowPlayingState> emit) async {
    try {
      emit(MovieNowPlayingLoading());
      var movies = await repository.getMovieNowPlaying(
        ApiConstant.apiKey,
        ApiConstant.language,
      );
      if (movies.results.isEmpty) {
        emit(MovieNowPlayingNoData(AppConstant.noData));
      } else {
        emit(MovieNowPlayingHasData(movies));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(MovieNowPlayingNoInternetConnection());
      } else if (e.type == DioExceptionType.unknown) {
        emit(MovieNowPlayingNoInternetConnection());
      } else {
        emit(MovieNowPlayingError(e.toString()));
      }
    }
  }
}
