import 'package:salon_soft/Interfaces/crud_hive_provider_interface.dart';

import '../models/appointment.dart';

class AppointmentProvider extends CrudHiveProviderInterface<Appointment> {
  AppointmentProvider() : super(boxName: "appointments");
}
