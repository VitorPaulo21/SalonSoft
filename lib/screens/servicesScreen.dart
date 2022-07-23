import 'dart:collection';

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/models/service.dart';
import 'package:salon_soft/providers/appointment_provider.dart';
import 'package:salon_soft/providers/services_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<Service> services = [];
  String query = "";
  TextEditingController queryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    services = Provider.of<ServicesProvider>(context).objects;
    services = services
        .where((service) =>
            service.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return LayoutBuilder(builder: (ctx, constrains) {
      return Row(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              serviceSearchField(),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 30),
                child: servicesListComponent(),
              )),
            ],
          )),
          SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 5,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Container(
                    width: constrains.maxWidth / 3,
                    height: 300,
                    child: mostSelledServices(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Card(
                  elevation: 5,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Container(
                    height: (constrains.maxHeight - 30 - 15 - 10 - 300) > 400
                        ? constrains.maxHeight - 30 - 15 - 10 - 300 - 16
                        : 400,
                    width: constrains.maxWidth / 3,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          )
        ],
      );
    });
  }

  Padding serviceSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(90))),
        elevation: 5,
        child: CupertinoTextField(
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
      ),
    );
  }

  Card servicesListComponent() {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      elevation: 5,
      child: Container(
          alignment: Alignment.center,
          width: 380,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 35,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onPressed: () {
                      addServiceDialog();
                    },
                    child: const Text("Adicionar Serviço")),
              ),
              const ListTile(
                leading: Icon(Icons.list),
                title: Text("Serviço"),
                trailing: Text("Duração"),
              ),
              Expanded(
                child: servicesListComponentItem(),
              ),
            ],
          )),
    );
  }

  ListView servicesListComponentItem() {
    return ListView.builder(
        controller: ScrollController(),
        itemCount: services.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            leading: const Icon(Icons.work_outline),
            title: Text(services[index].name),
            trailing:
                Text(getTimeHoursByMinutes(services[index].duration.inMinutes)),
            key: UniqueKey(),
            onTap: () => addServiceDialog(services[index]),
          );
        });
  }

  Future<dynamic> addServiceDialog([Service? service]) {
    return showDialog(
        context: context,
        builder: (ctx) {
          TextEditingController nameController = TextEditingController();
          TextEditingController hourController = TextEditingController();
          TextEditingController minController = TextEditingController();
          GlobalKey<FormState> formKey = GlobalKey<FormState>();
          nameController.text = service?.name ?? "";
          if (service != null) {
            hourController.text =
                service.duration.inHours.toString().padLeft(2, "0");
            minController.text =
                (service.duration.inMinutes % 60).toString().padLeft(2, "0");
          }
          void submitForm() {
            bool isvalid = formKey.currentState?.validate() ?? false;
            if (isvalid) {
              if (service == null) {
                Provider.of<ServicesProvider>(context, listen: false).addObject(
                  Service(
                    name: nameController.text,
                    duration: Duration(
                      hours: int.parse(hourController.text),
                      minutes: int.parse(minController.text),
                    ),
                  ),
                );
              } else {
                service.name = nameController.text;
                service.duration = Duration(
                  hours: int.parse(hourController.text),
                  minutes: int.parse(minController.text),
                );
                Provider.of<ServicesProvider>(context, listen: false)
                    .saveData(service);
              }
              Navigator.of(context, rootNavigator: true).pop();
            }
          }

          return AlertDialog(
            titlePadding: service == null
                ? null
                : EdgeInsets.only(left: 24, right: 3, top: 8),
            title: service == null
                ? Text("Adicionar Serviço")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Adicionar Serviço"),
                      IconButton(
                        onPressed: (() =>
                            removeServiceDialog(context, service)),
                        icon: const Icon(
                          Icons.delete_forever_outlined,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    maxLength: 25,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        label: Text("Nome: "),
                        border: RoundInputBorder(
                            Theme.of(context).colorScheme.primary),
                        errorBorder: RoundInputBorder(Colors.red)),
                    validator: (txt) {
                      if (txt == null) {
                        return "Campo Vazio!";
                      } else if (txt.isEmpty) {
                        return "Campo Vazio!";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                          ],
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.center,
                          controller: hourController,
                          decoration: InputDecoration(
                            suffixText: "Hs",
                            label: Text("Horas:"),
                            border: RoundInputBorder(
                                Theme.of(context).colorScheme.primary),
                            errorBorder: RoundInputBorder(Colors.red),
                          ),
                          // onFieldSubmitted: (txt) =>
                          //     submitForm(),
                          validator: (txt) {
                            if (txt == null) {
                              return "Campo Vazio!";
                            } else if (txt.isEmpty) {
                              return "Campo Vazio!";
                            } else if (int.tryParse(txt) == null) {
                              return "Valor Inválido";
                            } else if (int.parse(txt) < 0) {
                              return "Negativo!";
                            } else if (int.parse(txt) > 24) {
                              return "Máximo 24H!";
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(":"),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                          ],
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (txt) => submitForm(),
                          textAlign: TextAlign.center,
                          controller: minController,
                          decoration: InputDecoration(
                            suffixText: "min",
                            label: Text("Mins:"),
                            border: RoundInputBorder(
                                Theme.of(context).colorScheme.primary),
                            errorBorder: RoundInputBorder(Colors.red),
                          ),
                          validator: (txt) {
                            if (txt == null) {
                              return "Campo Vazio!";
                            } else if (txt.isEmpty) {
                              return "Campo Vazio!";
                            } else if (int.tryParse(txt) == null) {
                              return "Valor Inválido";
                            } else if (int.parse(txt) == 0 &&
                                (int.tryParse(hourController.text) ?? 0) <= 0) {
                              return "Valor Zerado";
                            } else if (int.parse(txt) < 0) {
                              return "Negativo!";
                            } else if (int.parse(txt) > 59) {
                              return "Máximo 24min!";
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: submitForm,
                  child: Text(service == null ? "Adicionar" : "Salvar")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text("Cancelar")),
            ],
          );
        });
  }

  OutlineInputBorder RoundInputBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
    );
  }

  String getTimeHoursByMinutes(int minutes) {
    int hours = minutes ~/ 60;
    int minutesdif = minutes % 60;
    return "${hours.toString().padLeft(2, "0")} : ${minutesdif.toString().padLeft(2, "0")}";
  }

  void removeServiceDialog(BuildContext context, Service service) {
    showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Remover Serviço"),
            content: const Text("Deseja remover permanentemente este Serviço?"),
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
        Provider.of<ServicesProvider>(context, listen: false)
            .removeObject(service);
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }
}

