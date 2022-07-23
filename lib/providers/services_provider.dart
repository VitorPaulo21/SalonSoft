import 'package:salon_soft/Interfaces/crud_hive_provider_interface.dart';
import 'package:salon_soft/models/service.dart';
import 'package:meta/meta.dart';

import 'appointment_provider.dart';

class ServicesProvider extends CrudHiveProviderInterface<Service> {
  AppointmentProvider? appointmentProvider;
 

  ServicesProvider(this.appointmentProvider) : super(boxName: "services");

  @override
  void removeObject(Service object) {
    if (appointmentProvider != null) {
      
      appointmentProvider?.removeServicesByService(object);
      super.removeObject(object);
    }
  }
}
