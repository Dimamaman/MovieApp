import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared/shared.dart';

import '../../../feature_movie.dart';

class UpComingScreen extends StatefulWidget {
  const UpComingScreen({super.key});

  @override
  State<UpComingScreen> createState() => _UpComingScreenState();
}

class _UpComingScreenState extends State<UpComingScreen> {
  late Completer<void> _refreshCompleter;

  void _loadMovieUpComing(BuildContext context) {
    context.read<MovieUpComingBloc>().add(LoadMovieUpComing());
  }

  Future<void> _refresh() {
    _loadMovieUpComing(context);
    return _refreshCompleter.future;
  }

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _loadMovieUpComing(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Up Coming Movie'),
        centerTitle: true,
      ),
      body: LiquidPullToRefresh(
        onRefresh: _refresh,
        showChildOpacityTransition: false,
        child: BlocBuilder<MovieUpComingBloc, MovieUpComingState>(
          builder: (context, state) {
            if (state is MovieUpComingHasData) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return ListView.builder(
                itemCount: state.result.results.length,
                itemBuilder: (BuildContext context, int index) {
                  final dto = state.result.results[index];
                  final movie = dto.toUI(true);
                  return CardMovies(
                    image: dto.posterPath,
                    title: movie.name,
                    vote: movie.ratingText,
                    releaseDate: movie.releaseDate,
                    overview: movie.overview,
                    genre: movie.genreIds
                        .take(3)
                        .map(buildGenreChip)
                        .toList(),
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
            } else if (state is MovieUpComingLoading) {
              return ShimmerList();
            } else if (state is MovieUpComingError) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return CustomErrorWidget(message: state.errorMessage);
            } else if (state is MovieUpComingNoData) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return CustomErrorWidget(message: state.message);
            } else if (state is MovieUpComingNoInternetConnection) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
              return NoInternetWidget(
                message: AppConstant.noInternetConnection,
                onPressed: () => _loadMovieUpComing(context),
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

