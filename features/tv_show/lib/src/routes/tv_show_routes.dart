import 'package:flutter/material.dart';

import '../presentation/screens/airing_today_screen.dart';
import '../presentation/screens/on_the_air_screen.dart';
import '../presentation/screens/tv_popular_screen.dart';

class TvShowRoutes {
  static const airingToday = '/airing_today';
  static const onTheAir = '/on_the_air';
  static const popular = '/tv_popular';

  static Map<String, WidgetBuilder> builders = {
    airingToday: (_) => AiringTodayScreen(),
    onTheAir: (_) => OnTheAirScreen(),
    popular: (_) => TvPopularScreen(),
  };
}
