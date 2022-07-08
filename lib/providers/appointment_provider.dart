import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:salon_soft/Interfaces/crud_hive_provider_interface.dart';
import 'package:salon_soft/models/appointment.dart';
import 'package:salon_soft/models/service.dart';
import 'package:salon_soft/models/settings.dart';
import 'package:salon_soft/providers/settings_provider.dart';

import '../models/appointments.dart';
import '../models/worker.dart';

class AppointmentProvider extends CrudHiveProviderInterface<Appointments> {
  SettingsProvider? settingsProvider;
  AppointmentProvider(this.settingsProvider) : super(boxName: "appointments") {}

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

  List<Appointments> getAppointmensByDate(DateTime date) {
    return objects
        .where((appointment) =>
            appointment.initialDate.day == date.day &&
            appointment.initialDate.month == date.month &&
            appointment.initialDate.year == date.year)
        .toList();
  }

  List<int> avaliableHoursByDate(DateTime date) {
    List<int> avaliableHours = [];
    for (int i = settingsProvider!.objectPrivate.openHour;
        i <= settingsProvider!.objectPrivate.closeHour;
        i++) {
      avaliableHours.add(i);
    }
    objects.forEach((appointment) {
      avaliableHours.removeWhere((hour) =>
          hour >= appointment.initialDate.hour &&
          hour < appointment.endDate.hour);
    });
    return avaliableHours;
  }

  List<int> avaliableMinutesByHourAtDate(
      {required DateTime date, required int hour}) {
    List<int> avaliableMinutes = List<int>.generate(59, (index) => index);
    return avaliableMinutes;
  }

  List<DateTime> avaliableHoursByServiceAtDate(
      {required DateTime date,
      required Service service,
      required Worker worker}) {
    List<DateTime> avaliableDates = [];
    DateTime currentDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      settingsProvider!.objectPrivate.openHour,
      settingsProvider!.objectPrivate.openMinute,
    );
    //Adicionando Todas as Datas para as Avaliables datas de
    //acordo com a hora de abertura e fechamento com o intervalo pre definido
    print("Hora de Abertura " +
        settingsProvider!.objectPrivate.openHour.toString());
    print("Hora de Fechamento " +
        settingsProvider!.objectPrivate.closeHour.toString());
    for (int i = settingsProvider!.objectPrivate.openHour;
        i <=
            (settingsProvider!.objectPrivate.closeHour *
                (60 / settingsProvider!.objectPrivate.intervalOfMinutes));
        i++) {
      avaliableDates.add(currentDateTime);
      currentDateTime = currentDateTime.add(
          Duration(minutes: settingsProvider!.objectPrivate.intervalOfMinutes));
    }
    print(avaliableDates.length.toString() + " Primeiro datas disponivel");
    avaliableDates.removeWhere((dateTime) {
      DateTime toCheckDate = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
      );
      print(DateFormat("dd/MM/yyyy HH:mm").format(toCheckDate));
      toCheckDate = toCheckDate.add(service.duration);
      bool containsAny = objects.any((appointment) {
        if (appointment.worker != worker) {
          return false;
        }
        bool isInDateRange = appointment.initialDate.isBefore(toCheckDate) &&
                appointment.endDate.isAfter(toCheckDate) ||
            appointment.initialDate.isBefore(dateTime) &&
                appointment.endDate.isAfter(dateTime);
        print(isInDateRange);
        return isInDateRange;
      });
      print(containsAny);
      return containsAny;
    });

    return avaliableDates;
  }
}
