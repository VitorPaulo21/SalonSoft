import 'package:enhance_stepper/enhance_stepper.dart';

import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/components/dialogs.dart';
import 'package:salon_soft/components/titled_icon.dart';
import 'package:salon_soft/components/titled_icon_button.dart';

import 'package:salon_soft/models/appointments.dart';
import 'package:salon_soft/models/client.dart';
import 'package:salon_soft/models/service.dart';
import 'package:salon_soft/models/worker.dart';
import 'package:salon_soft/providers/appointment_provider.dart';
import 'package:salon_soft/providers/clients_provider.dart';
import 'package:salon_soft/providers/date_time_provider.dart';
import 'package:salon_soft/providers/services_provider.dart';
import 'package:salon_soft/providers/worker_provider.dart';
import 'package:salon_soft/screens/appointment_screen.dart';
import 'package:salon_soft/screens/clients_screen.dart';
import 'package:salon_soft/screens/professionals_screen.dart';
import 'package:salon_soft/screens/servicesScreen.dart';
import 'package:salon_soft/utils/routes.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int screen = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey,
        elevation: 5,
        title: Text(
          "Salon Studio",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        actions: [
          TitledIconButton(
            onTap: () {
              setState(() {
                screen = 0;
              });
            },
            icon: Icon(
              Icons.calendar_month,
              color: screen == 0 ? Theme.of(context).colorScheme.primary : null,
            ),
            title: "Agenda",
            textStyle: screen == 0
                ? TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
          TitledIconButton(
              onTap: () {
                setState(() {
                  screen = 1;
                });
              },
              icon: Icon(Icons.storefront,
                  color: screen == 1
                      ? Theme.of(context).colorScheme.primary
                      : null),
              title: "Clientes",
              textStyle: screen == 1
                  ? TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null),
          TitledIconButton(
              onTap: () {
                setState(() {
                  screen = 2;
                });
              },
              icon: Icon(Icons.storefront,
                  color: screen == 2
                      ? Theme.of(context).colorScheme.primary
                      : null),
              title: "Serviços",
              textStyle: screen == 2
                  ? TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null),
          TitledIconButton(
              onTap: () {
                setState(() {
                  screen = 3;
                });
              },
              icon: Icon(Icons.badge_outlined,
                  color: screen == 3
                      ? Theme.of(context).colorScheme.primary
                      : null),
              title: "Profissionais",
              textStyle: screen == 3
                  ? TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null),
          const SizedBox(
            width: 10,
          ),
          TitledIconButton(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.SETTINGS);
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: "Ajustes",
            textStyle: TextStyle(color: Colors.black),
            invert: true,
            centered: true,
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            SingleChildScrollView(
              child: SideBarSelection(context),
            ),
            Expanded(
                child: screen == 0
                    ? AppointmenScreen()
                    : screen == 1
                        ? ClientsScreen()
                        : screen == 2
                            ? ServicesScreen()
                            : screen == 3
                                ? ProfessionalsScreen()
                                : Center()),
          ],
        ),
      ),
    );
  }

  Widget SideBarSelection(BuildContext context) {
    AppointmentProvider appointmentProvider =
        Provider.of<AppointmentProvider>(context);
    WorkerProvider workerProvider = Provider.of<WorkerProvider>(context);
    ClientsProvider clientsProvider = Provider.of<ClientsProvider>(context);
    DateTimeProvider dateTimeProvider =
        Provider.of<DateTimeProvider>(context, listen: false);
    ServicesProvider servicesProvider =
        Provider.of<ServicesProvider>(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height - kToolbarHeight - 5,
      color: Colors.white,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 1440 / 6,
              child: ElevatedButton(
                onLongPress: () {
                  // appointmentProvider.removeAllObjects();
                },
                onPressed: () {
                  Dialogs.addAppointmentDialog(context, null, null);
                },
                child: const TitledIcon(
                  title: "Adicionar",
                  icon: Icon(Icons.calendar_month_outlined),
                  centered: true,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 1440 / 6,
              height: 1440 / 6,
              child: SfDateRangePicker(
                monthViewSettings:
                    const DateRangePickerMonthViewSettings(dayFormat: "E"),
                enablePastDates: false,
                initialSelectedDate: dateTimeProvider.currentDateTime,
                onSelectionChanged: (dateTime) {
                  dateTimeProvider.currentDateTime = dateTime.value;
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 1440 / 6,
              child: Text("Legenda"),
            ),
            const SizedBox(
              height: 10,
            ),
            TitledIcon(
                title: "Pendentes",
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.amber.withAlpha(110),
                )),
            const SizedBox(
              height: 5,
            ),
            TitledIcon(
                title: "Atendendo",
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.purple.withAlpha(110),
                )),
            const SizedBox(
              height: 5,
            ),
            TitledIcon(
                title: "Concluido",
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.green.withAlpha(110),
                )),
            const SizedBox(
              height: 5,
            ),
            TitledIcon(
              title: "Horario Cancelado",
              icon: Icon(
                Icons.check_circle,
                color: Colors.red.withAlpha(110),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TitledIcon(
              title: "Horario Indisponivel",
              icon: Icon(
                Icons.check_circle,
                color: Colors.indigo.withAlpha(110),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  

  

  
}
