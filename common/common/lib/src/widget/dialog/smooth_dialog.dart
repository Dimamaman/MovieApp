import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:common/common.dart';

enum SmoothMode { Lottie, Network, Asset }

class ButtonConfig {
  final String dialogDone, dialogCancel;
  late Color buttonCancelColor,
      buttonDoneColor,
      labelCancelColor,
      labelDoneColor;

  ButtonConfig({
    this.dialogDone = 'Done',
    this.dialogCancel = 'Cancel',
    Color? buttonCancelColor,
    Color? buttonDoneColor,
    Color? labelCancelColor,
    Color? labelDoneColor,
  }) {
    this.buttonCancelColor = buttonCancelColor ?? ColorPalettes.white;
    this.buttonDoneColor = buttonDoneColor ?? ColorPalettes.darkAccent;
    this.labelCancelColor = labelCancelColor ?? ColorPalettes.black;
    this.labelDoneColor = labelDoneColor ?? ColorPalettes.white;
  }
}

class SmoothDialog {
  final String path;
  final String title;
  final String content;
  final double dialogHeight;
  final double imageHeight;
  final double imageWidth;
  final VoidCallback? submit;
  final BuildContext context;

  late ButtonConfig buttonConfig;
  SmoothMode mode = SmoothMode.Lottie;

  SmoothDialog({
    required this.context,
    required this.path,
    required this.title,
    required this.content,
    required this.submit,
    required this.mode,
    ButtonConfig? buttonConfig,
    this.imageHeight = 150,
    this.imageWidth = 150,
    this.dialogHeight = 310,
  }) {
    this.buttonConfig = buttonConfig ?? ButtonConfig();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(Sizes.dp16(context)),
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              content: SizedBox(
                width: double.maxFinite,
                height: dialogHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: Sizes.dp16(context)),
                    if (mode == SmoothMode.Lottie) ...[
                      Center(
                        child: Lottie.asset(
                          path,
                          width: imageWidth,
                          height: imageHeight,
                        ),
                      ),
                    ] else if (mode == SmoothMode.Asset) ...[
                      Center(
                        child: Image.asset(
                          path,
                          width: imageWidth,
                          height: imageHeight,
                        ),
                      ),
                    ] else ...[
                      Center(
                        child: CachedNetworkImage(
                          imageUrl: path,
                          width: imageWidth,
                          height: imageHeight,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                  ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ],
                    SizedBox(height: Sizes.dp8(context)),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: Sizes.dp20(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: Sizes.dp8(context)),
                    Text(
                      content,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Sizes.dp13(context)),
                    ),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: Sizes.dp10(context)),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigation.back(context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: Sizes.dp12(context),
                                          horizontal: Sizes.dp22(context),
                                        ),
                                        decoration: BoxDecoration(
                                          color: this
                                              .buttonConfig
                                              .buttonCancelColor,
                                          borderRadius: BorderRadius.circular(
                                            Sizes.dp16(context),
                                          ),
                                        ),
                                        child: Text(
                                          this.buttonConfig.dialogCancel,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: Sizes.dp13(context),
                                            fontWeight: FontWeight.bold,
                                            color: this
                                                .buttonConfig
                                                .labelCancelColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: Sizes.dp4(context)),
                                    InkWell(
                                      onTap: () {
                                        Navigation.back(context);
                                        submit?.call();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: Sizes.dp12(context),
                                          horizontal: Sizes.dp26(context),
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              this.buttonConfig.buttonDoneColor,
                                          borderRadius: BorderRadius.circular(
                                            Sizes.dp16(context),
                                          ),
                                        ),
                                        child: Text(
                                          this.buttonConfig.dialogDone,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: Sizes.dp13(context),
                                            fontWeight: FontWeight.bold,
                                            color: this
                                                .buttonConfig
                                                .labelDoneColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
