import 'package:flutter/material.dart';
import 'package:common/common.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key, required this.arguments});

  final ScreenArguments arguments;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDarkTheme = themeData.appBarTheme.backgroundColor == null;
    return Scaffold(
      backgroundColor: !isDarkTheme
          ? ColorPalettes.darkPrimary
          : ColorPalettes.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(arguments.movies.name),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(Sizes.dp20(context)),
          child: Column(
            children: <Widget>[
              DateWidget(),
              TimeWidget(),
              CinemaWidget(movieBackground: arguments.movies.backdropUrl),
              Padding(
                padding: EdgeInsets.only(top: Sizes.dp20(context)),
                child: CustomButton(
                  text: 'Pay',
                  onPressed: () {
                    SmoothDialog(
                      context: context,
                      path: ImagesAssets.successful,
                      mode: SmoothMode.Lottie,
                      content: 'Thanks for your movie ticket order',
                      title: 'Payment Successful!',
                      submit: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
