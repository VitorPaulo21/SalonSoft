import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/components/appointment_state_selector.dart';
import 'package:salon_soft/models/appointments.dart';
import 'package:salon_soft/models/settings.dart';
import 'package:salon_soft/providers/date_time_provider.dart';
import 'package:salon_soft/providers/services_provider.dart';
import 'package:salon_soft/providers/settings_provider.dart';

import '../models/client.dart';
import '../models/service.dart';
import '../models/worker.dart';
import '../providers/appointment_provider.dart';
import '../providers/clients_provider.dart';
import '../providers/worker_provider.dart';

class Dialogs {
  static String getTimeHoursByMinutes(int minutes) {
    int hours = minutes ~/ 60;
    int minutesdif = minutes % 60;
    return "${hours.toString().padLeft(2, "0")} : ${minutesdif.toString().padLeft(2, "0")}";
  }

  static Future<dynamic> addAppointmentDialog(
      BuildContext context,
      Appointments? paramAppointment, Worker? selectedWorker) {
    Worker? currentWorker = selectedWorker;
    Client? currentClient;
    List<Service> currentServices = [];
    DateTime? currentDateTime;
    if (paramAppointment != null) {
      currentWorker = paramAppointment.worker.first;
      currentClient = paramAppointment.client.first;
      currentDateTime = paramAppointment.initialDate;
      currentServices = paramAppointment.service;
    }
    int currentStep =
        selectedWorker != null && paramAppointment == null ? 1 : 0;
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
            if (currentServices.isEmpty) {
              // valueController.text = currentServices.length > 0
              //     ? currentServices[0].toString()
              //     : "";
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
                  currentServices.add(selectedObject as Service);

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
          if (T == Service) {
            if (currentServices.isEmpty) {
              return "Campo Obrigatório";
            }
          } else {
            if (txt == null) {
              return "Campo Obrigatório!";
            } else if (txt.isEmpty) {
              return "Campo Obrigatório!";
            } else if (!objects.any((element) =>
                element.toString().toLowerCase() == txt.toLowerCase())) {
              return "Selecionar Item";
            }
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
                        child: const Icon(
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
          TextEditingController hourController = TextEditingController();
          TextEditingController minuteController = TextEditingController();
          bool nextAvaliableHour = paramAppointment == null;
          if (paramAppointment != null) {
            obsController.text = paramAppointment.description ?? "";
          }
          return StatefulBuilder(
            builder: (context, setState) {
              void submitForm() {
                bool isValid = formKey.currentState?.validate() ?? false;
                if (isValid) {
                  currentDateTime = DateTime(
                    dateTimeProvider.currentDateTime.year,
                    dateTimeProvider.currentDateTime.month,
                    dateTimeProvider.currentDateTime.day,
                    int.parse(hourController.text),
                    int.parse(minuteController.text),
                  );
                  Provider.of<AppointmentProvider>(context, listen: false)
                      .addObject(
                    Appointments(
                      worker: HiveList(Hive.box<Worker>("workers"))
                        ..add(currentWorker!),
                      client: HiveList(Hive.box<Client>("clients"))
                        ..add(currentClient!),
                      service: HiveList(Hive.box<Service>("services"))
                        ..addAll(currentServices),
                      initialDate: currentDateTime!,
                      endDate: currentDateTime!.add(currentServices
                          .map<Duration>((service) => service.duration)
                          .reduce(
                            (previousValue, nextValue) => Duration(
                              minutes:
                                  previousValue.inMinutes + nextValue.inMinutes,
                            ),
                          )),
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
                    objects: workerProvider.objects
                        .where((worker) => worker.isActive ?? true)
                        .toList(),
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
                  state: triedToValidate && currentServices.isNotEmpty
                      ? StepState.complete
                      : triedToValidate
                          ? StepState.error
                          : StepState.indexed,
                  title: Text(currentServices.isEmpty
                      ? "Serviço"
                      : "Serviço - ${currentServices.length > 1 ? "${currentServices[0]}..." : currentServices[0]}"),
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
                      if (currentServices.isNotEmpty)
                        Container(
                          height: 150,
                          child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...currentServices.map<Widget>((service) {
                                    return Card(
                                      elevation: 3,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              leading: Icon(Icons.work_outline),
                                              title: Text(service.name),
                                              trailing: Text(
                                                  getTimeHoursByMinutes(service
                                                      .duration.inMinutes)),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                currentServices.remove(service);
                                              });
                                            },
                                            child: Container(
                                              width: 13,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(5)),
                                                color: Colors.red,
                                              ),
                                              height: 50,
                                              child: const Icon(
                                                Icons.close,
                                                size: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                EnhanceStep(
                  isActive: true,
                  state: obsController.text.isNotEmpty
                      ? StepState.complete
                      : StepState.editing,
                  title: Text("Observação"),
                  icon: Icon(Icons.notes),
                  content: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: TextField(
                      maxLines: 3,
                      maxLength: 100,
                      controller: obsController,
                      decoration: InputDecoration(
                          label: const Text("Observações: "),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                  ),
                ),
                EnhanceStep(
                    title: Text("Horário" +
                        (currentDateTime != null
                            ? " - ${DateFormat("dd/MM/yyyy # HH:mm").format(currentDateTime!).replaceAll("#", "às")}"
                            : "")),
                    icon: const Icon(Icons.calendar_month_outlined),
                    state: triedToValidate && currentDateTime == null
                        ? StepState.error
                        : StepState.complete,
                    content: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: appointmentDurationPicker(
                        currentServices,
                        currentWorker,
                        nextAvaliableHour,
                        hourController,
                        appointmentProvider,
                        dateTimeProvider,
                        minuteController,
                        currentDateTime,
                        paramAppointment,
                      ),
                    ))
              ];

              return AlertDialog(
                title: Text("Adicionar Horario"),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height > 400
                      ? MediaQuery.of(context).size.height * 0.6
                      : 400,
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
                          if (currentStep < 4) {
                            currentStep++;
                          } else {
                            currentStep = 0;
                          }
                        });
                        Scrollable.ensureVisible(
                          context,
                          curve: Curves.fastOutSlowIn,
                          duration: kThemeAnimationDuration,
                        );
                      },
                      onStepContinue: () {
                        setState(() {
                          if (currentStep < 4) {
                            currentStep++;
                          }
                        });
                        // if (_keys[stepIndex].currentContext != null) {
                        //   Future.delayed(Duration(
                        //           milliseconds:
                        //               kThemeAnimationDuration.inMilliseconds))
                        //       .then((value) {
                        //     Scrollable.ensureVisible(
                        //       _keys[widget.currentStep].currentContext!,
                        //       curve: Curves.fastOutSlowIn,
                        //       duration: kThemeAnimationDuration,
                        //     );
                        //   });
                        // }
                      },
                      onStepTapped: (index) {
                        setState(() {
                          currentStep = index;
                        });
                        Scrollable.ensureVisible(
                          context,
                          curve: Curves.fastOutSlowIn,
                          duration: kThemeAnimationDuration,
                        );
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
                    onPressed: () {
                      if (paramAppointment != null) {
                        if (paramAppointment.worker.first != currentWorker) {
                          appointmentProvider.removeObject(paramAppointment);
                          submitForm();
                          Navigator.of(context, rootNavigator: true).pop();
                        } else if (formKey.currentState?.validate() ?? false) {
                          currentDateTime = DateTime(
                            dateTimeProvider.currentDateTime.year,
                            dateTimeProvider.currentDateTime.month,
                            dateTimeProvider.currentDateTime.day,
                            int.parse(hourController.text),
                            int.parse(minuteController.text),
                          );
                          paramAppointment.client[0] = currentClient!;
                          paramAppointment.description = obsController.text;
                          paramAppointment.initialDate = currentDateTime!;
                          paramAppointment.service.replaceRange(0,
                              paramAppointment.service.length, currentServices);
                          paramAppointment.situation =
                              paramAppointment.situation;
                          paramAppointment.worker[0] = currentWorker!;
                          paramAppointment.endDate = currentDateTime!.add(
                              currentServices
                                  .map<Duration>((service) => service.duration)
                                  .reduce(
                                    (previousValue, nextValue) => Duration(
                                      minutes: previousValue.inMinutes +
                                          nextValue.inMinutes,
                                    ),
                                  ));

                          appointmentProvider.saveData(paramAppointment);
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                      } else {
                        submitForm();
                      }
                    },
                    child:
                        Text(paramAppointment != null ? "Salvar" : "Adicionar"),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                  ),
                ],
              );
            },
          );
        });
  }

  static Widget appointmentDurationPicker(
      List<Service> currentServices,
      Worker? currentWorker,
      bool nextAvaliableHour,
      TextEditingController hourController,
      AppointmentProvider appointmentProvider,
      DateTimeProvider dateTimeProvider,
      TextEditingController minuteController,
      DateTime? currentDateTime,
      Appointments? paramAppointment) {
    return StatefulBuilder(builder: (context, setState) {
      Settings settings =
          Provider.of<SettingsProvider>(context, listen: false).objectPrivate;
      if (dateTimeProvider.currentDateTime.compareTo(DateTime(
            dateTimeProvider.currentDateTime.year,
            dateTimeProvider.currentDateTime.month,
            dateTimeProvider.currentDateTime.day,
            settings.closeHour,
            settings.closeMinute,
          )) >=
          0) {
        nextAvaliableHour = false;
      }
      if (nextAvaliableHour &&
          currentServices.isNotEmpty &&
          currentWorker != null) {
        DateTime? nextAvaliableDate =
            appointmentProvider.nextAvaliableHourByDurationAtDate(
                date: dateTimeProvider.currentDateTime,
                duration: currentServices
                    .map<Duration>((service) => service.duration)
                    .reduce(
                      (previousValue, nextValue) => Duration(
                        minutes: previousValue.inMinutes + nextValue.inMinutes,
                      ),
                    ),
                worker: currentWorker,
                paramAppointment: paramAppointment);
        // print(DateFormat("dd/MM/yyyy HH:mm").format(nextAvaliableDate));
        if (nextAvaliableDate != null) {
          hourController.text = DateFormat("HH").format(nextAvaliableDate);
          minuteController.text = DateFormat("mm").format(nextAvaliableDate);
        } else {
          nextAvaliableHour = false;
        }
      } else if (currentDateTime != null) {
        hourController.text = currentDateTime!.hour.toString().padLeft(2, "0");
        minuteController.text =
            currentDateTime!.minute.toString().padLeft(2, "0");
      } else {
        hourController.text = "";
        minuteController.text = "";
        currentDateTime = null;
      }
      List<DateTime> avaliableDatesToAppointments = currentWorker == null ||
              currentServices.isEmpty
          ? []
          : appointmentProvider.avaliableHoursByDurationAtDate(
              date: dateTimeProvider.currentDateTime,
              duration: currentServices
                  .map<Duration>((service) => service.duration)
                  .reduce(
                    (previousValue, nextValue) => Duration(
                      minutes: previousValue.inMinutes + nextValue.inMinutes,
                    ),
                  ),
              worker: currentWorker,
              paramAppointment: paramAppointment);
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (currentServices.isEmpty || currentWorker == null)
            const Text("Por favor preencha as informações anteriores"),
          if (currentServices.isNotEmpty && currentWorker != null)
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              leading: Checkbox(
                  value: nextAvaliableHour,
                  onChanged: (value) {
                    setState(() {
                      nextAvaliableHour = value ?? false;
                    });
                    if (!(value ?? false)) {
                      hourController.text = "";
                    }
                  }),
              title: Text("Próximo horário disponivel"),
            ),
          const SizedBox(
            height: 10,
          ),
          if (currentServices.isNotEmpty && currentWorker != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TypeAheadFormField<String>(
                    onSuggestionSelected: (hour) {
                      hourController.text = hour;
                    },
                    itemBuilder: (ctx, hour) {
                      return Text(
                        hour,
                        textAlign: TextAlign.center,
                      );
                    },
                    suggestionsCallback: (query) {
                      return currentServices.isEmpty
                          ? []
                          : avaliableDatesToAppointments
                              .where(
                                (date) => query.isEmpty
                                    ? true
                                    : DateFormat("HH").format(date).contains(
                                          (int.tryParse(query) ?? -1)
                                              .toString(),
                                        ),
                              )
                              .map<String>(
                                  (date) => DateFormat("HH").format(date))
                              .toSet();
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      enabled: !nextAvaliableHour,
                      controller: hourController,
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
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    validator: (txt) {
                      if (txt == null && !nextAvaliableHour) {
                        return "Campo Vazio!";
                      } else if (txt?.isEmpty ?? false) {
                        return "Campo Vazio!";
                      } else if (currentServices.isEmpty) {
                        return "Selecionar Serviço!";
                      } else if (int.tryParse(txt!) == null) {
                        return "Valor Inválido";
                      } else if (!avaliableDatesToAppointments
                          .map<String>((date) => DateFormat("HH").format(date))
                          .toSet()
                          .contains(txt)) {
                        return "Horario Inválido";
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(":"),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TypeAheadFormField<String>(
                    onSuggestionSelected: (minute) {
                      minuteController.text = minute;
                    },
                    itemBuilder: (ctx, hour) {
                      return Text(
                        hour.toString(),
                        textAlign: TextAlign.center,
                      );
                    },
                    suggestionsCallback: (query) {
                      return avaliableDatesToAppointments.isEmpty
                          ? []
                          : hourController.text.isEmpty
                              ? []
                              : avaliableDatesToAppointments
                          .where((date) =>
                              date.hour == int.parse(hourController.text))
                          .map<String>((date) => DateFormat("mm").format(date))
                          .toSet();
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      enabled: !nextAvaliableHour,
                      controller: minuteController,
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
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                        ),
                      ),
                    ),
                    validator: (txt) {
                      if (txt == null && !nextAvaliableHour) {
                        return "Campo Vazio!";
                      } else if (txt?.isEmpty ?? false) {
                        return "Campo Vazio!";
                      } else if (currentServices.isEmpty) {
                        return "Selecionar Serviço!";
                      } else if (int.tryParse(txt!) == null) {
                        return "Valor Inválido";
                      } else if (!avaliableDatesToAppointments
                          .where((date) =>
                              date.hour == int.parse(hourController.text))
                          .map<String>((date) => DateFormat("mm").format(date))
                          .toSet()
                          .contains(txt)) {
                        return "Horario Inválido";
                      }
                    },
                  ),
                ),
              ],
            ),
        ],
      );
    });
  }

  static Future<dynamic> appointmentDetailsDialog(
      BuildContext context, Appointments appoint) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    return showDialog(
        context: context,
        builder: (ctx) {
          return Consumer<AppointmentProvider>(
            builder: (context, appointmentProvider, _) => AlertDialog(
              titlePadding: EdgeInsets.only(left: 24, top: 3, right: 3),
              title: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Row(
                    children: const [
                      Expanded(
                          child: Center(
                        child: Text(
                          "Agendamento:",
                        ),
                      )),
                      Expanded(
                          child: Center(
                              child: Text(
                        "Serviços:",
                      ))),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppointmentStateSelector(
                        appointment: appoint,
                        elevation: 5,
                        borderColor: Colors.grey,
                        borderWidth: 1,
                        iconColor: Colors.grey[700]!,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Tooltip(
                        message: "Editar",
                        child: InkWell(
                            onTap: () {
                              Dialogs.addAppointmentDialog(
                                  context, appoint, null);
                            },
                            child: const Icon(Icons.edit)),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Tooltip(
                        message: "Deletar",
                        child: InkWell(
                          onTap: () {
                            deleteDialog(
                              context,
                              "Deletar Agendament0?",
                              "Cuidado, ao deletar este agendamento esta operaão nao poderá ser desfeita.\nDeseja mesmo Deletar?",
                            ).then((value) {
                              if (value ?? false) {
                                appointmentProvider.removeObject(appoint);
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }
                            });
                          },
                          child: const Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              content: Container(
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width * 0.5 > 400
                    ? MediaQuery.of(context).size.width * 0.5
                    : 400,
                height: 300,
                child: Column(
                  children: [
                    Divider(
                      height: 0,
                      thickness: 2,
                      color: settingsProvider.objectPrivate
                          .getStateColors()[appoint.situation ?? 0],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.person_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: Text("Cliente"),
                                subtitle: Text(appoint.client.first.name),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.badge_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: Text("Atendente"),
                                subtitle: Text(appoint.worker.first.name),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: Text("Horário"),
                                subtitle: Text(
                                    "${DateFormat("dd/MM/yy").format(appoint.initialDate)} às ${DateFormat("dd/MM/yy").format(appoint.endDate)}"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 200,
                          child: VerticalDivider(
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                        ),
                        Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 200,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...appoint.service.toList().map<Widget>(
                                          (service) => ListTile(
                                            leading: Icon(
                                              Icons.work_outline,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            title: Text(service.name),
                                            // subtitle: Text(
                                            //     "${service.duration.inMinutes ~/ 60}h : ${service.duration.inMinutes % 60}min"),
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                    Expanded(
                        child: TextField(
                      readOnly: true,
                      maxLines: 3,
                      decoration: InputDecoration(
                        label: const Text("Descrião: "),
                        // prefixText: "Descrição: ",
                        // prefixIcon: Icon(Icons.list),
                        contentPadding: const EdgeInsets.only(
                            left: 15, top: 24, right: 15, bottom: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      controller: TextEditingController()
                        ..text = appoint.description ?? "",
                    )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<bool?> deleteDialog(
      BuildContext context, String title, String content) {
    return showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                },
                child: const Text(
                  "Sim",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(false);
                },
                child: const Text(
                  "Não",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        });
  }
}
