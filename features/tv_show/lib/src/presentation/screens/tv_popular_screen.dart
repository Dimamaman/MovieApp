import 'dart:async';

import 'package:feature_movie/feature_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared/common.dart';

import '../../../feature_tv_show.dart';

class TvPopularScreen extends StatefulWidget {
  static const routeName = '/tv_popular';

  @override
  _TvPopularScreenState createState() => _TvPopularScreenState();
}

class _TvPopularScreenState extends State<TvPopularScreen> {
  late Completer<void> _refreshCompleter;

  _loadTvPopular(BuildContext context) {
    context.read<TvPopularBloc>().add(LoadTvPopular());
  }

  Future<void> _refresh() {
    _loadTvPopular(context);
    return _refreshCompleter.future;
  }

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _loadTvPopular(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular'), centerTitle: true),
      body: LiquidPullToRefresh(
        onRefresh: _refresh,
        showChildOpacityTransition: false,
        child: BlocBuilder<TvPopularBloc, TvPopularState>(
          builder: (context, state) {
            if (state is TvPopularHasData) {
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
            } else if (state is TvPopularLoading) {
              return ShimmerList();
            } else if (state is TvPopularError) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return CustomErrorWidget(message: state.errorMessage);
            } else if (state is TvPopularNoData) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return CustomErrorWidget(message: state.message);
            } else if (state is TvPopularNoInternetConnection) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return NoInternetWidget(
                message: AppConstant.noInternetConnection,
                onPressed: () => _loadTvPopular(context),
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
