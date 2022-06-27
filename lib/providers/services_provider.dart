import 'package:salon_soft/Interfaces/crud_hive_provider_interface.dart';
import 'package:salon_soft/models/service.dart';
import 'package:meta/meta.dart';

class ServicesProvider extends CrudHiveProviderInterface<Service> {
 

  ServicesProvider() : super(boxName: "services");

 
}
