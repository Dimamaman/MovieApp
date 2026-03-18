import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:common/common.dart';

class CardDiscover extends StatelessWidget {
  final String? image, title;
  final double? rating;
  final List<String>? genres;
  final VoidCallback? onTap;

  const CardDiscover({
    super.key,
    this.image,
    this.title,
    this.rating,
    this.genres,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var ratingValue = rating ?? 0.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.dp20(context)),
          child: GestureDetector(
            onTap: onTap,
            child: CachedNetworkImage(
              imageUrl: (image ?? '').imageOriginal,
              width: Sizes.width(context) / 2,
              placeholder: (context, url) => ShimmerDiscover(),
              errorWidget: (context, url, error) => ErrorImage(),
            ),
          ),
        ),
        SizedBox(height: Sizes.height(context) * .02),
        Text(
          title ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: Sizes.width(context) / 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Sizes.height(context) * .01),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: (genres ?? []).take(3).map(_buildGenreChip).toList(),
          ),
        ),
        SizedBox(height: Sizes.height(context) * .01),
        Text(
          ratingValue.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: Sizes.width(context) / 16,
          ),
        ),
        SizedBox(height: Sizes.height(context) * .005),
        buildRatingBar(theme, context, ratingValue),
      ],
    );
  }

  Widget _buildGenreChip(String label) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(8),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: ColorPalettes.white),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: ColorPalettes.grey),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
