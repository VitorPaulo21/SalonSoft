import 'package:hive/hive.dart';
import 'package:salon_soft/models/client.dart';
import 'package:salon_soft/models/service.dart';
import 'package:salon_soft/models/worker.dart';

part 'appointment.g.dart';

@HiveType(typeId: 3)
class Appointment extends HiveObject {
  @HiveField(0)
  DateTime date;
  @HiveField(1)
  HiveList<Worker> worker;
  @HiveField(2)
  HiveList<Client> client;
  @HiveField(3)
  HiveList<Service> service;

  Appointment({
    required this.date,
    required this.worker,
    required this.client,
    required this.service,
  });
}
