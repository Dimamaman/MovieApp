import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPrefHelper prefHelper;

  ThemeBloc({required this.prefHelper})
      : super(const ThemeState(isDarkTheme: false)) {
    on<ThemeChanged>((event, emit) async {
      await prefHelper.saveValueDarkTheme(event.isDarkTheme);
      emit(ThemeState(isDarkTheme: event.isDarkTheme));
    });
    on<GetTheme>((event, emit) async {
      var isDarkTheme = await prefHelper.getValueDarkTheme();
      emit(ThemeState(isDarkTheme: isDarkTheme));
    });
  }
}

