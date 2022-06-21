import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:salon_soft/components/titled_icon.dart';

class TitledIconButton extends StatelessWidget {
  void Function() onTap;
  Icon icon;
  String title;
  TextStyle? textStyle;
  bool invert;
  TitledIconButton(
      {Key? key,
      required this.onTap,
      required this.icon,
      required this.title,
      this.textStyle,
      this.invert = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        child: TitledIcon(invert: invert, title: title, textStyle: textStyle, icon: icon),
      ),
    );
  }
}

