import 'dart:io' as io;

import 'package:brasil_fields/brasil_fields.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/components/profile_image_round.dart';

import '../models/profile.dart';
import '../providers/profileProvider.dart';
import '../utils/global_paths.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  ProfileProvider? profileProvider;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController cnpjController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController photoPathController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController enderecoController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController estadoController = TextEditingController();

  bool isProfilePhotoHovered = false;
  bool isEditting = false;
  bool isCnpj = true;
  @override
  void initState() {
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    isEditting = !profileProvider!.areAllFieldsFilled();
    photoPathController.text = profileProvider!.objectPrivate.logoPath;
    super.initState();
  }

  void submitForm() async {
    if (formKey.currentState?.validate() ?? false) {
      imageCache.clear();
      if (await io.File(photoPathController.text).exists()) {
        io.File file = io.File(photoPathController.text);
        io.File newFile =
            await file.copy(GlobalPaths.USER_LOGO_IMAGE_PATH + "\\Logo.png");
        photoPathController.text = newFile.path;
      }
      Profile profile = profileProvider!.objectPrivate
        ..bairro = bairroController.text
        ..cidade = cidadeController.text
        ..cnpj = cnpjController.text
        ..cpf = cpfController.text
        ..email = emailController.text
        ..endereco = enderecoController.text
        ..estado = estadoController.text
        ..logoPath = photoPathController.text
        ..name = nameController.text
        ..numero = numeroController.text
        ..phoneNumber = phoneNumberController.text;
      print(profile.name);
      profileProvider?.saveData(profile);
      setState(() {
        isEditting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    if (profileProvider?.areAllFieldsFilled() ?? false) {
      nameController.text = profileProvider!.objectPrivate.name;
      cnpjController.text = profileProvider!.objectPrivate.cnpj;
      cpfController.text = profileProvider!.objectPrivate.cpf;
      emailController.text = profileProvider!.objectPrivate.email;
      enderecoController.text = profileProvider!.objectPrivate.endereco;
      phoneNumberController.text = profileProvider!.objectPrivate.phoneNumber;
      numeroController.text = profileProvider!.objectPrivate.numero;
      bairroController.text = profileProvider!.objectPrivate.bairro;
      cidadeController.text = profileProvider!.objectPrivate.cidade;
      estadoController.text = profileProvider!.objectPrivate.estado;
    } 
    
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            ProfileImageRound(),
            Expanded(
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      MouseRegion(
                        onEnter: isEditting
                            ? (event) {
                                setState(() {
                                  isProfilePhotoHovered = true;
                                });
                              }
                            : null,
                        onExit: isEditting
                            ? (event) {
                                setState(() {
                                  isProfilePhotoHovered = false;
                                });
                              }
                            : null,
                        child: GestureDetector(
                          onTap: isEditting
                              ? () async {
                                  FilePickerResult? result = await FilePicker
                                      .platform
                                      .pickFiles(type: FileType.image);
                                  if (result?.files.first.path?.isNotEmpty ??
                                      false) {
                                    setState(() {
                                      photoPathController.text =
                                          result!.files.first.path!;
                                    });
                                  }
                                }
                              : null,
                          child: JustTheTooltip(
                            offset: 8,
                            preferredDirection: AxisDirection.right,
                            backgroundColor: Colors.black54,
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                !isEditting
                                    ? "Imagem de Perfil"
                                    : photoPathController.text.isEmpty
                                        ? "Adicionar Imagem"
                                        : "Alterar Imagem",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            child: Stack(
                              children: [
                                ProfileImageRound(
                                  radius: 100,
                                  fontSize: 100,
                                  withText: false,
                                  path: photoPathController.text,
                                ),
                                if (isProfilePhotoHovered)
                                  Positioned.fill(
                                      child: Container(
                                    child: const Icon(
                                      Icons.add_a_photo_outlined,
                                      color: Colors.white,
                                      size: 100,
                                    ),
                                    decoration: BoxDecoration(
                                      color: photoPathController.text.isEmpty
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withAlpha(100),
                                      shape: BoxShape.circle,
                                    ),
                                  ))
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: constraints.maxWidth * 0.6 > 600
                            ? 600
                            : constraints.maxWidth * 0.6,
                        child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 25,
                                ),
                                TextFormField(
                                  readOnly: !isEditting,
                                  
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    label: Text("Nome da Empresa: "),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  validator: (txt) {
                                    if (txt == null) {
                                      return "Obrigatório";
                                    } else if (txt.isEmpty) {
                                      return "Obrigatório";
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                TextFormField(
                                    readOnly: !isEditting,

                                    controller: cnpjController,
                                    decoration: InputDecoration(
                                      label: Text("CPF/CNPJ: "),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      CpfOuCnpjFormatter()
                                    ],
                                    validator: (txt) {
                                      if ((txt?.length ?? 0) >
                                          "111.111.111-11".length) {
                                        if (!CNPJValidator.isValid(txt)) {
                                          return "CNPJ Inválido";
                                        }
                                      } else {
                                        if (!CPFValidator.isValid(txt)) {
                                          return "CPF Inválido";
                                        }
                                      }
                                    }),
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: TextFormField(
                                        readOnly: !isEditting,
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          label: Text("Email: "),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        validator: (txt) {
                                          if (txt == null) {
                                            return "Obrigatório";
                                          } else if (txt.isEmpty) {
                                            return "Obrigatório";
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: TextFormField(
                                        readOnly: !isEditting,
                                        controller: phoneNumberController,
                                        decoration: InputDecoration(
                                          label: Text("Telefone: "),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        validator: (txt) {
                                          if (txt == null) {
                                            return "Obrigatório";
                                          } else if (txt.isEmpty) {
                                            return "Obrigatório";
                                          } else if (txt.length <
                                              "(37) 3231-1123".length) {
                                            return "Número Inválido";
                                          }
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          TelefoneInputFormatter(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: TextFormField(
                                        readOnly: !isEditting,
                                        controller: enderecoController,
                                        decoration: InputDecoration(
                                          label: Text("Endereço: "),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        validator: (txt) {
                                          if (txt == null) {
                                            return "Obrigatório";
                                          } else if (txt.isEmpty) {
                                            return "Obrigatório";
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: TextFormField(
                                        readOnly: !isEditting,
                                        controller: numeroController,
                                        decoration: InputDecoration(
                                          label: Text("Número: "),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        validator: (txt) {
                                          if (txt == null) {
                                            return "Obrigatório";
                                          } else if (txt.isEmpty) {
                                            return "Obrigatório";
                                          }
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                TextFormField(
                                  readOnly: !isEditting,
                                  controller: bairroController,
                                  decoration: InputDecoration(
                                    label: Text("Bairro: "),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  validator: (txt) {
                                    if (txt == null) {
                                      return "Obrigatório";
                                    } else if (txt.isEmpty) {
                                      return "Obrigatório";
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 5,
                                      child: TextFormField(
                                        readOnly: !isEditting,
                                        controller: cidadeController,
                                        decoration: InputDecoration(
                                          label: Text("Cidade: "),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        validator: (txt) {
                                          if (txt == null) {
                                            return "Obrigatório";
                                          } else if (txt.isEmpty) {
                                            return "Obrigatório";
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: TextFormField(
                                        readOnly: !isEditting,
                                        controller: estadoController,
                                        style: TextStyle(),
                                        decoration: InputDecoration(
                                          label: Text("UF: "),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        validator: (txt) {
                                          if (txt == null) {
                                            return "Obrigatório";
                                          } else if (txt.isEmpty) {
                                            return "Obrigatório";
                                          } else if (txt.length < 2) {
                                            return "UF Inválida";
                                          }
                                        },
                                        textAlign: TextAlign.center,
                                        inputFormatters: [
                                          UpperCaseTextFormatter(),
                                          FilteringTextInputFormatter.deny(
                                              RegExp("[0-9]")),
                                          LengthLimitingTextInputFormatter(2)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: constraints.maxWidth * 0.6 > 600
                  ? 600
                  : constraints.maxWidth * 0.6,
              child: ElevatedButton(
                onPressed: !isEditting
                    ? () {
                        setState(() {
                          isEditting = true;
                        });
                      }
                    : submitForm,
                child: Text(!isEditting ? "Editar" : "Salvar"),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
