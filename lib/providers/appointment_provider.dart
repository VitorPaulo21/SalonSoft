import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';
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
    DateTime openDate = _openTimeFromDate(date);
    DateTime closeDate = _closeTimeFromDate(date);
    DateTime currentDate = DateTime(openDate.year, openDate.month, openDate.day,
        openDate.hour, openDate.minute);

    while (currentDate.compareTo(closeDate) < 0) {
      avaliableDates.add(currentDate);
      currentDate = currentDate.add(
          Duration(minutes: settingsProvider!.objectPrivate.intervalOfMinutes));
    }
    return avaliableDates;
  }

  List<DateTime> avaliableHoursByDurationAtDate(
      {required DateTime date,
      required Duration duration,
      required Worker worker,
      Appointments? paramAppointment}) {
    List<DateTime> avaliableHours = [];

    DateTime openDate = _openTimeFromDate(date);

    DateTime closeDate = _closeTimeFromDate(date);

    List<DateTime> allDailyTimes = getAvaliableDatesAtDailyRangeBYDate(date);

    //Obtendo Agendamentos do funcionario de acordo com a data
    List<Appointments> workerAppointments = worker.getAppointmensByDate(date)
      ..remove(paramAppointment)
      ..removeWhere(
        (appoint) =>
            ((appoint.initialDate.compareTo(closeDate) >= 0) &&
                appoint.endDate.isAfter(closeDate)) ||
            (appoint.initialDate.isBefore(openDate) &&
                (appoint.endDate.compareTo(openDate) <= 0)),
      );

    //Se o funcionario nao tiver agendamentos hoje retorna todos os horaios
    if (workerAppointments.isEmpty) {
      avaliableHours.addAll(allDailyTimes.where(
          (dateInList) => !(dateInList.add(duration).isAfter(closeDate))));
    } else {
      for (DateTime dateInList in allDailyTimes) {
        bool matchAnyAppointment = workerAppointments.any((appoint) {
          if (dateInList.add(duration).isAfter(closeDate)) {
            return true;
          } else if (_isDateOutAppointment(
              initialDate: dateInList,
              endDate: dateInList.add(duration),
              appointment: appoint)) {
            return false;
          } else if (dateInList.compareTo(appoint.initialDate) <= 0 &&
              dateInList.add(duration).compareTo(appoint.endDate) >= 0) {
            return true;
          } else if (dateInList.isAfter(appoint.initialDate) ||
              dateInList.add(duration).isBefore(appoint.endDate)) {
            return true;
          } else {
            return false;
          }
        });
        if (!matchAnyAppointment) {
          avaliableHours.add(dateInList);
        }
      }
    }
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

    late DateTime nextDate;
    if (dates.isEmpty) {
      nextDate = date;
    } else if (dates[0].isAtSameMomentAs(date)) {
      nextDate = date;
    } else if (dates.any((dateItem) => dateItem.compareTo(date) >= 0)) {
      nextDate = dates.firstWhere((dateItem) => dateItem.compareTo(date) >= 0);
    } else {
      nextDate = dates
          .lastWhere((dateItem) => dateItem.compareTo(date.add(duration)) <= 0)
          .subtract(duration);
    }

    return nextDate;
  }

  DateTime _closeTimeFromDate(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      settingsProvider!.objectPrivate.closeHour,
      settingsProvider!.objectPrivate.closeMinute,
    );
  }

  DateTime _openTimeFromDate(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      settingsProvider!.objectPrivate.openHour,
      settingsProvider!.objectPrivate.openMinute,
    );
  }

  bool _isDateOutAppointment(
      {required DateTime initialDate,
      required DateTime endDate,
      required Appointments appointment}) {
    return ((initialDate.isBefore(appointment.initialDate)) &&
            (endDate.compareTo(appointment.initialDate) <= 0)) ||
        ((initialDate.compareTo(appointment.endDate) >= 0) &&
            endDate.isAfter(appointment.endDate));
  }

  List<Appointments> getAppointmentsByService(Service service) {
    return objectsPrivate
        .where((appointment) => appointment.service.first == service)
        .toList();
  }
}
