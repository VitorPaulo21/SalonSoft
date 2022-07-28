import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/models/appointment.dart';
import 'package:salon_soft/models/worker.dart';
import 'package:salon_soft/providers/appointment_provider.dart';
import 'package:salon_soft/providers/date_time_provider.dart';
import 'package:salon_soft/providers/settings_provider.dart';
import 'package:salon_soft/providers/worker_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salon_soft/utils/global_paths.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../components/circular_percentage_chart.dart';
import '../components/titled_icon_button.dart';
import '../components/worker_rounded_photo.dart';
import '../models/appointments.dart';
import '../utils/routes.dart';

class ProfessionalsScreen extends StatefulWidget {
  const ProfessionalsScreen({Key? key}) : super(key: key);

  @override
  State<ProfessionalsScreen> createState() => _ProfessionalsScreenState();
}

class _ProfessionalsScreenState extends State<ProfessionalsScreen> {
  @override
  Widget build(BuildContext context) {
    WorkerProvider workerProvider = Provider.of<WorkerProvider>(context);
    DateTimeProvider dateTimeProvider = Provider.of<DateTimeProvider>(context);

    return GridView(
      padding: const EdgeInsets.all(10.0),
      shrinkWrap: true,
      semanticChildCount: workerProvider.objects.length + 1,
      controller: ScrollController(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisExtent: 450,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      children: [
        addWorkerGridItem(context),
        ...workerProvider.objects.map<Widget>((worker) {
          return Card(
            elevation: 5,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Stack(
              children: [
                WorkerGridItem(worker, context),
                if (!worker.isActive!)
                  Positioned.fill(
                      child: Container(
                    color: Colors.grey.withAlpha(130),
                  )),
                Positioned.fill(
                  child: MaterialButton(
                    onPressed: () {
                      workerInfoDialog(context, worker);
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: worker.isActive!,
                      onChanged: (value) {
                        workerProvider.saveData(worker..isActive = value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Stack addWorkerGridItem(BuildContext context) {
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
            addWorkerDialog(context);
          },
          // splashColor: Colors.pink,
          // highlightColor: Colors.pink,
          child: Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  addWorkerDialog(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.badge_outlined),
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

  Container WorkerGridItem(Worker worker, BuildContext context) {
    File file = File(worker.photoPath);
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
            .where((appointment) => appointment.worker.first == worker)
            .toList());
    if (todayAppointmentsInMinutes == 0) {
      todayAppointmentsInMinutes = 1;
      todayClientAppointmentsInMinutes = 0;
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 12,
              top: 8,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),
                Icon(
                  Icons.settings,
                  size: 18,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
          WorkerRoundedPhoto(
            file: file,
            worker: worker,
          ),
          Container(
            alignment: Alignment.center,
            height: 30,
            child: Text(
              worker.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
              child: CircularPercentageChart(
            allValue: todayAppointmentsInMinutes,
            percentageValue: todayClientAppointmentsInMinutes,
            allvalueLegend: "Total de Atendimentos",
            percentualValueLegend: "Este Proficional",
          ))
        ],
      ),
    );
  }

  Future<void> addWorkerDialog(BuildContext context) async {
    WorkerProvider workerProvider = Provider.of(context, listen: false);
    showDialog<Worker>(
        context: context,
        builder: (ctx) {
          TextEditingController nameController = TextEditingController();
          String photoPath = "";
          File? imageProfile;
          GlobalKey<FormState> formKey = GlobalKey<FormState>();
          bool submitForm() {
            return formKey.currentState?.validate() ?? false;
          }

          return StatefulBuilder(builder: (ctx, state) {
            return AlertDialog(
              title: Text("Adicionar Trabalhador"),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(type: FileType.image);
                        if (result?.files.first.path?.isNotEmpty ?? false) {
                          state(() {
                            photoPath = result!.files.first.path!;
                            imageProfile = File(photoPath);
                          });
                        }
                      },
                      child: CircleAvatar(
                        maxRadius: 50,
                        backgroundColor: imageProfile == null
                            ? Colors.grey[300]
                            : Colors.transparent,
                        foregroundImage: imageProfile != null
                            ? FileImage(imageProfile!)
                            : null,
                        child: imageProfile == null
                            ? const Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.grey,
                                size: 30,
                              )
                            : null,
                      ),
                    ),
                    TextFormField(
                      controller: nameController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        label: Text("Nome: "),
                      ),
                      validator: (txt) {
                        if (txt?.isEmpty ?? false) {
                          return "Nome não pode estar vazio!";
                        }
                      },
                      onFieldSubmitted: (txt) async {
                        if (submitForm()) {
                          await callAddWorker(
                              imageProfile, nameController, photoPath, context);
                        }
                      },
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      // workerProvider.removeAllWorkers();
                      if (submitForm()) {
                        await callAddWorker(
                            imageProfile, nameController, photoPath, context);
                      }
                    },
                    child: Text("Adicionar")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(null);
                    },
                    child: Text("Cancelar")),
              ],
            );
          });
        }).then((worker) {
      if (worker != null) {
        workerProvider.addObject(worker);
      }
    });
  }

  Future<void> callAddWorker(
      File? imageProfile,
      TextEditingController nameController,
      String photoPath,
      BuildContext context) async {
    String newPath = "";
    if (imageProfile != null) {
      Directory directory = Directory(Platform.resolvedExecutable
              .substring(0, Platform.resolvedExecutable.lastIndexOf("\\")) +
          "\\UserImages");
      Directory finalDirectory = Directory("${directory.path}\\ProfileImages");
      if (!(await finalDirectory.exists())) {
        await finalDirectory.create(recursive: true);
      }
      newPath =
          "${finalDirectory.path}\\${(nameController.text).replaceAll(RegExp(r"\s\b|\b\s"), "")}${(BigInt.from(await finalDirectory.list().length) + BigInt.one).toString()}${imageProfile.path.substring(imageProfile.path.lastIndexOf("."), imageProfile.path.length)}";

      File(photoPath).copy(newPath);
    }
    Navigator.of(context, rootNavigator: true).pop(Worker(
        name: nameController.text, photoPath: newPath.isEmpty ? "" : newPath));
  }

  Future<void> workerInfoDialog(BuildContext context, Worker worker) async {
    WorkerProvider workerProvider = Provider.of(context, listen: false);
    showDialog<Worker>(
        context: context,
        builder: (ctx) {
          TextEditingController nameController = TextEditingController();
          String photoPath = worker.photoPath;
          File? imageProfile = File(photoPath);
          GlobalKey<FormState> formKey = GlobalKey<FormState>();
          bool isActive = worker.isActive!;
          nameController.text = worker.name;
          bool submitForm() {
            return formKey.currentState?.validate() ?? false;
          }

          return StatefulBuilder(builder: (ctx, state) {
            return AlertDialog(
              titlePadding: EdgeInsets.only(top: 0, left: 20, right: 3),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Alterar Informações"),
                  IconButton(
                      onPressed: () {
                        removeWorkerDialog(context, worker);
                      },
                      icon: const Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                      ))
                ],
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(type: FileType.image);
                        if (result?.files.first.path?.isNotEmpty ?? false) {
                          state(() {
                            photoPath = result!.files.first.path!;
                            imageProfile = File(photoPath);
                          });
                        }
                      },
                      child: CircleAvatar(
                        maxRadius: 50,
                        backgroundColor:
                            imageProfile == null ? Colors.grey[300] : null,
                        foregroundImage: imageProfile != null
                            ? FileImage(imageProfile!)
                            : null,
                        child: imageProfile == null
                            ? const Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.grey,
                                size: 30,
                              )
                            : null,
                      ),
                    ),
                    TextFormField(
                      controller: nameController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        label: Text("Nome: "),
                      ),
                      validator: (txt) {
                        if (txt?.isEmpty ?? false) {
                          return "Nome não pode estar vazio!";
                        }
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Ativo"),
                    Switch(
                        value: isActive,
                        onChanged: (value) {
                          state(() {
                            isActive = value;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () async {
                          // workerProvider.removeAllWorkers();
                          if (submitForm()) {
                            String newPath = "";
                            if (imageProfile != null) {
                              if (worker.photoPath.isEmpty) {
                                
                                Directory finalDirectory = Directory(
                                    GlobalPaths.USER_PROFILE_IMAGE_DIRECTORY);
                                if (!(await finalDirectory.exists())) {
                                  await finalDirectory.create(recursive: true);
                                }
                                newPath =
                                    "${finalDirectory.path}\\${(nameController.text).replaceAll(RegExp(r"\s\b|\b\s"), "")}${(BigInt.from(await finalDirectory.list().length) + BigInt.one).toString()}${imageProfile!.path.substring(imageProfile!.path.lastIndexOf("."), imageProfile!.path.length)}";
                              } else {
                                newPath = worker.photoPath;
                              }

                              File(photoPath).copy(newPath);
                            }
                            worker.name = nameController.text;
                            worker.photoPath = newPath.isEmpty ? "" : newPath;
                            worker.isActive = isActive;
                            Navigator.of(context, rootNavigator: true)
                                .pop(worker);
                          }
                        },
                        child: Text("Salvar")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop(null);
                        },
                        child: Text("Cancelar")),
                  ],
                ),
              ],
            );
          });
        }).then((worker) {
      if (worker != null) {
        setState(() {
          imageCache.clear();
          imageCache.clearLiveImages();
          workerProvider.saveData(worker);
        });
      }
    });
  }

  void removeWorkerDialog(BuildContext context, Worker worker) {
    showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Remover Profissional"),
            content:
                const Text("Deseja remover permanentemente este Profissional?"),
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
        showDialog<bool>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text("Cuidado"),
                content: const Text(
                    "Ao deletar este profissional, todos os agendamentos relacionados a ele serão apagados da memória.\nNão será possivel desfazer."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      child: const Text("Deletar")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(false);
                      },
                      child: const Text("Cancelar"))
                ],
              );
            }).then((value) {
          if (value ?? false) {
                
        Provider.of<WorkerProvider>(context, listen: false)
            .removeObject(worker);
          }
          Navigator.of(context, rootNavigator: true).pop();
          
        });
      }
    });
  }
}