class mostSelledServices extends StatefulWidget {
  const mostSelledServices({
    Key? key,
  }) : super(key: key);

  @override
  State<mostSelledServices> createState() => _mostSelledServicesState();
}

class _mostSelledServicesState extends State<mostSelledServices> {
  @override
  Widget build(BuildContext context) {
    ServicesProvider servicesProvider = Provider.of<ServicesProvider>(context);
    AppointmentProvider appointmentProvider =
        Provider.of<AppointmentProvider>(context);
    Map<Service, Duration> selledServices = {};
    for (Service service in servicesProvider.objects) {
      selledServices.putIfAbsent(
        service,
        () => appointmentProvider
            .getAppointmentsByService(service)
            .fold<Duration>(
              Duration(),
              (previousValue, element) => Duration(
                minutes: previousValue.inMinutes +
                    element.service
                        .fold<Duration>(
                          Duration(),
                          (previousServiceValue, serviceElement) => Duration(
                            minutes: previousServiceValue.inMinutes +
                                serviceElement.duration.inMinutes,
                          ),
                        )
                        .inMinutes,
              ),
            ),
      );
    }
    SplayTreeMap<Service, Duration> mostSelledServices =
        SplayTreeMap<Service, Duration>.from(
            selledServices,
            ((key1, key2) => selledServices[key1]!
                .inMinutes
                .compareTo(selledServices[key2]!.inMinutes)));

    if (mostSelledServices.length > 3) {
      while (mostSelledServices.length > 3) {
        mostSelledServices.remove(mostSelledServices.lastKey());
      }
    }
    List<Map<String, int>> dataSource = [];
    for (MapEntry<Service, Duration> entry in mostSelledServices.entries) {
      dataSource.add({entry.key.toString(): entry.value.inMinutes});
    }

    print(selledServices);
    print(mostSelledServices);
    print(dataSource);
    return SfCircularChart(
      legend: Legend(
          // textStyle: TextStyle(fontSize: 10),

          isVisible: true,
          position: LegendPosition.bottom,
          isResponsive: true,
          overflowMode: LegendItemOverflowMode.wrap,
          orientation: LegendItemOrientation.vertical),
      series: <CircularSeries<Map<String, int>, String>>[
        DoughnutSeries(
            dataLabelMapper: (datum, index) {
              int thisValue = (datum.values.first * 100);
              int totalValue = dataSource.fold<int>(
                  0,
                  (previousValue, element) =>
                      previousValue + element.values.first);
              return "${(thisValue / (totalValue <= 0 ? 1 : totalValue)).toStringAsFixed(2)}%";
            },
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
            ),
            dataSource: dataSource,
            radius: "50%",
            innerRadius: "65%",
            xValueMapper: (value, index) => value.keys.first,
            yValueMapper: (value, index) => 25)
      ],
    );
  }
}
