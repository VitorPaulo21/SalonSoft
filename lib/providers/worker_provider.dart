import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:salon_soft/Interfaces/crud_hive_provider_interface.dart';
import 'package:salon_soft/models/worker.dart';

class WorkerProvider extends CrudHiveProviderInterface<Worker> {


  WorkerProvider() : super(boxName: "workers");

  @override
  void syncToHive() async {
    objectsPrivate.addAll(Hive.box<Worker>("workers").values);
    objectsPrivate.forEach((element) {
      element.syncToHive();
    });
  }

  @override
  void removeAllObjects() {
    objectsPrivate.forEach((worker) {
      if (worker.photoPath.isNotEmpty) {
        File(worker.photoPath).delete();
      }
    });
    objectsPrivate.clear();
    Hive.box<Worker>("workers").clear();
    notifyListeners();
  }

}
