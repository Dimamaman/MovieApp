import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import '../presentation/screens/movie_home_screen.dart';
import '../presentation/screens/now_playing_screen.dart';
import '../presentation/screens/movie_popular_screen.dart';
import '../presentation/screens/up_coming_screen.dart';
import '../presentation/screens/detail_screen.dart';
import '../presentation/screens/booking_screen.dart';

class MovieRoutes {
  static const movieHome = '/movies';
  static const nowPlaying = '/now_playing';
  static const popular = '/movie_popular';
  static const upComing = '/up_coming';
  static const detail = '/detail_movies';
  static const booking = '/booking';

  /// Simple named routes (no arguments)
  static Map<String, WidgetBuilder> builders = {
    movieHome: (_) => const MovieScreen(),
    nowPlaying: (_) => const NowPlayingScreen(),
    popular: (_) => const MoviePopularScreen(),
    upComing: (_) => const UpComingScreen(),
  };

  /// Routes that require [ScreenArguments] (detail, booking, ...)
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == detail) {
      final args = settings.arguments as ScreenArguments;
      return MaterialPageRoute(
        builder: (_) => DetailScreen(arguments: args),
      );
    }

    if (settings.name == booking) {
      final args = settings.arguments as ScreenArguments;
      return MaterialPageRoute(
        builder: (_) => BookingScreen(arguments: args),
      );
    }

    return null;
  }
}

