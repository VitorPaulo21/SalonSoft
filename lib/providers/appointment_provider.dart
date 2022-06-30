import 'package:hive_flutter/hive_flutter.dart';
import 'package:salon_soft/Interfaces/crud_hive_provider_interface.dart';

import '../models/appointments.dart';
import '../models/worker.dart';

class AppointmentProvider extends CrudHiveProviderInterface<Appointments> {
  AppointmentProvider() : super(boxName: "appointments");

  @override
  void addObject(Appointments appointment) {
    Worker worker = appointment.worker.first;
    worker.appointments.add(appointment);
    if (worker.isInBox) {
      worker.save();
    }
    objectsPrivate.add(appointment);
    notifyListeners();
    Hive.box<Appointments>("appointments").add(appointment);
  }

  @override
  void removeAllObjects() async {
    objectsPrivate.forEach((appointment) {
      appointment.delete();
      appointment.worker.first.syncToHive();
    });
    objectsPrivate.clear();
    notifyListeners();
  }

  @override
  void saveData(Appointments object) async {
    await object.save();
    object.worker.first.syncToHive();
    notifyListeners();
  }

  @override
  void removeObject(Appointments object) async {
    await object.delete();
    objectsPrivate.remove(object..worker.first.syncToHive());
    notifyListeners();
  }
}
