import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:common/common.dart';

import '../../../feature_movie.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late Completer<void> _refreshCompleter;

  void _loadMovieNowPlaying(BuildContext context) {
    context.read<MovieNowPlayingBloc>().add(LoadMovieNowPlaying());
  }

  Future<void> _refresh() {
    _loadMovieNowPlaying(context);
    return _refreshCompleter.future;
  }

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _loadMovieNowPlaying(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing Movies'),
        centerTitle: true,
      ),
      body: LiquidPullToRefresh(
        onRefresh: _refresh,
        showChildOpacityTransition: false,
        child: BlocBuilder<MovieNowPlayingBloc, MovieNowPlayingState>(
          builder: (context, state) {
            if (state is MovieNowPlayingHasData) {
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
            } else if (state is MovieNowPlayingLoading) {
              return ShimmerList();
            } else if (state is MovieNowPlayingError) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return CustomErrorWidget(message: state.errorMessage);
            } else if (state is MovieNowPlayingNoData) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return CustomErrorWidget(message: state.message);
            } else if (state is MovieNowPlayingNoInternetConnection) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return NoInternetWidget(
                message: AppConstant.noInternetConnection,
                onPressed: () => _loadMovieNowPlaying(context),
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
