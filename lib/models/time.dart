class Time {
  final int hour;
  final int min;
  const Time(this.hour, this.min) : assert(hour < 24 && min < 60);

  String refactor(int times, int add) {
    
    switch (times) {
      case 1:
        return stringify(hour + add) + ":" + stringify(min);
      case 2:
        return stringify(hour + add) + ":" + stringify(min + 15);
      case 3:
        return stringify(hour + add) + ":" + stringify(min + 30);
      case 4:
        return stringify(hour + add) + ":" + stringify(min + 45);
      default:
        return "";
    }
  }

  String stringify(int number) => number < 10 ? "0$number" : number.toString();
}

enum TimeSlot { fifteen, thirteen, oclock }
