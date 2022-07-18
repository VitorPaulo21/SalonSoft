import 'package:flutter/cupertino.dart';
import 'package:salon_soft/models/appointments.dart';

class KeysProvider with ChangeNotifier {
  Map<Appointments, GlobalKey> keys = {};
}
