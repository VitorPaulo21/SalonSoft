import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/models/service.dart';
import 'package:salon_soft/providers/services_provider.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<Service> services = [];
  @override
  Widget build(BuildContext context) {
    services = Provider.of<ServicesProvider>(context).services;
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
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 5,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Container(
                    width: constrains.maxWidth / 3,
                    height: 300,
                  ),
                ),
                SizedBox(
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
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
          suffix: IconButton(
              onPressed: () {},
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
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            TextEditingController nameController =
                                TextEditingController();
                            TextEditingController hourController =
                                TextEditingController();
                            TextEditingController minController =
                                TextEditingController();
                            GlobalKey<FormState> formKey =
                                GlobalKey<FormState>();

                            void submitForm() {
                              bool isvalid =
                                  formKey.currentState?.validate() ?? false;
                              if (isvalid) {
                                Provider.of<ServicesProvider>(context,
                                        listen: false)
                                    .addservice(
                                  Service(
                                    name: nameController.text,
                                    duration: Duration(
                                      hours: int.parse(hourController.text),
                                      minutes: int.parse(minController.text),
                                    ),
                                  ),
                                );
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }
                            }

                            return AlertDialog(
                              title: Text("Adicionar Serviço"),
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
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                          errorBorder:
                                              RoundInputBorder(Colors.red)),
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
                                              LengthLimitingTextInputFormatter(
                                                  2),
                                            ],
                                            textInputAction:
                                                TextInputAction.next,
                                            textAlign: TextAlign.center,
                                            controller: hourController,
                                            decoration: InputDecoration(
                                              suffixText: "Hs",
                                              label: Text("Horas:"),
                                              border: RoundInputBorder(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                              errorBorder:
                                                  RoundInputBorder(Colors.red),
                                            ),
                                            // onFieldSubmitted: (txt) =>
                                            //     submitForm(),
                                            validator: (txt) {
                                              if (txt == null) {
                                                return "Campo Vazio!";
                                              } else if (txt.isEmpty) {
                                                return "Campo Vazio!";
                                              } else if (int.tryParse(txt) ==
                                                  null) {
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
                                              LengthLimitingTextInputFormatter(
                                                  2),
                                            ],
                                            textInputAction:
                                                TextInputAction.done,
                                            onFieldSubmitted: (txt) =>
                                                submitForm(),
                                            textAlign: TextAlign.center,
                                            controller: minController,
                                            decoration: InputDecoration(
                                              suffixText: "min",
                                              label: Text("Mins:"),
                                              border: RoundInputBorder(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                              errorBorder:
                                                  RoundInputBorder(Colors.red),
                                            ),
                                            
                                            validator: (txt) {
                                              if (txt == null) {
                                                return "Campo Vazio!";
                                              } else if (txt.isEmpty) {
                                                return "Campo Vazio!";
                                              } else if (int.tryParse(txt) ==
                                                  null) {
                                                return "Valor Inválido";
                                              } else if (int.parse(txt) == 0 &&
                                                  (int.tryParse(hourController
                                                              .text) ??
                                                          0) <=
                                                      0) {
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
                                    child: const Text("Adicionar")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child: const Text("Cancelar")),
                              ],
                            );
                          });
                    },
                    child: const Text("Adicionar Serviço")),
              ),
              const ListTile(
                leading: Icon(Icons.list),
                title: Text("Serviço"),
                trailing: Text("Duração"),
              ),
              Expanded(
                child: ListView.builder(
                    controller: ScrollController(),
                    itemCount: services.length,
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        leading: const Icon(Icons.work_outline),
                        title: Text(services[index].name),
                        trailing: Text(getTimeHoursByMinutes(
                            services[index].duration.inMinutes)),
                        key: UniqueKey(),
                      );
                    }),
              ),
            ],
          )),
    );
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
}
