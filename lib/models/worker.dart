import 'package:hive/hive.dart';
import 'package:salon_soft/models/appointments.dart';

part 'worker.g.dart';

@HiveType(typeId: 0)
class Worker extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String photoPath;
  @HiveField(2)
  bool? isActive;
  late List<Appointments> appointments = [];

  Worker({
    required this.name,
    this.photoPath = "",
    this.isActive = true,
  });

  List<Appointments> getAppointmensByDate(DateTime date) {
    return appointments
        .where((appointment) =>
            (appointment.initialDate.day == date.day &&
                appointment.initialDate.month == date.month &&
                appointment.initialDate.year == date.year) &&
            (isActive ?? false))
        .toList();
  }

  void syncToHive() {
    appointments.clear();
    appointments =
        Hive.box<Appointments>("appointments").values.where((appointment) {
      if (key != null) {
        return appointment.worker.first.key == key;
      } else {
        return false;
      }
    }).toList();
  }

  @override
  String toString() {
    return name;
  }
}
