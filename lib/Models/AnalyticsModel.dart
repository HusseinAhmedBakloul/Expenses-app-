// models/AnalyticsModel.dart
import 'package:flutter/material.dart';

class AnalyticsModel extends ChangeNotifier {
  double _totalExpenses = 0;

  double get totalExpenses => _totalExpenses;

  set totalExpenses(double value) {
    _totalExpenses = value;
    notifyListeners();
  }
}
