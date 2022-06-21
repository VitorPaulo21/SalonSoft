import 'package:flutter/material.dart';

class TitledIcon extends StatelessWidget {
  const TitledIcon({
    Key? key,
     this.invert = false,
    required this.title,
    this.textStyle,
    required this.icon,
    this.centered = false
  }) : super(key: key);

  final bool invert;
  final String title;
  final TextStyle? textStyle;
  final Widget icon;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.end,
        children: invert
            ? [
                Text(
                  title,
                  style: textStyle,
                ),
                const SizedBox(
                  width: 8,
                ),
                icon,
              ]
            : [
                icon,
                const SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: textStyle,
                )
              ],
      ),
    );
  }
}
