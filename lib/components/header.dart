import 'dart:io';

import 'package:flutter/material.dart';
import '../models/header.dart';

class HeaderComponent extends StatelessWidget {
  final Header header;

  final double width;
  final double height;
  final Color borderColor;
  final Color backgroundColor;

  const HeaderComponent({
    Key? key,
    required this.header,
    required this.height,
    required this.width,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFF353433),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      width: width,
      height: height,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        elevation: 5,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: header.photoPath.isEmpty
                ? Colors.grey[300]
                : Colors.transparent,
            foregroundImage: header.photoPath.isNotEmpty
                ? FileImage(File(header.photoPath))
                : null,
            child: header.photoPath == null
                ? const Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.grey,
                    size: 30,
                  )
                : null,
          ),
          title: Text(header.title),
        ),
      ),
    );
  }
}
