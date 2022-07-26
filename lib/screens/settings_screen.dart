import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:salon_soft/components/settings_Settings_screen.dart';

import '../components/profile_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(236, 236, 240, 1),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 5 < 280
                  ? 280
                  : MediaQuery.of(context).size.width / 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReturnTitleBar(),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ListTile(
                          title: Text(
                            "AJUSTES",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          minLeadingWidth: 20,
                          selected: selectedIndex == 0,
                          leading: Icon(Icons.person_outline),
                          title: Text("Perfil"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90)),
                          selectedTileColor: Colors.white,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          onTap: () {
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          minLeadingWidth: 20,
                          selected: selectedIndex == 1,
                          leading: Icon(Icons.settings_outlined),
                          title: Text("Configurações"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90)),
                          selectedTileColor: Colors.white,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          onTap: () {
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          minLeadingWidth: 20,
                          selected: selectedIndex == 2,
                          leading: Icon(Icons.manage_accounts_outlined),
                          title: Text("Conta"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90)),
                          selectedTileColor: Colors.white,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          onTap: () {
                            setState(() {
                              selectedIndex = 2;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          minLeadingWidth: 20,
                          selected: selectedIndex == 3,
                          leading: Icon(Icons.dashboard_customize_outlined),
                          title: Text("Personalização"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90)),
                          selectedTileColor: Colors.white,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          onTap: () {
                            setState(() {
                              selectedIndex = 3;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(child: LayoutBuilder(
              builder: (context, constraints) {
                return Card(
                  margin: EdgeInsets.all(0),
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30)),
                  ),
                  child: Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: selectedIndex == 0
                        ? ProfileSettingsScreen()
                        : SettingsComponentScreen(),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}



class ReturnTitleBar extends StatelessWidget {
  const ReturnTitleBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
          splashRadius: 25,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios)),
      title: Text(
        "Salon Studio",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
