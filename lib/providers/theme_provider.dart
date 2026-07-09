import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setLightTheme() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  void setDarkTheme() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  void toggleTheme() {
    if (isDarkMode) {
      setLightTheme();
    } else {
      setDarkTheme();
    }
  }
}
