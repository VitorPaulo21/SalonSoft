import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/components/profile_image_round.dart';
import 'package:salon_soft/providers/settings_provider.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            SizedBox(
              width: constraints.maxWidth,
              child: ProfileImageRound(
                withText: true,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 28,
                      ),
                      Text(
                        "Conta",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 30),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Form(
                          child: SizedBox(
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 28,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    label: const Text("Email: "),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      label: const Text("Senha: "),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      suffixIcon:
                                          Icon(Icons.remove_red_eye_outlined)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
