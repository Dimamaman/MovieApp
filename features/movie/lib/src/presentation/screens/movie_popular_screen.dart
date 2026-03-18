import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:common/common.dart';

import '../../../feature_movie.dart';

class MoviePopularScreen extends StatefulWidget {
  const MoviePopularScreen({super.key});

  @override
  State<MoviePopularScreen> createState() => _MoviePopularScreenState();
}

class _MoviePopularScreenState extends State<MoviePopularScreen> {
  late Completer<void> _refreshCompleter;

  void _loadMoviePopular(BuildContext context) {
    context.read<MoviePopularBloc>().add(LoadMoviePopular());
  }

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _loadMoviePopular(context);
  }

  Future<void> _refresh() {
    _loadMoviePopular(context);
    return _refreshCompleter.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies'), centerTitle: true),
      body: LiquidPullToRefresh(
        onRefresh: _refresh,
        showChildOpacityTransition: false,
        child: BlocBuilder<MoviePopularBloc, MoviePopularState>(
          builder: (context, state) {
            if (state is MoviePopularHasData) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return ListView.builder(
                itemCount: state.result.results.length,
                itemBuilder: (BuildContext context, int index) {
                  final dto = state.result.results[index];
                  final movie = dto.toEntity(true);
                  return CardMovies(
                    image: dto.posterPath,
                    title: movie.name,
                    vote: movie.ratingText,
                    releaseDate: movie.releaseDate,
                    overview: movie.overview,
                    genre: movie.genres.take(3).map(buildGenreChip).toList(),
                    onTap: () {
                      Navigation.intentWithData(
                        context,
                        MovieRoutes.detail,
                        ScreenArguments(movie, true, false),
                      );
                    },
                  );
                },
              );
            } else if (state is MoviePopularLoading) {
              return ShimmerList();
            } else if (state is MoviePopularError) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return CustomErrorWidget(message: state.errorMessage);
            } else if (state is MoviePopularNoData) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return CustomErrorWidget(message: state.message);
            } else if (state is MoviePopularNoInternetConnection) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return NoInternetWidget(
                message: AppConstant.noInternetConnection,
                onPressed: () => _loadMoviePopular(context),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
