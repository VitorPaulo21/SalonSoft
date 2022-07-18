import 'package:flutter/cupertino.dart';

class DateTimeProvider with ChangeNotifier {
  late DateTime _currentDateTime;
  DateTimeProvider() {
    _currentDateTime = DateTime.now();
  }
  DateTime get currentDateTime {
    DateTime now = DateTime.now();
    if (_currentDateTime.year != now.year ||
        _currentDateTime.month != now.month ||
        _currentDateTime.day != now.day) {
          
      return DateTime(
          _currentDateTime.year, _currentDateTime.month, _currentDateTime.day);
    } else {
      return DateTime(
        _currentDateTime.year,
        _currentDateTime.month,
        _currentDateTime.day,
        now.hour,
        now.minute,
      );
    }
  }

  set currentDateTime(DateTime date) {
    DateTime now = DateTime.now();
    if (date.year != now.year ||
        date.month != now.month ||
        date.day != now.day) {
      _currentDateTime = date;
    } else {
      _currentDateTime =
          DateTime(date.year, date.month, date.day, now.hour, now.minute);
    }
    notifyListeners();
  }
}
