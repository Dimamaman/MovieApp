import 'package:common/common.dart';
import 'package:feature_detail/feature_detail.dart';
import 'package:feature_movie/feature_movie.dart';
import 'package:feature_setting/feature_setting.dart';
import 'package:feature_tv_show/feature_tv_show.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviecatalogue/di/injection_container.dart';
import 'package:moviecatalogue/ui/about/about_screen.dart';
import 'package:moviecatalogue/ui/dashboard/dashboard_screen.dart';
import 'package:moviecatalogue/ui/home/discover_screen.dart';
import 'package:moviecatalogue/ui/setting/setting_screen.dart';
import 'package:moviecatalogue/ui/splash/splash_screen.dart';

import 'app_config.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => inject<DiscoverMovieBloc>()),
        BlocProvider(create: (context) => inject<MovieNowPlayingBloc>()),
        BlocProvider(create: (context) => inject<MoviePopularBloc>()),
        BlocProvider(create: (context) => inject<MovieUpComingBloc>()),
        BlocProvider(create: (context) => inject<TvAiringTodayBloc>()),
        BlocProvider(create: (context) => inject<TvOnTheAirBloc>()),
        BlocProvider(create: (context) => inject<TvPopularBloc>()),
        BlocProvider<TrailerBloc>(create: (context) => inject<TrailerBloc>()),
        BlocProvider<CrewBloc>(create: (context) => inject<CrewBloc>()),
        BlocProvider<ThemeBloc>(create: (context) => inject<ThemeBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(builder: _buildWithTheme),
    );
  }

  Widget _buildWithTheme(BuildContext context, ThemeState state) {
    context.select((ThemeBloc themeBloc) => themeBloc.add(GetTheme()));
    return MaterialApp(
      title: Config.title,
      debugShowCheckedModeBanner: Config.isDebug,
      theme: state.isDarkTheme ? Themes.darkTheme : Themes.lightTheme,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        DashBoardScreen.routeName: (context) =>
            DashBoardScreen(title: Config.title),
        DiscoverScreen.routeName: (context) => DiscoverScreen(),
        SettingScreen.routeName: (context) => SettingScreen(),
        AboutScreen.routeName: (context) => AboutScreen(),
        ...MovieRoutes.builders,
        ...TvShowRoutes.builders,
      },
      onGenerateRoute: MovieRoutes.onGenerateRoute,
    );
  }
}
