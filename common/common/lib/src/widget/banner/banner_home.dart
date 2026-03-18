import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:common/common.dart';

class BannerHome extends StatelessWidget {
  final Function(int index, CarouselPageChangedReason reason) onPageChanged;
  final List<Movie> items;
  final int currentIndex;
  final String routeNameDetail, routeNameAll;
  final bool isFromMovie;

  const BannerHome({
    Key? key,
    required this.onPageChanged,
    required this.items,
    required this.currentIndex,
    required this.routeNameDetail,
    required this.routeNameAll,
    required this.isFromMovie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final result = items.length > 10 ? 10 : items.length;
    return Column(
      children: <Widget>[
        // Banner
        Container(
          height: Sizes.width(context) / 2,
          child: CarouselSlider(
            options: CarouselOptions(
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              viewportFraction: 1.0,
              aspectRatio: 2.0,
              onPageChanged: onPageChanged,
            ),
            items: <Widget>[
              for (var i = 0; i < result; i++)
                Builder(
                  builder: (context) {
                    final movie = items[i];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(Sizes.dp10(context)),
                      child: GestureDetector(
                        onTap: () {
                          Navigation.intentWithData(
                            context,
                            routeNameDetail,
                            ScreenArguments(movie, isFromMovie, true),
                          );
                        },
                        child: GridTile(
                          child: CachedNetworkImage(
                            imageUrl: movie.backdropUrl,
                            width: Sizes.width(context),
                            fit: BoxFit.fill,
                            placeholder: (context, url) => LoadingIndicator(),
                            errorWidget: (context, url, error) => ErrorImage(),
                          ),
                          footer: Container(
                            color: ColorPalettes.whiteSemiTransparent,
                            padding: EdgeInsets.all(Sizes.dp5(context)),
                            child: Text(
                              movie.name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ColorPalettes.darkBG,
                                fontWeight: FontWeight.bold,
                                fontSize: Sizes.dp16(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        _dotIndicator(result, context),
      ],
    );
  }

  Widget _dotIndicator(int data, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (var i = 0; i < data; i++)
          Container(
            width: Sizes.dp8(context),
            height: Sizes.dp8(context),
            margin: EdgeInsets.symmetric(
              vertical: Sizes.dp10(context),
              horizontal: 2.0,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == i
                  ? ColorPalettes.darkAccent
                  : ColorPalettes.grey,
            ),
          ),
        Spacer(),
        GestureDetector(
          onTap: () {
            Navigation.intent(context, routeNameAll);
          },
          child: Text(
            'See all',
            style: TextStyle(
              fontSize: Sizes.dp15(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
