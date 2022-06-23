import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/models/worker.dart';
import 'package:salon_soft/providers/worker_provider.dart';
import 'package:path_provider/path_provider.dart';

import '../components/titled_icon_button.dart';
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
    return GridView(
      padding: const EdgeInsets.all(10.0),
      shrinkWrap: true,
      semanticChildCount: workerProvider.workers.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        childAspectRatio: 3 / 4,
        mainAxisSpacing: 10,
      ),
      children: [
        ...workerProvider.workers
            .map<Widget>((worker) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        foregroundImage: FileImage(File(worker.photoPath)),
                        radius: 60,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(worker.name)
                    ],
                  ),
                ))
            .toList(),
        Stack(alignment: Alignment.bottomCenter, children: [
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
        ])
      ],
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
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      // workerProvider.removeAllWorkers();
                      if (submitForm()) {
                        String newPath = "";
                        if (imageProfile != null) {
                          Directory directory =
                              await getApplicationDocumentsDirectory();
                          Directory finalDirectory = Directory(
                              "${directory.path}\\SalonSoft\\ProfileImages");
                          if (!(await finalDirectory.exists())) {
                            await finalDirectory.create(recursive: true);
                          }
                          newPath =
                              "${finalDirectory.path}\\${(nameController.text).replaceAll(RegExp(r"\s\b|\b\s"), "")}${(BigInt.from(await finalDirectory.list().length) + BigInt.one).toString()}${imageProfile!.path.substring(imageProfile!.path.lastIndexOf("."), imageProfile!.path.length)}";

                          File(photoPath).copy(newPath);
                        }
                        Navigator.of(context, rootNavigator: true).pop(Worker(
                            name: nameController.text,
                            photoPath: newPath.isEmpty ? "" : newPath));
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
        workerProvider.addWorker(worker);
      }
    });
  }
}
