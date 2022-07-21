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
    object.worker.first.syncToHive();
    objectsPrivate.remove(object);
    notifyListeners();
  }

  List<Appointments> getAppointmensByDate(DateTime date) {
    return objects
        .where((appointment) =>
            (appointment.initialDate.day == date.day &&
                appointment.initialDate.month == date.month &&
                appointment.initialDate.year == date.year) &&
            (appointment.worker.first.isActive ?? true))
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
  List<DateTime> getAvaliableDatesAtDailyRangeBYDate(DateTime date) {
    List<DateTime> avaliableDates = [];
    DateTime openDate = DateTime(
      date.year,
      date.month,
      date.day,
      settingsProvider!.objectPrivate.openHour,
      settingsProvider!.objectPrivate.openMinute,
    );
    DateTime closeDate = DateTime(
      date.year,
      date.month,
      date.day,
      settingsProvider!.objectPrivate.closeHour,
      settingsProvider!.objectPrivate.closeMinute,
    );
    DateTime currentDate = DateTime(openDate.year, openDate.month, openDate.day,
        openDate.hour, openDate.minute);

    while (currentDate.compareTo(closeDate) >= 0) {
      int loops = 0;

      loops++;
      if (loops == 200) {
        break;
      }
    }
    print(avaliableDates.toString());
    return avaliableDates;
  }
  List<DateTime> avaliableHoursByDurationAtDate(
      {required DateTime date,
      required Duration duration,
      required Worker worker,
      Appointments? paramAppointment}) {
    List<DateTime> avaliableHours = [];
    DateTime openDate = DateTime(
      date.year,
      date.month,
      date.day,
      settingsProvider!.objectPrivate.openHour,
      settingsProvider!.objectPrivate.openMinute,
    );
    DateTime closeDate = DateTime(
      date.year,
      date.month,
      date.day,
      settingsProvider!.objectPrivate.closeHour,
      settingsProvider!.objectPrivate.closeMinute,
    );
    List<Appointments> workerAppointments = worker.getAppointmensByDate(date)
      ..remove(paramAppointment)
      ..removeWhere(
        (appoint) =>
            ((appoint.initialDate.compareTo(openDate) >= 0) &&
                appoint.endDate.isAfter(openDate)) ||
            (appoint.initialDate.isBefore(closeDate) &&
                (appoint.endDate.compareTo(closeDate) <= 0)),
      );
    getAvaliableDatesAtDailyRangeBYDate(date);
    return avaliableHours;
  }

  DateTime? nextAvaliableHourByDurationAtDate(
      {required DateTime date,
      required Duration duration,
      required Worker worker,
      Appointments? paramAppointment}) {
    List<DateTime> dates = avaliableHoursByDurationAtDate(
        date: date,
        duration: duration,
        worker: worker,
        paramAppointment: paramAppointment);
    print(dates.toString());
    print(DateFormat("dd/HH/yyyy HH:mm").format(date));
    print(paramAppointment == null);

    late DateTime nextDate;
    if (dates.isEmpty) {
      print(1);
      nextDate = date;
    } else if (dates[0].isAtSameMomentAs(date)) {
      print(2);
      nextDate = date;
    } else if (dates.any((dateItem) => dateItem.compareTo(date) >= 0)) {
      print(3);
      nextDate = dates.firstWhere((dateItem) => dateItem.compareTo(date) >= 0);
    } else {
      print(4);
      nextDate = dates
          .lastWhere((dateItem) => dateItem.compareTo(date.add(duration)) <= 0)
          .subtract(duration);
    }

    return nextDate;
  }
}
