import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'tv_on_the_air_event.dart';
import 'tv_on_the_air_state.dart';

class TvOnTheAirBloc extends Bloc<TvOnTheAirEvent, TvOnTheAirState> {
  final Repository repository;

  TvOnTheAirBloc({required this.repository}) : super(InitialTvOnTheAir()) {
    on<LoadTvOnTheAir>((event, emit) async {
      await _loadTvOnTheAir(emit);
    });
  }

  Future<void> _loadTvOnTheAir(Emitter<TvOnTheAirState> emit) async {
    try {
      emit(TvOnTheAirLoading());
      var movies = await repository.getTvOnTheAir(
          ApiConstant.apiKey, ApiConstant.language);
      if (movies.results.isEmpty) {
        emit(TvOnTheAirNoData(AppConstant.noData));
      } else {
        emit(TvOnTheAirHasData(movies));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(TvOnTheAirNoInternetConnection());
      } else if (e.type == DioExceptionType.unknown) {
        emit(TvOnTheAirNoInternetConnection());
      } else {
        emit(TvOnTheAirError(e.toString()));
      }
    }
  }
}
