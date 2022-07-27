import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  @HiveField(5)
  List<int> _stateColors = [];
  @HiveField(6)
  bool worWithFinances;
  @HiveField(7)
  int primaryColor = Colors.pink[600]!.value;
  @HiveField(8)
  int onPrimary = Colors.white.value;

  Settings({
    required this.closeHour,
    required this.closeMinute,
    required this.openHour,
    required this.openMinute,
    required this.intervalOfMinutes,
      List<int> stateColorsList = const [],
    this.worWithFinances = false,
  }) {
    if (stateColorsList.isEmpty) {
      stateColorsList = [
        Colors.amber.value,
        Colors.purple.value,
        Colors.green.value,
        Colors.red.value,
        Colors.indigo.value,
      ];
      _stateColors = stateColorsList;
     
    } else {
      _stateColors = stateColorsList;
    }
  }

  List<Color> getStateColors() {
    return _stateColors
        .map<Color>((value) => Color(value).withAlpha(110))
        .toList();
  }
}
