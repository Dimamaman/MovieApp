import 'package:flutter/material.dart';
import 'package:shared/common.dart';

class RatingInformation extends StatelessWidget {
  final double? rating;

  const RatingInformation({super.key, this.rating});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var ratingValue = rating ?? 0.0;
    var numericRating = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ratingValue.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.secondary,
            fontSize: Sizes.dp16(context),
          ),
        ),
        SizedBox(height: Sizes.dp4(context)),
        Text('Ratings'),
      ],
    );

    var starRating = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildRatingBar(theme, context, ratingValue),
        Padding(
          padding: EdgeInsets.only(
            top: Sizes.dp4(context),
            left: Sizes.dp4(context),
          ),
          child: Text('Grade now'),
        ),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        numericRating,
        SizedBox(width: Sizes.dp16(context)),
        starRating,
      ],
    );
  }
}

Widget buildRatingBar(ThemeData theme, BuildContext context, double rating) {
  var stars = <Widget>[];
  for (var i = 1; i <= 5; i++) {
    var color = i <= rating / 2
        ? theme.colorScheme.secondary
        : ColorPalettes.grey;
    var star = Icon(Icons.star, color: color, size: Sizes.dp18(context));
    stars.add(star);
  }
  return Row(mainAxisSize: MainAxisSize.min, children: stars);
}
