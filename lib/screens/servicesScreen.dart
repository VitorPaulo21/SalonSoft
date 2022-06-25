import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                      showDialog<Service>(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text("Adicionar Serviço"),
                              content: Form(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                        label: Text("Nome: "),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        errorBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextFormField()
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {}, child: Text("Adicionar")),
                                TextButton(
                                    onPressed: () {}, child: Text("Cancelar")),
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

  String getTimeHoursByMinutes(int minutes) {
    int hours = minutes ~/ 60;
    int minutesdif = minutes % 60;
    return "${hours.toString().padLeft(2, "0")} : ${minutesdif.toString().padLeft(2, "0")}";
  }
}
