import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'crew_event.dart';
import 'crew_state.dart';

class CrewBloc extends Bloc<CrewEvent, CrewState> {
  final Repository repository;

  CrewBloc({required this.repository}) : super(InitialCrew()) {
    on<LoadCrew>((event, emit) async {
      if (event.isFromMovie) {
        await _loadMovieCrew(event.movieId, emit);
      } else {
        await _loadTvShowCrew(event.movieId, emit);
      }
    });
  }

  Future<void> _loadMovieCrew(int movieId, Emitter<CrewState> emit) async {
    try {
      emit(CrewLoading());
      var movies = await repository.getMovieCrew(
        movieId,
        ApiConstant.apiKey,
        ApiConstant.language,
      );
      if (movies.crew.isEmpty) {
        emit(CrewNoData(AppConstant.noCrew));
      } else {
        emit(CrewHasData(movies));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(CrewNoInternetConnection());
      } else if (e.type == DioExceptionType.unknown) {
        emit(CrewNoInternetConnection());
      } else {
        emit(CrewError(e.toString()));
      }
    }
  }

  Future<void> _loadTvShowCrew(int tvId, Emitter<CrewState> emit) async {
    try {
      emit(CrewLoading());
      var tvShow = await repository.getTvShowCrew(
        tvId,
        ApiConstant.apiKey,
        ApiConstant.language,
      );
      if (tvShow.crew.isEmpty) {
        emit(CrewNoData(AppConstant.noCrew));
      } else {
        emit(CrewHasData(tvShow));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(CrewNoInternetConnection());
      } else if (e.type == DioExceptionType.unknown) {
        emit(CrewNoInternetConnection());
      } else {
        emit(CrewError(e.toString()));
      }
    }
  }
}

