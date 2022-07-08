import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'settings.g.dart';
@HiveType(typeId: 4)
class Settings extends HiveObject {
  @HiveField(0)
  int openHour;
  @HiveField(1)
  int openMinute;
  @HiveField(2)
  int closeHour;
  @HiveField(3)
  int closeMinute;
  @HiveField(4)
  int intervalOfMinutes;


  Settings({
    required this.closeHour,
    required this.closeMinute,
    required this.openHour,
    required this.openMinute,
    required this.intervalOfMinutes,
  });
}
