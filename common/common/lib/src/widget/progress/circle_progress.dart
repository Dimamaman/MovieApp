import 'package:flutter/material.dart';
import 'package:common/common.dart';

class CircleProgress extends StatelessWidget {
  final String? vote;

  const CircleProgress({super.key, this.vote});

  @override
  Widget build(BuildContext context) {
    var voteValue = vote ?? '0';
    return SizedBox(
      width: Sizes.width(context) / 10,
      height: Sizes.width(context) / 10,
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: Sizes.width(context) / 10,
              height: Sizes.width(context) / 10,
              decoration: BoxDecoration(
                color: ColorPalettes.blueGrey,
                borderRadius: BorderRadius.circular(Sizes.dp20(context)),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: Sizes.dp30(context),
              height: Sizes.dp30(context),
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                  ColorPalettes.getColorCircleProgress(double.parse(voteValue)),
                ),
                backgroundColor: ColorPalettes.grey,
                value: double.parse(voteValue) / 10.0,
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: Sizes.dp30(context),
              height: Sizes.dp30(context),
              child: Center(
                child: Text(
                  '${(double.parse(voteValue) * 10.0).floor()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: Sizes.dp10(context),
                    color: ColorPalettes.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
