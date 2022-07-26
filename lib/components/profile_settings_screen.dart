import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/components/profile_image_round.dart';
import 'package:salon_soft/models/profile.dart';
import 'package:salon_soft/providers/profileProvider.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController cnpjController = TextEditingController();
  bool isCnpj = true;
  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    if (profileProvider.objectPrivate.name.isNotEmpty) {
      nameController.text = profileProvider.objectPrivate.name;
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
                      ProfileImageRound(
                        radius: 100,
                        fontSize: 100,
                        withText: false,
                      ),
                      Container(
                        width: constraints.maxWidth * 0.6 > 600
                            ? 600
                            : constraints.maxWidth * 0.6,
                        child: Form(
                            child: Column(
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            TextFormField(
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
                                  if (txt?.length == 19) {
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
                                    decoration: InputDecoration(
                                      label: Text("Email: "),
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
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      label: Text("Telefone: "),
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
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
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
                                    decoration: InputDecoration(
                                      label: Text("Endereço: "),
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
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      label: Text("Número: "),
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
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            TextFormField(
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
                                    decoration: InputDecoration(
                                      label: Text("Cidade: "),
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
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    style: TextStyle(),
                                    decoration: InputDecoration(
                                      label: Text("UF: "),
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
