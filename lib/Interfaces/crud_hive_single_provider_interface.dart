import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CrudHiveSingleProviderInterface<T extends HiveObject>
    with ChangeNotifier {
  T objectPrivate;
  String _boxName;
  CrudHiveSingleProviderInterface(
      {required String boxName, required T initialObjectValue})
      : _boxName = boxName,
        objectPrivate = initialObjectValue {
    syncToHive();
  }

  T? get objects => objectPrivate;

  void syncToHive() async {
    if (Hive.box<T>(_boxName).length > 0) {
      objectPrivate = Hive.box<T>(_boxName).values.first;
    }
  }

  void saveData(T object) {
    notifyListeners();
    object.save();
  }
}
