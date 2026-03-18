import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:moviecatalogue/di/injection_container.dart' as di;
import 'package:moviecatalogue/observer/movie_bloc_observer.dart';

import 'app_config.dart';
import 'movie_app.dart';

void main() async {
  Bloc.observer = MovieBlocObserver();
  Config.appFlavor = Flavor.RELEASE;
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(ApiConstant.baseUrlProd);
  runApp(MyApp());
}
