import 'package:flutter/material.dart';
import 'package:common/common.dart';

Widget buildGenreChip(String label) {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.all(8),
    child: Text(label, style: TextStyle(fontSize: 12)),
    decoration: BoxDecoration(
      border: Border.all(color: ColorPalettes.grey),
      borderRadius: BorderRadius.circular(20),
    ),
  );
}
