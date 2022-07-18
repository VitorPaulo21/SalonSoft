import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/providers/appointment_provider.dart';
import 'package:salon_soft/providers/date_time_provider.dart';
import 'package:salon_soft/providers/keys_provider.dart';
import 'package:salon_soft/providers/settings_provider.dart';
import 'package:salon_soft/providers/worker_provider.dart';

import '../models/appointment.dart';
import '../models/header.dart';
import '../models/line.dart';
import '../models/time.dart';
import '../team_calendar.dart';

class AppointmenScreen extends StatefulWidget {
  const AppointmenScreen({Key? key}) : super(key: key);

  @override
  State<AppointmenScreen> createState() => _AppointmenScreenState();
}

class _AppointmenScreenState extends State<AppointmenScreen> {
  @override
  void initState() {
    super.initState();
    print("Initied State");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Provider.of<KeysProvider>(context, listen: false).keys.isNotEmpty) {
        print("Possui Chaves");
        if (Provider.of<KeysProvider>(context, listen: false)
                .keys
                .values
                .first
                .currentContext !=
            null) {
          print("Possui Contexto");
          Scrollable.ensureVisible(
            Provider.of<KeysProvider>(context, listen: false)
                .keys
                .values
                .first
                .currentContext!,
            curve: Curves.fastOutSlowIn,
            duration: kThemeAnimationDuration,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Builting");

    DateTimeProvider dateTimeProvider = Provider.of<DateTimeProvider>(context);
    WorkerProvider workerProvider = Provider.of<WorkerProvider>(context);
    AppointmentProvider appointmentProvider = Provider.of<AppointmentProvider>(
      context,
    );
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    int activeWorkersCount = workerProvider.objects
        .where((worker) => worker.isActive ?? false)
        .length;

    return LayoutBuilder(
        builder: (context, constraints) => Container(
            margin: EdgeInsets.only(top: 15),
            child: TeamCalendarGrid(context, constraints, activeWorkersCount)));
  }

  TeamCalendar TeamCalendarGrid(BuildContext context,
      BoxConstraints constraints, int activeWorkersCount) {
    Provider.of<KeysProvider>(context, listen: false).keys.clear();

    WorkerProvider workerProvider =
        Provider.of<WorkerProvider>(context, listen: false);
    DateTimeProvider dateTimeProvider =
        Provider.of<DateTimeProvider>(context, listen: false);
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    return TeamCalendar(
      timeSlotWidth: 45,
      timeSlotHeight: 55,
      startTime: Time(settingsProvider.objectPrivate.openHour,
          settingsProvider.objectPrivate.openMinute),
      endTime: Time(settingsProvider.objectPrivate.closeHour,
          settingsProvider.objectPrivate.closeMinute),
      timeSlot: TimeSlot.thirteen,
      resources: [
        ...workerProvider.objects
            .where((worker) => worker.isActive ?? false)
            .map<Line>((worker) {
          return Line(
            header: Header(
              title: worker.name,
              photoPath: worker.photoPath,
            ),
            appointments: [
              ...worker.appointments
                  .where((appointment) =>
                      appointment.initialDate.year ==
                          dateTimeProvider.currentDateTime.year &&
                      appointment.initialDate.month ==
                          dateTimeProvider.currentDateTime.month &&
                      appointment.initialDate.day ==
                          dateTimeProvider.currentDateTime.day)
                  .map<Appointment>((appoint) {
                return Appointment(appoint,
                    title: appoint.service.first.name,
                    start: Time(
                        appoint.initialDate.hour, appoint.initialDate.minute),
                    end: Time(appoint.endDate.hour, appoint.endDate.minute),
                    onTap: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          titlePadding:
                              EdgeInsets.only(left: 24, top: 3, right: 3),
                          title: Row(
                            children: [
                              Text("Agendamento"),
                              Expanded(child: SizedBox()),
                              Icon(Icons.edit),
                              Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          content: Container(
                            width: MediaQuery.of(context).size.width * 0.5 > 400
                                ? MediaQuery.of(context).size.width * 0.5
                                : 400,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.person_outline,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  title: Text("Cliente"),
                                  subtitle: Text(appoint.client.first.name),
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.badge_outlined,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  title: Text("Atendente"),
                                  subtitle: Text(appoint.worker.first.name),
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.calendar_month_outlined,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  title: Text("Horário"),
                                  subtitle: Text(
                                      "${DateFormat("dd/MM/yy").format(appoint.initialDate)} às ${DateFormat("dd/MM/yy").format(appoint.endDate)}"),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                });
              })
            ],
          );
        })
      ],
      lineWidth:
          (constraints.maxWidth / activeWorkersCount) - 45 / activeWorkersCount,
    );
  }

  List<Widget> appointmentsGrid(
      WorkerProvider workerProvider, BoxConstraints constraints) {
    int activeWorkersCount = workerProvider.objects
        .where((worker) => worker.isActive ?? false)
        .length;
    return workerProvider.objects
        .where((worker) => worker.isActive ?? false)
        .map<Widget>((worker) {
      return Container(
        alignment: Alignment.topCenter,
        width: constraints.maxWidth / activeWorkersCount,
        height: constraints.maxHeight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: workerProvider.objects.indexOf(worker) !=
                          activeWorkersCount - 1
                      ? (constraints.maxWidth / activeWorkersCount) - 16
                      : constraints.maxWidth / activeWorkersCount,
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: worker.photoPath.isEmpty
                            ? Colors.grey[300]
                            : Colors.transparent,
                        foregroundImage: worker.photoPath.isNotEmpty
                            ? FileImage(File(worker.photoPath))
                            : null,
                        child: worker.photoPath == null
                            ? const Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.grey,
                                size: 30,
                              )
                            : null,
                      ),
                      title: Text(worker.name),
                    ),
                  ),
                )
              ],
            ),
            if (workerProvider.objects.indexOf(worker) !=
                workerProvider.objects
                        .where((worker) => worker.isActive ?? false)
                        .length -
                    1)
              VerticalDivider(
                thickness: 2,
              )
          ],
        ),
      );
    }).toList();
  }
}
