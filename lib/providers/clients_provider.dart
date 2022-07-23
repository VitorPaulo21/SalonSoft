import 'package:salon_soft/Interfaces/crud_hive_provider_interface.dart';
import 'package:salon_soft/models/client.dart';
import 'package:salon_soft/providers/appointment_provider.dart';
import 'package:salon_soft/providers/worker_provider.dart';

class ClientsProvider extends CrudHiveProviderInterface<Client> {
  AppointmentProvider? appointmentProvider;
  ClientsProvider(this.appointmentProvider) : super(boxName: "clients");
  @override
  void removeObject(Client object) async {
    if (appointmentProvider != null) {
      appointmentProvider?.removeServicesByClient(object);
      super.removeObject(object);
    }
  }
}
