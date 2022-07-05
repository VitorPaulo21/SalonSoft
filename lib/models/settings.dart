import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class settings extends HiveObject {
  int openHour;
  int openMinute;
  int closeHour;
  int closeMinute;

  settings({
    required this.closeHour,
    required this.closeMinute,
    required this.openHour,
    required this.openMinute,
  });
}
