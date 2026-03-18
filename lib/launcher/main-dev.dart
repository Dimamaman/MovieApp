import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:moviecatalogue/di/injection_container.dart' as di;
import 'package:moviecatalogue/observer/movie_bloc_observer.dart';

import 'app_config.dart';
import 'movie_app.dart';

void main() async {
  Bloc.observer = MovieBlocObserver();
  Config.appFlavor = Flavor.DEVELOPMENT;
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(ApiConstant.baseUrlDebug);
  runApp(MyApp());
}
