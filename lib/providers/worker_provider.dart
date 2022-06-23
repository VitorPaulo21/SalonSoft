import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:salon_soft/models/worker.dart';

class WorkerProvider extends ChangeNotifier {
  List<Worker> _workers = [];

  WorkerProvider() {
    syncToHive();
  }

  List<Worker> get workers => [..._workers];
  void syncToHive() async {
    _workers.addAll(Hive.box<Worker>("workers").values);
  }

  void addWorker(Worker worker) {
    _workers.add(worker);
    notifyListeners();
    Hive.box<Worker>("workers").add(worker);
  }

  void removeAllWorkers() {
    _workers.forEach((worker) {
      if (worker.photoPath.isNotEmpty) {
        File(worker.photoPath).delete();
      }
    });
    _workers.clear();
    Hive.box<Worker>("workers").clear();
    notifyListeners();
  }
}
