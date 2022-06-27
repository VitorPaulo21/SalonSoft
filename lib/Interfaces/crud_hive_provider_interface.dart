import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CrudHiveProviderInterface<T extends HiveObject> with ChangeNotifier {
  List<T> objectsPrivate = [];
  String _boxName;
  CrudHiveProviderInterface({required String boxName}) : _boxName = boxName {
    syncToHive();
  }

  List<T> get objects => [...objectsPrivate];

  void syncToHive() async {
    objectsPrivate.addAll(Hive.box<T>(_boxName).values);
  }

  void addObject(T object) {
    objectsPrivate.add(object);
    notifyListeners();
    Hive.box<T>(_boxName).add(object);
  }

  void removeAllObjects() {
    objectsPrivate.clear();
    notifyListeners();
    Hive.box<T>(_boxName).clear();
  }

  void saveData(T object) {
    notifyListeners();
    object.save();
  }

  void removeObject(T object) {
    objectsPrivate.remove(object);
    notifyListeners();
    object.delete();
  }
}
