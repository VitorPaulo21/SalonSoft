import 'package:salon_soft/Interfaces/crud_hive_provider_interface.dart';
import 'package:salon_soft/models/client.dart';

class ClientsProvider extends CrudHiveProviderInterface<Client> {
  ClientsProvider() : super(boxName: "clients");
}
