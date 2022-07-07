import 'package:flutter/cupertino.dart';
import 'package:salon_soft/Interfaces/crud_hive_single_provider_interface.dart';
import 'package:salon_soft/models/settings.dart';

class SettingsProvider extends CrudHiveSingleProviderInterface<Settings> {
  SettingsProvider()
      : super(
            boxName: "settings",
            initialObjectValue: Settings(
                closeHour: 23, closeMinute: 59, openHour: 0, openMinute: 0));
}
