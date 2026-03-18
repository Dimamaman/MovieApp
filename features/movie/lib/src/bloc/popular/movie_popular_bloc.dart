import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:common/common.dart';

import 'movie_popular_event.dart';
import 'movie_popular_state.dart';

class MoviePopularBloc extends Bloc<MoviePopularEvent, MoviePopularState> {
  final Repository repository;

  MoviePopularBloc({required this.repository}) : super(InitialMoviePopular()) {
    on<LoadMoviePopular>((event, emit) async {
      await _loadPopular(emit);
    });
  }

  Future<void> _loadPopular(Emitter<MoviePopularState> emit) async {
    try {
      emit(MoviePopularLoading());
      var movies = await repository.getMoviePopular(
        ApiConstant.apiKey,
        ApiConstant.language,
      );
      if (movies.results.isEmpty) {
        emit(MoviePopularNoData(AppConstant.noData));
      } else {
        emit(MoviePopularHasData(movies));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(MoviePopularNoInternetConnection());
      } else if (e.type == DioExceptionType.unknown) {
        emit(MoviePopularNoInternetConnection());
      } else {
        emit(MoviePopularError(e.toString()));
      }
    }
  }
}
