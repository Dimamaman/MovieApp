import 'package:flutter/material.dart';
import 'package:shared/common.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? message;

  const CustomErrorWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message ?? '',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: Sizes.dp12(context),
        ),
      ),
    );
  }
}
