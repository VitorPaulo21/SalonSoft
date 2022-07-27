import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/components/profile_image_round.dart';

import '../providers/settings_provider.dart';

class CustomSettingsScreen extends StatefulWidget {
  const CustomSettingsScreen({Key? key}) : super(key: key);

  @override
  State<CustomSettingsScreen> createState() => _CustomSettingsScreenState();
}

class _CustomSettingsScreenState extends State<CustomSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

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
                        "Personalização",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 30),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Form(
                          child: SizedBox(
                            width: 350,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 28,
                                ),
                                Card(
                                  elevation: 5,
                                  child: ListTile(
                                    visualDensity: VisualDensity.compact,
                                    title: Text("Cor Principal"),
                                    trailing: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Card(
                                  elevation: 5,
                                  child: ListTile(
                                    visualDensity: VisualDensity.compact,
                                    title: Text("Cor sobre a principal"),
                                    trailing: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 4)),
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                for (int i = 0;
                                    i <
                                        settingsProvider.objectPrivate
                                            .getStateColors()
                                            .length;
                                    i++)
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Card(
                                        elevation: 5,
                                        child: ListTile(
                                          visualDensity: VisualDensity.compact,
                                          title: Text(
                                              "Cor de agendamento ${i == 0 ? "Pendente" : i == 1 ? "Em Atendimento" : i == 2 ? "Concluído" : i == 3 ? "Cancelado" : "Indisponível"}"),
                                          trailing: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                color: settingsProvider
                                                    .objectPrivate
                                                    .getStateColors()[i],
                                                shape: BoxShape.circle),
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
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
