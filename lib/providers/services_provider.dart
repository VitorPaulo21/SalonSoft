import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:salon_soft/models/service.dart';

class ServicesProvider with ChangeNotifier {
  List<Service> _services = [];

  ServicesProvider() {
    syncToHive();
  }

  List<Service> get services => [..._services];
  void syncToHive() async {
    _services.addAll(Hive.box<Service>("services").values);
  }

  void addservice(Service service) {
    _services.add(service);
    notifyListeners();
    Hive.box<Service>("services").add(service);
  }

  void removeAllservices() {
    _services.clear();
    notifyListeners();
    Hive.box<Service>("services").clear();
  }

  void saveData(Service service) {
    notifyListeners();
    service.save();
  }

  void removeService(Service service) {
    _services.remove(service);
    notifyListeners();
    service.delete();
  }
}
