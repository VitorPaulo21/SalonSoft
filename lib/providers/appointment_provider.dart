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

  List<DateTime> avaliableHoursByDurationAtDate(
      {required DateTime date,
      required Duration duration,
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

    for (int i = settingsProvider!.objectPrivate.openHour;
        i <=
            (settingsProvider!.objectPrivate.closeHour *
                (60 / settingsProvider!.objectPrivate.intervalOfMinutes));
        i++) {
      avaliableDates.add(currentDateTime);
      currentDateTime = currentDateTime.add(
          Duration(minutes: settingsProvider!.objectPrivate.intervalOfMinutes));
    }

    avaliableDates.removeWhere((dateTime) {
      DateTime toCheckDate = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
      );
      dateTime = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
      );
      toCheckDate =
          toCheckDate.add(Duration(minutes: duration.inMinutes));
      int closeHour = settingsProvider!.objectPrivate.closeHour;
      int closeMinute = settingsProvider!.objectPrivate.closeMinute;
      bool isAfterMaximum = toCheckDate.compareTo(DateTime(dateTime.year,
              dateTime.month, dateTime.day, closeHour, closeMinute)) >
          0;

      bool containsAny = objects
          .where((appointment) => appointment.worker.first == worker)
          .any((appointment) {
        bool isAtSameMoment =
            appointment.initialDate.isAtSameMomentAs(dateTime) &&
                appointment.endDate.isAtSameMomentAs(toCheckDate);

        bool isOutside() {
          bool isOutsideTotal = appointment.initialDate.isAfter(dateTime) &&
              appointment.endDate.isBefore(toCheckDate);
          bool isPartialOutsideInit =
              appointment.initialDate.isAtSameMomentAs(dateTime) &&
                  appointment.endDate.isBefore(toCheckDate);
          bool isPartialOutsideEnd =
              appointment.initialDate.isAfter(dateTime) &&
                  appointment.endDate.isAtSameMomentAs(toCheckDate);
          return isOutsideTotal || isPartialOutsideInit || isPartialOutsideEnd;
        }

        bool isInside() {
          bool isInsideTotal = appointment.initialDate.isBefore(dateTime) &&
              appointment.endDate.isAfter(toCheckDate);

          bool isPartialInsideInit =
              appointment.initialDate.isAtSameMomentAs(dateTime) &&
                  appointment.endDate.isAfter(toCheckDate);

          bool isPartialInsideEnd =
              appointment.initialDate.isBefore(dateTime) &&
                  appointment.endDate.isAtSameMomentAs(toCheckDate);
          return isInsideTotal || isPartialInsideInit || isPartialInsideEnd;
        }
        
        bool isafter = appointment.initialDate.isBefore(toCheckDate) &&
            appointment.initialDate.isAfter(dateTime);

        bool isbefore = appointment.endDate.isAfter(dateTime) &&
            appointment.endDate.isBefore(toCheckDate);
        if (isAtSameMoment ||
            isOutside() ||
            isInside() ||
            isafter ||
            isbefore) {
          print(DateFormat("dd/MM/yyyy HH:mm").format(dateTime));
          print(DateFormat("dd/MM/yyyy HH:mm").format(toCheckDate));
          print(DateFormat("dd/MM/yyyy HH:mm").format(appointment.initialDate) +
              " - Appointment Initial Date");
          print(DateFormat("dd/MM/yyyy HH:mm").format(appointment.endDate) +
              " - Appointment End Date");
          print("Is at same moment " + isAtSameMoment.toString());
          print("Is Outside " + isOutside().toString());
          print("Is Inside " + isInside().toString());
          print("Is After " + isafter.toString());
          print("Is before " + isbefore.toString());
        }
        return isAtSameMoment ||
            isOutside() ||
            isInside() ||
            isafter ||
            isbefore;
      });

      return containsAny || isAfterMaximum;
    });
    print(avaliableDates.toString());
    return avaliableDates;
  }

  DateTime? nextAvaliableHourByDurationAtDate(
      {required DateTime date,
      required Duration duration,
      required Worker worker}) {
    List<DateTime> dates = avaliableHoursByDurationAtDate(
        date: date, duration: duration, worker: worker);
    late DateTime nextDate;
    if (dates.isEmpty) {
      nextDate = date;
    } else if (dates[0].isAtSameMomentAs(date)) {
      nextDate = date;
    } else if (dates.any((dateItem) => dateItem.isAfter(date))) {
      nextDate = dates.firstWhere((dateItem) => dateItem.isAfter(date));
    } else {
      return dates
          .lastWhere((dateItem) => dateItem.compareTo(date.add(duration)) <= 0)
          .subtract(duration);
    }

    return nextDate;
  }
}
