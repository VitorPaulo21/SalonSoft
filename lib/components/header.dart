import 'dart:io';

import 'package:flutter/material.dart';
import 'package:salon_soft/components/dialogs.dart';
import 'package:salon_soft/components/worker_rounded_photo.dart';
import 'package:salon_soft/models/worker.dart';
import '../models/header.dart';

class HeaderComponent extends StatelessWidget {
  final Header header;

  final double width;
  final double height;
  final Color borderColor;
  final Color backgroundColor;
  final Worker worker;

  const HeaderComponent({
    Key? key,
    required this.header,
    required this.height,
    required this.width,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFF353433),
    required this.worker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      width: width,
      height: height,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        elevation: 5,
        child: ListTile(
          leading: WorkerRoundedPhoto(
            file: File(worker.photoPath),
            worker: worker,
            size: 35,
            borderWidth: 2,
          ),
          title: Text(header.title),
          trailing: InkWell(
            onTap: () {
              Dialogs.addAppointmentDialog(context, null, worker);
            },
            child: Tooltip(
              message: "Adicionar Agendamento",
              child: Icon(Icons.playlist_add_rounded),
            ),
          ),
        ),
      ),
    );
  }
}
