import 'package:flutter/material.dart';
import 'package:salon_soft/models/appointments.dart';
import '../models/time.dart';

class Appointment{
  final String title;
  final String subtitle;
  final Time start;
  final Time end;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final VoidCallback onTap;
  final BoxDecoration decoration;
  final Color color;
  final TextStyle textStyle;
  final TextStyle subtitleStyle;
  Appointments appointments;


  Appointment(
    this.appointments, {
    required this.title,
    this.subtitle = "",
    required this.start,
    required this.end,
    this.padding = const EdgeInsets.all(10),
    this.margin = const EdgeInsets.all(0),
    required this.onTap,
    this.decoration = const BoxDecoration(),
    this.color = const Color(0xFF323D6C),
    this.textStyle = const TextStyle(
        color: Color(0xFF535353), fontSize: 11, fontWeight: FontWeight.w400),
    this.subtitleStyle =
        const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF363636)),
   
  });
}
