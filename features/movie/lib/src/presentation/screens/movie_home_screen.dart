import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared/shared.dart';

import '../../../feature_movie.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late Completer<void> _refreshCompleter;
  int _current = 0;

  void _loadMovieNowPlaying(BuildContext context) {
    context.read<MovieNowPlayingBloc>().add(LoadMovieNowPlaying());
  }

  void _loadMoviePopular(BuildContext context) {
    context.read<MoviePopularBloc>().add(LoadMoviePopular());
  }

  void _loadMovieUpComing(BuildContext context) {
    context.read<MovieUpComingBloc>().add(LoadMovieUpComing());
  }

  Future<void> _refresh() {
    _loadMovieNowPlaying(context);
    _loadMoviePopular(context);
    _loadMovieUpComing(context);
    return _refreshCompleter.future;
  }

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _loadMovieNowPlaying(context);
    _loadMoviePopular(context);
    _loadMovieUpComing(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Movies'),
        centerTitle: true,
      ),
      body: LiquidPullToRefresh(
        onRefresh: _refresh,
        showChildOpacityTransition: false,
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        margin: EdgeInsets.all(Sizes.dp10(context)),
        child: Column(
          children: <Widget>[
            _buildBanner(context),
            SizedBox(height: Sizes.dp12(context)),
            _buildUpComing(context),
            SizedBox(height: Sizes.dp12(context)),
            _buildPopular(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return BlocBuilder<MovieNowPlayingBloc, MovieNowPlayingState>(
      builder: (context, state) {
        if (state is MovieNowPlayingHasData) {
          _refreshCompleter.complete();
          _refreshCompleter = Completer();
          return BannerHome(
            isFromMovie: true,
            onPageChanged: (index, reason) {
              setState(() => _current = index);
            },
            data: state.result,
            currentIndex: _current,
            routeNameDetail: MovieRoutes.detail,
            routeNameAll: MovieRoutes.nowPlaying,
          );
        } else if (state is MovieNowPlayingLoading) {
          return ShimmerBanner();
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
    );
  }

  Widget _buildUpComing(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Up Coming',
              style: TextStyle(
                fontSize: Sizes.dp14(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                size: Sizes.dp16(context),
              ),
              onPressed: () {
                Navigation.intent(context, MovieRoutes.upComing);
              },
            ),
          ],
        ),
        SizedBox(
          width: Sizes.width(context),
          height: Sizes.width(context) / 1.8,
          child: BlocBuilder<MovieUpComingBloc, MovieUpComingState>(
            builder: (context, state) {
              if (state is MovieUpComingHasData) {
                _refreshCompleter.complete();
                _refreshCompleter = Completer();
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.result.results.length > 5
                      ? 5
                      : state.result.results.length,
                  itemBuilder: (BuildContext context, int index) {
                    final dto = state.result.results[index];
                    final movie = dto.toUI(true);
                    return CardHome(
                      image: dto.posterPath,
                      title: movie.name,
                      rating: movie.rating,
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
                return ShimmerCard();
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
      ],
    );
  }

  Widget _buildPopular(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Popular',
              style: TextStyle(
                fontSize: Sizes.dp14(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                size: Sizes.dp16(context),
              ),
              onPressed: () {
                Navigation.intent(context, MovieRoutes.popular);
              },
            ),
          ],
        ),
        SizedBox(
          width: Sizes.width(context),
          height: Sizes.width(context) / 1.8,
          child: BlocBuilder<MoviePopularBloc, MoviePopularState>(
            builder: (context, state) {
              if (state is MoviePopularHasData) {
                _refreshCompleter.complete();
                _refreshCompleter = Completer();
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.result.results.length > 5
                      ? 5
                      : state.result.results.length,
                  itemBuilder: (BuildContext context, int index) {
                    final dto = state.result.results[index];
                    final movie = dto.toUI(true);
                    return CardHome(
                      image: dto.posterPath,
                      title: movie.name,
                      rating: movie.rating,
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
                return ShimmerCard();
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
      ],
    );
  }
}

