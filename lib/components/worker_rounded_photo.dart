import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/appointments.dart';
import '../models/worker.dart';
import '../providers/date_time_provider.dart';
import '../providers/settings_provider.dart';

class WorkerRoundedPhoto extends StatefulWidget {
  const WorkerRoundedPhoto({
    Key? key,
    required this.file,
    required this.worker,
    this.size = 95,
    this.borderWidth = 4,
  }) : super(key: key);

  final File file;
  final Worker worker;
  final double size;
  final double borderWidth;

  @override
  State<WorkerRoundedPhoto> createState() => _WorkerRoundedPhotoState();
}

class _WorkerRoundedPhotoState extends State<WorkerRoundedPhoto> {
  late SettingsProvider settingsProvider;
  late DateTimeProvider dateTimeProvider;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    settingsProvider = Provider.of<SettingsProvider>(context);
    dateTimeProvider = Provider.of<DateTimeProvider>(context);
    return Container(
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      width: widget.size,
      height: widget.size,
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(90)),
          child: Image.file(
            widget.file,
            fit: BoxFit.cover,
            key: UniqueKey(),
            height: widget.size,
            width: widget.size,
          )),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: getColorByAppointments(),
          width: widget.borderWidth,
        ),
      ),
    );
  }

  Color getColorByAppointments() {
    DateTime openDate = _openTimeFromDate(dateTimeProvider.currentDateTime);
    DateTime closeDate = _closeTimeFromDate(dateTimeProvider.currentDateTime);
    final List<Appointments> todayWorkerAppointments =
        widget.worker.getAppointmensByDate(dateTimeProvider.currentDateTime)
          ..removeWhere(
            (appoint) =>
                ((appoint.initialDate.compareTo(closeDate) >= 0) &&
                    appoint.endDate.isAfter(closeDate)) ||
                (appoint.initialDate.isBefore(openDate) &&
                    (appoint.endDate.compareTo(openDate) <= 0)),
          );
    final bool isContainingSomeCanceledOrIndisponible =
        todayWorkerAppointments.any((appointment) =>
            appointment.situation == 3 || appointment.situation == 4);
    List<Appointments> canceledOrInativeAppoints = todayWorkerAppointments
        .where((appointment) =>
            appointment.situation == 3 || appointment.situation == 4)
        .toList();
    //Checa se a lista está vazia
    if (todayWorkerAppointments.isEmpty) {
      return Colors.white;

      // checa se ha agendamentos em atendimento
    } else if (todayWorkerAppointments
        .any((appointment) => appointment.situation == 1)) {
      return settingsProvider.objectPrivate.getStateColors()[1].withAlpha(255);

      //checa se ha agendamentos cancelasdops ou indisponiveis
    } else if (isContainingSomeCanceledOrIndisponible &&
        canceledOrInativeAppoints.any((appointment) =>
            appointment.initialDate
                    .compareTo(dateTimeProvider.currentDateTime) <=
                0 &&
            appointment.endDate.compareTo(dateTimeProvider.currentDateTime) >=
                0)) {
      //checa se esses cancelados ou indisponiveis se ha algum que esteja no horario atual

      Appointments currentAppointment = canceledOrInativeAppoints.firstWhere(
          (appointment) =>
              appointment.initialDate
                      .compareTo(dateTimeProvider.currentDateTime) <=
                  0 &&
              appointment.endDate.compareTo(dateTimeProvider.currentDateTime) >=
                  0);
      return settingsProvider.objectPrivate
          .getStateColors()[currentAppointment.situation!]
          .withAlpha(255);

      //checa se ha agendamentos em aberto
    } else if (todayWorkerAppointments
        .any((appointment) => appointment.situation == 0)) {
      return settingsProvider.objectPrivate.getStateColors()[0].withAlpha(255);

      //checa se todos os agendamentos estao concluidos sem contar com cancelados e Indisponiveis
    } else if (((todayWorkerAppointments
          ..removeWhere((appointment) =>
              appointment.situation == 3 || appointment.situation == 4))
        .every((appointment) => appointment.situation == 2))) {
      return settingsProvider.objectPrivate.getStateColors()[2].withAlpha(255);
    } else {
      return Colors.white;
    }
  }

  DateTime _closeTimeFromDate(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      settingsProvider.objectPrivate.closeHour,
      settingsProvider.objectPrivate.closeMinute,
    );
  }

  DateTime _openTimeFromDate(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      settingsProvider.objectPrivate.openHour,
      settingsProvider.objectPrivate.openMinute,
    );
  }
}
