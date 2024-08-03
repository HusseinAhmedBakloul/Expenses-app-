import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountModel with ChangeNotifier {
  String _name = '';
  String _email = '';
  String _password = '';
  String _phone = '';
  String _imagePath = '';

  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get phone => _phone;
  String get imagePath => _imagePath;

  AccountModel() {
    _loadAccountData(); // Load account data from SharedPreferences when the model is created
  }

  Future<void> _loadAccountData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? '';
    _email = prefs.getString('email') ?? '';
    _password = prefs.getString('password') ?? '';
    _phone = prefs.getString('phone') ?? '';
    _imagePath = prefs.getString('imagePath') ?? '';
    notifyListeners(); // Notify listeners that the initial data has been loaded
  }

  Future<void> updateAccount({
    String? name,
    String? email,
    String? password,
    String? phone,
    String? address,
    String? imagePath,
  }) async {
    if (name != null) _name = name;
    if (email != null) _email = email;
    if (password != null) _password = password;
    if (phone != null) _phone = phone;
    if (imagePath != null) _imagePath = imagePath;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _name);
    await prefs.setString('email', _email);
    await prefs.setString('password', _password);
    await prefs.setString('phone', _phone);
    await prefs.setString('imagePath', _imagePath);

    notifyListeners();
  }

  Future<void> clearAccountData() async {
    _name = '';
    _email = '';
    _password = '';
    _phone = '';
    _imagePath = '';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('phone');
    await prefs.remove('imagePath');

    notifyListeners();
  }
}
