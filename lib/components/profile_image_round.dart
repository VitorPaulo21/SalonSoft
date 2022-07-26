import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profileProvider.dart';

class ProfileImageRound extends StatefulWidget {
  double radius;
  double fontSize;
  bool withText;

  ProfileImageRound({
    Key? key,
    this.radius = 25,
    this.fontSize = 25,
    this.withText = true,
  }) : super(key: key);

  @override
  State<ProfileImageRound> createState() => _ProfileImageRoundState();
}

class _ProfileImageRoundState extends State<ProfileImageRound> {
  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    return widget.withText
        ? ListTile(
            leading: CircleAvatar(
              radius: widget.radius,
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
                        fontSize: widget.fontSize,
                        textBaseline: TextBaseline.ideographic,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
            title: Text(
              profileProvider.objectPrivate.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: profileProvider.objectPrivate.email.isEmpty
                ? null
                : Text(profileProvider.objectPrivate.email))
        : CircleAvatar(
            radius: widget.radius,
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
                      fontSize: widget.fontSize,
                      textBaseline: TextBaseline.ideographic,
                    ),
                    textAlign: TextAlign.center,
                  ),
          );
  }
}
