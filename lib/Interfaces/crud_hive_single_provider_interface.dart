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
    } else {
      await Hive.box<T>(_boxName).add(objectPrivate);
    }
  }

  void saveData(T object) {
    objectPrivate = object;
    notifyListeners();
    if (objectPrivate.isInBox) {
      
    object.save();
    } else {
      Hive.box<T>(_boxName).add(objectPrivate);
    }
  }
}
