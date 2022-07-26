import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            ListTile(
              leading: profileImageRound(context, profileProvider),
              title: Text(
                profileProvider.objectPrivate.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: profileProvider.objectPrivate.email.isEmpty
                  ? null
                  : Text(profileProvider.objectPrivate.email),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      profileImageRound(context, profileProvider,
                          radius: 100, fontSize: 100),
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

  CircleAvatar profileImageRound(
      BuildContext context, ProfileProvider profileProvider,
      {double radius = 25, double fontSize = 25}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.transparent,
      foregroundImage: profileProvider.objectPrivate.logoPath.isEmpty
          ? null
          : FileImage(File(profileProvider.objectPrivate.logoPath)),
      child: profileProvider.objectPrivate.logoPath.isEmpty &&
              profileProvider.objectPrivate.name.isEmpty
          ? const Icon(
              Icons.person_outline,
              color: Colors.white,
            )
          : Text(
              profileProvider.objectPrivate.name.substring(0, 1),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: fontSize,
                textBaseline: TextBaseline.ideographic,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }
}
