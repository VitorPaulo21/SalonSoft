import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/components/titled_icon.dart';
import 'package:salon_soft/components/titled_icon_button.dart';
import 'package:salon_soft/providers/date_time_provider.dart';
import 'package:salon_soft/screens/appointment_screen.dart';
import 'package:salon_soft/screens/clients_screen.dart';
import 'package:salon_soft/screens/professionals_screen.dart';
import 'package:salon_soft/screens/servicesScreen.dart';
import 'package:salon_soft/utils/routes.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
                  : null
          ),
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
            onTap: () {},
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
          crossAxisAlignment: CrossAxisAlignment.start,
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


  Column SideBarSelection(BuildContext context) {
    DateTimeProvider dateTimeProvider =
        Provider.of<DateTimeProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 1440 / 6,
          child: ElevatedButton(
            onPressed: () {},
            child: const TitledIcon(
              title: "Adicionar",
              icon: Icon(Icons.calendar_month_outlined),
              centered: true,
            ),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: 1440 / 6,
          height: 1440 / 6,
          child: SfDateRangePicker(
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
        const TitledIcon(
            title: "Pendentes",
            icon: Icon(
              Icons.check_circle,
              color: Colors.amber,
            )),
        const SizedBox(
          height: 5,
        ),
        const TitledIcon(
            title: "Atendendo",
            icon: Icon(
              Icons.check_circle,
              color: Colors.purple,
            )),
        const SizedBox(
          height: 5,
        ),
        const TitledIcon(
            title: "Concluido",
            icon: Icon(
              Icons.check_circle,
              color: Colors.green,
            )),
        const SizedBox(
          height: 5,
        ),
        const TitledIcon(
          title: "Horario Cancelado",
          icon: Icon(
            Icons.check_circle,
            color: Colors.red,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TitledIcon(
          title: "Horario Indisponivel",
          icon: Icon(
            Icons.check_circle,
            color: Colors.lightBlue[900],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
