import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;
  bool isCustomMode = false;

  void toggleTheme() {
    if (isDarkMode) {
      isDarkMode = false;
      isCustomMode = true;
    } else if (isCustomMode) {
      isCustomMode = false;
    } else {
      isDarkMode = true;
    }
    notifyListeners();
  }
}
