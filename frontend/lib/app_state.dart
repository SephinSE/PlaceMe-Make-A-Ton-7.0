import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplicationState extends ChangeNotifier {
  String? errorMessage = '';

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void onNavBarTap(index) {
    _selectedIndex = index;
    notifyListeners();
  }
}