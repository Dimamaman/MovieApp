import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/common.dart';

import 'tv_airing_today_event.dart';
import 'tv_airing_today_state.dart';

class TvAiringTodayBloc extends Bloc<TvAiringTodayEvent, TvAiringTodayState> {
  final Repository repository;

  TvAiringTodayBloc({required this.repository})
    : super(InitialTvAiringToday()) {
    on<LoadTvAiringToday>((event, emit) async {
      await _loadTvAiringToday(emit);
    });
  }

  Future<void> _loadTvAiringToday(Emitter<TvAiringTodayState> emit) async {
    try {
      emit(TvAiringTodayLoading());
      var movies = await repository.getTvAiringToday(
        ApiConstant.apiKey,
        ApiConstant.language,
      );
      if (movies.results.isEmpty) {
        emit(TvAiringTodayNoData(AppConstant.noData));
      } else {
        emit(TvAiringTodayHasData(movies));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(TvAiringTodayNoInternetConnection());
      } else if (e.type == DioExceptionType.unknown) {
        emit(TvAiringTodayNoInternetConnection());
      } else {
        emit(TvAiringTodayError(e.toString()));
      }
    }
  }
}
