import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'tv_popular_event.dart';
import 'tv_popular_state.dart';

class TvPopularBloc extends Bloc<TvPopularEvent, TvPopularState> {
  final Repository repository;

  TvPopularBloc({required this.repository}) : super(InitialTvPopular()) {
    on<LoadTvPopular>((event, emit) async {
      await _loadTvPopular(emit);
    });
  }

  Future<void> _loadTvPopular(Emitter<TvPopularState> emit) async {
    try {
      emit(TvPopularLoading());
      var movies = await repository.getTvPopular(
          ApiConstant.apiKey, ApiConstant.language);
      if (movies.results.isEmpty) {
        emit(TvPopularNoData(AppConstant.noData));
      } else {
        emit(TvPopularHasData(movies));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(TvPopularNoInternetConnection());
      } else if (e.type == DioExceptionType.unknown) {
        emit(TvPopularNoInternetConnection());
      } else {
        emit(TvPopularError(e.toString()));
      }
    }
  }
}
