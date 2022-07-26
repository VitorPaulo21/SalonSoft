import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:salon_soft/components/profile_image_round.dart';

class SettingsComponentScreen extends StatefulWidget {
  const SettingsComponentScreen({Key? key}) : super(key: key);

  @override
  State<SettingsComponentScreen> createState() =>
      _SettingsComponentScreenState();
}

class _SettingsComponentScreenState extends State<SettingsComponentScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            SizedBox(
              width: constraints.maxWidth,
              child: ListTile(
                leading: ProfileImageRound(
                  withText: true,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
