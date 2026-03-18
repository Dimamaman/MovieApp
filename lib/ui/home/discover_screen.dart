import 'package:cached_network_image/cached_network_image.dart';
import 'package:common/common.dart';
import 'package:feature_movie/feature_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverScreen extends StatefulWidget {
  static const routeName = '/discover_movie';

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  _loadDiscoverMovie(BuildContext context) {
    context.read<DiscoverMovieBloc>().add(LoadDiscoverMovie());
  }

  @override
  void initState() {
    super.initState();
    _loadDiscoverMovie(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalettes.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back, color: ColorPalettes.white),
      ),
      body: BlocBuilder<DiscoverMovieBloc, DiscoverMovieState>(
        builder: (context, state) {
          if (state is DiscoverMovieHasData) {
            return PageView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: state.result.results.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final dto = state.result.results[index];
                final movie = dto.toUI(true);
                var position = index + 1;
                return Container(
                  width: Sizes.width(context),
                  height: Sizes.height(context),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: movie.backdropUrl,
                        width: Sizes.width(context),
                        height: Sizes.height(context),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => LoadingIndicator(),
                        errorWidget: (context, url, error) => ErrorImage(),
                      ),
                      Container(
                        color: ColorPalettes.grey.withValues(alpha: 0.6),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorPalettes.black.withValues(alpha: 0.9),
                              ColorPalettes.black.withValues(alpha: 0.3),
                              ColorPalettes.black.withValues(alpha: 0.95),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1, 0.5, 0.9],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CardDiscover(
                          image: dto.posterPath,
                          title: movie.name,
                          rating: movie.rating,
                          genre: movie.genreIds,
                          onTap: () {
                            Navigation.intentWithData(
                              context,
                              MovieRoutes.detail,
                              ScreenArguments(movie, true, false),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: Sizes.width(context) / 7,
                            right: Sizes.dp30(context),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Text(
                                '$position',
                                style: TextStyle(
                                  color: ColorPalettes.white,
                                  fontSize: Sizes.dp25(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "/${state.result.results.length}",
                                style: TextStyle(
                                  color: ColorPalettes.white,
                                  fontSize: Sizes.dp16(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is DiscoverMovieLoading) {
            return LoadingIndicator();
          } else if (state is DiscoverMovieError) {
            return CustomErrorWidget(message: state.errorMessage);
          } else if (state is DiscoverMovieNoData) {
            return CustomErrorWidget(message: state.message);
          } else if (state is DiscoverMovieNoInternetConnection) {
            return NoInternetWidget(
              message: AppConstant.noInternetConnection,
              onPressed: () => _loadDiscoverMovie(context),
            );
          } else {
            return Center(child: Text(""));
          }
        },
      ),
    );
  }
}
