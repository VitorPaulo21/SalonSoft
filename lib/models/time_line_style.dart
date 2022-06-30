import 'package:flutter/material.dart';

class TimeLineStyle {
  final Color backgroundColor;
  final Color borderColor;
  final TextStyle textStyle;

  const TimeLineStyle({
    this.backgroundColor = Colors.white,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 13,
    ),
    this.borderColor = Colors.grey,
  });
}
