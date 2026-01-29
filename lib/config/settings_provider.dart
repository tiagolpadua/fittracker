import 'package:flutter/material.dart';

/// Provider para configurações globais do aplicativo
class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _showCompletedExercises = true;
  String _measurementUnit = 'kg';

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;
  bool get showCompletedExercises => _showCompletedExercises;
  String get measurementUnit => _measurementUnit;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleShowCompleted() {
    _showCompletedExercises = !_showCompletedExercises;
    notifyListeners();
  }

  void setMeasurementUnit(String unit) {
    _measurementUnit = unit;
    notifyListeners();
  }
}
