import 'dart:async';

import 'package:feature_movie/feature_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared/common.dart';

import '../../../feature_tv_show.dart';

class OnTheAirScreen extends StatefulWidget {
  static const routeName = '/on_the_air';

  @override
  _OnTheAirScreenState createState() => _OnTheAirScreenState();
}

class _OnTheAirScreenState extends State<OnTheAirScreen> {
  late Completer<void> _refreshCompleter;

  _loadTvOnAir(BuildContext context) {
    context.read<TvOnTheAirBloc>().add(LoadTvOnTheAir());
  }

  Future<void> _refresh() {
    _loadTvOnAir(context);
    return _refreshCompleter.future;
  }

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _loadTvOnAir(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('On The Air'), centerTitle: true),
      body: LiquidPullToRefresh(
        onRefresh: _refresh,
        showChildOpacityTransition: false,
        child: BlocBuilder<TvOnTheAirBloc, TvOnTheAirState>(
          builder: (context, state) {
            if (state is TvOnTheAirHasData) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return ListView.builder(
                itemCount: state.result.results.length,
                itemBuilder: (BuildContext context, int index) {
                  final dto = state.result.results[index];
                  final movie = dto.toUI(false);
                  return CardMovies(
                    image: dto.posterPath,
                    title: movie.name,
                    vote: movie.ratingText,
                    releaseDate: movie.releaseDate,
                    overview: movie.overview,
                    genre: movie.genreIds.take(3).map(buildGenreChip).toList(),
                    onTap: () {
                      Navigation.intentWithData(
                        context,
                        MovieRoutes.detail,
                        ScreenArguments(movie, false, false),
                      );
                    },
                  );
                },
              );
            } else if (state is TvOnTheAirLoading) {
              return ShimmerList();
            } else if (state is TvOnTheAirError) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return CustomErrorWidget(message: state.errorMessage);
            } else if (state is TvOnTheAirNoData) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return CustomErrorWidget(message: state.message);
            } else if (state is TvOnTheAirNoInternetConnection) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return NoInternetWidget(
                message: AppConstant.noInternetConnection,
                onPressed: () => _loadTvOnAir(context),
              );
            } else {
              return Center(child: Text(""));
            }
          },
        ),
      ),
    );
  }
}
