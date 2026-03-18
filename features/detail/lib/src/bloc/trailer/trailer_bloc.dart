import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'trailer_event.dart';
import 'trailer_state.dart';

class TrailerBloc extends Bloc<TrailerEvent, TrailerState> {
  final Repository repository;

  TrailerBloc({required this.repository}) : super(InitialTrailer()) {
    on<LoadTrailer>((event, emit) async {
      if (event.isFromMovie) {
        await _loadMovieTrailer(event.movieId, emit);
      } else {
        await _loadTvShowTrailer(event.movieId, emit);
      }
    });
  }

  Future<void> _loadMovieTrailer(
    int movieId,
    Emitter<TrailerState> emit,
  ) async {
    try {
      emit(TrailerLoading());
      var movies = await repository.getMovieTrailer(
        movieId,
        ApiConstant.apiKey,
        ApiConstant.language,
      );
      if (movies.trailer.isEmpty) {
        emit(TrailerNoData(AppConstant.noTrailer));
      } else {
        emit(TrailerHasData(movies));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(TrailerNoInternetConnection());
      } else if (e.type == DioExceptionType.unknown) {
        emit(TrailerNoInternetConnection());
      } else {
        emit(TrailerError(e.toString()));
      }
    }
  }

  Future<void> _loadTvShowTrailer(
    int movieId,
    Emitter<TrailerState> emit,
  ) async {
    try {
      emit(TrailerLoading());
      var tvShow = await repository.getTvShowTrailer(
        movieId,
        ApiConstant.apiKey,
        ApiConstant.language,
      );
      if (tvShow.trailer.isEmpty) {
        emit(TrailerNoData(AppConstant.noTrailer));
      } else {
        emit(TrailerHasData(tvShow));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(TrailerNoInternetConnection());
      } else if (e.type == DioExceptionType.unknown) {
        emit(TrailerNoInternetConnection());
      } else {
        emit(TrailerError(e.toString()));
      }
    }
  }
}

