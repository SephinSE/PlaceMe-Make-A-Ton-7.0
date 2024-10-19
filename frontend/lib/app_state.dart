import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplicationState extends ChangeNotifier {
  String? errorMessage = '';

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void onNavBarTap(index) {
    _selectedIndex = index;
    notifyListeners();
  }
}