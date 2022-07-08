import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/components/titled_icon.dart';
import 'package:salon_soft/components/titled_icon_button.dart';
import 'package:salon_soft/models/appointment.dart';
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
    AppointmentProvider appointmentProvider =
        Provider.of<AppointmentProvider>(context);
    WorkerProvider workerProvider = Provider.of<WorkerProvider>(context);
    ClientsProvider clientsProvider = Provider.of<ClientsProvider>(context);
    DateTimeProvider dateTimeProvider =
        Provider.of<DateTimeProvider>(context, listen: false);
    ServicesProvider servicesProvider =
        Provider.of<ServicesProvider>(context, listen: false);
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
            onLongPress: () {
              appointmentProvider.removeAllObjects();
            },
            onPressed: () {
              addAppointmentDialog(context);
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
    );
  }

  Future<dynamic> addAppointmentDialog(
    BuildContext context,
  ) {
    Worker? currentWorker;
    Client? currentClient;
    Service? currentService;
    int currentStep = 0;
    Widget dropdownRoundBorder<T>({
      required List<T> objects,
      required StateSetter setState,
      String label = "",
    }) {
      TextEditingController valueController = TextEditingController();

      switch (T) {
        case Worker:
          {
            if (currentWorker != null) {
              valueController.text = currentWorker.toString();
            }
            break;
          }
        case Client:
          {
            if (currentClient != null) {
              valueController.text = currentClient.toString();
            }

            break;
          }
        case Service:
          {
            if (currentService != null) {
              valueController.text = currentService.toString();
            }

            break;
          }
      }

      return TypeAheadFormField<T>(
        onSuggestionSelected: (selectedObject) {
          valueController.text = selectedObject.toString();
          setState(() {
            switch (T) {
              case Worker:
                {
                  currentWorker = selectedObject as Worker;
                  break;
                }
              case Client:
                {
                  currentClient = selectedObject as Client;

                  break;
                }
              case Service:
                {
                  currentService = selectedObject as Service;

                  break;
                }
            }

            if (currentStep < 2) {
              currentStep++;
            }
          });
        },
        itemBuilder: (ctx, item) {
          return ListTile(
            title: Text(item.toString()),
          );
        },
        suggestionsCallback: (query) {
          return objects.where((listObject) => listObject
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()));
        },
        validator: (txt) {
          if (txt == null) {
            return "Campo Obrigatório!";
          } else if (txt.isEmpty) {
            return "Campo Obrigatório!";
          } else if (!objects.any((element) =>
              element.toString().toLowerCase() == txt.toLowerCase())) {
            return "Selecionar Item";
          }
        },
        textFieldConfiguration: TextFieldConfiguration(
            controller: valueController,
            decoration: InputDecoration(
                label: label.isEmpty ? null : Text(label),
                suffixIcon: valueController.text.isEmpty
                    ? null
                    : GestureDetector(
                        onTap: () {
                          valueController.text = "";
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)))),
      );
    }

    WorkerProvider workerProvider =
        Provider.of<WorkerProvider>(context, listen: false);
    ClientsProvider clientsProvider =
        Provider.of<ClientsProvider>(context, listen: false);
    ServicesProvider servicesProvider =
        Provider.of<ServicesProvider>(context, listen: false);
    AppointmentProvider appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);
    DateTimeProvider dateTimeProvider =
        Provider.of<DateTimeProvider>(context, listen: false);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool triedToValidate = false;

    return showDialog(
        context: context,
        builder: (context) {
          TextEditingController workerTextController = TextEditingController();
          TextEditingController clientTextController = TextEditingController();
          TextEditingController servicetextController = TextEditingController();
          TextEditingController obsController = TextEditingController();

          return StatefulBuilder(
            builder: (context, setState) {
              void submitForm() {
                bool isValid = formKey.currentState?.validate() ?? false;
                if (isValid) {
                  Provider.of<AppointmentProvider>(context, listen: false)
                      .addObject(
                    Appointments(
                      worker: HiveList(Hive.box<Worker>("workers"))
                        ..add(currentWorker!),
                      client: HiveList(Hive.box<Client>("clients"))
                        ..add(currentClient!),
                      service: HiveList(Hive.box<Service>("services"))
                        ..add(currentService!),
                      initialDate: DateTime.now(),
                      endDate: DateTime.now().add(currentService!.duration),
                      description: obsController.text,
                    ),
                  );
                  Navigator.of(context, rootNavigator: true).pop();
                } else {
                  setState(() {
                    triedToValidate = true;
                  });
                }
              }

              List<EnhanceStep> steps = [
                EnhanceStep(
                  isActive: true,
                  state: triedToValidate && currentWorker != null
                      ? StepState.complete
                      : triedToValidate
                          ? StepState.error
                          : StepState.indexed,
                  title: Text(currentWorker == null
                      ? "Profissional"
                      : "Profissional - ${currentWorker!.name}"),
                  icon: Icon(Icons.badge_outlined),
                  content: dropdownRoundBorder<Worker>(
                    objects: workerProvider.objects,
                    setState: setState,
                  ),
                ),
                EnhanceStep(
                  isActive: true,
                  state: triedToValidate && currentClient != null
                      ? StepState.complete
                      : triedToValidate
                          ? StepState.error
                          : StepState.indexed,
                  title: Text(currentClient == null
                      ? "Cliente"
                      : "Cliente - ${currentClient!.name}"),
                  icon: Icon(Icons.person_outline_outlined),
                  content: dropdownRoundBorder<Client>(
                    objects: clientsProvider.objects,
                    setState: setState,
                  ),
                ),
                EnhanceStep(
                    isActive: true,
                    state: triedToValidate && currentService != null
                        ? StepState.complete
                        : triedToValidate
                            ? StepState.error
                            : StepState.indexed,
                    title: Text(currentService == null
                        ? "Serviço"
                        : "Serviço - ${currentService!.name}"),
                    icon: Icon(Icons.work_outline_outlined),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        dropdownRoundBorder<Service>(
                          objects: servicesProvider.objects,
                          setState: setState,
                          label: "Serviço: ",
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          maxLines: 3,
                          maxLength: 100,
                          controller: obsController,
                          decoration: InputDecoration(
                              label: const Text("Observações: "),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        )
                      ],
                    )),
                EnhanceStep(
                    title: const Text("Horário"),
                    icon: const Icon(Icons.calendar_month_outlined),
                    content: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            leading:
                                Checkbox(value: true, onChanged: (value) {}),
                            title: Text("Próximo horário disponivel"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: TypeAheadFormField<String>(
                                    onSuggestionSelected: (hour) {},
                                    itemBuilder: (ctx, hour) {
                                      return Text(hour);
                                    },
                                    suggestionsCallback: (query) {
                                      return currentService == null
                                          ? []
                                          : appointmentProvider
                                              .avaliableHoursByServiceAtDate(
                                                date: dateTimeProvider
                                                    .currentDateTime,
                                                service: currentService!,
                                              )
                                              .where(
                                                (date) => query.isEmpty
                                                    ? true
                                                    : DateFormat("HH")
                                                        .format(date)
                                                        .contains(
                                                          (int.tryParse(
                                                                      query) ??
                                                                  -1)
                                                              .toString(),
                                                        ),
                                              )
                                              .map<String>((date) =>
                                                  DateFormat("HH").format(date))
                                              .toSet();
                                    },
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                                label: Text("Horas: "),
                                                // suffixIcon: valueController.text.isEmpty
                                                //     ? null
                                                //     : GestureDetector(
                                                //         onTap: () {
                                                //           valueController.text = "";
                                                //         },
                                                //         child: Icon(
                                                //           Icons.close,
                                                //           color: Colors.red,
                                                //         ),
                                                //       ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15))))),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(":"),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: TypeAheadFormField<int>(
                                    onSuggestionSelected: (hour) {},
                                    itemBuilder: (ctx, hour) {
                                      return Text(hour.toString());
                                    },
                                    suggestionsCallback: (query) {
                                      return [];
                                    },
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                                label: Text("Minutos: "),
                                                // suffixIcon: valueController.text.isEmpty
                                                //     ? null
                                                //     : GestureDetector(
                                                //         onTap: () {
                                                //           valueController.text = "";
                                                //         },
                                                //         child: Icon(
                                                //           Icons.close,
                                                //           color: Colors.red,
                                                //         ),
                                                //       ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15))))),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))
              ];
              print(currentWorker.toString());
              return AlertDialog(
                title: Text("Adicionar Horario"),
                content: SizedBox(
                  height: 400,
                  width: 400,
                  child: Form(
                    key: formKey,
                    child: EnhanceStepper(
                      physics: ClampingScrollPhysics(),
                      stepIconSize: 25,
                      horizontalLinePosition: HorizontalLinePosition.top,
                      horizontalTitlePosition: HorizontalTitlePosition.inline,
                      type: StepperType.vertical,
                      currentStep: currentStep,
                      steps: steps,
                      onStepCancel: () {
                        setState(() {
                          if (currentStep < 3) {
                            currentStep++;
                          } else {
                            currentStep = 0;
                          }
                        });
                      },
                      onStepContinue: () {
                        setState(() {
                          if (currentStep < 3) {
                            currentStep++;
                          }
                        });
                      },
                      onStepTapped: (index) {
                        setState(() {
                          currentStep = index;
                        });
                      },
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text("Cancelar"),
                      style: ElevatedButton.styleFrom(primary: Colors.red)),
                  ElevatedButton(
                    onPressed: submitForm,
                    child: Text("Adicionar"),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                  ),
                ],
              );
            },
          );
        });
  }
}
