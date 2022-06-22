import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey,
        elevation: 5,
        title: Text(
          "Salon Studio",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        actions: [
          TitledIconButton(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
            },
            icon: const Icon(
              Icons.calendar_month,
            ),
            title: "Agenda",
          ),
          TitledIconButton(
            onTap: () {},
            icon: Icon(Icons.person_outline),
            title: "Clientes",
          ),
          TitledIconButton(
            onTap: () {},
            icon: Icon(Icons.storefront),
            title: "Serviços",
          ),
          TitledIconButton(
            onTap: () {},
            icon: Icon(
              Icons.badge_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: "Profissionais",
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          TitledIconButton(
            onTap: () {},
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: "Ajustes",
            textStyle: TextStyle(color: Colors.black),
            invert: true,
            centered: true,
          ),
        ],
      ),
    );
  }
}
