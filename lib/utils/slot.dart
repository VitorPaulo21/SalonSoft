import '../models/time.dart';

class Slot {
  static int calc(TimeSlot timeSlot) {
    switch (timeSlot) {
      case TimeSlot.oclock:
        return 1;

      case TimeSlot.thirteen:
        return 2;

      case TimeSlot.fifteen:
        return 4;

      default:
        return 1;
    }
  }
}
