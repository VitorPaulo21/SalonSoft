import '../models/appointment.dart';
import '../models/header.dart';

class Line {
  /// Pillar object helps link the resource with his appointments.
  /// [head] employee/resource.
  final Header header;

  /// [events] (appointments/Todos) linked to the head.
  final List<Appointment> appointments;

  Line({
    required this.header,
    required this.appointments,
  });
}
