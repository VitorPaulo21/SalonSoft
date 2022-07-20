import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';

import '../models/appointments.dart';
import '../providers/appointment_provider.dart';
import '../providers/settings_provider.dart';

class AppointmentStateSelector extends StatelessWidget {
  AppointmentStateSelector({
    Key? key,
    required this.appointment,
    this.elevation = 8,
    this.borderColor = Colors.white,
    this.iconColor = Colors.white,
    this.borderWidth = 2,
  }) : super(key: key);

  Appointments appointment;
  double elevation;
  double borderWidth;
  Color borderColor;
  Color iconColor;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return PopupMenuButton<int>(
      splashRadius: 20,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      tooltip: "Alterar Estado",
      position: PopupMenuPosition.over,
      constraints: const BoxConstraints(minWidth: 30, maxWidth: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
      initialValue: appointment.situation,
      icon: Material(
        color: Colors.white,
        shape: CircleBorder(),
        elevation: elevation,
        child: Container(
          alignment: Alignment.center,
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: borderWidth),
            shape: BoxShape.circle,
            color: appointment.situation == 0
                ? Colors.amber.withAlpha(150)
                : settingsProvider.objectPrivate
                    .getStateColors()[appointment.situation ?? 0],
          ),
          child: Icon(
            Icons.more_vert,
            color: iconColor,
            size: 18,
          ),
        ),
      ),
      itemBuilder: (context) {
        List<PopupMenuItem<int>> entries = [];
        for (int i = 0;
            i < settingsProvider.objectPrivate.getStateColors().length;
            i++) {
          entries.add(
            PopupMenuItem(
              height: 40,
              padding: const EdgeInsets.all(0),
              value: i,
              child: JustTheTooltip(
                backgroundColor: Colors.black54,
                preferredDirection: AxisDirection.right,
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    const [
                      "Pendente",
                      "Atendendo",
                      "Concluído",
                      "Cancelado",
                      "Indisponível"
                    ][i],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: settingsProvider.objectPrivate.getStateColors()[i],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return entries;
      },
      onSelected: (value) {
        appointment.situation = value;
        Provider.of<AppointmentProvider>(context, listen: false)
            .saveData(appointment);
      },
    );
  }
}
