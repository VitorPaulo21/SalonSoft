import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:salon_soft/Interfaces/crud_hive_provider_interface.dart';
import 'package:salon_soft/models/worker.dart';

import 'appointment_provider.dart';

class WorkerProvider extends CrudHiveProviderInterface<Worker> {
  AppointmentProvider? appointmentProvider;

  WorkerProvider(this.appointmentProvider) : super(boxName: "workers");

  @override
  void syncToHive() async {
    objectsPrivate.addAll(Hive.box<Worker>("workers").values);
    objectsPrivate.forEach((element) {
      element.syncToHive();
    });
  }
  @override
  void removeObject(Worker worker) {
    if (appointmentProvider != null) {
      
      appointmentProvider?.removeServicesByWorker(worker);
    objectsPrivate.remove(worker);
    notifyListeners();
    worker.delete();
    }
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
