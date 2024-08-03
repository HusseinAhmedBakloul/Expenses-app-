import 'package:flutter/material.dart';

class IncomeModel with ChangeNotifier {
  double _income = 0;

  double get income => _income;

  set income(double value) {
    _income = value;
    notifyListeners(); // Notify listeners when the value changes
  }
}
