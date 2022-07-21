import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/components/circular_percentage_chart.dart';
import 'package:salon_soft/models/appointment.dart';
import 'package:salon_soft/models/appointments.dart';
import 'package:salon_soft/models/client.dart';
import 'package:salon_soft/providers/appointment_provider.dart';
import 'package:salon_soft/providers/clients_provider.dart';
import 'package:salon_soft/providers/date_time_provider.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({Key? key}) : super(key: key);

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  List<Client> clients = [];
  TextEditingController queryController = TextEditingController();
  String query = "";
  @override
  Widget build(BuildContext context) {
    clients = Provider.of<ClientsProvider>(context).objects;
    DateTimeProvider dateTimeProvider = Provider.of<DateTimeProvider>(context);
    clients = clients
        .where(
            (client) => client.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // margin: EdgeInsets.only(left: 20),
            width: (constraints.maxWidth / 4) * 2,
            child: RoundedSearchField(),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
              child: GridView.builder(
                  itemCount: clients.length + 1,
                  controller: ScrollController(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      mainAxisExtent: 370,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5),
                  itemBuilder: (ctx, index) {
                    return index == 0
                        ? addClientGridItem(context)
                        : clientGridItem(context, index);
                  }))
        ],
      ),
    );
  }

  Widget clientGridItem(BuildContext context, int index) {
    AppointmentProvider appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);
    DateTimeProvider dateTimeProvider =
        Provider.of<DateTimeProvider>(context, listen: false);
    List<Appointments> todayAppointments = appointmentProvider
        .getAppointmensByDate(dateTimeProvider.currentDateTime);
    int appointmentsInMinutes(List<Appointments> appoints) {
      return appoints
          .map<int>((appointment) =>
              appointment.initialDate.difference(appointment.endDate).inMinutes)
          .fold<int>(0, (previousValue, element) => previousValue + element);
    }

    int todayAppointmentsInMinutes = appointmentsInMinutes(todayAppointments);
    int todayClientAppointmentsInMinutes = appointmentsInMinutes(
        todayAppointments
            .where(
                (appointment) => appointment.client.first == clients[index - 1])
            .toList());
    if (todayAppointmentsInMinutes == 0) {
      todayAppointmentsInMinutes = 1;
      todayClientAppointmentsInMinutes = 0;
    }
    return Stack(
      children: [
        Stack(
          children: [
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8, right: 8),
                    child: FittedBox(
                      child: Text(
                        clients[index - 1].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  CircularPercentageChart(
                      allValue: todayAppointmentsInMinutes,
                      percentageValue: todayClientAppointmentsInMinutes,
                      allvalueLegend: "Atendimentos",
                      percentualValueLegend: "Este Cliente"),
                  FittedBox(
                    child: Text(
                        "Valor Gasto: R\$${Random().nextInt(1000).toStringAsFixed(2)}"),
                  )
                ],
              ),
            ),
            const Positioned(
              child: Icon(
                Icons.settings,
                size: 17,
                color: Colors.grey,
              ),
              top: 10,
              right: 10,
            )
          ],
        ),
        
        Positioned.fill(
            child: MaterialButton(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          onPressed: () => addClientDialog(context, clients[index - 1]),
        ))
      ],
    );
  }

  Card RoundedSearchField() {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(90))),
      elevation: 5,
      child: CupertinoTextField(
        textAlign: TextAlign.center,
        controller: queryController,
        onSubmitted: (txt) {
          if (queryController.text.isNotEmpty) {
            setState(() {
              query = queryController.text;
            });
          }
        },
        onChanged: (txt) {
          if (txt.isEmpty) {
            setState(() {
              query = queryController.text;
            });
          }
        },
        textInputAction: TextInputAction.search,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
        suffix: IconButton(
            onPressed: () {
              if (queryController.text.isNotEmpty) {
                setState(() {
                  query = queryController.text;
                });
              }
            },
            icon: const Icon(
              Icons.search,
              color: Colors.cyan,
            )),
        decoration: const BoxDecoration(

            // color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(90))),
      ),
    );
  }

  Stack addClientGridItem(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      Container(
        alignment: Alignment.center,
        color: Colors.grey[200],
        child: Icon(
          Icons.add_circle,
          color: Colors.grey[300],
          size: 120,
        ),
      ),
      Positioned.fill(
        child: MaterialButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            addClientDialog(context);
          },
          // splashColor: Colors.pink,
          // highlightColor: Colors.pink,
          child: Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  addClientDialog(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.person_add_alt),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Adicionar")
                  ],
                )),
          ),
        ),
      )
    ]);
  }

  Future<dynamic> addClientDialog(BuildContext context, [Client? client]) {
    TextEditingController nameController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    ClientsProvider clientsProvider =
        Provider.of<ClientsProvider>(context, listen: false);
    nameController.text = client?.name ?? "";
    return showDialog(
        context: context,
        builder: (ctx) {
          void submitForm() {
            if (formKey.currentState?.validate() ?? false) {
              if (client == null) {
                clientsProvider.addObject(Client(name: nameController.text));
              } else {
                client.name = nameController.text;
                clientsProvider.saveData(client);
              }
              Navigator.of(context).pop();
            }
          }

          return AlertDialog(
            titlePadding: client == null
                ? null
                : EdgeInsets.only(left: 24, top: 3, right: 3),
            title: client == null
                ? const Text("Adicionar Cliente")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Adicionar Cliente"),
                      IconButton(
                          onPressed: () => removeClietDialog(context, client),
                          icon: const Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.red,
                          ))
                    ],
                  ),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text("Nome: "),
                ),
                validator: (txt) {
                  if (txt == null) {
                    return "Campo Vazio!";
                  } else if (txt.isEmpty) {
                    return "Campo Vazio!";
                  }
                },
                onFieldSubmitted: (txt) => submitForm(),
              ),
            ),
            actions: [
              TextButton(onPressed: submitForm, child: Text("Adicionar")),
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text("Cancelar"),
              ),
            ],
          );
        });
  }

  void removeClietDialog(BuildContext context, Client client) {
    showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Remover Cliente"),
            content: const Text("Deseja remover permanentemente este Cliente?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(true);
                  },
                  child: const Text("Sim")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(false);
                  },
                  child: const Text("Não"))
            ],
          );
        }).then((value) {
      if (value ?? false) {
        Provider.of<ClientsProvider>(context, listen: false)
            .removeObject(client);
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }
}
