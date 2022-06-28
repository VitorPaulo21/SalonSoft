import 'package:flutter/cupertino.dart';

class DateTimeProvider with ChangeNotifier {
  DateTime _currentDateTime = DateTime.now();

  DateTime get currentDateTime => _currentDateTime;

  set currentDateTime(DateTime date) {
    _currentDateTime = date;
    notifyListeners();
  }
}
