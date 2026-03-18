import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_up_coming_event.dart';
import 'movie_up_coming_state.dart';

class MovieUpComingBloc extends Bloc<MovieUpComingEvent, MovieUpComingState> {
  final Repository repository;

  MovieUpComingBloc({required this.repository}) : super(InitialMovieUpComing()) {
    on<LoadMovieUpComing>((event, emit) async {
      await _loadUpComing(emit);
    });
  }

  Future<void> _loadUpComing(Emitter<MovieUpComingState> emit) async {
    try {
      emit(MovieUpComingLoading());
      var movies = await repository.getMovieUpComing(
          ApiConstant.apiKey, ApiConstant.language);
      if (movies.results.isEmpty) {
        emit(MovieUpComingNoData(AppConstant.noData));
      } else {
        emit(MovieUpComingHasData(movies));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(MovieUpComingNoInternetConnection());
      } else if (e.type == DioExceptionType.unknown) {
        emit(MovieUpComingNoInternetConnection());
      } else {
        emit(MovieUpComingError(e.toString()));
      }
    }
  }
}
