import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  bool isDarkModeOn = false;

  void toggletheme() {
    isDarkModeOn = !isDarkModeOn;
    notifyListeners();
  }
}
